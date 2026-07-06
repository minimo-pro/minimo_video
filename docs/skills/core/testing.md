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
- Compression estimate formula and audio contribution
- Minimum 10% output-savings policy
- Batch status transitions and mixed success/skipped results
- Cancellation state reset and compressor cancellation call
- Weighted overall progress, current-file progress, and stale-event rejection
- Saving and original deletion through source identifiers
- Compression failure state
- Cache size and full cleanup
- Preview styling, status percentage, press motion, and hold-button background

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

Simulator tests are insufficient for codec, thermal, and real Photos/MediaStore behavior.

---

[Back to SKILLS.md](../../SKILLS.md)
