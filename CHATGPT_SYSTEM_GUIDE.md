# SENTINEL System Guide for ChatGPT

This document is a high-signal handoff so a new ChatGPT session can quickly understand the full project.

## 1. What This System Is

SENTINEL is an integrated security operations platform for Davao Security & Investigation Agency.
It manages:

- Personnel and scheduling
- Guard attendance and replacement workflows
- Firearm inventory, permits, allocation, and maintenance
- Armored car fleet, driver assignment, trips, and maintenance
- Notifications, support tickets, and analytics

## 2. Tech Stack

- Frontend: React + TypeScript + Vite (`DasiaAIO-Frontend`)
- Backend: Rust + Axum (`DasiaAIO-Backend`)
- Database: PostgreSQL
- Runtime/Deployment: Docker + Docker Compose (local), Railway (production)
- ORM/DB client: `sqlx 0.8.x` (upgraded from 0.7.x)
- Mapping: OpenStreetMap tiles rendered via Leaflet + React Leaflet (`DasiaAIO-Frontend`)

## 3. Repository Layout

- `DasiaAIO-Frontend/`: Web app UI, dashboards, client-side logic, tests
- `DasiaAIO-Backend/`: API server, DB migrations/init, domain handlers
- `apps/android-capacitor/`: Capacitor Android shell consuming `DasiaAIO-Frontend/app-dist`
- `apps/desktop-tauri/`: Tauri desktop shell consuming `DasiaAIO-Frontend/app-dist`
- Root docs:
  - `SYSTEM_AUDIT_REPORT.md`
  - `explanation.md`
  - `SENTINEL - Group 8.md`
  - `TermsOfAgreement.md`
  - `PrivacyPolicy.md`
  - `AcceptableUsePolicy.md`

## 4. Current Role Model (Important)

### Implemented and enforced

- `superadmin`
- `admin`
- `supervisor`
- `guard`

### Legacy compatibility still present

- `user` is still accepted as a legacy role value and normalized to `guard` in critical paths.
- Frontend role normalization now treats role strings case-insensitively (for example `Admin`, `ADMIN`, ` admin `), reducing accidental fallback to `guard` caused by inconsistent casing.

If ChatGPT is asked about roles, it should verify code paths before assuming docs are fully accurate.

## 5. Core Modules and Flows

### A. Authentication & Account

Backend endpoints include:

- `POST /api/register`
- `POST /api/login`
- `POST /api/verify`
- `POST /api/resend-code`
- `POST /api/forgot-password`
- `POST /api/verify-reset-code`
- `POST /api/reset-password`
- `POST /api/refresh`
- `POST /api/auth/refresh`
- `POST /api/logout`
- `POST /api/auth/logout`

Behavior highlights:

- Gmail-only validation for registration email
- Public registration only creates guard accounts
- Self-registered guard accounts start as `pending` approval
- Login requires both email verification and `approval_status = approved`
- Admin/supervisor accounts should be created internally via authenticated management flows
- Email verification required when email provider is configured
- Email verification is mandatory for guard self-registration; registration is rejected when email verification provider is not configured
- Access and refresh JWTs issued on login; refresh sessions are persisted server-side and rotated on refresh

Approval workflow highlights (implemented):

- Reviewer roles (`superadmin`, `admin`, `supervisor`) can list pending guard approvals
- Reviewer roles can approve or reject pending guard accounts
- Guard self-registration triggers reviewer notifications about pending approval
- Approval/rejection action triggers a decision notification to the guard

### B. Personnel and Scheduling

- User CRUD routes (`/api/users`, `/api/user/:id` etc.)
- Shift creation and retrieval via guard replacement handlers
- Guard attendance check-in/check-out
- No-show detection and replacement request/accept flows
- Guard availability set/get

### C. Firearms and Permits

- Firearm CRUD
- Allocation issue/return + active allocations
- Overdue allocations endpoint
- Guard permit management + expiring/auto-expire operations
- Firearm maintenance schedule/pending/complete/history

### D. Armored Cars and Trips

- Armored car CRUD
- Car allocation issue/return
- Driver assignment/unassignment
- Trip create/end/list and enhanced trip management endpoints
- Car maintenance schedule/complete/history

### E. Missions, Merit, Analytics, Tickets, Notifications

- Mission assignment and retrieval
- Merit score calculation/rankings/evaluations/overtime candidates
- Analytics summary/trends and mission status update
- Support ticket create/list
- User notifications list/read/delete/unread count

## 6. Data and Database Notes

Database initialization occurs in backend startup (`run_migrations` in `db.rs`).
Main table domains include:

- `users`, `verifications`, `password_reset_tokens`
- `shifts`, `attendance`, replacement/availability related tables
- `firearms`, `firearm_allocations`, permit/maintenance related tables
- `armored_cars`, car allocations, trips, driver assignments, vehicle maintenance
- Notifications, tickets, merit-related tables
- Operational map tracking tables: `client_sites`, `tracking_points`, `geofence_events`, `site_geofences`
- Audit traceability table: `audit_logs` now stores `source_ip`, `user_agent`, structured `metadata`, and indexed result/time dimensions for forensic querying
- AI operational intelligence tables:
  - `guard_absence_predictions`
  - `smart_guard_replacements`
  - `incident_severity_classifications`
  - `predictive_vehicle_maintenance`
  - `ai_incident_summaries`

`users.role` is a free-form varchar in schema, but business logic constrains allowed values in auth and frontend checks.

## 7. Frontend Architecture Notes

- `src/App.tsx` is the top-level router-by-state for dashboard/view switching.
- Login/register/reset flows live in `src/components/LoginPage.tsx`.
- Calendar operations view is in `src/components/CalendarDashboard.tsx`.

Recent optimization work in calendar:

- Memoized event grouping/filtering/statistics to reduce repeated render-time filtering
- Safer date parsing for malformed source records
- Partial data-source failure resilience (can still render available data)

API utility hardening:

- `src/utils/api.ts` supports safe non-JSON parsing fallback
- `fetchJsonOrThrow` supports timeout-based abort
- `fetchJsonOrThrow` now blocks protected `/api/*` requests when no session token exists and emits a normalized session-expired event instead of sending unauthenticated dashboard calls.
- `fetchJsonOrThrow` now auto-attaches `Authorization: Bearer <token>` on protected API calls when caller headers omit it, reducing silent auth-header drift between dashboard modules.

Client access governance hardening:

- `DasiaAIO-Frontend/src/App.tsx` now enforces a first-use Terms of Agreement gate across Web, Desktop (Tauri), and Mobile (Capacitor) runtimes.
- Access is blocked by an application modal until users explicitly agree, and final acceptance is persisted server-side through `POST /api/legal/consent`.
- Legal acceptance metadata (`consentAcceptedAt`, `consentVersion`, `legalConsentAccepted`) is now returned by login and used for restore-auth gating.
- Consent recording now captures compliance trace metadata (`consent_ip`, `consent_user_agent`) in the `users` table.
- `App.tsx` consent modal now links directly to repository legal documents (`TermsOfAgreement.md`, `PrivacyPolicy.md`, `AcceptableUsePolicy.md`).
- `DasiaAIO-Frontend/src/App.tsx` now checks GitHub Releases for newer tagged builds and prompts users to download updates via in-app modal (`Later` / `Download update`) when a newer release than `VITE_APP_VERSION` is available.
- `DasiaAIO-Frontend/src/App.tsx` now includes a manual "Check for Updates" action in addition to scheduled update checks.
- `DasiaAIO-Frontend/src/config.ts` now exposes app/update metadata (`APP_VERSION`, `LATEST_RELEASE_API_URL`, `RELEASE_DOWNLOAD_URL`) and resolves API base URL strictly from `VITE_API_BASE_URL`.
- Runtime API fallback paths were removed to prevent cross-platform drift between web, desktop, and mobile clients.
- Frontend release scripts now enforce production env safety via `DasiaAIO-Frontend/scripts/ensure-production-env.mjs`, blocking unsafe releases when `VITE_API_BASE_URL` is missing/non-HTTPS/private-host or when `VITE_APP_VERSION` is not a semantic release value.
- `DasiaAIO-Frontend/src/utils/location.ts` now uses CORS-compatible IP geolocation providers (`ipinfo.io` with `geolocation-db.com` fallback) plus short-lived caching to avoid repeated blocked external requests when precise GPS is unavailable.

## 8. API and Security Notes

- JWT generation and verification are active and used in managed user creation.
- JWT access and refresh token claims now include `legal_consent_accepted` to enforce consent state in protected routes.
- Legal consent endpoints are active:
  - `POST /api/legal/consent`
  - `GET /api/legal/consent/status`
- Consent endpoint issuance now persists refresh-token session rows in `refresh_token_sessions` so post-consent refresh rotation remains valid.
- Permission-based authorization middleware is active (`DasiaAIO-Backend/src/middleware/authz.rs`) and applied at route level in `DasiaAIO-Backend/src/main.rs`.
- `require_authenticated` and permission middleware now enforce legal-consent acceptance for protected routes, while legal bootstrap/logout paths are explicitly bypassed.
- Centralized write audit middleware is active (`DasiaAIO-Backend/src/middleware/audit.rs`) and records write outcomes (`success`/`failed`) into `audit_logs`.
- Elevated roles can now review those records through both legacy and expanded contracts:
  - `GET /api/audit-logs` (legacy compatibility)
  - `GET /api/audit/logs`
  - `GET /api/audit/logs/filter`
  - `GET /api/audit/user-activity/:id`
  - `GET /api/audit/anomalies`
  The handler (`DasiaAIO-Backend/src/handlers/audit.rs`) supports pagination, multi-field filtering, user-activity timelines, and anomaly group extraction for high-fidelity SOC review.
- Managed user creation endpoint (`POST /api/users`) enforces role hierarchy:
  - `superadmin` can create `admin`, `supervisor`, and `guard`
  - `admin` can create `supervisor` and `guard`
- Guard approval management endpoints are active:
  - `GET /api/users/pending-approvals`
  - `PUT /api/users/:id/approval`
- Guard login is blocked when `approval_status != approved`.
- CORS accepts both `CORS_ORIGINS` (comma-separated, preferred) and `CORS_ORIGIN` (single-origin compatibility).
- If neither env var is set to a valid value, fallback allow-list behavior in `DasiaAIO-Backend/src/main.rs` includes local development and production web origins (`https://dasiasentinel.xyz`, `https://www.dasiasentinel.xyz`, `https://dasiaaio.up.railway.app`).
- CORS fallback allow-lists now also include runtime origins used by packaged clients (`capacitor://localhost`, `tauri://localhost`, `http://localhost`, `https://localhost`) to prevent mobile/desktop WebView login fetch failures when strict CORS env vars are absent.
- When `CORS_ORIGINS` or `CORS_ORIGIN` is explicitly configured, backend CORS now still augments those settings with native wrapper origins (`capacitor://localhost`, `tauri://localhost`, `http://localhost`, `https://localhost`) so mobile and desktop wrappers do not regress into `Failed to fetch` due to origin mismatch.
- The explicit-CORS path also now always augments with local web dev origins `http://localhost:5173` and `http://127.0.0.1:5173`, preventing browser preflight failures when developers run the frontend locally against the deployed backend.
- Global middleware order in `DasiaAIO-Backend/src/main.rs` now keeps CORS outermost so browser CORS headers are still attached when upstream middleware (rate-limit/auth/presence) returns early errors.
- API/auth/expensive rate-limit middleware (`DasiaAIO-Backend/src/middleware/rate_limit.rs`) now bypasses `OPTIONS` requests so browser preflight checks are never rate-limited.
- Rate-limit middleware now returns CORS-safe `429` responses so browser clients receive explicit throttling status instead of opaque CORS failures under load.
- Global API rate-limit requester identity now falls back to verified bearer-token user IDs when proxy IP headers are unavailable, reducing shared `unknown-client` bucket collisions in local/containerized runs.
- Global API limiter buckets are now keyed by requester and path (`api:<requester>:<path>`), reducing cross-endpoint throttling collisions during dashboard burst startup while preserving per-route abuse protection.
- Auth/API/expensive endpoint rate limiting now enforces both per-IP and per-user buckets (`*:ip:*` + `*:user:*`) when identity data is available, with fallback buckets retained for unknown-client contexts.
- `/api/health` is excluded from global API rate limiting so dashboard/service probes remain responsive during burst traffic.
- Global timeout middleware (`DasiaAIO-Backend/src/middleware/request_timeout.rs`) now caps request execution time (default 30s, configurable via `REQUEST_TIMEOUT_SECS`) and returns structured `504` responses.
- Global security-header middleware (`DasiaAIO-Backend/src/middleware/security_headers.rs`) now applies `X-Content-Type-Options`, `X-Frame-Options`, `Content-Security-Policy`, and production `Strict-Transport-Security` headers.
- Error responses are standardized in `DasiaAIO-Backend/src/error.rs` with stable fields: `error`, `code`, `status`, `timestamp`; raw database/internal details are logged server-side and not exposed to clients.
- Health payloads (`/api/health`, `/api/health/system`) now include DB state, websocket state (`activeConnections`), uptime seconds, and timestamp.
- New platform-release metadata endpoint is active: `GET /api/system/version` (`latestVersion`, `changelog`, `downloadLinks`).
- Backend Docker runtime now enforces least privilege by running the server as a dedicated non-root user (`USER sentinel`) and enforces lockfile-based reproducible builds via `Cargo.lock` + `cargo build --locked` (`DasiaAIO-Backend/Dockerfile`).
- Release packaging workflow now uses `actions/checkout` for both orchestration and frontend repository retrieval, replacing manual tokenized git shell commands in `.github/workflows/release-artifacts.yml`.
- Backend config now enforces production startup guards (`DasiaAIO-Backend/src/config.rs`) when `APP_ENV=production` or `NODE_ENV=production`:
  - requires strong non-default `JWT_SECRET`,
  - rejects default `ADMIN_CODE=122601`,
  - requires explicit `CORS_ORIGINS` or `CORS_ORIGIN`.
