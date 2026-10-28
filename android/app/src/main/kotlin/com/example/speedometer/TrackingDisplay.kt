package com.example.speedometer

import android.content.Context
import java.text.NumberFormat

/** Already-filtered presentation from Dart; no coordinates are stored here. */
data class TrackingDisplay(
    val speed: Double? = null,
    val unit: String = "",
    val overLimit: Boolean = false,
    val status: String = "",
    val title: String = "",
    val stopLabel: String = "",
) {
    /** Sub-unit Doppler jitter need not redraw a whole-number native surface. */
    fun rendersSameAs(other: TrackingDisplay): Boolean =
        speedText() == other.speedText() && unit == other.unit &&
            overLimit == other.overLimit && status == other.status &&
            title == other.title && stopLabel == other.stopLabel

    fun speedText(): String = speed?.let {
        NumberFormat.getNumberInstance().apply { maximumFractionDigits = 0 }.format(it)
    } ?: "—"

    fun statusText(context: Context): String = status.ifBlank {
        context.getString(if (TrackingService.active) R.string.tracking_waiting else R.string.tracking_idle)
    }
}
