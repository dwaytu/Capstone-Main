# SENTINEL Chapter 3 and 4 Evidence Package

**Evidence date:** October 17, 2026 (Asia/Manila)  
**Scope:** Current repository and read-only production verification only. This is an evidence package for academic writing, not Chapters 3 or 4 themselves.  
**Data integrity rule:** The production capstone records described below are explicitly labeled presentation/test data. They must not be represented as genuine DASIA historical activity, respondent survey results, or real-user audit activity.

## Evidence Status Legend

| Status | Meaning |
| --- | --- |
| IMPLEMENTED AND VERIFIED | Verified by a command or read-only production check in this evidence pass. |
| IMPLEMENTED, SOURCE-VERIFIED | Current source and configuration were inspected, but the authenticated production workflow was not exercised in this pass. |
| CONFIGURED, NOT FULLY VALIDATED | Delivery/configuration exists, but packaged-runtime or full workflow UAT was not performed. |
| NOT VERIFIED | No safe evidence was available in this pass. It must not be described as tested or completed. |

---

## Part A. Current System Baseline

### A.1 Current commits and production endpoints

| Item | Current evidence |
| --- | --- |
| Workspace commit | `6f42b36da038350cf44cf0c6ad1c083d89075e4c` (`docs: record capstone enrichment validation`) |
| Backend submodule commit | `f89f73254a25d5c932a80e1baf8ebee335df190a` (`feat(capstone): enrich 24-7 presentation dataset workflows`) |
| Public production frontend | `https://dasiasentinel.xyz` - HTTP 200 verified October 17, 2026. |
| Production backend | `https://backend-production-0c47.up.railway.app` - `/api/health` returned HTTP 200 with API and database status `up`. |
| Deployment environment | Railway project `SENTINEL`, environment `production`, Backend service verified read-only through Railway CLI. |
| Production revision caveat | The repository commits above are the current local `main` revisions. The public frontend does not expose a deploy commit identifier, so exact frontend artifact-to-commit parity was not independently proven from the public endpoint. |

### A.2 Architecture and technologies

| Layer | Current implementation evidence | Status |
| --- | --- | --- |
| Frontend | React 18 single-page application written in TypeScript, built with Vite and styled with Tailwind CSS. React Router controls protected routes and role-aware shells. | IMPLEMENTED AND VERIFIED by source inspection, type check, Jest, and production build. |
| Backend | Rust 2021 Axum REST/WebSocket API using Tokio, SQLx, structured handlers/services, and middleware for CORS, authentication, authorization, rate limiting, security headers, audit/presence behavior, and request tracing. | IMPLEMENTED, SOURCE-VERIFIED. Railway backend health is verified. |
| Database | PostgreSQL accessed through SQLx. Runtime bootstrap in `src/db.rs` creates/updates core schema idempotently; additional SQL migration files are present in `DasiaAIO-Backend/migrations/`. | IMPLEMENTED, SOURCE-VERIFIED; production database health verified. |
| Mapping | Leaflet and React Leaflet are installed. The operations map uses OpenStreetMap/Carto map tiles and the tracking APIs. | IMPLEMENTED, SOURCE-VERIFIED. |
| Web deployment | Docker multi-stage frontend build plus Railway static serving; Docker backend build runs non-root `sentinel` user and health checks `/api/health`. | IMPLEMENTED AND VERIFIED for public web/backend availability. |
| Desktop delivery | Tauri configuration targets Windows MSI/NSIS and consumes the built web distribution. | CONFIGURED, NOT FULLY VALIDATED in a packaged desktop runtime during this pass. |
| Android delivery | Capacitor Android wrapper includes Android, geolocation, push notification, status-bar, and secure-storage dependencies. | CONFIGURED, NOT FULLY VALIDATED in an installed Android release during this pass. |
| Presentation runner | Rust `capstone-dataset` binary with guarded production seed/enrichment commands and provenance ledger. | IMPLEMENTED AND VERIFIED read-only against production status/validation. |

### A.3 Text-based architecture diagram

```text
Web browser / Tauri desktop / Capacitor Android
                |
                v
React + TypeScript + Vite SPA
  - React Router role guards
  - OperationalShell / AppShell
  - Leaflet map, offline action queue, push-client support
                |
                | HTTPS REST + WebSocket tracking updates
                v
Rust Axum API on Railway
  - JWT authentication and refresh-token sessions
  - RBAC middleware and permission checks
  - Handler and service modules
  - Alert, geofence, missing-check-in, notification loops
                |
                v
PostgreSQL on Railway
  - identity/security, operations, assets, tracking,
    analytics, audit, and provenance-ledger tables
```