- Legacy high-privilege routes were hardened with centralized middleware, including:
  - permits + firearm maintenance + training record endpoints
  - car allocation + car maintenance + driver assignment endpoints
  - legacy trips endpoints and legacy firearm maintenance listing endpoint
- Support-ticket create request now accepts both `guard_id` and `guardId` payload keys for compatibility.

## 9. Backend Context Snapshot (Keep Updated)

Primary backend files that must be rechecked when roles/auth/dashboards change:

- `DasiaAIO-Backend/src/main.rs`: route registration and middleware wiring
- `DasiaAIO-Backend/src/handlers/auth.rs`: login/register/verification/reset and pending-approval notifications
- `DasiaAIO-Backend/src/handlers/users.rs`: managed account creation, pending approvals, approve/reject action
- `DasiaAIO-Backend/src/db.rs`: schema bootstrap and migration execution behavior
- `DasiaAIO-Backend/src/models.rs`: request/response contracts used by frontend

Current backend reality:

- Role hierarchy in business logic is `superadmin > admin > supervisor > guard` with `user` legacy compatibility
- Public registration creates pending guards that require reviewer approval
- Public registration now always creates `verified = false` pending guards and always issues a verification-code challenge
- `POST /api/register` now fails fast when `RESEND_API_KEY` is missing so unverified guard accounts are not created without a deliverable code path
- `POST /api/verify` now validates confirmation codes against both code and email (joined to the `users` table), reducing cross-account code misuse risk
- Users now have persisted legal consent metadata columns (`consent_accepted_at`, `consent_version`, `consent_ip`, `consent_user_agent`) created by startup schema guards in `db.rs`.
- Login payload now includes legal consent state (`legalConsentAccepted`, `consentAcceptedAt`, `consentVersion`), and token issuance inherits that state.
- Legal consent routes are active and protected by auth middleware with legal-bootstrap bypass behavior:
  - `POST /api/legal/consent`
  - `GET /api/legal/consent/status`
- Reviewer notifications and guard decision notifications are persisted in `notifications`
- API authorization is still the final source of truth even when frontend hides/shows role surfaces
- Dashboard contract aliases are now explicitly available for integration stability:
  - `GET /api/guards` (approved guards list)
  - `GET /api/vehicles` (armored-car list alias)
- Centralized middleware coverage now spans both primary and legacy privileged route families (users, firearms, allocations, schedules, missions, analytics, notifications, tickets, merit, armored cars, trips, permits, maintenance, training)
- Audit logging is route-layered on write endpoints and captures both authorized writes and authorization failures that return HTTP error responses
- Guard-scoped ownership enforcement was tightened in handlers to prevent cross-user access on authenticated routes:
  - `DasiaAIO-Backend/src/handlers/firearm_allocation.rs`: `get_guard_allocations` now requires `self` access or minimum `supervisor` role.
  - `DasiaAIO-Backend/src/handlers/guard_replacement.rs`: `check_in`, `check_out`, `set_availability`, `get_guard_shifts`, and `get_guard_attendance` now enforce self-or-supervisor checks, with additional guard/shift ownership validation in attendance flows.
- Overdue firearm allocation query fix:
  - `DasiaAIO-Backend/src/handlers/firearm_allocation.rs`: `get_overdue_allocations` now queries the existing `firearm_allocations.return_date` column (instead of non-existent `expected_return_date`) and returns `returnDate` in payload rows.
- Presence tracking update:
  - `DasiaAIO-Backend/src/models.rs`: `User` and `UserResponse` now include `last_seen_at`.
  - `DasiaAIO-Backend/src/db.rs`: startup schema bootstrap now ensures `users.last_seen_at TIMESTAMPTZ` exists.
  - `DasiaAIO-Backend/src/middleware/presence.rs`: new global middleware updates `users.last_seen_at` on authenticated requests.
  - `DasiaAIO-Backend/src/main.rs`: global `touch_last_seen` middleware is now wired with DB state.
  - `DasiaAIO-Backend/src/handlers/auth.rs`: successful login now updates `last_seen_at`.
  - `DasiaAIO-Backend/src/handlers/users.rs`: user list/detail queries now select `last_seen_at` so frontend can render presence.
- Operational map tracking update:
  - `DasiaAIO-Backend/src/db.rs`: startup schema bootstrap now creates/extends `client_sites`, `tracking_points` (including `user_id` association), `geofence_events`, and `site_geofences` with operational indexes.
  - `DasiaAIO-Backend/src/handlers/tracking.rs`: handlers now cover map snapshots, telemetry/site ingestion, guard movement intelligence, and geofence transition evaluation.
  - `DasiaAIO-Backend/src/handlers/mod.rs`: `tracking` module export added.
  - `DasiaAIO-Backend/src/main.rs`: new authenticated routes:
    - `GET /api/tracking/map-data`
    - `POST /api/tracking/points`
    - `POST /api/tracking/client-sites`
    - `GET /api/tracking/guard-history/:id`
    - `GET /api/tracking/guard-path/:id`
    - `GET /api/tracking/active-guards`
    - `GET /api/tracking/geofences`
    - `GET /api/tracking/client-sites/:id/geofences`
    - `POST /api/tracking/client-sites/:id/geofences`
    - `PUT /api/tracking/geofences/:id`
    - `DELETE /api/tracking/geofences/:id`
  - Guard safety rule: guards can only submit `entityType='guard'` points for their own `entityId` (JWT `sub`).
  - Expanded tracking API for location lifecycle and live streaming:
    - `GET /api/tracking/client-sites`
    - `PUT /api/tracking/client-sites/:id`
    - `DELETE /api/tracking/client-sites/:id`
    - `POST /api/tracking/heartbeat` (guard session heartbeat -> guard tracking point)
    - `GET /api/tracking/ws?token=<jwt>` (websocket snapshot stream)
  - Websocket lifecycle hardening:
    - `DasiaAIO-Backend/src/handlers/tracking.rs`: websocket auth rejection, snapshot-build failures, receive errors, lag events, and disconnects now produce structured tracing logs for production troubleshooting.
    - websocket snapshot send failures now terminate the client loop cleanly instead of failing silently.
  - Geofence transition intelligence:
    - guard/user tracking inserts evaluate enter/exit state changes against configured `site_geofences` (radius or polygon per site)
    - if a site has no active geofence zones, transition logic falls back to the default 1 km site-radius boundary
    - transitions are persisted to `geofence_events` and emitted as map snapshot `geofenceAlerts`
    - leadership notification fanout is sent on enter/exit transitions (`geofence_alert`)
  - `DasiaAIO-Backend/Cargo.toml`: `axum` now enables `ws` feature for websocket upgrades.
  - Websocket broadcast behavior:
    - tracking/site create-update-delete and heartbeat actions publish map refresh events.
    - active websocket clients receive updated map snapshots without polling reload.
  - Session-autoplot behavior:
    - map snapshots for elevated roles now include online guard session markers (`last_seen_at` window + latest guard coordinates).
- Predictive alerting surface (new):
  - `DasiaAIO-Backend/src/handlers/alerts.rs`: aggregates near-term risk heuristics (permits expiring within 7 days, overdue vehicle maintenance, repeated guard no-shows, low guard availability) and normalizes them into alert objects.
  - `GET /api/alerts/predictive` (supervisor+) now returns these alerts, sharing the analytics authorization path (`require_analytics_view`).
  - Responses include severity, category, detected timestamp, and structured context so the frontend can render warning cards without re-querying raw tables.
- Guard absence prediction surface (new):
  - `DasiaAIO-Backend/src/services/guard_prediction_service.rs`: deterministic scoring service for upcoming-shift guards using weighted heuristic
    - `AbsenceRisk = (previous_absences * 0.5) + (late_checkins * 0.3) + (recent_leave_requests * 0.2)`
    - Inputs are sourced from `punctuality_records`, `guard_availability`, and leave-like `support_tickets` text signals.
  - Service persists explainable prediction artifacts in `guard_absence_predictions` (`explanation`, `contributing_factors`, `source_snapshot`).
  - `DasiaAIO-Backend/src/handlers/ai.rs`: exposes `GET /api/ai/guard-absence-risk` (supervisor+).
  - `DasiaAIO-Backend/src/main.rs`: route registration for `/api/ai/guard-absence-risk` behind analytics view authorization.
- Smart guard replacement surface (new):
  - `DasiaAIO-Backend/src/services/replacement_ai_service.rs`: deterministic recommendation engine for post coverage with scoring model:
    - `ReplacementScore = (reliability_score * 0.4) + (availability * 0.3) + (distance_score * 0.3)`
    - Candidate filters enforce `availability = true` and valid active permit before ranking.
    - Distance scoring uses post coordinates (`client_sites`) and latest guard coordinates (`tracking_points`) via Haversine distance.
  - `suggest_replacement(post_id)` returns top 3 guards and persists explainable records in `smart_guard_replacements` when an active/scheduled shift is found for the post.
  - `DasiaAIO-Backend/src/handlers/ai.rs`: exposes `GET /api/ai/replacement-suggestions?post_id=<client_site_id>` (supervisor+).
  - `DasiaAIO-Backend/src/main.rs`: route registration for `/api/ai/replacement-suggestions` behind analytics view authorization.
- System audit review API (new):
  - `DasiaAIO-Backend/src/handlers/audit.rs`: exposes paginated + filterable reads on `audit_logs` while enforcing `require_min_role('admin')`.
  - Expanded review endpoints now provide:
    - timeline/filter access (`/api/audit/logs`, `/api/audit/logs/filter`)
    - per-user operational stories and hourly activity heatmap data (`/api/audit/user-activity/:id`)
    - anomaly summaries for failed bursts, activity spikes, and suspicious source IPs (`/api/audit/anomalies`)
  - `DasiaAIO-Backend/src/models.rs`: adds `AuditLogEntry`, `AuditLogListResponse`, and `AuditLogPageMeta` so contracts stay typed.
  - `DasiaAIO-Backend/src/main.rs`: registers both legacy and expanded audit endpoint family with authenticated middleware; admin/superadmin policy enforcement is handled in handler-level role gates.

## 10. Frontend Context Snapshot (Keep Updated)

Primary frontend files that must be rechecked when roles/auth/dashboards change:

- `DasiaAIO-Frontend/src/App.tsx`: role-based top-level dashboard routing
- `DasiaAIO-Frontend/src/components/AdminDashboard.tsx`: admin/supervisor dashboard shell + approvals UI
- `DasiaAIO-Frontend/src/components/SuperadminDashboard.tsx`: superadmin shell + approvals UI
- `DasiaAIO-Frontend/src/components/CalendarDashboard.tsx`: role-aware event aggregation and guarded API calls
- `DasiaAIO-Frontend/src/components/MeritScoreDashboard.tsx`: merit API calls and auth headers
- `DasiaAIO-Frontend/src/utils/api.ts`: fetch wrapper behavior, timeout, and parsing safety

Current frontend reality:

- Multi-platform environment routing is active through Vite mode files:
  - `DasiaAIO-Frontend/.env.web`
  - `DasiaAIO-Frontend/.env.mobile`
  - `DasiaAIO-Frontend/.env.desktop`
- API host resolution now uses a strict single source of truth (`VITE_API_BASE_URL`) with startup validation in `DasiaAIO-Frontend/src/config.ts`:
  - Missing/empty URL now falls back to `https://backend-production-0c47.up.railway.app` in production builds to prevent blank-screen startup failures.
  - Non-production sessions still fail fast when `VITE_API_BASE_URL` is missing.
  - Production requires `https://`.
  - Production rejects localhost/private hosts (`localhost`, `127.0.0.1`, `10.*`, `192.168.*`, `172.16-31.*`, `10.0.2.2`).
  - Legacy runtime/query-param fallback paths were removed.
- Runtime platform tagging now sets DOM classes for platform-specific UX (`platform-mobile`, `platform-desktop`, `platform-web`):
  - `DasiaAIO-Frontend/src/utils/platform.ts`
  - `DasiaAIO-Frontend/src/main.tsx`
