# Results, Saving, and Errors

## Result Semantics

| Condition | Status | Output |
|---|---|---|
| Output saves at least 10% | `compressed` | Temporary MP4 retained |
| Output saves less than 10% | `skipped` | New MP4 deleted |
| Plugin/IO operation throws | `failed` | Error stored in Bloc state |
| User cancels | returns to `ready` | Partial run results cleared |

Mixed batches can contain compressed, skipped, and failed items. Save/share actions use successful output paths only. Saved-space totals exclude skipped and failed videos.

## Preview

Successful results can be previewed from `CompressionResultView`. The preview uses `video_player` to show original and compressed local files side by side with a center divider, shared play/pause, shared seek, and muted playback.

Only `state.successResults` are previewable. Skipped and failed items stay in the status list.

## Share

`CompressionResultView` passes all successful MP4 paths to `share_plus`. On tablets, `sharePositionOrigin` comes from result-view bounds. Failures are shown through an error snackbar.

## Save

`CompressResultsSaved(deleteOriginals: false)` saves each successful output through `gal`. If album saving is enabled, album name is `Minimo`.

Saving is guarded by `state.isSaving` to prevent duplicate actions. A failure stops the operation and stores `saveError` for UI notification.

## Save and Delete Originals

`CompressResultsSaved(deleteOriginals: true)` saves successful outputs first, then requests source deletion using unique non-null `sourceIdentifier` values.

- Save success remains valid if original deletion fails.
- Deletion failures use `deleteError`, separate from `saveError`.
- Sources without a platform identifier cannot be deleted.
- Output paths equal to source paths are excluded defensively.
- System confirmation remains authoritative; cancellation is not deletion success.

## Compression Errors

- Plugin failure/cancel variants become `StateError` in the adapter.
- Normal encoder errors mark that item failed; remaining batch items continue.
- User cancellation exits the active run and ignores later callbacks.
- Run IDs reject progress from previous compression runs.
- Thumbnail and estimate failures return `null`; UI falls back instead of blocking compression.

## Known Limitations

- `light_compressor_v2` is pinned to `1.0.0` for current Dart compatibility.
- Installing/changing a native plugin requires a full rebuild; hot reload cannot register new platform channels.
- Already compressed inputs are re-encoded before the 10% policy decides whether to keep output.
- Estimates are bitrate-based approximations, not guarantees.
- Codec output and compression ratio can differ between Android and iOS.
- Original deletion depends on picker/provider identifiers and OS support.
- Android original deletion requires Android 11 or newer.
- Flutter tests cannot validate real native video frames or audio synchronization.

---

[Back to SKILLS.md](../../SKILLS.md)