### A.4 Authentication, sessions, and role architecture

- Roles are `guard`, `supervisor`, `admin`, and `superadmin`. There is no current `user` role; a legacy `user` claim is normalized to `guard` by backend utility code.
- The frontend derives route access from the authenticated role. The guard workspace is limited to guard routes; elevated command routes are available to supervisor, admin, and superadmin as configured; Audit and Feedback Intelligence are superadmin-only routes.
- Login verifies password and account state. The backend stores refresh-token hashes in `refresh_token_sessions`, rotates refresh tokens, and revokes sessions through logout/password-reset workflows. JWT access claims include user identity, role, legal-consent state, issued time, and expiry.
- Source evidence: `DasiaAIO-Backend/src/handlers/auth.rs`, `DasiaAIO-Backend/src/middleware/authz.rs`, `DasiaAIO-Backend/src/utils.rs`, and `DasiaAIO-Frontend/src/router/index.tsx`.
- The public login page rendered in a real browser, but a successful production login was **not** performed because no credentials were used in this evidence pass. Therefore the complete live authentication flow is NOT VERIFIED here.

---

## Part B. Module Inventory

The table distinguishes module presence in current source from authenticated live verification. "Database" names the principal persisted entities where applicable; it does not imply every field or workflow was live-exercised.

| Module | User role(s) | Frontend | Backend | Database | Live status | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| Authentication | All roles | Login, password recovery/change, Terms prompt | Auth, legal, users handlers | users, refresh sessions, reset tokens, login attempts, verifications | Public login rendered; full login NOT VERIFIED | JWT plus refresh-session design. |
| Dashboard | Guard; supervisor/admin/superadmin | `UserDashboard`, command center/superadmin dashboard | Summary, analytics, missions, notifications APIs | operational tables | SOURCE-VERIFIED | Role-specific workspace shells. |
| User Management | Supervisor/admin/superadmin, role-scoped | User management in elevated dashboard | users handler and hierarchy checks | users, roles, permissions, user_roles | SOURCE-VERIFIED | Dynamic role-policy administration UI was not found. |
| Approvals | Admin, superadmin | Approval route/panel | user approval and operational request review | users, requests, request events | SOURCE-VERIFIED | Supervisor can coordinate/create requests but does not have request-review permission. |
| Guard Management | Supervisor/admin/superadmin | Resource Management guard tab, guard search/Guard ID | users, assignments, replacement handlers | users, guard_assignments, availability | SOURCE-VERIFIED | Guard IDs are distinct from legacy MDR identifiers. |
| Client Sites | Elevated roles | Resource Management site tab | clients/sites handlers | client_sites, clients, geofences | SOURCE-VERIFIED | Site coordinates support geofencing/tracking. |
| Scheduling | Supervisor/admin/superadmin | Schedule route/modals and search selectors | guard replacement/schedule handlers | shifts, guard assignments | SOURCE-VERIFIED | Conflict and approved-guard controls are source-evidenced. |
| Calendar | All authenticated roles | `CalendarDashboard` | replacement/shift feed | shifts, attendance | SOURCE-VERIFIED | Calendar paginates the shift feed. |
| Attendance | Guard for own actions; elevated oversight | Guard check-in/out and reports | attendance/tracking handlers | attendance, punctuality_records | SOURCE-VERIFIED | Selected guard actions support offline queuing. |
| DTR | Elevated roles; guard-facing attendance context | `DtrReport` | dtr handler | attendance, shifts, punctuality_records | SOURCE-VERIFIED | Report availability depends on source records. |
| No-show Detection | Supervisor/admin/superadmin | Attention and replacement panels | alert/replacement services | shifts, attendance, alerts | SOURCE-VERIFIED | Missing-check-in loop is source-evidenced. |
| Guard Replacement | Supervisor/admin/superadmin | Replacement and shift-swap panels | guard_replacement, shift_swap handlers | smart_guard_replacements, swaps, availability | SOURCE-VERIFIED | Swap history has a documented degraded mode if its feed is unavailable. |
| Notifications / Inbox | All roles, role-scoped | Header/inbox panels and triage | notifications handler/service | notifications, push_subscriptions | SOURCE-VERIFIED | Browser push needs supported device/browser and VAPID configuration. |
| Incidents | Guard submit; elevated review | Guard incident form and command panels | incidents handler/services | incidents, classifications, summaries | SOURCE-VERIFIED | Incident severity classification is rule/service based. |
| Support / Tickets | Guard submit; elevated support workflow | Support panel | support_tickets handler | support_tickets | SOURCE-VERIFIED | Ticket UI includes degraded/retry state. |
| Feedback | Guard/supervisor/admin/superadmin submit; superadmin intelligence | Feedback form/dashboard | feedback handler | feedback | SOURCE-VERIFIED | Presentation feedback is synthetic test data, not survey evidence. |
| Live Tracking | Consent-scoped roles | Guard map, operations map | tracking handler/WebSocket | tracking_points | SOURCE-VERIFIED | Depends on location permission, device GPS, and network. |
| Operations Map | Elevated roles; scoped guard map | `OperationalMapPanel`, guard map tab | tracking/geofence APIs | tracking points, client sites | SOURCE-VERIFIED | Falls back to last-known positions when current tracking is unavailable. |
| Geofencing | Tracking-enabled roles/command oversight | Map/geofence status UI | tracking and geofence alert service | site_geofences, geofence_events | SOURCE-VERIFIED | Full command-side geofence administration was not live-tested. |
| Missions | Elevated and guard workspaces | Mission panels/guard mission section | missions handler | shifts, mission-related records | SOURCE-VERIFIED | Rendered through shared dashboard areas. |
| Firearms | Elevated roles | Inventory/compliance panels | firearms handler | firearms | SOURCE-VERIFIED | Inventory count uses paginated API totals. |
| Firearm Allocation | Elevated roles | `FirearmAllocation` | firearm_allocation handler | firearm_allocations | SOURCE-VERIFIED | Includes issue/return and custody workflow. |
| Firearm Permits | All authenticated viewing as configured; elevated management | Permit/compliance screens | permits, guard/firearm compliance handlers | guard_firearm_permits, training_records | SOURCE-VERIFIED | Allocation validation is backend-enforced; documented force override is a governance caveat. |
| Armored Vehicles | Elevated roles | `ArmoredCarDashboard`, resources tab | armored cars handler | armored_cars, status transitions | SOURCE-VERIFIED | Plate numbers and vehicle resource management are present. |
| Vehicle Allocation | Elevated roles | Armored vehicle allocation UI | armored cars handler | car_allocations, driver_assignments | SOURCE-VERIFIED | Driver assignment is an application association, not vehicle GPS hardware. |
| Trips | Elevated roles | Trip Management route/panel | trip_management handler | trips | SOURCE-VERIFIED | Trip lifecycle and assigned vehicle/driver records are modeled. |
| Maintenance | Elevated roles | Firearm/vehicle maintenance panels | maintenance handlers/services | firearm_maintenance, car_maintenance, predictive maintenance | SOURCE-VERIFIED | Predictive outputs are decision-support logic, not validated machine learning. |
| Analytics | Elevated roles | Analytics, performance, merit dashboards | analytics/merit/decision-support handlers | merit, evaluations, punctuality, incidents, predictions | SOURCE-VERIFIED | Use "rule-based analytical and decision-support outputs" in the paper. |
| Audit / Forensics | Superadmin command route | `AuditDashboard` | audit handler/middleware | audit_logs | SOURCE-VERIFIED | Provenance distinguishes system capstone markers from real-user actions. |
| Profile | All authenticated roles | Profile dashboard/modal and photo crop UI | users/auth endpoints | users, profile image references | SOURCE-VERIFIED | Desktop packaged photo UAT is not verified. |
| Settings | All authenticated roles | Settings and status switches | auth/users/push support | users, subscriptions | SOURCE-VERIFIED | Push option depends on browser/device capability. |
| MDR Import | Elevated roles | MDR batch list/review/uploader | mdr handlers/services | mdr_import_batches, staging, quality log | SOURCE-VERIFIED | Cleansing preserves raw data and flags ambiguous matches. |
| Emergency / Panic | Guard | Panic button, emergency contacts | alerts/tracking/notification paths | alerts, tracking, notifications | SOURCE-VERIFIED | GPS is optional for SOS; high-priority action has offline queue support. |

