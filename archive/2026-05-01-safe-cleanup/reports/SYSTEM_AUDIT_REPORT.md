# System Audit Report

Date: 2026-03-29
Workspace: `d:\Dwight\Capstone Main`

## Scope

This audit cycle covered pre-deployment hardening and validation across security-sensitive and cross-platform release surfaces:

- Backend credential and migration safety.
- Android package/test namespace readiness.
- GitHub release workflow secret binding reliability.
- Build/test/runtime verification for frontend and backend.
- Documentation synchronization for architecture and capstone/system references.

## Key Improvements Implemented

1. Seeder credential hardening
- File: `DasiaAIO-Backend/seed.js`
- Removed hardcoded production database connection string.
- Seeder now requires `DATABASE_URL` from environment and exits fast when missing.
- Added optional SSL mode control through `DATABASE_SSL_MODE` (`require` or `no-verify`) to support controlled local/prod behavior.

2. Password-reset migration schema alignment
- File: `DasiaAIO-Backend/migrations/add_password_reset_tokens.sql`
- Corrected `user_id` type to `VARCHAR(36)` to match `users.id`.
- Added `ON UPDATE CASCADE` to foreign key behavior.
- Standardized timestamp columns to `TIMESTAMPTZ` for timezone-safe behavior.

3. Android namespace/test drift correction
- Files:
  - `apps/android-capacitor/android/app/src/test/java/com/sentinel/app/ExampleUnitTest.java`
  - `apps/android-capacitor/android/app/src/androidTest/java/com/sentinel/app/ExampleInstrumentedTest.java`
- Removed stale `com.getcapacitor.myapp` test package path and replaced with `com.sentinel.app`.
- Updated instrumentation assertion to `com.sentinel.app` so package checks align with current `applicationId`.

4. Release workflow secret resolution hardening
- File: `.github/workflows/release.yml`
- Replaced indexed secret indirection with direct secret references:
  - `secrets.SENTINEL_ANDROID_KEYSTORE_BASE64`
  - `secrets.SENTINEL_UPLOAD_STORE_PASSWORD`
  - `secrets.SENTINEL_UPLOAD_KEY_ALIAS`
  - `secrets.SENTINEL_UPLOAD_KEY_PASSWORD`
- This removes brittle expression indirection and makes required secret contracts explicit.

## Verification Results

Frontend:

- Command: `npm test --prefix "d:\Dwight\Capstone Main\DasiaAIO-Frontend" -- --runInBand`
- Result: PASS (`1/1` suite, `5/5` tests).

- Command: `npm run build --prefix "d:\Dwight\Capstone Main\DasiaAIO-Frontend"`
- Result: PASS (Vite production build successful).

Backend:

- Command: `cargo test --manifest-path "d:\Dwight\Capstone Main\DasiaAIO-Backend\Cargo.toml"`
- Result: PASS (`2/2` integration tests, no failures).

- Command: `docker compose config -q` (in `DasiaAIO-Backend`)
- Result: PASS.

- Command: `docker compose up -d` (in `DasiaAIO-Backend`)
- Result: PASS (`guard-firearm-backend` running, `guard-firearm-postgres` healthy).

- Endpoint: `GET http://localhost:5000/api/health`
- Result: PASS (`status: ok`, database up, websocket up).

## Constraints and Residual Risks

1. GitHub secret diagnostics in editor
- VS Code still reports contextual warnings for release secrets in workflow YAML when repository/organization secret metadata is not available to static validation.
- Runtime workflow behavior remains valid for configured repositories, but final assurance requires a live `workflow_dispatch` dry-run in GitHub Actions.

2. Android language-server classpath warnings
- Java files under Android module still report local IDE classpath warnings in this workspace configuration.
- File/package alignment is now correct; full certainty requires Android Gradle test invocation inside Android Studio/CI.

3. Stale diagnostic from deleted legacy workflow
- Workspace diagnostics still reference removed `.github/workflows/release-artifacts.yml` as a deleted-file warning.
- This is an editor state artifact, not an active runtime workflow.

## Recommended Next Steps

1. Execute one manual `workflow_dispatch` run on `.github/workflows/release.yml` to verify secret materialization and signed Android artifact output end-to-end.
2. Add a CI lint stage for workflow validation and markdown/doc drift checks.
3. Add Android wrapper CI smoke tests (`assembleDebug` and package assertion) to prevent future namespace regressions.
