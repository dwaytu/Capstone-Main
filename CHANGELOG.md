# Changelog

All notable changes to SENTINEL are documented in this file.

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

