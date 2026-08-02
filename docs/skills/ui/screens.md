# Screens and Navigation

Routes use `auto_route` with fade transitions.

| Route | Responsibility |
|---|---|
| `SplashRoute` | Resolve first-launch destination |
| `OnboardingRoute` | Explain local selection, quality, and privacy |
| `StartRoute` | Choose gallery or files, select one or more videos, show store update and changelog prompts |
| `CompressRoute` | Add more videos, configure, run, cancel, save, share, or delete originals |
| `SettingsRoute` | Filename prefix, thermal warning, album, cache, language |
| `InfoRoute` | App/version information, rating, sharing, and external links |

Settings, info, comparison, and original-management sheets use fixed-height `showAppSheet` routes via `stupid_simple_sheet`. Compact menus — video source pick, post-compression more actions, and changelog — use content-sized `showAppContentSheet` so Android does not stretch a short action list to a tall fraction of the screen. Both helpers show the shared top drag handle by default. Swiping down at the top of a nested list dismisses the sheet; while the list can scroll, the same gesture scrolls it. Do not wrap sheet content in a custom `ScrollConfiguration` — the package needs Flutter's default scroll behavior for the scroll-to-drag handoff.

## Compression Screen Modes

The screen renders from `CompressStatus`:

- `ready` → simple/advanced settings and a bottom action row with add-more and compress
- `processing` → size estimate, overall progress, current-file percentage, status list, hold-to-cancel
- `done` → results, saved space, and compact post-compression actions

### Navigation chrome

`CompressScreen` owns the top-left icon-only back button for `ready` and `done`. It uses the `AppActionButton` text variant (no border or fill). Navigation chrome is hidden during `processing` and while picked videos are copied into cache.

During `processing` and add-more file copying, `PopScope(canPop: false)` blocks route pops, including Android system back and the iOS edge-swipe gesture. Hold-to-cancel is the only exit from processing back to settings; copying must finish or fail before navigation resumes.

### Done-screen actions

On a successful result:

| Placement | Actions |
|---|---|
| Bottom row | Icon-only share, filled primary save, icon-only more |
| More sheet (`showAppContentSheet`) | Compare, delete original |
| Original-management sheet | Per-video delete selection for multi-video results; unavailable originals are greyed out |

Failed compression replaces save with retry and keeps the more menu. Already-optimized results keep the more menu without a primary filled action.

`CompressionBottomActions` places an outlined icon-only plus button and the filled compress button in the same bottom row. The plus button opens the same gallery/files source sheet as `StartRoute`, appends selected videos, and refreshes thumbnails and the size estimate without resetting compression settings. Back remains in the shared top chrome.

Simple presets are the primary UX. Advanced mode currently exposes only resolution and audio.

## Hold-to-confirm Actions

`HoldToConfirmButton` is used for destructive or interrupting actions:

- Clear cache
- Cancel compression
- Delete originals

A short tap shows a snackbar explaining that the button must be held. Delete originals is reached from the done-screen more sheet, not the persistent bottom row.

---

[Back to SKILLS.md](../../SKILLS.md)
