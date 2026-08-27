## [Unreleased]

### Changed

* Removed remote changelog loading; update notes now come only from the app bundle.

## [1.0.1]

### Added

* Added advanced video bitrate, frame rate, and H.264/HEVC codec controls.
* Added an H.264 notice when HEVC is unavailable on the device.
* Added explicit save-as-new, beside-original, and safe replacement modes on iOS with capture date, location, album membership, and favorite preservation where supported.
* Added app sharing and store rating from the about screen.
* Added a review prompt after successful conversions with cooldown tracking.
* Added store update prompts and an in-app changelog after updates.
* Added before/after compressed video preview with split-screen playback.
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
