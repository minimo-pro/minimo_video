# Screens and Navigation

Routes use `auto_route` with fade transitions.

| Route | Responsibility |
|---|---|
| `SplashRoute` | Resolve first-launch destination |
| `OnboardingRoute` | Explain local selection, quality, and privacy |
| `StartRoute` | Choose gallery or files, select one or more videos, show store update and changelog prompts |
| `CompressRoute` | Configure, run, cancel, save, share, or delete originals |
| `SettingsRoute` | Filename prefix, thermal warning, album, cache, language |
| `InfoRoute` | App/version information, rating, sharing, and external links |

Settings and info are presented as 90%-height sheets via `stupid_simple_sheet` (`showAppSheet` in `lib/widgets/app_sheet.dart`). Swiping down at the top of a nested list dismisses the sheet; while the list can scroll, the same gesture scrolls it. Changelog and before/after comparison use the same route type. Compact action menus use content-sized sheets via `showAppContentSheet`. Do not wrap sheet content in a custom `ScrollConfiguration` — the package needs Flutter's default scroll behavior for the scroll-to-drag handoff.

## Compression Screen Modes

The screen renders from `CompressStatus`:

- `ready` → simple/advanced settings and full-width compress action
- `processing` → size estimate, overall progress, current-file percentage, status list, hold-to-cancel
- `done` → results, saved space, and compact post-compression actions

### Navigation chrome

`CompressScreen` owns the top-left icon-only back button for `ready` and `done`. It uses the `AppActionButton` text variant (no border or fill). Back is hidden during `processing`.

During `processing`, `PopScope(canPop: false)` blocks route pops, including Android system back and the iOS edge-swipe gesture. Hold-to-cancel is the only exit back to settings.

### Done-screen actions

On a successful result:

| Placement | Actions |
|---|---|
| Bottom row | Icon-only share, filled primary save, icon-only more |
| More sheet (`showAppContentSheet`) | Compare, hold-to-delete-originals |

Failed compression replaces save with retry and keeps the more menu. Already-optimized results keep the more menu without a primary filled action.

`CompressionBottomActions` on the settings screen is compress-only; back lives in the shared top chrome.

Simple presets are the primary UX. Advanced mode currently exposes only resolution and audio.

## Hold-to-confirm Actions

`HoldToConfirmButton` is used for destructive or interrupting actions:

- Clear cache
- Cancel compression
- Delete originals

A short tap shows a snackbar explaining that the button must be held. Delete originals is reached from the done-screen more sheet, not the persistent bottom row.

---

[Back to SKILLS.md](../../SKILLS.md)
