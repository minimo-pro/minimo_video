# App Store Screenshots — Editor Template

A pre-built Next.js + ShadCN editor for generating App Store and Google Play screenshots. Scaffolded by the `app-store-screenshots` skill.

## Quick start

```bash
npm ci
npm run dev -- --port 3001   # http://localhost:3001
```

## What's inside

- **Connected canvas editor** (`src/components/editor/`) — every screen sits on one horizontal canvas, so phones, captions, and other elements can be dragged across screen boundaries and exported as split crops when Connected mode is enabled.
- **Screen controls** — drag-to-reorder screens, click-to-edit text, screenshot drop targets, per-screen layout switcher, dark/light toggle.
- **Device frames** (`src/components/editor/device-frames.tsx`) — iPhone (PNG mockup), iPad, Android phone, Android tablet (portrait + landscape), feature graphic.
- **Auto-save (git-trackable)** — every change is persisted within ~600ms to **`app-store-screenshots.json`** at the project root (via `/api/project`) **and** mirrored to `localStorage` as an instant-paint cache. Commit `app-store-screenshots.json` and you can `git clone` to another machine and resume exactly where you left off.
- **Multi-device decks** — iOS and Android slide decks live side by side; switching the platform tab preserves both.
- **One-click export** — bulk PNG export at any required App Store / Play Store resolution using `html-to-image`; each PNG is rendered from the current connected or isolated deck mode.
- **Project migration** — older `app-store-screenshots.json` files are migrated on load. Existing per-slide transforms remain valid, and connected crops become available without rewriting the deck by hand.
- **Legacy-safe mode** — pre-v2 projects opened directly in the editor start in isolated-screen mode first, then can opt into connected crops with the toolbar's Connected/Isolated control. Skill-run in-place migrations keep legacy decks isolated unless the project had already explicitly opted into connected canvas.

## Adding screenshots

Two ways:

1. **Drop a file in the inspector** — drag-and-drop or click Pick. The file is sent to `/api/upload`, hashed, and written to `public/screenshots/uploaded/<hash>.png`. The slide stores the resulting `/screenshots/uploaded/...` path, so commit those files alongside `app-store-screenshots.json` and the screenshots survive a `git clone`.
2. **Reference a static file** — put PNGs under `public/screenshots/{platform}/{device}/{locale}/` and reference them by path. Default sample slides expect:
   - `public/screenshots/apple/iphone/en/...`
   - `public/screenshots/android/phone/en/...`
   - `public/screenshots/apple/ipad/en/...`

Update the matching `screenshot` fields in `app-store-screenshots.json` to point at whatever filenames you choose.

## Exporting

The toolbar dropdown lists every Apple/Google-required size for the current device. Click **Export bundle** to download a zip. In Connected mode, each PNG is clipped from the connected canvas, so an element that straddles two screens appears split exactly where you placed it. In Isolated mode, each screen clips its own elements and legacy offscreen content cannot leak into neighboring exports.

## Customizing

| Where | What |
|-------|------|
| `src/lib/constants.ts` | Canvas dimensions, export sizes, frame ratios, themes, locales |
| `app-store-screenshots.json` | Canonical starter project: app name, current device, connected-canvas mode, slide copy, screenshots, and transforms |
| `src/lib/defaults.ts` | Fallback/reset state used when no project file or local cache exists |
| `src/components/editor/slide-canvas.tsx` | Add new layouts and connected-canvas element rendering |
| `src/components/editor/device-frames.tsx` | Tweak device chrome (bezel radii, camera dots) |
| `src/app/layout.tsx` | Swap the font (`next/font/google`) |

## Notes

