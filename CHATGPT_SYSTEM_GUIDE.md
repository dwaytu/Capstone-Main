# SENTINEL System Guide for ChatGPT

This document is a high-signal handoff so a new ChatGPT session can quickly understand the full project.

## 1. What This System Is

SENTINEL is a mission and decision-support system for Davao Security & Investigation Agency.
It combines governed operational records, real-time field signals, policy enforcement, and assistive analytics so command roles can decide:

- who is deployable
- which assets are compliant
- where field personnel are operating
- what incidents or exceptions require intervention

The platform is built to reduce delayed detection, strengthen accountability, and preserve legally defensible operational history across web, desktop, and Android runtimes.

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
- Password-reset codes are now generated at 8 digits by default, stored as hashes (not plaintext), and validated with account/IP lockout checks to reduce brute-force risk.
- Password reset now redeems tokens atomically and revokes active refresh-token sessions in the same transaction after password update.
- `POST /api/resend-code`, `POST /api/verify-reset-code`, and `POST /api/reset-password` now return enumeration-safe responses that do not disclose whether an account exists.

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

### E. Missions, Merit, Analytics, Feedback, Tickets, Notifications

- Mission assignment and retrieval
- Merit score calculation/rankings/evaluations/overtime candidates
- Analytics summary/trends and mission status update
- Feedback collection and review:
  - `POST /api/feedback` (authenticated single submission per user)
  - `GET /api/feedback/status` (authenticated submission-state check)
  - `GET /api/feedback` (superadmin feedback dashboard feed)
- Support ticket create/list
- User notifications list/read/delete/unread count

### F. MDR Import and Reconciliation

- MDR batch intake with staging + review gates for roster-derived records
- Match/review workflow for staged rows before write-through to operational tables
- Transactional batch commit/reject flow with batch status transitions and audit metadata
- MDR endpoints:
  - `POST /api/mdr/import`
  - `GET /api/mdr/batches`
  - `GET /api/mdr/batches/:id`
  - `GET /api/mdr/batches/:id/review`
  - `PATCH /api/mdr/staging/:id/resolve`
  - `POST /api/mdr/batches/:id/commit`
  - `POST /api/mdr/batches/:id/reject`

## 6. Data and Database Notes

Database initialization occurs in backend startup (`run_migrations` in `db.rs`).
Main table domains include:

- `users`, `verifications`, `password_reset_tokens`
- `shifts`, `attendance`, replacement/availability related tables
- `firearms`, `firearm_allocations`, permit/maintenance related tables
- `armored_cars`, car allocations, trips, driver assignments, vehicle maintenance
- Notifications, tickets, merit-related tables
- MDR import pipeline tables: `mdr_import_batches`, `mdr_staging_rows`
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
- `fetchJsonOrThrow` auth-expiry classification now treats permission-denied `403` responses as non-expiry errors unless token-expiry indicators are present, preventing valid sessions from being force-logged out on role-based access denials.

Client access governance hardening:

- `DasiaAIO-Frontend/src/App.tsx` now enforces a first-use Terms of Agreement gate across Web, Desktop (Tauri), and Mobile (Capacitor) runtimes.
- Access is blocked by an application modal until users explicitly agree, and final acceptance is persisted server-side through `POST /api/legal/consent`.
- Legal acceptance metadata (`consentAcceptedAt`, `consentVersion`, `legalConsentAccepted`) is now returned by login and used for restore-auth gating.
- Consent recording now captures compliance trace metadata (`consent_ip`, `consent_user_agent`) in the `users` table.
- `App.tsx` consent modal now links directly to repository legal documents (`TermsOfAgreement.md`, `PrivacyPolicy.md`, `AcceptableUsePolicy.md`) in the active `dwaytu/Capstone-Main` repository.
- `DasiaAIO-Frontend/src/App.tsx` now checks backend release metadata (`GET /api/system/version`) with GitHub fallback, then prompts users to update when a newer release than `VITE_APP_VERSION` is available.
- `DasiaAIO-Frontend/src/App.tsx` now includes a manual "Check for Updates" action in addition to scheduled update checks.
- `DasiaAIO-Frontend/src/App.tsx` now renders a one-time per-version "What's New" dialog sourced from `VITE_WHATS_NEW`, persisted locally via version-scoped keys.
- `DasiaAIO-Frontend/src/config.ts` now exposes app/update metadata (`APP_VERSION`, `APP_WHATS_NEW`, `LATEST_RELEASE_API_URL`, `RELEASE_DOWNLOAD_URL`) and resolves API base URL strictly from `VITE_API_BASE_URL`.
- Runtime API fallback paths were removed to prevent cross-platform drift between web, desktop, and mobile clients.
- Frontend release scripts now enforce production env safety via `DasiaAIO-Frontend/scripts/ensure-production-env.mjs`, blocking unsafe releases when `VITE_API_BASE_URL` is missing/non-HTTPS/private-host or when `VITE_APP_VERSION` is not a semantic release value.
- `DasiaAIO-Frontend/src/utils/location.ts` now uses CORS-compatible IP geolocation providers (`ipinfo.io` with `geolocation-db.com` fallback) plus short-lived caching to avoid repeated blocked external requests when precise GPS is unavailable.
- Elevated dashboard layout uses a fixed-shell contract: sidebar is fixed, app shell is viewport-locked (`h-[100dvh]`), and only main content regions own vertical scrolling.
- `DasiaAIO-Frontend/src/components/layout/OperationalShell.tsx` now enforces `main` as a `min-h-0 overflow-hidden` container with a dedicated `overflow-y-auto` content pane, preventing nested body/document scroll drift.
- `DasiaAIO-Frontend/src/components/layout/OperationalShell.tsx` now owns desktop sidebar collapse state and persists user preference in `localStorage` via `dasi.sidebar.collapsed`, while `DasiaAIO-Frontend/src/components/Sidebar.tsx` applies synchronized fixed-width transitions (`18rem` expanded, `4rem` collapsed) and retains full-label behavior for the mobile drawer.
- Shared elevated dashboard roots (`FirearmInventory`, `FirearmAllocation`, `FirearmMaintenance`, `GuardFirearmPermits`, `PerformanceDashboard`, `MeritScoreDashboard`, `ArmoredCarDashboard`, `CalendarDashboard`, `ProfileDashboard`) now use `h-[100dvh]` + `overflow-hidden` shells and `min-h-0` main columns to eliminate overlap/clipping between fixed sidebar and content.
- Global shell styling in `DasiaAIO-Frontend/src/index.css` now locks `html/body/#root` to full height with hidden document overflow and moves atmospheric gradient rendering to a fixed background layer (`body::before`) so decorative layers no longer interfere with scrollable content.
- Frontend theming now uses an expanded semantic token contract in `DasiaAIO-Frontend/src/index.css` covering dual light/dark palettes, component surfaces, interactive states, role badges, overlays, and status tones (`.soc-*` utility classes) for consistent SOC visual behavior.
- Shared shell components (`Sidebar`, `Header`, `SectionBadge`, `AccountManager`, `NotificationPanel`, `LoginPage`) were refactored to consume tokenized classes instead of hardcoded hex/rgba inline colors.
- `DasiaAIO-Frontend/src/context/ThemeProvider.tsx` now initializes theme state synchronously from persisted preference/system fallback and applies root theme classes in a layout effect to reduce first-paint theme flicker.
- A follow-up dashboard consistency pass normalized residual micro-typography and control spacing in `Sidebar`, `AuditDashboard`, `IncidentPanel`, and `IncidentSeverityClassifier`, aligning compact labels/chips and action control heights without changing module behavior.
- A production-readiness UI hardening pass now enforces a unified front-end layering contract in `DasiaAIO-Frontend/src/index.css` (map panes, sticky shells, drawers, floating notices, overlays, and modal tiers) to prevent cross-module z-index collisions.
 Shared shell controls were refined for readability and mobile stability: `Header` now truncates long titles cleanly on narrow viewports, `Sidebar` spacing follows an 8px rhythm with reduced overlap risk, and header overlays use predictable stack layers instead of ad-hoc high z-values.