- Mobile adaptation pass (without dashboard redesign):
  - safe-area padding + touch-focused spacing rules in `DasiaAIO-Frontend/src/index.css`
  - user/approvals/schedule tables include mobile card fallback in `DasiaAIO-Frontend/src/components/AdminDashboard.tsx`
- Build pipeline now includes cross-platform scripts in `DasiaAIO-Frontend/package.json`:
  - `build:web`
  - `build:android`
  - `build:desktop`

- Routing intent is:
  - `superadmin` -> superadmin dashboard path
    - `admin` and `supervisor` -> shared superadmin-style dashboard shell (with role-gated actions)
  - `guard` and legacy `user` -> guard/user path
  - Elevated landing-page fix:
    - `DasiaAIO-Frontend/src/App.tsx` now sets default post-login/home view for all elevated roles (`superadmin`, `admin`, `supervisor`) to `dashboard` instead of `users`, preventing supervisor failures on restricted user-management routes.
    - `DasiaAIO-Frontend/src/App.tsx` now renders the unified elevated shell (`SuperadminDashboard`) for `admin` and `supervisor` so visual structure is consistent across elevated roles.
- Approvals tab exists for elevated roles and is expected in shared elevated navigation surfaces
- Elevated role pages should send `Authorization: Bearer <token>` for protected API calls
- Guard-specific pages must avoid calling endpoints restricted to elevated roles
  - Frontend auth-expiry handling is now centralized:
    - `DasiaAIO-Frontend/src/utils/api.ts`: `fetchJsonOrThrow` now detects invalid/expired-token responses (`401/403` or token-expiry error text), emits a one-time `auth:token-expired` browser event, and throws a normalized session-expired message.
    - `DasiaAIO-Frontend/src/App.tsx`: listens for `auth:token-expired`, clears local auth storage, and returns the UI to the login screen to stop repeated protected polling attempts and console-error spam.
  - `DasiaAIO-Frontend/src/hooks/useOperationalMapData.ts` now uses strict-mode-safe websocket lifecycle management with bounded exponential backoff reconnects, periodic polling fallback continuity, and connection-state tracking (`disabled`/`connecting`/`open`/`backoff`/`closed`) to prevent live-map socket flapping from cascading into dashboard instability.
  - `DasiaAIO-Frontend/src/App.tsx` now uses backend-driven version discovery (`GET /api/system/version`) with GitHub fallback, then presents platform-aware update prompts:
    - web/mobile -> external download flow
    - Tauri desktop -> in-app one-click updater (`@tauri-apps/plugin-updater`) with relaunch.
  - `DasiaAIO-Frontend/src/App.tsx` now includes connectivity resilience UX: online/offline listeners, recurring backend health probe, and a persistent disconnected banner when backend/network is unavailable.
  - Mobile runtime now exposes bottom quick-navigation for key dashboards when running under Capacitor to improve touch access and small-screen workflow continuity.
  - Frontend console-noise suppression for expected auth failures:
    - `DasiaAIO-Frontend/src/utils/logger.ts`: new shared logger utility with `isExpectedAuthNoise(...)` and `logError(...)` to suppress expected invalid-token/session-expiry fetch noise while preserving unexpected-error logging.
    - `DasiaAIO-Frontend/src/components/SuperadminDashboard.tsx`, `DasiaAIO-Frontend/src/components/ArmoredCarDashboard.tsx`, and `DasiaAIO-Frontend/src/components/CalendarDashboard.tsx` now route noisy fetch logs through `logError(...)`.
    - Rollout expanded to additional operational surfaces: `FirearmInventory.tsx`, `FirearmAllocation.tsx`, `EditScheduleModal.tsx`, `FirearmMaintenance.tsx`, `GuardFirearmPermits.tsx`, `MeritScoreDashboard.tsx`, `PerformanceDashboard.tsx`, `NotificationPanel.tsx`, `ProfileDashboard.tsx`, and `UserDashboard.tsx`.
- Guard/profile/support flows were hardened to include bearer headers on protected endpoints (attendance, allocations, tickets, profile update/photo actions)
- UI permission gates in shared elevated shell:
  - `superadmin`: full management actions
  - `admin`: elevated management actions, but no superadmin-targeted destructive controls
  - `supervisor`: operational visibility with restricted user-management actions (for example, no delete-user control)
- Full-width layout guardrails:
  - Global CSS enforces `html/body/#root` full-width/full-height and `body { margin: 0 }`
  - Avoid removing root width/height guarantees when adjusting dashboard overflow behavior, otherwise right-side viewport gaps can reappear
- Header consistency guardrail:
  - Shared `Header` now renders a default `Refresh` button beside theme toggle when a dashboard does not provide a custom `rightSlot` (desktop and mobile)
  - Dashboards with custom right-side controls keep their custom controls
