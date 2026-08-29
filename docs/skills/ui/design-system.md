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

## Icons

Asset paths live in `AppIcons` (`lib/constants/app_icons.dart`). Icons are hand-drawn SVGs under `assets/icons/`.

Notable action icons:

| Constant | Asset | Typical use |
|---|---|---|
| `arrowBack` | `arrow_back.svg` | Top-left compress navigation |
| `share` | `share.svg` | Done-screen share |
| `more` | `more.svg` | Done-screen overflow menu |
| `close` | `close.svg` | Settings/info sheet dismiss |

When rendering icons inside `AppActionButton`, the SVG is wrapped in a fixed `SizedBox(iconWidth × iconHeight)` with `BoxFit.contain`. Wide assets such as `more.svg` must not expand past the button.

## Shared Controls

| Widget | Purpose |
|---|---|
| `Pressable` | Platform-aware spring scale feedback |
| `HoldToConfirmButton` | 1.5-second hold confirmation with red fill; optional `fontSize` for action-style labels |
| `AppActionButton` | Primary/secondary screen actions (`filled`, `outlined`, `text`) |
| `MinimoLoader` | Hand-drawn rotating loader, including compact action-button progress |
| `AppSnackBar` | Success, error, and instruction messages |
| `FadedScrollView` | Clamped scroll with static alpha-only edge fading |
| `showAppSheet` / `showAppContentSheet` | Modal sheets with shared drag handle and scroll-to-drag dismissal |
| `AppOptionPicker` | Compact option selection |
| `AnimatedAssetCheckbox` | Custom settings checkbox |

`AppActionButton` text variant is for chrome icons without border or fill. Compact icon-only buttons are typically `47×47`; compression back and add-video use the same outlined variant.

## Motion Rules

- Respect `MediaQuery.disableAnimations` where applicable.
- `RollingCounterText` animates only when its formatted text changes. Counter rolls use a short, low-bounce curve; equal rounded values remain static.
- Current video progress is static red text, not a pulsing indicator.
- Video import uses the compact `MinimoLoader` inside the disabled Compress button.
- Disabled `AppActionButton` labels and icons use a high-contrast `onSurface` foreground over the shared gray background.
- Hold progress fills left-to-right while the whole button uses `Pressable` scaling.
- Duplicate `AppSnackBar` messages shake the existing snackbar, bring it to the front, and reset its timer instead of adding another copy.
- Avoid Material splash/highlight fills; the app uses scale feedback instead.

---

[Back to SKILLS.md](../../SKILLS.md)
