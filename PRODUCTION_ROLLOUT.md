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

Set these environment variables (or Gradle properties) before release signing:

- SENTINEL_UPLOAD_STORE_FILE
- SENTINEL_UPLOAD_STORE_PASSWORD
- SENTINEL_UPLOAD_KEY_ALIAS
- SENTINEL_UPLOAD_KEY_PASSWORD

If these are missing, release builds are generated as unsigned artifacts.

### 3.2 Desktop signing (recommended)

Code-sign MSI installers with your organization certificate to reduce SmartScreen friction.

## 4. Local Release Commands

From repository root:

1. Web release build
   - npm run release:web

2. Desktop installer release build
   - npm run release:desktop

3. Android release build
   - npm run release:android

4. Build all targets
   - npm run release:all

## 5. Artifact Output Paths

### Desktop

- apps/desktop-tauri/src-tauri/target-release/release/bundle/msi/SENTINEL_1.0.0_x64_en-US.msi

### Android

Unsigned (default if signing vars are not set):

- apps/android-capacitor/android/app/build/outputs/apk/release/app-release-unsigned.apk

Signed (if signing vars are set):

- apps/android-capacitor/android/app/build/outputs/apk/release/app-release.apk

## 6. CI/CD Release Workflow

GitHub Actions workflow:

- .github/workflows/release-artifacts.yml

Trigger modes:

1. Manual workflow dispatch with api_base_url input
2. Git tag push matching v*

Outputs:

- Desktop MSI artifact
- Android signed APK artifact when signing vars are configured, otherwise unsigned APK artifact

When triggered by a tag push matching `v*`, the workflow also publishes both files to the GitHub Release for that tag so users can download from the repository Releases page.

Download location after release job finishes:

- `https://github.com/Cloudyrowdyyy/Capstone-Main/releases`

## 7. Final Production Checklist

1. Confirm production API URL is correct for all target builds.
2. Build and publish desktop MSI.
3. Build signed Android release (APK/AAB for distribution/store).
4. Smoke test login and key workflows in web, desktop, and mobile.
5. Verify all clients read/write the same production backend data.
6. Keep release notes with app version and backend commit hash.

## 8. Security Notes

- Production Capacitor config now disables cleartext and mixed-content by default when CAPACITOR_ENV=production or NODE_ENV=production.
- Keep TLS-only API endpoints in production.
- Do not commit keystore files or signing passwords.
