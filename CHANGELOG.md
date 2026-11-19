# Changelog

All notable changes to SENTINEL are documented in this file.

## [1.2.7] - 2026-11-19

### Changed
- Orders dated events in the operations and incident feeds from earliest to latest.
- Shows daily attended shift counts and spaces evaluation points by date.
- Shows actual evaluation coverage and labels saved capstone merit scores.
- Allows mission assignment without entering a destination.

### Security
- Updates the Vite build dependency to 7.3.7.


## [1.0.0] - 2026-03-29

### Added
- Unified release version orchestration across web, desktop, and Android pipelines.
- Tag-driven release workflow with deterministic artifact naming for every platform.
- In-app "What's New" modal to highlight release improvements after upgrades.

### Changed
- Android production identity updated to `com.sentinel.app` with signed release enforcement.
- Android `versionCode` now derives from semantic version for deterministic store uploads.
- Release notes generation now sources changelog entries for GitHub releases and in-app summaries.

### Security
- Release builds now fail fast when Android signing credentials are missing.