- Role typing/gating centralization is now in place:
  - `DasiaAIO-Frontend/src/types/auth.ts`: defines `Role`, `normalizeRole`, and elevated-role helpers.
    - Role parsing now trims and lowercases role input before validation, then applies legacy `user -> guard` compatibility.
  - `DasiaAIO-Frontend/src/utils/permissions.ts`: defines capability map and `can(...)` helper for UI gating.
  - `DasiaAIO-Frontend/src/utils/permissions.ts`: now also exposes `canAny(...)` and `canAll(...)` for composite UI permission checks.
  - `DasiaAIO-Frontend/src/config/navigation.ts`: single source for role-aware sidebar navigation across elevated and guard workspaces.
  - `DasiaAIO-Frontend/src/App.tsx`: now uses normalized roles and centralized permission checks for dashboard routing decisions.
  - `DasiaAIO-Frontend/src/components/AccountManager.tsx`: legacy `'user'` role-specific branch removed to stay aligned with normalized `Role` typing.
  - `DasiaAIO-Frontend/src/components/dashboard/SectionPanel.tsx` + `DasiaAIO-Frontend/src/components/dashboard/CommandMetricCard.tsx`: reusable command-center layout primitives used for dashboard readability and KPI consistency.
  - `DasiaAIO-Frontend/src/components/dashboard/OperationalSummaryStrip.tsx` + `DasiaAIO-Frontend/src/components/dashboard/QuickActionsPanel.tsx`: shared dashboard modules for command metrics and high-frequency operations shortcuts.
  - `DasiaAIO-Frontend/src/components/dashboard/SystemStatusBanner.tsx`: global SOC status banner rendered at top of the command center with `operational`/`warning`/`critical` state and key metrics (guards, incidents, firearms checked out, deployed vehicles).
  - `DasiaAIO-Frontend/src/components/dashboard/OperationalMapPanel.tsx`: elevated users now have a visible map-header `+ Add Client Site` button to start location creation directly from the map surface.
  - `DasiaAIO-Frontend/src/components/dashboard/LiveOperationsFeed.tsx` + `DasiaAIO-Frontend/src/components/dashboard/SystemInfrastructureStatus.tsx`: new SOC live-storytelling and infrastructure-health panels (status dots, category coloring, chronological event feed).
  - `DasiaAIO-Frontend/src/components/dashboard/MissionTimelinePanel.tsx`: mission progression panel with queued/active/completed tactical states.
  - `DasiaAIO-Frontend/src/components/dashboard/OperationalMapPlaceholder.tsx`: animated tactical map placeholder with radar sweep/ping and active-trip/deployed-guard counters.
  - `DasiaAIO-Frontend/src/components/dashboard/IncidentAlertFeed.tsx`: dedicated incident stream panel for prioritized alerts.
  - `DasiaAIO-Frontend/src/components/dashboard/GuardDeploymentOverview.tsx`: deployment summary cards + guard/site/status table.
  - `DasiaAIO-Frontend/src/hooks/useServiceHealth.ts`: live endpoint probes powering binary service reachability states.
  - `DasiaAIO-Frontend/src/components/SuperadminDashboard.tsx`, `DasiaAIO-Frontend/src/components/AdminDashboard.tsx`, `DasiaAIO-Frontend/src/components/CalendarDashboard.tsx`, and `DasiaAIO-Frontend/src/components/MeritScoreDashboard.tsx` now consume centralized navigation and reduced ad-hoc role checks.
  - `AdminDashboard` and `SuperadminDashboard` now both present command-style summary and quick-action sections to improve cross-role layout consistency and reduce clicks for common operations.
  - `DasiaAIO-Frontend/src/components/SuperadminDashboard.tsx` now uses shared API helpers (`fetchJsonOrThrow`, `getAuthHeaders`) for user/shifts/missions/approvals CRUD and mission/schedule submissions, removing ad-hoc fetch/error parsing.
  - `SuperadminDashboard` shell-logo navigation now synchronizes both internal section state and parent app view state via `onViewChange('dashboard')`.
  - `DasiaAIO-Frontend/src/hooks/useOpsSummary.ts` now targets the correct pluralized firearm allocation endpoints (`/api/firearm-allocations/active`, `/api/firearm-allocations/overdue`) and maps backend response keys (`activeAllocations`/`overdueAllocations`).
  - `DasiaAIO-Frontend/src/components/dashboard/CommandCenterDashboard.tsx` + `DasiaAIO-Frontend/src/hooks/useOpsAlerts.ts` were adjusted so alerts are derived from already-loaded summary state, removing duplicate summary API fetches.
  - Global theming and visual tokens were refactored for SOC-style dual modes:
    - `DasiaAIO-Frontend/src/context/ThemeProvider.tsx`: dark mode is now default (`localStorage`-persisted), still toggles `dark` class on `<html>`, and updates `meta[name='theme-color']`.
    - `DasiaAIO-Frontend/src/index.css`: tokenized tactical dark/light palette aligned to SOC surfaces, status semantics (`success`/`warning`/`danger`/`info`), and shared utilities (`status-bar-*`, `critical-glow`, `command-panel`, `skip-link`).
    - `DasiaAIO-Frontend/src/index.css`: global themed scrollbar system added (WebKit + Firefox) with tokenized track/thumb states and forced-colors fallback.
  - New reusable logo component:
    - `DasiaAIO-Frontend/src/components/SentinelLogo.tsx` now implements the `Target & Scope` reticle-eye concept as pure SVG geometry with Tailwind-aware dark/light adaptation and explicit variants (`IconOnly`, `FullLogo`).
    - `SentinelLogo` now supports `animated?: boolean` and includes a lightweight SVG radar system: rotating sweep beam (~3s), fading trail, pulse rings, and center-eye pulse (no JavaScript timers).
    - `DasiaAIO-Frontend/src/components/Logo.tsx` now serves as compatibility wrapper over `SentinelLogo`.
    - Integration touchpoints updated for variant/animation usage: `DasiaAIO-Frontend/src/components/LoginPage.tsx`, `DasiaAIO-Frontend/src/components/Sidebar.tsx`, `DasiaAIO-Frontend/src/components/Header.tsx`, `DasiaAIO-Frontend/src/components/dashboard/CommandCenterDashboard.tsx`.
  - Command-center visual hierarchy modernization:
    - `DasiaAIO-Frontend/src/components/dashboard/CommandMetricCard.tsx`
    - `DasiaAIO-Frontend/src/components/dashboard/SectionPanel.tsx`
    - `DasiaAIO-Frontend/src/components/dashboard/OperationalSummaryStrip.tsx`
    - `DasiaAIO-Frontend/src/components/dashboard/QuickActionsPanel.tsx`
    - `DasiaAIO-Frontend/src/components/dashboard/CommandCenterDashboard.tsx`
    - `DasiaAIO-Frontend/src/components/dashboard/OpsMetricCard.tsx`
    - `DasiaAIO-Frontend/src/components/dashboard/OpsAlertFeed.tsx`
    - `DasiaAIO-Frontend/src/components/dashboard/OpsTableWidget.tsx`
    - `DasiaAIO-Frontend/src/components/dashboard/OpsSectionGrid.tsx`
    - `DasiaAIO-Frontend/src/components/dashboard/CommandCenterDashboard.tsx` now includes:
      - global operations strip with system status, threat level, active guards, active missions, alert count, and live clock
      - live operations feed with chronological activity categories (guard, vehicle, mission, equipment, system)
      - system infrastructure status panel (Database, API Gateway, Monitoring Nodes, Vehicle Telemetry, Authentication Service)
      - periodic refresh for command metrics/data and subtle live updates
      - mission timeline, operational map placeholder, incident alert feed, and guard deployment overview while preserving existing tactical shell/layout
      - infrastructure status indicators now represent live endpoint reachability (`online` green / `offline` red), not static placeholders
  - Micro-interaction upgrades:
    - `DasiaAIO-Frontend/src/components/dashboard/CommandMetricCard.tsx` animates numeric metric changes.
    - `DasiaAIO-Frontend/src/components/Header.tsx` and `DasiaAIO-Frontend/src/components/SuperadminDashboard.tsx` refresh controls now use rotating refresh-icon feedback.
    - `DasiaAIO-Frontend/src/components/Sidebar.tsx` adds visual group separators between `MAIN MENU`, `OPERATIONS`, and `RESOURCES` without changing nav structure.
  - Guard approvals table consistency update:
    - `DasiaAIO-Frontend/src/components/SuperadminDashboard.tsx` and `DasiaAIO-Frontend/src/components/AdminDashboard.tsx` now always render approval tables with consistent columns (`Guard Name`, `Requested Role`, `Submitted Date`, `Status`, `Actions`) and table-embedded empty state: `No pending guard approvals.`
  - Additional SOC consistency pass for non-command-center operational views:
    - `DasiaAIO-Frontend/src/components/AnalyticsDashboard.tsx`: legacy light-only cards replaced with tokenized command panels and status-bar KPIs.
    - `DasiaAIO-Frontend/src/components/TripManagement.tsx`: error/banner states, action buttons, modal surfaces, and assignment chips updated to SOC token classes.
    - `DasiaAIO-Frontend/src/components/ArmoredCarDashboard.tsx`: alert banners, KPI strip, and tab panels moved to `bento-card`/`command-panel`/`table-glass` hierarchy.
    - `DasiaAIO-Frontend/src/components/MeritScoreDashboard.tsx`: ranking/detail/evaluation surfaces updated to command-panel styling and shared action button styles.
    - `DasiaAIO-Frontend/src/components/CalendarDashboard.tsx`: filter controls, monthly grid states, and day-detail status chips aligned to shared SOC status tokens; added skip link and `main#maincontent` focus target.
    - `DasiaAIO-Frontend/src/components/PerformanceDashboard.tsx`: table header/metric styling aligned to SOC command surfaces; attendance progress bars and task chips moved to semantic token-driven styles; added skip link and `main#maincontent` focus target.
    - `DasiaAIO-Frontend/src/index.css`: added shared SOC utilities for multi-page reuse (`soc-btn*`, `soc-alert-*`, `soc-chip`).
  - Latest command-center and cross-dashboard UX architecture pass:
    - `DasiaAIO-Frontend/src/components/dashboard/CommandCenterDashboard.tsx`: now includes executive SOC header block with clear hierarchy (`System`, `Threat`, `Incidents`, `Clock`) while preserving all command modules and existing API integrations.
    - `DasiaAIO-Frontend/src/components/dashboard/SectionPanel.tsx`: improved accessible heading linkage (`aria-labelledby`) and action region semantics.
    - `DasiaAIO-Frontend/src/components/dashboard/LiveOperationsFeed.tsx` + `DasiaAIO-Frontend/src/components/dashboard/IncidentAlertFeed.tsx`: timeline-like animated entries and clearer severity/timestamp labeling for faster operator scanability.
  - Console-issue remediation pass (March 2026):
    - `DasiaAIO-Backend/src/handlers/audit.rs`: fixed `GET /api/audit-logs` SQL composition by restoring valid spacing/newline query text in the SELECT/FROM segment, resolving server-side `500` syntax failures seen in the audit-log dashboard.
    - `DasiaAIO-Frontend/src/components/AuditLogViewer.tsx`: audit filter controls now include explicit `id`/`name` and `htmlFor` associations (`audit-search`, `audit-result`, `audit-entity-type`, `audit-page-size`) to satisfy browser autofill/accessibility form-field checks.
    - `DasiaAIO-Frontend/src/components/SentinelLogo.tsx` + `DasiaAIO-Frontend/src/index.css`: replaced conflicting dual-class SVG beam animation wiring with unified `sentinel-beam-animated` class and CSS keyframes so radar sweep rotation and opacity pulse run together again; retained `prefers-reduced-motion` fallback.
    - `DasiaAIO-Frontend/src/hooks/useOperationalMapData.ts` + `DasiaAIO-Frontend/.env.local`: websocket map stream remains opt-in via `VITE_ENABLE_TRACKING_WS=true`; if backend rejects websocket upgrade/token, browser will still show connection warnings while periodic polling continues.
    - `DasiaAIO-Frontend/src/components/dashboard/OperationalMapPanel.tsx`: operational legend and usage hints added (without changing map data contracts).
    - `DasiaAIO-Frontend/src/components/CalendarDashboard.tsx`: schedule workspace header and stable tokenized event color classes (using CSS variables) replacing fragile class names.
    - `DasiaAIO-Frontend/src/components/AnalyticsDashboard.tsx`: restructured into SOC surface hierarchy with KPI blocks and accessible utilization progressbars.
    - `DasiaAIO-Frontend/src/components/PerformanceDashboard.tsx`, `DasiaAIO-Frontend/src/components/MeritScoreDashboard.tsx`, `DasiaAIO-Frontend/src/components/ArmoredCarDashboard.tsx`, `DasiaAIO-Frontend/src/components/ProfileDashboard.tsx`: standardized top-level context headers and KPI/section hierarchy for consistent operator workflows.
    - `DasiaAIO-Frontend/src/components/Sidebar.tsx`: navigation IA visuals updated with compact glyph tags while preserving existing route structure and permission-driven grouping.
    - `DasiaAIO-Frontend/src/index.css`: added missing semantic tokens (`status-*`, focus ring, stronger borders) and new shared SOC primitives (`soc-surface`, `soc-kpi`, timeline utilities).
  - Audit-log entity filter parity fix (March 2026):
    - `DasiaAIO-Backend/src/handlers/audit.rs`: `entity_type` filtering now treats `user` and `users` as equivalent aliases so records from both `/api/user/:id` and `/api/users/:id` write routes are returned together under user-management filtering.
    - `DasiaAIO-Backend/src/middleware/audit.rs`: audit-write middleware now logs database insertion failures (`failed to persist audit log entry`) instead of silently swallowing errors, improving forensic reliability diagnostics.
  - Follow-up responsive and micro-interaction hardening:
    - `DasiaAIO-Frontend/src/components/ArmoredCarDashboard.tsx`: inventory tab form grid now stacks on small screens (`grid-cols-1` at mobile, `lg:grid-cols-2`) to avoid cramped two-column rendering.
    - `DasiaAIO-Frontend/src/components/ProfileDashboard.tsx`: message severity detection now treats neutral/success updates (for example, photo removal) as success unless message contains failure/error keywords.
    - `DasiaAIO-Frontend/src/index.css`: added global `prefers-reduced-motion: reduce` handling to disable non-essential radar/pulse/feed animations and shorten transitions for motion-sensitive users.
  - Branded shell/login integration:
    - `DasiaAIO-Frontend/src/components/Header.tsx` and `DasiaAIO-Frontend/src/components/Sidebar.tsx` now embed `SentinelLogo` and use SOC typography/tokens.
    - `DasiaAIO-Frontend/src/components/layout/OperationalShell.tsx` adds an explicit skip link + `main#maincontent` focus target.
    - `DasiaAIO-Frontend/src/components/LoginPage.tsx` now renders a mission-access terminal layout with tactical grid backdrop, branded auth card, and right-side system status panel.
    - `LoginPage` now also includes command-center polish features:
      - subtle full-viewport rotating radar sweep overlay in the background (pure CSS, low-opacity)
      - live-style system status cards with iconography, status lights, and slow node ticker updates
      - terminal-style login action button with glow/elevation hover, active flash/scale, and stronger keyboard focus ring
  - Presence/status and UX polish updates:
    - `DasiaAIO-Frontend/src/components/SuperadminDashboard.tsx` now computes user `Online`/`Offline` state from backend `last_seen_at` recency instead of static labels.
    - `DasiaAIO-Frontend/src/components/SuperadminDashboard.tsx` and `DasiaAIO-Frontend/src/components/AdminDashboard.tsx` now truncate long email/username/name text with hover title for full value visibility.
    - `DasiaAIO-Frontend/src/components/Sidebar.tsx` now persists sidebar scroll position in `sessionStorage` to prevent jump-to-top after navigation/view remounts.
  - User management table architecture upgrade (latest):
    - `DasiaAIO-Frontend/src/components/SuperadminDashboard.tsx` now renders an expanded SOC-style user management workspace with:
      - role filter + status filter + search in one control strip,
      - summary KPI cards (`total`, `active`, `pending`, `supervisors`),
      - status model derived from live/pending metadata (`active`, `inactive`, `pending`, `suspended`),
      - human-readable `Last Login` column (`Just now`, `x minutes ago`, `Yesterday`, etc.),
      - bulk row selection and bulk actions (`Approve Selected`, `Suspend Selected` placeholder, `Delete Selected`),
      - responsive mobile card rendering for user rows.
    - Table now uses reusable local primitives in the same file (`UserAvatar`, `RoleBadge`, `StatusIndicator`) to keep row visuals consistent and reduce duplicated role/status styling logic.
    - Bulk approval uses the existing guard approval endpoint (`PUT /api/users/:id/approval`) only for currently pending rows.
    - Suspension/reset controls are intentionally surfaced as UX placeholders with explicit warning notifications because no dedicated backend suspend/admin-reset endpoints exist in current API contracts.
  - Admin dashboard parity update (latest):
    - `DasiaAIO-Frontend/src/components/AdminDashboard.tsx` now mirrors the same user-management table architecture used by the elevated shell pattern:
      - role + status filtering, search, KPI summary cards, derived user status chips, human-readable last-login column,
      - bulk row selection with bulk actions (`Approve Selected`, `Suspend Selected` placeholder, `Delete Selected`),
      - responsive mobile user cards,
      - role-aware visibility/edit constraints (`admin` excludes `superadmin`; `supervisor` scoped to `guard`).
  - SOC dashboard realism refinement (latest):
    - Added reusable live-freshness UI primitive:
      - `DasiaAIO-Frontend/src/components/dashboard/ui/LiveFreshnessPill.tsx` renders consistent live/delayed/offline status with relative age text.
    - `DasiaAIO-Frontend/src/components/dashboard/CommandCenterDashboard.tsx` now shows `SOC stream` freshness in the command header and keeps sync state aligned with the 15-second refresh cycle.
    - `DasiaAIO-Frontend/src/components/AnalyticsDashboard.tsx` now includes:
      - analytics-feed freshness indicator,
      - KPI deltas versus command targets,
      - operational narrative cards for anomaly/risk/action storytelling.
    - `DasiaAIO-Frontend/src/components/CalendarDashboard.tsx` now includes:
      - mobile-toggle filter panel,
      - operational-state legend (`Scheduled`, `In Progress`, `Needs Attention`, `Completed`),
      - day-cell attention highlighting,
      - selected-day attention counts and event-level recommended actions,
      - calendar-feed freshness indicator.
    - `DasiaAIO-Frontend/src/components/AdminDashboard.tsx` and `DasiaAIO-Frontend/src/components/SuperadminDashboard.tsx` now include:
      - `Roster sync` freshness indicator in user-management control bars,
      - precise `Signal x[s|m|h] ago` metadata next to relative last-login values in desktop and mobile user rows.
    - AI panel action framing upgrades:
      - `DasiaAIO-Frontend/src/components/dashboard/PredictiveAlertsPanel.tsx`: now includes `Suggested action` per alert severity/category.
      - `DasiaAIO-Frontend/src/components/dashboard/GuardAbsencePredictionPanel.tsx`: now includes explicit risk reasons and suggested operator action.
      - `DasiaAIO-Frontend/src/components/dashboard/ReplacementSuggestionPanel.tsx`: now includes recommendation reason and dispatch guidance.
      - `DasiaAIO-Frontend/src/components/dashboard/VehicleMaintenancePredictionPanel.tsx`: now includes urgency note tied to risk level.
  - Calendar bento metric data-source correction (latest):
    - `DasiaAIO-Frontend/src/components/CalendarDashboard.tsx`: `SecurityBentoGrid` inputs are now derived from live fetched calendar events (shifts/trips/missions/maintenance) instead of hardcoded demo values.
    - `DasiaAIO-Frontend/src/components/SecurityBentoGrid.tsx`: removed built-in demo defaults (`24`, `3`, `97`) and made metric data required so callers must pass real values.
  - Real map replacement updates:
    - `DasiaAIO-Frontend/src/hooks/useOperationalMapData.ts`: polls `/api/tracking/map-data` every 15s and exposes site/unit telemetry.
    - `DasiaAIO-Frontend/src/components/dashboard/OperationalMapPanel.tsx`: real OpenStreetMap/Leaflet map with live client-site and guard/vehicle markers.
    - `DasiaAIO-Frontend/src/components/dashboard/CommandCenterDashboard.tsx`: now renders `OperationalMapPanel` instead of placeholder panel.
    - `DasiaAIO-Frontend/src/main.tsx`: imports Leaflet CSS for map rendering.
    - `DasiaAIO-Frontend/package.json`: map dependencies added (`leaflet`, `react-leaflet@4`, `@types/leaflet`).
  - Client-location management + live transport updates:
    - `DasiaAIO-Frontend/src/hooks/useOperationalMapData.ts` now supports:
      - websocket-driven snapshot updates (`/api/tracking/ws`)
      - client-site CRUD helpers (`createClientSite`, `updateClientSite`, `deleteClientSite`)
      - guard geolocation heartbeat submission (`/api/tracking/heartbeat`)
      - guard-history/path intelligence fetchers (`/api/tracking/guard-history/:id`, `/api/tracking/guard-path/:id`)
      - active-guard roster intelligence fetcher (`/api/tracking/active-guards`)
      - geofence alert stream hydration (`geofenceAlerts` in map snapshots)
    - `DasiaAIO-Frontend/src/components/dashboard/OperationalMapPanel.tsx` now includes an elevated-role "Client Location Manager" UI for add/edit/delete site operations directly in the dashboard.
    - `OperationalMapPanel` now supports click-to-place coordinates: operators can press `Pick Position On Map`, click map, and auto-fill latitude/longitude for add/edit workflows.
    - `OperationalMapPanel` now also includes movement-intelligence controls:
      - zoom-to-guard command chips from live active roster
      - patrol trail rendering via guard path endpoint
      - playback scrubber + auto-play trail animation
      - zoom-aware clustered marker rendering for dense map states
      - live geofence enter/exit feed panel
    - `DasiaAIO-Frontend/src/components/UserDashboard.tsx` now includes a guard-facing `Turn On Live Location` / `Turn Off Live Location` control (consent-gated heartbeat flow to backend).
    - Guard location UX now includes:
      - explicit consent gate (`dasi.locationConsent.v1`) before tracking can be enabled,
      - explicit runtime permission prompt trigger when enabling tracking,
      - permission state indicator (`prompt` / `granted` / `denied`),
      - live `Location Accuracy Meter` showing current meter estimate and quality tier,
      - cross-platform location fallback behavior:
        - Web: browser geolocation then IP-based fallback when precise location is unavailable.
        - Capacitor mobile: plugin permission + precise location, then IP-based fallback.
        - Tauri desktop: secure-context geolocation when available, otherwise IP-based fallback.
