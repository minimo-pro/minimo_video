## [1.3.1]

### Fixed

* Fix importing videos with long filenames.

## [1.3.0]

### Added

* Preserve HDR when compressing on supported iPhones and iPads. The comparison shows HDR or HDR → SDR based on the actual output ([#58](https://github.com/minimo-pro/minimo_video/issues/58)).

### Changed

* Show social, email, and website links on the About screen as full-width buttons with lowercase labels and arrows.
* Update `light_compressor_v2` to 1.12.0 for HEVC Main10 HDR export ([upstream #29](https://github.com/Farid023/light_compressor_v2/issues/29)). Android and unsupported iOS devices convert HDR to SDR.
* Update `upgrader` to 14.0.0. UI code imports Material from `material_ui`, and `MaterialUiCompatibilityBridge` keeps `stupid_simple_sheet` and `rate_my_app` on the legacy Material theme.

## [1.2.0]

### Added

* Add a hand-drawn Threads icon linking to [@khlebobul](https://www.threads.com/@khlebobul) from About.
* Continue importing videos selected from the gallery or Files in the background on Android and supported iOS devices, with system progress and cancellation ([#67](https://github.com/minimo-pro/minimo_video/issues/67)).
* iOS 26+: request a CPU-only continued-processing task for each picker import. Older iOS versions or denied admission use limited background time; expiration cancels the import.
* Android: keep imports running through a dataSync foreground service with a progress notification, cancellation, and a CPU wakelock.

### Changed

* Refresh onboarding with animated video cards, staggered fade-and-rise transitions, swipe-linked progress segments, and trailing icons on Next and Get started. Reduced motion keeps components static.

### Notes

* Force-quitting the app does not resume imports. Share Sheet and Shortcuts inbox imports retain their existing behavior.

## [1.1.1]

### Added

* Share your compressed video count and saved space from the statistics screen, with ready-to-post text and a link to minimo in all 13 supported languages ([#65](https://github.com/minimo-pro/minimo_video/issues/65)).

### Changed

* Replace `in_app_review` with `rate_my_app` for in-app rating requests ([#63](https://github.com/minimo-pro/minimo_video/issues/63)).
* Enable Android built-in Kotlin and update Android Gradle Plugin to 9.1.0, Kotlin Gradle Plugin to 2.4.0, and Gradle to 9.3.1.
* Update the CI Flutter version to 3.47.9 for the built-in Kotlin migration.

## [1.1.0]

### Added

* iOS 26+: continue video compression in the background on supported devices, with system progress, file count, and cancellation for the whole batch ([#60](https://github.com/minimo-pro/minimo_video/issues/60)).
* Keep foreground-only compression with current-video restart on older iOS versions or when background processing is unavailable.

## [1.0.16]

### Improved

* Increase the contrast of secondary text in the light theme.
* Show a loading indicator on the save button while videos are being saved.

## [1.0.15]

### Added

* Show an HDR badge on selected videos, a note that HDR will be converted to SDR, and an HDR → SDR label on the comparison sheet.
* Suggest minimo (photo) in a dismissible animated card at the top after successful video compressions, with separate counters and three-month cooldowns for the photo and rating prompts.

### Changed

* Update `light_compressor_v2` to 1.11.0.

### Fixed

* Avoid a crash when leaving the compression screen while the photo-app suggestion is visible.
* Keep video counts on one line inside the selection badge.
* Fixed [#54](https://github.com/minimo-pro/minimo_video/issues/54) (Android foreground service startup race) via light_compressor_v2 upgrade
* Android: compress iPhone HDR (Dolby Vision) videos on devices without a Dolby Vision decoder, and show their previews.
* HDR videos now compress to standard SDR (BT.709) instead of keeping HDR tags on 8-bit video, which caused banding or washed-out colours.
* iOS: non-AAC audio, such as the PCM audio many cameras write into `.mov`, is re-encoded to AAC instead of being copied uncompressed.

## [1.0.14]

### Added

* Added a link to minimo (photo) in Settings and About.

## [1.0.13]

### Added

* Select fractional video bitrates from 1 to 20 Mbps in 0.5 Mbps steps, including 1.5 Mbps ([#47](https://github.com/minimo-pro/minimo_video/issues/47)).

### Changed

* Preserve fractional bitrate values through settings, size estimates, and native compression; automatic bitrate no longer rounds to whole Mbps.
* Update `light_compressor_v2` to 1.10.0 for fractional bitrate support on Android and iOS.
* Compare original and compressed videos as aligned overlays with a draggable divider that reveals the result, full-frame portrait/landscape previews, and accessible reveal controls ([#10](https://github.com/minimo-pro/minimo_video/issues/10)).

## [1.0.12]

### Changed

* Automatically remove each batch’s temporary videos and previews after leaving the compression screen, once active operations finish. Gallery videos remain untouched ([#50](https://github.com/minimo-pro/minimo_video/issues/50), [#49](https://github.com/minimo-pro/minimo_video/issues/49)).
* Remove completed and partial outputs on cancellation while keeping imported videos available for retry ([#50](https://github.com/minimo-pro/minimo_video/issues/50)).

## [1.0.11]

### Changed

* Replaced bitrate preset buttons with a hand-drawn horizontal slider for every whole value from 1 to 20 Mbps, with a plain circular thumb, selection haptics, and a quick return to automatic.

## [1.0.10]

### Changed

* Updated app dependencies, including `auto_route` and `wakelock_plus`.

## [1.0.9]

### Added

* Added manual video bitrate options up to 20 Mbps.

## [1.0.8]

### Added

* Added local statistics for compressed videos and saved space ([#34](https://github.com/minimo-pro/minimo_video/issues/34)).

### Changed

* Restored the familiar High, Medium, and Low names for the basic compression presets.

## [1.0.7]

### Added

* Added iOS Shortcuts and iOS/Android Share Sheet imports with High, Medium, and Low preset routing ([#36](https://github.com/minimo-pro/minimo_video/issues/36)).

### Changed

* Moved the Quality, Balanced, and Smaller presets to the main compression settings.
* Moved bitrate and frame-rate controls to Advanced settings.
* Kept the previous size estimate dimmed during recalculation and updated it smoothly when ready.
* Redesigned the video import extension with clearer progress and completion states.

## [1.0.6]

### Added

* Preserved embedded capture date and GPS when saving videos selected through the private iOS picker, without requiring broader Photos access ([#37](https://github.com/minimo-pro/minimo_video/issues/37)).

### Fixed

* Kept the screen awake while selected videos are loading when the setting is enabled ([#3](https://github.com/minimo-pro/minimo_video/issues/3)).
* Allowed video selection to be retried immediately after leaving an import in progress ([#35](https://github.com/minimo-pro/minimo_video/issues/35)).
* Prevented duplicate video-source sheets and finished closing the sheet before opening the loading screen.
* Kept the import loader stationary while its progress counter changes.
* Replaced the loader's uneven geometry with a smooth centered arc.
* Prevented the initial compressed-size estimate from shrinking prematurely and then returning to the original size.

## [1.0.5]

### Added

* Added a What’s New link to the About screen for reopening the current release notes ([#32](https://github.com/minimo-pro/minimo_video/issues/32)).

### Changed

* Increased hold time for actions that require confirmation to 2.5 seconds and slowed their progress near completion ([#31](https://github.com/minimo-pro/minimo_video/issues/31)).
* Stacked simultaneous notifications vertically instead of overlapping them ([#30](https://github.com/minimo-pro/minimo_video/issues/30)).

## [1.0.4]

### Changed

* Clarified that replacing an original saves the compressed video before Photos asks to delete the original.
* Allowed leaving while selected videos are importing after a confirmation.

### Fixed

* Kept compression size estimates responsive for batches over 100 videos by cancelling stale estimate work and showing recalculation progress ([#28](https://github.com/minimo-pro/minimo_video/issues/28)).
* Prevented empty compression settings from flashing after cancelling the file picker.
* Fixed iOS temporary video copies accumulating outside the in-app cache counter and cleanup paths.

## [1.0.3]

### Added

* Added Spanish, Brazilian Portuguese, German, French, Simplified Chinese, Hindi, Dutch, Korean, Japanese, Italian, and Turkish translations ([#24](https://github.com/minimo-pro/minimo_video/issues/24)).

### Changed

* Made the language picker scrollable and showed every language by its native name.
* Redesigned the Simple/Advanced compression switch with clearer selection, spring feedback, accessibility semantics, and reduced-motion support.

## [1.0.2]

### Added

* Added import progress to the Compress button while cloud-backed or large videos load ([#22](https://github.com/minimo-pro/minimo_video/issues/22)).

### Changed

* Changed the save action to a disabled Saved state with a checkmark after successful saving ([#23](https://github.com/minimo-pro/minimo_video/issues/23)).
* Compression settings now stay interactive while selected videos import ([#22](https://github.com/minimo-pro/minimo_video/issues/22)).
* Kept the loading screen visible until video selection is confirmed, avoiding empty settings placeholders.
* Added scroll-edge fading to long in-app update notes.

## [1.0.1]

### Added

* Added advanced video bitrate, frame rate, and H.264/HEVC codec controls ([#5](https://github.com/minimo-pro/minimo_video/issues/5)).
* Added an H.264 notice when HEVC is unavailable on the device.
* Added explicit save-as-new, beside-original, and safe replacement modes on iOS with capture date, location, album membership, and favorite preservation where supported ([#6](https://github.com/minimo-pro/minimo_video/issues/6), [#1](https://github.com/minimo-pro/minimo_video/issues/1)).
* Added app sharing and store rating from the about screen.
* Added a review prompt after successful conversions with cooldown tracking.
* Added store update prompts and an in-app changelog after updates.
* Added before/after compressed video preview with split-screen playback ([#10](https://github.com/minimo-pro/minimo_video/issues/10)).
* Refreshed the app icons for light, dark, and Android themed variants.

### Fixed

* Matched compression size estimates to the native encoder configuration.
* Fixed portrait Android screen recordings being squeezed with reduced-resolution presets.
* Improved before/after preview scrubbing so frames update while dragging the timeline.
* Prevented repeated saves from replacing or deleting the same gallery video twice.
* Replaced technical save, delete, and share errors with user-friendly messages.
* Simplified Android saving to create a new gallery item immediately without replacement options.

## [1.0.0]

### Added

* Initial release
