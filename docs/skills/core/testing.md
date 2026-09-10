# Testing

Run local checks with:

```bash
flutter analyze
flutter test
git diff --check
```

## Automated Coverage

Current tests cover:

- Quality preset mapping to internal tier and resolution
- Appending only new picked videos while preserving settings and aligned batch state
- Custom bitrate estimate fallback and exact bitrate/FPS/codec encode-plan mapping
- Automatic bitrate response to resolution, effective FPS, and codec
- Invalid configured/source frame-rate handling
- HEVC-to-H.264 fallback notice on the result screen
- Minimum 10% output-savings policy
- Batch status transitions and mixed success/skipped results
- Cancellation state reset and compressor cancellation call
- Weighted overall progress, current-file progress, and stale-event rejection
- Saving and original deletion through source identifiers
- Private-picker metadata payload mapping, fallback save forwarding, and separate metadata/delete capabilities
- Beside-original enabled while replace-original stays disabled for an inaccessible Limited Photos asset
- Compression failure state
- Cache size and full cleanup
- Preview styling and count-badge bounds, status percentage, press motion, and hold-button background
- Rolling counters ignore unchanged formatted values and use calm motion
- Previous estimate retained while a settings estimate refreshes
- Initial estimate keeps the original size visible until native calculation completes, avoiding an optimistic size reversal
- Add-more and compress actions sharing the settings bottom row
- Repeated video-source requests reuse one open bottom sheet, and selection returns only after its closing transition
- Import progress digit changes do not move the loader inside the Compress button
- Intermediate pre-selection loader, confirmed exit cancels the pending native import, no empty-settings flash after picker cancellation, then interactive settings with preview/button loaders, hidden zero-byte estimates, and safe completion during active scrolling
- Screen stays awake during import and compression when `prevent_screen_sleep` is enabled
- Compact icon-only `AppActionButton` layout for wide SVG assets (`arrow_back`, `share`, `more`)

## Test Boundaries

Flutter tests use fake compressor/file adapters. They do **not** execute native codecs, Photos, MediaStore, gallery saving, or platform permission dialogs.

Do not mock private helpers or test generated code. Prefer behavior through `CompressBloc`, public adapters, and rendered widgets.

## Required Physical-device Checks

Native behavior needs focused manual checks when compression or platform code changes:

- Portrait and landscape-recorded MOV/MP4 inputs produce visible video and synchronized audio
- High, medium, and low outputs play on the source device
- Audio removal produces silent video
- Current-file and overall progress advance correctly
- Cancellation stops work and leaves no usable partial result
- Already optimized input is skipped when savings are below 10%
- Save, share, and delete-original flows show expected system UI
- Multi-select preserves filenames and handles duplicate names
- Adding videos from both gallery and files during configuration preserves the existing batch and settings, refreshes previews/estimate, and reports copy progress
- With Limited Photos access, choose a video outside the app's allowed
  selection through `PHPicker`: beside-original preserves its embedded capture
  date/GPS without a broader permission prompt, while replace-original stays
  disabled
- With a fully accessible Photos asset, capture date, location, writable album
  membership, favorite state, and replacement/deletion behavior remain intact

Simulator tests are insufficient for codec, thermal, and real Photos/MediaStore behavior.

---

[Back to SKILLS.md](../../SKILLS.md)