**Inventory count:** 33 functional areas were inventoried above. This is a documentation count, not a claim that 33 separate standalone pages exist; several areas are implemented as panels, tabs, or role-specific sections within shared shells.

---

## Part C. Objectives-to-Implementation Matrix

Source for objective wording: `SENTINEL - Group 8.md`, Specific Objectives section.

| Objective | Sub-objective | Implemented feature evidence | Current status |
| --- | --- | --- | --- |
| 1. Secure approval-governed access | Identity, sessions, recovery, legal-policy compliance | JWT/refresh-session handlers, login attempt records, password reset, approval state, role guards, consent routes | IMPLEMENTED, SOURCE-VERIFIED. Do not claim third-party identity-proofing integration. |
| 2. Personnel operations | Scheduling, attendance, DTR, check-in/out, replacement coordination | schedules, attendance, DTR handler, no-show alerts, availability and replacement services, calendar | IMPLEMENTED, SOURCE-VERIFIED. Describe approved-guard and schedule-conflict validation; do not claim license/firearm validation on every shift creation. |
| 3. Asset accountability | Firearms, permits, vehicles, issuance/return, maintenance | inventory, allocation, permits/compliance, armored vehicles, driver/trip/maintenance entities | IMPLEMENTED, SOURCE-VERIFIED. Mention force-allocation override only as a governed exception if relevant. |
| 4. Field operations | Incidents, emergency escalation, service requests, notifications, live monitoring | Guard dashboard, SOS, incidents, support tickets, requests, inbox, tracking/map/geofence entities | IMPLEMENTED, SOURCE-VERIFIED. Qualify monitoring as device/GPS/network dependent. |
| 5. Evaluation and analytics | Attendance, punctuality, incidents, assignments, performance reporting | merit scores, client evaluations, punctuality, analytics dashboard, risk/absence and maintenance services | PARTIAL / SOURCE-VERIFIED. Current predictive-style outputs are transparent rules/formulas, not validated AI/ML models. |
| 6. Traceable multi-platform delivery | Web, Desktop, Android, audit, approvals, reports | audit logs, role guards, web deployment, Tauri config, Capacitor config, release workflow | Web/audit IMPLEMENTED, SOURCE-VERIFIED; Desktop and Android CONFIGURED, NOT FULLY VALIDATED in packaged runtime. |