- Elevated and guard shells now use a shared header global-actions contract (`DasiaAIO-Frontend/src/components/shared/HeaderGlobalActions.tsx`) that keeps sidebar navigation focused on primary destinations while moving quick inbox, settings, refresh, theme, and profile controls into the fixed top-right header.
- `DasiaAIO-Frontend/src/components/shared/useOverlayController.ts` now centralizes mutually exclusive header overlay state so quick inbox, settings drawer, and profile menu share Escape/outside-close behavior and focus restoration patterns.
- `DasiaAIO-Frontend/src/components/NotificationPanel.tsx` now functions as a compact role-aware quick inbox instead of a sidebar destination. It surfaces high-priority items, degraded-state notices, and a fallback action to the full `inbox` view without removing existing view-state support. The panel now sanitizes incomplete user context and malformed summary items before render so header overlays cannot crash the elevated or guard shell during partial-load states.
- `DasiaAIO-Frontend/src/components/admin/SuperadminDashboard.tsx` now explicitly maps route-derived `activeView='inbox'` to `activeSection='inbox'` in its view-sync effect, with an updater-safe state comparison. This keeps elevated-role "View Full Inbox" header actions synchronized with `/inbox` route navigation and reliably renders role-specific inbox panels.
- `DasiaAIO-Frontend/src/components/settings/SettingsPanel.tsx` and `DasiaAIO-Frontend/src/components/settings/RoleSettingsContent.tsx` now provide a shared slide-over settings surface in the header while preserving the full `settings` route as a fallback screen for direct view navigation and recovery flows. `DasiaAIO-Frontend/src/components/layout/OperationalShell.tsx` now suppresses empty sidebar chrome when a role resolves to no sidebar navigation items, so guard access to `/settings` renders as a full-width workspace instead of an empty elevated shell.
- Elevated sidebar navigation (`DasiaAIO-Frontend/src/config/navigation.ts`) now restores `Calendar` as a first-class destination for `superadmin`, `admin`, and `supervisor` roles, while mobile elevated bottom tabs remain focused on `Dashboard`, `Approvals`, `Schedule`, and `Alerts` with `More` overflow.
- Feedback UI is now role-governed in navigation and routing:
  - `DasiaAIO-Frontend/src/components/feedback/FeedbackForm.tsx` provides authenticated 5-star + optional-comment submission for `guard`, `supervisor`, and `admin`, including preflight `/api/feedback/status` checks, conflict-safe `409` handling, and shell-contained loading/error/success states.
  - `DasiaAIO-Frontend/src/components/feedback/FeedbackDashboard.tsx` provides superadmin-only feedback review with average rating summary, submission counts, tabular entries, and inline loading/error/empty states under `OperationalShell`.
  - `DasiaAIO-Frontend/src/router/index.tsx`, `src/router/routes.ts`, `src/router/guards.tsx`, and `src/components/layout/AppShell.tsx` now register `/feedback` and `/feedback-dashboard` with role-specific guards and keep both routes in OperationalShell view handling.
  - `DasiaAIO-Frontend/src/config/navigation.ts` and `src/components/Sidebar.tsx` now expose Feedback navigation entries only where the route is a primary destination. Superadmin retains the sidebar entry for `/feedback-dashboard`, while `admin`, `supervisor`, and `guard` reach feedback intentionally from role-specific Settings content and profile/menu routing rather than a persistent sidebar destination.
- URL-accessible elevated routes intentionally excluded from sidebar chrome are now explicitly documented in `DasiaAIO-Frontend/src/router/routes.ts` via `ELEVATED_URL_ONLY_ROUTES` (`/permits`, `/inbox`, `/profile`, `/support`, `/shift-swaps`, `/notifications`, `/trips`).
- Command-center AI panels (`PredictiveAlertsPanel`, `IncidentSeverityClassifier`, `IncidentSummaryGenerator`) now use semantic status tokens (`*-bg`, `*-border`, `*-text`) instead of hardcoded dark-only text classes, fixing light-mode contrast regressions.
- Analytics charts in `DasiaAIO-Frontend/src/components/AnalyticsDashboard.tsx` now set SVG label/axis fill and baseline stroke directly from semantic CSS tokens (`--color-text-primary`, `--color-text-secondary`, `--color-border-elevated`) for consistent readability in both dark and light themes.
- Operational map role gating in `DasiaAIO-Frontend/src/hooks/useOperationalMapData.ts` now aligns with backend tracking authorization: only `supervisor` and `guard` roles access tracking endpoints, and client-site add/edit/delete controls remain supervisor-only to prevent admin/superadmin tracking 403 console noise.
- Direct `Header` consumers with view-state routing context (`ArmoredCarDashboard`, `FirearmInventory`, `FirearmAllocation`, `FirearmMaintenance`, `GuardFirearmPermits`, and `MeritScoreDashboard`) now pass shared `onNavigateToInbox` and `onNavigateToSettings` callbacks so top-right actions stay consistent across elevated resource pages while the sidebar remains limited to primary navigation.
- `DasiaAIO-Frontend/src/utils/pushNotifications.ts` now short-circuits service-worker registration in Vite development and clears existing localhost registrations/caches from `src/main.tsx` startup so the web shell cannot be pinned to stale cached chrome during dashboard iteration. Production push/offline behavior continues to use `/sw.js`.
- `DasiaAIO-Frontend/vite.config.ts` now pins dev HMR client behavior to localhost (`server.hmr.host`, `clientPort`, `strictPort`) so VS Code integrated-browser sessions avoid localhost/127.0.0.1 websocket drift and consistently load current shell updates.
- `DasiaAIO-Frontend/src/components/layout/OperationalShell.tsx` now accepts a shared `onRefresh` callback so elevated dashboards use a single header refresh action instead of duplicating page-specific refresh buttons alongside global controls.
- `DasiaAIO-Frontend/src/App.tsx` and `DasiaAIO-Frontend/src/components/NotificationCenter.tsx` now keep persistent connectivity/toast messaging out of the header hit area by using narrower shell status trays with large-screen offsets, reducing overlap with navigation and command actions during degraded backend states.
- `DasiaAIO-Frontend/src/components/admin/SuperadminDashboard.tsx` now renders a centered degraded-state recovery panel on command-center load failure, replacing the previous mixed loading/error presentation with explicit retry and fallback navigation actions.
- Modal behavior was normalized with reusable overlay/panel patterns (`.soc-modal-backdrop`, `.soc-modal-panel`) and applied across schedule/user edit dialogs, trip details, calendar event details, bug report dialog, and approval drawers so dialogs consistently appear above dashboard chrome.
- Scroll and safe-area handling were tightened by applying `soc-scroll-area` plus bottom safe-area padding in shared content panes (`OperationalShell`, `ProfileDashboard`) to keep profile/account forms fully visible and scrollable on mobile devices.
- Operational map presentation was refined to avoid UI obstruction: Leaflet pane z-order was constrained in `index.css`, map containers now isolate stacking contexts, and loading overlays are non-interactive (`pointer-events-none`) so map feedback no longer blocks surrounding dashboard interactions.
- `DasiaAIO-Frontend/src/components/dashboard/OperationalMapPanel.tsx` now consumes `OperationalEventContext` so selecting entries in command-center live operations or incident alert feeds opens a dismissible event detail card directly on the map surface; for guard-type events, the map performs best-effort active-telemetry matching to focus and emphasize the related guard marker when available.
- Global mobile quick navigation in `App.tsx` is disabled for guard routing, and guard navigation is now single-sourced inside `UserDashboard.tsx` through a dedicated bottom-nav field shell to avoid redundant controls.
- `DasiaAIO-Frontend/src/components/UserDashboard.tsx` was redesigned to a mission-first guard workspace with a single-column mobile layout, persistent field action dock (`Report Incident`, `Check In/Check Out`, `View Instructions`), assignment-focused top summary cards, a dedicated bottom navigation bar (`Mission`, `Resources`, `Support`, `Map`), and shared top-right header actions for quick inbox, settings, and profile access.
- Guard resilience UX now includes explicit loading/sync states, offline and partial-sync banners with retry, and protected action feedback messages for field-critical workflows.
- Tracking telemetry hooks now enforce frontend role gating (`supervisor`/`guard`) before calling tracking APIs/websocket endpoints (`useOperationalMapData`, `useReplacementSuggestions`, and app-level heartbeat dispatch in `App.tsx`), preventing repeated `403` tracking calls for non-tracking roles.
- `LocationContext.tsx` now exports a heartbeat status type; `UserDashboard.tsx` shows an amber warning indicator when location sharing is paused or heartbeat submission is inactive.
- `SuperadminDashboard.tsx` now passes computed `activeGuards` and `activeTrips` from tracking data to `OperationalMapPanel` instead of hardcoded zeros.
- Sidebar service-health polling (`DasiaAIO-Frontend/src/hooks/useServiceHealth.ts`) now uses `/api/health/system` payloads instead of probing role-restricted operational routes, eliminating expected-but-noisy `403` console spam for lower-privilege sessions.
- Release workflow Android governance (`.github/workflows/release.yml`) now requires signing material for release execution and fails fast when signing secrets are missing.
- Android CI setup now includes Gradle dependency caching (`gradle/actions/setup-gradle@ed408507eac070d1f99cc633dbcf757c94c7933a`), dual SDK package provisioning (`platforms;android-33` + `build-tools;33.0.2` and `platforms;android-35` + `build-tools;35.0.0`), and robust license acceptance handling that avoids `yes | sdkmanager --licenses` pipefail termination.
- Android release job now validates with `:app:assembleDebug` before enforced signed `:app:assembleRelease :app:bundleRelease` outputs, with Gradle `--stacktrace` diagnostics on failure.
- Android CI frontend prebuild now invokes Vite through Node from `DasiaAIO-Frontend` (`node node_modules/vite/bin/vite.js build --mode mobile`) to avoid intermittent Linux runner execute-bit issues (`vite: Permission denied`) before Gradle stages.
- Android CI now uses Temurin JDK 21 in the Android job to satisfy Capacitor Android Java compilation targets (`invalid source release: 21` mitigation).

## v1.2.0 Palantir-Style Platform Transformation

### Shared Event Context (OperationalEventContext)
- New: `src/context/OperationalEventContext.tsx`
- Exports `OperationalEvent { id, type, title }` interface and `OperationalEventContextValue { selectedEventId, selectedEvent, selectEvent, clearSelection }` shape.
- `OperationalEventProvider` wraps `CommandCenterDashboard`; any child panel can call `useOperationalEvent()` to read or set `selectedEventId`.
- Cross-panel selection: clicking an alert in `IncidentAlertFeed` or a feed item in `LiveOperationsFeed` calls `selectEvent()`, which highlights the matching row across all consuming panels via ring CSS.
- `OpsAlert.incidentId?: string` field added to `OpsAlertFeed` so alert records can be linked back to the originating incident for unified selection.
- `incidentAlerts` useMemo in `CommandCenterDashboard` now threads `incidentId` through each resolved alert object.

