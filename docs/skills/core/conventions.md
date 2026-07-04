# Development Conventions

## Generated Code

Never edit these files manually:

- `lib/router/app_router.gr.dart`
- `lib/generated/l10n.dart`
- `lib/generated/intl/messages_all.dart`
- `lib/generated/intl/messages_en.dart`
- `lib/generated/intl/messages_ru.dart`

After changing routes:

```bash
dart run build_runner build
```

After changing either ARB file:

```bash
dart run intl_utils:generate
```

Commit generated output together with its source change.

## Compression Changes

- Keep plugin-specific types inside `VideoCompressorAdapter`.
- Keep batch orchestration and user-visible state inside `CompressBloc`.
- Preserve run-ID checks; they prevent stale native events from mutating a new run.
- Never overwrite source files. Compression writes a separate temporary MP4.
- Preserve the 10% acceptance threshold unless product behavior explicitly changes.
- Keep simple presets primary; advanced controls must work on both platforms.

## Platform Changes

- Flutter calls native media operations only through channels documented in `architecture.md`.
- Return platform failures through `FlutterError`; never report destructive actions as successful silently.
- Media selection should remain privacy-preserving and avoid broad library permission.
- Deletion stays behind hold confirmation plus system authorization.

## UI Changes

- Reuse `AppTheme`, `CompressionUiColors`, and shared controls.
- Support both system themes.
- Respect reduced-motion settings for nonessential animation.
- User-visible text belongs in both ARB files.

## Validation

Every behavior branch or bug fix should leave one focused regression test where a reliable Flutter seam exists. Native codec behavior remains a physical-device check.

---

[Back to SKILLS.md](../../SKILLS.md)