---

## Part D. Chapter 3 Technical Evidence

### D.1 Development and requirements evidence

- The repository contains a React/TypeScript frontend and a Rust/Axum backend as separately versioned worktrees, plus `apps/desktop-tauri` and `apps/android-capacitor` wrappers.
- Existing routes, handlers, services, tests, CI/release scripts, Dockerfiles, Railway manifests, and the current production health checks provide implementation evidence. They do not substitute for a human-subject usability study, survey, or field deployment study.
- Current route protection is implemented in frontend `RoleGuard` and backend permission middleware. Backend enforcement remains the authorization boundary; hiding a frontend control alone is not treated as authorization.

### D.2 Database design and principal relationships

Major current entities are grouped below. The runtime bootstrap contains 53 `CREATE TABLE IF NOT EXISTS` declarations and the repository has 15 additional migration SQL files.

| Domain | Principal entities | Relationship summary |
| --- | --- | --- |
| Identity and governance | users, roles, permissions, user_roles, role_permissions, verifications, auth_login_attempts, password_reset_tokens, refresh_token_sessions, audit_logs | Users authenticate and hold role/permission relationships; session and audit records retain security/governance history. |
| Personnel operations | shifts, attendance, punctuality_records, guard_assignments, guard_availability, guard_shift_readiness, guard_shift_swaps, smart_guard_replacements, guard_merit_scores, client_evaluations | A guard is assigned to shifts; shifts can produce attendance, punctuality, readiness, availability, replacement, and performance records. |
| Client and location | clients, client_sites, site_geofences, tracking_points, geofence_events | Client sites provide operational locations; tracking points and geofence events are associated with entities/sites. |
| Assets | firearms, firearm_allocations, firearm_maintenance, guard_firearm_permits, training_records, armored_cars, car_allocations, driver_assignments, car_maintenance, trips | Firearms and vehicles retain allocation, compliance, maintenance, driver, and trip relationships. |
| Workflow and support | incidents, incident_severity_classifications, ai_incident_summaries, operational_requests, operational_request_events, support_tickets, notifications, feedback | Operational workflows retain request history, incident classification, support, notifications, and feedback. |
| MDR and data quality | mdr_import_batches, mdr_staging_rows, data_quality_change_log | Import staging retains raw/cleansed representations and reviewer-oriented quality evidence. |
| Presentation provenance | capstone_seed_batches, capstone_seed_records | Tracks only generated test record IDs so controlled reset/enrichment affects generated records rather than master production data. |

