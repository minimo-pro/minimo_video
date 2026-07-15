# Screens and Navigation

Routes use `auto_route` with fade transitions.

| Route | Responsibility |
|---|---|
| `SplashRoute` | Resolve first-launch destination |
| `OnboardingRoute` | Explain local selection, quality, and privacy |
| `StartRoute` | Select one or more videos, show store update and changelog prompts |
| `CompressRoute` | Configure, run, cancel, save, share, or delete originals |
| `SettingsRoute` | Filename prefix, thermal warning, album, cache, language |
| `InfoRoute` | App/version information, rating, sharing, and external links |

Settings and info are presented as 90%-height draggable sheets with a drag handle and swipe-down dismissal.

## Compression Screen Modes

The screen renders from `CompressStatus`:

- `ready` → simple/advanced settings
- `processing` → size estimate, overall progress, current-file percentage, status list, cancellation
- `done` → results, saved space, save/share/delete actions

Simple presets are the primary UX. Advanced mode currently exposes only resolution and audio.

## Hold-to-confirm Actions

`HoldToConfirmButton` is used for destructive or interrupting actions:

- Clear cache
- Cancel compression
- Delete originals

A short tap shows a snackbar explaining that the button must be held.

---

[Back to SKILLS.md](../../SKILLS.md)
