# Contributing

Contributions to **minimo (video)** are welcome: bug reports, fixes, translations, documentation, and small features.

## Before changing code

1. Check [existing issues](https://github.com/minimo-pro/minimo_video/issues).
2. For a bug, describe how to reproduce it, expected behavior, actual behavior, device, and OS version.
3. For a large feature, open an issue first so the approach can be discussed before implementation.

## Local setup

Install [Flutter](https://docs.flutter.dev/get-started/install), then run:

```sh
git clone https://github.com/minimo-pro/minimo_video.git
cd minimo_video
flutter pub get
flutter run
```

## Making a change

- Keep the change focused. Do not mix unrelated fixes in one pull request.
- Follow the existing project structure and Dart style.
- Update both `lib/l10n/intl_en.arb` and `lib/l10n/intl_ru.arb` when changing user-facing text.
- Do not edit files under `lib/generated/` by hand.
- Add or update tests when behavior changes.

Before opening a pull request, run:

```sh
dart format .
flutter analyze
flutter test
```

Open a pull request with a short explanation of what changed and how it was tested. Add screenshots for visible UI changes.

By contributing, you agree to follow the [Code of Conduct](CODE_OF_CONDUCT.md).