- Predictive alerts UI (new):
  - `DasiaAIO-Frontend/src/hooks/usePredictiveAlerts.ts`: fetches `/api/alerts/predictive`, stores status/error metadata, and refreshes alongside other SOC telemetry.
  - `DasiaAIO-Frontend/src/components/dashboard/PredictiveAlertsPanel.tsx`: renders command-panel style warning cards (icon + severity border + category chip + context chips).
  - `DasiaAIO-Frontend/src/components/dashboard/CommandCenterDashboard.tsx`: now mounts `PredictiveAlertsPanel` in the left column, refreshes the predictive alerts hook every 15 seconds, and surfaces last-updated metadata for operators.
- Guard absence prediction UI (new):
  - `DasiaAIO-Frontend/src/hooks/useGuardAbsencePrediction.ts`: fetches `/api/ai/guard-absence-risk` and tracks loading/error/refresh timestamps.
  - `DasiaAIO-Frontend/src/components/dashboard/GuardAbsencePredictionPanel.tsx`: renders guard name, risk score, and risk level with SOC color coding (`LOW` green, `MEDIUM` yellow, `HIGH` red).
  - `DasiaAIO-Frontend/src/components/dashboard/CommandCenterDashboard.tsx`: mounts `GuardAbsencePredictionPanel` in the predictive insights section and refreshes it with the existing 15-second command-center polling cycle.
- Smart replacement UI (new):
  - `DasiaAIO-Frontend/src/hooks/useReplacementSuggestions.ts`: resolves active post from `/api/tracking/client-sites`, then fetches `/api/ai/replacement-suggestions` with `post_id` query and tracks loading/error/refresh metadata.
    - Hook now supports both response shapes from `/api/tracking/client-sites` (`ClientSite[]` and `{ sites: ClientSite[] }`) to prevent false empty-state errors.
  - `DasiaAIO-Frontend/src/components/dashboard/ReplacementSuggestionPanel.tsx`: command-center recommendation card showing guard name, reliability score, distance, availability, permit validity, and replacement score.
  - `DasiaAIO-Frontend/src/components/dashboard/CommandCenterDashboard.tsx`: mounts `ReplacementSuggestionPanel` in forward insights and refreshes it within the 15-second command-center polling cycle.
- Command-center AI and data continuity (latest):
  - `DasiaAIO-Frontend/src/components/dashboard/IncidentSeverityClassifier.tsx`: dedicated card for `/api/ai/classify-incident` scoring.
  - `DasiaAIO-Frontend/src/components/dashboard/IncidentSummaryGenerator.tsx`: dedicated card for `/api/ai/summarize-incident` summaries and key phrases.
  - `DasiaAIO-Frontend/src/components/dashboard/CommandCenterDashboard.tsx` now renders only backend-provided operational datasets (mock fallback datasets removed from command surfaces).
  - `DasiaAIO-Frontend/src/components/PerformanceDashboard.tsx` now sources guard performance from `GET /api/analytics/guard-reliability` instead of simulated/randomized rows.
- System audit viewer (new):
  - `DasiaAIO-Frontend/src/hooks/useAuditLogs.ts`: shared hook for fetching `/api/audit-logs` with filter + pagination awareness and consistent error handling.
  - `DasiaAIO-Frontend/src/components/AuditLogViewer.tsx`: renders searchable/filterable audit table with status chips, metadata preview, and paging controls; uses SOC token classes for contrast/compliance.
  - `DasiaAIO-Frontend/src/components/SuperadminDashboard.tsx`: adds `audit-log` section + conditional render + navigation wiring, while `src/config/navigation.ts` introduces the “System Audit Log” nav item (admin & superadmin via `manage_users` permission).
  - Intelligence dashboard upgrade:
    - `DasiaAIO-Frontend/src/components/AuditDashboard.tsx`: new command-style audit intelligence surface (timeline, anomaly panel, heatmap, and operational story feed)
    - `DasiaAIO-Frontend/src/hooks/useAuditIntelligence.ts`: added anomaly and user-activity fetchers (`/api/audit/anomalies`, `/api/audit/user-activity/:id`)
    - `DasiaAIO-Frontend/src/hooks/useAuditLogs.ts`: now targets `/api/audit/logs` and supports advanced filters (`status`, `action_type`, `resource_type`, source/user-agent, date window)
    - `DasiaAIO-Frontend/src/components/SuperadminDashboard.tsx`: `audit-log` section now lazy-loads and renders `AuditDashboard` for investigative workflows
    - `DasiaAIO-Frontend/vite.config.ts`: manual chunking now splits mapping/icons bundles to keep main production chunk below the previous warning threshold
- Production hardening and AI contract update (March 2026):
  - Backend route and middleware updates:
    - `DasiaAIO-Backend/src/error.rs`: added `RateLimited` app error mapped to HTTP `429`.
    - `DasiaAIO-Backend/src/middleware/rate_limit.rs`: new auth-rate limiter middleware with window and request ceilings configurable via environment variables.
    - `DasiaAIO-Backend/src/main.rs`: auth endpoints now pass through rate limiting and system health route now includes `GET /api/health/system`.
    - `DasiaAIO-Backend/src/handlers/health.rs`: system health payload now includes database probe status for runtime readiness checks.
    - `DasiaAIO-Backend/src/utils.rs`: JWT expiry now configurable (`JWT_EXPIRY_HOURS`), bcrypt cost now configurable (`BCRYPT_COST`), token verification failures are normalized to unauthorized responses, and shared pagination helpers were added.
  - Backend API contract updates for scale and AI consistency:
    - `DasiaAIO-Backend/src/handlers/users.rs`: `GET /api/users` now supports paginated response (`total`, `page`, `pageSize`, `users`).
    - `DasiaAIO-Backend/src/handlers/guard_replacement.rs`: list endpoints now support pagination (`get_guard_shifts`, `get_all_shifts`).
    - `DasiaAIO-Backend/src/handlers/incidents.rs`: `GET /api/incidents` and `GET /api/incidents/active` now return paginated metadata with list payload.
    - `DasiaAIO-Backend/src/handlers/ai.rs`: incident AI endpoints now return standardized fields including `riskLevel`, `confidence`, `explanation`, and `suggestedActions`.
  - Frontend runtime and AI presentation updates:
    - `DasiaAIO-Frontend/src/utils/api.ts`: fetch wrapper now supports retry/backoff for retryable failures and offline-aware messaging.
    - `DasiaAIO-Frontend/src/config.ts`: platform-aware API host resolution now supports web/desktop/mobile-specific overrides and safer Capacitor fallback behavior.
    - `DasiaAIO-Frontend/src/hooks/useIncidents.ts`: now supports paginated incident responses while retaining array compatibility.
    - AI panels now surface standardized AI fields (risk, confidence, explanation, suggested actions):
      - `DasiaAIO-Frontend/src/components/dashboard/PredictiveAlertsPanel.tsx`
      - `DasiaAIO-Frontend/src/components/dashboard/GuardAbsencePredictionPanel.tsx`
      - `DasiaAIO-Frontend/src/components/dashboard/ReplacementSuggestionPanel.tsx`
      - `DasiaAIO-Frontend/src/components/dashboard/VehicleMaintenancePredictionPanel.tsx`
      - `DasiaAIO-Frontend/src/components/dashboard/IncidentSeverityClassifier.tsx`
      - `DasiaAIO-Frontend/src/components/dashboard/IncidentSummaryGenerator.tsx`
      - `DasiaAIO-Frontend/src/components/dashboard/IncidentPanel.tsx`
      - `DasiaAIO-Frontend/src/components/dashboard/IncidentReportForm.tsx`

      - Security hardening update (latest):
        - Backend auth hardening:
          - `DasiaAIO-Backend/src/handlers/auth.rs`: login lockout is now database-backed (`auth_login_attempts`) for per-user and per-IP scopes so counters survive restarts and scale across instances.
          - `DasiaAIO-Backend/src/handlers/auth.rs`: login persists refresh token sessions, refresh rotates sessions transactionally, and logout revokes refresh sessions.
          - `DasiaAIO-Backend/src/handlers/auth.rs`: `verify_reset_code` and `reset_password` enforce trimmed input, strict 6-digit reset-code format, and stronger password policy checks.
          - `DasiaAIO-Backend/src/handlers/auth.rs`: forgot-password flow returns generic success for unknown accounts to reduce enumeration risk.
          - Login/refresh response contract remains additive: `token`, `refreshToken`, `tokenType`, `expiresInSeconds`.
        - Token/security utilities:
          - `DasiaAIO-Backend/src/utils.rs`: added `hash_token` for persisted refresh-token fingerprinting.
          - `DasiaAIO-Backend/src/models.rs`: `RefreshTokenRequest` (`refreshToken`) is used for refresh and logout revocation flows.
        - Schema and route updates:
          - `DasiaAIO-Backend/src/db.rs`: added `auth_login_attempts` and `refresh_token_sessions` tables plus indexes.
          - `DasiaAIO-Backend/src/main.rs`: wired `/api/logout` and `/api/auth/logout` alongside refresh routes.
          - `DasiaAIO-Backend/src/main.rs`: global API rate limiting and expensive-endpoint throttling remain active.
        - Audit and schema updates:
          - `DasiaAIO-Backend/src/db.rs`: `audit_logs` includes `source_ip` with supporting index.
          - `DasiaAIO-Backend/src/middleware/audit.rs`: write-audit entries persist requester source IP.
          - `DasiaAIO-Backend/src/handlers/audit.rs` + `DasiaAIO-Backend/src/models.rs`: audit list returns `source_ip` and supports source-IP filtering/search.
        - Frontend auth-session updates:
          - `DasiaAIO-Frontend/src/utils/api.ts`: centralized auth session helpers now include secure-session hydration and Capacitor secure refresh-token persistence when secure plugin is available.
          - `DasiaAIO-Frontend/src/App.tsx`: startup now hydrates secure session state before auth restore and logout now calls backend revocation endpoint.
          - `DasiaAIO-Frontend/src/components/LoginPage.tsx`: login stores both access and refresh tokens; client-side password checks match stronger policy expectations.
        - Desktop/mobile wrapper hardening:
          - `apps/desktop-tauri/src-tauri/tauri.conf.json`: explicit production and development CSP policies are enforced.
          - `apps/android-capacitor/capacitor.config.ts`: Android scheme uses `https` in production builds.
          - `apps/android-capacitor/android/app/src/main/AndroidManifest.xml`: Android backup extraction disabled (`allowBackup=false`, `fullBackupContent=false`).
          - `apps/android-capacitor/package.json`: added `capacitor-secure-storage-plugin` (Capacitor 7-compatible) and synced Android plugins.
        - Validation performed:
          - Backend: `cargo check` completed successfully.
          - Frontend: `npm run build` completed successfully.
          - Mobile wrapper: `npm run build` in `apps/android-capacitor` completed successfully with secure storage plugin present in sync output.
        - Remaining follow-up:
          - For strict compliance in high-security deployments, add device-policy guidance to require screen lock and encrypted storage at OS level, then perform physical-device compromise testing.

## 11. Local Runbook (Docker-first)

