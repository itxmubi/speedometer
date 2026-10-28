package com.example.speedometer

import android.Manifest
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.content.pm.ServiceInfo
import android.graphics.Color
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Paint
import android.graphics.Typeface
import android.graphics.drawable.Icon
import android.location.Location
import android.location.LocationListener
import android.location.LocationManager
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.os.SystemClock

/** Explicitly started GPS-only FGS. Never restarted by boot, widget or Android. */
class TrackingService : Service(), LocationListener {
    private lateinit var locations: LocationManager
    private lateinit var overlay: SpeedOverlay
    private val handler = Handler(Looper.getMainLooper())
    private var lastFixNanos = Long.MIN_VALUE
    private val staleCheck = Runnable {
        if (active) DeviceBridge.markStale()
    }

    private fun armStaleCheck() {
        // One deadline per healthy fix; no once-a-second polling during GPS loss.
        handler.removeCallbacks(staleCheck)
        handler.postDelayed(staleCheck, STALE_MILLIS)
    }

    override fun onCreate() {
        super.onCreate()
        instance = this
        locations = getSystemService(LocationManager::class.java)
        overlay = SpeedOverlay(this)
        if (Build.VERSION.SDK_INT >= 26) {
            getSystemService(NotificationManager::class.java).createNotificationChannel(
                NotificationChannel(CHANNEL, getString(R.string.tracking_channel), NotificationManager.IMPORTANCE_LOW).apply {
                    description = getString(R.string.tracking_channel_description)
                    setSound(null, null)
                    enableVibration(false)
                    setShowBadge(false)
                },
            )
        }
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        if (intent?.action == ACTION_STOP || !requested) {
            requested = false
            finishStart("cancelled")
            stopSelf()
            return START_NOT_STICKY
        }
        if (active) { finishStart(null); return START_NOT_STICKY }
        try {
            if (checkSelfPermission(Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
                finishStart("permission_denied")
                stopSelf()
                return START_NOT_STICKY
            }
            if (!locations.isProviderEnabled(LocationManager.GPS_PROVIDER)) {
                finishStart("location_disabled")
                stopSelf()
                return START_NOT_STICKY
            }
            if (Build.VERSION.SDK_INT >= 29) startForeground(NOTIFICATION_ID, notification(), ServiceInfo.FOREGROUND_SERVICE_TYPE_LOCATION)
            else startForeground(NOTIFICATION_ID, notification())
            active = true
            requestLocations()
            DeviceBridge.trackingChanged(true)
            armStaleCheck()
            finishStart(null)
        } catch (_: SecurityException) {
            finishStart("permission_denied")
            DeviceBridge.locationError("permission_denied")
            stopSelf()
        } catch (_: RuntimeException) {
            finishStart("location_unavailable")
            DeviceBridge.locationError("location_unavailable")
            stopSelf()
        }
        return START_NOT_STICKY
    }

    @Suppress("MissingPermission")
    private fun requestLocations() {
        // GPS_PROVIDER speed is receiver Doppler speed. Never infer speed from
        // successive coordinates; distance filtering would hide stationary fixes.
        locations.requestLocationUpdates(LocationManager.GPS_PROVIDER, intervalMillis, 0f, this, Looper.getMainLooper())
    }

    override fun onLocationChanged(location: Location) {
        if (!active) return
        // Receiver wall time can differ from the phone clock. Reject cached and
        // reordered deliveries using Android's monotonic fix clock first.
        val ageNanos = SystemClock.elapsedRealtimeNanos() - location.elapsedRealtimeNanos
        if (ageNanos !in 0..MAX_FIX_AGE_NANOS || location.elapsedRealtimeNanos <= lastFixNanos) return
        lastFixNanos = location.elapsedRealtimeNanos
        val hasSpeedAccuracy = Build.VERSION.SDK_INT >= 26 && location.hasSpeedAccuracy()
        val speedAccuracy = if (hasSpeedAccuracy) location.speedAccuracyMetersPerSecond.toDouble() else -1.0
        val healthy = location.hasSpeed() && location.speed.isFinite() && location.speed >= 0 && location.speed <= 150 &&
            location.hasAccuracy() && location.accuracy.isFinite() && location.accuracy <= 25 && location.accuracy >= 0 &&
            (!hasSpeedAccuracy || speedAccuracy.isFinite() && speedAccuracy >= 0 && speedAccuracy <= 3) &&
            location.latitude.isFinite() && location.latitude in -90.0..90.0 &&
            location.longitude.isFinite() && location.longitude in -180.0..180.0
        if (healthy) armStaleCheck()
        else DeviceBridge.markStale()
        DeviceBridge.location(mapOf(
            "latitude" to location.latitude,
            "longitude" to location.longitude,
            "timestamp" to location.time,
            "speed" to location.speed.toDouble(),
            "accuracy" to location.accuracy.toDouble(),
            "altitude" to location.altitude,
            "heading" to location.bearing.toDouble(),
            "speedAccuracy" to speedAccuracy,
            "altitudeAccuracy" to if (Build.VERSION.SDK_INT >= 26 && location.hasVerticalAccuracy()) location.verticalAccuracyMeters.toDouble() else -1.0,
            "headingAccuracy" to if (Build.VERSION.SDK_INT >= 26 && location.hasBearingAccuracy()) location.bearingAccuracyDegrees.toDouble() else -1.0,
            "hasSpeed" to location.hasSpeed(),
            "hasAccuracy" to location.hasAccuracy(),
            "hasAltitude" to location.hasAltitude(),
            "hasHeading" to location.hasBearing(),
            "hasSpeedAccuracy" to hasSpeedAccuracy,
            "isMocked" to if (Build.VERSION.SDK_INT >= 31) location.isMock else location.isFromMockProvider,
        ))
    }

    override fun onProviderDisabled(provider: String) {
        if (provider == LocationManager.GPS_PROVIDER) {
            DeviceBridge.locationError("location_disabled")
            requested = false
            stopSelf()
        }
    }
    override fun onProviderEnabled(provider: String) = Unit
    @Deprecated("Legacy Android callback")
    override fun onStatusChanged(provider: String?, status: Int, extras: Bundle?) = Unit

    private fun refreshDisplay() {
        if (!active) return
        getSystemService(NotificationManager::class.java).notify(NOTIFICATION_ID, notification())
        overlay.update(DeviceBridge.display)
    }

    private fun notification(): Notification {
        val display = DeviceBridge.display
        val launch = PendingIntent.getActivity(this, 0, Intent(this, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_SINGLE_TOP or Intent.FLAG_ACTIVITY_CLEAR_TOP
        }, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
        val stop = PendingIntent.getService(this, 1, Intent(this, TrackingService::class.java).setAction(ACTION_STOP),
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
        val builder = if (Build.VERSION.SDK_INT >= 26) Notification.Builder(this, CHANNEL) else Notification.Builder(this)
        return builder
            .setSmallIcon(speedIcon(display))
            .setContentTitle(display.title.ifBlank { getString(R.string.app_name) })
            .setContentText("${display.speedText()} ${display.unit} · ${display.statusText(this)}")
            .setContentIntent(launch)
            .setOngoing(true)
            .setOnlyAlertOnce(true)
            .setShowWhen(false)
            .setCategory(Notification.CATEGORY_SERVICE)
            .setVisibility(Notification.VISIBILITY_PUBLIC)
            .setColor(if (display.overLimit) Color.RED else Color.rgb(0, 150, 136))
            .addAction(Notification.Action.Builder(null, display.stopLabel.ifBlank { getString(R.string.tracking_stop) }, stop).build())
            .build()
    }

    private fun speedIcon(display: TrackingDisplay): Icon {
        if (display.speed == null) return Icon.createWithResource(this, R.drawable.ic_speed_notification)
        val size = (24 * resources.displayMetrics.density).toInt().coerceAtLeast(24)
        val bitmap = Bitmap.createBitmap(size, size, Bitmap.Config.ARGB_8888)
        val canvas = Canvas(bitmap)
        val label = display.speedText()
        val paint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
            color = Color.WHITE
            typeface = Typeface.DEFAULT_BOLD
            textAlign = Paint.Align.CENTER
            textSize = size * if (label.length > 2) 0.63f else 0.8f
        }
        canvas.drawText(label, size / 2f, size / 2f - (paint.ascent() + paint.descent()) / 2f, paint)
        return Icon.createWithBitmap(bitmap)
    }

    override fun onTaskRemoved(rootIntent: Intent?) {
        // Swiping the task is a deliberate end to tracking. Dart recovers the
        // checkpoint as paused on next launch, never silently starts GPS again.
        requested = false
        stopSelf()
        super.onTaskRemoved(rootIntent)
    }

    override fun onDestroy() {
        handler.removeCallbacksAndMessages(null)
        locations.removeUpdates(this)
        overlay.dispose()
        active = false
        requested = false
        instance = null
        finishStart("cancelled")
        DeviceBridge.trackingChanged(false)
        SpeedWidget.updateAll(this)
        stopForeground(STOP_FOREGROUND_REMOVE)
        finishStops()
        super.onDestroy()
    }

    override fun onBind(intent: Intent?): IBinder? = null

    companion object {
        private const val CHANNEL = "speedometer_tracking"
        private const val NOTIFICATION_ID = 1001
        private const val ACTION_STOP = "com.example.speedometer.STOP"
        private const val STALE_MILLIS = 10_000L
        private const val MAX_FIX_AGE_NANOS = 5_000_000_000L
        private var instance: TrackingService? = null
        private var requested = false
        private var completion: ((String?) -> Unit)? = null
        private val stopCompletions = mutableListOf<() -> Unit>()
        private var intervalMillis = 1000L
        var active = false
            private set

        fun start(context: Context, callback: (String?) -> Unit) {
            if (active) { callback(null); return }
            if (requested) { callback("busy"); return }
            requested = true
            completion = callback
            try {
                val intent = Intent(context, TrackingService::class.java)
                if (Build.VERSION.SDK_INT >= 26) context.startForegroundService(intent) else context.startService(intent)
            } catch (_: SecurityException) {
                requested = false
                finishStart("permission_denied")
            } catch (_: RuntimeException) {
                requested = false
                finishStart("location_unavailable")
            }
        }

        fun stop(context: Context, callback: () -> Unit = {}) {
            requested = false
            finishStart("cancelled")
            if (instance == null) {
                context.stopService(Intent(context, TrackingService::class.java))
                callback()
            } else {
                stopCompletions.add(callback)
                context.stopService(Intent(context, TrackingService::class.java))
            }
        }
        fun refresh() { instance?.refreshDisplay() }
        fun setOverlayEnabled(enabled: Boolean) { instance?.overlay?.setEnabled(enabled) }
        fun setInterval(milliseconds: Long) {
            val next = milliseconds.coerceIn(1000L, 3000L)
            if (next == intervalMillis) return
            intervalMillis = next
            instance?.takeIf { active }?.let { service ->
                try {
                    service.locations.removeUpdates(service)
                    service.requestLocations()
                }
                catch (_: SecurityException) {
                    DeviceBridge.locationError("permission_denied")
                    service.stopSelf()
                } catch (_: RuntimeException) {
                    DeviceBridge.locationError("location_unavailable")
                    service.stopSelf()
                }
            }
        }
        private fun finishStart(error: String?) {
            val callback = completion
            completion = null
            callback?.invoke(error)
        }
        private fun finishStops() {
            val callbacks = stopCompletions.toList()
            stopCompletions.clear()
            callbacks.forEach { it() }
        }
    }
}