### AI Action Layer
All AI/prediction panels upgraded from static text output to actionable call-to-action buttons:
- `IncidentSeverityClassifier`: `suggestedActions[]` now rendered as individual clickable buttons rather than joined display text.
- `IncidentSummaryGenerator`: same action-button pattern applied.
- `GuardAbsencePredictionPanel`: HIGH risk rows render "Deploy Replacement" + "Notify Guard" buttons; MEDIUM rows render "Send Confirmation".
- `VehicleMaintenancePredictionPanel`: HIGH risk rows render "Flag for Inspection" + "Remove from Dispatch" buttons; MEDIUM rows render "Book Maintenance".
- `ReplacementSuggestionPanel`: Rank-1 available guard with a valid permit gets "Assign Now" + "Contact Guard" CTAs.

### UI Discipline and Scrolling
- `PredictiveAlertsPanel`: `max-h-80 overflow-y-auto` scroll bounds added.
- `ActiveIncidentsWidget`: `max-h-64 overflow-y-auto` scroll bounds; priority-based row emphasis via `incident-row-critical`, `incident-row-high`, `incident-row-medium` CSS classes with danger/warning border-tint and hover transitions.
- `OperationalMapPanel`: map container height expanded from `h-72` to `h-80 md:h-96`.
- `TodaysShiftOperations`: shift row hover transitions added.
- `IncidentAlertFeed`: max-h-64 scroll bounds; ring highlight on selected alert.
- `LiveOperationsFeed`: ring highlight on selected feed item; keyboard support (`onKeyDown`) added.
- `DasiaAIO-Frontend/src/index.css`: new utility classes `.soc-feed-item`, `.incident-row-critical`, `.incident-row-high`, `.incident-row-medium`, `.ai-action-btn` added.

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
- Superadmin-only audit review is enforced for both legacy and expanded contracts:
  - `GET /api/audit-logs` (legacy compatibility)
  - `GET /api/audit/logs`
  - `GET /api/audit/logs/filter`
  - `GET /api/audit/user-activity/:id`
  - `GET /api/audit/anomalies`
  The handler (`DasiaAIO-Backend/src/handlers/audit.rs`) supports pagination, multi-field filtering, user-activity timelines, and anomaly group extraction for high-fidelity SOC review.
- A new global authorization-failure audit middleware now persists API-wide `401/403` denials (including write requests) into `audit_logs` (`action_key` prefixed with `AUTHZ_DENIED`), while existing write-audit middleware continues to capture write outcomes.
- Managed user creation endpoint (`POST /api/users`) enforces role hierarchy:
  - `superadmin` can create `admin`, `supervisor`, and `guard`
  - `admin` can create `supervisor` and `guard`
- Guard approval management endpoints are active:
  - `GET /api/users/pending-approvals`
  - `PUT /api/users/:id/approval`
- Pending approval routes now require guard-approval permission (`approve_guard_registration`) instead of user-creation permission so supervisors can access approval queues/updates under RBAC.
- Guard permit retrieval route (`GET /api/guard-firearm-permits/:guard_id`) now uses authenticated-route middleware and relies on handler-level `require_self_or_min_role(..., "supervisor")` checks, preventing false `403 Missing required permission: manage_firearms` responses for valid guard self-access.
- Guard login is blocked when `approval_status != approved`.
- CORS accepts both `CORS_ORIGINS` (comma-separated, preferred) and `CORS_ORIGIN` (single-origin compatibility).
- If neither env var is set to a valid value, fallback allow-list behavior in `DasiaAIO-Backend/src/main.rs` is localhost/native-wrapper only (`http://localhost:*`, `127.0.0.1`, `https://localhost`, `capacitor://localhost`, `tauri://localhost`).
- CORS fallback allow-lists now also include runtime origins used by packaged clients (`capacitor://localhost`, `tauri://localhost`, `http://localhost`, `https://localhost`) to prevent mobile/desktop WebView login fetch failures when strict CORS env vars are absent.
- When `CORS_ORIGINS` or `CORS_ORIGIN` is explicitly configured, backend CORS augments those settings with native wrapper origins (`capacitor://localhost`, `tauri://localhost`, `http://localhost`, `https://localhost`) so mobile and desktop wrappers do not regress into `Failed to fetch` due to origin mismatch.
- Local web dev origins `http://localhost:5173` and `http://127.0.0.1:5173` are now only auto-augmented for non-production runtime, tightening production CORS posture while preserving local developer ergonomics.
- Tracking websocket upgrades (`GET /api/tracking/ws`) now explicitly reject users without accepted legal consent and reject roles outside `supervisor`/`guard`.
- Tracking websocket authentication now supports token transport via `Sec-WebSocket-Protocol` (`sentinel-tracking-v1`, `bearer.<jwt>`) to avoid exposing JWTs in URL query strings; temporary query-token fallback remains for transition compatibility.
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
- Release packaging is now centralized in `.github/workflows/release.yml` with tag-driven orchestration, unified version synchronization (`scripts/release-version.js`, `scripts/sync-release-version.js`), and deterministic artifact renaming (`scripts/rename-artifacts.js`).
- Backend config now enforces production startup guards (`DasiaAIO-Backend/src/config.rs`) when `APP_ENV=production` or `NODE_ENV=production`:
  - requires strong non-default `JWT_SECRET`,
  - requires explicitly configured non-default `ADMIN_CODE` (startup fails when missing/empty/default),
  - validates DB pool config via `DB_POOL_MAX_CONNECTIONS` and `DB_POOL_ACQUIRE_TIMEOUT_SECS`,
  - requires explicit `CORS_ORIGINS` or `CORS_ORIGIN`.
- JWT secret fallback in token utilities was removed; token issue/verify flows now fail when `JWT_SECRET` is missing or empty (`DasiaAIO-Backend/src/utils.rs`).
- Legacy high-privilege routes were hardened with centralized middleware, including:
  - permits + firearm maintenance + training record endpoints
  - car allocation + car maintenance + driver assignment endpoints
  - legacy trips endpoints and legacy firearm maintenance listing endpoint
- Support-ticket create request now accepts both `guard_id` and `guardId` payload keys for compatibility.
- MDR import endpoints are active with role-gated access controls in `DasiaAIO-Backend/src/main.rs`:
  - `require_mdr_management` for import, list/review, and row-resolution routes
  - `require_superadmin` for batch commit/reject routes
  - `audit_write_requests` applied on MDR write operations (`import`, `resolve`, `commit`, `reject`)
- Seeder credential hardening:
  - `DasiaAIO-Backend/seed.js` no longer contains a hardcoded database connection string.
  - Seeder now requires `DATABASE_URL` and supports optional TLS behavior via `DATABASE_SSL_MODE`.
- Password-reset migration compatibility fix:
  - `DasiaAIO-Backend/migrations/add_password_reset_tokens.sql` now uses `user_id VARCHAR(36)` (aligned with `users.id`) and `TIMESTAMPTZ` columns to match backend runtime schema expectations.
- Release workflow secret-binding simplification:
  - `.github/workflows/release.yml` now references signing secrets directly (`secrets.SENTINEL_ANDROID_KEYSTORE_BASE64`, `secrets.SENTINEL_UPLOAD_STORE_PASSWORD`, `secrets.SENTINEL_UPLOAD_KEY_ALIAS`, `secrets.SENTINEL_UPLOAD_KEY_PASSWORD`) instead of indexed indirection.
- Release workflow supply-chain hardening:
  - `.github/workflows/release.yml` now pins third-party actions to immutable commit SHAs (`setup-node`, `setup-java`, `upload/download-artifact`, `setup-android`, `action-gh-release`, and `rust-toolchain`).

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
- Password-reset storage and verification now use hashed reset codes (`password_reset_tokens.token` widened to 128 chars) with transaction-safe redemption and post-reset refresh-session revocation.
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
- Validation snapshot (latest hardening pass):
  - Backend checks: `cargo test` passed after auth/tracking/schema/CORS hardening updates.
  - Frontend checks: `npm test -- --runInBand` and `npm run build` passed after websocket + reset UX updates.
  - Workflow hardening: release workflow action pins were updated to immutable SHAs.
- Residual risks / follow-up checks:
  - Validate websocket subprotocol token auth compatibility in staged/production edge-proxy paths.
  - Confirm signed Android artifact release path remains healthy after workflow pinning changes.
  - `DasiaAIO-Backend/src/handlers/users.rs`: user list/detail queries now select `last_seen_at` so frontend can render presence.
- Operational map tracking update:
  - `DasiaAIO-Backend/src/db.rs`: startup schema bootstrap now creates/extends `client_sites`, `tracking_points` (including `user_id` association), `geofence_events`, and `site_geofences` with operational indexes.
  - `DasiaAIO-Backend/src/handlers/tracking.rs`: handlers now cover map snapshots, telemetry/site ingestion, guard movement intelligence, and geofence transition evaluation.
  - `DasiaAIO-Backend/src/handlers/mod.rs`: `tracking` module export added.
  - `DasiaAIO-Backend/src/main.rs`: tracking routes now require `supervisor` or `guard` role at middleware level:
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
  - Expanded tracking API for location lifecycle and live streaming (same `supervisor`/`guard` scope):
    - `GET /api/tracking/client-sites`
    - `PUT /api/tracking/client-sites/:id`
    - `DELETE /api/tracking/client-sites/:id`
    - `POST /api/tracking/heartbeat` (guard session heartbeat -> guard tracking point)
    - `GET /api/tracking/ws?token=<jwt>` (websocket snapshot stream)
  - Guard heartbeat precision policy update (`POST /api/tracking/heartbeat`):
    - samples with `accuracy_meters > 5000` are treated as approximate IP-based fallbacks, persisted with status `approximate`, and acknowledged with `accepted: true` plus `approximate: true`
    - samples with `accuracy_meters` in the GPS-like range still enforce environment-based strict/balanced precision thresholds
    - missing `accuracy_meters` still follows the infinity fallback path and is ignored with `accepted: false`
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
  - `DasiaAIO-Backend/src/handlers/audit.rs`: exposes paginated + filterable reads on `audit_logs` while enforcing `require_min_role('superadmin')`.
  - Expanded review endpoints now provide:
    - timeline/filter access (`/api/audit/logs`, `/api/audit/logs/filter`)
    - per-user operational stories and hourly activity heatmap data (`/api/audit/user-activity/:id`)
    - anomaly summaries for failed bursts, activity spikes, and suspicious source IPs (`/api/audit/anomalies`)
  - `DasiaAIO-Backend/src/models.rs`: adds `AuditLogEntry`, `AuditLogListResponse`, and `AuditLogPageMeta` so contracts stay typed.
  - `DasiaAIO-Backend/src/main.rs`: registers both legacy and expanded audit endpoint family with `require_superadmin` route middleware.

