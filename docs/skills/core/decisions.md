# Technical Decisions

## Native Compression Instead of FFmpeg

The app uses native Android/iOS codec stacks through `light_compressor_v2`. This avoids shipping an FFmpeg runtime, keeps binary size and licensing work smaller, and fits straightforward on-device compression.

Accepted trade-off: output may differ across platforms, and uncommon formats or complex filters are outside current scope.

## Migration from `v_video_compressor`

`v_video_compressor` was removed after real-device iOS output produced black video with audio and unreliable output sizing. The app now uses `light_compressor_v2` for compression while retaining small native helpers for selection, metadata, thumbnails, and deletion.

## Small User-facing Settings Surface

Simple presets cover the primary use case. Advanced settings expose controls
supported consistently by `light_compressor_v2`: resolution, video bitrate,
frame rate, H.264/HEVC codec, and audio. CRF, speed preset, two-pass mode, noise
reduction, streaming optimization, metadata preservation, and hardware-
acceleration switches remain outside UI/state.

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

Users choose gallery or files before a native picker opens. Gallery uses privacy-preserving system pickers (`PHPicker` / Android photo picker); files use document pickers (`UIDocumentPicker` / `ACTION_OPEN_DOCUMENT`). Selection should not request unrestricted media-library access. Broader authorization is deferred until saving or explicit source deletion requires it. Original deletion remains available only for gallery picks that return a provider identifier.

## Temporary Copies

Picked and compressed files live in app cache until saved/shared. Originals are never modified in place. Temporary files are cleared on every cold start.

## Sheets via `stupid_simple_sheet`

Settings, info, changelog, and comparison use `StupidSimpleSheetRoute` (through `showAppSheet` / `showAppContentSheet`) instead of `showModalBottomSheet`. Material's modal sheet does not hand a downward swipe from a list at its top edge over to sheet dismissal; users expect that native behavior. Small pickers without nested scrolling (e.g. language) may still use `showModalBottomSheet`.

---

[Back to SKILLS.md](../../SKILLS.md)
