# SENTINEL Security Operations Platform

## 1. Complete Project Structure

### Workspace Root
- Monorepo-style workspace with two primary applications and architecture/runbook artifacts.
- Primary folders:
  - DasiaAIO-Frontend
  - DasiaAIO-Backend
- Key documentation files:
  - CHATGPT_SYSTEM_GUIDE.md
  - architecture.md
  - SYSTEM_AUDIT_REPORT.md
  - SYSTEM_FLOW_DIAGRAMS.md

### Frontend Folder Structure
- DasiaAIO-Frontend/src
  - components
    - dashboard
    - layout
    - rbac
    - role dashboards and utility views
  - hooks
  - context
  - config
  - types
  - utils
  - styles

### Backend Folder Structure
- DasiaAIO-Backend/src
  - handlers
  - services
  - middleware
  - db.rs
  - models.rs
  - main.rs
  - utils.rs
  - config.rs

### Shared Modules
- There is no shared compiled code package between frontend and backend.
- Sharing occurs by API contract and behavior documentation.
- Contract stability is anchored in:
  - Backend route definitions in main.rs
  - Frontend endpoint usage in hooks and dashboard components
  - System behavior notes in CHATGPT_SYSTEM_GUIDE.md

## 2. Frontend Architecture

### Core App and Bootstrapping
- Entry: DasiaAIO-Frontend/src/main.tsx
- App shell and role/view orchestration: DasiaAIO-Frontend/src/App.tsx
- Theme provider and dark/light mode context: DasiaAIO-Frontend/src/context/ThemeProvider.tsx

### Dashboards and Pages
- Elevated shell: SuperadminDashboard.tsx
- Guard shell: UserDashboard.tsx
- Specialized dashboards:
  - AdminDashboard.tsx
  - AnalyticsDashboard.tsx
  - CalendarDashboard.tsx
  - PerformanceDashboard.tsx
  - MeritScoreDashboard.tsx
  - ArmoredCarDashboard.tsx
  - ProfileDashboard.tsx

### Major Components
- Shared shell components:
  - Sidebar.tsx
  - Header.tsx
  - OperationalShell.tsx
- Command center modules under components/dashboard:
  - CommandCenterDashboard.tsx
  - SectionPanel.tsx
  - SystemStatusBanner.tsx
  - OperationalSummaryStrip.tsx
  - LiveOperationsFeed.tsx
  - IncidentAlertFeed.tsx
  - OperationalMap.tsx
  - OperationalMapPanel.tsx
  - GuardDeploymentOverview.tsx
  - TodaysShiftOperations.tsx
  - FirearmsStatusPanel.tsx
  - GuardAbsencePredictionPanel.tsx
  - ReplacementSuggestionPanel.tsx
  - VehicleMaintenancePredictionPanel.tsx
  - IncidentSeverityMonitoringPanel.tsx
  - IncidentSeverityClassifier.tsx
  - IncidentSummaryGenerator.tsx
  - PredictiveAlertsPanel.tsx

### State Management
- Primary pattern: local React state with useState/useEffect/useMemo/useCallback.
- Feature encapsulation in custom hooks (hooks directory).
- Global cross-cutting state:
  - Theme state in ThemeProvider context.
  - Auth session and active user persisted in localStorage.

### Routing Structure
- Routing is view-state driven, not react-router based.
- App.tsx manages activeView and renders role-specific workspace.
- Role-based sidebar navigation map comes from config/navigation.ts.
- Permission-aware view gating uses utils/permissions.ts.

### UI Modules (Panels, Cards, Feeds, Maps)
- Panels/containers:
  - SectionPanel, SystemStatusBanner, command panels
- Cards and KPIs:
  - CommandMetricCard, OperationalSummaryStrip, bento-style metric cards
- Feeds:
  - LiveOperationsFeed, IncidentAlertFeed, IncidentSeverityMonitoringPanel
- Maps:
  - OperationalMapPanel with Leaflet + OpenStreetMap
  - Live marker updates using websocket snapshots + polling fallback

## 3. Backend Architecture

