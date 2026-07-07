package com.khlebobul.minimo_video

import android.content.Context
import android.content.ContentUris
import android.content.Intent
import android.database.Cursor
import android.net.Uri
import android.os.Build
import android.os.PowerManager
import android.provider.OpenableColumns
import android.provider.DocumentsContract
import android.provider.MediaStore
import android.media.MediaMetadataRetriever
import android.util.Log
import java.io.File
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private lateinit var videosChannel: MethodChannel
    private var pendingPickResult: MethodChannel.Result? = null
    private var pendingDeleteResult: MethodChannel.Result? = null
    private var pendingDeleteCount = 0

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
        videosChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "minimo_video/videos"
        )
        videosChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "pickVideos" -> pickVideos(result)
                "deleteOriginals" -> deleteOriginals(call.arguments as? List<*>, result)
                "videoInfo" -> videoInfo(call.arguments as? String, result)
                "createThumbnail" -> createThumbnail(call.arguments as? String, result)
                else -> result.notImplemented()
            }
        }
    }

    @Deprecated("Deprecated in Java")
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == DELETE_VIDEOS_REQUEST) {
            val result = pendingDeleteResult ?: return
            pendingDeleteResult = null
            if (resultCode == RESULT_OK) result.success(pendingDeleteCount)
            else result.error("delete_cancelled", "original video deletion was cancelled", null)
            pendingDeleteCount = 0
            return
        }
        if (requestCode != PICK_VIDEOS_REQUEST) return

        val result = pendingPickResult ?: return
        if (resultCode != RESULT_OK || data == null) {
            pendingPickResult = null
            result.success(emptyList<Map<String, Any>>())
            return
        }

        Thread {
            runCatching { readPickedVideos(data) }
                .onSuccess { videos ->
                    runOnUiThread {
                        pendingPickResult = null
                        result.success(videos)
                    }
                }
                .onFailure { error ->
                    runOnUiThread {
                        pendingPickResult = null
                        result.error("pick_failed", error.message, null)
                    }
                }
        }.start()
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

    private fun videoInfo(path: String?, result: MethodChannel.Result) {
        if (path == null) {
            result.error("invalid_path", "video path is missing", null)
            return
        }
        runCatching {
            val retriever = MediaMetadataRetriever()
            try {
                retriever.setDataSource(path)
                retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_DURATION)?.toLongOrNull() ?: 0L
            } finally {
                retriever.release()
            }
        }.onSuccess { result.success(mapOf("durationMs" to it)) }
            .onFailure { result.error("video_info_failed", it.message, null) }
    }

    private fun createThumbnail(path: String?, result: MethodChannel.Result) {
        if (path == null) {
            result.error("invalid_path", "video path is missing", null)
            return
        }
        runCatching {
            val retriever = MediaMetadataRetriever()
            val frame = try {
                retriever.setDataSource(path)
                retriever.getFrameAtTime(0, MediaMetadataRetriever.OPTION_CLOSEST_SYNC)
                    ?: error("unable to decode video thumbnail")
            } finally {
                retriever.release()
            }
            val output = File(cacheDir, "thumbnail_${System.nanoTime()}.jpg")
            output.outputStream().use {
                frame.compress(android.graphics.Bitmap.CompressFormat.JPEG, 82, it)
            }
            frame.recycle()
            output.absolutePath
        }.onSuccess(result::success)
            .onFailure { result.error("thumbnail_failed", it.message, null) }
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

    private fun deleteOriginals(arguments: List<*>?, result: MethodChannel.Result) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.R) {
            result.error("delete_unsupported", "deleting originals requires Android 11 or newer", null)
            return
        }
        if (pendingDeleteResult != null) {
            result.error("delete_in_progress", "video deletion is already open", null)
            return
        }
        val uris = arguments.orEmpty().filterIsInstance<String>().mapNotNull(::mediaStoreUri).distinct()
        if (uris.isEmpty()) {
            result.error("delete_unavailable", "no MediaStore videos to delete", null)
            return
        }
        pendingDeleteResult = result
        pendingDeleteCount = uris.size
        val request = MediaStore.createDeleteRequest(contentResolver, uris)
        startIntentSenderForResult(
            request.intentSender,
            DELETE_VIDEOS_REQUEST,
            null,
            0,
            0,
            0
        )
    }

    private fun mediaStoreUri(value: String): Uri? {
        val uri = Uri.parse(value)
        if (uri.authority == "media") return uri
        if (uri.authority != "com.android.providers.media.documents") return null
        val id = DocumentsContract.getDocumentId(uri).substringAfter(':').toLongOrNull() ?: return null
        return ContentUris.withAppendedId(MediaStore.Video.Media.EXTERNAL_CONTENT_URI, id)
    }

    private fun readPickedVideos(data: Intent): List<Map<String, Any>> {
        val uris = mutableListOf<Uri>()
        data.clipData?.let { clip ->
            for (index in 0 until clip.itemCount) {
                uris.add(clip.getItemAt(index).uri)
            }
        }
        data.data?.let { uris.add(it) }
        File(cacheDir, "picked_videos").deleteRecursively()
        Log.i(TAG, "Importing ${uris.size} videos sequentially")
        sendPickProgress(0, uris.size)
        return uris.mapIndexed { index, uri ->
            copyPickedVideo(uri).also {
                Log.i(TAG, "Imported ${index + 1}/${uris.size} videos")
                sendPickProgress(index + 1, uris.size)
            }
        }
    }

    private fun sendPickProgress(processed: Int, total: Int) = runOnUiThread {
        videosChannel.invokeMethod(
            "pickProgress",
            mapOf("processed" to processed, "total" to total)
        )
    }

    private fun copyPickedVideo(uri: Uri): Map<String, Any> {
        val metadata = queryMetadata(uri)
        val name = sanitizeFileName(metadata.first)
        val outputFile = uniqueCacheFile(name)

        contentResolver.openInputStream(uri).use { input ->
            requireNotNull(input) { "unable to open selected video" }
            outputFile.outputStream().use { output ->
                input.copyTo(output, 1024 * 1024)
            }
        }

        return mapOf(
            "path" to outputFile.absolutePath,
            "name" to name,
            "size" to outputFile.length(),
            "sourceIdentifier" to uri.toString()
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
        private const val TAG = "VideoPicker"
        private const val PICK_VIDEOS_REQUEST = 4207
        private const val DELETE_VIDEOS_REQUEST = 4208
    }
}