### D.3 Security and data flow evidence

1. A user opens the SPA and submits credentials to the Axum API.
2. The API validates credentials/account state and returns access and refresh tokens; refresh-token hashes are persisted server-side.
3. The frontend stores authenticated context and route guards select the permitted shell/workspace.
4. Protected API requests include the access token; backend middleware validates claims and permissions before handlers access PostgreSQL through SQLx-bound queries.
5. Operational actions create or update domain records, with audit/security middleware and workflow-specific notification/tracking behavior where implemented.
6. Map/tracking flows use location permission, device/browser capabilities, REST/WebSocket updates, and fallback states when current data is unavailable.

### D.4 Major workflows evidenced in code

- Controlled account lifecycle: create/approve/reject account, login, refresh, logout, password recovery/change, consent acknowledgement.
- Shift operations: schedule assignment, conflict checks, guard check-in/out, attendance/DTR/punctuality records, no-show detection, and replacement recommendation.
- Asset custody: firearm/vehicle management, allocation, return, permit/training checks, trip/maintenance history.
- Field coordination: incident report, support ticket, operational request, notification/inbox, SOS and emergency-contact workflows.
- Operational visibility: tracking consent, tracking points, geofences, operations map, analytics, merit/evaluation, and audit timeline.

---

## Part E. Testing and Build Evidence

### E.1 Commands run in this pass

| Test/build type | Command | Result | Notes |
| --- | --- | --- | --- |
| Frontend TypeScript | `npx tsc --noEmit --incremental false` | PASS | Completed with exit code 0. |
| Frontend unit/component tests | `npm test -- --runInBand` | PASS | 56 suites passed; 199 tests passed; 0 failed. |
| Frontend production build | `npm run build` | PASS | 1,967 modules transformed; Vite completed. Non-blocking warnings report modules that are both dynamically and statically imported. |
| Selected Playwright browser tests | `npx playwright test tests/feedback.spec.ts tests/guard-dashboard.spec.ts tests/inbox.spec.ts tests/operational-requests.spec.ts tests/profile-settings.spec.ts tests/schedule-guard-selector.spec.ts --project=chromium` | PARTIAL | 16 passed, 1 failed. The failed assertion expected the heading `Account Settings` in the guard profile/settings dialog. See Part H. |
| Backend Rust tests | `cargo test` | NOT VERIFIED | Blocked before project tests by missing Windows OpenSSL development libraries / `OPENSSL_DIR` or `VCPKG_ROOT`. This is a local test-environment blocker, not evidence that backend tests failed. |
| Backend static/build check | `cargo check` / `cargo build` | NOT RUN SEPARATELY | `cargo test` stopped in the same native OpenSSL dependency step. Railway's Linux Docker deployment has successfully compiled the current backend runner, but that is not a local test-suite result. |
| Scheduler regression tests | Included in `src/bin/capstone_dataset.rs` | NOT VERIFIED LOCALLY | Two pure scheduler tests are present, but `cargo test` could not reach test execution in this environment. |
| Production capstone validation | `railway ssh "/app/capstone-dataset validate"` | PASS | Future attendance 0; October 17 scheduled shifts 33; overlaps 0; insufficient-rest violations 0; causal enrichment validation passed. |
| Production public frontend | `curl -I https://dasiasentinel.xyz` | PASS | HTTP 200. |
| Production backend health | `curl https://backend-production-0c47.up.railway.app/api/health` | PASS | HTTP 200; API and database reported up. |

### E.2 Test coverage inventory from current source

- Frontend Jest configuration discovers source tests under `src`; the executed result is 56 suites and 199 tests.
- Frontend Playwright configuration contains seven Chromium specs for smoke/auth, guard dashboard, inbox, operational requests, profile/settings, schedule selectors, and feedback. The six API-mocked specs were selected to avoid production mutation.
- Backend source contains unit tests for authentication/security helpers, authorization, analytics, DTR, firearms/compliance, users, tracking, replacement, MDR cleansing, notification delivery, operational requests, and the capstone scheduler. Two async tracking integration files exist. They were not run in this pass because the local native TLS dependency blocked compilation; integration tests can also write to an explicitly configured test database and were excluded from this read-only evidence pass.