### API Routes
- Centralized route registration in DasiaAIO-Backend/src/main.rs
- Domain coverage includes:
  - Auth and account lifecycle
  - Users and approvals
  - Firearms inventory/allocation/maintenance
  - Guard schedules, attendance, replacement
  - Notifications
  - Missions
  - Permits and training
  - Support tickets
  - Merit scores and evaluations
  - Armored cars and fleet operations
  - Trips and trip management
  - Analytics and predictive alerts
  - AI endpoints
  - Tracking and websocket map stream
  - Incidents
  - Health check

### Handlers
- Handler modules live in DasiaAIO-Backend/src/handlers
- Key handlers:
  - auth.rs
  - users.rs
  - firearms.rs
  - firearm_allocation.rs
  - firearm_maintenance.rs
  - guard_replacement.rs
  - armored_cars.rs
  - trip_management.rs
  - analytics.rs
  - alerts.rs
  - ai.rs
  - tracking.rs
  - incidents.rs
  - merit.rs
  - missions.rs
  - permits.rs
  - support_tickets.rs
  - notifications.rs
  - audit.rs

### Services
- AI and predictive logic isolated in DasiaAIO-Backend/src/services:
  - guard_prediction_service.rs
  - replacement_ai_service.rs
  - vehicle_predictive_service.rs
  - incident_ai_classifier.rs
  - incident_summary_service.rs

### Middleware
- authz.rs
  - permission-based route authorization checks
- audit.rs
  - write-request audit trail logging
- presence.rs
  - updates users.last_seen_at on authenticated requests

### Authentication Logic
- JWT generation and validation in utils.rs.
- Bearer token extraction and claims parsing in utils.rs.
- User auth workflow in auth.rs:
  - register
  - verify email
  - resend verification code
  - forgot/reset password
  - login token issuance

### RBAC Implementation
- Code-level role and permission mapping in utils.rs.
- Route guards via middleware/authz.rs.
- Role normalization maps legacy user role to guard for compatibility.
- Normalized RBAC tables are also bootstrapped in db.rs:
  - roles
  - permissions
  - role_permissions
  - user_roles

## 4. Database Architecture

### Schema Sources
- Runtime bootstrap and idempotent table/index creation in db.rs.
- Additional SQL migrations in DasiaAIO-Backend/migrations.

### Tables and Major Data Domains

#### Identity, Access, and Audit
- users
- verifications
- password_reset_tokens
- roles
- permissions
- role_permissions
- user_roles
- audit_logs

#### Guard Operations and Scheduling
- shifts
- attendance
- guard_availability
- punctuality_records
- training_records
- support_tickets

#### Firearms Domain
- firearms
- firearm_allocations
- guard_firearm_permits
- firearm_maintenance

#### Vehicle and Mission Domain
- armored_cars
- car_allocations
- car_maintenance
- driver_assignments
- trips

#### Incident and Tracking Domain
- incidents
- client_sites
- tracking_points
- notifications

#### Merit and Evaluation Domain
- guard_merit_scores
- client_evaluations

#### AI Operational Intelligence Domain
- guard_absence_predictions
- smart_guard_replacements
- incident_severity_classifications
- predictive_vehicle_maintenance
- ai_incident_summaries

### Relationships
- users acts as principal identity table referenced by most operational domains.
- Common relationship examples:
  - shifts.guard_id -> users.id
  - attendance.shift_id -> shifts.id
  - firearm_allocations.firearm_id -> firearms.id
  - guard_firearm_permits.guard_id -> users.id
  - trips.car_id -> armored_cars.id
  - incidents.reported_by -> users.id
  - audit_logs.actor_user_id -> users.id
  - notifications.user_id -> users.id

### Operational Data vs AI Data
- Operational data supports day-to-day transactional workflows and current state.
- AI data stores explainable outputs and scoring artifacts for decision support and auditability.

## 5. System Modules

- Command Center
- Guard Management
- Vehicle Management
- Firearms Inventory
- Incidents
- Scheduling
- Approvals
- Analytics
- Calendar
- Tracking
- AI Prediction Modules

### Module-to-Implementation Mapping
- Command Center:
  - CommandCenterDashboard and dashboard module components
