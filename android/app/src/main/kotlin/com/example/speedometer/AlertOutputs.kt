package com.example.speedometer

import android.content.Context
import android.media.AudioAttributes
import android.media.AudioManager
import android.media.ToneGenerator
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.os.VibrationEffect
import android.os.Vibrator
import android.os.VibratorManager
import android.speech.tts.TextToSpeech
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.Locale

/** Platform execution only; Dart decides alert thresholds/cooldown/hysteresis. */
class AlertOutputs(private val context: Context) {
    private val handler = Handler(Looper.getMainLooper())
    private val tones = mutableSetOf<ToneGenerator>()
    private var speech: TextToSpeech? = null
    private var speechReady = false
    private var pending: (() -> Unit)? = null
    private var pendingFailure: (() -> Unit)? = null

    fun emit(call: MethodCall, result: MethodChannel.Result) {
        val volume = (call.argument<Number>("volume")?.toDouble() ?: 1.0).let {
            if (it.isFinite()) it.coerceIn(0.0, 1.0) else 0.0
        }
        var unavailable = false
        if (call.argument<Boolean>("sound") == true && volume > 0) {
            // No audio-focus request: navigation and music remain audible.
            val tone = ToneGenerator(AudioManager.STREAM_MUSIC, (volume * 100).toInt())
            tones.add(tone)
            unavailable = !tone.startTone(ToneGenerator.TONE_PROP_BEEP2, 250)
            handler.postDelayed({ tone.release(); tones.remove(tone) }, 400)
        }
        if (call.argument<Boolean>("vibration") == true) {
            @Suppress("DEPRECATION")
            val vibrator = if (Build.VERSION.SDK_INT >= 31) context.getSystemService(VibratorManager::class.java).defaultVibrator
                else context.getSystemService(Vibrator::class.java)
            if (!vibrator.hasVibrator()) unavailable = true
            else if (Build.VERSION.SDK_INT >= 26) vibrator.vibrate(VibrationEffect.createOneShot(250, VibrationEffect.DEFAULT_AMPLITUDE))
            else vibrator.vibrate(250)
        }
        if (call.argument<Boolean>("voice") != true || volume == 0.0) {
            if (unavailable) result.error("unsupported", null, null) else result.success(null)
            return
        }
        val message = call.argument<String>("message").orEmpty().take(1000)
        val locale = Locale.forLanguageTag(call.argument<String>("languageTag") ?: Locale.getDefault().toLanguageTag())
        val otherUnavailable = unavailable
        val speak = {
            try {
                val tts = speech
                // Never download voice data or use a network-backed TTS voice.
                val voice = tts?.voices?.firstOrNull {
                    !it.isNetworkConnectionRequired && !it.features.contains(TextToSpeech.Engine.KEY_FEATURE_NOT_INSTALLED) &&
                        it.locale.language == locale.language && it.locale.country == locale.country
                } ?: tts?.voices?.firstOrNull {
                    !it.isNetworkConnectionRequired && !it.features.contains(TextToSpeech.Engine.KEY_FEATURE_NOT_INSTALLED) &&
                        it.locale.language == locale.language
                }
                if (tts == null || voice == null || message.isBlank()) result.error("unsupported", null, null)
                else {
                    tts.voice = voice
                    val parameters = Bundle().apply { putFloat(TextToSpeech.Engine.KEY_PARAM_VOLUME, volume.toFloat()) }
                    val outcome = tts.speak(message, TextToSpeech.QUEUE_FLUSH, parameters, "speed-limit")
                    if (outcome == TextToSpeech.ERROR || otherUnavailable) result.error("unsupported", null, null)
                    else result.success(null)
                }
            } catch (_: RuntimeException) {
                result.error("unsupported", null, null)
            }
        }
        if (speechReady) speak()
        else {
            pendingFailure?.invoke()
            pending = speak
            pendingFailure = { result.error("unsupported", null, null) }
            if (speech == null) {
                speech = TextToSpeech(context) { status ->
                    handler.post {
                        speechReady = status == TextToSpeech.SUCCESS
                        speech?.setAudioAttributes(AudioAttributes.Builder()
                            .setUsage(AudioAttributes.USAGE_ASSISTANCE_SONIFICATION)
                            .setContentType(AudioAttributes.CONTENT_TYPE_SPEECH).build())
                        val action = if (speechReady) pending else pendingFailure
                        pending = null
                        pendingFailure = null
                        action?.invoke()
                    }
                }
                // Broken or absent engines must not leave a method call pending.
                handler.postDelayed({
                    if (!speechReady) {
                        pendingFailure?.invoke()
                        pending = null
                        pendingFailure = null
                        speech?.shutdown()
                        speech = null
                    }
                }, 5000)
            }
        }
    }

    fun stopActive() {
        handler.removeCallbacksAndMessages(null)
        tones.forEach { it.release() }
        tones.clear()
        pendingFailure?.invoke()
        pending = null
        pendingFailure = null
        try { speech?.stop(); speech?.shutdown() }
        catch (_: RuntimeException) { android.util.Log.w("Speedometer", "offline_speech_shutdown_failed") }
        speech = null
        speechReady = false
    }

    fun dispose() {
        stopActive()
    }
}