From `DasiaAIO-Backend/`:

```bash
docker compose up -d --build
```

Health check:

```bash
curl http://localhost:5000/api/health
```

Expected:

```json
{"status":"ok"}
```

Frontend (from `DasiaAIO-Frontend/`):

```bash
npm install
npm run dev
```

Production account bootstrap helper:

- SQL template file: `DasiaAIO-Backend/scripts/railway_live_account_provision.sql`
- Purpose: promote Dwight to `superadmin` and upsert `admin`/`supervisor`/`guard` accounts in Railway Postgres.
- Replace placeholders before execution.

## 12. Verification Commands

Frontend:

```bash
npm test -- --runInBand
npm run build
```

Backend (runtime validation):

```bash
docker compose config -q
docker compose ps
curl http://localhost:5000/api/health
```

Cross-platform build validation:

```bash
npm run build:web --prefix DasiaAIO-Frontend
npm run build:android --prefix DasiaAIO-Frontend
npm run build:desktop --prefix DasiaAIO-Frontend
```

## 13. Release and Distribution Snapshot (Latest)

- Canonical release workflow:
  - `.github/workflows/release-artifacts.yml`
- Trigger conditions:
  - manual dispatch (`api_base_url` input)
  - tag push matching `v*`

Current release behavior:

- Web artifact:
  - CI now builds and uploads a static web bundle (`sentinel-web-static`) and publishes `sentinel-web-dist.tar.gz` on `v*` tags.
- Desktop artifacts:
  - MSI + EXE are built and uploaded as `sentinel-desktop-installers`.
- Android artifact:
  - CI now always publishes an installable APK (`sentinel-android-release-installable`).
  - If production signing secrets are absent, CI performs fallback signing (ephemeral keystore) so sideload install still works.
- Release guard behavior:
  - release jobs set production runtime flags (`NODE_ENV=production`, plus `CAPACITOR_ENV=production` for Android) and execute frontend release env validation before packaging.
- GitHub Release publishing:
  - For `v*` tags, web, desktop, and android artifacts are attached to the Release entry.

Checkout/build stability updates applied:

- Release workflow now uses pinned `actions/checkout` for both orchestration and frontend repository retrieval.
- Repository submodule metadata is now explicitly declared in `.gitmodules` for `DasiaAIO-Backend` and `DasiaAIO-Frontend`, preventing checkout-time `No url found for submodule path` failures.
- Release checkout steps now explicitly set `submodules: false` to avoid unintended recursive submodule sync during web/desktop/android artifact packaging.
- Web artifact validation now relies on `ensure-production-env.mjs` (required HTTPS/public `VITE_API_BASE_URL`) instead of broad static-string grep checks to avoid false-positive release failures from non-runtime localhost text in bundled assets.
- Android release build sets executable permission on gradle wrapper before execution (`chmod +x gradlew`) to avoid Linux permission failures (`exit 126`).
- Build runtime updated to Node.js 24 in both jobs.

Documentation and licensing distribution updates:

- GitHub Pages docs portal now includes dedicated runtime/distribution pages:
  - `DasiaAIO-Frontend/docs/download.md`
  - `DasiaAIO-Frontend/docs/features.md`
  - `DasiaAIO-Frontend/docs/security.md`
  - `DasiaAIO-Frontend/docs/architecture.md`
- Site landing/navigation were updated in:
  - `DasiaAIO-Frontend/docs/index.md`
  - `DasiaAIO-Frontend/docs/_layouts/default.html`
  - `DasiaAIO-Frontend/docs/_config.yml`
- Repository licensing is now proprietary (`All Rights Reserved`) with `UNLICENSED` package metadata.

Warning interpretation (important):

- Node 20 deprecation warnings may still appear in workflow annotations when third-party actions internally run on Node 20.
- Those warnings are action-runtime warnings, not a failure of the app runtime itself.

## 14. Release Validation Update (March 2026)

- Release workflow run completed successfully for both jobs (`desktop-windows` and `android-release`) with artifacts generated:
  - `sentinel-desktop-installers`
  - `sentinel-android-release-installable`
- Remaining warnings were deprecation notices from upstream GitHub actions runtime and did not block artifact output.

Latest compliance/docs pass (March 28, 2026):

- Backend compile verification: `cargo check` succeeded after legal-consent endpoint and JWT-claim updates (warnings only; no compile errors).
- Frontend verification: `npm run build --prefix DasiaAIO-Frontend` succeeded after consent-modal and legal-link updates.
- Frontend tests: `npm test --prefix DasiaAIO-Frontend -- --runInBand` succeeded (`5/5` tests passing).
- Documentation verification: GitHub Pages docs now include `download`, `features`, `security`, and `architecture` pages plus updated navigation and landing links.

Residual risks / follow-ups:

- Runtime smoke of `/api/legal/consent` and `/api/legal/consent/status` should still be executed against deployed staging/production with real auth tokens.
- License posture is now proprietary; downstream redistribution channels should confirm no stale cached MIT artifacts remain.

Verified in this session (Docker runtime):

- Build/recreate successful via `docker compose up -d --build`.
- Container health: Postgres healthy, backend recreated and serving.
- Role matrix checks passed:
  - `GET /api/users`: `superadmin/admin=200`, `supervisor=403`
  - `GET /api/analytics`: `supervisor=200`, `guard=403`
  - `POST /api/support-tickets`: guard self=200, guard other=403, supervisor on behalf=200
- Legacy hardening checks passed:
  - `GET /api/trips`: admin=200, guard=403
  - `GET /api/guard-firearm-permits`: admin=200, guard=403
  - `GET /api/firearm-maintenance`: admin=200, guard=403
- Audit table verification passed for write actions:
  - Observed both `success|HTTP 201` and `failed|HTTP 403` rows for `POST /api/support-tickets` in `audit_logs`.
- Frontend verification in this session:
  - `npm run build` succeeded
  - `npm test -- --runInBand` succeeded (`5/5` tests passing)
- Frontend verification after role-helper refactor:
  - `DasiaAIO-Frontend/src/App.tsx` diagnostics: no TypeScript errors
  - `npm run build` succeeded (Vite production build)
  - `npm test -- --runInBand` succeeded (`5/5` tests passing)
- Frontend verification after command-center/navigation refactor:
  - Workspace diagnostics: no TypeScript errors
  - `npm run build` succeeded
  - `npm test -- --runInBand` succeeded (`5/5` tests passing)
- Frontend verification after superadmin API-helper unification:
  - `DasiaAIO-Frontend/src/components/SuperadminDashboard.tsx` diagnostics: no TypeScript errors
  - `npm run build` succeeded
  - `npm test -- --runInBand` succeeded (`5/5` tests passing)
- Frontend verification after command-center endpoint and alert-fetch optimization:
  - `npm run build` succeeded
  - `npm test -- --runInBand` succeeded (`5/5` tests passing)
- Frontend verification after SOC visual/theming refactor:
  - Workspace diagnostics: no TypeScript errors in modified frontend files
  - `npm run build` succeeded
- Frontend verification in this hardening pass:
  - Workspace diagnostics: no TypeScript errors in modified AI, incident, API, and config files.
- Backend verification in this hardening pass:
  - Workspace diagnostics: no Rust errors in modified middleware, route, health, incidents, users, and AI handler files.
- Cross-platform build verification in this hardening pass:
  - `npm run build:android --prefix DasiaAIO-Frontend` succeeded, including `npx cap sync android`.
  - `npm run build:desktop --prefix DasiaAIO-Frontend` succeeded, including full Tauri MSI/NSIS bundle generation.
- Remaining validation scope:
  - Device-level runtime smoke checks (native Android device + installed desktop binary).
  - End-to-end API/UX assertion for all newly paginated list endpoints from deployed frontend surfaces.
  - `npm test -- --runInBand` succeeded (`5/5` tests passing)
  - Browser smoke on `http://localhost:4173` verified:
    - command-center top/middle/bottom hierarchy and quick-action console layout
    - skip-link presence and keyboard focus target (`#maincontent`)
    - branded login terminal layout and integrated `SentinelLogo`
    - header theme toggle + dark/light mode switching behavior
- Frontend verification after additional multi-page SOC consistency pass:
  - Workspace diagnostics: no TypeScript errors in modified files
 - Frontend verification after latest user-management table overhaul:
   - `DasiaAIO-Frontend/src/components/SuperadminDashboard.tsx` diagnostics: no TypeScript errors
   - `npm run build` succeeded
- Frontend verification after SOC realism refinement pass:
  - `npm run build --prefix DasiaAIO-Frontend` succeeded
  - `npm --prefix DasiaAIO-Frontend test -- --runInBand` succeeded (`5/5` tests passing)
 - Backend verification after audit-log entity alias fix:
   - `DasiaAIO-Backend/src/handlers/audit.rs` diagnostics: no Rust analyzer errors
   - `cargo check` could not be executed in this session because `cargo` is not available in the active terminal environment.
- Live audit API smoke verification (latest):
  - Backend service rebuilt and restarted locally via Docker compose before test execution.
  - Authenticated admin smoke calls succeeded:
    - `GET /api/audit-logs?page=1&page_size=10` => `200`
    - `GET /api/audit-logs?...&entity_type=users` => `200`
    - `GET /api/audit-logs?...&entity_type=user` => `200`
  - Filter alias parity confirmed in runtime:
    - `entity_type=users` and `entity_type=user` return equal totals.
  - Fresh write-ingestion check confirmed:
    - `POST /api/support-tickets` produced audit row `POST /api/support-tickets` with `result=success` and `reason=HTTP 201`.
  - Fresh user-route filter check confirmed:
    - generated a safe failed `PUT /api/users/:id/profile-photo` (`HTTP 400`) and validated that both `entity_type=users` and `entity_type=user` queries returned that row (`result=failed`).
  - `npm run build` succeeded
  - `npm test -- --runInBand` succeeded (`5/5` tests passing)
  - Browser smoke checks confirmed updated visual system is active on auth and operational workspaces, including armored-car and merit-score flows.
- Frontend verification after final calendar/performance SOC polish:
  - `DasiaAIO-Frontend/src/components/CalendarDashboard.tsx` diagnostics: no TypeScript errors
  - `DasiaAIO-Frontend/src/components/PerformanceDashboard.tsx` diagnostics: no TypeScript errors
  - `npm run build` succeeded
  - `npm test -- --runInBand` succeeded (`5/5` tests passing)
  - Browser smoke (`http://localhost:4173`) confirmed calendar route render and navigation stability; note that long-running local container instances may require refresh/rebuild to reflect latest static bundle text changes.
- Frontend verification after global scrollbar polish:
  - `DasiaAIO-Frontend/src/index.css` diagnostics: no errors
  - `npm run build` succeeded
  - Route-by-route smoke on `http://localhost:4173` covered analytics, calendar, performance, trip management, merit scores, and armored cars without navigation regressions.
- Frontend verification after SentinelLogo redesign:
  - Diagnostics: no TypeScript errors in updated logo/integration files
  - `npm run build` succeeded
  - Runtime check: `http://localhost:5173` loaded successfully after update session (active page reachable)
- Frontend verification after elevated-role routing fix + radar animation refinement:
  - Diagnostics: no TypeScript errors in `App.tsx`, `SuperadminDashboard.tsx`, and updated logo integration files
  - `npm run build` succeeded
  - `npm test -- --runInBand` succeeded (`5/5` tests passing)
  - Rebuilt and relaunched local frontend container on `5173`; supervisor session now lands on the unified dashboard shell (instead of user-management landing), with no blocking UI error banner.
- Frontend verification after tactical login enhancements:
  - Diagnostics: no errors in `SentinelLogo.tsx`, `LoginPage.tsx`, and `index.css`
  - `npm run build` succeeded
  - `npm test -- --runInBand` succeeded (`5/5` tests passing)
- Frontend verification after latest dashboard UX architecture pass:
  - `npm run build` succeeded (Vite production build)
  - Audit dashboard now ships as a dedicated lazy chunk and the main bundle no longer emits the previous >500kb warning.
- Frontend verification after responsive/motion follow-up pass:
  - `npm run build` succeeded
  - Bundle split remains stable with dedicated `mapping`, `icons`, and `AuditDashboard` chunks.
- Frontend verification after auth-expiry handling hardening:
  - `npm run build` succeeded
  - Browser smoke with stale token on `http://127.0.0.1:5173` now returns to login view automatically (instead of repeatedly logging invalid-token fetch errors across dashboard polling calls).
- Frontend verification after logger suppression pass:
  - `npm run build` succeeded
  - Diagnostics: no errors in `utils/logger.ts` and all updated component files listed above.
  - Runtime checks on `http://localhost:5173` confirmed:
    - animated radar logo active (`animateTransform` present)
    - login background radar sweep overlay present (`.login-radar-sweep`)
    - command-style login button class active (`.terminal-login-btn`)
    - system status panel icons/lights rendered and monitoring-node ticker exposed via `aria-live="polite"`
