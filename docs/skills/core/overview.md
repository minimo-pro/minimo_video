# Project Overview

**minimo (video)** is a Flutter app for private, on-device video compression on iOS and Android. Videos are never uploaded to a server.

## Current Capabilities

- Select one or multiple local videos
- High, medium, and low quality presets
- Manual resolution and audio controls
- Sequential batch compression with overall and per-video progress
- Hold-to-confirm cancellation and original deletion
- Save to the gallery, optionally into the `Minimo` album
- Share compressed files
- Light/dark system theme
- English and Russian localization

## Product Boundaries

- Portrait-only UI
- Native codecs through `light_compressor_v2`; no FFmpeg runtime
- Output is kept only when it is at least 10% smaller than the input
- Original files are untouched unless deletion is explicitly confirmed
- Advanced bitrate, frame-rate, codec, speed-preset, and metadata controls are not implemented

## Entry Points

| Purpose | File |
|---|---|
| App initialization | `lib/main.dart` |
| Routing | `lib/router/app_router.dart` |
| Main selection screen | `lib/screens/start_page.dart` |
| Compression feature | `lib/features/compression/` |
| Persistent settings | `lib/services/app_settings_service.dart` |

---

[Back to SKILLS.md](../../SKILLS.md)