## 10. Frontend Context Snapshot (Keep Updated)

Primary frontend files that must be rechecked when roles/auth/dashboards change:

- `DasiaAIO-Frontend/src/App.tsx`: role-based top-level dashboard routing
- `DasiaAIO-Frontend/src/components/AdminDashboard.tsx`: admin/supervisor dashboard shell + approvals UI
- `DasiaAIO-Frontend/src/components/SuperadminDashboard.tsx`: superadmin shell + approvals UI
- `DasiaAIO-Frontend/src/components/ErrorBoundary.tsx`: shared render-failure containment for dashboard sections
- `DasiaAIO-Frontend/src/components/CalendarDashboard.tsx`: role-aware event aggregation and guarded API calls
- `DasiaAIO-Frontend/src/components/MeritScoreDashboard.tsx`: merit API calls and auth headers
- `DasiaAIO-Frontend/src/components/GuardDashboard.tsx`: now a 3-line re-export shell pointing to `guards/UserDashboard`; original standalone implementation removed as dead code
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
    - websocket close events now detect auth-expired close codes (`1008`, `4001`, `4401`, `4403`) and emit `auth:token-expired` instead of entering reconnect loops with invalid sessions.
  - `DasiaAIO-Frontend/src/App.tsx` now uses backend-driven version discovery (`GET /api/system/version`) with GitHub fallback, then presents platform-aware update prompts:
    - web/mobile -> external download flow
    - Tauri desktop -> in-app one-click updater (`@tauri-apps/plugin-updater`) with relaunch.
  - `DasiaAIO-Frontend/src/App.tsx` now shows a version-scoped "What's New" dialog after release upgrades, populated from `VITE_WHATS_NEW` and persisted so each version is shown once.
  - `DasiaAIO-Frontend/src/App.tsx` now includes connectivity resilience UX: online/offline listeners, recurring backend health probe, and a persistent disconnected banner when backend/network is unavailable.
  - Mobile bottom quick-navigation in `App.tsx` is currently disabled for guard routing so guard navigation remains single-sourced in `UserDashboard.tsx`.
  - Elevated-role mobile bottom tabs are now primary in `DasiaAIO-Frontend/src/components/layout/OperationalShell.tsx` (`Dashboard`, `Approvals`, `Schedule`, `Alerts`, `More`), while `DasiaAIO-Frontend/src/components/layout/AppShell.tsx` only provides fallback mobile tabs for non-OperationalShell routes to avoid duplicate mobile navigation bars.
  - Inbox pending-approval aggregations in `SupervisorInboxPanel.tsx`, `AdminInboxPanel.tsx`, `SuperadminInboxPanel.tsx`, and `roleInboxSummary.ts` now consume `GET /api/users/pending-approvals` with envelope-aware normalization (`{ total, users }`) to eliminate production 404s from deprecated `/api/guard-replacement/pending-approvals` polling paths.
  - Admin-focused quick Inbox aggregations in `AdminInboxPanel.tsx` and `roleInboxSummary.ts` now query `GET /api/firearm-allocations` (with `/api/firearms` fallback) instead of deprecated `/api/firearms/allocations`, removing production 404 noise caused by `/:id` route capture on the firearms module.
  - `DasiaAIO-Frontend/src/utils/swapRequests.ts` now caches unsupported swap-feed capability after a `404/501` probe and short-circuits subsequent polling requests to `unavailable`, preventing repeated console/network spam when live backend versions do not expose `/api/shifts/swap-requests` yet.
  - `OperationalMapPanel.tsx` now resolves light-theme Carto tiles through `rastertiles/voyager` (via `mapTileUrls.ts`) while retaining `dark_all` for dark mode, preventing live tile 404/ORB failures that previously blanked tactical map panels in light mode.
  - `UserDashboard.tsx` now uses a mission-first guard shell with no sidebar, persistent action buttons, a dedicated bottom navigation bar (`Mission`, `Resources`, `Support`, `Map`), and shared top-right header actions for quick inbox, settings, and profile access.
  - Floating runtime notices in `App.tsx` (update/location/error banners) account for safe-area offsets without depending on bottom quick-nav spacing.
  - Core shell touch-target tuning:
    - `Header.tsx`, `Sidebar.tsx`, `NotificationCenter.tsx`, and `OperationalMapPanel.tsx` now use larger interactive target sizing and focus-visible affordances for mobile/tablet usability and keyboard access.
    - `ProfileDashboard.tsx` photo overlay action now uses a semantic button with accessible labeling instead of a mouse-only clickable `div`.
  - Second-pass control-density refinements:
    - `App.tsx` now uses dynamic mobile quick-nav column sizing to avoid sparse/awkward guard navigation spacing on small screens, and `auth:token-expired` handlers now surface the event message before session reset.
    - `App.tsx` restore-auth now validates persisted access-token freshness on startup and attempts refresh-token recovery before restoring a logged-in session; if refresh recovery fails, local auth state is cleared before gated workflows (including legal-consent submission) can execute.
    - `App.tsx` legal-consent acceptance now performs pre-submit session validation/refresh and routes expired sessions back to login instead of allowing stale-token consent POST attempts.
    - `NotificationPanel.tsx` now serves as the shared quick inbox overlay, using explicit button semantics (`type="button"` + labels), Escape/outside-close behavior, larger touch targets, inline panel error messaging, and role-aware summaries with degraded-state guidance.
    - `AdminDashboard.tsx`, `SuperadminDashboard.tsx`, `SectionPanel.tsx`, and consent/update modal actions in `App.tsx` now enforce higher-frequency control sizing (44px-class minimum targets) for mobile and kiosk ergonomics.
    - `index.css` now expands Leaflet zoom control hit areas and focus-visible outlines for keyboard and touch accessibility on operational map surfaces.
    - `Header.tsx` and `AccountManager.tsx` now establish an explicit high-priority stacking context (`z-[1200+]`) so account/profile controls remain clickable above Leaflet map panes and controls.
  - Frontend console-noise suppression for expected auth failures:
    - `DasiaAIO-Frontend/src/utils/logger.ts`: new shared logger utility with `isExpectedAuthNoise(...)` and `logError(...)` to suppress expected invalid-token/session-expiry fetch noise while preserving unexpected-error logging.
    - `DasiaAIO-Frontend/src/components/SuperadminDashboard.tsx`, `DasiaAIO-Frontend/src/components/ArmoredCarDashboard.tsx`, and `DasiaAIO-Frontend/src/components/CalendarDashboard.tsx` now route noisy fetch logs through `logError(...)`.
    - Rollout expanded to additional operational surfaces: `FirearmInventory.tsx`, `FirearmAllocation.tsx`, `EditScheduleModal.tsx`, `FirearmMaintenance.tsx`, `GuardFirearmPermits.tsx`, `MeritScoreDashboard.tsx`, `PerformanceDashboard.tsx`, `NotificationPanel.tsx`, `ProfileDashboard.tsx`, and `UserDashboard.tsx`.
  - Dashboard render containment:
    - `DasiaAIO-Frontend/src/components/ErrorBoundary.tsx` now provides a reusable section-level fallback surface with retry action.
    - `DasiaAIO-Frontend/src/App.tsx` now wraps profile, routed elevated views, and home rendering through this boundary (`renderProtectedView(...)`) so runtime render faults degrade to bounded recovery UI instead of collapsing the entire app shell.
- Guard/profile/support flows were hardened to include bearer headers on protected endpoints (attendance, allocations, tickets, profile update/photo actions)
- UI permission gates in shared elevated shell:
  - `superadmin`: full management actions
  - `admin`: elevated management actions, but no superadmin-targeted destructive controls
  - `supervisor`: operational visibility with restricted user-management actions (for example, no delete-user control)
- Full-width layout guardrails:
  - Global CSS enforces `html/body/#root` full-width/full-height and `body { margin: 0 }`
  - Avoid removing root width/height guarantees when adjusting dashboard overflow behavior, otherwise right-side viewport gaps can reappear
  - Keep dashboard shells on fixed-height (`h-[100dvh]`) + `overflow-hidden` roots with `min-h-0` main columns so only designated content panes own vertical scroll.
