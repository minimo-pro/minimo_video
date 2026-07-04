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

## Pipeline

1. Native picker copies selected video to app cache.
2. `VideoCompressorAdapter` maps settings to `light_compressor_v2`.
3. Plugin compresses with native Android/iOS codecs.
4. Progress stream is normalized from `0–100` to `0–1`.
5. Output is moved to app temporary storage only when it saves at least 10%.
6. Smaller savings are treated as already optimized: output is deleted, original remains.

## Estimates

Estimate formula:

```text
(video bitrate + optional 128 kbps audio) × duration / 8
```

Each estimate is capped at original file size. Duration comes from native `videoInfo`.

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