- Guard Management:
  - users, guard_replacement, attendance, approvals flows
- Vehicle Management:
  - armored_cars, car allocation/maintenance, trip management
- Firearms Inventory:
  - firearms, firearm allocation, permits, maintenance
- Incidents:
  - incidents handler + active incident UI modules
- Scheduling:
  - shifts APIs + schedule views in elevated and guard workspaces
- Approvals:
  - pending approval endpoints and approvals UI sections
- Analytics:
  - analytics endpoint + analytics dashboard
- Calendar:
  - calendar event composition across shifts/trips/missions/maintenance
- Tracking:
  - map-data, client-sites CRUD, heartbeat, points, websocket
- AI Prediction Modules:
  - absence risk, replacement suggestions, maintenance risk, severity classification, summarization, predictive alerts

## 6. AI and Analytics Features

### Prediction Engines
- Guard absence prediction:
  - Service: guard_prediction_service.rs
  - Endpoint: GET /api/ai/guard-absence-risk
- Vehicle predictive maintenance:
  - Service: vehicle_predictive_service.rs
  - Endpoint: GET /api/ai/vehicle-maintenance-risk
- Smart replacement recommendations:
  - Service: replacement_ai_service.rs
  - Endpoint: GET /api/ai/replacement-suggestions

### Classification Systems
- Incident severity classifier:
  - Service: incident_ai_classifier.rs
  - Endpoint: POST /api/ai/classify-incident

### Summarization Features
- Incident summarization and key phrase extraction:
  - Service: incident_summary_service.rs
  - Endpoint: POST /api/ai/summarize-incident

### Risk Scoring and Predictive Alerts
- Predictive alert synthesis in alerts.rs:
  - permit expiry risk
  - vehicle maintenance overdue risk
  - repeated no-show personnel risk
  - guard capacity risk
- Endpoint: GET /api/alerts/predictive

### Analytics Features
- Aggregated KPI analytics in analytics.rs:
  - overview stats
  - performance metrics
  - resource utilization
  - mission stats
- Endpoints:
  - GET /api/analytics
  - GET /api/analytics/trends
  - GET /api/analytics/guard-reliability

## 7. Real-Time Components

### WebSocket Endpoints
- GET /api/tracking/ws
  - Token-authenticated websocket upgrade path
  - Initial snapshot push + event-driven refresh snapshots

### Live Feeds
- Frontend feed components consume periodic and live-updated data:
  - LiveOperationsFeed
  - IncidentAlertFeed
  - IncidentSeverityMonitoringPanel

### Map Tracking
- Backend tracking handler provides:
  - GET /api/tracking/map-data
  - GET/POST/PUT/DELETE client site routes
  - heartbeat and generic tracking point ingestion
- Frontend useOperationalMapData hook:
  - websocket live updates
  - polling fallback
  - client-site CRUD integration

## 8. Security Model

### Authentication Flow
1. User registration (guard self-registration requires verification and approval).
2. Email verification using short-lived code.
3. Login validates credentials and approval status.
4. JWT token issued and consumed as Bearer token by frontend API calls.
5. Middleware validates token and permission requirements per route.

### Role-Based Access Control
- Roles:
  - superadmin
  - admin
  - supervisor
  - guard
- Legacy user role is normalized to guard.
- Permission checks are enforced in middleware authz and role helper logic.

### Permissions (Representative)
- create_user
- update_user
- delete_user
- approve_guard_registration
- manage_firearms
- allocate_firearm
- manage_armored_cars
- assign_vehicle_driver
- manage_missions
- manage_schedules
- view_analytics
- manage_trip_status
- view_support_tickets
- create_support_ticket
- manage_notifications
- view_merit
- manage_merit

### Additional Security Controls
- Audit middleware logs write operations and outcomes.
- Presence middleware updates last-seen telemetry.
- Min-role and self-or-min-role helper guards protect sensitive access paths.
- Tracking endpoint constraints enforce safe guard/user telemetry submission behavior.

## 9. Dashboard Structure

### Superadmin Dashboard
- Purpose:
  - Elevated operations command shell and control center.
