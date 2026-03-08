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

## 3. Repository Layout

- `DasiaAIO-Frontend/`: Web app UI, dashboards, client-side logic, tests
- `DasiaAIO-Backend/`: API server, DB migrations/init, domain handlers
- Root docs:
  - `SYSTEM_AUDIT_REPORT.md`
  - `explanation.md`
  - `Capstone_Option_5_DASIA_Implemented_System.md`

## 4. Current Role Model (Important)

### Implemented and enforced

- `superadmin`
- `admin`
- `supervisor`
- `guard`

### Legacy compatibility still present

- `user` is still accepted as a legacy role value and normalized to `guard` in critical paths.

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

Behavior highlights:

- Gmail-only validation for registration email
- Public registration only creates guard accounts
- Self-registered guard accounts start as `pending` approval
- Login requires both email verification and `approval_status = approved`
- Admin/supervisor accounts should be created internally via authenticated management flows
- Email verification required when email provider is configured
- JWT token issued on login and used by frontend persistence

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

## 8. API and Security Notes

- JWT generation and verification are active and used in managed user creation.
- Permission-based authorization middleware is active (`DasiaAIO-Backend/src/middleware/authz.rs`) and applied at route level in `DasiaAIO-Backend/src/main.rs`.
- Centralized write audit middleware is active (`DasiaAIO-Backend/src/middleware/audit.rs`) and records write outcomes (`success`/`failed`) into `audit_logs`.
- Managed user creation endpoint (`POST /api/users`) enforces role hierarchy:
  - `superadmin` can create `admin`, `supervisor`, and `guard`
  - `admin` can create `supervisor` and `guard`
- Guard approval management endpoints are active:
  - `GET /api/users/pending-approvals`
  - `PUT /api/users/:id/approval`
- Guard login is blocked when `approval_status != approved`.
- CORS is permissive by default unless `CORS_ORIGIN` env var is set.
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
- Reviewer notifications and guard decision notifications are persisted in `notifications`
- API authorization is still the final source of truth even when frontend hides/shows role surfaces
- Centralized middleware coverage now spans both primary and legacy privileged route families (users, firearms, allocations, schedules, missions, analytics, notifications, tickets, merit, armored cars, trips, permits, maintenance, training)
- Audit logging is route-layered on write endpoints and captures both authorized writes and authorization failures that return HTTP error responses
- Guard-scoped ownership enforcement was tightened in handlers to prevent cross-user access on authenticated routes:
  - `DasiaAIO-Backend/src/handlers/firearm_allocation.rs`: `get_guard_allocations` now requires `self` access or minimum `supervisor` role.
  - `DasiaAIO-Backend/src/handlers/guard_replacement.rs`: `check_in`, `check_out`, `set_availability`, `get_guard_shifts`, and `get_guard_attendance` now enforce self-or-supervisor checks, with additional guard/shift ownership validation in attendance flows.
- Overdue firearm allocation query fix:
  - `DasiaAIO-Backend/src/handlers/firearm_allocation.rs`: `get_overdue_allocations` now queries the existing `firearm_allocations.return_date` column (instead of non-existent `expected_return_date`) and returns `returnDate` in payload rows.

## 10. Frontend Context Snapshot (Keep Updated)

Primary frontend files that must be rechecked when roles/auth/dashboards change:

- `DasiaAIO-Frontend/src/App.tsx`: role-based top-level dashboard routing
- `DasiaAIO-Frontend/src/components/AdminDashboard.tsx`: admin/supervisor dashboard shell + approvals UI
- `DasiaAIO-Frontend/src/components/SuperadminDashboard.tsx`: superadmin shell + approvals UI
- `DasiaAIO-Frontend/src/components/CalendarDashboard.tsx`: role-aware event aggregation and guarded API calls
- `DasiaAIO-Frontend/src/components/MeritScoreDashboard.tsx`: merit API calls and auth headers
- `DasiaAIO-Frontend/src/utils/api.ts`: fetch wrapper behavior, timeout, and parsing safety