### E.3 Proposed and verified test-case matrix

| ID | Module | Test scenario | Expected result | Actual result | Status | Evidence |
| --- | --- | --- | --- | --- | --- | --- |
| TC-01 | Frontend type safety | Compile TypeScript without emitting files | No type errors | Exit 0 | PASS | `npx tsc --noEmit --incremental false` |
| TC-02 | Frontend components | Execute Jest suite | All registered unit/component tests pass | 199/199 tests passed | PASS | `npm test -- --runInBand` |
| TC-03 | Frontend packaging | Build Vite production output | Build completes | 1,967 modules transformed; build completed | PASS | `npm run build` |
| TC-04 | Requests | Guard submits service request using mocked API | Request is submitted and retained | Passed | PASS | Selected Playwright run |
| TC-05 | Requests | Administrator approves request with history | State/history renders | Passed | PASS | Selected Playwright run |
| TC-06 | Scheduler | Search guard/site and retain payload | Searchable selection works | Passed | PASS | Selected Playwright run |
| TC-07 | Feedback | Display selected/saved star ratings | Filled stars render | Passed | PASS | Selected Playwright run |
| TC-08 | Inbox | Open quick inbox and full notification detail | Role shell/inbox behavior works | Passed | PASS | Selected Playwright run |
| TC-09 | Guard support/map | Support and tracking fallback states | User-facing fallback remains usable | Passed | PASS | Selected Playwright run |
| TC-10 | Guard profile/settings | Navigate guard account menu to profile/settings | Expected heading visible | `Account Settings` heading was not found | FAIL | `guard-dashboard.spec.ts:236` |
| TC-11 | Production scheduling data | Validate seed integrity | No future attendance, no overlaps/short rest | All reported zero | PASS | Railway read-only `validate` |
| TC-12 | Production availability | Load public UI and backend health | Frontend/API/database reachable | HTTP 200 and health `up` | PASS | Curl checks October 17, 2026 |
| TC-13 | Authenticated role routes | Login as each role and review major pages | Role-specific UI visible | Not executed without credentials | NOT TESTED | Requires approved read-only test accounts/session |
| TC-14 | Packaged desktop/Android | Launch signed/installable artifacts | Native runtime works | Not executed in this pass | NOT TESTED | Configuration only |

---

## Part F. Live System Verification and Screenshot Evidence

### F.1 Read-only production verification

| Check | Result |
| --- | --- |
| `https://dasiasentinel.xyz` | HTTP 200; public SPA login page rendered in Chromium. |
| `https://backend-production-0c47.up.railway.app/api/health` | HTTP 200; `status: ok`, `services.api: up`, `services.database: up`, WebSocket status `up`. |
| Railway production target | Railway CLI reported `SENTINEL / production / Backend`. |
| Authentication flow | Login screen rendered, but no account credentials were used; successful authentication NOT VERIFIED. |
| Role-specific navigation/pages | NOT VERIFIED on the production UI because no authenticated read-only session was available. |
| Responsive behavior | Login was rendered at desktop and 390x844 Chromium viewport. Authenticated mobile screens were not exercised. |

### F.2 Screenshots

| Target | File | Result |
| --- | --- | --- |
| 01-login desktop | `docs/chapter4-screenshots/01-login.png` | Captured from live public UI after a five-second render wait. |
| 01-login narrow viewport | `docs/chapter4-screenshots/01-login-mobile.png` | Captured from live UI at 390x844 Chromium viewport. |
| 02-superadmin-dashboard through 26-profile-settings | Not captured | Require authenticated, role-appropriate, read-only test sessions. No credentials were used or created in this evidence pass. |

The initial immediate screenshot was blank because it was captured before SPA hydration; it was replaced and is not retained as evidence.

---

## Part G. Presentation / Capstone Test Data Metrics

**PRESENTATION / CAPSTONE TEST DATA - NOT GENUINE DASIA HISTORICAL ACTIVITY**

Production counts below were obtained through read-only Railway status/validation commands and ledger-scoped queries. The base schedule batch is `capstone-live-october-2026`; enrichment is tracked separately as `capstone-live-october-2026-enrichment-v1`.

