package com.khlebobul.minimo_video

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Intent
import android.os.Build
import android.os.IBinder
import android.os.PowerManager

/** Keeps the existing sequential cache copy alive while the activity is hidden. */
class VideoImportService : Service() {
    companion object { @Volatile var expiredToken: Long? = null }
    private var token = -1L
    private var wakeLock: PowerManager.WakeLock? = null

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val id = intent?.getLongExtra("token", -1) ?: -1
        if (intent?.action == "start") {
            token = id
            if (Build.VERSION.SDK_INT >= 26) {
                getSystemService(NotificationManager::class.java).createNotificationChannel(
                    NotificationChannel("video_import", "Video import", NotificationManager.IMPORTANCE_LOW)
                )
            }
            startForeground(4208, notification(0, 0))
            wakeLock?.let { if (it.isHeld) it.release() }
            wakeLock = (getSystemService(POWER_SERVICE) as PowerManager)
                .newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "minimo:import").apply {
                    acquire(6 * 60 * 60 * 1000L)
                }
        } else if (id == token) {
            when (intent?.action) {
                "update" -> getSystemService(NotificationManager::class.java).notify(
                    4208, notification(intent.getIntExtra("processed", 0), intent.getIntExtra("total", 0))
                )
                "finish" -> stopSelf()
                "cancel" -> { expiredToken = token; stopSelf() }
            }
        }
        return START_NOT_STICKY
    }

    private fun notification(processed: Int, total: Int): Notification {
        val builder = if (Build.VERSION.SDK_INT >= 26) Notification.Builder(this, "video_import")
            else @Suppress("DEPRECATION") Notification.Builder(this)
        val open = PendingIntent.getActivity(this, 0, Intent(this, MainActivity::class.java),
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
        val cancel = PendingIntent.getService(this, 0,
            Intent(this, VideoImportService::class.java).setAction("cancel").putExtra("token", token),
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
        return builder.addAction(Notification.Action.Builder(null,
            getString(android.R.string.cancel), cancel).build()).setSmallIcon(android.R.drawable.stat_sys_download)
            .setContentTitle("minimo")
            .setContentText(if (total > 0) "$processed / $total" else "…")
            .setContentIntent(open).setOngoing(true).setOnlyAlertOnce(true)
            .setProgress(total, processed, total == 0).build()
    }

    override fun onTimeout(startId: Int, fgsType: Int) {
        expiredToken = token
        stopSelf()
    }

    override fun onDestroy() {
        wakeLock?.let { if (it.isHeld) it.release() }
        wakeLock = null
        stopForeground(STOP_FOREGROUND_REMOVE)
        super.onDestroy()
    }
}
