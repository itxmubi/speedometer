package com.example.speedometer

import android.content.Context
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor

/** One process-local engine, never a second headless isolate/database writer. */
object SpeedometerEngine {
    private var engine: FlutterEngine? = null

    fun obtain(context: Context): FlutterEngine {
        engine?.let { return it }
        val created = FlutterEngine(context.applicationContext)
        engine = created
        DeviceBridge.initialize(context.applicationContext, created.dartExecutor.binaryMessenger)
        created.dartExecutor.executeDartEntrypoint(DartExecutor.DartEntrypoint.createDefault())
        return created
    }
}