### G.1 Base schedule and roster

| Metric | Verified value |
| --- | --- |
| Selected sites | 11 Tagum-area sites: BPI Direct Banko Sto. Tomas; BPI Direct Banko Tagum Branch; BPI Robinsons; DASIA Tagum; DBP Tagum; DPB Lending Tagum; EMCOR Tagum; Globe FOC Tagum; RCBC Tagum; UCPB Tagum; UM Tagum College. |
| Participating guards | 55, organized as stable five-guard site rosters. |
| Coverage rotation | 07:00-15:00 day, 15:00-23:00 evening, 23:00-07:00 night. |
| Base coverage slots | 561: 187 per day/evening/night rotation. |
| Tracked shifts | 564, including three recorded same-site relief replacements. |
| Sunday coverage | 66 slots. |
| Attendance | 528 completed attendance records. |
| Shift status distribution | 528 completed; 3 absent; 33 scheduled. |
| Punctuality | 531 records: 510 present/on-time status records, 18 late, 3 absent. |
| Merit scores | 55 derived guard merit scores. |
| Smart replacements | 3. |
| Integrity checks | 0 future attendance records; 0 overlap violations; 0 insufficient-rest violations. |

### G.2 Enrichment batch

| Metric | Verified value |
| --- | --- |
| Incidents | 7 incidents with 7 severity classifications. |
| Operational requests | 9 requests with 22 recorded request-history events. |
| Notifications | 23 total: 13 read and 10 unread. |
| Readiness checks | 96 total: 33 day, 33 evening, 30 night. |
| Absence predictions | 4 derived presentation scenarios: 1 high, 2 medium, 1 low. |
| Support tickets | 7 total: 2 open, 2 in progress, 3 resolved. |
| Client evaluations | 24; rating range 3.4 to 4.9. |
| Tracking points | 18; 0 outside the configured site-coordinate tolerance. |
| Feedback | 22 total: 20 Bisaya/Cebuano guard feedback entries, one supervisor entry, one admin entry. Rating distribution: 5 rated 3, 14 rated 4, 3 rated 5. |
| Audit provenance | One system-attributed enrichment audit marker; no fabricated real-user audit actor was created. |

### G.3 Preservation checks

The enrichment was additive and ledger-tracked. Read-only before/after preservation checks reported 154 users, 2 protected active superadmins with unchanged fingerprint, 36 client sites, 110 firearms, and 5 armored vehicles. Non-capstone counts observed for preservation were one feedback record, 12 incidents, and two operational requests. The runner reported idempotency on repeat execution: no duplicate child records were created.

---

## Part H. Known Issues and Limitations

| Item | Evidence-supported limitation or defect | Academic wording guidance |
| --- | --- | --- |
| Guard profile/settings browser regression | One selected local Playwright test failed because the expected `Account Settings` heading was not found in the guard profile/settings dialog. The failure proves a current automated regression mismatch; it does not by itself prove a production workflow failure. | Report as an outstanding UI regression requiring investigation before final acceptance. |
| Native backend test environment | Local `cargo test` did not reach tests because Windows cannot locate OpenSSL development libraries/Vcpkg. | Do not state backend suite passed in this evidence pass. |
| Desktop/Android runtime parity | Tauri and Capacitor configurations exist, but packaged release artifacts were not installed/exercised here. | Say cross-platform targets are configured; packaged-runtime validation remains required. |
| GPS/network dependency | Tracking, geofence, and current location depend on permission, browser/device capabilities, GPS accuracy, and network availability. | Qualify live monitoring as near-real-time and device/network dependent. |
| Offline scope | Offline queue support is implemented for high-priority guard actions; failed actions can remain failed after retry limits. | Do not claim fully offline system operation. |
| Push notifications | Device push requires compatible browser/device, service worker, VAPID public key, and backend subscription support. | State as capability-dependent, not universal delivery. |
| Shift swap feed | Client deliberately degrades to unavailable/stale state when endpoint is unavailable; manual request submission remains available. | Describe graceful degradation, not guaranteed live swap-history availability. |
| Dynamic permissions | Role permissions are static source maps; a dynamic role/permission policy-administration UI was not found. | Describe role-scoped access governance, not administrator-configurable permission modeling. |
| Distributed scheduler control | Alert loops run in each server process; source inspection found no explicit leader-election mechanism for multi-replica scheduling. | Treat multi-replica scheduler coordination as a deployment/architecture follow-up. |
| Legacy seed scripts | Legacy `seed.js`/`seed.ps1` do not have the newer capstone runner safeguards; one legacy script contains a hard-coded database credential and should not be used. | Do not use these scripts as security evidence; sanitize/remove the legacy credential separately. |
| Runtime migrations | Docker copies Rust source and invokes idempotent runtime bootstrap; standalone SQL migration files are not independently copied/applied by that container path. | Document the current bootstrap behavior accurately; do not claim a fully managed migration pipeline without further verification. |

