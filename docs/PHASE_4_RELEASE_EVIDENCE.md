# SENTINEL Phase 4 Release Evidence

**Date:** 2026-09-16  
**Phase:** Platform Release Confidence  
**Status:** Complete for the current local source; the post-fix route change still requires the next commit/release.

## Objective Coverage

| Requirement | Evidence | Result |
|---|---|---|
| MAP-01 | `npm run audit:phase4`; command and guard map surfaces tested on desktop and mobile; `mapTileUrls` tests cover both themes | PASS |
| MAP-02 | Authenticated `map-data` and `active-guards` checks returned valid `200` payloads for superadmin and guard roles | PASS |
| REL-01 | Production web gate, Android/Capacitor build, desktop/Tauri build, and governed GitHub release evidence | PASS |

## Local Verification

- `npx tsc --noEmit`: PASS.
- `npm test -- --runInBand`: PASS, 29 suites and 131 tests.
- `npm run release:web`: PASS. Production environment gate accepted `https://backend-production-0c47.up.railway.app` and `v1.2.2`.
- `npm run build:android`: PASS. Vite mobile bundle built and `npx cap sync android` completed with four Capacitor plugins.
- `npm run build:desktop`: PASS. Tauri application and Windows installers built:
  - `apps/desktop-tauri/src-tauri/target/release/bundle/msi/SENTINEL_1.0.0_x64_en-US.msi`
  - `apps/desktop-tauri/src-tauri/target/release/bundle/nsis/SENTINEL_1.0.0_x64-setup.exe`

## Browser Map Audit

Command:

```text
cd DasiaAIO-Frontend
npm run audit:phase4
```

Results:

- Superadmin desktop: map `966x382`, 10 tiles, tracking endpoints `200/200/200`.
- Superadmin mobile: map `268x318`, 4 tiles, tracking endpoints `200/200/200`.
- Guard desktop: map `990x676`, 20 tiles, `map-data` and `active-guards` `200`; client-site management endpoint correctly `403`.
- Guard mobile: map `356x620`, 12 tiles, `map-data` and `active-guards` `200`; client-site management endpoint correctly `403`.
- All four runs had zero page errors, unexpected console errors, failed requests, API errors, or horizontal overflow.
- Elevated command map theme toggle changed and restored the root theme state. Guard map uses the shared theme-aware map tile component and inherits the device/application theme; guard mode intentionally does not expose the elevated-role theme toggle.

## Defect Fixed During Phase 4

Direct navigation to `/operations-map` was classified as a non-operational-shell route, so the dashboard rendered instead of the requested map. The route is now included in `AppShell`'s operational-shell view set. The fix is covered by the browser audit and all frontend regression checks.

## Governed Release Evidence

GitHub Actions release workflow run `34926862284` completed successfully for `v1.2.2` on 2026-09-15. The published release contains:

- web archive
- Windows `.exe` installer
- Windows `.msi` installer
- signed Android `.apk`
- signed Android `.aab`

The local post-fix builds prove that the current source remains buildable for all targets. The route fix has not yet been committed or included in a new published release; that is the remaining release step before client rollout.

## Known Non-Blocking Warnings And Boundaries

- Vite reports existing mixed static/dynamic import warnings for `config.ts` and `api.ts`; builds still complete successfully.
- A browser cannot prove physical GPS accuracy. Real-device Android GPS and background tracking remain separate device acceptance checks.
- Production rollout still requires the governed workflow, configured Railway CORS/notification values, database backup/rollback readiness, and signed Android secrets.
