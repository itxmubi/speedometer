package com.example.speedometer

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.widget.RemoteViews

/** Passive widget: tapping opens the app and never starts GPS collection. */
class SpeedWidget : AppWidgetProvider() {
    override fun onUpdate(context: Context, manager: AppWidgetManager, ids: IntArray) {
        ids.forEach { update(context, manager, it) }
    }

    companion object {
        fun updateAll(context: Context) {
            val manager = AppWidgetManager.getInstance(context)
            manager.getAppWidgetIds(ComponentName(context, SpeedWidget::class.java)).forEach { update(context, manager, it) }
        }

        private fun update(context: Context, manager: AppWidgetManager, id: Int) {
            val display = DeviceBridge.display
            val active = TrackingService.active
            val views = RemoteViews(context.packageName, R.layout.speed_widget)
            views.setTextViewText(R.id.widget_speed, if (active) "${display.speedText()} ${display.unit}" else "—")
            views.setTextViewText(R.id.widget_status, if (active) display.statusText(context) else context.getString(R.string.tracking_idle))
            views.setTextColor(R.id.widget_speed, if (active && display.overLimit) Color.rgb(255, 120, 120) else Color.WHITE)
            val open = PendingIntent.getActivity(context, id, Intent(context, MainActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_SINGLE_TOP or Intent.FLAG_ACTIVITY_CLEAR_TOP
            }, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
            views.setOnClickPendingIntent(R.id.widget_root, open)
            manager.updateAppWidget(id, views)
        }
    }
}