---

## Part I. Recommended Use in Chapters 3 and 4

- **Chapter 3:** Use Parts A, D, and the source-evidenced architecture/database/workflow descriptions. Present Desktop and Android as configured cross-platform targets pending packaged-runtime validation.
- **Chapter 4:** Use Parts B, C, E, F, and G. Separate software test results from presentation dataset metrics and from any future user-acceptance survey results.
- **Do not claim:** real historical DASIA activity from the presentation ledger, human-subject evaluation from seeded feedback, AI/ML validation where source shows rule-based analytics, full offline operation, or verified desktop/Android release parity.

---

## Part J. Output Summary

| Requested summary item | Current evidence |
| --- | --- |
| 1. Current production commit | Workspace `6f42b36da038350cf44cf0c6ad1c083d89075e4c`; backend `f89f73254a25d5c932a80e1baf8ebee335df190a`. |
| 2. Current live URL | `https://dasiasentinel.xyz`; backend health `https://backend-production-0c47.up.railway.app/api/health`. |
| 3. Implemented module inventory | 33 documented functional areas. Many are panels/role sections rather than standalone pages. |
| 4. Verified automated tests | 215 passing automated tests in commands run here: 199 Jest plus 16 selected Playwright tests. |
| 5. Tests passed/failed | 215 passed; 1 selected Playwright test failed; backend suite NOT VERIFIED locally due OpenSSL environment blocker. |
| 6. Known defects | Guard profile/settings Playwright heading regression; investigate before final acceptance. |
| 7. Known limitations | Packaged desktop/Android UAT, GPS/network and push dependency, partial offline scope, static permissions, degraded swap feed, distributed scheduler coordination, legacy seed scripts, and runtime migration behavior. |
| 8. Screenshots captured | Two: desktop login and narrow-viewport login. Authenticated target screenshots were not captured because no credentials were used. |
| 9. Objective 1 mapping | Auth, approval, consent, JWT/refresh sessions, account recovery, RBAC. |
| 10. Objective 2 mapping | Scheduling, attendance, DTR, no-show detection, replacements, calendar. |
| 11. Objective 3 mapping | Firearms, permits/compliance, allocation/return, vehicles, trips, maintenance. |
| 12. Objective 4 mapping | Incidents, SOS, support, requests, notifications, tracking/map/geofencing. |
| 13. Objective 5 mapping | Punctuality, merit, evaluations, analytics, rule-based decision support. |
| 14. Objective 6 mapping | Audit/forensics, approvals/reports, deployed web, configured Tauri/Capacitor targets. |

## Source Pointers

- Frontend routing and RBAC: `DasiaAIO-Frontend/src/router/index.tsx`, `DasiaAIO-Frontend/src/router/guards.tsx`, `DasiaAIO-Frontend/src/config/navigation.ts`.
- Frontend test configuration: `DasiaAIO-Frontend/jest.config.cjs`, `DasiaAIO-Frontend/playwright.config.ts`, `DasiaAIO-Frontend/tests/`.
- Backend composition: `DasiaAIO-Backend/src/main.rs`, `DasiaAIO-Backend/src/handlers/mod.rs`, `DasiaAIO-Backend/src/services/mod.rs`.
- Database bootstrap: `DasiaAIO-Backend/src/db.rs` and `DasiaAIO-Backend/migrations/`.
- Auth/RBAC: `DasiaAIO-Backend/src/handlers/auth.rs`, `DasiaAIO-Backend/src/middleware/authz.rs`, `DasiaAIO-Backend/src/utils.rs`.
- Production capstone safeguard and validation: `DasiaAIO-Backend/src/bin/capstone_dataset.rs`.
- Deployment: `DasiaAIO-Frontend/Dockerfile`, `DasiaAIO-Backend/Dockerfile`, both `railway.json` files, and `.github/workflows/release.yml`.
