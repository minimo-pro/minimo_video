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

`CompressionResultView` places `VS`, save, and icon-only share in the bottom row. `VS` opens comparison immediately. Share passes all successful MP4 paths to `share_plus`. On tablets, `sharePositionOrigin` comes from result-view bounds. Failures are shown through an error snackbar.

## Save

On iOS, filled primary save opens a sheet with three explicit modes: save as new,
save beside the original, or replace the original. Save as new uses `gal`.
Beside and replace use the native create-and-verify path with source metadata;
replace then requests original deletion. On Android, the button saves as new
immediately without opening the sheet. If album saving is enabled, album name is
`Minimo`.

Saving is guarded by `state.isSaving` against concurrent actions. Successfully
saved outputs, replacements, and deletions are remembered for the current Bloc
run, so retries skip completed work instead of duplicating assets or requesting
an already deleted Photos asset. After every output is saved, the primary action
shows a disabled `Saved` state with a checkmark; save failure restores the ready
action.

## Save and Delete Originals

The save sheet is the only deletion path. For selected originals, the app first
creates and verifies a new gallery asset carrying supported source metadata.
Only after every output is saved does it request deletion using unique non-null
`sourceIdentifier` values whose source is marked deletable. This preserves the
chronological gallery position without risky in-place writes.

- Save success remains valid if original deletion fails.
- Metadata transfer failures use `metadataError` and are reported as partial success.
- Deletion failures use `deleteError`, separate from `saveError`.
- Sources without a platform identifier cannot be deleted.
- Beside and replace modes are disabled when no source supports gallery replacement.
- Output paths equal to source paths are excluded defensively.
- System confirmation remains authoritative; cancellation is not deletion success.

## Compression Errors

- Picker errors, including providers returning non-video files, show an error snackbar and do not add files to the batch.
- User-facing save, delete, and share errors are localized messages; raw platform exceptions remain internal.
- Plugin failure/cancel variants become `StateError` in the adapter.
- Normal encoder errors mark that item failed; remaining batch items continue.
- User cancellation exits the active run and ignores later callbacks.
- Run IDs reject progress from previous compression runs.
- Thumbnail and estimate failures return `null`; UI falls back instead of blocking compression.

## Known Limitations

- `light_compressor_v2` is pinned to `1.9.1`; update it deliberately and repeat physical-device codec checks.
- Installing/changing a native plugin requires a full rebuild; hot reload cannot register new platform channels.
- Already compressed inputs are re-encoded before the 10% policy decides whether to keep output.
- Estimates are bitrate-based approximations, not guarantees.
- Codec output and compression ratio can differ between Android and iOS.
- Original deletion depends on picker/provider identifiers and is iOS-only.
- Android save is always save-as-new and skips the options sheet because protected
  Photo Picker items do not reliably expose replacement/deletion metadata.
- Gallery ordering in system-specific "Recently Added" views cannot be preserved.
- Flutter tests cannot validate real native video frames or audio synchronization.

---

[Back to SKILLS.md](../../SKILLS.md)
