# Video Compression

## Presets

| Preset | Internal CRF tier | Target bitrate | Resolution |
|---|---:|---:|---|
| High | 22 | 4 Mbps | original |
| Medium | 28 | 2 Mbps | 1280×720 |
| Low | 34 | 1 Mbps | 854×480 |

Preset bitrates are nominal for 30 FPS H.264 input. CRF is retained internally to map existing UI state to `light_compressor_v2`; users do not edit it directly.

Advanced mode allows:

- Original, 1080p, 720p, 480p, or 360p resolution
- Automatic or 1, 2, 4, 6, or 8 Mbps video bitrate
- Original, 60, 30, 24, or 15 FPS output; the package only downsamples
- H.264 or HEVC output; unsupported HEVC hardware falls back to H.264
- Stereo audio or no audio

With automatic bitrate, `CompressionSettings.effectiveBitrateMbps()` derives the encoder target from the fitted output pixel count, effective output FPS, quality tier, and codec efficiency. Original resolution uses source dimensions for bitrate calculation without passing them as resize dimensions. Requested FPS is capped at the source FPS because the package only downsamples. HEVC targets fewer bits than H.264 for comparable quality. `light_compressor_v2` currently accepts only whole Mbps, so automatic targets are rounded and clamped to `1–8 Mbps`. A manually selected bitrate is absolute and is not modified by resolution, FPS, or codec.

`light_compressor_v2 1.9.1` does not expose encoder speed presets or video
container metadata copying. Do not add UI switches for either until the native
pipeline can honor them on both Android and iOS.

Reduced-resolution presets preserve the source orientation. Before passing a
custom `videoWidth`/`videoHeight` to `light_compressor_v2`,
`VideoCompressorAdapter` reads `LightCompressor.getMediaInfo()` and fits the
target inside the raw encoded `width`/`height` while preserving the source
aspect ratio. The plugin applies rotation metadata itself, so passing display
dimensions would rotate the target twice. Original resolution does not pass
custom dimensions and relies on the package's `keepOriginalResolution` path.

Retained audio is encoded as AAC at 128 kbps. Do not switch back to passthrough: `light_compressor_v2 1.8.1` can crash inside `AVAssetWriter.addInput` when the source audio format is incompatible with MP4.

## Pipeline

1. Native picker copies selected videos to app cache.
2. `VideoCompressorAdapter` maps settings to `light_compressor_v2`.
3. Plugin compresses with native Android/iOS codecs.
4. Progress stream is normalized from `0–100` to `0–1`.
5. Output is moved to app temporary storage only when it saves at least 10%.
6. Smaller savings are treated as already optimized: output is deleted, original remains.

The plugin-reported `usedFormat` is stored with each successful result. If
HEVC was requested but hardware fallback produced H.264, the result screen
shows a localized notice.

`BackgroundConfig` keeps compression running through an Android foreground service when the app is minimized or the screen is off. iOS does not support continuous background transcoding; the native job can remain stuck after the OS suspends the app.

On iOS the compression screen warns the user to keep the app open. If the app is backgrounded during compression, the active native job is cancelled immediately; returning restarts only the current video and keeps completed batch items.

## Importing and Adding Videos During Configuration

After the start-screen source choice, `CompressScreen` opens the native picker and owns the import. Until native selection is confirmed, it shows the intermediate `VideoLoadingView` instead of an empty settings placeholder. Cancellation returns to the start screen. Once `pickProgress(0, total)` confirms a non-empty selection, simple and advanced settings appear and remain interactive while cloud-backed videos download or files copy into cache. Until the first import completes, the preview area shows `MinimoLoader` plus the cloud/large-file hint; zero-byte estimates and the no-savings message stay hidden. The Compress button shows its own compact `MinimoLoader` plus picker batch progress and stays disabled until every selected video is ready. Back and add-more are also disabled during import; an import error restores them and shows a localized snackbar.

The plus action beside the bottom Compress button is available only in `CompressStatus.ready`. It uses the same gallery/files source sheet and `VideoFileAdapter.pickVideos` path. Add-more imports use the same non-blocking settings UI and progress state.

Picked videos are appended through `CompressVideosAdded`; existing compression settings remain unchanged. Videos already in the batch are ignored: provider `sourceIdentifier` is the primary identity, with original filename plus file size as the fallback for providers that do not expose an identifier. The same filtering also removes duplicates returned in one additional pick.

The Bloc keeps `videos`, `thumbnailPaths`, and `videoStatuses` aligned, requests thumbnails for the first three items, invalidates any stale asynchronous estimate, and computes a new estimate for the expanded batch. Empty, cancelled, or duplicate-only picker results leave the batch unchanged. Adding files is not available during processing or on the result screen.

## Estimates

`VideoCompressorAdapter` calls `LightCompressor.getCompressionEstimate()` with
the same quality, codec, dimensions, bitrate, and audio-removal settings used
for compression. Frame rate affects the automatic bitrate before that call,
because the plugin estimate API has no separate FPS argument. Each estimate is
capped at original file size. Changing
settings keeps the previous asynchronous estimate visible until the refreshed
native estimate arrives; this avoids a transient local-fallback `0%` state.
Adding videos still clears the old estimate because it belongs to a different
batch. A genuine `0%` estimate disables compression, while the adapter's 10%
acceptance threshold remains authoritative for completed output.

## Batch and Progress

- Files run sequentially.
- Overall progress is weighted by original file sizes.
- `currentVideoProgress` drives the percentage beside the active filename.
- Per-video statuses: waiting, processing, compressed, skipped, failed.

## Cancellation

Cancellation increments a generation counter, calls the plugin cancellation API, clears partial results, and returns the Bloc to `ready`. Stale progress events are ignored by compression run ID.

## Output Naming

- Optional prefix: `minimo_`
- Existing prefix is not duplicated
- Invalid filename characters become `_`
- Duplicate outputs receive `_2`, `_3`, and so on
- Output container is MP4

---

[Back to SKILLS.md](../../SKILLS.md)
