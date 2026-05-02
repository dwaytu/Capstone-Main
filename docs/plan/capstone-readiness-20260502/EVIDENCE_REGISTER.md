# Evidence Register (2026-05-02)

## Status Legend

- `PASS` = validated and reproducible
- `PARTIAL` = implemented but incomplete evidence or partial platform coverage
- `FAIL` = broken flow or no implementation proof

## Evidence Table

| Evidence ID | Objective | Sub-Objective | Runtime | Scenario | Artifact Path | API/Log Ref | Result | Verified By | Verified At |
|---|---|---|---|---|---|---|---|---|---|
| E-001 | 13 | 13.a | Web | Frontend production build gate | `docs/plan/capstone-readiness-20260502/evidence/latest-readiness-report.md` | `frontend_build` | PASS | Codex | 2026-05-02 15:54 +08:00 |
| E-002 | 13 | 13.a | Backend | Backend compile gate | `docs/plan/capstone-readiness-20260502/evidence/latest-readiness-report.md` | `backend_cargo_check` | PASS | Codex | 2026-05-02 15:54 +08:00 |
| E-003 | 13 | 13.a | Backend | Backend test gate | `docs/plan/capstone-readiness-20260502/evidence/latest-readiness-report.md` | `backend_cargo_test` | PASS | Codex | 2026-05-02 15:54 +08:00 |
| E-004 | 12 | 12.c | Backend/API | API health and availability gate | `docs/plan/capstone-readiness-20260502/evidence/latest-readiness-report.md` | `api_health` | PASS | Codex | 2026-05-02 15:54 +08:00 |
| E-005 | 1 | 1.a | Backend/API | Auth login and token issuance gate | `docs/plan/capstone-readiness-20260502/evidence/latest-readiness-report.md` | `api_login` | PASS | Codex | 2026-05-02 15:54 +08:00 |
| E-006 | 9 | 9.b | Backend/API | Tracking map-data endpoint gate | `docs/plan/capstone-readiness-20260502/evidence/latest-readiness-report.md` | `api_tracking_map_data` | PASS | Codex | 2026-05-02 15:54 +08:00 |
| E-007 | 9 | 9.b | Backend/API | Heartbeat accuracy and tracking smoke | `docs/plan/capstone-readiness-20260502/evidence/latest-readiness-report.md` | `tracking_smoke_script` | PASS | Codex | 2026-05-02 15:54 +08:00 |
| E-008 | 12 | 12.c | Backend/API | MDR operations-health endpoint gate | `docs/plan/capstone-readiness-20260502/evidence/latest-readiness-report.md` | `api_mdr_ops_health` | PASS | Codex | 2026-05-02 15:54 +08:00 |
| E-009 | 2 | 2.a | Backend/DB | Role account provisioning for controlled QA | `scripts/provision-capstone-accounts.ps1` | provisioning output (superadmin/admin/supervisor/guard) | PASS | Codex | 2026-05-02 15:04 +08:00 |
| E-010 | 13 | 13.e | Backend/DB | Backup artifact generation | `docs/plan/capstone-readiness-20260502/evidence/OBJ13-SUB13E-backend-db-backup-20260502-1556.sql` | `pg_dump` | PASS | Codex | 2026-05-02 15:56 +08:00 |
| E-011 | 13 | 13.e | Backend/DB | Restore drill into isolated database | `docs/plan/capstone-readiness-20260502/RELEASE_OPS_HARDENING_REPORT.md` | `psql` restore to `guard_firearm_system_restore_test` | PASS | Codex | 2026-05-02 15:57 +08:00 |
| E-012 | 13 | 13.b | Desktop | Desktop runtime packaging validation | `apps/desktop-tauri/src-tauri/target/release/bundle/` | `npm run build:desktop` | PASS | Codex | 2026-05-02 23:05 +08:00 |
| E-013 | 13 | 13.c | Android | Android runtime web-asset sync validation | `apps/android-capacitor/android/app/src/main/assets/public/index.html` | `npm run build:android` | PASS | Codex | 2026-05-02 23:06 +08:00 |
| E-014 | 13 | 13.d | Web/Desktop/Android-webview | Cross-runtime smoke capture (controlled session) | `docs/plan/capstone-readiness-20260502/evidence/phase5-smoke-2026-05-02T16-06-11-404Z/report.json` | `node DasiaAIO-Frontend/tmp/capstone-phase5-evidence.mjs` | PASS | Codex | 2026-05-02 23:06 +08:00 |
| E-015 | 14 | 14.c | Android-webview | Guard touch-target accessibility checks (Emergency contacts + Panic button) | `docs/plan/capstone-readiness-20260502/evidence/phase5-smoke-2026-05-02T16-06-11-404Z/report.json` | a11y metrics (`44px` pill min, `64x64` panic button) | PASS | Codex | 2026-05-02 23:06 +08:00 |
| E-016 | 13,14 | 13.b/13.c/14.c | Release/QA | Consolidated phase-5 platform and accessibility evidence summary | `docs/plan/capstone-readiness-20260502/evidence/phase5-platform-a11y-summary-20260502.md` | phase-5 summary log | PASS | Codex | 2026-05-02 23:07 +08:00 |

## Summary

- Strict automated gate (`-RequireApi`) passes end-to-end.
- Objective 13 now has current-cycle desktop + Android evidence artifacts plus cross-runtime smoke evidence.
- Objective 14 now has explicit guard touch-target evidence for emergency controls.
