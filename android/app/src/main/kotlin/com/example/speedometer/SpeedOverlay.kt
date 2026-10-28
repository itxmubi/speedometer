package com.example.speedometer

import android.content.Context
import android.graphics.Color
import android.graphics.PixelFormat
import android.graphics.Typeface
import android.graphics.drawable.GradientDrawable
import android.os.Build
import android.provider.Settings
import android.view.Gravity
import android.view.MotionEvent
import android.view.View
import android.view.WindowManager
import android.widget.LinearLayout
import android.widget.TextView

/** A draggable, resizable window created only after explicit user enablement. */
class SpeedOverlay(private val context: Context) {
    private val windows = context.getSystemService(WindowManager::class.java)
    private var root: LinearLayout? = null
    private var speed: TextView? = null
    private var params: WindowManager.LayoutParams? = null
    private var enabled = false

    fun setEnabled(value: Boolean) {
        enabled = value
        if (value && TrackingService.active && Settings.canDrawOverlays(context)) {
            if (root == null) show()
            update(DeviceBridge.display)
        } else remove()
    }

    private fun show() {
        val view = LinearLayout(context).apply {
            orientation = LinearLayout.VERTICAL
            setPadding(dp(8), dp(4), dp(8), dp(4))
            importantForAccessibility = View.IMPORTANT_FOR_ACCESSIBILITY_YES
        }
        val number = TextView(context).apply {
            gravity = Gravity.CENTER
            textSize = 32f
            setTypeface(typeface, Typeface.BOLD)
            setTextColor(Color.WHITE)
        }
        view.addView(number, LinearLayout.LayoutParams(-1, 0, 1f))
        val controls = LinearLayout(context).apply { orientation = LinearLayout.HORIZONTAL }
        val close = TextView(context).apply {
            text = "×"
            textSize = 26f
            gravity = Gravity.CENTER
            setTextColor(Color.WHITE)
            contentDescription = context.getString(R.string.overlay_close)
            setOnClickListener { setEnabled(false) }
        }
        controls.addView(close, LinearLayout.LayoutParams(0, dp(48), 1f))
        val resize = TextView(context).apply {
            text = "↔"
            textSize = 26f
            gravity = Gravity.CENTER
            setTextColor(Color.WHITE)
            contentDescription = context.getString(R.string.overlay_resize)
        }
        controls.addView(resize, LinearLayout.LayoutParams(0, dp(48), 1f))
        view.addView(controls)
        val layout = WindowManager.LayoutParams(
            dp(200), dp(152),
            if (Build.VERSION.SDK_INT >= 26) WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY else WindowManager.LayoutParams.TYPE_PHONE,
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL,
            PixelFormat.TRANSLUCENT,
        ).apply { gravity = Gravity.TOP or Gravity.START; x = dp(12); y = dp(100) }
        root = view
        speed = number
        params = layout
        gesture(number, resizing = false)
        gesture(resize, resizing = true)
        try { windows.addView(view, layout) }
        catch (_: RuntimeException) {
            android.util.Log.w("Speedometer", "overlay_window_unavailable")
            root = null; speed = null; params = null; enabled = false
        }
    }

    private fun gesture(view: View, resizing: Boolean) {
        var downX = 0f
        var downY = 0f
        var startX = 0
        var startY = 0
        view.setOnTouchListener { target, event ->
            val layout = params ?: return@setOnTouchListener false
            when (event.actionMasked) {
                MotionEvent.ACTION_DOWN -> {
                    downX = event.rawX
                    downY = event.rawY
                    startX = if (resizing) layout.width else layout.x
                    startY = if (resizing) layout.height else layout.y
                    true
                }
                MotionEvent.ACTION_MOVE -> {
                    val deltaX = (event.rawX - downX).toInt()
                    val deltaY = (event.rawY - downY).toInt()
                    val metrics = context.resources.displayMetrics
                    if (resizing) {
                        layout.width = (startX + deltaX).coerceIn(dp(144), minOf(dp(400), metrics.widthPixels))
                        layout.height = (startY + deltaY).coerceIn(dp(128), minOf(dp(320), metrics.heightPixels))
                        speed?.textSize = (layout.width / metrics.density / 6).coerceIn(24f, 60f)
                    } else {
                        layout.x = (startX + deltaX).coerceIn(0, (metrics.widthPixels - layout.width).coerceAtLeast(0))
                        layout.y = (startY + deltaY).coerceIn(0, (metrics.heightPixels - layout.height).coerceAtLeast(0))
                    }
                    root?.let { windows.updateViewLayout(it, layout) }
                    true
                }
                MotionEvent.ACTION_UP -> { target.performClick(); true }
                else -> false
            }
        }
    }

    fun update(display: TrackingDisplay) {
        if (!enabled) return
        if (!Settings.canDrawOverlays(context)) { dispose(); return }
        root?.background = GradientDrawable().apply {
            setColor(if (display.overLimit) Color.rgb(170, 0, 0) else Color.rgb(12, 18, 20))
            cornerRadius = dp(20).toFloat()
            setStroke(dp(2), if (display.overLimit) Color.YELLOW else Color.WHITE)
        }
        speed?.text = "${display.speedText()} ${display.unit}"
        speed?.contentDescription = "${display.speedText()} ${display.unit}, ${display.statusText(context)}"
    }

    private fun remove() {
        root?.let {
            try { windows.removeView(it) }
            catch (_: IllegalArgumentException) { android.util.Log.w("Speedometer", "overlay_window_already_removed") }
        }
        root = null
        speed = null
        params = null
    }
    fun dispose() { enabled = false; remove() }
    private fun dp(value: Int): Int = (value * context.resources.displayMetrics.density).toInt()
}