- Header consistency guardrail:
  - Shared `Header` now routes default top-right actions through `HeaderGlobalActions`, keeping quick inbox, settings, profile, theme, and refresh behavior aligned across elevated dashboards and the guard workspace.
  - Existing `inbox`, `settings`, and `profile` view keys remain supported as fallback routes or panels even though they are no longer primary sidebar destinations.
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
  - `DasiaAIO-Frontend/src/components/admin/ResourceManagementPanel.tsx` now includes a guarded Add User modal in the Guards tab with required-field validation (name/email/password + min-length password), role-scoped dropdown options resolved from auth context (`superadmin -> admin/supervisor/guard`, `admin -> supervisor/guard`, `supervisor -> guard`), authenticated `POST /api/users` submission, and superadmin-only row-level Edit access for guard records via `EditUserModal`.
  - `DasiaAIO-Frontend/src/components/shared/SentinelModal.tsx` now provides a shared dialog primitive (`soc-modal-backdrop` + `soc-modal-panel`) with Escape/backdrop close handling, body scroll lock, accessible dialog semantics (`role="dialog"`, `aria-modal`, `aria-labelledby`), and the visual contract now used across Add User, Edit User, firearm, vehicle, client-site, and schedule dialogs for consistent spacing, border, and scroll behavior.
  - `DasiaAIO-Frontend/src/components/admin/ResourceManagementPanel.tsx` now renders Firearms, Vehicles, and Client Sites creation via modal dialogs instead of inline toggle forms, and adds row-level destructive controls for Firearms (`DELETE /api/firearms/:id`) and Vehicles (`DELETE /api/armored-cars/:id`) while preserving existing Client Site removal behavior.
  - `DasiaAIO-Frontend/src/components/admin/SuperadminDashboard.tsx` now passes a refresh callback (`fetchData`) into `ResourceManagementPanel` so successful account creation and edit attempts can immediately reconcile against the latest personnel list shown in the management table.
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
    - `DasiaAIO-Frontend/src/hooks/useOperationalMapData.ts`: websocket map stream is now enabled by default via `VITE_ENABLE_TRACKING_WS=true` set in all environment files (`.env.production`, `.env.development`, `.env.web`, `.env.mobile`, `.env.desktop`, `.env.example`). If backend rejects websocket upgrade/token, browser will still show connection warnings while periodic polling continues. The duplicate secondary heartbeat interval previously running inside `useOperationalMapData` has been removed to prevent double heartbeat submissions.
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
    - `DasiaAIO-Frontend/src/components/dashboard/CommandCenterDashboard.tsx` now runs its 15-second refresh cycle in staged sequence instead of one burst, reducing concurrent request spikes while preserving freshness indicators.
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
    - `DasiaAIO-Frontend/src/utils/api.ts`: fetch wrapper now uses status-aware retry/backoff (including `408/425/429/5xx`) with exponential delay for safe/idempotent calls and offline-aware messaging.
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
          - `apps/desktop-tauri/src-tauri/tauri.conf.json`: explicit production and development CSP policies are enforced. CSP `style-src` now includes `https://fonts.googleapis.com` and `font-src` includes `https://fonts.gstatic.com` in both production and development policies for proper Google Fonts loading.
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
  - `.github/workflows/release.yml`
- Trigger conditions:
  - tag push matching `v*`
  - manual dispatch (`release_version`, `api_base_url`)

Current release behavior:

- Quality gate:
  - A dedicated `quality-gate` job now runs frontend tests and backend tests before web/desktop/android artifact jobs execute.
- Workflow permissions:
  - Global workflow permission is now least-privilege `contents: read`, with `contents: write` scoped only to the publish job.

- Web artifact:
  - CI builds a production web bundle and publishes a versioned archive (`sentinel-web-v<version>.tar.gz`).
- Desktop artifacts:
  - Windows MSI + NSIS installers are built and published with deterministic names (`sentinel-desktop-windows-v<version>.<ext>`).
- Android artifact:
  - CI requires Android signing material and publishes signed APK and AAB artifacts with deterministic names (`sentinel-android-v<version>.apk/.aab`).
  - Release execution fails when signing secrets are missing, removing unsigned fallback behavior from release runs.
- Release guard behavior:
  - release jobs set production runtime flags (`NODE_ENV=production`, plus `CAPACITOR_ENV=production` for Android), run frontend env-policy validation, and propagate a unified semantic version across wrapper manifests/configs before building.
- Release metadata generation:
  - `scripts/generate-release-notes.js` extracts the target version section from `CHANGELOG.md`.
  - generated notes are used as GitHub release body, and a condensed `VITE_WHATS_NEW` payload is injected into built clients.
- GitHub Release publishing:
  - For `v*` tags, web/desktop/android artifacts and generated release notes are attached to the Release entry.

Checkout/build stability updates applied:

- Release workflow now uses pinned `actions/checkout` with `submodules: recursive` in all release jobs, so web/desktop/android artifacts build from the exact repository-pinned frontend snapshot instead of an external moving-target checkout.
- Release workflow now pins immutable SHAs for `setup-node`, `setup-java`, `setup-android`, `setup-gradle`, and `upload/download-artifact` alongside checkout for deterministic CI execution.
- Repository submodule metadata is now explicitly declared in `.gitmodules` for `DasiaAIO-Backend` and `DasiaAIO-Frontend`, preventing checkout-time `No url found for submodule path` failures.
- Web artifact validation now relies on `ensure-production-env.mjs` (required HTTPS/public `VITE_API_BASE_URL`) instead of broad static-string grep checks to avoid false-positive release failures from non-runtime localhost text in bundled assets.
- Build runtime uses Node.js 22 across release jobs (prepare/quality-gate/web/desktop/android).

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

## 14. Release Validation Update (April 2026)

- Live `workflow_dispatch` run `23929317544` completed `Prepare Release Metadata`, `Quality Gate`, `Build Web Artifact`, `Build Desktop Artifacts`, and `Build Android Artifacts` successfully.
- The Android job successfully materialized signing material, executed the debug preflight, and uploaded signed APK and AAB artifacts.
- `Publish GitHub Release` was skipped in that run because publish remains gated to tag-triggered executions (`refs/tags/v*`).
- Remaining warnings were upstream action-runtime deprecation notices and did not block artifact output.

Residual release risks:

- The next tag-driven release should still be observed end-to-end to confirm GitHub Release asset publication with the same secret contract.
- External store submission and desktop code-signing operations remain downstream responsibilities outside this repository.

## 15. Hardening and UI Improvement Waves (April 2026)

### Wave 1 — Release Governance and Android Signing Readiness

- `scripts/setup-android-signing.ps1` provides the operational path for generating the Android keystore, encoding it, and producing the exact GitHub Actions secret values required by the governed release pipeline.
- Root `.gitignore` and `apps/android-capacitor/android/.gitignore` prevent accidental commit of keystore material and generated secret files.
- The governed Android CI signing contract in `.github/workflows/release.yml` is:
  - `SENTINEL_ANDROID_KEYSTORE_BASE64`
  - `SENTINEL_UPLOAD_STORE_PASSWORD`
  - `SENTINEL_UPLOAD_KEY_ALIAS`
  - `SENTINEL_UPLOAD_KEY_PASSWORD`
- Release execution fails when any signing secret is missing; unsigned Android fallback is not part of the governed release path.

### Wave 2 — Dead Code Removal / Dashboard Consolidation

- `DasiaAIO-Frontend/src/components/GuardDashboard.tsx` replaced with a 3-line re-export delegating to `guards/UserDashboard`. The previous standalone guard shell was superseded by the unified `UserDashboard` and had become dead code.
- No behavioral change; all guard routing in `App.tsx` continues to resolve through the same import path.

### Wave 3 — Auth Header Consistency (Security Hardening)

- Eliminated all direct `localStorage.getItem('token')` calls across 23 frontend files (9 hooks + 14 components).
- Every API fetch call in affected files now uses `getAuthHeaders()` from `src/utils/api.ts`, centralizing token retrieval and auth-header construction.
- Affected hooks: all API-calling hooks in `src/hooks/`.
- Affected components: `BugReportButton`, `CalendarDashboard`, `ArmoredCarDashboard`, `EditScheduleModal`, `TripManagement`, `FirearmInventory`, `FirearmAllocation`, `FirearmMaintenance`, `GuardFirearmPermits`, `MeritScoreDashboard`, `IncidentPanel`, `IncidentReportForm`, `IncidentSummaryGenerator`, `IncidentSeverityClassifier`.
- Eliminates auth-header drift between modules; future token-management changes require edits in one place only (`api.ts`).

### Wave 4 — UI/UX Improvements

#### guards/UserDashboard.tsx

- Inbox section now renders inside `guard-section-frame` container (was bare `p-4`).
- Mission section now opens with an `Immediate Action` card that summarizes the next guard decision (`Check in`, `Stay on post`, or standby) plus a readiness cue derived from existing shift, connectivity, and location-consent/tracking state so first-viewport content stays action-oriented without new backend data.
- KPI row: added `sm:grid-cols-2` responsive breakpoint for intermediate screen sizes.
- Location tracking toggle: minimum touch target raised from `min-h-9` to `min-h-11` (WCAG 2.5.5 compliance); `aria-pressed` state attribute added; corrupted Unicode bullet characters (● ○) replaced with correct glyphs.
- Accuracy pill: corrupted `·` separator character replaced with correct middle-dot.
- Support ticket textarea: Tailwind height changed from `min-h-[110px]` to `min-h-28` (token-aligned).
- Primary CTA button: corrupted `✓` and `—` characters replaced with correct Unicode.
- Active nav button: added `outline outline-transparent` + `forced-colors:text-[ButtonText]` for Windows High Contrast mode support.
- Incident description textarea: height changed from `min-h-[120px]` to `min-h-32`.
- `dashboard/GuardShiftSwapPanel.tsx` now treats `GET /api/shifts/swap-requests` 404/501/network-unavailable/stale payloads as degraded non-fatal states: request history shows as unavailable, the manual request form remains usable, and helper copy now explains manual target-guard ID entry plus the no-shift fallback path.