Current frontend reality:

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
  - `DasiaAIO-Frontend/src/utils/permissions.ts`: defines capability map and `can(...)` helper for UI gating.
  - `DasiaAIO-Frontend/src/utils/permissions.ts`: now also exposes `canAny(...)` and `canAll(...)` for composite UI permission checks.
  - `DasiaAIO-Frontend/src/config/navigation.ts`: single source for role-aware sidebar navigation across elevated and guard workspaces.
  - `DasiaAIO-Frontend/src/App.tsx`: now uses normalized roles and centralized permission checks for dashboard routing decisions.
  - `DasiaAIO-Frontend/src/components/AccountManager.tsx`: legacy `'user'` role-specific branch removed to stay aligned with normalized `Role` typing.
  - `DasiaAIO-Frontend/src/components/dashboard/SectionPanel.tsx` + `DasiaAIO-Frontend/src/components/dashboard/CommandMetricCard.tsx`: reusable command-center layout primitives used for dashboard readability and KPI consistency.
  - `DasiaAIO-Frontend/src/components/dashboard/OperationalSummaryStrip.tsx` + `DasiaAIO-Frontend/src/components/dashboard/QuickActionsPanel.tsx`: shared dashboard modules for command metrics and high-frequency operations shortcuts.
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
  - Additional SOC consistency pass for non-command-center operational views:
    - `DasiaAIO-Frontend/src/components/AnalyticsDashboard.tsx`: legacy light-only cards replaced with tokenized command panels and status-bar KPIs.
    - `DasiaAIO-Frontend/src/components/TripManagement.tsx`: error/banner states, action buttons, modal surfaces, and assignment chips updated to SOC token classes.
    - `DasiaAIO-Frontend/src/components/ArmoredCarDashboard.tsx`: alert banners, KPI strip, and tab panels moved to `bento-card`/`command-panel`/`table-glass` hierarchy.
    - `DasiaAIO-Frontend/src/components/MeritScoreDashboard.tsx`: ranking/detail/evaluation surfaces updated to command-panel styling and shared action button styles.
    - `DasiaAIO-Frontend/src/components/CalendarDashboard.tsx`: filter controls, monthly grid states, and day-detail status chips aligned to shared SOC status tokens; added skip link and `main#maincontent` focus target.
    - `DasiaAIO-Frontend/src/components/PerformanceDashboard.tsx`: table header/metric styling aligned to SOC command surfaces; attendance progress bars and task chips moved to semantic token-driven styles; added skip link and `main#maincontent` focus target.
    - `DasiaAIO-Frontend/src/index.css`: added shared SOC utilities for multi-page reuse (`soc-btn*`, `soc-alert-*`, `soc-chip`).
  - Branded shell/login integration:
    - `DasiaAIO-Frontend/src/components/Header.tsx` and `DasiaAIO-Frontend/src/components/Sidebar.tsx` now embed `SentinelLogo` and use SOC typography/tokens.
    - `DasiaAIO-Frontend/src/components/layout/OperationalShell.tsx` adds an explicit skip link + `main#maincontent` focus target.
    - `DasiaAIO-Frontend/src/components/LoginPage.tsx` now renders a mission-access terminal layout with tactical grid backdrop, branded auth card, and right-side system status panel.
    - `LoginPage` now also includes command-center polish features:
      - subtle full-viewport rotating radar sweep overlay in the background (pure CSS, low-opacity)
      - live-style system status cards with iconography, status lights, and slow node ticker updates
      - terminal-style login action button with glow/elevation hover, active flash/scale, and stronger keyboard focus ring

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
  - `npm test -- --runInBand` succeeded (`5/5` tests passing)
  - Browser smoke on `http://localhost:4173` verified:
    - command-center top/middle/bottom hierarchy and quick-action console layout
    - skip-link presence and keyboard focus target (`#maincontent`)
    - branded login terminal layout and integrated `SentinelLogo`
    - header theme toggle + dark/light mode switching behavior
- Frontend verification after additional multi-page SOC consistency pass:
  - Workspace diagnostics: no TypeScript errors in modified files
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
