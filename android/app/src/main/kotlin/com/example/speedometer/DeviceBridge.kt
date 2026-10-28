package com.example.speedometer

import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.provider.Settings
import android.view.WindowManager
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.lang.ref.WeakReference

/** Owns channels only; feature decisions, thresholds and persistence stay in Dart. */
object DeviceBridge : MethodChannel.MethodCallHandler {
    private const val NOTIFICATION_REQUEST = 7024
    private lateinit var context: Context
    private var activity = WeakReference<Activity>(null)
    private var foreground = false
    private var locationSink: EventChannel.EventSink? = null
    private var trackingSink: EventChannel.EventSink? = null
    private var pendingStart: MethodChannel.Result? = null
    private var notificationRequestOutstanding = false
    private lateinit var compass: CompassController
    private lateinit var alerts: AlertOutputs
    var display = TrackingDisplay()
        private set

    fun initialize(context: Context, messenger: BinaryMessenger) {
        this.context = context
        compass = CompassController(context) { activity.get() }
        alerts = AlertOutputs(context)
        MethodChannel(messenger, "speedometer/device").setMethodCallHandler(this)
        EventChannel(messenger, "speedometer/location").setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink) { locationSink = events }
            override fun onCancel(arguments: Any?) { locationSink = null }
        })
        EventChannel(messenger, "speedometer/tracking").setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                trackingSink = events
                events.success(TrackingService.active)
            }
            override fun onCancel(arguments: Any?) { trackingSink = null }
        })
        EventChannel(messenger, "speedometer/compass").setStreamHandler(compass)
    }

    fun attach(value: Activity) { activity = WeakReference(value) }
    fun resumed(value: Activity) {
        attach(value)
        foreground = true
        compass.setVisible(true)
        if (pendingStart != null && !notificationRequestOutstanding) launchTracking()
    }
    fun paused(value: Activity) {
        if (activity.get() === value) {
            foreground = false
            compass.setVisible(false)
        }
    }
    fun detach(value: Activity) {
        if (activity.get() === value) {
            resetDisplay()
            activity.clear()
            foreground = false
            compass.setVisible(false)
            if (!value.isChangingConfigurations) {
                pendingStart?.error("permission_denied", null, null)
                pendingStart = null
                notificationRequestOutstanding = false
            }
        }
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        try {
            when (call.method) {
                "applyDisplay" -> {
                    val host = activity.get()
                    if (host == null) result.error("unsupported", null, null)
                    else {
                        val awake = call.argument<Boolean>("keepAwake") == true
                        if (awake) host.window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
                        else host.window.clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
                        val requested = call.argument<Number>("brightness")?.toFloat() ?: -1f
                        val attributes = host.window.attributes
                        attributes.screenBrightness = if (requested < 0 || !requested.isFinite()) -1f else requested.coerceIn(0.05f, 1f)
                        host.window.attributes = attributes
                        result.success(null)
                    }
                }
                "emitAlert" -> alerts.emit(call, result)
                "updateTrackingDisplay" -> {
                    val speed = call.argument<Number>("displaySpeed")?.toDouble()
                    val hasSpeed = call.argument<Number>("speedMetersPerSecond") != null
                    val next = TrackingDisplay(
                        speed = speed?.takeIf { TrackingService.active && hasSpeed && it.isFinite() && it >= 0 },
                        unit = call.argument<String>("unit").orEmpty().take(24),
                        overLimit = TrackingService.active && call.argument<Boolean>("overLimit") == true,
                        status = call.argument<String>("status").orEmpty().take(160),
                        title = call.argument<String>("notificationTitle").orEmpty().take(160),
                        stopLabel = call.argument<String>("stopLabel").orEmpty().take(80),
                    )
                    val changed = !display.rendersSameAs(next)
                    display = next
                    if (changed) {
                        TrackingService.refresh()
                        SpeedWidget.updateAll(context)
                    }
                    result.success(null)
                }
                "isTracking" -> result.success(TrackingService.active)
                "setGpsInterval" -> {
                    TrackingService.setInterval(call.argument<Number>("milliseconds")?.toLong() ?: 1000L)
                    result.success(null)
                }
                "startTracking" -> startTracking(result)
                "stopTracking" -> {
                    pendingStart?.error("cancelled", null, null)
                    pendingStart = null
                    resetDisplay()
                    TrackingService.stop(context) { result.success(null) }
                }
                "canDrawOverlays" -> result.success(Settings.canDrawOverlays(context))
                "requestOverlayPermission" -> {
                    val host = activity.get()
                    if (host == null || !foreground) result.error("permission_denied", null, null)
                    else {
                        host.startActivity(Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION, Uri.parse("package:${context.packageName}")))
                        result.success(null)
                    }
                }
                "setOverlayEnabled" -> {
                    val enabled = call.argument<Boolean>("enabled") == true
                    if (enabled && !Settings.canDrawOverlays(context)) result.error("overlay_permission", null, null)
                    else if (enabled && !TrackingService.active) result.error("location_unavailable", null, null)
                    else {
                        TrackingService.setOverlayEnabled(enabled)
                        result.success(null)
                    }
                }
                "dispose" -> {
                    resetDisplay()
                    compass.dispose()
                    alerts.dispose()
                    TrackingService.stop(context) { result.success(null) }
                }
                else -> result.notImplemented()
            }
        } catch (_: SecurityException) {
            result.error("permission_denied", null, null)
        } catch (_: RuntimeException) {
            // Raw exception messages may contain user data. Return only stable codes.
            result.error("unavailable", null, null)
        }
    }

    private fun startTracking(result: MethodChannel.Result) {
        val host = activity.get()
        if (host == null || !foreground) { result.error("permission_denied", null, null); return }
        if (context.checkSelfPermission(Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            result.error("permission_denied", null, null)
            return
        }
        if (TrackingService.active) { result.success(null); return }
        if (pendingStart != null) { result.error("busy", null, null); return }
        pendingStart = result
        if (Build.VERSION.SDK_INT >= 33 &&
            host.checkSelfPermission(Manifest.permission.POST_NOTIFICATIONS) != PackageManager.PERMISSION_GRANTED &&
            !context.getSharedPreferences("platform", Context.MODE_PRIVATE).getBoolean("notificationAsked", false)
        ) {
            context.getSharedPreferences("platform", Context.MODE_PRIVATE).edit().putBoolean("notificationAsked", true).apply()
            notificationRequestOutstanding = true
            host.requestPermissions(arrayOf(Manifest.permission.POST_NOTIFICATIONS), NOTIFICATION_REQUEST)
        } else launchTracking()
    }

    fun permissionResult(requestCode: Int) {
        // Denied notification permission does not forbid a user-started FGS.
        if (requestCode == NOTIFICATION_REQUEST) {
            notificationRequestOutstanding = false
            if (pendingStart != null && foreground) launchTracking()
        }
    }

    private fun launchTracking() {
        val completion = pendingStart ?: return
        pendingStart = null
        if (!foreground) { completion.error("permission_denied", null, null); return }
        TrackingService.start(context) { error ->
            if (error == null) completion.success(null)
            else completion.error(error, null, null)
        }
    }

    fun location(fix: Map<String, Any>) { locationSink?.success(fix) }
    fun locationError(code: String) { locationSink?.error(code, null, null) }
    fun trackingChanged(active: Boolean) {
        // A stale notification Stop intent may launch this service without an engine.
        if (!::context.isInitialized) return
        if (!active) {
            resetDisplay()
            alerts.stopActive()
            display = display.copy(speed = null, overLimit = false, status = context.getString(R.string.tracking_idle))
        }
        trackingSink?.success(active)
        SpeedWidget.updateAll(context)
    }

    fun markStale() {
        val next = display.copy(speed = null, overLimit = false, status = context.getString(R.string.tracking_waiting))
        if (display.rendersSameAs(next)) return
        display = next
        TrackingService.refresh()
        SpeedWidget.updateAll(context)
    }

    private fun resetDisplay() {
        activity.get()?.window?.let { window ->
            window.clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
            window.attributes = window.attributes.apply { screenBrightness = -1f }
        }
    }
}