#### dashboard/CommandCenterDashboard.tsx

- Threat Level `StatusBadge`: tone changed from `analytics` to `success` for the Low threat state (semantic correctness).
- `OperationalSummaryStrip`: removed duplicate System Status and Threat Level entries that were already rendered in the dashboard header.
- System Status `SectionPanel`: removed `collapsible` prop so critical system-status information is always visible.
- AI tools grid: added `sm:grid-cols-2` responsive breakpoint (column count was jumping directly from 1 to 4).
- `PredictiveAlertsPanel`: wrapped in `sm:col-span-2` container to give the primary AI module visual prominence.
- Error banner: replaced raw `amber-*` Tailwind color classes with `warning-*` design tokens; added `role="alert"` + `aria-live="assertive"` for screen-reader announcement.

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
  - Tracking scope verification (latest):
    - Runtime probe executed against active local backend on `http://localhost:5000`.
    - `POST /api/tracking/heartbeat` and `GET /api/tracking/map-data` are now restricted to `supervisor` and `guard` roles; admin/superadmin requests are expected to return `403` and generate authz-failure audit entries.
    - Guard requests continue to persist heartbeat telemetry and receive `Location heartbeat recorded` success responses when precision policy is satisfied.
    - Frontend accuracy tuning added:
      - App-level all-user location capture now performs an immediate `getCurrentPosition` call on login and uses fresher geolocation cache (`maximumAge: 2000`) before watch updates.
      - Heartbeat payload status now flags low-precision fixes as `low_accuracy` when `accuracyMeters > 60`.
      - Guard dashboard renders an explicit low-accuracy warning message and operational map popups show `Low GPS precision` for weak fixes.
    - Smoke test after tuning:
      - Frontend `npm run build` passed.
      - Backend services rebuilt and running (`docker compose ps`: backend up, postgres healthy).
      - `GET /api/health` => `200`.
      - `POST /api/tracking/heartbeat` (supervisor/guard token) => `201` with message `Location heartbeat recorded`.
      - `GET /api/tracking/map-data` returns role-scoped tracking payload for supervisor/guard sessions.
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
  - Accuracy mode defaults (latest):
    - Default accuracy mode changed from `strict` to `balanced` in both frontend (`trackingPolicy.ts`) and backend (`tracking.rs`).
    - `VITE_TRACKING_ACCURACY_MODE=balanced` is now set in `.env.production`, `.env.mobile`, and `.env.example`.
    - Balanced mode thresholds: `accuracy_meters <= 35`, person recency within 8 minutes.
    - Strict mode thresholds (available via override): `accuracy_meters <= 20`, person recency within 3 minutes.
    - User/guard map points are filtered by the active mode:
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
    - If override vars are absent, `balanced` mode defaults are applied (accuracy ≤35m, person recency 8min, vehicle recency 10min).
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
      - `GET    /api/incidents`           — role-scoped listing; guards only see incidents they reported, elevated roles see full feed
      - `GET    /api/incidents/active`    — role-scoped active feed (same guard/elevated visibility model)
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
  - Command-center AI action behavior hardening (latest):
    - Frontend — `DasiaAIO-Frontend/src/components/dashboard/IncidentSeverityClassifier.tsx`:
      - Replaced placeholder `alert()` handlers in recommended-action chips with `useOperationalEvent().selectEvent(...)` targeting the current incident id.
      - Clicking a recommended action now drives the existing map/detail operational flow instead of opening a dead-end browser dialog.
    - Frontend — `DasiaAIO-Frontend/src/components/dashboard/IncidentSummaryGenerator.tsx`:
      - Replaced placeholder `alert()` handlers with clipboard actions (`navigator.clipboard.writeText`).
      - `Include`/`report`-style actions now copy a formatted incident brief (incident title, risk level, confidence, summary, explanation/key phrases when available).
      - Other suggested actions copy the generated summary text and provide in-component confirmation (`Copied ✓`) plus polite status feedback.
    - Validation:
      - Frontend build passes after behavior update (`npm run build`).
      - Workspace diagnostics report no errors in modified files.
  - RBAC and layout hardening pass (latest):
    - Backend authorization updates:
      - `/api/audit-logs`, `/api/audit/logs`, `/api/audit/logs/filter`, `/api/audit/user-activity/:id`, `/api/audit/anomalies` now require superadmin route and handler gates.
      - Tracking routes now require supervisor/guard role middleware; websocket upgrades reject non-supervisor/non-guard roles.
      - Incident reads are role-scoped: guard sees self-reported incidents only; elevated roles retain full incident feed.
      - Global authz-failure audit middleware records API-wide denials (`401/403`, including write-route denials) into `audit_logs`.
    - Frontend authorization/layout updates:
      - `audit-log` navigation permission moved to `view_audit_logs` (superadmin only).
      - Restricted views now render explicit Access Denied fallback instead of silently falling through to dashboard.
      - Sidebar is fixed with a desktop spacer; dashboard shells now use `h-[100dvh]` + `overflow-hidden` + `min-h-0` main columns, with only content panes scrolling.
      - Global CSS locks document scroll and moves gradient atmosphere to fixed background layer.
    - Validation completed in this session:
      - Backend: `cargo test` passed (including `tracking_audit_integration` suite).
      - Frontend: `npm run build` passed.
      - Diagnostics: no errors on modified backend/frontend files in workspace checks.
    - Residual risks to monitor:
      - Existing integration tests do not yet include explicit 403 assertions for admin/superadmin access to tracking routes after scope tightening.
      - Stale client state pointing to now-restricted views may surface additional Access Denied transitions that should be validated in staged end-to-end smoke tests.

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

## 17. April 2026 Implementation Completion

Latest implemented and verified additions in this cycle:

- Push notifications:
  - Frontend service worker registration + permission + subscription helpers at `DasiaAIO-Frontend/src/utils/pushNotifications.ts`.
  - Profile opt-in toggle UI in `DasiaAIO-Frontend/src/components/ProfileDashboard.tsx`.
  - Backend subscription endpoint `POST /api/notifications/push-subscribe` in `DasiaAIO-Backend/src/handlers/notifications.rs` with route wiring in `DasiaAIO-Backend/src/main.rs`.
  - DB persistence table/index for push subscriptions in `DasiaAIO-Backend/src/db.rs` (`push_subscriptions`, `idx_push_subscriptions_user_id`).

- Offline support:
  - Service-worker cache and background replay queue in `DasiaAIO-Frontend/public/sw.js`.
  - IndexedDB queue utility in `DasiaAIO-Frontend/src/utils/offlineQueue.ts`.

- E2E smoke testing:
  - Playwright config/scripts/tests added:
    - `DasiaAIO-Frontend/playwright.config.ts`
    - `DasiaAIO-Frontend/tsconfig.playwright.json`
    - `DasiaAIO-Frontend/tests/smoke.spec.ts`
    - `DasiaAIO-Frontend/package.json` scripts: `test:e2e`, `test:e2e:ui`

- Validation status for this cycle:
  - Backend `cargo check`: passes (warnings only).
  - Frontend smoke tests: running and passing core coverage, with role-dependent routes marked as skip-safe in scenarios where a role cannot access a target view.

## 18. Unified Role-Centric Action Inbox + Workflow Timeline Implementation

### UI/UX Architecture Overview

A new unified inbox system provides role-scoped action prioritization and workflow status timelines within a cohesive operational dashboard. The system uses two reusable shared UI primitives (`ActionInbox`, `WorkflowTimeline`) composed into four role-specific dashboard panels, integrated into both Guardian (`UserDashboard`) and Elevated (`SuperadminDashboard`) shells.

### Shared UI Primitives

**ActionInbox.tsx** (`src/components/inbox/ActionInbox.tsx`, 155 lines)
- **Purpose**: Render prioritized inbox items sorted by urgency with visual feedback
- **Type Definitions**:
  - `InboxPriority`: `'urgent' | 'high' | 'normal'`
  - `InboxCategory`: `'mission' | 'incident' | 'shift' | 'approval' | 'firearm' | 'compliance' | 'notification'`
  - `InboxItem`: interface with `id`, `priority`, `category`, `title`, `description`, `timestamp`, `actionLabel`, `statusChip`, `onAction` callback
- **Features**:
  - Priority color bar on left edge (red/orange/muted per urgency)
  - Category-specific Lucide icon (Clock, AlertTriangle, ArrowLeftRight, UserCheck, Shield, FileText, Bell)
  - Priority-based sorting (urgent → high → normal)
  - Skeleton loading state during fetch
  - Empty state with centered messaging
  - Keyboard navigation (`onKeyDown` Enter/Space on items)
  - ARIA labels and semantic `<section>` wrapper
- **Design Compliance**: Uses SOC token classes (`.soc-dashboard-card`, responsive grid) and CSS variables; no arbitrary Tailwind colors

**WorkflowTimeline.tsx** (`src/components/inbox/WorkflowTimeline.tsx`, 153 lines)
- **Purpose**: Render vertical workflow/status progression timeline with milestone markers
- **Type Definitions**:
  - `TimelineStatus`: `'pending' | 'active' | 'resolved' | 'cancelled'`
  - `TimelineEntry`: interface with `id`, `status`, `title`, `participant`, `timestamp`, `detail`, `category`
- **Features**:
  - Vertical layout with status-colored icon circles (Clock pending, Zap active, CheckCircle resolved, XCircle cancelled)
  - Connecting vertical border on left side
  - Title + participant + relative timestamp display
  - Optional expandable detail section
  - "Show more" pagination (first 8 entries, then expand button)
  - Empty state and loading skeleton
  - Keyboard focus support on expandable items
  - Accessible heading with `aria-label`