- `mockup.png` is the iPhone bezel overlay; replacing it requires re-measuring the `PHONE_SCREEN` constants.
- Image preloading converts every static path to a base64 data URI before exports run, and export retries paths that were previously missing — this prevents the html-to-image race where some slide screenshots come out black.
- Reset via the toolbar's circular arrow icon clears in-memory state and reloads the default screens. To wipe disk state too, delete `app-store-screenshots.json`.
- **Persistence model** — the canonical state lives in `app-store-screenshots.json` (git-tracked). On load, the editor reads localStorage first for instant paint, then overwrites with the file contents if present; if the file endpoint is unavailable, autosave is blocked so stale cache cannot overwrite disk. On save, both are written. If you ever see a conflict, the file always wins.
- **Migration model** — schema v1 projects do not need a manual conversion. On first load, the editor upgrades localized text and transform records, writes `schemaVersion: 2`, preserves all existing screens, and keeps `connectedCanvas: false` so old offscreen/clipped elements export exactly as isolated screens. Turn on **Connected** in the toolbar when you want elements to cross screen edges. Explicit skill migrations preserve an existing `connectedCanvas` choice, otherwise they keep legacy decks isolated too.
- **Custom themes** — if a project file references a theme id that is not present in `src/lib/constants.ts`, the editor falls back to `clean-light` and shows a warning. Merge custom `THEMES` entries during in-place upgrades.

## Localized minimo screenshots

The saved decks cover every locale in `lib/l10n/intl_*.arb`: **en, de, es, fr, hi, it, ja, ko, nl, pt, ru, tr, zh**. Select the language in the editor toolbar. The original sky/Pangolin design is retained; translations fit within the existing composition. Unsupported Pangolin scripts use system fallback fonts.

Each locale has six slides for each of iPhone, iPad and Android, plus three store banners: **273 export PNGs** in total.

UI captures (`public/screenshots/`), comparison PNGs (`public/brand/compare*.png`) and finished exports (`export/`) are kept locally and ignored by Git. Keep these files when switching branches; a fresh clone needs the capture and export steps below. Decks, translations, editor code and generation scripts remain tracked.

| Asset | Size | Output directory |
|-------|------|------------------|
| iPhone | 1320 × 2868 | `export/apple/iphone-6.9/<locale>/` |
| iPad | 2064 × 2752 | `export/apple/ipad-13/<locale>/` |
| Android | 1080 × 1920 | `export/android/phone/<locale>/` |
| Apple header | 3840 × 1646 | `export/apple/header/<locale>/` |
| Apple search | 3840 × 2560 | `export/apple/search-results/<locale>/` |
| Play feature graphic | 1024 × 500 | `export/android/feature-graphic/<locale>/` |

Regenerate from the repository root on macOS (capture uses SFNS and Arial Unicode system fonts):

```bash
flutter test tool/store_screenshots/capture_test.dart
cd store_screenshots
node scripts/localize-decks.mjs
python3 -m pip install playwright Pillow
# Keep the dev server running in another terminal.
bash scripts/export-pngs.sh
```

The capture script defaults to the five UI screens used in the decks. To capture the other demo screens too, pass `--dart-define=STORE_SCREENSHOTS_ONLY=false` to `flutter test`. English exports use the existing flat directories (without an `en/` subdirectory). Other locales use the language subdirectories above, avoiding duplicate English PNGs.

Export or validate selected languages:

```bash
bash scripts/export-pngs.sh --locales ru ja
bash scripts/export-pngs.sh --check
```

`BASE` defaults to `http://localhost:3001`; `CHROME` can override the installed Chrome executable. The exporter waits for fonts/images, checks JavaScript errors and text overflow, then validates PNG dimensions, RGB mode and nonblank content.

Marketing translations live in `src/lib/store-copy.json`. `localize-decks.mjs` reads the app's locale list, fills labels/headlines/highlights/pills and preserves slide transforms. `seed-deck.mjs` also reapplies those translations after seeding. Native UI captures use the app's existing ARB translations. Comparison stickers are rendered from `/comparison?locale=...` before exporting the decks.

Read-only previews accept a language, for example `/preview?device=iphone&locale=ru&h=640&n=6` or `/creative?kind=play&locale=ja`.
