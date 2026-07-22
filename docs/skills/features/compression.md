# Video Compression

## Presets

| Preset | Internal CRF tier | Target bitrate | Resolution |
|---|---:|---:|---|
| High | 22 | 4 Mbps | original |
| Medium | 28 | 2 Mbps | 1280×720 |
| Low | 34 | 1 Mbps | 854×480 |

CRF is retained internally to map existing UI state to `light_compressor_v2`; users do not edit it directly.

Advanced mode allows:

- Original, 1080p, 720p, 480p, or 360p resolution
- Stereo audio or no audio

Reduced-resolution presets preserve the source orientation. Before passing a
custom `videoWidth`/`videoHeight` to `light_compressor_v2`,
`VideoCompressorAdapter` reads `LightCompressor.getMediaInfo()` and fits the
target inside the raw encoded `width`/`height` while preserving the source
aspect ratio. The plugin applies rotation metadata itself, so passing display
dimensions would rotate the target twice. Original resolution does not pass
custom dimensions and relies on the package's `keepOriginalResolution` path.

Retained audio is encoded as AAC at 128 kbps. Do not switch back to passthrough: `light_compressor_v2 1.8.1` can crash inside `AVAssetWriter.addInput` when the source audio format is incompatible with MP4.

## Pipeline

1. Native picker copies selected video to app cache.
2. `VideoCompressorAdapter` maps settings to `light_compressor_v2`.
3. Plugin compresses with native Android/iOS codecs.
4. Progress stream is normalized from `0–100` to `0–1`.
5. Output is moved to app temporary storage only when it saves at least 10%.
6. Smaller savings are treated as already optimized: output is deleted, original remains.

`BackgroundConfig` keeps compression running through an Android foreground service when the app is minimized or the screen is off. iOS does not support continuous background transcoding; the native job can remain stuck after the OS suspends the app.

On iOS the compression screen warns the user to keep the app open. If the app is backgrounded during compression, the active native job is cancelled immediately; returning restarts only the current video and keeps completed batch items.

## Estimates

Estimate formula:

```text
(video bitrate × resolution scale + optional 128 kbps audio) × duration / 8
```

Lower target resolutions use progressively smaller estimate scales. Each
estimate is capped at original file size. Duration comes from native
`videoInfo`. Changing settings immediately clears the previous asynchronous
estimate so the UI shows the local fallback until fresh metadata-based output
arrives.

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