- **Design Compliance**: Responsive width, SOC token styling, no arbitrary colors

### Role-Specific Inbox Panels

**GuardInboxPanel.tsx** (`src/components/inbox/GuardInboxPanel.tsx`, 193 lines)
- **Purpose**: Guard field operations inbox focused on mission execution
- **Data Fetched** (Promise.allSettled for resilience):
  - `GET /api/guard-replacement/guard/{userId}/shifts` → upcoming assignments
  - `GET /api/users/{userId}/notifications` → system notifications
  - `GET /api/shifts/swap-requests` via `src/utils/swapRequests.ts` → pending peer shift swaps when the endpoint is available
- **InboxItem Mapping**:
  - Shifts within 24h → `(urgent, mission, "Upcoming Shift: location/time")`
  - Swap requests → `(high, shift, "Swap Request: from peer name")`
  - Notifications (unread) → priority varies by type (high for shift-type, normal for others)
- **TimelineEntry Mapping**: Shifts mapped with status (pending → pending, active → active, etc.), category "Mission Shift"
- **Features**: Offline banner (navigator.onLine check), non-blocking degraded-state notice when swap-request history is unavailable or stale, error state on all-fail, responsive grid layout
- **Authorization**: Guard can only access own shifts/notifications; self-service check

**SupervisorInboxPanel.tsx** (`src/components/inbox/SupervisorInboxPanel.tsx`, 215 lines)
- **Purpose**: Supervisor field-control inbox for shift oversight and incident response
- **Data Fetched** (Promise.allSettled):
  - `GET /api/guard-replacement/pending-approvals` → pending shift replacements
  - `GET /api/incidents` → unresolved incidents
  - `GET /api/guard-replacement/shifts` → unassigned shifts
  - `GET /api/users/{userId}/notifications` → system notifications
- **InboxItem Mapping**:
  - Pending approvals → `(urgent, approval, "Guard name: replacement request")`
  - Unresolved incidents → `(high, incident, incident title)`
  - Unassigned shifts → `(high, shift, "Unassigned: location/time")`
  - Notifications → `(normal, notification, ...)`
- **Key Feature**: All fetches use shared `getAuthHeaders()` utility for consistent authorization
- **Authorization**: Supervisor sees global unassigned/incident views; approvals already filtered server-side

**AdminInboxPanel.tsx** (`src/components/inbox/AdminInboxPanel.tsx`, 228 lines)
- **Purpose**: Admin operations orchestration inbox with real-time metrics
- **Data Fetched** (Promise.allSettled):
  - `GET /api/guard-replacement/pending-approvals` → pending approvals
  - `GET /api/firearms/allocations` → firearm inventory
  - `GET /api/users/{userId}/notifications` → notes
  - `GET /api/analytics/metrics` → operational stats
- **Metrics Banner**: 3 stat chips above grid (active guards count, pending approvals count, incidents count)
- **InboxItem Mapping**: Approvals → urgent, firearms needing attention → high, notifications → normal
- **Layout**: Responsive 2-column grid on desktop (ActionInbox + WorkflowTimeline side-by-side), 1-column on mobile
- **Authorization**: Admin scoped to visible organizational units; metrics represent organization-wide view

**SuperadminInboxPanel.tsx** (`src/components/inbox/SuperadminInboxPanel.tsx`, 220 lines)
- **Purpose**: Superadmin governance/compliance inbox with system-wide visibility
- **Data Fetched** (Promise.allSettled):
  - `GET /api/users/{userId}/notifications` → global notifications
  - `GET /api/guard-replacement/pending-approvals` → all pending approvals
  - `GET /api/incidents` → all incidents
  - `GET /api/analytics/metrics` → system metrics
- **Security Fix Applied**: Added useEffect cleanup guard (`let cancelled = false` flag, cleanup return) to prevent stale setState on unmount during async fetch
- **Governance Banner**: 3 stat chips (incidents this month, pending approvals, unread notifications)
- **InboxItem Mapping**: Unresolved critical incidents → urgent/compliance, >48h approvals → urgent, <48h → high, notifications → normal
- **TimelineEntry Mapping**: Incidents sorted newest-first, closed incidents → resolved status, others → active
- **Authorization**: Superadmin sees system-wide data; organization filtering handled as a follow-up governance control

### Dashboard Integration

**UserDashboard.tsx** (modified `src/components/UserDashboard.tsx`)
- **Type Change**: `GuardSection` union extended to include `'inbox'` as first item
- **Import**: Added `import { GuardInboxPanel } from './inbox/GuardInboxPanel'`
- **Tab Navigation**: Added `{ key: 'inbox', label: 'Inbox' }` at index 0 (first tab position)
- **Render Block**:
  ```tsx
  if (activeSection === 'inbox') {
    return <div className="p-4"><GuardInboxPanel userId={user.id} onAction={(type, id) => { if (type === 'mission') setActiveSection('mission'); }} /></div>
  }
  ```
- **Impact**: Guards now see "Inbox" as first tab in mission-first workspace, with optional action callback for inline navigation

**SuperadminDashboard.tsx** (modified `src/components/SuperadminDashboard.tsx`)
- **Type Change**: `activeSection` union extended to include `'inbox'` at front
- **Imports**: Added 3 role panel components (SupervisorInboxPanel, AdminInboxPanel, SuperadminInboxPanel)
- **Navigation**: `handleNavigate` now routes `'inbox'` view to `setActiveSection('inbox')`
- **Render Block** (critical role dispatch order):
  ```tsx
  {activeSection === 'inbox' && (
    <div className="p-6">
      {isSuperadminViewer ? (
        <SuperadminInboxPanel userId={user.id} />
      ) : isAdminViewer ? (
        <AdminInboxPanel userId={user.id} />
      ) : (
        <SupervisorInboxPanel userId={user.id} />
      )}
    </div>
  )}
  ```
  **Critical Detail**: Superadmin check first (prevents admin catch-all bug; ensures correct panel renders per role)
- **Impact**: Elevated roles see "Inbox" in sidebar navigation; dashboard routing determines which panel renders based on JWT role

### Navigation Configuration

**navigation.ts** (modified `src/config/navigation.ts`)
- **Changes**: Added `'inbox'` as first NavItem in both ELEVATED_NAV and GUARD_NAV arrays
- **Structure**: `{ view: 'inbox', label: 'Inbox', group: 'MAIN MENU' }`
- **Result**: Sidebar and guard bottom-nav now show "Inbox" as the first/primary navigation item

### Playwright E2E Tests

**inbox.spec.ts** (new `tests/inbox.spec.ts`, ~110 lines)
- **Purpose**: Verify inbox navigation is visible and accessible for all 4 roles
- **Tests (4 passing)**:
  1. **Guard sees Inbox tab**: Verifies "Inbox" appears in bottom navigation tabs for guard sessions
  2. **Admin sees Inbox in sidebar**: Confirms "Inbox" nav item in sidebar for admin sessions
  3. **Supervisor sees Inbox in sidebar**: Confirms "Inbox" nav item in sidebar for supervisor sessions
  4. **Superadmin sees Inbox in sidebar**: Confirms "Inbox" nav item in sidebar for superadmin sessions
