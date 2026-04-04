# SENTINEL Production Rollout Guide

This runbook covers a true production rollout for web, desktop, and mobile using one production backend.

## 1. Production Architecture

- Web client: Railway-hosted frontend
- Desktop client: Tauri MSI installer
- Mobile client: Capacitor Android release APK/AAB
- Backend API + DB: Railway backend service

All clients must use the same API base URL in production.

Current production API URL:

- https://backend-production-0c47.up.railway.app

## 2. Integration With Existing Railway Web

Yes, production desktop and mobile integrate with your currently live Railway web deployment if they all point to the same backend API URL.

Integration rules:

1. Keep one canonical production API URL for all platform builds.
2. Keep backend CORS policy aligned to web + desktop/mobile origins as required.
3. Validate auth/session behavior across all three clients after each release.

## 3. One-Time Release Preparation

### 3.1 Android signing secrets

For the governed repository release workflow (`.github/workflows/release.yml`), configure these GitHub Actions secrets:

- SENTINEL_ANDROID_KEYSTORE_BASE64
- SENTINEL_UPLOAD_STORE_PASSWORD
- SENTINEL_UPLOAD_KEY_ALIAS
- SENTINEL_UPLOAD_KEY_PASSWORD

`scripts/setup-android-signing.ps1` generates the keystore and prints the exact secret values needed for GitHub Actions. During CI, the workflow decodes the keystore into a temporary file and fails the Android job if any signing secret is missing. There is no unsigned Android fallback in the release workflow.

### 3.2 Desktop signing (recommended)

Code-sign MSI installers with your organization certificate to reduce SmartScreen friction.

## 4. Local Release Commands

From repository root:

Required env vars before release commands:

- `VITE_API_BASE_URL` (must be HTTPS production backend URL)
- `VITE_APP_VERSION` (semantic version, for example `v1.2.3`)

For local signed Android release builds, also provide:

- `SENTINEL_UPLOAD_STORE_FILE`
- `SENTINEL_UPLOAD_STORE_PASSWORD`
- `SENTINEL_UPLOAD_KEY_ALIAS`
- `SENTINEL_UPLOAD_KEY_PASSWORD`

CI materializes `SENTINEL_UPLOAD_STORE_FILE` from `SENTINEL_ANDROID_KEYSTORE_BASE64`; local builds must provide the keystore path directly.

1. Web release build
   - npm run release:web

2. Desktop installer release build
   - npm run release:desktop

3. Android release build
   - npm run release:android

4. Build all targets
   - npm run release:all

## 5. Artifact Output Paths

### Web

- `sentinel-web-dist.tar.gz` (GitHub Actions artifact + Release asset on `v*` tags)

### Desktop

- apps/desktop-tauri/src-tauri/target-release/release/bundle/msi/SENTINEL_1.0.0_x64_en-US.msi
- apps/desktop-tauri/src-tauri/target-release/release/bundle/nsis/SENTINEL_1.0.0_x64-setup.exe

### Android

Local signed Gradle outputs:

- apps/android-capacitor/android/app/build/outputs/apk/release/app-release.apk
- apps/android-capacitor/android/app/build/outputs/bundle/release/app-release.aab

Governed release assets after renaming:

- release-files/sentinel-android-v<version>.apk
- release-files/sentinel-android-v<version>.aab

## 6. CI/CD Release Workflow

GitHub Actions workflow:

- .github/workflows/release.yml

Trigger modes:

1. Manual workflow dispatch with required `release_version` and `api_base_url` inputs
2. Git tag push matching v*

Execution path:

- `prepare` resolves release metadata and notes
- `quality-gate` runs frontend and backend tests
- `web`, `desktop`, and `android` build in parallel after the gate passes
- `android` materializes the keystore from Actions secrets, validates with `:app:assembleDebug`, then produces signed `:app:assembleRelease` and `:app:bundleRelease` outputs

Outputs:

- Web release tarball
- Desktop MSI and NSIS EXE artifacts
- Android signed APK and signed AAB artifacts

Publication behavior:

- Tag-triggered runs publish assets to the GitHub Release for the matching version
- Manual dispatch runs validate artifact generation but skip the publish job

Observed live validation: successful manual run `23929317544` completed `Prepare Release Metadata`, `Quality Gate`, `Build Web Artifact`, `Build Desktop Artifacts`, and `Build Android Artifacts`; `Publish GitHub Release` was skipped because the run was not tag-driven.

Download location after release job finishes:

- `https://github.com/dwaytu/Capstone-Main/releases`

## 7. Final Production Checklist

1. Confirm production API URL is correct for all target builds.
2. Ensure release env vars are set before running release commands (`VITE_API_BASE_URL`, `VITE_APP_VERSION`).
3. Confirm all four Android signing secrets are configured in GitHub Actions before governed releases.
4. Build and publish desktop installers.
5. Build signed Android release artifacts (APK and AAB).
6. Smoke test login and key workflows in web, desktop, and mobile.
7. Verify all clients read/write the same production backend data.
8. Keep release notes with app version and backend commit hash.

## 8. Rollback Procedures

### Web (Railway)

Railway retains previous deployments. To roll back:

1. Open the Railway dashboard for the frontend or backend service.
2. Select **Deployments** and click the last known-good deployment.
3. Click **Redeploy** to restore the previous version.

Alternatively, revert the git commit and push to trigger a new Railway build from the previous state.

### Desktop (Tauri)

Desktop installers are self-contained. To roll back:

1. Uninstall the current version.
2. Download the previous MSI or EXE from GitHub Releases (`https://github.com/dwaytu/Capstone-Main/releases`).
3. Install the previous version.

The Tauri native updater is currently disabled (`updater.active = false` in `tauri.conf.json`), so users will not receive automatic update prompts. Version awareness is handled by the frontend via `GET /api/system/version` with a manual download flow.

### Android

To roll back a sideloaded APK:

1. Uninstall the current version from the device.
2. Download the previous APK from GitHub Releases.
3. Install the previous APK.

### Backend (Railway)

1. Identify the last healthy commit hash.
2. In Railway, redeploy from that commit or use `git revert` and push.
3. Verify with `GET /api/health` after redeployment.

### Database

Database migrations run forward-only on backend startup (`db.rs`). If a migration introduces a breaking change:

1. Take a manual PostgreSQL backup before deploying schema changes.
2. Restore from backup if rollback is required.
3. Railway PostgreSQL supports point-in-time recovery if enabled on your plan.

## 9. Security Notes

- Production Capacitor config now disables cleartext and mixed-content by default when CAPACITOR_ENV=production or NODE_ENV=production.
- Keep TLS-only API endpoints in production.
- Do not commit keystore files or signing passwords.
- Governed Android releases are signed-only; do not treat unsigned local test artifacts as production-distribution outputs.
