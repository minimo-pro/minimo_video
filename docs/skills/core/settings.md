# Settings and Local Storage

Settings use `shared_preferences` through `AppSettingsService`.

| Key | Type | Default | Purpose |
|---|---|---:|---|
| `add_kompresso_prefix` | `bool` | `true` | Prefix output filenames with `minimo_` |
| `show_overheat_warning` | `bool` | `true` | Show thermal warning during compression |
| `save_videos_to_album` | `bool` | `false` | Save into gallery album `Minimo` |
| `language_code` | `String?` | system | Override locale with `en` or `ru` |
| `dark_theme` | `bool?` | system | Override system theme after user selection |
| `onboarding_completed` | `bool` | `false` | Skip onboarding after completion |

## Cache

`AppCacheService` manages two temporary directories:

- `picked_videos` — picker copies
- `minimo_video` — compressed outputs waiting for save/share

The settings screen clears both directories and the compressor plugin cache. `main()` performs the same full cleanup on every cold start because compression sessions are not restored after relaunch.

## Compression Settings

Compression choices are session state, not persistent preferences:

| Field | Default |
|---|---|
| `crf` | `28` (internal preset selector) |
| `resolution` | `1280:720` |
| `audioMode` | stereo |

---

[Back to SKILLS.md](../../SKILLS.md)
