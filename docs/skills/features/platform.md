# Platform Integration

## Media Selection

### iOS

Uses `PHPickerViewController` filtered to videos with unlimited multi-selection. The picker grants access only to selected items and does not require broad library permission.

### Android

Uses `ACTION_OPEN_DOCUMENT`, `video/*`, and multi-selection. Selected URIs are copied into app cache.

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

## Orientation

- Android activity: `screenOrientation="portrait"`
- iPhone: portrait only
- iPad: portrait and portrait upside-down

## iOS Configuration

- Deployment target: 15.0
- `ITSAppUsesNonExemptEncryption = false`
- Photo library usage strings are defined in `Info.plist`

## Android Configuration

- Min SDK: 24
- JitPack repository is required by `light_compressor_v2`
- Hardware acceleration remains enabled

---

[Back to SKILLS.md](../../SKILLS.md)