- Components:
  - Command center, approvals, schedules, missions, analytics, trips, audit log.
- Data sources:
  - users, pending approvals, shifts, missions, assignment resources, audit logs, command-center operational hooks.

### User (Guard) Dashboard
- Purpose:
  - Guard daily operations workspace.
- Components:
  - Overview, schedule, firearms, permits, support, attendance check-in/out, live location controls.
- Data sources:
  - attendance, guard shifts, allocations, permits, support tickets, heartbeat APIs.

### Admin Dashboard
- Purpose:
  - User/approval/schedule operational management for admin workflows.
- Components:
  - user list, approvals section, schedule section, edit modals.
- Data sources:
  - users, pending approvals, approval actions, shifts.

### Analytics Dashboard
- Purpose:
  - High-level system KPI and utilization observability.
- Components:
  - overview cards, performance metrics, mission statistics, resource utilization panels.
- Data sources:
  - analytics endpoint aggregate payload.

### Calendar Dashboard
- Purpose:
  - Unified timeline and monthly operational planning visualization.
- Components:
  - month grid, event filters, detail views.
- Data sources:
  - shifts, trips, missions, firearm maintenance schedules.

### Performance Dashboard
- Purpose:
  - Guard performance review interface.
- Components:
  - metric table and performance bars.
- Data sources:
  - users endpoint plus in-UI computed metrics.

### Armored Car Dashboard
- Purpose:
  - Fleet operations and logistics management.
- Components:
  - inventory, allocations, maintenance, trip controls.
- Data sources:
  - armored cars, allocations, maintenance, trips.

### Merit Score Dashboard
- Purpose:
  - Guard ranking, evaluation, and merit trend visibility.
- Components:
  - ranking list, guard detail, evaluation submission workflow.
- Data sources:
  - merit rankings, guard merit detail, evaluations.

### Profile Dashboard
- Purpose:
  - user profile and account detail management.
- Data sources:
  - profile and profile-photo endpoints.

## 10. System Data Flow

### Core Transaction Flow (Frontend -> Backend -> Database -> Frontend)
1. Frontend components/hooks send authenticated HTTP requests to API endpoints.
2. Backend route router in main.rs dispatches to target handler.
3. Middleware chain enforces auth, RBAC, audit logging (write paths), and presence updates.
4. Handler executes domain logic and SQL queries through SQLx.
5. PostgreSQL returns result sets and mutation outcomes.
6. Backend returns JSON payload.
7. Frontend updates local state/hooks and re-renders dashboards/panels.

### Real-Time Tracking Flow
1. Frontend opens websocket with token at /api/tracking/ws.
2. Backend validates token and sends initial snapshot.
3. Tracking events publish to in-memory broadcast bus.
4. Backend pushes refreshed snapshot payloads over websocket.
5. Frontend map/feed components update live state; polling fallback continues as resilience path.

### AI Data Flow
1. Frontend AI widget invokes AI endpoint.
2. Backend AI handler calls deterministic service module.
3. Service computes score/classification/summary and may persist explainable artifacts.
4. API returns structured output.
5. Frontend renders AI output in command-center modules.

## 11. Release and Distribution Architecture

### CI/CD Release Workflow
- Workflow file: `.github/workflows/release.yml`
- Trigger modes:
  - Manual: `workflow_dispatch` with required `release_version` and `api_base_url` inputs (`api_base_url` defaults to the production backend URL)
  - Tagged release: push tag matching `v*`
- Pipeline jobs:
  - `prepare`: resolves semantic release metadata and generates release notes from `CHANGELOG.md`
  - `quality-gate`: runs frontend and backend tests before artifact builds
  - `web`: builds `app-dist` and packages a tarball artifact
  - `desktop`: builds MSI/NSIS installers through Tauri
  - `android`: builds signed APK and AAB artifacts only
  - `publish`: attaches release assets to GitHub Releases for tag-driven runs only

### Desktop Packaging Pipeline
- Build runner: `windows-latest`
- Packaging target: Tauri bundle outputs in `apps/desktop-tauri/src-tauri/target-release/release/bundle/`
- Published installer formats:
  - MSI (`.msi`)
  - NSIS EXE (`.exe`)
