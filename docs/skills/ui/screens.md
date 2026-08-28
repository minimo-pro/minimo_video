# Screens and Navigation

Routes use `auto_route` with fade transitions.

| Route | Responsibility |
|---|---|
| `SplashRoute` | Resolve first-launch destination |
| `OnboardingRoute` | Explain local selection, quality, and privacy |
| `StartRoute` | Choose gallery or files, select one or more videos, show store update and changelog prompts |
| `CompressRoute` | Add more videos, configure, run, cancel, save, share, or delete originals |
| `SettingsRoute` | Filename prefix, thermal warning, save/delete defaults, album, cache, language |
| `InfoRoute` | App/version information, rating, sharing, and external links |

Settings, info, comparison, and save sheets use fixed-height `showAppSheet` routes via `stupid_simple_sheet`. Compact menus — video source pick and changelog — use content-sized `showAppContentSheet` so Android does not stretch a short action list to a tall fraction of the screen. Both helpers show the shared top drag handle by default. Swiping down at the top of a nested list dismisses the sheet; while the list can scroll, the same gesture scrolls it. Do not wrap sheet content in a custom `ScrollConfiguration` — the package needs Flutter's default scroll behavior for the scroll-to-drag handoff.

## Compression Screen Modes

The screen renders from `CompressStatus`:

- `ready` → simple/advanced settings and a bottom action row with add-more and compress
- `processing` → size estimate, overall progress, current-file percentage, status list, hold-to-cancel
- `done` → results, saved space, and compact post-compression actions

Before the initial picker confirms a non-empty selection, `CompressScreen` shows `VideoLoadingView` rather than empty video/settings placeholders. Picker cancellation returns to `StartRoute`; the settings UI appears on the initial `pickProgress` event and stays interactive for the remaining import.

### Navigation chrome

`CompressScreen` owns the top-left icon-only back button for `ready` and `done`. It uses the `AppActionButton` text variant (no border or fill). Navigation chrome is hidden during `processing`; back is disabled while picked videos are copied into cache.

In `ready`, scrolling the main size row out of view pins a compact size summary beside the back button. The summary matches the button's `47`-pixel height and keeps the savings percentage right-aligned without a separate frame or fill. Settings changes keep the previous estimate visible until the refreshed native estimate arrives, preventing a transient no-savings hint and compress-button flicker. A genuine `0%` estimate still shows the no-savings hint and disables compression.

During `processing` and file copying, `PopScope(canPop: false)` blocks route pops, including Android system back and the iOS edge-swipe gesture. Hold-to-cancel is the only exit from processing back to settings; copying must finish or fail before navigation resumes.

### Done-screen actions

On a successful result:

| Placement | Actions |
|---|---|
| Bottom row | `VS` compare, filled primary save, icon-only share |
| Save sheet | Per-video delete selection before saving; unavailable originals are greyed out and long lists fade at scroll edges |

Failed compression replaces save with retry and disables `VS`. Already-optimized results keep `VS` disabled without a primary filled action.

`CompressionBottomActions` places an outlined icon-only plus button and the filled Compress button in the same bottom row. During initial or add-more import, settings remain interactive while add/back are disabled and Compress shows a spinner plus batch progress. When import completes, selected videos, thumbnails, and estimates refresh without resetting settings.

Simple presets are the primary UX. Advanced mode exposes resolution, video
bitrate, frame rate, H.264/HEVC codec, and audio controls.
The advanced list leaves extra scroll space after the final audio control.
The selected-video count badge stays inside the preview bounds so the scroll viewport never clips its circular top edge.

## Hold-to-confirm Actions

`HoldToConfirmButton` is used for destructive or interrupting actions:

- Clear cache
- Cancel compression
- Delete originals

A short tap shows a snackbar explaining that the button must be held. Delete originals is reached from the done-screen more sheet, not the persistent bottom row.

---

[Back to SKILLS.md](../../SKILLS.md)
