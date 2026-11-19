# Dependencies and Maintenance

## Main Packages

| Package | Purpose |
|---|---|
| `light_compressor_v2` | Native video compression, metadata, and progress stream |
| `flutter_bloc` | Compression state orchestration |
| `auto_route` | Typed navigation |
| `shared_preferences` | Settings and onboarding state |
| `gal` | Save videos to gallery |
| `share_plus` | Share output files |
| `video_player` | Local before/after playback on the result screen |
| `in_app_review` | Request or open app review |
| `upgrader` | Prompt when a store update is available. 14.x widgets require `material_ui` |
| `material_ui` | Material widgets, theme, and localizations |
| `cupertino_ui` | Cupertino widgets used by the store-update dialog |
| `pub_semver` | Compare changelog versions |
| `path_provider`, `path` | Temporary file management |
| `intl`, `intl_utils` | Localization |
| `package_info_plus` | App version for changelog and about screen |
| `motor` | Press interaction motion |
| `stupid_simple_sheet` | Modal sheets with scroll-to-drag dismissal |
| `flutter_svg` | SVG icons |

`light_compressor_v2 1.12.0` supports fractional Mbps, optional 10-bit HDR export on iOS, and decoding Dolby Vision through its HEVC base layer on Android. The version is pinned in `pubspec.yaml`. Verify codec changes on physical devices.

UI code imports Material from `package:material_ui/material_ui.dart`. `MainApp` passes `GlobalMaterialLocalizations.delegates` and wraps the navigator in `MaterialUiCompatibilityBridge`, so packages that still import `package:flutter/material.dart` can read the theme. Leave the generated `flutter/material.dart` import in `lib/generated/l10n.dart` alone: `intl_utils` emits it, and that file only uses shared `Locale` and `LocalizationsDelegate` types.

Keep `shared_preferences_android` at 2.4.24 or newer so Android does not apply the Kotlin Gradle Plugin. `in_app_review` 2.0.12 still applies KGP; the Built-in Kotlin fix is only in unpublished PR https://github.com/britannio/in_app_review/pull/180. Do not switch that plugin to a git dependency. Re-check pub.dev for 2.0.13 before enabling `android.builtInKotlin=true`.

## Commands

```bash
flutter pub get
dart run build_runner build
dart run intl_utils:generate
flutter analyze
flutter test
flutter build apk --debug
flutter build ios --debug --no-codesign
```

Use `dart run build_runner build` after route changes. Use `dart run intl_utils:generate` after ARB changes.
The iOS project uses Flutter's Swift Package Manager integration. Do not add CocoaPods back unless a dependency has no SPM path.

## Platform Requirements

- Dart: `^3.12.0`
- Android min SDK: 24
- Android build: Gradle 9.1.0, AGP 9.0.1, Kotlin 2.3.20
- iOS deployment target: 15.0

---

[Back to SKILLS.md](../../SKILLS.md)
