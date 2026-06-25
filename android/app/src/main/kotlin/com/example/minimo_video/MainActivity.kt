package com.example.minimo_video

import android.content.Context
import android.content.Intent
import android.database.Cursor
import android.net.Uri
import android.os.Build
import android.os.PowerManager
import android.provider.OpenableColumns
import java.io.File
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private var pendingPickResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "minimo_video/thermal"
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "currentState" -> result.success(currentThermalState())
                else -> result.notImplemented()
            }
        }
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "minimo_video/videos"
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "pickVideos" -> pickVideos(result)
                else -> result.notImplemented()
            }
        }
    }

    @Deprecated("Deprecated in Java")
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode != PICK_VIDEOS_REQUEST) return

        val result = pendingPickResult ?: return
        pendingPickResult = null
        if (resultCode != RESULT_OK || data == null) {
            result.success(emptyList<Map<String, Any>>())
            return
        }

        try {
            result.success(readPickedVideos(data))
        } catch (error: Exception) {
            result.error("pick_failed", error.message, null)
        }
    }

    private fun currentThermalState(): String {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q) return "unknown"
        val powerManager = getSystemService(Context.POWER_SERVICE) as PowerManager
        return when (powerManager.currentThermalStatus) {
            PowerManager.THERMAL_STATUS_NONE -> "nominal"
            PowerManager.THERMAL_STATUS_LIGHT -> "fair"
            PowerManager.THERMAL_STATUS_MODERATE -> "fair"
            PowerManager.THERMAL_STATUS_SEVERE -> "serious"
            PowerManager.THERMAL_STATUS_CRITICAL -> "critical"
            PowerManager.THERMAL_STATUS_EMERGENCY -> "critical"
            PowerManager.THERMAL_STATUS_SHUTDOWN -> "critical"
            else -> "unknown"
        }
    }

    private fun pickVideos(result: MethodChannel.Result) {
        if (pendingPickResult != null) {
            result.error("pick_in_progress", "video picker is already open", null)
            return
        }

        pendingPickResult = result
        val intent = Intent(Intent.ACTION_OPEN_DOCUMENT).apply {
            addCategory(Intent.CATEGORY_OPENABLE)
            type = "video/*"
            putExtra(Intent.EXTRA_ALLOW_MULTIPLE, true)
            addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
        }
        startActivityForResult(intent, PICK_VIDEOS_REQUEST)
    }

    private fun readPickedVideos(data: Intent): List<Map<String, Any>> {
        val uris = mutableListOf<Uri>()
        data.clipData?.let { clip ->
            for (index in 0 until clip.itemCount) {
                uris.add(clip.getItemAt(index).uri)
            }
        }
        data.data?.let { uris.add(it) }
        return uris.map { copyPickedVideo(it) }
    }

    private fun copyPickedVideo(uri: Uri): Map<String, Any> {
        val metadata = queryMetadata(uri)
        val name = sanitizeFileName(metadata.first)
        val outputFile = uniqueCacheFile(name)

        contentResolver.openInputStream(uri).use { input ->
            requireNotNull(input) { "unable to open selected video" }
            outputFile.outputStream().use { output -> input.copyTo(output) }
        }

        return mapOf(
            "path" to outputFile.absolutePath,
            "name" to name,
            "size" to outputFile.length()
        )
    }

    private fun queryMetadata(uri: Uri): Pair<String, Long> {
        var name = "video.mp4"
        var size = 0L
        val cursor: Cursor? = contentResolver.query(uri, null, null, null, null)
        cursor?.use {
            val nameIndex = it.getColumnIndex(OpenableColumns.DISPLAY_NAME)
            val sizeIndex = it.getColumnIndex(OpenableColumns.SIZE)
            if (it.moveToFirst()) {
                if (nameIndex >= 0) name = it.getString(nameIndex) ?: name
                if (sizeIndex >= 0) size = it.getLong(sizeIndex)
            }
        }
        return name to size
    }

    private fun sanitizeFileName(name: String): String {
        val clean = name
            .replace(Regex("""[<>:"/\\|?*\u0000-\u001F]"""), "_")
            .trim()
        return clean.ifEmpty { "video.mp4" }
    }

    private fun uniqueCacheFile(name: String): File {
        val directory = File(cacheDir, "picked_videos").apply { mkdirs() }
        val baseName = name.substringBeforeLast('.', name)
        val extension = name.substringAfterLast('.', "mp4")
        var candidate = File(directory, "$baseName.$extension")
        var index = 2
        while (candidate.exists()) {
            candidate = File(directory, "${baseName}_$index.$extension")
            index++
        }
        return candidate
    }

    companion object {
        private const val PICK_VIDEOS_REQUEST = 4207
    }
}