- Frontend runtime smoke (fresh Vite server on `http://localhost:4173`):
  - Admin login succeeded and rendered command-center blocks (`Security Operations Command Center`, quick actions, ops metric cards, and asset/shift widgets).
  - Sidebar role routing and section switching remained operational during smoke checks.
- Production runtime sweep in this session:
  - `GET /api/health` => `200`
  - RBAC matrix: `GET /api/users` => `admin=200`, `supervisor=403`, `guard=403`
  - RBAC matrix: `GET /api/analytics` => `admin=200`, `supervisor=200`, `guard=403`
- Backend endpoint compatibility checks for command-center data:
  - `GET /api/firearm-allocations/active` => `200`
  - `GET /api/firearm-allocations/overdue` => `200` after handler query correction
- Backend verification after latest ownership hardening:
  - Backend rebuilt successfully in Docker (`docker compose up -d --build`)
  - `cargo check` could not be executed in this shell because `cargo` was not available in PATH
- Backend compatibility verification in this session:
  - `POST /api/support-tickets` accepted camelCase `guardId` payload after model alias update
- Frontend verification after SOC command-center operations enhancements + approvals table consistency update:
  - Workspace diagnostics: no errors in modified frontend/backend files
  - `npm run build` succeeded
  - `cargo check` could not be executed in this shell because `cargo` is not available in PATH
- Backend runtime verification after mandatory verification + dashboard follow-up session:
  - `docker compose up -d --build` succeeded in `DasiaAIO-Backend`
  - `docker compose ps` shows backend up and postgres healthy
  - `GET /api/health` returned `200` with `{"status":"ok"}`
  - Non-destructive endpoint probes: unauthenticated `GET /api/users/pending-approvals` returned `401`; invalid `POST /api/verify` returned `400`
- Frontend runtime verification after mission-control panel expansion:
  - `npm run build` succeeded
  - Frontend Docker image rebuilt and relaunched on `http://localhost:5173`
  - Browser smoke confirms command center renders new panels: `Mission Timeline`, `Operational Map`, `Incident Alert Feed`, and `Guard Deployment Overview`
- Account login verification in this session (`POST /api/login`) with provided credentials:
  - `Dwight / december262001` => `200` (`superadmin`)
  - `admin / admin123` => `200` (`admin`)
  - `supervisor / supervisor123` => `200` (`supervisor`)
  - `guard / guard123` => `200` (`guard`)
- Presence/UX verification after sidebar and online-status updates:
  - Backend runtime checks passed: `docker compose config -q`, `docker compose ps`, and `GET /api/health` => `200` (`{"status":"ok"}`).
  - Frontend `npm run build` succeeded.
  - Editor diagnostics (`get_errors`) reported no issues in modified backend/frontend files.
  - `cargo check` remains unavailable in this shell (`cargo` not found in PATH), so compile verification is runtime + diagnostics based.
- Map-tracking verification in this session:
  - Backend container rebuilt successfully; Rust compile completed inside Docker build.
  - Frontend `npm run build` succeeded after Leaflet integration.
  - Browser runtime check (`http://localhost:5173`) confirmed map section now shows `OpenStreetMap live field tracking` and Leaflet attribution.
  - API end-to-end checks succeeded:
    - `POST /api/tracking/client-sites` => `201` (sample site created)
    - `POST /api/tracking/points` => `201` (sample vehicle telemetry point created)
    - `GET /api/tracking/map-data` => includes created site + tracking point payloads
  - Browser snapshot confirmed map counters updated (`Tracked Units: 1`, `Client Sites: 1`).
