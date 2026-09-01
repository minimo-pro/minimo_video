# Localization

## Supported Locales

| Code | Language | Source |
|---|---|---|
| `en` | English | `lib/l10n/intl_en.arb` |
| `ru` | Russian | `lib/l10n/intl_ru.arb` |
| `es` | Spanish | `lib/l10n/intl_es.arb` |
| `pt` | Portuguese (Brazil) | `lib/l10n/intl_pt.arb` |
| `de` | German | `lib/l10n/intl_de.arb` |
| `fr` | French | `lib/l10n/intl_fr.arb` |
| `zh` | Chinese (Simplified) | `lib/l10n/intl_zh.arb` |
| `hi` | Hindi | `lib/l10n/intl_hi.arb` |
| `nl` | Dutch | `lib/l10n/intl_nl.arb` |
| `ko` | Korean | `lib/l10n/intl_ko.arb` |
| `ja` | Japanese | `lib/l10n/intl_ja.arb` |
| `it` | Italian | `lib/l10n/intl_it.arb` |
| `tr` | Turkish | `lib/l10n/intl_tr.arb` |

The default follows the system locale. Users can select any supported language or the system language in Settings.

## Workflow

1. Add the same key to every ARB file.
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
