package com.example.speedometer

import android.content.Context
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

/** Retained Dart engine continues processing GPS/database writes while hidden. */
class MainActivity : FlutterActivity() {
    override fun provideFlutterEngine(context: Context): FlutterEngine = SpeedometerEngine.obtain(context)
    override fun shouldDestroyEngineWithHost(): Boolean = false

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        DeviceBridge.attach(this)
    }

    override fun onResume() {
        super.onResume()
        DeviceBridge.resumed(this)
    }

    override fun onPause() {
        DeviceBridge.paused(this)
        super.onPause()
    }

    override fun onDestroy() {
        DeviceBridge.detach(this)
        super.onDestroy()
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        DeviceBridge.permissionResult(requestCode)
    }
}