- Expanded map lifecycle and live-update verification in this session:
  - Backend rebuilt successfully in Docker after websocket + CRUD route additions.
  - Frontend rebuilt and redeployed successfully on `http://localhost:5173` after manager/websocket hook updates.
  - API verification:
    - `POST /api/tracking/client-sites` => `201`
    - `PUT /api/tracking/client-sites/:id` => `200`
    - `DELETE /api/tracking/client-sites/:id` => `200`
    - `POST /api/tracking/heartbeat` (guard token) => `201`
  - Runtime browser verification:
    - Operational map shows `Client Location Manager` with editable site rows and action controls.
    - `Client Sites` counter and site table updated live after a server-side create action (`WS Live Site`) without manual route change, validating websocket delivery.
  - Map UX verification after click-to-pick enhancement:
    - Operational map manager now renders `Pick Position On Map` action and coordinate inputs update from map-click selection flow.
    - Frontend build and diagnostics passed after guard-location toggle addition in `UserDashboard`.
  - Accuracy-meter and permission-prompt verification:
    - Frontend build succeeded after adding permission-state and accuracy UI.
    - No diagnostics issues in `UserDashboard.tsx` and `OperationalMapPanel.tsx`.
  - All-user tracking verification (latest):
    - Runtime probe executed against active local backend on `http://localhost:5000`.
    - `POST /api/tracking/heartbeat` (admin token) => `201` and persisted a `tracking_points` row with `entityType: "user"` and `accuracyMeters` populated.
    - `GET /api/tracking/map-data` returned the new `user` point in `trackingPoints` payload.
    - Heartbeat response contract was normalized from `"Guard heartbeat recorded"` to `"Location heartbeat recorded"` to reflect all-role behavior.
    - Frontend accuracy tuning added:
      - App-level all-user location capture now performs an immediate `getCurrentPosition` call on login and uses fresher geolocation cache (`maximumAge: 2000`) before watch updates.
      - Heartbeat payload status now flags low-precision fixes as `low_accuracy` when `accuracyMeters > 60`.
      - Guard dashboard renders an explicit low-accuracy warning message and operational map popups show `Low GPS precision` for weak fixes.
    - Smoke test after tuning:
      - Frontend `npm run build` passed.
      - Backend services rebuilt and running (`docker compose ps`: backend up, postgres healthy).
      - `GET /api/health` => `200`.
      - `POST /api/tracking/heartbeat` (admin token) => `201` with message `Location heartbeat recorded`.
      - `GET /api/tracking/map-data` includes inserted `user` tracking point with `accuracyMeters` value.
  - User management + map ops updates (latest):
    - User table filter control in `SuperadminDashboard` is now active and role-scoped (`all`, `superadmin`, `admin`, `supervisor`, `guard`).
    - User table ordering now enforces role priority first, then alphabetical name ordering:
      - `superadmin` -> `admin` -> `supervisor` -> `guard`.
    - Operational map symbology updated:
      - Current signed-in user: red location pin and map center anchor.
      - Armored cars: blue circles.
      - Guards: green circles.
      - Client sites: larger yellow circles with 1 km geofence radius overlays.
    - New backend proximity-risk notifications:
      - Added `POST /api/tracking/proximity-alerts/check` (supervisor+).
      - `GET /api/tracking/map-data` now also evaluates one-hour pre-shift proximity risk for scheduled guards and creates leadership notifications (`superadmin`, `admin`, `supervisor`) when guard-to-client distance exceeds 1 km.
      - Notification type: `proximity_alert` with dedupe window.
  - Smoke verification for this update:
    - Frontend build passed (`npm run build`).
    - Backend rebuilt and healthy in Docker.
    - `GET /api/health` => `200`.
    - `POST /api/tracking/proximity-alerts/check` => success (`Proximity alert evaluation complete`).
    - `GET /api/tracking/map-data` => `200` with tracking payload.
  - Map accuracy tuning (latest):
    - Tracking snapshot selection now prefers recent, higher-confidence points:
      - quality preference window: last 10 minutes
      - preferred accuracy threshold: `accuracy_meters <= 80` (or null)
      - fallback remains latest point when no preferred candidate exists
    - Session-derived guard points now require recent tracking telemetry (`recorded_at` within 15 minutes) to reduce stale map positions.
    - Validation:
      - Backend rebuilt successfully after query updates.
      - `GET /api/tracking/map-data` returns payload successfully and includes current user point with expected `accuracyMeters`.
  - Strict accuracy mode (latest):
    - User/guard map points are now strict-filtered to improve reliability:
      - required precision: `accuracy_meters <= 20`
      - required recency: within 3 minutes
      - stale session-overlay guard points were removed from map snapshot composition to avoid drift artifacts.
    - Vehicle points keep a separate recency gate (10 minutes).
    - Ingestion hardening:
      - `POST /api/tracking/heartbeat` now ignores low-precision user/guard samples (returns `202` with `accepted=false`).
      - `POST /api/tracking/points` applies the same low-precision rejection for `entityType` guard/user.
    - Frontend capture hardening:
      - `App.tsx` skips all-user heartbeat submission unless GPS accuracy is <= 20m.
      - `UserDashboard.tsx` skips guard heartbeat submission for low-precision fixes and shows explicit guidance to improve GPS lock.
    - Smoke validation:
      - low-accuracy heartbeat sample (`accuracyMeters=65`) => ignored (`accepted=false`) and absent from map snapshot.
      - high-accuracy heartbeat sample (`accuracyMeters=8`) => recorded and visible in map snapshot.
  - Mobile-vs-PC positioning hardening (latest):
    - Frontend now uses mobile-first geolocation policy:
      - mobile required accuracy threshold: `<= 20m`
      - desktop required accuracy threshold: `<= 8m`
    - Both `getCurrentPosition` and `watchPosition` now request fresh fixes (`maximumAge: 0`, longer timeout) to reduce cached/coarse desktop location artifacts.
    - Guard dashboard messaging now explicitly explains desktop Wi-Fi/IP drift and recommends mobile GPS for reliable tracking.
    - Runtime note: map data contracts still enforce strict backend filtering; frontend policy now further suppresses low-confidence desktop submissions.
  - Permission-prompt UX hardening (latest):
    - Added app-wide location diagnostics banner in `App.tsx` for all logged-in users while geolocation is not granted.
    - Banner includes explicit `Prompt Location Access` action, with context-aware messaging for:
      - denied permission state (site settings remediation)
      - insecure context (HTTPS requirement on mobile/LAN)
      - unsupported geolocation environments.
  - Configurable tracking policy + trust indicators (latest):
    - Added frontend policy utility: `DasiaAIO-Frontend/src/utils/trackingPolicy.ts`.
      - Modes: `strict` and `balanced`.
      - Stores selected mode in `localStorage` key `dasi.trackingAccuracyMode`.
      - Supports env fallback `VITE_TRACKING_ACCURACY_MODE`.
    - Added admin-visible control in `SuperadminDashboard` user-management header:
      - `Accuracy` selector with `Strict` / `Balanced`.
      - Selection persists client-side and shows notification feedback.
    - Operational map trust enhancements in `OperationalMapPanel`:
      - Marker popup now shows `Source`, `Accuracy`, and `Updated: Xs ago`.
      - Stale tracking points are auto-hidden based on current mode thresholds.
      - UI now shows hidden stale count (`stale hidden`) in tracked-units card.
  - Backend policy configurability (latest):
    - `tracking.rs` now reads configurable policy from environment:
      - `TRACKING_ACCURACY_MODE` (`strict`/`balanced`)
      - `TRACKING_REQUIRED_ACCURACY_METERS`
      - `TRACKING_PERSON_RECENCY_MINUTES`
      - `TRACKING_VEHICLE_RECENCY_MINUTES`
    - If override vars are absent, mode defaults are applied.
  - Regression checks (latest):
    - Added script: `scripts/tracking_smoke_test.ps1`.
      - Verifies health, auth, low-accuracy rejection, high-accuracy acceptance, and map snapshot visibility rules.
    - Added checklist: `scripts/tracking_permission_checklist.md`.
      - Covers manual geolocation prompt validation and trust-indicator/stale-point UI checks.
    - Script runtime validation in this session: `PASS: tracking smoke test succeeded.`
  - Deployment note:
    - These latest changes are validated locally (Docker + local runtime) and intentionally not pushed/deployed to Railway yet.
  - Command-center UX update (latest):
    - `CommandCenterDashboard` now renders `SystemStatusBanner` above the main section stack for high-visibility system health.
    - Banner color and glow are state-driven (`green` operational, `yellow` warning, `red` critical) and derived from existing alert severity logic.
    - Banner metrics currently map to: `Guards Active`, `Active Incidents` (warning+critical), `Firearms Checked Out`, and `Vehicles Deployed`.
  - Incident Management module (latest):
    - Backend — new `incidents` table (PostgreSQL, auto-migrated on startup via `db.rs`):
      - Columns: `id`, `title`, `description`, `location`, `reported_by` (FK → `users.id`), `status` (open/investigating/resolved), `priority` (low/medium/high/critical), `created_at`, `updated_at`.
      - Index: `idx_incidents_status_priority_created` on `(status, priority, created_at DESC)`.
    - Backend — new handler file `handlers/incidents.rs` exposing 4 endpoints:
      - `POST   /api/incidents`           — create incident (min role: `guard`)
      - `GET    /api/incidents`           — all incidents, ordered by `created_at DESC` (authenticated)
      - `GET    /api/incidents/active`    — open/investigating, ordered by priority weight then time (authenticated)
      - `PATCH  /api/incidents/:id/status` — update status (min role: `supervisor`)
    - Backend — new models in `models.rs`: `Incident`, `CreateIncidentRequest` (camelCase serde), `UpdateIncidentStatusRequest`.
    - Frontend — `src/hooks/useIncidents.ts`:
      - Polls `GET /api/incidents/active`, exposes `{ incidents, activeCount, loading, error, lastUpdated, refresh, reportIncident, updateStatus }`.
      - `reportIncident()` → POST, `updateStatus()` → PATCH, both trigger auto-refresh.
    - Frontend — `src/components/dashboard/ActiveIncidentsWidget.tsx`:
      - SOC widget with priority color coding: `critical=red`, `high=orange`, `medium=yellow`, `low=green`.
      - Shows incident title, location, priority badge, status, and time reported.
      - Remains available as a reusable tactical incident list widget.
    - Frontend — `src/components/dashboard/IncidentReportForm.tsx`:
      - Accessible form (WCAG 2.2 AA): `aria-required`, `aria-invalid`, `aria-describedby`, focus management on first invalid field on submit.
      - Fields: title, description, location, priority select.
    - Frontend — `src/components/dashboard/IncidentPanel.tsx`:
      - Full management panel: filter tabs (all/open/investigating/resolved), table with priority/status badges.
      - Status advancement buttons (investigating → resolved) gated to `supervisor`/`admin`/`superadmin` via `normalizeRole()`.
      - Embeds `IncidentReportForm` toggle for all roles.
    - Frontend — `CommandCenterDashboard.tsx` updated:
      - Imports `useIncidents` and uses incidents state to drive middle-section AI monitoring cards.
      - `activeIncidents` in `SystemStatusBanner` now prefers real `incidentsState.activeCount` over alert-derived count.
      - Refresh interval includes `incidentsState.refresh()`.
    - Browser smoke (latest): `ActiveIncidentsWidget` renders in dashboard — "Active Incidents" heading, live timestamp, "No active incidents" with empty DB confirmed.
  - Operational Activity Feed (latest):
    - Component `OperationalActivityFeed.tsx` remains available for tactical event-stream use.
    - `CommandCenterDashboard` was later refactored to prioritize AI module sections; activity feed generation was removed from this view.
  - Predictive Vehicle Maintenance (latest):
    - Backend — new service `DasiaAIO-Backend/src/services/vehicle_predictive_service.rs`:
      - Exposes `predict_vehicle_risk(vehicle_id)` and fleet aggregation helper.
      - Inputs include armored car mileage, last maintenance date, and maintenance history/trip telemetry.
      - Deterministic risk formula:
        - `MaintenanceRisk = (mileage_since_service * 0.5) + (days_since_service * 0.5)`
        - Service applies normalization (mileage/10,000 and days/180) so persisted `risk_score` remains in `[0,1]` for `predictive_vehicle_maintenance` table constraints.
      - Returns `LOW | MEDIUM | HIGH` with recommended maintenance action text.
      - Persists generated predictions to `predictive_vehicle_maintenance`.
    - Backend — AI endpoint contract:
      - `GET /api/ai/vehicle-maintenance-risk` (supervisor+) now returns fleet risk rows with:
        - `vehicleId`, `licensePlate`, `riskScore`, `riskLevel`, `mileageSinceService`, `daysSinceService`, `maintenanceHistoryCount`, `recommendedAction`, `formula`, `calculatedAt`.
      - Route registered in `DasiaAIO-Backend/src/main.rs` with analytics-view authorization.
    - Frontend — new SOC panel wiring:
      - `DasiaAIO-Frontend/src/hooks/useVehicleMaintenancePrediction.ts` fetches `/api/ai/vehicle-maintenance-risk` and tracks loading/error/refresh metadata.
      - `DasiaAIO-Frontend/src/components/dashboard/VehicleMaintenancePredictionPanel.tsx` renders vehicle identifier, risk score, risk level, and recommended action.
      - `DasiaAIO-Frontend/src/components/dashboard/CommandCenterDashboard.tsx` now mounts the vehicle panel in the Bottom Section and includes it in the 15-second refresh cycle.
    - Validation in this session:
      - Backend Docker rebuild/restart succeeded after adding the new service and route.
      - Frontend `npm run build` succeeded after panel/hook integration.
      - Runtime API verification:
        - `POST /api/incidents` created a test incident successfully.
        - `GET /api/incidents/active` returned the created active incident.
        - `GET /api/ai/vehicle-maintenance-risk` returned `200` with an empty array in current seed state (no vehicles scored).
      - Browser smoke:
        - `Predictive Vehicle Maintenance` panel is visible in the command center and renders empty-state text when no vehicles are available.
  - Guard reliability 500 fix (latest):
    - Backend — `DasiaAIO-Backend/src/handlers/analytics.rs`:
      - `get_guard_reliability` SQL now casts score expressions to `NUMERIC` before `ROUND(..., 2)`.
      - Fix resolves PostgreSQL error `function round(double precision, integer) does not exist` that previously caused dashboard reliability widget failures.
    - Validation:
      - `GET /api/analytics/guard-reliability` now returns `200` with ranked guard rows.
      - Browser dashboard no longer shows the prior `Failed to fetch guard reliability` error banner after refresh.
  - AI Incident Summarization (latest):
    - Backend — new service `DasiaAIO-Backend/src/services/incident_summary_service.rs`:
      - `extract_key_phrases(description)` selects high-signal keywords after stopword filtering.
      - `summarize_incident(description)` returns a deterministic 1-2 sentence summary.
    - Backend — API contract:
      - `POST /api/ai/summarize-incident` (authenticated) accepts `{ description }`.
      - Returns `{ summary, keyPhrases }` in camelCase response shape.
      - Route wired in `DasiaAIO-Backend/src/main.rs`; handler added in `src/handlers/ai.rs`.
    - Frontend — Incident panel summary preview:
      - `DasiaAIO-Frontend/src/components/dashboard/IncidentPanel.tsx` now adds an on-demand `Preview AI Summary` action per incident row.
      - Summary is rendered inline under the incident title after generation, with loading/error feedback.
    - Validation:
      - Runtime API check for `POST /api/ai/summarize-incident` returns summary + extracted key phrases.
      - Frontend build succeeds with summary preview integration.
  - Command center AI layout refactor (latest):
    - Frontend — `DasiaAIO-Frontend/src/components/dashboard/CommandCenterDashboard.tsx`:
      - Layout now follows a strict three-tier SOC module stack with tactical section headers:
        - Top Section: `GuardAbsencePredictionPanel`
        - Middle Section: `IncidentSeverityMonitoringPanel` + `ReplacementSuggestionPanel`
        - Bottom Section: `VehicleMaintenancePredictionPanel` + `PredictiveAlertsPanel` (retitled in-view as `AI Operational Insights`)
      - New `IncidentSeverityMonitoringPanel.tsx` provides high-density severity counters (critical/high/medium/low) and active incident rows with status + severity indicators.
      - Dashboard keeps dark command-center styling and maintains 15-second polling across all AI modules.
    - Frontend — `DasiaAIO-Frontend/src/components/dashboard/PredictiveAlertsPanel.tsx`:
      - Added optional `title` and `subtitle` props so the same panel can be presented as `AI Operational Insights` without duplicating logic.
    - Validation:
      - `npm run build` succeeds after the refactor.
      - Browser snapshot confirms Top/Middle/Bottom section headings and all required AI panels render in order.
  - Command center operational module restoration (latest):
    - Frontend — `DasiaAIO-Frontend/src/components/dashboard/CommandCenterDashboard.tsx`:
      - Restored critical command-center modules while keeping all new AI modules active.
      - Current dashboard section flow:
        - `System Status`: `SystemStatusBanner` + `OperationalSummaryStrip`
        - `Tactical View`: `OperationalMapPanel` + `GuardDeploymentOverview`
        - `Live Operations`: `LiveOperationsFeed` + `IncidentAlertFeed` + retained AI overlays (`IncidentSeverityMonitoringPanel`, `AI Operational Insights` via `PredictiveAlertsPanel`)
        - `Operations Management`: `TodaysShiftOperations` + `GuardAbsencePredictionPanel` + `ReplacementSuggestionPanel`
        - `Asset Monitoring`: `VehicleMaintenancePredictionPanel` + `FirearmsStatusPanel`
      - Feed wiring uses existing hook-backed data sources (`useOpsShifts`, `useOpsAssets`, `useIncidents`, `getOpsAlerts`) and stays on the existing 15-second polling cycle.
    - Frontend — newly restored components:
      - `DasiaAIO-Frontend/src/components/dashboard/TodaysShiftOperations.tsx`
      - `DasiaAIO-Frontend/src/components/dashboard/FirearmsStatusPanel.tsx`
    - Validation:
      - Frontend build passes after restoration (`npm run build`).
      - Browser snapshot verifies all required restored modules render in the command center alongside AI modules.
  - Full system audit closure (latest):
    - Backend endpoint matrix verified with authenticated smoke tests:
      - `GET /api/incidents`
      - `GET /api/incidents/active`
      - `GET /api/guards`
      - `GET /api/vehicles`
      - `GET /api/ai/guard-absence-risk`
      - `GET /api/ai/replacement-suggestions?post_id=<active_client_site_id>`
      - `GET /api/ai/vehicle-maintenance-risk`
      - `POST /api/ai/classify-incident`
      - `POST /api/ai/summarize-incident`
    - Replacement suggestion 404 root cause was test-input related (invalid/nonexistent `post_id`); verified healthy behavior returns `200` with valid active client-site id.
    - Frontend runtime snapshot confirms all required command-center sections and modules render:
      - `System Status`, `Tactical View`, `Live Operations`, `Operations Management`, `Asset Monitoring`
      - `Operational Map`, `Guard Deployment Overview`, `Live Operations Feed`, `Incident Alert Feed`, `Today's Shifts`, `Firearms Status`
      - `Guard Absence Prediction`, `Smart Guard Replacement`, `Predictive Vehicle Maintenance`, `Incident Severity Classifier`, `Incident Summary Generator`
    - Requested architecture document created: `architecture.md`.

Role-based runtime sweep (recommended):

- Log in as `admin`, `supervisor`, and `guard`
- Navigate all sidebar routes available per role
- Confirm browser network has no `4xx/5xx` responses for expected API calls

## 13. Known Gaps / Watchouts

- Some legacy queries still include `role = 'user'` for migration safety and should eventually be fully migrated to `guard`.
- Route-level RBAC coverage is significantly expanded; keep enforcing middleware-first policy for any newly introduced privileged endpoint to prevent drift.
- Frontend still shares dashboard surfaces for some elevated roles; backend authorization remains the source of truth.
- Visual design parity between `AdminDashboard` and `SuperadminDashboard` is improved functionally but can still be unified further.
- Continue auditing newly added UI actions for missing auth headers whenever a component introduces a fresh `/api/*` call.
- Frontend local smoke depends on API base URL targeting an available backend. When frontend points to production while local backend is expected (or vice versa), dashboard widgets can show partial data/loading states even if UI wiring is correct.
- Existing build warnings remain for unused structs/fields in some modules. These are non-blocking for current runtime but should be tracked.
- Railway CLI was not available in this environment (`railway` command not found), so production account SQL could not be executed directly from this machine.
- User presence currently uses an activity recency window (`last_seen_at`) as the online heuristic, not websocket session tracking.
- Operational map supports websocket push updates (`/api/tracking/ws`) and also keeps a periodic refresh fallback in the frontend hook.
- Location submission is consent-gated first. When consent is accepted, tracking attempts precise runtime geolocation and degrades to IP-based fallback when permission is denied or unavailable.
- Location precision remains environment-dependent (device GPS, OS settings, browser permissions, network conditions), so accuracy can vary even when tracking is functioning correctly.
- `replacement_status` is not present in all deployed `shifts` schemas; proximity-alert logic intentionally avoids hard dependency on that column for compatibility.

## 14. Suggested Prompt for Any Future ChatGPT Session

Use this prompt:

"Read `CHATGPT_SYSTEM_GUIDE.md` first. Then inspect backend auth role constraints and frontend role routing before proposing role-related changes. Keep recommendations aligned to current code reality, not only documentation claims."

## 15. Mandatory Update Protocol (Every Session)

When any change touches auth, roles, dashboards, account lifecycle, or API contracts, update this guide in the same session before handoff.

Minimum required update checklist:

- Backend context delta:
  - Routes added/removed/changed
  - Handler logic changes (auth, RBAC, approvals, notifications)
  - DB/migration or table contract changes
- Frontend context delta:
  - Role routing changes in `App.tsx`
  - Dashboard behavior/nav changes per role
  - API call/auth-header changes in affected components
- Validation delta:
  - Build/test/runtime verification performed
  - Any unresolved risks or gaps

Do not leave this file stale after role/auth/dashboard work.

## 16. Maintainer Notes

If you change roles, auth, or major endpoints, update this file immediately so future AI sessions stay accurate.
