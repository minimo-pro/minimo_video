# Changelog

## In-App Changelog

`ChangelogService` stores a local versioned changelog map in Dart. Keys are semantic versions, language keys use the `Language` enum, and version comparisons use `pub_semver`.
The app never fetches changelog content remotely.

Current release: `1.3.2+42`. The root and in-app changelogs cover lower memory usage when importing large videos. In-app notes are available in all 13 languages.

## Seen Version

`last_seen_version` is stored in `shared_preferences`. First install is skipped and saves the current version. Existing users without `last_seen_version` are treated as update users and can see bundled entries up to the current version.

`unseenChanges()` returns every entry where:

```text
lastSeen < entryVersion <= current
```

so users jumping multiple releases see all unseen changes.

## UI

`StartPage` waits for the upgrader check to finish (and for any
`UpgradeAlert` prompt to be dismissed) before showing the changelog sheet.
`UpgradeAlert` is built with `material_ui`, so `MainApp` uses `MaterialApp`
and `GlobalMaterialLocalizations.delegates` from that package.
If unseen changes exist, `showChangelogDialog()` presents a content-sized
`stupid_simple_sheet` (scroll-to-drag dismiss). Long change lists use the
shared `FadedScrollView` to show scroll-edge fading. Dismissing the sheet
marks the current version as seen.

`InfoScreen` also links to the bundled notes for the current app version, so
users can reopen “What’s new” after the automatic sheet has been dismissed.

## Release Checklist

- Update root `CHANGELOG.md` and group entries under category headings such as `### Added`.
- Add a local `_changelog` entry for every app version.
- Add release notes for every supported language. Historical missing translations fall back to English.

---

[Back to SKILLS.md](../../SKILLS.md)
