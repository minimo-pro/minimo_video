# Architecture

## Structure

```text
lib/
├── main.dart
├── router/                 # auto_route configuration and generated routes
├── screens/                # splash, onboarding, start, settings, info
├── features/compression/
│   ├── bloc/               # events, state, orchestration
│   ├── data/               # compressor and platform file adapters
│   ├── domain/             # settings, picked video, result models
│   └── presentation/       # compression screen and widgets
├── services/               # settings, cache, thermal state, first launch
├── theme/                  # light/dark colors and ThemeData
├── widgets/                # shared controls
├── l10n/                   # source ARB files
└── generated/              # generated localization code
```

Native integration lives in:

- `ios/Runner/SceneDelegate.swift`
- `android/app/src/main/kotlin/com/example/minimo_video/MainActivity.kt`

## Compression State Flow

```text
CompressScreen
  → CompressBloc
    → VideoCompressorAdapter
      → light_compressor_v2
        → native Android/iOS codecs
```

`CompressBloc` owns the selected batch, settings, estimates, status per video, compression progress, cancellation, results, saving, and deletion. `CompressScreen` owns import progress so Bloc settings can change while native picking/copying is still pending. `CompressVideosAdded` appends completed imports only while the Bloc is `ready`, extends the aligned thumbnail/status lists, and schedules fresh thumbnails and an estimate without resetting settings. `CompressResultsSaved` receives selected source identifiers from the save sheet and deletes them only after all outputs save. Videos are compressed sequentially. Overall progress is weighted by input file size.

## Platform Channel

Channel: `minimo_video/videos`

| Method | Purpose |
|---|---|
| `pickVideos` | Open gallery or files picker (`source`) and copy selected videos to cache |
| `deleteOriginals` | Request explicit system deletion of source assets |
| `videoInfo` | Read duration for size estimates |
| `createThumbnail` | Generate cached JPEG preview |

Channel `minimo_video/thermal` exposes `currentState` for overheating warnings.

## File Lifecycle

1. The start screen chooses a source and routes immediately to `CompressScreen`, which opens the native picker. Add-more uses the same picker from `ready`.
2. Picker copies selected files into temporary `picked_videos` storage while settings remain interactive and the Compress button reports import progress. Completed picks are appended to the current batch.
3. Compressor writes MP4 output into temporary `minimo_video` storage.
4. Output saving uses `gal`; sharing uses `share_plus`.
5. Outputs saving less than 10% are deleted and marked skipped.
6. App and compressor temporary files are cleared on every cold start.

## Generated Files

Do not edit these manually:

- `lib/router/app_router.gr.dart`
- `lib/generated/l10n.dart`
- `lib/generated/intl/*`

---

[Back to SKILLS.md](../../SKILLS.md)
