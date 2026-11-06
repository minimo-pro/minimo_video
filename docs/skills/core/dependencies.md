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
| `upgrader` | Prompt when a store update is available |
| `pub_semver` | Compare changelog versions |
| `path_provider`, `path` | Temporary file management |
| `intl`, `intl_utils` | Localization |
| `package_info_plus` | App version for changelog and about screen |
| `motor` | Press interaction motion |
| `stupid_simple_sheet` | Modal sheets with scroll-to-drag dismissal |
| `flutter_svg` | SVG icons |

`light_compressor_v2 1.11.0` supports fractional Mbps for compression and estimates, decodes Dolby Vision through its HEVC base layer on Android, outputs HDR sources as SDR (BT.709), and stays pinned in `pubspec.yaml`; verify its example app before changing compression options.

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
