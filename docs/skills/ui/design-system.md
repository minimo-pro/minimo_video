# Design System

## Theme

`AppTheme` follows system light/dark mode until the user selects and saves a theme in settings. Color definitions live in `lib/theme/app_colors.dart`.

| Token | Light | Dark |
|---|---|---|
| Background | `#F1F2F6` | `#121212` |
| Text | `#272727` | `#E0E0E0` |
| Accent | `#FC3636` | `#FC3636` |
| Success | `#059A25` | `#059A25` |
| Frame | `#D9D9D9` | `#3A3A3A` |

Font family: **Pangolin**.

## Shared Controls

| Widget | Purpose |
|---|---|
| `Pressable` | Platform-aware spring scale feedback |
| `HoldToConfirmButton` | 1.5-second hold confirmation with red fill |
| `AppActionButton` | Primary/secondary screen actions |
| `AppSnackBar` | Success, error, and instruction messages |
| `FadedScrollView` | Clamped scroll with static alpha-only edge fading |
| `AppOptionPicker` | Compact option selection |
| `AnimatedAssetCheckbox` | Custom settings checkbox |

## Motion Rules

- Respect `MediaQuery.disableAnimations` where applicable.
- Current video progress is static red text, not a pulsing indicator.
- Hold progress fills left-to-right while the whole button uses `Pressable` scaling.
- Duplicate `AppSnackBar` messages shake the existing snackbar, bring it to the front, and reset its timer instead of adding another copy.
- Avoid Material splash/highlight fills; the app uses scale feedback instead.

---

[Back to SKILLS.md](../../SKILLS.md)
