package com.example.speedometer

import android.app.Activity
import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.view.Surface
import io.flutter.plugin.common.EventChannel

/** Magnetic compass, orientation adjusted and throttled to 5 Hz. */
class CompassController(context: Context, private val activity: () -> Activity?) : EventChannel.StreamHandler, SensorEventListener {
    private val manager = context.getSystemService(SensorManager::class.java)
    private val sensor = manager.getDefaultSensor(Sensor.TYPE_ROTATION_VECTOR)
    private var sink: EventChannel.EventSink? = null
    private var visible = false
    private var lastTimestamp = 0L
    private val matrix = FloatArray(9)
    private val adjusted = FloatArray(9)
    private val orientation = FloatArray(3)

    override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
        sink = events
        if (sensor == null) events.error("unsupported", null, null) else register()
    }
    override fun onCancel(arguments: Any?) { sink = null; manager.unregisterListener(this) }
    fun setVisible(value: Boolean) { visible = value; register() }
    private fun register() {
        manager.unregisterListener(this)
        val device = sensor ?: return
        if (visible && sink != null && !manager.registerListener(this, device, SensorManager.SENSOR_DELAY_UI)) {
            sink?.error("unsupported", null, null)
        }
    }
    override fun onSensorChanged(event: SensorEvent) {
        if (event.timestamp - lastTimestamp < 200_000_000L) return
        lastTimestamp = event.timestamp
        if (event.accuracy == SensorManager.SENSOR_STATUS_UNRELIABLE) {
            // An unreliable sample is recoverable; keep the event stream open.
            sink?.success(null)
            return
        }
        SensorManager.getRotationMatrixFromVector(matrix, event.values)
        @Suppress("DEPRECATION")
        val rotation = activity()?.windowManager?.defaultDisplay?.rotation ?: Surface.ROTATION_0
        val axes = when (rotation) {
            Surface.ROTATION_90 -> SensorManager.AXIS_Y to SensorManager.AXIS_MINUS_X
            Surface.ROTATION_180 -> SensorManager.AXIS_MINUS_X to SensorManager.AXIS_MINUS_Y
            Surface.ROTATION_270 -> SensorManager.AXIS_MINUS_Y to SensorManager.AXIS_X
            else -> SensorManager.AXIS_X to SensorManager.AXIS_Y
        }
        SensorManager.remapCoordinateSystem(matrix, axes.first, axes.second, adjusted)
        SensorManager.getOrientation(adjusted, orientation)
        sink?.success((Math.toDegrees(orientation[0].toDouble()) + 360.0) % 360.0)
    }
    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) = Unit
    fun dispose() { manager.unregisterListener(this); sink = null }
}