- **Test Pattern**:
  - Auth injection via `page.addInitScript()` (localStorage token injection)
  - API route mocking via `page.route()` to prevent backend dependency
  - DOM assertion via `page.getByRole('navigation')` selectors
  - Graceful skip on not-found (role-safe, doesn't fail entire suite)
- **Execution**: All 4 tests passed (6.9s total run)
- **Integration**: Runs alongside existing smoke tests; full suite remains 7 passed + 3 skipped (10 total, role-dependent)

### Code Review & Security Audit Results

**gem-reviewer performed full security/quality audit** with 4 issues identified and auto-fixed:

| Issue | Severity | Files | Fix Applied |
|-------|----------|-------|-------------|
| Missing useEffect cleanup guard | HIGH | SuperadminInboxPanel | Added `let cancelled` flag, cleanup return, void cast |
| Duplicated auth token retrieval | MEDIUM | 3 panels (Supervisor, Admin, Superadmin) | Replaced manual `localStorage.getItem('token')` with shared `getAuthHeaders()` utility |
| Missing URL path encoding | MEDIUM | 2 panels (Guard, Superadmin) | Added `encodeURIComponent(userId)` to all `/api/*` URLs |
| Unnecessary tabindex on static content | MEDIUM | WorkflowTimeline | Removed `tabIndex={0}`, redundant `role="listitem"`, moved `aria-label` to parent |

**Result**: PASS — All 4 issues resolved; TypeScript strict mode zero errors project-wide after fixes

### Validation & Testing Results

**Wave 1 (Primitives, 3 tasks)**
- ✅ ActionInbox.tsx: 155 lines, zero errors
- ✅ WorkflowTimeline.tsx: 153 lines, zero errors
- ✅ Navigation config: 2 lines added, zero errors

**Wave 2 (Role Panels, 4 tasks)**
- ✅ GuardInboxPanel.tsx: 193 lines, zero errors
- ✅ SupervisorInboxPanel.tsx: 215 lines, zero errors
- ✅ AdminInboxPanel.tsx: 228 lines, zero errors
- ✅ SuperadminInboxPanel.tsx: 220 lines, zero errors (+ 1 security fix applied)

**Wave 3 (Dashboard Integration, 2 tasks)**
- ✅ UserDashboard.tsx: Integration successful, zero errors
- ✅ SuperadminDashboard.tsx: Integration successful, zero errors (+ 1 pre-existing dead code cleanup)

**Wave 4 (Security Review & E2E Tests, 2 tasks)**
- ✅ Security audit: 4 issues found + auto-fixed, PASS status
- ✅ E2E tests: 4 new tests (inbox.spec.ts), all 4 PASSED (6.9s)

**Final TypeScript Validation**
- `npx tsc --noEmit` → **ZERO errors** (full project-wide validation)

**Full E2E Suite**
- `npx playwright test --reporter=line` → **7 passed (8.1s), 3 skipped** (10 total tests)
  - 4 new inbox tests: all passed
  - 3 existing smoke tests: passed
  - 3 existing role-dependent tests: skipped gracefully

### Feature Completion Status

**Completed & Integrated**:
- ✅ 2 reusable UI primitives (ActionInbox, WorkflowTimeline)
- ✅ 4 role-specific panels (Guard, Supervisor, Admin, Superadmin)
- ✅ Dashboard shell integration (UserDashboard, SuperadminDashboard)
- ✅ Navigation configuration (sidebar + guard bottom-nav)
- ✅ Security audit (4 issues found & fixed)
- ✅ E2E test coverage (4 new tests, all passing)
- ✅ TypeScript strict compliance (zero errors)
- ✅ Full regression validation (existing tests passing)

**Design Compliance**:
- ✅ CSS design tokens (Tailwind + index.css variables)
- ✅ No arbitrary colors (SOC token classes only)
- ✅ Accessibility (ARIA labels, keyboard nav, WCAG 2.2)
- ✅ Responsive layout (mobile + desktop)
- ✅ Error resilience (Promise.allSettled, graceful degradation)

## 19. Frontend Multi-Issue Wave 1-3 Completion

Latest frontend dashboard and route behavior changes completed in this session:

- Guard profile continuity:
  - `DasiaAIO-Frontend/src/components/profile/ProfileModalContent.tsx` now owns the reusable account-settings surface used by both inline and routed profile experiences.
  - `DasiaAIO-Frontend/src/components/UserDashboard.tsx` now opens profile management inside an inline modal (`role="dialog"`, accessible name `Guard profile settings`) instead of sending guards out of the mission shell.
  - `DasiaAIO-Frontend/src/components/ProfileDashboard.tsx` now acts as the full-page wrapper around the same shared profile content, preserving non-guard and direct-profile flows without duplicating save/photo/push/availability logic.

- Theme and settings routing:
  - `DasiaAIO-Frontend/src/components/UserDashboard.tsx` now exposes the existing `ThemeToggleButton`, closing the last top-level dashboard gap in theme-toggle coverage.
  - `DasiaAIO-Frontend/src/components/settings/` now contains the settings MVP surface (`SettingsView`, `GuardSettings`, `SupervisorSettings`, `AdminSettings`, `SuperadminSettings`, shared notifications panel, storage helpers, and role resolver hook).
  - `DasiaAIO-Frontend/src/App.tsx` now registers a protected `settings` view in the main view registry.
  - `DasiaAIO-Frontend/src/config/navigation.ts` now exposes `settings` in both elevated and guard navigation definitions.
  - Settings remain frontend-only in this MVP and persist through role-scoped localStorage keys such as `settings.guard.notifications` and `settings.supervisor.supervisor`.

- Support and shift-swap hardening:
  - `DasiaAIO-Frontend/src/components/dashboard/GuardShiftSwapPanel.tsx` now routes list, submit, and respond flows through `fetchJsonOrThrow(...)` and `getAuthHeaders(...)`, removing the previous swallowed PATCH failure path.
  - `DasiaAIO-Frontend/src/components/inbox/GuardInboxPanel.tsx` now uses the shared authenticated API helper path and surfaces complete inbox-load failures with explicit UI feedback.

- Validation performed in this session:
  - `npm test -- --runInBand src/__tests__/guardDashboardRedesign.test.tsx src/__tests__/settings.test.tsx` passed: 15/15 tests.
  - `npm run build` in `DasiaAIO-Frontend` passed.
  - `npx playwright test tests/guard-dashboard.spec.ts --project=chromium` passed: 5/5 tests.

- Residual risk:
  - Editor diagnostics still show a pre-existing `process` name-resolution warning in `DasiaAIO-Frontend/tests/smoke.spec.ts`, although Playwright execution remains functional through `tsconfig.playwright.json`.

### Known Limitations & Future Enhancements

- **Unread counts**: Badge indicators on nav items (intentionally skipped for v1; easy add-on)
- **Detail modal**: Full inbox item detail view opens in modal (phase 2 feature)
- **Filters/search**: Current panels show all items; filter UI deferred to v1.1
- **Real-time push**: WebSocket-driven inbox updates (deferred; polling refresh suffices for v1)
- **Action completion**: Some action callbacks (e.g., "Assign Now" for replacement) trigger navigation instead of inline completion (phase 2 enhancement)

## 20. Wave 4 Domain Reorganization and Continuation Outcomes (2026-04-03)

### Frontend Component Domain Organization (Wave 4)

Three top-level components were moved to domain subdirectories under `DasiaAIO-Frontend/src/components/` with backward-compatible shims retained at original paths:

| Original path | New domain path | Domain |
|---|---|---|
| `src/components/Header.tsx` | `src/components/shared/Header.tsx` | `shared/` |
| `src/components/UserDashboard.tsx` | `src/components/guards/UserDashboard.tsx` | `guards/` |
| `src/components/SuperadminDashboard.tsx` | `src/components/admin/SuperadminDashboard.tsx` | `admin/` |

Compatibility shims at the original paths re-export the default export from the new domain paths. All secondary consumers (e.g., `CalendarDashboard`, `FirearmInventory`, `PerformanceDashboard`) continue resolved via shims. Primary consumers were updated to import directly from domain paths:
- `src/App.tsx` now imports `UserDashboard` from `./components/guards/UserDashboard` and `SuperadminDashboard` from `./components/admin/SuperadminDashboard`.
- `src/components/layout/OperationalShell.tsx` now imports `Header` from `../shared/Header`.

Future shim retirement: shims at original paths can be deleted once all secondary consumers have migrated to domain paths in a subsequent release.

### Identity Drift Remediation (Continuation Scope)

Continuation-scoped `Cloudyrowdyyy/Capstone-Main` remediation is limited to active runtime surfaces plus active frontend documentation and the published docs artifact:
- `.github/workflows/release.yml`: `VITE_LATEST_RELEASE_API_URL` and `VITE_RELEASE_DOWNLOAD_URL` in the web, desktop, and Android build jobs now reference `dwaytu/Capstone-Main`.
- `PRODUCTION_ROLLOUT.md`: Release download link updated to `https://github.com/dwaytu/Capstone-Main/releases`.
- `DasiaAIO-Frontend/src/App.tsx`: consent modal legal-document links (Terms, Privacy, Acceptable Use) now reference `https://github.com/dwaytu/Capstone-Main/...`.
- `DasiaAIO-Frontend/README.md`, `DasiaAIO-Frontend/docs/**`, and `docs/index.html`: active frontend documentation links now reference `dwaytu/Capstone-Main` and `https://dwaytu.github.io/Capstone-Main`.
- `CHATGPT_SYSTEM_GUIDE.md` (this document): Wave 4 continuation narrative reconciled to match runtime implementation.

Notes:
- `.gitmodules` submodule remote URLs are now aligned to the active owner (`dwaytu/DasiaAIO-Backend`, `dwaytu/DasiaAIO-Frontend`) so release checkout with `submodules: recursive` resolves correctly.
- Historical git log records are explicitly preserved as immutable provenance.

### Verification Evidence (plan: frontend-multi-issue-20260403)

- `npm run build` in `DasiaAIO-Frontend`: **PASS** — 1880 modules transformed, built in 3.33s, zero errors.
- `npm test -- --runInBand`: **PASS** — 20/20 tests across 3 suites (guardDashboardRedesign, api, settings).
- Continuation closeout validation (2026-04-03): `npm run build` **PASS** — 1880 modules transformed, built in 3.36s.
- Continuation closeout validation (2026-04-03): `npm test -- --runInBand guardDashboardRedesign` **PASS** — 12/12 tests.
- Import integrity check: primary consumers verified on domain paths; secondary consumers verified via shims; `AuditDashboard` lazy-import depth corrected in `admin/SuperadminDashboard.tsx`.
- Identity drift check: zero remaining `Cloudyrowdyyy` references in release.yml.

### Residual Risks

- Shims at original component paths must be retired after all secondary consumers migrate to domain paths to avoid long-term import ambiguity.
- Pre-existing `process` name-resolution warning in `DasiaAIO-Frontend/tests/smoke.spec.ts` (Playwright tsconfig scope) remains; does not affect runtime test execution.

## 21. First Operational Hardening Wave (2026-04-03)

### Release governance

- The hardening wave established one governed release path in `.github/workflows/release.yml` for web, desktop, and Android outputs.
- Android release distribution is now documented and verified as signed-only within that path, using the four `SENTINEL_*` signing secrets and temporary keystore materialization during CI.
- A successful live manual run (`23929317544`) confirmed prepare, quality gate, web, desktop, and Android execution; publish remained tag-gated.

### Decision-support reliability

- SENTINEL continues to treat analytics and AI outputs as assistive decision inputs rather than autonomous actions.
- Current hardening work reinforces that operating model by tightening release governance, preserving cross-platform version consistency, and reducing documentation drift around what the system actually guarantees.

### Residual risk

- The next tagged release should be observed to confirm GitHub Release publication with the same verified signing contract.
- Distribution channels outside GitHub Releases, including mobile store submission and external signing programs, remain outside the current repository scope.
