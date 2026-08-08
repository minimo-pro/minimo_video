package com.khlebobul.minimo_video

import android.content.Context
import android.content.ContentUris
import android.content.ContentValues
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
    private var pendingPickSource = "gallery"
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
                "pickVideos" -> pickVideos(call.arguments, result)
                "deleteOriginals" -> deleteOriginals(call.arguments as? List<*>, result)
                "saveReplacement" -> saveReplacement(call.arguments as? Map<*, *>, result)
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
        val source = pendingPickSource
        if (resultCode != RESULT_OK || data == null) {
            pendingPickResult = null
            result.success(emptyList<Map<String, Any>>())
            return
        }

        Thread {
            runCatching { readPickedVideos(data, source) }
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

    private fun pickVideos(arguments: Any?, result: MethodChannel.Result) {
        if (pendingPickResult != null) {
            result.error("pick_in_progress", "video picker is already open", null)
            return
        }

        pendingPickResult = result
        val source = (arguments as? Map<*, *>)?.get("source") as? String ?: "gallery"
        pendingPickSource = source
        val intent = if (source == "files") {
            openDocumentIntent()
        } else {
            galleryIntent()
        }
        startActivityForResult(intent, PICK_VIDEOS_REQUEST)
    }

    private fun openDocumentIntent(): Intent {
        return Intent(Intent.ACTION_OPEN_DOCUMENT).apply {
            addCategory(Intent.CATEGORY_OPENABLE)
            type = "video/*"
            putExtra(Intent.EXTRA_ALLOW_MULTIPLE, true)
            addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
        }
    }

    private fun galleryIntent(): Intent {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            return Intent(MediaStore.ACTION_PICK_IMAGES).apply {
                type = "video/*"
                putExtra(MediaStore.EXTRA_PICK_IMAGES_MAX, MediaStore.getPickImagesMaxLimit())
            }
        }
        return Intent(Intent.ACTION_GET_CONTENT).apply {
            addCategory(Intent.CATEGORY_OPENABLE)
            type = "video/*"
            putExtra(Intent.EXTRA_ALLOW_MULTIPLE, true)
        }
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

    private fun saveReplacement(arguments: Map<*, *>?, result: MethodChannel.Result) {
        val path = arguments?.get("path") as? String
        val sourceIdentifier = arguments?.get("sourceIdentifier") as? String
        val album = arguments?.get("album") as? String
        if (path == null || sourceIdentifier == null || !File(path).isFile) {
            result.error("save_failed", "replacement video is unavailable", null)
            return
        }
        val sourceUri = mediaStoreUri(sourceIdentifier)
        if (sourceUri == null) {
            result.error("save_failed", "original MediaStore video is unavailable", null)
            return
        }

        Thread {
            var outputUri: Uri? = null
            try {
                val metadata = queryReplacementMetadata(sourceUri)
                val warnings = mutableListOf<String>()
                val baseValues = ContentValues().apply {
                    put(MediaStore.Video.Media.DISPLAY_NAME, File(path).name)
                    put(MediaStore.Video.Media.MIME_TYPE, "video/mp4")
                    put(MediaStore.Video.Media.IS_PENDING, 1)
                    if (metadata.dateTaken > 0) {
                        put(MediaStore.Video.Media.DATE_TAKEN, metadata.dateTaken)
                    }
                    put(
                        MediaStore.Video.Media.RELATIVE_PATH,
                        metadata.relativePath
                            ?: album?.takeIf { it.isNotBlank() }?.let { "Movies/$it" }
                            ?: "Movies"
                    )
                }
                val allValues = ContentValues(baseValues).apply {
                    metadata.favorite?.let { put("is_favorite", it) }
                    metadata.latitude?.let { put("latitude", it) }
                    metadata.longitude?.let { put("longitude", it) }
                }
                outputUri = try {
                    contentResolver.insert(MediaStore.Video.Media.EXTERNAL_CONTENT_URI, allValues)
                } catch (_: Exception) {
                    warnings.add("optional_metadata_unavailable")
                    contentResolver.insert(MediaStore.Video.Media.EXTERNAL_CONTENT_URI, baseValues)
                } ?: error("replacement MediaStore item was not created")

                File(path).inputStream().use { input ->
                    contentResolver.openOutputStream(outputUri!!, "w").use { output ->
                        requireNotNull(output) { "replacement MediaStore item could not be opened" }
                        input.copyTo(output, 1024 * 1024)
                    }
                }
                val published = ContentValues().apply { put(MediaStore.Video.Media.IS_PENDING, 0) }
                contentResolver.update(outputUri!!, published, null, null)
                val size = contentResolver.query(
                    outputUri!!,
                    arrayOf(MediaStore.Video.Media.SIZE),
                    null,
                    null,
                    null
                )?.use { cursor ->
                    if (cursor.moveToFirst()) cursor.getLong(0) else 0L
                } ?: 0L
                check(size > 0) { "replacement video could not be verified" }

                runOnUiThread { result.success(mapOf("saved" to true, "warnings" to warnings)) }
            } catch (error: Exception) {
                outputUri?.let { runCatching { contentResolver.delete(it, null, null) } }
                runOnUiThread { result.error("save_failed", error.message, null) }
            }
        }.start()
    }

    private fun queryReplacementMetadata(uri: Uri): ReplacementMetadata {
        return contentResolver.query(uri, null, null, null, null)?.use { cursor ->
            check(cursor.moveToFirst()) { "original MediaStore video is unavailable" }
            fun long(column: String): Long? = cursor.getColumnIndex(column)
                .takeIf { it >= 0 && !cursor.isNull(it) }
                ?.let(cursor::getLong)
            fun int(column: String): Int? = cursor.getColumnIndex(column)
                .takeIf { it >= 0 && !cursor.isNull(it) }
                ?.let(cursor::getInt)
            fun double(column: String): Double? = cursor.getColumnIndex(column)
                .takeIf { it >= 0 && !cursor.isNull(it) }
                ?.let(cursor::getDouble)
            fun string(column: String): String? = cursor.getColumnIndex(column)
                .takeIf { it >= 0 && !cursor.isNull(it) }
                ?.let(cursor::getString)

            ReplacementMetadata(
                dateTaken = long(MediaStore.Video.Media.DATE_TAKEN)
                    ?.takeIf { it > 0 }
                    ?: long(MediaStore.Video.Media.DATE_ADDED)?.times(1000)
                    ?: long(MediaStore.Video.Media.DATE_MODIFIED)?.times(1000)
                    ?: 0L,
                relativePath = string(MediaStore.Video.Media.RELATIVE_PATH),
                favorite = int("is_favorite"),
                latitude = double("latitude"),
                longitude = double("longitude")
            )
        } ?: error("original MediaStore video is unavailable")
    }

    private fun mediaStoreUri(value: String): Uri? {
        val uri = Uri.parse(value)
        if (uri.authority == "media") {
            if (uri.pathSegments.contains("picker")) {
                val id = uri.lastPathSegment?.toLongOrNull() ?: return null
                return ContentUris.withAppendedId(MediaStore.Video.Media.EXTERNAL_CONTENT_URI, id)
            }
            return uri
        }
        if (uri.authority != "com.android.providers.media.documents") return null
        val id = DocumentsContract.getDocumentId(uri).substringAfter(':').toLongOrNull() ?: return null
        return ContentUris.withAppendedId(MediaStore.Video.Media.EXTERNAL_CONTENT_URI, id)
    }

    private fun readPickedVideos(data: Intent, source: String): List<Map<String, Any>> {
        val uris = mutableListOf<Uri>()
        data.clipData?.let { clip ->
            for (index in 0 until clip.itemCount) {
                uris.add(clip.getItemAt(index).uri)
            }
        }
        data.data?.let { uris.add(it) }
        Log.i(TAG, "Importing ${uris.size} videos sequentially")
        sendPickProgress(0, uris.size)
        return uris.mapIndexed { index, uri ->
            copyPickedVideo(uri, source).also {
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

    private fun copyPickedVideo(uri: Uri, source: String): Map<String, Any> {
        val metadata = queryMetadata(uri)
        val name = sanitizeFileName(metadata.first)
        val outputFile = uniqueCacheFile(name)
        val deleteUri = if (source == "gallery") mediaStoreUri(uri.toString()) else null

        contentResolver.openInputStream(uri).use { input ->
            requireNotNull(input) { "unable to open selected video" }
            outputFile.outputStream().use { output ->
                input.copyTo(output, 1024 * 1024)
            }
        }
        if (!isVideoFile(outputFile)) {
            outputFile.delete()
            error("selected file is not a video")
        }

        return mapOf(
            "path" to outputFile.absolutePath,
            "name" to name,
            "size" to outputFile.length(),
            "sourceIdentifier" to (deleteUri?.toString() ?: uri.toString()),
            "canDeleteOriginal" to (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R && deleteUri != null)
        )
    }

    private fun isVideoFile(file: File): Boolean {
        val retriever = MediaMetadataRetriever()
        return try {
            retriever.setDataSource(file.absolutePath)
            retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_HAS_VIDEO) == "yes"
        } finally {
            retriever.release()
        }
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

    private data class ReplacementMetadata(
        val dateTaken: Long,
        val relativePath: String?,
        val favorite: Int?,
        val latitude: Double?,
        val longitude: Double?
    )
}
