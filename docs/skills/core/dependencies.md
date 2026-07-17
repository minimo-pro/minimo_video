# Dependencies and Maintenance

## Main Packages

| Package | Purpose |
|---|---|
| `light_compressor_v2` `1.8.2` | Native video compression, metadata, and progress stream |
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
| `flutter_svg` | SVG icons |

`light_compressor_v2` stays pinned in `pubspec.yaml`; verify its example app before changing compression options.

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

- Dart: `^3.9.2`
- Android min SDK: 24
- iOS deployment target: 15.0

---

[Back to SKILLS.md](../../SKILLS.md)