- Artifact naming is normalized by `scripts/rename-artifacts.js`:
  - `sentinel-desktop-windows-v<version>.msi`
  - `sentinel-desktop-windows-v<version>.exe`

### Android Packaging Pipeline
- Build runner: `ubuntu-latest`
- Build command path:
  - frontend production build -> capacitor sync -> Gradle release assemble + bundle
- Release signing behavior:
  - `SENTINEL_ANDROID_KEYSTORE_BASE64` is required
  - `SENTINEL_UPLOAD_STORE_PASSWORD`, `SENTINEL_UPLOAD_KEY_ALIAS`, and `SENTINEL_UPLOAD_KEY_PASSWORD` are required
  - workflow exits early when signing inputs are missing (no unsigned fallback path)
- Artifact naming is normalized by `scripts/rename-artifacts.js`:
  - `sentinel-android-v<version>.apk`
  - `sentinel-android-v<version>.aab`

### Version Synchronization and Metadata
- `scripts/release-version.js` derives release tag, app version, and Android versionCode
- `scripts/sync-release-version.js` synchronizes versions across:
  - root `package.json`
  - `DasiaAIO-Frontend/package.json`
  - `apps/android-capacitor/package.json`
  - `apps/desktop-tauri/package.json`
  - `apps/desktop-tauri/src-tauri/tauri.conf.json`
  - `apps/desktop-tauri/src-tauri/Cargo.toml`
- `scripts/generate-release-notes.js` generates release notes and a short `What's New` summary for clients

### Runtime and Action Notes
- Workflow build runtime uses Node.js 22 via `actions/setup-node`.
- Release builds inject one shared backend base URL through `VITE_API_BASE_URL` for web, desktop, and Android outputs.
- Frontend release scripts enforce production safety checks (`DasiaAIO-Frontend/scripts/ensure-production-env.mjs`) before packaging.

### Verified Release Outcome
- Live manual run `23929317544` completed `prepare`, `quality-gate`, `web`, `desktop`, and `android` successfully.
- The Android path materialized signing material, produced signed APK and AAB outputs, and confirmed that publish remains tag-gated rather than dispatch-driven.

### Distribution Surface
- Successful tag builds publish install artifacts directly to GitHub Releases for the matching tag.
- Release page should contain:
  - Web release tarball (`sentinel-web-v<version>.tar.gz`)
  - Desktop `.msi` and `.exe`
  - Android `.apk` and `.aab`

## 12. Latest Hardening Delta (2026-03-29)

- Removed hardcoded database credentials from `DasiaAIO-Backend/seed.js`; seeding now requires `DATABASE_URL`.
- Corrected password-reset migration contract in `DasiaAIO-Backend/migrations/add_password_reset_tokens.sql` (`user_id VARCHAR(36)`, timezone-aware timestamps).
- Aligned Android wrapper test namespaces with active package ID (`com.sentinel.app`) under:
  - `apps/android-capacitor/android/app/src/test/java/com/sentinel/app/`
  - `apps/android-capacitor/android/app/src/androidTest/java/com/sentinel/app/`
- Simplified release workflow secret bindings in `.github/workflows/release.yml` to direct secret references.

### Validation Snapshot

- Frontend tests: pass (`npm test --prefix DasiaAIO-Frontend -- --runInBand`).
- Frontend build: pass (`npm run build --prefix DasiaAIO-Frontend`).
- Backend tests: pass (`cargo test --manifest-path DasiaAIO-Backend/Cargo.toml`).
- Runtime health: pass (`docker compose up -d` and `GET /api/health` returns `status: ok`).

### Current Residual Risk

- Final confidence for release secrets requires a live GitHub Actions run in repository context.
- Android classpath validation should still be confirmed through Android Studio/CI Gradle test execution.

## Reviewer Notes
- Architecture is endpoint-centric with middleware-enforced security and role policy.
- Operational and AI data are clearly separated while linked by user/incident/asset identifiers.
- Real-time map behavior combines websocket push with polling fallback for resilience.
- Frontend is modular and dashboard-driven, with role-aware view composition and hook-based data integration.
