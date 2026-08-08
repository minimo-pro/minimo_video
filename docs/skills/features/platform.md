# Platform Integration

## Media Selection

The start screen and the compression screen's add-more action show the same source sheet (`from gallery` / `from files`) before opening a native picker. Flutter passes `source` (`gallery` | `files`) to `pickVideos`. Selection from the compression screen is restricted to the pre-compression `ready` state and appends files to the existing batch.

### iOS

- **Gallery:** `PHPickerViewController` filtered to videos with unlimited multi-selection. Preserves Photos `assetIdentifier` and marks the pick deletable.
- **Files:** `UIDocumentPickerViewController` for `UTType.movie`, multi-selection, `asCopy: true`. No Photos identifier — original deletion is unavailable for these picks.

Selected files are imported sequentially to avoid parallel disk/memory pressure. Neither path requests broad library permission.

### Android

- **Gallery:** system photo picker (`MediaStore.ACTION_PICK_IMAGES`, `video/*`) on Android 13+; `ACTION_GET_CONTENT` + `video/*` on older versions. Android maps picker/document URIs to MediaStore video URIs when possible so originals can be selected for deletion. Providers that cannot be mapped remain non-deletable.
- **Files:** `ACTION_OPEN_DOCUMENT`, `video/*`, multi-selection. Document picks are non-deletable.

Selected URIs are copied sequentially into app cache on a background thread with a 1 MB buffer. After copying, native code verifies that the cached file contains a video track; invalid files are deleted and the pick fails so Flutter shows an error snackbar instead of opening compression. A later add-more pick must not clear `picked_videos`, because the existing batch still references those cached copies; cold-start cleanup owns removal of the directory.

Both platforms report `pickProgress` (`processed`/`total`) over the videos method channel while files are imported.

## Gallery and Deletion

- Normal saving uses `gal` and may request add-only gallery permission.
- Outputs selected to replace deletable originals use native `saveReplacement`.
  The replacement is created and verified before source deletion begins.
- iOS copies the Photos capture date, location, writable user-album membership,
  and favorite state. The new asset always receives a new local identifier.
- Android copies `DATE_TAKEN`, location and favorite values when MediaStore
  accepts them, plus the source `RELATIVE_PATH` so the replacement stays in the
  same folder. Unsupported optional columns produce a warning and retry with
  safe base metadata.
- iOS original deletion requests Photos read/write authorization only when deletion is confirmed.
- Android 11+ uses `MediaStore.createDeleteRequest` only for picks marked deletable, which shows the system confirmation UI.
- Android versions below 11 report original deletion as unsupported.
- Flutter carries both `sourceIdentifier` and `canDeleteOriginal`; UI must not infer delete capability from identifier presence alone.
- Metadata-copy and deletion failures are reported as partial success; a save
  failure leaves the original untouched.

## Native Metadata

| Platform | Duration/thumbnail API |
|---|---|
| iOS | `AVURLAsset`, `AVAssetImageGenerator` |
| Android | `MediaMetadataRetriever` |

## Screen Awake

`wakelock_plus` keeps the display awake during compression when the setting is enabled.

## Orientation

- Android activity: `screenOrientation="portrait"`
- iPhone: portrait only
- iPad: all orientations with multitasking and dynamic resizing

## iOS Configuration

- Deployment target: 15.0
- Flutter plugins are linked through Swift Package Manager.
- `ITSAppUsesNonExemptEncryption = false`
- Photo library usage strings are defined in `Info.plist`

## Android Configuration

- Min SDK: 24
- JitPack repository is required by `light_compressor_v2`
- Hardware acceleration remains enabled

---

[Back to SKILLS.md](../../SKILLS.md)
