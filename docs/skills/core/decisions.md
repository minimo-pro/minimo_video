# Technical Decisions

## Native Compression Instead of FFmpeg

The app uses native Android/iOS codec stacks through `light_compressor_v2`. This avoids shipping an FFmpeg runtime, keeps binary size and licensing work smaller, and fits straightforward on-device compression.

Accepted trade-off: output may differ across platforms, and uncommon formats or complex filters are outside current scope.

## Migration from `v_video_compressor`

`v_video_compressor` was removed after real-device iOS output produced black video with audio and unreliable output sizing. The app now uses `light_compressor_v2` for compression while retaining small native helpers for selection, metadata, thumbnails, and deletion.

## Small User-facing Settings Surface

Simple presets cover the primary use case. Advanced settings were reduced to resolution and audio. CRF, speed preset, frame rate, codec, two-pass mode, noise reduction, streaming optimization, metadata preservation, and hardware-acceleration switches were removed from UI/state.

Reason: the replacement package does not expose all controls consistently, and most users need predictable basic compression rather than encoder tuning.

## Minimum Useful Savings

Compressed output is accepted only when:

```text
output size ≤ 90% of original size
```

Otherwise output is deleted and shown as skipped/already optimized. This avoids keeping a lossy re-encode for negligible space savings.

## Sequential Batch Processing

Videos are compressed one at a time. This keeps memory, thermal load, cancellation, and progress semantics predictable on mobile devices.

## Privacy-preserving Pickers

iOS uses `PHPickerViewController`; Android uses `ACTION_OPEN_DOCUMENT`. Selection should not request unrestricted media-library access. Broader authorization is deferred until saving or explicit source deletion requires it.

## Temporary Copies

Picked and compressed files live in app cache until saved/shared. Originals are never modified in place. Temporary files are cleared on every cold start.

---

[Back to SKILLS.md](../../SKILLS.md)
