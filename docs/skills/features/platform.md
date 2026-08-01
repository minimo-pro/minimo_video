# Platform Integration

## Media Selection

The start screen shows a source sheet (`from gallery` / `from files`) before opening a native picker. Flutter passes `source` (`gallery` | `files`) to `pickVideos`.

### iOS

- **Gallery:** `PHPickerViewController` filtered to videos with unlimited multi-selection. Preserves Photos `assetIdentifier` for original deletion.
- **Files:** `UIDocumentPickerViewController` for `UTType.movie`, multi-selection, `asCopy: true`. No Photos identifier — original deletion is unavailable for these picks.

Selected files are imported sequentially to avoid parallel disk/memory pressure. Neither path requests broad library permission.

### Android

- **Gallery:** system photo picker (`MediaStore.ACTION_PICK_IMAGES`, `video/*`) on Android 13+; `ACTION_GET_CONTENT` + `video/*` on older versions.
- **Files:** `ACTION_OPEN_DOCUMENT`, `video/*`, multi-selection.

Selected URIs are copied sequentially into app cache on a background thread with a 1 MB buffer.

Both platforms report `pickProgress` (`processed`/`total`) over the videos method channel while files are imported.

## Gallery and Deletion

- Saving uses `gal` and may request add-only gallery permission.
- iOS original deletion requests Photos read/write authorization only when deletion is confirmed.
- Android 11+ uses `MediaStore.createDeleteRequest`, which shows the system confirmation UI.
- Android versions below 11 report original deletion as unsupported.

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
