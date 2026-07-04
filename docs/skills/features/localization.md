# Localization

## Supported Locales

| Code | Language | Source |
|---|---|---|
| `en` | English | `lib/l10n/intl_en.arb` |
| `ru` | Russian | `lib/l10n/intl_ru.arb` |

The default follows the system locale. Users can select English, Russian, or system language in Settings.

## Workflow

1. Add the same key to both ARB files.
2. Include placeholder metadata where needed.
3. Run:

```bash
dart run intl_utils:generate
```

4. Run `flutter analyze` and `flutter test`.

Generated files under `lib/generated/` must not be edited manually.

## Usage

UI code reads strings through `S.of(context)`. Avoid hardcoded user-visible text in Dart and native platform code where Flutter can own the message.

---

[Back to SKILLS.md](../../SKILLS.md)
