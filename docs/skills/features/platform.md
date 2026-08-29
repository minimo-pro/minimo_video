# Platform Integration

## Media Selection

The start screen and the compression screen's add-more action show the same source sheet (`from gallery` / `from files`) before opening a native picker. Flutter passes `source` (`gallery` | `files`) to `pickVideos`. Selection from the compression screen is restricted to the pre-compression `ready` state and appends files to the existing batch.

### iOS

- **Gallery:** `PHPickerViewController` filtered to videos with unlimited multi-selection. Preserves Photos `assetIdentifier` and marks the pick deletable.
- **Files:** `UIDocumentPickerViewController` for `UTType.movie`, multi-selection, `asCopy: true`. No Photos identifier — original deletion is unavailable for these picks.

Selected files are imported sequentially to avoid parallel disk/memory pressure. Neither path requests broad library permission.

### Android

- **Gallery:** system photo picker (`MediaStore.ACTION_PICK_IMAGES`, `video/*`) on Android 13+; `ACTION_GET_CONTENT` + `video/*` on older versions. Selected URIs are imported only; Android does not retain identifiers for replacement or deletion.
- **Files:** `ACTION_OPEN_DOCUMENT`, `video/*`, multi-selection. Document picks are non-deletable.

Selected URIs are copied sequentially into app cache on a background thread with a 1 MB buffer. After copying, native code verifies that the cached file contains a video track; invalid files are deleted and the pick fails so Flutter shows an error snackbar instead of opening compression. A later add-more pick must not clear `picked_videos`, because the existing batch still references those cached copies; cold-start cleanup owns removal of the directory.

Both platforms report `pickProgress` (`processed`/`total`) over the videos method channel while files are imported. `CompressScreen` displays it in the disabled Compress button while the rest of the settings remain interactive.

## Gallery and Deletion

- Normal saving uses `gal` and may request add-only gallery permission.
- On iOS, beside-original and replace-original use native `saveReplacement`.
  Both preserve supported metadata; only replace requests source deletion after
  the new asset is created and verified.
- iOS copies the Photos capture date, location, writable user-album membership,
  and favorite state. The new asset always receives a new local identifier.
- iOS original deletion requests Photos read/write authorization only when deletion is confirmed.
- Flutter carries both `sourceIdentifier` and `canDeleteOriginal`; UI must not infer delete capability from identifier presence alone.
- Android always reports picks as non-deletable, does not register native
  replacement/deletion methods, and saves directly through `gal` when the user
  taps save. The beside/replace sheet remains iOS-only.
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
