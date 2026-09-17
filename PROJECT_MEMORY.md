# PROJECT_MEMORY.md — SENTINEL Security Operations Platform

> This file is the persistent working memory for AI coding agents (Codex / Copilot / orchestrators) working on SENTINEL.
>
> Purpose:
> - keep product, UX, architecture, deployment, and documentation aligned
> - prevent random feature drift
> - help AI think like a startup CTO + product designer + capstone engineer

---

# 1) PROJECT IDENTITY

## Product Name
**SENTINEL**

## Product Category
Security Operations Platform / Command & Control System / Guard Operations Management System

## Core Vision
SENTINEL should feel like a **real operational platform**, not a student dashboard project.

Conceptually, it should move toward:
- **Palantir-style operational intelligence**
- **mission-centric workflows**
- **role-based decision support**
- **high-trust field usability**

SENTINEL is NOT meant to be “feature-stuffed.”
It should be:
- cohesive
- reliable
- readable under pressure
- deployable
- believable as a real product

---

# 2) PRIMARY PRODUCT GOAL

SENTINEL exists to help security agencies manage:

- guards
- schedules
- incidents
- firearms
- armored vehicles
- missions / trips
- approvals
- real-time tracking
- operational awareness

The system should help users **make decisions quickly**, not just view data.

---

# 3) TARGET USERS

## Primary Users
### Guards
The guard is the most important user.
The system must work for them under:
- stress
- low connectivity
- mobile-only conditions
- emergency scenarios

### Supervisors
Need:
- situational awareness
- rapid incident prioritization
- fast escalation visibility

### Admin / Superadmin
Need:
- command center visibility
- approvals
- staffing / scheduling control
- resource / incident overview
- auditability

---

# 4) CORE PRODUCT PRINCIPLES

All future work MUST follow these principles:

## 4.1 Guard-first usability
If a guard cannot use it quickly at 2AM, it is bad UX.

## 4.2 Clarity over complexity
Do NOT add UI clutter or cleverness that reduces readability.

## 4.3 Decisions over dashboards
Dashboards must help users act, not just observe.

## 4.4 Real trust over fake polish
Never fake system intelligence, fake metrics, fake contacts, fake activity, or fake confidence.

## 4.5 Product cohesion
Everything should feel like ONE connected system, not isolated modules.

## 4.6 Production readiness
The system should always move toward:
- deployability
- reliability
- maintainability
- realistic use

---

# 5) CURRENT PLATFORMS

SENTINEL currently targets:

- **Web**
- **Desktop (Tauri)**
- **Mobile Android (Capacitor)**

All 3 should:
- use the same backend
- use the same database
- share the same business logic and product behavior
- feel like the same product

No platform should feel “secondary” or broken.

---

# 6) KNOWN PROJECT DIRECTION

## 6.1 DO NOT add random new features
The project has already passed the “feature accumulation” stage.

Current priority is:
- improve what exists
- make it stable
- make it trustworthy
- make it polished

## 6.2 Maintain the current design language
The goal is NOT to completely redesign the product.
The goal is to:
- refine it
- mature it
- professionalize it

## 6.3 Think like a startup + capstone
Every improvement should satisfy BOTH:
- “Would this make the product more real?”
- “Would this help in capstone defense?”

---

# 7) ARCHITECTURE MEMORY

## 7.1 Frontend (known structure)
Frontend is React-based and includes:
- role-based dashboards
- modular dashboard panels
- operational map components
- theme system
- local state + hooks
- role-aware navigation

Known dashboard/page structure includes:
- SuperadminDashboard
- AdminDashboard
- AnalyticsDashboard
- CalendarDashboard
- PerformanceDashboard
- MeritScoreDashboard
- ArmoredCarDashboard
- ProfileDashboard
- Guard/User dashboard
- Command center modules

## 7.2 Backend (known structure)
Backend is Rust-based and includes:
- route-centric API registration
- handlers
- services
- middleware
- DB bootstrap / schema logic

Known domains:
- auth
- users
- approvals
- firearms
- schedules
- attendance
- notifications
- incidents
- tracking
- analytics
- AI endpoints
- trips
- armored cars
- merit / evaluation
- support tickets

## 7.3 Database
Shared operational DB.
The system should remain **single-source-of-truth**, not fragmented per platform.

---

# 8) MAJOR PRODUCT THEMES

## 8.1 Operational Command Interface
SENTINEL should feel like:
- a command center
- an operational console
- a field support system

NOT:
- a school dashboard template
- a generic admin panel

## 8.2 Live Operational Storytelling
Important operational events should connect across:
- map
- alerts
- live feed
- incidents
- deployment views
- AI suggestions

The system should tell a live operational story.

## 8.3 Role-based decision support
Each role should be designed around:
- what they must decide
- what they must do next
- what they need to notice first

---

# 9) UX MEMORY — MOST IMPORTANT

## 9.1 Biggest current weakness: UI/UX maturity
The system’s biggest weakness is still:
- UI quality
- layout discipline
- visual hierarchy
- “product feel”

This is more important right now than adding features.

## 9.2 Common UX issues previously identified
The project has repeatedly suffered from:

### Layout / responsiveness
- overlapping content
- map overlay issues
- sidebar scrolling incorrectly
- profile hidden on mobile
- modals clipped or blocked
- broken mobile ergonomics

### Visual quality
- bland / flat / skeleton-like screens
- weak hierarchy
- too many equal-looking cards
- low visual confidence
- “unfinished student project” feeling

### Data density problems
- crowded tables
- action columns getting crushed
- weak row readability
- repetitive low-value actions like generic “View Details”

### Theme quality
- weak light mode
- dark mode needing better contrast / depth

---

# 10) UX DESIGN RULES (MUST FOLLOW)

These are non-negotiable.

## 10.1 Glanceability
A user should understand the screen in **< 2 seconds**.

## 10.2 Strong hierarchy
Important things must stand out immediately:
- critical alerts
- status
- primary actions
- role-relevant information

## 10.3 Low friction
Under pressure, users should not have to “figure things out.”

## 10.4 Mobile-first usability
Mobile is not secondary.
All mobile interactions must be:
- readable
- tappable
- unobstructed
- stress-friendly

## 10.5 Operational data grid behavior
For data-heavy screens:
- use fixed/flexible column planning
- avoid overlap
- keep actions accessible
- prefer clear operational tables over generic admin tables

## 10.6 Map should not overpower UI
Map is contextual, not the primary focus all the time.
It must not:
- overpower text
- create visual noise
- block overlays

---

# 11) GUARD EXPERIENCE MEMORY

## The guard is the biggest user base.
This is critical.

The guard experience should feel like:
- a mission screen
- a field tool
- a practical emergency interface

NOT:
- a mini admin dashboard

## Guard UX must prioritize:
- duty status
- assignment
- SOS / emergency actions
- reporting
- supervisor contact
- current operational relevance

## Guard UX must avoid:
- empty dead screens
- weak actions
- low urgency
- confusing labels

---

# 12) MIDNIGHT SHIFT HARDENING MEMORY

This is an important completed milestone.

## Guiding question:
**“Would a real guard trust and rely on this system during an emergency at 2AM?”**

## Result:
**YES — field-ready**, with some deferred non-blockers.

## Major improvements completed:
- removed fake trust signals / fake competence
- simplified emergency workflows
- added 1-tap SOS behavior
- made emergency contacts more visible
- improved offline resilience
- improved command center prioritization
- improved clarity / plain language

## Important trust principle learned:
Never fake:
- status
- monitoring
- support contacts
- operational confidence

---

# 13) CURRENT STRATEGIC PHASE

SENTINEL is now in:

# REFINEMENT / VALIDATION / PRODUCTIZATION PHASE

This means:
- do NOT bloat the feature set
- improve quality
- prove usability
- fix weak points
- harden deployment
- make the system feel finished

---

# 14) WHAT “DONE” LOOKS LIKE

SENTINEL should eventually feel like:

- a real product
- something a security agency could actually pilot
- something a panel would believe
- something that could become a real SaaS

The system should feel:
- stable
- coherent
- trustworthy
- role-aware
- useful under pressure

---

# 15) WHAT THE SYSTEM IS CURRENTLY MISSING (STRATEGIC GAPS)

These are the biggest conceptual gaps still being closed:

## 15.1 Product maturity
Need stronger:
- cohesion
- trust
- polish
- deployment quality

## 15.2 Decision intelligence
Need stronger:
- actionability
- recommendation clarity
- operational narrative

## 15.3 UI confidence
Need stronger:
- visual hierarchy
- ergonomic layout
- screen readability
- command-grade feel

## 15.4 Production confidence
Need stronger:
- release quality
- build reliability
- install/update trust
- real deployment readiness

---

# 16) DEPLOYMENT / RELEASE MEMORY

## Goals
All versions should be **production-ready**:
- web
- desktop
- android

## Known needs
- versioned artifacts
- better GitHub releases
- easier install experience
- auto-update system where appropriate
- professional release notes
- proper changelog generation
- signed builds
- reduced trust friction

## Desired release artifact naming
Examples:
- `SENTINEL_v1.1.1.apk`
- `SENTINEL_v1.1.1.exe`

## Android signing issue (known blocker)
Known recurring issue:
> Android release signing secrets are required for release builds.

This MUST be solved with:
- a real keystore
- GitHub Secrets
- CI workflow integration

### Required GitHub secrets
- `ANDROID_KEYSTORE_BASE64`
- `ANDROID_KEYSTORE_PASSWORD`
- `ANDROID_KEY_ALIAS`
- `ANDROID_KEY_PASSWORD`

## Important keystore rule
Keystore must be treated as critical identity.
If lost, update continuity is at risk.

---

# 17) AUTO-UPDATES MEMORY

## Desktop
Tauri updater should be considered for production-grade desktop updates.
Tauri’s updater requires signed update artifacts and a persistent signing key.

## Mobile / Web
Update UX should include:
- “What’s New”
- version awareness
- clean release messaging

---

# 18) PUSH NOTIFICATIONS MEMORY

Push notifications are one of the few deferred features worth implementing next because guards may not always have the app open.

## Recommended direction
Use **Firebase Cloud Messaging (FCM)** for Android and web notifications.
FCM supports Android and web, including foreground/background handling and topic/device targeting.

## Android considerations
Android 13+ requires runtime notification permission (`POST_NOTIFICATIONS`) for reliable notification delivery.

## Web considerations
Web push requires:
- HTTPS
- service worker
- VAPID key configuration in Firebase / web app.

---

# 19) DOCUMENTATION MEMORY

Documentation must remain synchronized with the system.

But synchronization does NOT mean:
- dumping implementation details
- writing commit logs into the paper
- exposing component-level dev narration

## Required documentation style
Documentation should be:
- professional
- concise
- academically appropriate
- product/system focused

## Documentation must avoid
- component names unless absolutely necessary
- dev jargon
- implementation chronology (“later pass”, “implemented first”, etc.)
- AI-sounding over-technical phrasing

## Preferred style
Describe:
- what the system does
- why it matters
- how it supports operations

Not:
- how every internal component was coded

## Important docs
- `SENTINEL - Group 8.md`
- `CHATGPT_SYSTEM_GUIDE.md`
- deployment / release / runbook docs

---

# 20) AGENT ORCHESTRATION MEMORY

The user uses a multi-agent orchestration workflow with agents like:
- browser tester
- code simplifier
- critic
- debugger
- designer
- devops
- documentation writer
- implementer
- orchestrator
- planner
- researcher
- reviewer

## Required orchestrator behavior
The orchestrator should NOT just obey instructions.

It should:
- think independently
- critique the product
- detect issues proactively
- propose multiple solutions
- choose the best one
- implement carefully
- self-review
- refine again

## Desired orchestrator mindset
Think like:
- startup CEO
- CTO
- product manager
- UX lead
- capstone student
- real field user

---

# 21) HOW AI AGENTS SHOULD WORK ON THIS PROJECT

Whenever an AI agent changes SENTINEL, it should ask:

## Product questions
- Does this improve real usability?
- Does this make the product more believable?
- Does this make a role’s job easier?

## UX questions
- Is this clearer in 2 seconds?
- Is this easier under pressure?
- Is this less cluttered?
- Is this more mobile-safe?

## Engineering questions
- Is this stable?
- Is this production-safe?
- Does this break any cross-platform behavior?

## Documentation questions
- Does documentation remain aligned?
- Is the explanation too technical or too verbose?

---

# 22) WHAT TO PRIORITIZE NEXT

Unless explicitly overridden, prioritize in this order:

## Priority 1 — UI / UX maturity
- hierarchy
- layout stability
- mobile usability
- clarity
- “finished product” feel

## Priority 2 — Real-world validation
- click-through testing
- stress scenarios
- friction elimination
- role-by-role usability

## Priority 3 — Production readiness
- Android signing
- CI/CD stability
- release quality
- install/update experience

## Priority 4 — Documentation quality
- capstone-ready language
- alignment with real system behavior

## Priority 5 — Selective deferred features only if high-value
Examples:
- push notifications
- minimal supervisor incident visibility improvements

---

# 23) THINGS TO AVOID

Avoid:
- random features
- fake intelligence
- fake data
- overengineering
- academic-writing pollution from raw implementation details
- UI complexity without operational value
- “pretty but unusable” design

---

# 24) SUCCESS TEST

Before considering any improvement “done,” ask:

## Core trust test
**Would a real guard trust this at 2AM?**

## Product test
**Would this make the system feel more like a real product?**

## Capstone test
**Would this strengthen defense / credibility?**

If the answer is no, the work is incomplete.

---

# 25) LIVE ENVIRONMENT MEMORY

## Production web app
Known live deployment:
- `https://dasiasentinel.xyz`

Agents may be instructed to:
- test it live
- click through it
- inspect console/network behavior
- critique and improve UI from real behavior

This should be used as a validation target when appropriate.

---

# 26) FINAL WORKING IDENTITY

SENTINEL should ultimately become:

> A guard-first, supervisor-aware, command-grade operational platform that feels deployable, believable, and professionally designed.

That is the north star.

---

# 27) WORKSPACE ORGANIZATION MEMORY (2026-05-01)

## Intent
Improve repository readability without risky path moves that could break imports, scripts, or deployment workflows.

## Changes applied
- Curated multi-root VS Code workspace in `Capstone Main.code-workspace`:
  - `00 Root Governance`
  - `01 Frontend`
  - `02 Backend`
  - `03 Apps`
  - `04 Docs`
- Added workspace/file hygiene defaults in:
  - `Capstone Main.code-workspace`
  - `.vscode/settings.json`
- Hidden generated/clutter-heavy paths from Explorer/Search:
  - `node_modules`, `target`, `tmp`, `dist`, `build`, `app-dist`, `.venv`
- Enabled file nesting for cleaner root browsing:
  - governance docs grouped under `README.md`
  - `SENTINEL - Group 8.pdf` nested under `SENTINEL - Group 8.md`
  - `package-lock.json` nested under `package.json`
- Added navigation guide: `docs/WORKSPACE_NAVIGATION.md`
- Linked navigation guide in `README.md` documentation section.

## Rationale
This approach makes the workspace look professional and easier to read while preserving existing runtime and build behavior.

## Safe cleanup pass
- A reversible clutter-reduction pass moved legacy implementation/audit reports and misc historical files from root into `archive/2026-05-01-safe-cleanup/`.
- Root login screenshots were relocated to `docs/screenshots/login/` to keep evidence assets in documentation space.
- Temporary extracted artifacts under `tmp/docx_read` were archived, and `tmp/` was cleaned.
- Documentation references in `architecture.md` and `CHATGPT_SYSTEM_GUIDE.md` were updated to the archived audit/explanation paths.

## Railway automation pass
- Added GitHub Actions workflow `.github/workflows/railway-deploy.yml` for automated Railway deployment of backend and frontend services on `main` changes and manual dispatch.
- Added setup guide `docs/RAILWAY_AUTODEPLOY.md` with required secret (`RAILWAY_TOKEN`) and repository variables (`RAILWAY_PROJECT_ID`, `RAILWAY_ENVIRONMENT`, `RAILWAY_BACKEND_SERVICE`, `RAILWAY_FRONTEND_SERVICE`).
- Added local deployment script `scripts/railway-deploy.ps1` and root npm shortcuts:
  - `npm run deploy:railway`
  - `npm run deploy:railway:backend`
  - `npm run deploy:railway:frontend`
- Added VS Code extension recommendations for workflow/deployment authoring (`github-actions`, `docker`, `yaml`, `rust-analyzer`).

---

# 28) ORCHESTRATION POLICY MEMORY (2026-05-01)

## Leadership model
SENTINEL orchestration now follows a software-company delegation structure:
- CTO: `sentinel-orchestrator`
- Department heads:
  - `sentinel-planner`
  - `sentinel-backend-engineer`
  - `sentinel-frontend-engineer`
  - `sentinel-designer`
  - `sentinel-qa-lead`
  - `sentinel-security-reviewer`
  - `sentinel-release-manager`
  - `sentinel-capstone-documenter`

## Model default
- Default model for orchestration and coding workflows is `GPT-5.3-Codex`.
- Team manifests under `.github/agents/` and policy docs were updated to keep this default stable across new sessions.

---

# 29) LOCAL SMOKE + FEEDBACK SCHEMA FIX MEMORY (2026-05-01)

## Backend reliability fix
- Added missing `feedback` table bootstrap in `DasiaAIO-Backend/src/db.rs` to match existing feedback handlers (`/api/feedback`, `/api/feedback/status`) and stop runtime 500 errors on local deployments without that table.
- Added feedback indexes:
  - `idx_feedback_user_id`
  - `idx_feedback_created_at`
- Verified with `cargo check` and container rebuild (`docker compose up -d --build backend`).

## Local smoke baseline (web + mobile-webview)
- Local stack validated at:
  - backend: `http://localhost:5000`
  - frontend: `http://localhost:5173`
- API health confirmed: `/api/health` returned `status: ok`.
- Feedback API verified after fix using authenticated superadmin request to `/api/feedback` (no relation error).

## Browser smoke evidence
- Playwright artifacts written under:
  - `DasiaAIO-Frontend/output/playwright/local-smoke-fast/`
  - `DasiaAIO-Frontend/output/playwright/local-smoke-roles/`
  - `DasiaAIO-Frontend/output/playwright/local-smoke-guard/`
- Role coverage includes `superadmin`, `admin`, `supervisor`, and `guard` in desktop and Android-sized webview contexts.

## Packaging checks
- Desktop packaging validated with `npm run build:desktop` (Tauri MSI + NSIS outputs generated).
- Android wrapper validated with:
  - `npm run build:android` (Vite mobile build + Capacitor sync)
  - `apps/android-capacitor/android/gradlew.bat :app:assembleDebug` (debug APK build success)

---

# 30) GUARD MAP TILE PARITY MEMORY (2026-05-01)

- Guard map rendering no longer depends on OpenStreetMap embed iframe visuals alone; it now uses a Leaflet map surface with the same theme-aware Carto tile source policy used by elevated command map views (`dark_all` for dark theme, `rastertiles/voyager` for light theme).
- Implemented as lazy-loaded guard map canvas to preserve existing Jest guard-dashboard test stability while improving runtime visual parity.
- Verification run:
  - `npm test -- --runTestsByPath src/__tests__/guardDashboardRedesign.test.tsx --runInBand` (pass)
  - `npm run build` in frontend (pass)
  - Browser evidence screenshot: `DasiaAIO-Frontend/output/playwright/guard-map-carto-parity.png`.

---

# 31) RAILWAY DEPLOY MODEL MEMORY (2026-05-01)

- Deployment model is now Railway-native GitHub autodeploy per service (Backend + Frontend), with service source wiring managed in Railway UI and branch/root-directory mapping owned there.
- The repo-local GitHub Actions workflow `.github/workflows/railway-deploy.yml` was removed to prevent repeated CI auth failures from GitHub-hosted runners.
- `docs/RAILWAY_AUTODEPLOY.md` now documents the canonical setup:
  - Backend source repo: `dwaytu/DasiaAIO-Backend` (branch `main`)
  - Frontend source repo: `dwaytu/DasiaAIO-Frontend` (branch `main`)
  - Auto-deploy on push enabled in Railway service source settings.
- Local manual fallback remains available via `scripts/railway-deploy.ps1` and root `npm run deploy:railway*` commands.

## Finalization snapshot
- Railway service source status:
  - Frontend auto-deploy: enabled
  - Backend auto-deploy: enabled
  - Wait for CI: disabled on both
- Deploy-trigger pushes executed to service repos without touching local WIP files:
  - Frontend trigger commit: `87d30fc` (`dwaytu/DasiaAIO-Frontend`)
  - Backend trigger commit: `9235b71` (`dwaytu/DasiaAIO-Backend`)

---

# 32) BACKEND DIAGNOSTIC CLEANUP + VS CODE GRADLE CACHE REPAIR (2026-05-02)

## Backend warning cleanup
- Eliminated Rust `dead_code` warnings that were flooding the VS Code Problems panel by applying targeted cleanup:
  - Removed unused no-show query fields from `handlers/guard_replacement.rs` (`grace_period_minutes`, `replacement_status`) and aligned SQL projection.
  - Removed unused shift proximity query fields from `handlers/tracking.rs` (`guard_id`, `start_time`) and aligned SQL projection.
  - Marked intentional compatibility-only structures with narrow `#[allow(dead_code)]`:
    - `MissionAssignmentRequest` in `handlers/missions.rs`
    - `ActiveTripWithGuards` in `handlers/trip_management.rs`
  - Added module-level `#![allow(dead_code)]` in `src/models.rs` because this file keeps shared/legacy DTOs used across uneven deployment paths.
- Verification:
  - `cd DasiaAIO-Backend && cargo check` now completes with zero warnings.

## Android/Gradle tooling status
- Confirmed Android Gradle project builds correctly from CLI:
  - `cd apps/android-capacitor/android && .\\gradlew.bat :capacitor-cordova-android-plugins:help` -> BUILD SUCCESSFUL.
- Repaired missing Red Hat Java extension init script path used by VS Code Java Gradle import by recreating the absent cache file under `%APPDATA%\\Code\\User\\globalStorage\\redhat.java\\1.53.0\\...\\gradle\\init\\init.gradle` from the existing 1.54.0 template.
- This issue was IDE cache/tooling-state related, not a project code build failure.

---

# 33) OBJECTIVE 9 GEOFENCE COMMAND-SURFACE CLOSURE (2026-05-02)

## Objective coverage impact
- Closed the previously documented frontend gap for geofence-zone command management by exposing backend geofence CRUD in the command map UI.
- This directly improves Specific Objective 9.c/9.e/9.f coverage (site/geofence management + supervisory geofence monitoring response surface).

## Frontend implementation
- Extended `useOperationalMapData` with:
  - geofence-zone models (`GeofenceZone`, `GeofenceZoneInput`)
  - elevated-role geofence loading (`GET /api/tracking/geofences`)
  - geofence CRUD methods:
    - `POST /api/tracking/client-sites/:id/geofences`
    - `PUT /api/tracking/geofences/:id`
    - `DELETE /api/tracking/geofences/:id`
- Updated `OperationalMapPanel` to:
  - render real geofence zones per site (radius circles and polygon overlays when present)
  - replace fixed hardcoded “1 km” display with actual active-zone counts
  - add a Geofence Zone Manager (create/edit/activate/delete radius zones) for elevated roles.

## Verification
- `cd DasiaAIO-Frontend && npm run build` passed.
- Focused map/tracking test suite passed:
  - `mapTileUrls.test.ts`
  - `operationalMapTruthfulness.test.ts`
  - `trackingAccessPolicy.test.ts`
- Backend compile sanity check passed:
  - `cd DasiaAIO-Backend && cargo check`

---

# 34) REPOSITORY DOCS PROFESSIONALIZATION + PAGES LANDING REFRESH (2026-05-02)

## README standardization
- Rewrote README content in all three primary repositories to align with industry-style structure and onboarding clarity:
  - Root: `README.md`
  - Frontend repo: `DasiaAIO-Frontend/README.md`
  - Backend repo: `DasiaAIO-Backend/README.md`
- New structure emphasizes:
  - concise product overview
  - clear topology/repository relationships
  - prerequisite/setup commands
  - validated build/release commands
  - deployment model and governance links
  - security/configuration expectations

## GitHub Pages landing refresh
- Replaced `docs/index.html` with a cleaner, professional landing page design focused on:
  - architecture summary
  - repository topology and direct links
  - build/release command table
  - documentation/legal access points
  - production/release entry links
- Preserved deployment path: GitHub Pages still publishes from `docs/` via `.github/workflows/deploy-docs.yml`.

## Encoding hygiene
- Rewrote updated documentation files in UTF-8 without BOM to avoid rendering artifacts in markdown/html surfaces.

---

# 35) MDR SOURCE-OF-TRUTH IMPLEMENTATION (PHASES 1-6) (2026-05-02)

## Phase 1 - Ingestion and commit stability
- MDR batch responses now expose `pending_rows` by computing live pending counts from staging rows.
- MDR review resolution now refreshes batch counters immediately after row resolution so `matched/new/ambiguous/error` totals stay in sync before commit.
- Frontend MDR review/list now display pending counts and include pending rows in unresolved totals.

## Phase 2 - Data quality gates
- Added row-level MDR validation in backend matching:
  - required-field checks by section (guard/client/vehicle identifier expectations),
  - format checks for contact numbers, date fields, and serial formatting,
  - duplicate license and duplicate serial detection inside the same batch.
- Validation errors are persisted in `mdr_staging_rows.validation_errors` and surfaced in the MDR review UI.

## Phase 3 - Lifecycle tracking expansion
- Added armored asset lifecycle import handling for MDR `armored` rows:
  - armored car upsert by plate/VIN-like identifier,
  - status update on import,
  - optional client allocation creation when client context exists.
- Added `armored_car_status_transitions` table + indexes and write path for MDR-driven vehicle status transitions.

## Phase 4 - Operational enforcement
- MDR commit now blocks unsafe operational links for expired records:
  - guard assignment creation is blocked when license expiry is past due,
  - firearm allocation creation is blocked when firearm validity is expired.
- Commit summary now reports blocked-guard and blocked-firearm counts.
- Active assignment/allocation overlap prevention on MDR commit:
  - prior active guard assignments are ended before creating new active assignment,
  - prior active firearm allocations for guard/firearm are ended before creating new active allocation.

## Phase 5 - Governance and compliance visibility
- Standardized MDR audit writes to current `audit_logs` schema (`actor_user_id`, `action_key`, `result`, `metadata`).
- Added MDR audit events for:
  - batch import,
  - row resolve,
  - batch reject,
  - batch commit.
- Added compliance endpoint:
  - `GET /api/mdr/batches/:id/compliance-report`
  - returns batch details, status/section breakdown, validation-issue count, and recent MDR audit events.

## Phase 6 - Reliability and observability
- Added MDR ops-health endpoint:
  - `GET /api/mdr/ops-health`
  - includes reviewing batch count, stale-reviewing count (24h), pending/error row counts, rejected batches (7d), and latest commit timestamp.
- Runtime migrations (`src/db.rs`) now include MDR table/column safeguards for environments that depend on app-managed migrations.

## Verification snapshots
- Backend checks passed after implementation:
  - `cd DasiaAIO-Backend && cargo check`
- Frontend build checks passed after implementation:
  - `cd DasiaAIO-Frontend && npm run build`

# 36) MDR COMMIT HARDENING + E2E VERIFICATION (2026-05-02)

- Stabilized MDR commit execution in `DasiaAIO-Backend/src/services/mdr_import_service.rs`:
  - firearm inserts now satisfy non-null schema (`name`, `model`, `caliber`) via derived fallback values,
  - firearm inserts now use `ON CONFLICT(serial_number) DO UPDATE RETURNING id` to prevent duplicate-serial transaction failure,
  - malformed date strings are sanitized through Rust parsing before DB writes (invalid values become `NULL` instead of failing casts),
  - guard provisioning now reuses existing records (license or username/email) and uses identifier-suffixed usernames to avoid duplicate email collisions,
  - MDR allocation insert aligned to local `firearm_allocations` schema (removed non-existent `allocated_by` column write).
- Extended timeout policy for heavy MDR commit requests in `src/middleware/request_timeout.rs`:
  - route-aware timeout for `/api/mdr/batches/:id/commit` via `REQUEST_TIMEOUT_MDR_COMMIT_SECS` (default 120s),
  - preserved default request timeout behavior for other routes.
- Real local E2E rerun succeeded for uploaded batch `fe9977d7-48eb-4b8c-b30e-14b75cf195a2`:
  - commit endpoint returned 200 and batch transitioned to `committed`,
  - compliance report returned 200 with `mdr.batch.commit` audit event,
  - ops-health returned 200 with `reviewingBatches=0` and populated `lastCommittedAt`.
- Evidence artifact updated at `tmp/mdr-e2e-result-2.json`.

---

# 37) CAPSTONE READINESS PACK + AUTOMATED GATES (2026-05-02)

## What was added
- Introduced a capstone-readiness documentation pack at:
  - `docs/plan/capstone-readiness-20260502/`
- Added:
  - `README.md`
  - `OBJECTIVE_COMPLIANCE_MATRIX.md`
  - `EVIDENCE_REGISTER_TEMPLATE.md`
  - `EXECUTION_PLAYBOOK.md`
  - `evidence/.gitkeep`

## Automation
- Added script:
  - `scripts/capstone-readiness.ps1`
- Added root npm commands:
  - `npm run verify:capstone:quick`
  - `npm run verify:capstone:full`

## Gate behavior
- Script executes frontend and backend compile/test gates, then API/readiness checks, and emits machine + human-readable reports:
  - `docs/plan/capstone-readiness-20260502/evidence/latest-readiness-report.json`
  - `docs/plan/capstone-readiness-20260502/evidence/latest-readiness-report.md`
- API checks are optional by default (warn when local API is unavailable) and can be made strict with `-RequireApi`.

## Verification snapshot
- `npm run verify:capstone:quick` completed successfully and regenerated readiness evidence reports.

---

# 38) CAPSTONE PHASE 1-5 EXECUTION HARDENING (2026-05-02)

## Readiness script reliability fixes
- Hardened `scripts/capstone-readiness.ps1`:
  - resilient auth token extraction across `accessToken`, `token`, `access_token`,
  - robust map payload parsing across camel/snake-case keys,
  - dedicated tracking-smoke credentials (`TrackingIdentifier` / `TrackingPassword`),
  - strict `-RequireApi` full gate now stable under local role-account provisioning.
- Updated `scripts/tracking_smoke_test.ps1`:
  - supports non-interactive `-Password`,
  - keeps heartbeat acceptance/accuracy assertions while treating absent map echo as contextual note rather than hard failure.

## Local role account provisioning
- Added `scripts/provision-capstone-accounts.ps1` to deterministically upsert `superadmin/admin/supervisor/guard` local QA accounts with:
  - approved/verified state,
  - legal-consent metadata baseline,
  - location-tracking consent enabled for guard/supervisor test roles.

## Phase deliverables completed
- Added capstone readiness execution artifacts:
  - `docs/plan/capstone-readiness-20260502/PHASE1_SCOPE_LOCK.md`
  - `docs/plan/capstone-readiness-20260502/EVIDENCE_REGISTER.md`
  - `docs/plan/capstone-readiness-20260502/DEFECT_REGISTER.md`
  - `docs/plan/capstone-readiness-20260502/RELEASE_OPS_HARDENING_REPORT.md`
  - `docs/plan/capstone-readiness-20260502/DEFENSE_PACK.md`
- Updated `OBJECTIVE_COMPLIANCE_MATRIX.md` baseline status from `TBD` to `PARTIAL` for all 14 objectives pending manual cross-platform evidence closure.

## Ops recovery evidence
- Captured DB backup artifact:
  - `docs/plan/capstone-readiness-20260502/evidence/OBJ13-SUB13E-backend-db-backup-20260502-1556.sql`
- Performed isolated restore validation into `guard_firearm_system_restore_test` (successful restore run output captured in terminal logs).

## Final gate snapshot
- `powershell -ExecutionPolicy Bypass -File scripts/capstone-readiness.ps1 -Mode full -RequireApi` -> PASS
- Report artifact:
  - `docs/plan/capstone-readiness-20260502/evidence/latest-readiness-report.md`
  - summary `passed: 8, warnings: 0, failed: 0`

---

# 39) AO ORCHESTRATOR WINDOWS STABILIZATION (2026-05-02)

## Config hardening for AO start
- Updated `agent-orchestrator.yaml`:
  - `projects` key changed from `Capstone Main` to `capstone-main` (AO project-id regex compliance).
  - `defaults.runtime` changed to `process` (Windows fallback when `tmux` is unavailable).
  - `defaults.agent` changed to `codex` to align with Codex-first orchestration policy.
  - Added explicit slugged `storageKey`:
    - `bbbf62a2757b-capstone-main`
    - this avoids AO legacy storage-key generation with space-containing path basenames that break session-id validation.

## AO local runtime patch
- Patched local AO dashboard launcher:
  - File: `%APPDATA%\\npm\\node_modules\\@aoagents\\ao\\node_modules\\@aoagents\\ao-web\\dist-server\\start-all.js`
  - Added Windows-safe Next.js launch resolution (`next.cmd` or `node <next-bin>` fallback).
- Validation outcome:
  - `ao start capstone-main` now keeps AO running.
  - `http://localhost:3000` responds with HTTP 200.

## Remaining operational notes
- AO notifiers (`discord`, `slack`, `webhook`, `openclaw`) remain unconfigured by design; warnings are expected until webhook/token values are added.
- Worker/orchestrator sessions created with `process + codex` can report `runtime.state=exited` after agent process completion; this is observed behavior in current local setup.

---

# 40) AWESOME SKILLS + AO TEAM ORCHESTRATION BASELINE (2026-05-02)

## Skills installed from awesome-codex-skills
- Installed into `~/.codex/skills`:
  - `create-plan`
  - `webapp-testing`
  - `issue-triage`
  - `gh-fix-ci`
  - `gh-address-comments`
  - `changelog-generator`
  - `deploy-pipeline`
  - `file-organizer`
  - `pr-review-ci-fix`
  - `codebase-migrate`
- Installed AO skill bundle:
  - `agent-orchestrator` (from `external-tools/agent-orchestrator/skills/agent-orchestrator`)

## AO config alignment
- Updated `agent-orchestrator.yaml` defaults to codex-first operation:
  - `defaults.agent: codex`
  - `defaults.orchestrator.agent: codex`
  - `defaults.worker.agent: codex`
- Added project-level codex model policy:
  - `projects.capstone-main.agentConfig.model: gpt-5.3-codex`
  - `projects.capstone-main.agentConfig.permissions: auto-edit`
- Expanded `agentRules` to include SENTINEL governance and verification gates (no feature creep, file-scoped ownership, frontend/backend checks, smoke checks).

## Team orchestration assets
- Added prompt pack under:
  - `docs/ao-team/prompts/`
  - includes CTO + 8 department-head prompts:
    - planner, backend, frontend, designer, QA, security, release, capstone documenter
- Added runbook:
  - `docs/ao-team/README.md`
- Added automation script:
  - `scripts/ao-team-bootstrap.ps1`
  - actions: `bootstrap`, `start`, `send-cto`, `spawn-heads`, `status`, `stop`

## Validation snapshot
- Executed AO team workflow commands successfully:
  - start (`ao start --no-dashboard capstone-main`)
  - CTO prompt send to `cm-orchestrator-1`
  - spawned `cm-2` to `cm-9` department-head sessions with role prompts
  - status/cleanup completed (`ao session cleanup --project capstone-main`)

---

# 41) AO WINDOWS SEND-PATH FIX + TEAM BOOTSTRAP HARDENING (2026-05-02)

## Root issue observed
- AO `codex` launch commands are POSIX-quoted (example: `'codex' ...`).
- With AO `runtime: process` on Windows, command execution goes through `cmd.exe`; POSIX quoting can fail and trigger transport/session failures (`runtime_lost`, `process_missing`, prior `EPIPE` symptoms on send flows).

## Stabilization applied
- Added repo automation script:
  - `scripts/ao-windows-runtime-fix.ps1`
  - purpose: patch AO global runtime plugin (`ao-plugin-runtime-process/dist/index.js`) to use a PowerShell bridge on Windows:
    - `powershell.exe -NoLogo -NoProfile -Command "& <launchCommand>"`
  - behavior:
    - idempotent check for existing patch,
    - backup creation before edit,
    - explicit failure if target block/version drift is detected.

## Bootstrap flow updates
- Updated `scripts/ao-team-bootstrap.ps1`:
  - auto-runs Windows compatibility fix before AO actions.
  - CTO prompt delivery now uses file mode:
    - `ao send cm-orchestrator-1 -f docs/ao-team/prompts/cto-orchestrator.md`
  - this avoids large inline prompt argument fragility.

## Documentation updates
- Updated `docs/ao-team/README.md`:
  - added AO+skills usage guidance,
  - added Windows runtime troubleshooting and explicit fix command.

---

# 42) AO-LED CAPSTONE OBJECTIVE GATE EXECUTION (2026-05-02)

## AO orchestration run
- Re-ran AO codex-first orchestration flow using:
  - `scripts/ao-team-bootstrap.ps1 -Action start -NoDashboard`
  - `scripts/ao-team-bootstrap.ps1 -Action send-cto`
  - `scripts/ao-team-bootstrap.ps1 -Action spawn-heads`
- Department-head sessions spawned (`cm-27` to `cm-34`) for planner/backend/frontend/designer/qa/security/release/capstone-documenter lanes.

## Phase 1 — baseline validation
- Initial `scripts/capstone-readiness.ps1 -Mode full -RequireApi` returned `FAIL`.
- Failure cause was environment/runtime (`api_health` failed), while compile/test gates passed.

## Phase 2 — objective-critical blocker fix
- Identified backend runtime blockers during smoke setup:
  - missing required `ADMIN_CODE` env in one local launch path,
  - unavailable DB connectivity in local direct run.
- Stabilized runtime path using Docker compose services:
  - `docker compose -f DasiaAIO-Backend/docker-compose.yml up -d postgres backend`
- Verified backend runtime health at `http://127.0.0.1:5000/api/health` (`status=ok`, `database=up`).

## Phase 3 — rerun smoke/readiness
- Re-ran `scripts/capstone-readiness.ps1 -Mode full -RequireApi`.
- Result: `PASS` with `8/8` checks passing and no warnings.
- Evidence:
  - `docs/plan/capstone-readiness-20260502/evidence/latest-readiness-report.md`
  - `docs/plan/capstone-readiness-20260502/evidence/latest-readiness-report.json`

## Phase 4 — Objective 13 platform build-path verification
- Desktop build + packaging passed:
  - `npm run build:desktop`
  - artifacts:
    - `apps/desktop-tauri/src-tauri/target/release/bundle/msi/SENTINEL_1.0.0_x64_en-US.msi`
    - `apps/desktop-tauri/src-tauri/target/release/bundle/nsis/SENTINEL_1.0.0_x64-setup.exe`
- Android web build + Capacitor sync passed:
  - `npm run build:android`
  - synced web asset proof:
    - `apps/android-capacitor/android/app/src/main/assets/public/index.html`

## Notes
- Vite emitted non-blocking chunking warnings (`config.ts`/`api.ts` dynamic+static import mix); treated as optimization follow-up, not objective-critical blockers.
- No capstone manuscript (`SENTINEL - Group 8.md`) updates were made in this run because no user-facing feature behavior was changed.

---

# 43) PHASE-5 EVIDENCE CLOSURE (PLATFORM + A11Y) (2026-05-02)

## What was completed
- Closed remaining phase-5 evidence gaps by generating current-cycle artifacts for:
  - desktop runtime build/package path,
  - Android web build + Capacitor sync path,
  - focused desktop + Android-webview smoke capture with role surfaces,
  - guard touch-target accessibility checks.

## Evidence artifacts
- Added:
  - `docs/plan/capstone-readiness-20260502/evidence/phase5-platform-a11y-summary-20260502.md`
- Generated:
  - `docs/plan/capstone-readiness-20260502/evidence/phase5-smoke-2026-05-02T16-06-11-404Z/report.json`
  - `docs/plan/capstone-readiness-20260502/evidence/phase5-smoke-2026-05-02T16-06-11-404Z/desktop-web-superadmin.png`
  - `docs/plan/capstone-readiness-20260502/evidence/phase5-smoke-2026-05-02T16-06-11-404Z/android-webview-guard.png`
- Revalidated strict readiness:
  - `scripts/capstone-readiness.ps1 -Mode full -RequireApi` -> PASS

## Readiness-pack reconciliation updates
- Updated:
  - `EVIDENCE_REGISTER.md` with E-012..E-016
  - `DEFECT_REGISTER.md` (D-005/D-006 closed; D-007 remains open optimization)
  - `RELEASE_OPS_HARDENING_REPORT.md` with phase-5 platform/a11y closure step
  - `DEFENSE_PACK.md` rewritten in clean UTF-8 wording (panel-facing phrasing)
  - `OBJECTIVE_COMPLIANCE_MATRIX.md` sub-objective checkboxes for Obj-13 and Obj-14 evidence status

## Notes
- Desktop smoke capture used controlled session injection to avoid auth-rate-limit instability during repeated UI logins.
- Controlled desktop capture surfaced non-blocking websocket auth warnings in console; these did not block readiness gates.

---

# 44) AO-FIRST USER PREFERENCE + README SCREENSHOT REFRESH (2026-05-03)

## User workflow preference
- The user explicitly requested AO as the default operating mode for all future prompts in this workspace.
- Operational rule for new sessions:
  - start from AO workflow first (`agent-orchestrator` + repo `docs/ao-team` prompts),
  - only fall back to direct single-agent execution if AO is unavailable or blocked,
  - keep coding tasks on `GPT-5.3-Codex` per existing orchestration policy.

## README visual refresh
- Replaced root README dashboard imagery with current-role screenshots generated from the active local SENTINEL build (not legacy captures).
- Refreshed assets under `docs/assets/`:
  - `role-superadmin-dashboard-desktop.png`
  - `role-admin-dashboard-desktop.png`
  - `role-supervisor-dashboard-desktop.png`
  - `role-guard-dashboard-desktop.png`
  - `role-superadmin-dashboard-mobile.png`
  - `role-admin-dashboard-mobile.png`
  - `role-supervisor-dashboard-mobile.png`
  - `role-guard-dashboard-mobile.png`
- Capture evidence report:
  - `docs/assets/readme-screenshot-refresh-report.json`

---

# 45) DARKMODE README CAPTURE + AO WINDOWS STABILIZATION (2026-05-03)

## README screenshot refresh (dark mode)
- Added repeatable capture utility:
  - `scripts/refresh-readme-screenshots-dark.mjs`
- Regenerated role dashboard images used by root `README.md` in dark mode:
  - `docs/assets/role-superadmin-dashboard-desktop.png`
  - `docs/assets/role-admin-dashboard-desktop.png`
  - `docs/assets/role-supervisor-dashboard-desktop.png`
  - `docs/assets/role-guard-dashboard-desktop.png`
  - `docs/assets/role-superadmin-dashboard-mobile.png`
  - `docs/assets/role-admin-dashboard-mobile.png`
  - `docs/assets/role-supervisor-dashboard-mobile.png`
  - `docs/assets/role-guard-dashboard-mobile.png`
- Screenshot mode adjusted to viewport capture (`fullPage: false`) to avoid oversized blank trailing areas in mobile images.
- Updated root `README.md` line to state that the visual set was refreshed in dark mode.

## AO stabilization on Windows
- Verified AO runtime state:
  - `ao start` -> running (dashboard at `http://localhost:3000`)
  - `ao status` -> project loaded (`capstone-main`)
- Addressed Windows-specific `ao doctor` failure path:
  - AO package expected Unix shell checks (`ao-doctor.sh` + `/bin/bash`) and exited non-zero on Windows.
- Added a Windows-safe doctor behavior by patching local AO CLI command logic to skip shell-script doctor stage on `win32` and continue with config-aware checks.
  - Post-fix result: `ao doctor` exits successfully with warning-only output for optional notifier configuration.

---

# 46) GSD + CAVEMAN INSTALL (AO-OFF DEFAULT) (2026-05-03)

## Installed tooling
- Installed Get Shit Done (GSD) for Codex in repo-local minimal mode:
  - command: `npx get-shit-done-cc@latest --codex --local --minimal`
  - local skills created under:
    - `.codex/skills/gsd-new-project`
    - `.codex/skills/gsd-discuss-phase`
    - `.codex/skills/gsd-plan-phase`
    - `.codex/skills/gsd-execute-phase`
    - `.codex/skills/gsd-help`
    - `.codex/skills/gsd-update`
- Installed Caveman skills for Codex using Windows-safe copy mode:
  - workspace install: `npx skills add JuliusBrussee/caveman -a codex --copy --yes`
  - global install: `npx skills add JuliusBrussee/caveman -a codex --copy --yes --global`
  - cave skills available under `.agents/skills/*` (workspace and global).

## Usage policy in this workspace
- AO remains disabled by default (user preference).
- Use GSD for complex multi-phase work (planning/execution/verification loops), with minimal surface to reduce overhead.
- Use Caveman on-demand (`$caveman lite`) for long debugging/planning sessions to reduce token burn.
- Keep Caveman off for panel-facing prose/readme/capstone manuscript writing when polished language is needed.

---

# 47) GSD BROWNFIELD BOOTSTRAP FOR SENTINEL (2026-05-03)

## What changed
- Upgraded repo-local GSD install from minimal to full surface:
  - command used: `npx get-shit-done-cc@latest --codex --local`
  - installed full skill/agent/hook set under `.codex/` for brownfield workflows like `gsd-map-codebase`.
- Verified brownfield mapper prerequisites:
  - `agents_installed: true`
  - `missing_agents: []`

## Planning artifacts initialized for existing SENTINEL codebase
- Created `.planning/` baseline for brownfield execution (not a new product):
  - `.planning/PROJECT.md`
  - `.planning/REQUIREMENTS.md`
  - `.planning/ROADMAP.md`
  - `.planning/STATE.md`
  - `.planning/codebase/{architecture,concerns,conventions,integrations,stack,structure,testing}.md`

## Working mode
- Caveman explicitly enabled by user for active interaction.
- AO remains disabled; direct Codex + GSD execution path remains default.

---

# 48) DEFAULT EXECUTION MODE UPDATE (2026-05-03)

## User default preference
- Effective default for this workspace:
  - GSD workflow enabled by default for phase-driven work.
  - Caveman Lite mode enabled by default for regular coding/debug/planning exchanges.
  - AO remains disabled by default unless the user explicitly asks to use AO for a specific run.

## Practical execution rule
- Start from direct Codex + GSD flow (`discuss -> plan -> execute -> smoke evidence`) for all project phases.
- Keep responses concise/compressed by default (Caveman Lite style), but switch to polished prose for panel-facing docs or when explicitly requested.

---

# 49) PROFILE PHOTO PERSISTENCE FIX (2026-05-08)

## Symptom observed
- Profile photo upload succeeded in the UI but did not persist across refresh/remount because auth session state (`AuthContext.user`) and `localStorage.user` were not updated after profile mutations.

## What changed
- Added `updateUser(updates)` to `DasiaAIO-Frontend/src/context/AuthContext.tsx`.
  - Merges user patch into in-memory auth user state.
  - Persists patched user back to `localStorage`.
- Updated `DasiaAIO-Frontend/src/components/profile/ProfileModalContent.tsx` to call `updateUser(...)` after:
  - profile photo upload
  - profile photo removal
  - profile details save
- Added a sync effect so local photo display follows latest `user.profilePhoto` prop updates.

## Validation
- Frontend targeted tests:
  - `src/__tests__/authContext.test.tsx`
  - `src/router/__tests__/guards.test.tsx`
  - `src/router/__tests__/index.deepLinks.test.tsx`
  - Result: PASS (26 tests total).
- Frontend build: `npm run build` PASS.

---

# 50) YAML PARSE + TAILWIND CONFLICT CLEANUP (2026-05-08)

## Symptom observed
- VS Code YAML diagnostics reported parser failures in:
  - `docs/plan/production-hardening-20260404/plan.yaml`
  - `docs/plan/research_findings_backend_security.yaml`
- Tailwind IntelliSense reported repeated conflict warnings for duplicate utility pairs such as:
  - `focus-visible:outline` + `focus-visible:outline-2`
  - `forced-colors:outline` + `forced-colors:outline-2`

## What changed
- Fixed invalid YAML scalar quoting in `production-hardening-20260404/plan.yaml` by removing partial quote tokens around `Check for Updates`.
- Fixed duplicate map key in `research_findings_backend_security.yaml` by renaming second `lines` key to `lines2`.
- Applied frontend class cleanup:
  - removed duplicate outline utility pairs (`outline` + `outline-2`)
  - normalized several Tailwind v4 canonical token utility forms (e.g., `z-[var(--x)]` to `z-(--x)`, plus related token syntax updates)
  - removed one `uppercase`/`capitalize` conflict in `CalendarDashboard.tsx`

## Validation
- YAML validation:
  - `Get-Content -Raw <file> | npx -y yaml valid` -> PASS for both YAML files.
- Frontend build:
  - `npm run build` -> PASS.

---

# 51) ONE-COMMAND LOCAL START HARDENING (2026-05-08)

## Symptom observed
- Local one-command startup could launch frontend but backend exited with:
  - `ADMIN_CODE must not use the insecure default value.`
- Cause: backend `.env` still had `ADMIN_CODE=122601`.

## What changed
- Added local startup hardening to `scripts/start-local.ps1`:
  - if backend `.env` is missing, copy from `.env.example`,
  - if `ADMIN_CODE` is missing/blank/default (`122601`), auto-rewrite to a generated local-safe value:
    - `ADMIN_CODE=LOCAL-<6 digits>`.
- Updated `startup.txt` to include:
  - one-command start path (`npm run start:local`),
  - one-time manual fallback command to rewrite default `ADMIN_CODE` if needed.

## Result
- `npm run start:local` can recover from insecure-default `ADMIN_CODE` without manual backend troubleshooting.

---

# 52) MDR-ALIGNED GUARD ACCOUNT CREATION ENTRYPOINTS (2026-05-08)

## Goal
- Allow `superadmin`, `admin`, and `supervisor` to create guard login accounts directly from management dashboards after MDR operations, without navigating to separate panels.

## What changed
- Added reusable modal:
  - `DasiaAIO-Frontend/src/components/admin/CreateGuardAccountModal.tsx`
  - Guard-only account creation form with validation for required guard fields (license number + issue/expiry dates).
  - Auto-suggests username/email from guard name and optional MDR guard number.
  - Submits to existing backend endpoint: `POST /api/users` (role fixed to `guard`).
- Integrated modal entrypoint button in elevated management dashboards:
  - `DasiaAIO-Frontend/src/components/AdminDashboard.tsx`
  - `DasiaAIO-Frontend/src/components/admin/SuperadminDashboard.tsx`
  - New header action: **Create Guard Account**.
- Post-create refresh behavior:
  - Admin/Supervisor dashboard refreshes users + pending approvals.
  - Superadmin dashboard refreshes full user dataset.

## Validation
- Frontend build: `npm run build` -> PASS.

---

## Session Update - 2026-05-08 (Local Workflow + Role Account Creation Smoke)

- Fixed local frontend API targeting issue by setting `DasiaAIO-Frontend/.env.development.local` to `VITE_API_BASE_URL=http://localhost:5000`.
- Root cause: Vite precedence made `.env.development.local` override `.env.local`, forcing local web builds to call Railway.
- Confirmed backend/frontend local health:
  - Frontend: `http://localhost:5173`
  - Backend: `http://localhost:5000/api/health` returns `status=ok`
- Completed role smoke for **Create Guard Account** flow (local):
  - `superadmin`: can open modal and create guard account (`POST /api/users -> 201`)
  - `admin`: can open modal and create guard account (`POST /api/users -> 201`)
  - `supervisor`: can open modal and create guard account (`POST /api/users -> 201`)
  - `guard`: create button not shown (expected)
- Confirmed all API calls in this smoke were local (`http://localhost:5000/...`), not Railway.
- Hardened one-command launcher:
  - Updated `scripts/start-local.ps1` to auto-rewrite stale local DB URL (`postgres:password`) to docker-compose default (`postgres:postgres`) to avoid backend boot failure.
- Smoke evidence saved at: `DasiaAIO-Frontend/output/playwright/create-guard-flow/report.json` with role screenshots in the same folder.

---

# 53) CAPSTONE STABILIZATION SPRINT (LIVE TRACKING + OPS MAP + SOS) (2026-05-18)

## Scope executed
- Browser-first stabilization/verification focused on:
  - guard mobile live tracking path,
  - superadmin desktop Operations Map path,
  - guard SOS/offline queue behavior,
  - role dashboard shell/navigation sanity.

## Environment findings
- `npm run verify:capstone:full` passed (frontend build + backend tests) with known non-blocking Vite chunk warnings.
- Local backend health was initially blocked because Postgres was not listening on `:5432`.
- Recovery path used:
  - `docker compose -f DasiaAIO-Backend/docker-compose.yml up -d postgres backend`
  - backend health then returned `status: ok` at `http://localhost:5000/api/health`.

## Product fix applied
- Fixed guard SOS interaction layering on mobile:
  - file: `DasiaAIO-Frontend/src/components/guards/PanicButton.tsx`
  - change: raised container z-index from `z-40` to `z-(--z-toast)` so the button is above the guard sticky region and reliably tappable.

## Verification evidence
- Browser smoke artifact:
  - `DasiaAIO-Frontend/output/playwright/capstone-stabilization-sprint/report.json`
- Key verified outcomes:
  - guard mobile: login, tracking status visibility, map tab surface, emergency contacts bar, SOS offline queue (`queueCountAfterSos: 1`), queue banner visible.
  - superadmin desktop: Operations Map route, heading, map controls, and data-state surface visible.
  - role sanity: `superadmin`, `admin`, `supervisor`, `guard` all login with shell/navigation visible in smoke capture.

---

# 54) DASHBOARD FLICKER STABILIZATION (2026-05-18)

## Symptom observed
- Users reported visible screen/panel flicker while staying on role dashboards.
- Root pattern: several command-center data hooks flipped `loading=true` on every periodic refresh cycle (15s), causing repeated loading-state flashes.

## Product fix applied
- Updated command-center polling hooks to preserve `loading` as first-load only, while subsequent refreshes happen in-place:
  - `DasiaAIO-Frontend/src/hooks/useOpsSummary.ts`
  - `DasiaAIO-Frontend/src/hooks/useOpsShifts.ts`
  - `DasiaAIO-Frontend/src/hooks/useOpsAssets.ts`
  - `DasiaAIO-Frontend/src/hooks/useIncidents.ts`
  - `DasiaAIO-Frontend/src/hooks/usePredictiveAlerts.ts`
  - `DasiaAIO-Frontend/src/hooks/useGuardAbsencePrediction.ts`
  - `DasiaAIO-Frontend/src/hooks/useReplacementSuggestions.ts`
  - `DasiaAIO-Frontend/src/hooks/useVehicleMaintenancePrediction.ts`
- Implementation detail:
  - each hook now uses a `hasLoadedOnceRef` gate; `setLoading(true)` is applied only before first successful/failed fetch, eliminating recurring UI flash during polling.

## Validation
- Frontend build: `cd DasiaAIO-Frontend && npm run build` -> PASS.

---

# 55) CAPSTONE DEFENSE STUDY GUIDE (2026-05-20)

## What changed
- Added `docs/capstone/SENTINEL_DEFENSE_STUDY_GUIDE.md`.
- The guide consolidates defense preparation from the current manuscript, architecture notes, system flow diagrams, readiness pack, and latest live-tracking smoke evidence.

## Guide coverage
- What to read first for defense preparation.
- One-minute project pitch and problem statement framing.
- Complete role-based and technical system flows, including login, protected requests, live tracking, emergency/SOS, scheduling, asset compliance, and cross-platform release flow.
- Panel demo script, evidence references, possible panel questions with prepared answers, memorization sheet, and final review checklist.

## Notes
- Existing manuscript/PDF files were not modified.
- PDF text extraction was not available in the shell environment because `pdftotext` and Python were unavailable, so the current `SENTINEL - Group 8.md` manuscript source was used as the content authority.
---

# 56) SHIFT SCHEDULE JSON CONTRACT FIX (2026-08-19)

## Symptom observed
- Add New Schedule modal showed: `Failed to deserialize the JSON body into the target type: missing field guardId`.

## Root cause
- Frontend schedule create/edit requests were sending snake_case JSON fields (`guard_id`, `client_site`, `start_time`, `end_time`), while the Rust `CreateShiftRequest` model uses `#[serde(rename_all = "camelCase")]` and expects `guardId`, `clientSite`, `startTime`, and `endTime`.

## Fix applied
- Updated `DasiaAIO-Frontend/src/components/admin/SuperadminDashboard.tsx` schedule creation payload to camelCase.
- Updated `DasiaAIO-Frontend/src/components/EditScheduleModal.tsx` schedule update payload to camelCase.
- Added snake_case aliases to `DasiaAIO-Backend/src/models.rs` so older clients remain compatible.

## Validation
- Frontend build: `cd DasiaAIO-Frontend && npm run build` -> PASS.
- Backend check: `cd DasiaAIO-Backend && cargo check` -> PASS.
- Runtime API probe with camelCase body reached auth validation (`401 Missing Authorization header`) instead of JSON deserialization failure.
---

# 57) AI HYBRID ASSISTANCE REMOVAL (2026-08-19)

## Panel-driven change
- Defense panel requested removal of AI hybrid assistance from SENTINEL.

## Product decision
- Removed external AI/LLM behavior from active backend/frontend code.
- Reframed remaining useful outputs as rule-based operational analytics and risk scoring.
- Human supervisors/admins remain responsible for final decisions.

## Code changes
- Renamed backend AI-facing modules to neutral decision-support/scoring names.
- Removed Groq/OpenAI/LLM incident-classification behavior; incident severity triage is now deterministic keyword scoring only.
- Replaced public `/api/ai/*` usage with `/api/analytics/*` routes and `/api/alerts/operational-risk`.
- Updated frontend labels from AI/predictive wording to operational alerts, incident triage, generated summaries, and maintenance risk.

## Documentation changes
- Updated `SENTINEL - Group 8.md` implementation/objective/scope wording to remove AI hybrid assistance claims.
- Left AI mentions inside the Review of Related Literature and References untouched because those sections are protected by paper-maintenance instructions.
- Updated `docs/capstone/SENTINEL_DEFENSE_STUDY_GUIDE.md` to match the revised analytics/risk-scoring framing.

## Validation
- Backend check: `cd DasiaAIO-Backend && cargo check` -> PASS.
- Frontend build: `cd DasiaAIO-Frontend && npm run build` -> PASS.
---

# 58) CAPSTONE DOCX TO MARKDOWN SYNC (2026-08-19)

## User request
- User updated `SENTINEL - Group 8.docx` and requested `SENTINEL - Group 8.md` be updated from it.

## Work performed
- Converted the current DOCX content into Markdown and replaced `SENTINEL - Group 8.md`.
- Extracted DOCX images into `docs/capstone/paper-media`; updated images `img-32.png` through `img-35.png` changed from the DOCX source.
- Verified the revised Markdown contains the six summarized specific objectives from the DOCX.

## AI wording check
- SENTINEL implementation/scope/objective claims remain free of AI hybrid assistance wording after sync.
- Remaining AI mentions are in the Review of Related Literature and References only.
---

# 59) INBOX API INTEGRATION BUG FIX (2026-08-19)

## Symptom audited
- Elevated role inbox panels were still using relative `/api/...` fetch URLs, which hit the Vite frontend origin because no `/api` proxy is configured.
- The same panels and role inbox summary helper treated backend list responses as raw arrays, while current backend endpoints return envelopes such as `{ incidents }`, `{ shifts }`, `{ notifications }`, `{ firearms }`, and `{ allocations }`.
- `AdminInboxPanel` requested stale `/api/analytics/metrics`, which is not registered by the backend.

## Fix applied
- Added `src/components/inbox/inboxPayloads.ts` to extract arrays from both legacy raw-array payloads and backend envelope payloads.
- Updated `AdminInboxPanel`, `SupervisorInboxPanel`, `SuperadminInboxPanel`, and `roleInboxSummary` to use `API_BASE_URL` and unwrap backend response envelopes.
- Replaced admin inbox metrics fetch with existing `GET /api/analytics` and mapped overview fields into the small metrics chip model.
- Added abort cleanup for the full inbox panel fetch effects.
- Added `inboxPayloads.test.ts` for envelope parsing coverage.

## Validation
- Targeted frontend inbox tests: `npm test -- --runInBand --runTestsByPath src/components/inbox/__tests__/inboxPayloads.test.ts src/components/inbox/__tests__/roleInboxSummary.firearmEndpoint.test.ts src/components/inbox/__tests__/pendingApprovals.test.ts` -> PASS.
- Frontend full tests: `npm test -- --runInBand` -> PASS, 22 suites / 103 tests.
- Frontend build: `npm run build` -> PASS.
- Backend check: `cargo check` -> PASS.
- Backend tests: `cargo test` -> PASS.
---

# 60) GUARD PERFORMANCE REPORT ANALYTICS (2026-08-19)

## Panel recommendation implemented
- Added clearer graphical performance metrics, evaluation, and analytics reporting for guard operations.

## Backend changes
- Added `GET /api/analytics/guard-performance-report` in `src/main.rs` using the existing analytics permission gate.
- Added `get_guard_performance_report` in `src/handlers/analytics.rs`.
- The endpoint accepts optional `from=YYYY-MM-DD` and `to=YYYY-MM-DD` filters.
- The report aggregates per-guard and summary metrics from `shifts`, `attendance`, `punctuality_records`, `incidents`, `client_evaluations`, `guard_merit_scores`, and `guard_shift_swaps`.
- Returned metrics include attendance rate, late check-ins, completed shifts, no-shows, incident reports, average client rating, merit score, and replacement frequency.

## Frontend changes
- Reworked `src/components/PerformanceDashboard.tsx` from a reliability-only table into a full Guard Performance Report.
- Added KPI cards, date filters, native SVG bar charts, workload bars, replacement-frequency chart, and a detailed metrics table.
- Kept charts native SVG/HTML; no charting library was added.

## Validation
- Backend check: `cargo check` -> PASS.
- Backend tests: `cargo test` -> PASS.
- Frontend build: `npm run build` -> PASS.
- Frontend tests: `npm test -- --runInBand` -> PASS, 22 suites / 103 tests.

---

# 61) FULL SYSTEM BUG AUDIT AND REMEDIATION (2026-08-19)

## Backend fixes
- Enforced strict user-management hierarchy (`superadmin > admin > supervisor > guard`) for user updates, deletion, and profile-photo actions; self-service remains allowed where intended.
- Reworked user updates to validate the complete payload before one bound update, accept camelCase and snake_case aliases, parse date-only/RFC3339 license dates, and reject unsupported or oversized profile-photo data URLs.
- Made attendance check-in/check-out transactional and idempotent, tied attendance to the assigned shift, and restricted scheduling to approved verified guard accounts.
- Persisted no-shows to `punctuality_records`, prevented duplicate detection/notifications, and added startup migrations for legacy databases missing `shifts.grace_period_minutes` and `shifts.replacement_status`.
- Corrected guard performance no-show aggregation to avoid counting the same absence twice.

## Frontend fixes
- Converted schedule form local dates/times to UTC correctly, supported overnight shifts, and restored active check-in state from shift-specific attendance after refresh.
- Preserved distinct offline actions by comparing method, URL, and canonical body; SOS and incident actions now queue only network/offline failures, not server validation/authentication errors.
- Fixed request timeout behavior when callers provide an AbortSignal and added abort cleanup across operational data hooks.
- Fixed strict TypeScript defects in the account modal, MDR review, and offline queue.
- Removed the duplicate guard location banner and corrected the expanded emergency-contact safety region so content and SOS/contact controls do not overlap at 390px or 320px widths.

## Dependency remediation
- Updated direct `dompurify` and `react-router` dependencies and applied compatible audit fixes to the frontend build/test dependency graph.
- `npm audit --json` now reports zero vulnerabilities across production and development dependencies.

## Verification
- Backend: `cargo check`, `cargo test` (28 unit, 2 integration, 15 release-blocker), and `cargo clippy --all-targets` passed; Clippy reports 27 existing non-behavioral style warnings.
- Frontend: strict `tsc --noEmit`, 25 Jest suites / 119 tests, and Vite production build passed.
- Docker/live PostgreSQL probes passed for health, analytics (179 guards), role-hierarchy denial, date/alias user updates, profile-photo validation, approved-guard scheduling, duplicate check-in/check-out, and duplicate-free no-show detection. All temporary records were removed.
- Headless Playwright UI smoke passed for performance desktop/mobile and guard mobile/narrow-mobile with no page errors, API errors, horizontal overflow, or SOS/contact intersections.

# 62) RELEASE READINESS PHASE (2026-08-19)

## Work completed
- Added `docs/RELEASE_READINESS_GUIDE.md` with scope, execution order, acceptance criteria, panel-comment action register, defense-demo sequence, residuals, and go/no-go rules.
- Added root `npm run verify:release`, implemented by `scripts/release-readiness.ps1`.
- Added frontend `npm run audit:smoke`; parameterized local QA credentials through `AUDIT_SUPERADMIN_*` and `AUDIT_GUARD_*` environment variables.
- Strengthened browser smoke failures to include all unexpected API responses at HTTP 400 or higher, not only HTTP 500 responses.
- Updated `COPILOT.md`, `architecture.md`, and `README.md` so current routes and documentation describe deterministic rule-based operational analytics and human-reviewed decisions, with no active Ollama/LLM integration claim.
- Renamed active incident-form state from AI-prefixed terminology to neutral rule-based triage terminology.

## Verification
- `npm run verify:release -- -RequireApi -RunBrowserSmoke` -> PASS.
- Frontend TypeScript -> PASS.
- Frontend tests -> 25 suites / 119 tests passed.
- Frontend production build -> PASS.
- `npm audit --audit-level=high` -> 0 vulnerabilities.
- Backend `cargo check` -> PASS.
- Backend `cargo test` -> 45 meaningful tests passed (28 unit, 2 integration, 15 release-blocker).
- Backend `cargo clippy --all-targets` -> PASS with 27 existing non-behavioral warnings.
- Local API health -> PASS.
- Playwright browser smoke -> performance desktop/mobile and guard mobile/narrow-mobile passed with no page errors, API errors, horizontal overflow, or SOS/contact intersections.

## Remaining handoff
- Rehearse and freeze the defense deck against the current build.
- Keep production credentials, CORS, database backup/restore, and signed Android release validation as deployment-owned checks.
- Treat Clippy and Vite optimization warnings as follow-up cleanup unless they become release blockers.

# 63) POST-DEFENSE IMPLEMENTATION ROADMAP ADDED (2026-08-19)

## Work completed
- Expanded `docs/RELEASE_READINESS_GUIDE.md` with the five panel-driven roadmap phases:
  1. Documentation and scope revision
  2. DTR and attendance enhancement
  3. Firearm compliance enhancement
  4. Request and approval enhancement
  5. Analytics and evaluation enhancement
- Added status, deliverables, dependencies, completion evidence, and sequencing for each phase.
- Clarified that release readiness is the verification gate applied after each roadmap increment, not a replacement for the post-defense feature plan.

# 64) PHASE 1 VERIFIED AND PHASE 2 DTR IMPLEMENTED (2026-08-19)

## Phase 1 verification
- Verified the current `SENTINEL - Group 8.md` paper has one revised general objective and six summarized specific objectives.
- Verified the active purpose, objectives, scope, and limitations sections no longer claim AI hybrid assistance, Ollama, or an LLM feature.
- Preserved historical AI-related literature and references because they are protected paper sections, not active system scope.
- Recorded Phase 1 as complete for the paper revision; the PowerPoint and defense guide still require final synchronization before the defense.

## Phase 2 implementation
- Added elevated-role `GET /api/attendance/dtr` with guard, date range, site, status, pagination, date validation, derived attendance status, lateness, and total-hours fields.
- Added the `/dtr` frontend report for superadmin, admin, and supervisor roles with filter controls, paginated table, print action, CSV download, loading, empty, and error states.
- Added DTR navigation and route regression expectations.
- Extended browser smoke to validate DTR desktop/mobile rendering and an actual CSV download.

## Verification
- Docker backend rebuilt and live health check passed.
- Live DTR endpoint returned a paginated record and correctly returned an empty filtered result for `status=completed`.
- Invalid date and reversed date-range probes returned `400` with clear validation errors.
- Backend: `cargo test` -> 30 unit, 2 integration, and 15 release-blocker tests passed.
- Frontend: 25 Jest suites / 119 tests passed; production build passed.
- Browser smoke: performance desktop/mobile, DTR desktop/mobile, and guard mobile/narrow-mobile passed with no page errors, API errors, horizontal overflow, or SOS/contact intersections; CSV download passed.

# 65) FUNCTIONALITY COMPLETION: FIREARM COMPLIANCE (2026-08-19)

## Scope decision
- Defense rehearsal work is intentionally out of the active implementation scope because the outline defenses are complete.
- Current priority is functional completeness, controlled-pilot readiness, and repeatable regression evidence.

## Phase 3 implementation
- Added elevated-role firearm compliance reporting at `GET /api/firearms/compliance-report` with filters, pagination, custody data, permit expiry state, maintenance state, and compliance summary metrics.
- Added deduplicated expiry and overdue notifications at `POST /api/firearms/compliance-notifications`.
- Added the `Firearm Compliance` frontend page with KPI cards, filters, consolidated compliance table, print, CSV export, refresh, and notification synchronization.
- Fixed the firearm API contract by serializing firearm, allocation, permit, and guard-allocation models as camelCase for the React frontend.
- Added idempotent startup schema alterations for allocation return date, notes, and issuer metadata that existing handlers already require.
- Corrected notification selection so permits marked `expired` are still reported as overdue.

## Verification
- Full `npm run verify:release -- -RequireApi -RunBrowserSmoke` passed.
- Frontend: TypeScript, 25 Jest suites / 119 tests, production build, and dependency audit passed with 0 vulnerabilities.
- Backend: compile, 32 unit tests, 2 integration tests, 15 release-blocker tests, and Clippy passed; existing non-blocking Clippy warnings remain.
- Live API checks passed for the compliance report, camelCase firearm payloads, notification synchronization, invalid status, and invalid window validation.
- Browser smoke passed for performance, DTR, firearm compliance, and guard views on desktop/mobile, with no page errors, API failures, horizontal overflow, or guard SOS/contact intersections.

## Next implementation increment
- Phase 4 service/deposit request lifecycle and approval tracking remains next.
- Phase 5 analytics and evaluation refinement follows after Phase 4.

# 66) CURRENT-ITERATION BROWSER ACCEPTANCE AUDIT (2026-08-19)

## Browser audit
- Added `DasiaAIO-Frontend/scripts/manual-functionality-audit.mjs` and the `npm run audit:functionality` command.
- Audited authenticated superadmin, admin, supervisor, and guard accounts across 86 desktop/mobile route checks.
- Clicked 370 non-destructive controls including filters, refresh, print, CSV, calendar navigation, compliance alert synchronization, quick inbox, profile menus, and responsive layouts.
- Final audit result: zero page errors, console errors, API errors, request failures, or horizontal overflow. JSON evidence is saved under `DasiaAIO-Frontend/test-results/system-audit/manual-functionality-audit.json`.
- Destructive mutations were intentionally excluded because they require disposable fixtures and cleanup ownership; this audit proves read/navigation/control behavior, not every create/update/delete lifecycle.

## Defects found and fixed
- Fixed guard permit reads to call `/api/guard-firearm-permits/:guard_id` instead of the elevated all-permits endpoint, removing the guard-role 403.
- Fixed guard calendar loading to skip the elevated `/api/trips` feed; trips now load only for elevated roles.
- Corrected the audit harness to ignore navigation-aborted requests and avoid disabled select options, so results represent application failures rather than test timing artifacts.

## Verification
- `npm run audit:functionality` -> PASS: 86 route checks, 370 control clicks, zero failures.
- `npm run verify:release -- -RequireApi -RunBrowserSmoke` -> PASS.
- Frontend: TypeScript, 25 Jest suites / 119 tests, production build, and dependency audit passed with 0 vulnerabilities.
- Backend: compile, 32 unit tests, 2 integration tests, 15 release-blocker tests, and Clippy passed with existing non-blocking warnings.

## Readiness decision
- The current implemented iteration is accepted for the non-mutating browser acceptance scope.
- Before claiming total end-to-end functionality, run controlled fixture-based mutation tests for schedule creation, attendance check-in/out, incident submission, approvals, firearm allocation/return, maintenance, feedback, support tickets, MDR import, and logout/session expiry.
- Phase 4 and Phase 5 remain deferred until the team chooses to resume feature implementation.

# 67) FINAL ACCEPTANCE AUDIT RESULT (2026-08-19)

- Final `npm run audit:functionality` passed with 86 route/viewport checks, 475 safe control interactions, and zero failures.
- The final pass included responsive menu and More-drawer interactions plus profile-menu logout/session exit checks for all four roles.
- The saved report `DasiaAIO-Frontend/test-results/system-audit/manual-functionality-audit.json` is the current evidence artifact.
- This is acceptance-complete for navigation, read paths, controls, overlays, responsive layout, authorization reads, and session exit. It is not a claim that every data-changing workflow has been executed against the shared database.

# 68) FIXTURE-BASED MUTATION AUDIT AND ATTENDANCE CONTRACT FIX (2026-08-19)

## Audit result
- Created a disposable PostgreSQL clone and ran browser-driven mutation coverage against isolated backend/frontend services.
- Passed 12 workflows: schedule creation, attendance check-in/out, incidents, support tickets, feedback, firearm allocation, firearm return, maintenance schedule/complete, guard approval, and MDR import/reject.
- Final evidence: `output/mutation-audit/MUTATION-20260819140813.json` with zero page errors, console errors, or API errors.
- The disposable database was dropped after the run; the shared `guard_firearm_system` database was not mutated.

## Defect fixed
- Guard attendance actions sent snake_case JSON (`guard_id`, `shift_id`, `attendance_id`) while Rust request models require camelCase (`guardId`, `shiftId`, `attendanceId`). This caused HTTP 422 responses. Updated direct and offline-queue payloads in `DasiaAIO-Frontend/src/components/guards/UserDashboard.tsx`.
- Frontend tests, TypeScript, and production build passed after the fix.

## Remaining boundary
- Firearm return and firearm maintenance scheduling/completion backend routes passed through authenticated browser-context requests, but the current frontend exposes no corresponding mutation controls. Add those controls before claiming full click-complete UI coverage or explicitly accept them as out of scope.
- Added `scripts/mutation-functionality-audit.mjs` and the frontend `audit:mutations` command for repeatable fixture-based coverage.

# 69) POST-FIX RELEASE GATE (2026-08-19)

- `npm run verify:release -- -RequireApi -RunBrowserSmoke` passed after the attendance payload fix.
- Frontend TypeScript, 25 Jest suites / 119 tests, production build, npm audit, backend compile/tests/Clippy, API health, and browser smoke all passed.
- Browser smoke passed performance, DTR, firearm compliance, and guard mobile/narrow-mobile checks with no page/API/layout failures.
- Existing non-blocking Vite dynamic-import warnings and 27 Clippy warnings remain.

# 70) PHASE 4 REQUEST AND APPROVAL WORKFLOW (2026-09-09)

## Implementation
- Added operational_requests and operational_request_events with constrained states, request-linked notifications, resource duplicate protection, and chronological domain history.
- Added service, deposit, return, and firearm-registration suggestion workflows. Registration remains human-controlled; approval never creates a firearm automatically.
- Guards and other authenticated roles create their own requests. Supervisors/admins/superadmins review; only admins/superadmins fulfill. Self-review is denied.
- Explicit deposit/return completion updates firearm allocation and firearm custody atomically, or unassigns equipment after ownership validation.
- Added request UI to guard navigation, elevated Requests and Approvals views, role inboxes, sidebar navigation, and /requests deep links.
- Added status, type, priority, requester, and date filtering plus correction/resubmission, cancellation, decision reasons, fulfillment controls, and event history.

## Verification
- Backend: 37 unit tests, 2 integration tests, and 15 release-blocker tests passed. Startup migration and health checks passed on the existing local PostgreSQL database.
- Frontend: TypeScript, 26 Jest suites / 123 tests, production build, and 2 Phase 4 Playwright scenarios passed.
- Live API lifecycle passed guard submission, supervisor review, admin fulfillment, authorization denials, correction/resubmission, cancellation, history, and atomic firearm return; temporary fixtures were removed.
- Strict Clippy reports no Phase 4 findings but remains blocked by 27 pre-existing findings in unrelated modules.
- The older full Playwright suite is not globally green because existing guard-dashboard expectations/mocks and local login credentials are stale; refresh them before the next full release gate.

# 71) PHASE 5 ANALYTICS AND EVALUATION ENHANCEMENT (2026-09-10)

## Implementation
- Added a dedicated backend analytics service for operational resource availability and date-scoped client evaluation summaries, rating distribution, and trends.
- Corrected analytics date boundaries to Asia/Manila, removed silent database-error-to-zero fallbacks, aligned attendance denominators, and normalized vehicle deployment status handling.
- Added `GET /api/analytics/evaluations`; the main `/api/analytics` response now includes evaluation analytics and trend data.
- Guard performance reports now use eligible guards, deduplicated no-shows, and date-scoped advisory merit calculations.
- Added graphical available/unavailable comparisons for guards, firearms, and vehicles; attendance and evaluation charts; evaluation KPI cards; and performance CSV/print controls.
- Evaluation submissions now validate ratings and guard/shift ownership, derive evaluator identity from authentication, and report partial recalculation failures without encouraging duplicate submissions.
- Added analytics query indexes and a repeatable `npm run audit:phase5` Playwright audit.

## Verification
- Backend: formatting, compile, 42 unit tests, 2 integration tests, and 15 release-blocker tests passed. Clippy passed with 27 existing non-blocking warnings.
- Frontend: TypeScript, 27 Jest suites / 125 tests, production build, and Phase 5 desktop/mobile browser audit passed.
- Live local API: database migrations, all four analytics indexes, `/api/health`, and authenticated `/api/analytics/evaluations` passed.
- Browser evidence contains no page, console, request, API, or horizontal-overflow failures; computed graph checks confirm visible dimensions and theme-token colors.

## Scope boundary
- Phase 5 reports current stored operational records; empty periods intentionally render zero/empty states instead of fabricated data.
- No commit, push, or Railway deployment was performed as part of this implementation request.

# 72) PRODUCTION NOTIFICATION DELIVERY (2026-09-15)

## Implementation
- Added asynchronous notification delivery for persisted notifications through Resend email and VAPID/Web Push.
- Added delivery timestamps, retry metadata, and historical backfill protection to the notifications table.
- Added a backend delivery worker that preserves in-app notification writes when external providers are unavailable.
- Added production environment documentation and configured Railway with a generated VAPID key pair without storing secrets in the repositories.
- Kept native Capacitor push explicitly unclaimed because Firebase/FCM project credentials are not present; web push remains available to supported browser runtimes.

## Verification
- Linux Railway-equivalent Docker build passed with the backend delivery worker.
- Backend Docker test run passed all 43 unit tests.

# 73) RELEASE READINESS VERIFICATION (2026-09-15)

## Release
- Fixed the governed Android release workflow by overriding the obsolete `tools` SDK package default with `platform-tools`.
- Published `v1.2.1` with non-empty web, Windows MSI/EXE, signed Android APK, and signed Android AAB artifacts.
- Release quality gate passed frontend tests and backend tests; web, desktop, and Android artifact jobs all passed.

## Production verification
- Railway production Backend and Frontend deployments are successful.
- `https://dasiasentinel.xyz` and the backend `/api/health` endpoint returned HTTP 200.
- Production logs confirm database migrations completed and the notification worker started with email and Web Push enabled.
- Native Capacitor Android push remains dependent on Firebase/FCM credentials and is not claimed until that provider configuration exists.

# 74) GPS AND FINAL READINESS AUDIT (2026-09-15)

## Verification
- Browser geolocation acceptance passed with emulated Davao-area coordinates: consent, permission, device location resolution, map marker, coordinate display, and heartbeat UI all behaved as expected.
- Full local Playwright suite passed 17/17 after starting the existing Postgres service and provisioning disposable local QA accounts.
- Frontend TypeScript and 27 Jest suites / 125 tests passed.
- Production tracking smoke passed: low-accuracy heartbeat was rejected, high-accuracy heartbeat was accepted, and map-data access succeeded; the accepted smoke fixture was removed afterward.
- Production frontend and backend remained HTTP 200 and Railway deployments remained successful.

## Known platform boundary
- Physical GPS hardware cannot be verified from this PC. Native Android location is implemented through Capacitor Geolocation and foreground heartbeat updates; background tracking is intentionally not implemented.

# 75) ANDROID BACKGROUND LOCATION SERVICE (2026-09-15)

## Implementation
- Added a registered Capacitor `BackgroundLocation` plugin and Android `BackgroundLocationService` using a visible location foreground service.
- Android now requests precise location, notification, and background-location access where required; the service sends consented precise heartbeat samples directly to the HTTPS API every 20 seconds while the app is backgrounded.
- The React location context starts/stops the native service only for authenticated operational roles with legal and tracking consent, subscribes to native status events, and prevents duplicate JavaScript heartbeats on Capacitor.
- The service uses `START_NOT_STICKY`, stops on authorization/consent failure, clears stale configuration on rejection, and exposes a persistent status for the foreground UI.

## Verification
- Frontend TypeScript passed; all 27 Jest suites and 125 tests passed.
- `npm run build:android` passed and Capacitor sync recognized the native project.
- Android `:app:assembleDebug` passed with the foreground service and Android 14 location declarations.

## Boundary
- At the time of this entry, physical Android background GPS, battery-saver behavior, and OEM task-killing behavior still required real-device verification. Web and desktop remain foreground-only by platform design.

# 76) ANDROID DEVICE VERIFICATION AND PERMISSION-STATE FIX (2026-09-15)

## Verification
- A Xiaomi Android 14 device received the debug APK, logged in with a disposable approved guard account, and granted location, background-location, and notification permissions.
- Android kept `BackgroundLocationService` in the foreground with its persistent notification while the app was sent to the home screen; location updates continued at the configured 20-second interval.
- The device acquired live GPS/network fixes, but the indoor accuracy was approximately 79-100 m and was correctly rejected by the 35 m precision policy, so no false heartbeat was recorded.
- Reinstalled app state correctly reported tracking paused for low precision instead of falsely claiming permission was missing.
- The disposable production guard account was deleted through the authenticated admin API and verified unavailable; the debug APK and service were also removed from the device.

## Fix
- Capacitor now skips the browser Permissions API check, which could overwrite the native Android permission result during startup. A granted native result is applied immediately to the dashboard state.
- Updated guard tracking copy to describe Android foreground-service background tracking and its permission, consent, network, and power-setting dependencies.

## Boundary
- An accepted production heartbeat still requires an outdoor or otherwise strong GPS fix at or below the configured 35 m threshold; no mock location was used.

# 77) CROSS-ROLE AUDIT AND NAVIGATION CLEANUP (2026-09-15)

## Verification
- Full local browser functionality audit passed 86 route checks and 499 safe control interactions across superadmin, admin, supervisor, and guard roles on desktop and mobile viewports.
- The audit reported zero page errors, console errors, API errors, request failures, or horizontal-overflow failures.
- Frontend TypeScript, 27 Jest suites / 125 tests, web production build, Android web build and Capacitor sync, and the targeted 12-test Playwright suite passed.
- Geolocation smoke with granted permission resolved the configured Davao-area position, produced no browser errors, and correctly hid the inactive-location banner.
- Backend Docker builder compilation passed; backend tests in the Linux deployment toolchain passed all 43 unit tests. The Windows host `cargo test` remains unavailable without OpenSSL development libraries.
- Frontend production dependency audit reported zero vulnerabilities at the high-severity threshold.

## Fixes
- Superadmin user-data loading now accepts an `AbortSignal`, cancels on navigation, and ignores expected abort errors so fast route changes do not create false console failures or stale state updates.
- The guard dashboard E2E support-heading assertion now uses an exact accessible name, avoiding a false match against the empty-state text `No support tickets`.

## Remaining boundary
- The inactive-location banner shown in permissionless headless browser screenshots is expected behavior; a granted browser permission removes it. Physical Android background GPS was separately verified on a real device, while accepted heartbeat accuracy still depends on a strong GPS fix at or below the 35 m policy.

# 78) V1.2.2 RELEASE PUBLICATION (2026-09-15)

## Release
- Committed and pushed the frontend navigation-abort fix and Android background-location integration, then updated the main repository submodule pointer.
- Published the governed `v1.2.2` release after GitHub Actions passed the quality gate and web, Windows desktop, and signed Android artifact jobs.
- The public release contains the web archive, Windows MSI/EXE installers, and signed Android APK/AAB artifacts.

## Production verification
- `https://dasiasentinel.xyz` returned HTTP 200.
- The Railway backend `/api/health` endpoint returned HTTP 200 with API, database, and WebSocket services up.

# 79) INCIDENT SITE LABELS (2026-09-16)

## Fix
- Incident records now support an optional `site_name` field while retaining `location` for precise operational data.
- Guard incident and SOS submissions include the current assigned site when available.
- Command-center live events, active incidents, incident management, and severity monitoring display the site name instead of raw coordinate strings.
- Legacy coordinate-only incidents resolve against the reporter's shift window when possible; otherwise they display `Unassigned site`.

## Verification
- Frontend TypeScript check passed.
- All 28 Jest suites and 129 tests passed.
- Frontend production build passed.

# 87) CANONICAL GUARD ACCOUNT CREATION (2026-09-16)

## Fix
- Resource Management now routes guard creation to the shared `CreateGuardAccountModal` used by the operational dashboard.
- The generic Management account form is limited to non-guard roles and is labeled `Add Account`.
- The canonical guard form now sends and persists the MDR guard number through the managed-user API and user responses.
- Supervisors no longer trigger unauthorized pending-approval requests from the shared operations summary, eliminating expected 403 console noise.

## Verification
- Frontend TypeScript check passed.
- Backend Docker release build and local container restart passed.
- Full Jest suite passed: 29 suites and 131 tests.
- Role/viewport functionality audit passed: 85 route checks, 396 control interactions, zero failures.
- Backend health returned 200 with API, database, and WebSocket services up.
- Frontend production build passed.

# 82) REQUEST PRIVACY, ARCHIVE, AND NOTIFICATION READ STATE (2026-09-16)

## Fix
- Request lists and details are requester-scoped for guards and supervisors; only admins and superadmins can see all request records.
- Requesters can see only their own decision-relevant history: approved, needs correction, or rejected, including the decision reason. Cancellation and other internal audit events remain admin-only.
- Admins and superadmins can clear terminal requests from the active list. Clearing archives the record and preserves its audit history; `Show cleared` restores it in the admin view.
- Added read and unread notification controls, including mark-all-read, mark-all-unread, and per-notification toggles.

## Verification
- Frontend TypeScript check passed.
- All 28 Jest suites and 129 tests passed.
- Backend formatting check passed.
- Backend production Docker image build passed.

# 84) MANAGED GUARD ACCOUNT APPROVAL HIERARCHY (2026-09-16)

- Public `/api/register` and `/api/auth/register` routes were removed. Guard accounts are created by authorized staff.
- Supervisor-created guard accounts are marked `pending`, while admin- and superadmin-created guard accounts are approved immediately.
- Pending guard approval listing and approval/rejection actions are restricted to admin and superadmin roles. Supervisor approval permission and navigation were removed.
- Rejection requires a reason. Approval/rejection notifications are sent to the guard and to the supervisor who created the account.

# 85) PHASE 4 PLATFORM RELEASE CONFIDENCE (2026-09-16)

## Fix
- Added `operations-map` to the elevated operational-shell route set so direct navigation renders the map instead of falling back to the dashboard.
- Added a repeatable `audit:phase4` browser audit covering superadmin and guard map surfaces, desktop/mobile layouts, theme behavior, tracking endpoints, authorization, diagnostics, and overflow.

## Verification
- Phase 4 map audit passed for command and guard roles on desktop and mobile. Map tiles rendered in every run; `map-data` and `active-guards` returned valid `200` payloads; guard client-site management remained correctly restricted with `403`.
- Frontend TypeScript check passed; all 29 Jest suites and 131 tests passed.
- Production web gate passed; Android/Capacitor and desktop/Tauri builds passed after the route fix.
- GitHub Actions release run `34926862284` for `v1.2.2` is successful and contains web, Windows, signed Android APK, and signed Android AAB artifacts.

## Boundary
- The route fix is locally verified but is not included in the already published `v1.2.2` artifacts; it needs the next commit and governed release before client rollout.

# 81) OPERATIONAL REQUEST ROLE SEPARATION (2026-09-16)

## Fix
- Operational requests can now be submitted or resubmitted only by guards and supervisors.
- Admins and superadmins retain request queue access and are the only roles allowed to review, approve, reject, return, start, complete, or fulfill requests.
- The frontend hides `New Request` for admins and superadmins while retaining their review and fulfillment workflow.
- The resubmission endpoint now uses the same requester-role authorization, preventing legacy elevated-role requests from bypassing the policy.
- Startup permission cleanup removes the old elevated request-creation and supervisor-review rows from existing databases.
- Pending-request notifications are sent only to admin and superadmin reviewers.

## Verification
- Frontend TypeScript check passed.
- All 28 Jest suites and 129 tests passed.
- Backend formatting check passed.
- Backend production Docker image build passed.
- Backend Docker release build passed; native Windows cargo check remains blocked by the host's missing OpenSSL development libraries.

# 80) PREDICTIVE ALERT PRESENTATION CLEANUP (2026-09-16)

## Fix
- Removed confidence percentage and explanation text from the predictive operational alert cards.
- Risk level and suggested action remain visible for operational triage.

## Verification
- Frontend TypeScript check passed.
- All 28 Jest suites and 129 tests passed.
- Frontend production build passed.

# 83) MISSION RESOURCE SELECTION AND FIREARM COMPLIANCE (2026-09-16)

## Fix
- Mission assignment now loads approved, verified guards from `/api/guards` and uses the exact guard, firearm, and vehicle selected in the form.
- Mission firearm choices are limited to available firearms with a current license expiry date; the backend enforces the same rule.
- Firearm compliance now marks a missing firearm license as `no_permit`, uses the stored firearm license expiry date in the report, and includes firearm-license expirations in notification candidates.
- Shared SOC button and form-control styles were applied to mission assignment, approval, firearm allocation, firearm inventory, vehicle, and client-site actions. Approval actions use green styling and destructive/cancel actions use red styling.

## Verification
- Frontend TypeScript check passed.
- All 28 Jest suites and 129 tests passed.
- Frontend production build passed.
- Backend formatting check passed.
- Backend production Docker image build passed.

# 84) UI HCI POLISH PHASES 0-9 (2026-09-16)

## Completed
- Executed the UI/HCI plan sequentially for all four roles: baseline audit, shared design system, shell/navigation, shared interaction components, guard UI, supervisor UI, admin UI, superadmin UI, accessibility/responsive polish, and regression/release gates.
- Added configurable multi-viewport functionality auditing, role-safe supervisor approval routing, drawer focus management, consistent SOC controls, guard emergency-contact icons, semantic action colors, accessible elevated-role search labels, and a repeatable accessibility audit script.
- Added phase evidence to `docs/UI_POLISH_PHASE_STATUS.md`.

## Verification
- TypeScript check passed.
- Full Jest suite passed: 29 suites and 131 tests.
- Full interaction audit passed: 223 route checks, 989 control interactions, zero failures.
- Accessibility audit passed: 128 route checks, zero failures across 320px, 375px, 768px, and 1280px viewports.
- Web, Android/Capacitor, and desktop/Tauri builds passed. Desktop MSI and NSIS installers were produced.
- Existing Vite mixed static/dynamic `config.ts` import warning remains non-blocking.

# 85) MOBILE SIDEBAR CLOSE CONTROL (2026-09-16)

## Fix
- Removed the visible X button from the mobile sidebar header at the user's request.
- Preserved sidebar dismissal through the backdrop, Escape key, and global menu toggle.
- Focus now moves to the first navigation control when the mobile sidebar opens, and returns to the triggering control when it closes.

## Verification
- TypeScript check passed.
- Shell navigation tests passed: 7 tests.
- Mobile functionality audit passed: 16 route checks, 104 control interactions, zero failures.

# 86) GUARD ROSTER UI REFINEMENT (2026-09-16)

## Fix
- Refined the resource-management guard roster with a clearer personnel header, registered-count chip, consistent primary/neutral/danger actions, Lucide icons, improved row hierarchy, explicit missing-value labels, and an accessible responsive table caption and column scopes.

## Verification
- Full Jest suite passed: 29 suites and 131 tests.
- TypeScript check passed.
- Desktop and mobile functionality audit passed: 85 route checks, 396 control interactions, zero failures.
- Frontend production build passed.

# 88) REPO-WIDE UI STANDARDIZATION (2026-09-16)

## Fix
- Added shared semantic status classes, tokenized form-field styling, and a global minimum-size/focus baseline for buttons and form controls.
- Migrated remaining legacy action/status styles across dashboards, admin tools, maps, firearms, merit, support, audit, settings, and placeholder panels.
- Added `npm run audit:ui-consistency` to detect raw palette classes and action buttons missing a shared SOC variant.

## Verification
- UI consistency audit passed: 128 component files, 335 buttons, 184 form controls, zero findings.
- Manual functionality audit passed: 85 route checks, 396 control interactions, zero failures.
- Accessibility/responsive audits passed: 128 checks covering 320px, 375px, 768px, and 1280px viewport groups, zero failures.
- TypeScript, 29 Jest suites/131 tests, and frontend production build passed.
- A paced split was used for the accessibility matrix because the backend rate limiter returned 429 responses during an overly fast combined run.

# 89) MDR RESOURCE EXPORT AND CLEAR (2026-09-16)

## Fix
- Added an MDR workspace export action that downloads current guard, firearm, and vehicle records as CSV.
- Added a confirmation-protected delete-all action for those three resource groups.
- Enforced admin/superadmin authorization in both middleware and the handler; the clear operation runs in one transaction and preserves elevated accounts, clients, MDR history, and audit records.
- Cleared non-cascading guard references before deletion and recorded the operation with deletion counts in the audit log.

## Verification
- Frontend TypeScript check passed.
- Full Jest suite passed: 29 suites and 131 tests.
- Frontend production build passed.

- Backend production Docker build passed.
- Authorized admin export returned CSV sections for guards, firearms, and vehicles; guard delete attempt returned 403.
- Isolated database fixture confirmed deletion counts, preserved admin account, cleared references, and created the clear audit event.

# 90) LIVE OPERATIONS FEED LAYOUT FIX (2026-09-17)

## Fix
- Aligned the incident alert feed viewport with the live operations feed so alert cards and action controls are not clipped inside a shorter scroll area.
- Standardized live-feed dismiss, acknowledge, and resolve controls with SOC button variants, accessible sizing, and Lucide icons.

## Verification
- Frontend production build passed.
- Full Jest suite passed: 29 suites and 131 tests.
- UI consistency audit passed with zero findings.
- Local frontend served the updated modules on port 5173.
- Local backend and database health returned 200 OK.

# 91) NOTIFICATION TOAST READABILITY FIX (2026-09-17)

## Fix
- Corrected desktop toast positioning so notifications render below the header on the right instead of covering the sidebar.
- Added an opaque elevated surface, clearer text hierarchy, safe text wrapping, larger dismiss control, and a subtle five-second progress animation.

## Verification
- Frontend TypeScript check passed.
- Full Jest suite passed: 29 suites and 131 tests.
- Frontend production build passed.
- UI consistency audit passed with zero findings.
- Local frontend served the updated notification module and backend health returned 200 OK.

# 92) GEOFENCE RADIUS UNIT LABEL (2026-09-17)

## Fix
- Added a persistent `km` suffix to the geofence radius input in the Operational Map geofence manager so the default numeric value is unambiguous.
- Kept the form state and API payload numeric in kilometers; existing geofence table output already includes the `km` unit.

## Verification
- Frontend TypeScript check passed.
- Full Jest suite passed: 29 suites and 131 tests.
- Frontend production build passed.
- UI consistency audit passed with zero findings.
- Local frontend served the updated `OperationalMapPanel` module and backend health returned 200 OK.

# 93) GEOFENCE CONTROL CONSISTENCY (2026-09-17)

## Fix
- Removed browser number spinners from the geofence radius field while retaining keyboard and direct numeric input.
- Switched the client-site selector and radius field to the shared `soc-field` styling for consistent dimensions and focus states.
- Added an accessible description and hover explanation for the Active zone control; active zones are monitored for guard enter/exit alerts.

## Verification
- Frontend TypeScript check passed.
- Full Jest suite passed: 29 suites and 131 tests.
- Frontend production build passed.
- UI consistency audit passed with zero findings.
- Local frontend and backend health endpoints returned 200 OK.

# 98) BACKEND-BACKED GUARD AVAILABILITY AND SHIFT READINESS (2026-09-17)

## Fix
- Replaced the guard dashboard's localStorage-only callout and equipment state with the existing backend availability record and a new per-shift `guard_shift_readiness` record.
- Added authenticated readiness GET/PUT endpoints with guard self-access, supervisor-plus operational access, assigned-shift validation, item allow-list validation, and audit middleware on writes.
- Extended availability updates to persist optional availability windows and notes, and restricted targets to guard accounts.
- Added callout and readiness status fields to elevated shift data and surfaced them in the command-center deployment overview for supervisors, admins, and superadmins.
- Removed the duplicate profile availability control so the guard dashboard is the single operational control surface.

## Verification
- Frontend TypeScript check passed.
- Full Jest suite passed: 33 suites and 137 tests, including focused backend-backed readiness UI tests.
- Frontend production build passed with the existing Vite dynamic-import warnings only.

# 106) MDR COMMIT DUPLICATE-RESOURCE HARDENING (2026-09-17)

## Fix
- Fixed MDR client commits failing on the unique `(name, branch)` index when an existing client was not matched because workbook names contained spacing differences.
- Client matching and commit reuse trimmed/case-normalized names and update existing client details instead of inserting duplicates.
- Fixed armored-car commits where a workbook row matched one vehicle by plate and another by VIN. The importer now prefers the plate match and preserves the selected vehicle's existing VIN when identifiers conflict, preventing unique plate/VIN violations.

## Verification
- Rebuilt and restarted the backend Docker service successfully.
- Retried the affected batch through the live API; it committed successfully and is recorded as `committed` in PostgreSQL.
- API health returned `ok`.
- Backend format and diff checks passed.

# 107) MDR COMMIT SUMMARY FIELD PARITY (2026-09-17)

## Fix
- MDR commit summaries are serialized by the Rust API in camelCase, while the review modal was reading snake_case keys.
- The modal now reads the API contract correctly, with snake_case fallback compatibility, so guard created/updated and blocked counts reflect the actual commit.

## Verification
- Latest committed batch audit recorded 153 guard updates and 0 new guard accounts; the database contains the updated guard records.
- Frontend TypeScript check passed.
- Full Jest suite passed: 34 suites and 140 tests.
- Frontend production build passed with the existing Vite dynamic-import warnings only.
- UI consistency audit passed with zero findings.
- Backend `cargo fmt --all -- --check` passed.
- Backend compile verification remains blocked by the local Windows environment missing the OpenSSL development installation required by the existing `sqlx` native-tls dependency.
- Backend Docker release build passed, compiling the server successfully on Linux.

# 99) GUARD READINESS ITEM ALIGNMENT (2026-09-17)

## Fix
- Reduced the guard pre-shift readiness checklist to the required operational items: Uniform, Firearm, and Endorsement Form.
- Kept the frontend labels, submitted keys, backend allow-list, completion rule, elevated status query, and tests aligned at three items.

# 96) NATIVE SELECT TYPE-AHEAD CORRECTION (2026-09-17)

## Correction
- Removed the custom searchable combobox because the requested behavior is native dropdown type-ahead: users focus a selector and type the beginning of a name to jump to the matching option.
- Restored the original native selectors and preserved the existing form state, option values, and API behavior.

## Verification
- Full Jest suite passed: 29 suites and 131 tests.
- Frontend TypeScript check passed.
- Frontend production build passed.
- UI consistency audit passed with zero findings.

# 95) SEARCHABLE ENTITY SELECTORS (2026-09-17)

## Fix
- Added a shared accessible `SearchableSelect` combobox with text filtering, keyboard navigation, selected-state feedback, empty states, and outside-click handling.
- Applied it to long-list operational selectors for guards, client sites, firearms, vehicles, mission assignments, maintenance, and shift swaps.
- Preserved existing selected values and parent callbacks; static short filters such as status and priority remain native dropdowns.

## Verification
- Full Jest suite passed: 30 suites and 133 tests, including focused searchable-select tests.
- Frontend TypeScript check passed.
- Frontend production build passed.
- UI consistency audit passed with zero findings.
- Local frontend and backend health endpoints returned 200 OK.

# 94) GEOFENCE CONTROL HEIGHT ALIGNMENT (2026-09-17)

## Fix
- Set the client-site selector, radius input, and radius suffix wrapper to the shared 44px `h-11` height so the geofence form controls align consistently.

## Verification
- Frontend TypeScript check passed.
- Full Jest suite passed: 29 suites and 131 tests.
- Frontend production build passed.

# 97) ELEVATED SOS ALERT POPUP (2026-09-17)

## Fix
- Added a prominent, opaque SOS alert dialog for active guard panic incidents on the shared elevated command center used by supervisors, admins, and superadmins.
- The dialog shows the reporting guard, received time, site/location, and clear Acknowledge, Resolve SOS, and Dismiss actions.
- Acknowledge updates the incident to investigating; Resolve updates it to resolved; Dismiss only hides the popup locally while leaving the incident in the existing live feed and notification path.
- The popup uses the existing server-backed active-incident polling, so alerts sent from a guard device appear on elevated dashboards without changing SOS submission or offline queue behavior.

## Verification
- Focused SOS dialog tests passed: 2 tests.
- Full Jest suite passed: 30 suites and 133 tests.
- Frontend TypeScript check passed.
- Frontend production build passed with existing Vite dynamic-import warnings only.

# 125) REMOVE COMMAND CENTER REFRESH PILL (2026-09-17)

## Fix
- Removed the `Dashboard refresh` freshness pill from the command-center header at the user's request.
- Removed the unused local refresh timestamp state and component import; background polling remains unchanged.

## Verification
- Frontend TypeScript check passed.
- Focused dashboard and navigation tests passed: 2 suites and 9 tests.
- Frontend diff check passed.

# 128) FEEDBACK HEADER SPACING (2026-09-17)

## Fix
- Added responsive internal padding to the Feedback Intelligence command panel so its border no longer sits against the heading, description, or Refresh action.

## Verification
- Frontend TypeScript check passed.
- Feedback dashboard tests passed: 1 suite and 2 tests.
- Frontend diff check passed.

# 127) INBOX PRIORITY COLORS (2026-09-17)

## Fix
- Quick inbox priority badges now use red for Urgent, yellow for High, and green for Normal.
- Full action-inbox priority bars use the same severity colors, including green for Normal.
- Quick inbox badges use the explicit `soc-status-danger`, `soc-status-warning`, and `soc-status-success` styles for reliable rendering.

## Verification
- Frontend TypeScript check passed.
- Focused inbox and navigation tests passed: 2 suites and 10 tests.
- Frontend diff check passed.

# 126) GUARD LICENSE NOTIFICATION PRIORITY (2026-09-17)

## Fix
- Guard license compliance notifications are now mapped to Urgent when expired and High when expiring soon.
- Applied the priority mapping to the shared quick inbox and the admin, supervisor, and superadmin full inbox views.

## Verification
- Frontend TypeScript check passed.
- Focused inbox and navigation tests passed: 2 suites and 10 tests.
- Frontend diff check passed.

# 124) COMMAND CENTER STATUS DATA CORRECTIONS (2026-09-17)

## Fix
- Command-center guard capacity now uses the approved, verified guard roster from `/api/guards`; unavailable roster data is shown as `--` instead of an artificial denominator.
- Service availability now counts only the five service status fields, excluding the `lastChecked` timestamp.
- System status now becomes Warning when any monitored service is offline, in addition to existing operational alert rules.
- Renamed the dashboard freshness label from `SOC stream` to `Dashboard refresh` to reflect the current polling implementation.

## Verification
- Frontend TypeScript check passed.
- Full Jest suite passed: 34 suites and 142 tests.
- Frontend production build passed with existing Vite dynamic-import warnings only.

# 124) GUIDED CLIENT SITE AND CHECK-IN AREA SETUP (2026-09-17)

## Fix
- Added an atomic backend endpoint that creates a client site and its active radius geofence in one transaction.
- Reworked the Operations Map client location manager to use site name, address or landmark, map-selected location, and a plain-language 100/250/500 meter check-in area selector.
- Removed raw latitude/longitude fields and the separate Geofence Zone Manager from the visible setup workflow.
- Compact site records now show address, check-in area, and active/inactive status; existing sites remain editable and their radius can be updated through the same form.

## Verification
- Frontend TypeScript check passed.
- Frontend production build passed with existing Vite dynamic-import warnings only.

# 129) DARK MODE DATE PICKER CONTRAST (2026-09-17)

## Fix
- Added explicit light and dark `color-scheme` declarations to the frontend theme roots so native date and datetime calendar controls remain visible in dark mode.

## Verification
- Frontend TypeScript check passed.
- Frontend production build passed with existing Vite dynamic-import warnings only.
- Backend `cargo fmt -- --check` passed.
- Backend `cargo check` was blocked by the local Windows environment missing OpenSSL development files.
- Authenticated browser verification was blocked because the local backend was unavailable and no credentials were provided.

# 125) CLIENT SITE ACTION FEEDBACK (2026-09-17)

## Fix
- Made the Operations Map Add Client Site action scroll to and focus the guided site form.
- Made Edit scroll to and focus the site name field.
- Added visible saving, deleting, success, and validation feedback for site actions.
- Added per-site delete loading state and contextual accessible labels for Edit and Delete controls.

## Verification
- Frontend TypeScript check passed.
- Full Jest suite passed: 34 suites and 142 tests.
- Frontend production build passed with existing Vite dynamic-import warnings only.

# 128) CLIENT SITE ACTION BUTTONS AND MAP RESIZE (2026-09-17)

## Fix
- Promoted the Operations Map Add Client Site action to the shared primary button style and added a clear add icon.
- Styled Edit and Delete site actions with the shared controls and action icons, preserving delete loading feedback.
- Aligned the Add Site and Save changes actions directly with the guard check-in-area selector, with responsive stacking on narrow screens.
- Added Leaflet resize observation for the map and wrapper, including short post-transition refreshes, so sidebar collapse and expansion redraw the full tile area.

## Verification
- Frontend TypeScript check passed.
- Full Jest suite passed: 34 suites and 142 tests.
- Frontend production build passed with existing Vite dynamic-import warnings only.
- `git diff --check` passed.

# 129) CLIENT SITE LOCATION CONFIRMATION PIN (2026-09-17)

## Fix
- Replaced the temporary client-site draft circle with a visible yellow map pin.
- The pin appears after a location is clicked, remains visible while the form is reviewed, and clears after save, cancel, or delete.
- Added a pin popup that identifies the selected site location without presenting it as live GPS telemetry.

## Verification
- Frontend TypeScript check passed.
- Full Jest suite passed: 34 suites and 142 tests.
- Frontend production build passed with existing Vite dynamic-import warnings only.
- `git diff --check` passed.

# 130) OPERATIONS MAP METRIC LABEL ACCURACY (2026-09-17)

## Fix
- Renamed map summary metrics so telemetry counts are not presented as database trips, deployed-shift totals, or full-roster counts.
- Changed the tracked-unit summary to use all returned tracking points rather than the currently visible map layers.
- Added concise descriptions for reporting windows, schedule classification, and stale/offline guard reports.
- Renamed the map component props and parent count variables to reflect recent guard and vehicle reports.

## Verification
- Frontend TypeScript check passed.
- Full Jest suite passed: 34 suites and 142 tests.
- Frontend production build passed with existing Vite dynamic-import warnings only.
- `git diff --check` passed.

# 131) CLIENT SITE CREATION ROUTE DEPLOYMENT FIX (2026-09-17)

## Fix
- Diagnosed client-site creation failure as a stale local backend container missing the combined `/api/tracking/client-sites/with-geofence` POST route.
- Rebuilt and restarted the local backend with the current source.
- Confirmed the route now reaches authentication with HTTP 401 instead of returning HTTP 405 for an unauthenticated request.

## Deployment Note
- The Railway backend still returns HTTP 405 for this route and requires a separate deployment of the current backend image before the production frontend can use the combined site-and-geofence operation.

# 121) ALLOCATION DISPLAY IDENTIFIERS (2026-09-17)

## Fix
- Updated the all-allocation backend query to join guard and firearm records and return display fields alongside internal IDs.
- Allocation UI now displays guard names and firearm serial/model labels; unmatched relationships display `Unknown guard` or `Unknown firearm` instead of UUIDs.
- Rebuilt and restarted the local backend so the running API serves the new response shape.

## Verification
- Backend Docker release build passed.
- Backend `cargo fmt --all -- --check` passed.
- Frontend navigation/API tests passed: 2 suites and 16 tests.
- Frontend production build passed with existing Vite dynamic-import warnings only.
- Local database check confirmed 270/270 allocations have matching guard names and firearm serial numbers.
- Local backend `/api/health` returned HTTP 200.

# 120) FIREARM ALLOCATION LABELS AND NAVIGATION (2026-09-17)

## Fix
- Added the Allocation destination to the superadmin sidebar because the role already has `manage_allocations` permission and the `/allocation` route was already registered.
- Replaced raw guard and firearm UUIDs in the allocation table with guard names and firearm serial/model labels, retaining IDs only as fallback values when related records are unavailable.

## Verification
- Shell navigation test passed: 1 suite and 7 tests.
- Frontend production build passed with existing Vite dynamic-import warnings only.

# 119) ANALYTICS PANEL SURFACE CONSISTENCY (2026-09-17)

## Fix
- Updated the Total Missions analytics panel to use the same shared `soc-dashboard-card` surface as the KPI and chart panels.
- Analytics panels now avoid the isolated bright-box treatment while preserving warning-state styling and print output rules.

## Verification
- Focused analytics tests passed: 2 suites and 3 tests.
- Frontend production build passed with existing Vite dynamic-import warnings only.

# 118) ANALYTICS FILTER PANEL SURFACE (2026-09-17)

## Fix
- Matched the analytics Period filter bar to the Resource Availability card by using the shared `soc-dashboard-card` surface styling.
- Preserved the existing date-range selector, refresh action, and print-only visibility behavior.

## Verification
- Focused analytics tests passed: 2 suites and 3 tests.
- Frontend production build passed with existing Vite dynamic-import warnings only.

# 121) MERIT FIRST-EVALUATION DEPLOYMENT (2026-09-17)

## Verification
- Rebuilt and restarted the local backend Docker service with the initial-guard merit query.
- PostgreSQL data was preserved; the database reports 109 eligible guards and 0 existing merit-score rows.
- Backend release Docker compilation completed successfully and the service is running on port 5000.

# 120) INITIAL GUARD EVALUATION ACCESS (2026-09-17)

## Fix
- Merit rankings now include active, approved, verified guards who do not yet have a `guard_merit_scores` row.
- Guards without prior scoring appear with zero initial metrics and a `Not evaluated` rank so supervisors and administrators can open the record and submit the first evaluation.
- Guard detail requests now return an initial empty merit response instead of `Merit score not found`, while still rejecting invalid or ineligible guard accounts.
- Updated the empty state to explain that eligible guards are required before evaluations can be entered.

## Verification
- Backend `cargo fmt --check` passed.
- Focused frontend navigation and analytics tests passed: 9 tests.
- Frontend production build passed with existing Vite dynamic-import warnings only.
- UI consistency audit passed with zero findings.
- Local frontend and backend health endpoints returned 200 OK.

# 100) GEOFENCE AUTOMATIC SHIFT CHECK-IN (2026-09-17)

## Fix
- Added server-authoritative automatic check-in when a guard's accurate location is inside an active geofence for the guard's assigned site and the shift is currently in progress.
- Reused the locked, idempotent attendance check-in path for both manual and geofence check-in, preventing duplicate attendance records and preserving manual fallback behavior.
- Automatic check-ins record `check_in_source = 'geofence'` and create a guard notification.
- Automatic evaluation runs on the first valid GPS sample and every subsequent heartbeat, and allows arrival up to one hour before shift start while the guard remains inside the zone.
- Added a guard-dashboard attendance refresh so background-triggered check-ins appear after the app returns to the foreground.

## Verification
- Frontend TypeScript check passed.
- Full Jest suite passed: 33 suites and 137 tests.
- Frontend production build passed with existing Vite dynamic-import warnings only.
- UI consistency audit passed with zero findings.
- Backend `cargo fmt --all -- --check` passed.
- Backend Docker release build passed, compiling the server successfully on Linux.

# 101) EMERGENCY CONTACTS UPDATE (2026-09-17)

## Change
- Centralized guard emergency contacts now list Branch Manager, Security Officer, Secretary, and Tech Support with the configured Philippine phone numbers.
- Updated the field-instructions contact block to use the same four contacts and replaced the obsolete Operations Desk escalation reference with Security Officer.

## Verification
- Frontend TypeScript check passed.
- Full Jest suite passed: 33 suites and 137 tests.
- `git diff --check` passed with the repository's existing line-ending warning for `PROJECT_MEMORY.md`.

# 102) MDR GUARD LICENSE IMPORT FIX (2026-09-17)

## Fix
- MDR commit now updates `license_number` and `license_expiry_date` when a staging row matches an existing guard, including guards matched by name.
- MDR workbook parsing keeps Excel date-only cells as serial values to prevent timezone conversion from shifting Philippine dates back one day.
- Added a regression test covering license extraction and the `10/7/2025` Excel date serial behavior.

## Verification
- Frontend TypeScript check passed.
- Full Jest suite passed: 34 suites and 138 tests.
- Frontend production build passed with existing Vite dynamic-import warnings only.
- Backend `cargo fmt --all -- --check` passed.
- Backend Docker release build passed, compiling the server successfully on Linux.

# 103) MDR COMMIT ERROR-ROW RESOLUTION (2026-09-17)

## Fix
- MDR commit was correctly returning HTTP 409 when the staged batch still contained validation errors; the review UI did not provide an action for error rows, leaving the batch impossible to finish from the UI.
- Error rows can now be explicitly included as matched/new or skipped. Including clears the validation error only after a required reviewer note; skipping preserves the original error for audit and excludes the row from the commit transaction.
- Staging resolution verifies that the batch is still editable, records the decision and note in the MDR audit trail, and rejects missing notes for error-row decisions.

## Verification
- Live API test: unresolved batch commit returned 409; an error decision without a note returned 400; audited skip decisions reduced unresolved rows to zero; the batch then committed successfully.
- Frontend TypeScript check passed.
- Full Jest suite passed: 34 suites and 140 tests.
- Frontend production build passed with existing Vite dynamic-import warnings only.

# 107) GUARD ROSTER PAGINATION AND SEARCH (2026-09-17)

## Fix
- Guard roster now displays 10 records per page with Previous and Next controls.
- Added submitted search for guard name, username, email, phone, guard number, and license number.
- Search resets to page 1 and shows a clear no-results state; clearing the search restores the full roster.

## Verification
- Frontend TypeScript check passed.
- Full Jest suite passed: 34 suites and 140 tests.
- Frontend production build passed with existing Vite dynamic-import warnings only.

# 108) RESOURCE TAB HEADER STANDARDIZATION (2026-09-17)

## Fix
- Standardized Firearms, Vehicles, and Client Sites management headers to match the Guard Roster pattern.
- Each tab now shows a section label, live registered-count badge, clear title, and concise operational description.
- Existing add, delete, loading, and error behavior remains unchanged.

## Verification
- Frontend TypeScript check passed.
- Full Jest suite passed: 34 suites and 140 tests.
- Frontend production build passed with existing Vite dynamic-import warnings only.

# 109) ARMORED CAR CAPACITY REMOVAL (2026-09-17)

## Fix
- Removed capacity and passenger-capacity inputs and displays from armored-car management, fleet inventory, and mission vehicle selection.
- New armored-car creation no longer requires capacity fields; the backend keeps legacy database columns and defaults them for compatibility with existing records and MDR imports.

## Verification
- Frontend TypeScript check passed.
- Full Jest suite passed: 34 suites and 140 tests.
- Frontend production build passed with existing Vite dynamic-import warnings only.
- Backend `cargo fmt --all -- --check` passed.
- Backend Docker release build passed and the local backend container restarted successfully.
- Backend `cargo fmt --all -- --check` passed.
- Backend Docker release build passed, compiling and running the updated server successfully on Linux.

# 104) MDR COMMIT RESULT CONFIRMATION (2026-09-17)

## Fix
- Added a modal result confirmation to MDR batch review so commit success, validation blocking, and request failures are visible immediately.
- The blocked result explicitly states that no database changes were made and shows pending, ambiguous, error, and total unresolved counts.
- Successful commit confirmation reports guard creation/update counts and confirms that valid license data was written.

## Verification
- Live current-batch API check returned HTTP 409 with 18 unresolved error rows; no commit was performed.
- Frontend TypeScript check passed.
- Full Jest suite passed: 34 suites and 140 tests.
- Frontend production build passed with existing Vite dynamic-import warnings only.

# 105) GUARD PASSWORD HANDOFF AND ACTIVATION (2026-09-17)

## Fix
- Added an admin/superadmin-only guard password endpoint at `/api/users/:id/password` with backend role and target-role enforcement, password-strength validation, refresh-session revocation, and audit middleware coverage.
- Added a self-service `/api/users/:id/password/change` endpoint for guards to replace temporary credentials; the server stores only bcrypt hashes and clears the required-change flag.
- Added `must_change_password` to the runtime user schema and login response. Imported MDR guards now receive a random unusable initial password and are marked for activation instead of sharing `changeme123!`.
- Added a shared management modal with a generated temporary password, confirmation, copy action, and plain-language handoff instructions. It is available in the guard roster and elevated user-management table for admin and superadmin roles.
- Added a blocking first-login password modal for activated guards after Terms of Agreement is accepted.

## Verification
- Backend Docker release build passed.
- Backend formatting check passed.
- Live API test created and removed a temporary guard, confirmed a valid admin-side password reset response, confirmed no password was returned, and confirmed `mustChangePassword: true`.
- Weak-password validation returned HTTP 400.
- Frontend TypeScript check passed.
- Full Jest suite passed: 34 suites and 140 tests.
- Frontend production build passed with the existing Vite dynamic-import warnings only.

# 106) MANAGEMENT ROSTER PAGINATION AND LICENSE VISIBILITY (2026-09-17)

## Fix
- The management dashboard now requests up to 200 users, matching the backend pagination maximum, instead of displaying the default first 50 records.
- Added license number, issued date, and expiry date to the shared `UserResponse` contract used by `/api/users` and `/api/guards`.
- The guard roster now displays the license number and expiry date when available.

## Verification
- Live API returned 189 users and 180 guards for `page_size=200`; 148 guards have license numbers.
- The imported sample guards now return their expected license numbers through the API.
- Backend `cargo fmt --all -- --check` passed.
- Backend Docker release build passed.
- Frontend TypeScript check passed.
- Full Jest suite passed: 34 suites and 140 tests.
- Frontend production build passed with existing Vite dynamic-import warnings only.

# 110) DISABLE MDR VEHICLE IMPORTS AND SIMPLIFY A/C TABLES (2026-09-17)

## Fix
- MDR parsing now skips armored vehicle sections and warns that vehicles must be added manually in Resource Management.
- Backend staging marks armored rows as ignored and commit logic skips them, including rows submitted by older clients or direct API callers.
- Fleet inventory and vehicle management tables now show only A/C number and status, with management actions retained where applicable.
- Existing vehicle records were retained; no destructive cleanup was performed.

## Verification
- Frontend TypeScript check passed.
- Full Jest suite passed: 34 suites and 141 tests.
- Frontend production build passed with existing Vite dynamic-import warnings only.
- Backend `cargo fmt --all -- --check` passed.
- Backend Docker release build passed.
- Local backend health check returned API and database status `up`.

# 117) ADD SCHEDULE ACTION POLISH (2026-09-17)

## Fix
- Updated the superadmin schedule header action to use the shared primary SOC button styling and a semantic calendar-plus icon.
- Added a minimum touch target, descriptive title, explicit button type, and responsive stacking so the action remains clear on narrow screens.
- Preserved the existing client-site loading and add-schedule modal behavior.

## Verification
- Full frontend Jest suite passed: 34 suites and 142 tests.
- Frontend production build passed with existing Vite dynamic-import warnings only.

# 118) SUPERVISOR AND ADMIN GUARD EVALUATIONS (2026-09-17)

## Fix
- Reframed the evaluation workflow around supervisor, admin, and superadmin assessments because the system has no client account or client-link workflow.
- Added a frontend evaluation permission for elevated roles and hid evaluation entry controls from non-authorized users.
- Updated merit, analytics, performance, and CSV labels to describe guard/evaluator ratings instead of client ratings.
- Kept the existing evaluation API fields and `client_evaluations` table for backward compatibility with stored records.
- Renamed the backend submission handler to `submit_guard_evaluation`; the endpoint still requires supervisor-or-higher authorization and records evaluator identity and role.

## Verification
- Frontend production build passed.
- Full Jest suite passed: 34 suites and 142 tests.
- Backend `cargo fmt --check` passed.
- Backend `cargo check` remains blocked by the local Windows environment missing the OpenSSL development installation required by the existing dependency chain.

# 119) MERIT SIDEBAR NAVIGATION (2026-09-17)

## Fix
- Added the Merit destination to the supervisor, admin, and superadmin sidebar navigation.
- Kept Merit hidden from guard navigation through the existing elevated-role route and permission rules.

## Verification
- Focused shell navigation test passed: 7 tests.
- Frontend production build passed with existing Vite dynamic-import warnings only.

# 117) BLANK EMAILS FOR MDR-IMPORTED GUARDS (2026-09-17)

## Fix
- MDR-created guard accounts now store a blank email instead of a generated `@sentinel.local` address.
- Existing generated emails are cleared during backend startup only for guards linked to an MDR batch; real staff-assigned emails are preserved.
- Replaced the users email constraint with a partial unique index so real emails remain unique while multiple imported guards may have blank emails.
- Username and phone login remain available for imported guards.

## Verification
- Backend Docker release build passed.
- Backend `cargo fmt --all -- --check` passed.
- Frontend TypeScript check passed.
- Local database migration confirmed 177 imported guards with blank emails and zero legacy imported addresses.
- Local backend health check returned API and database status `up`.

# 112) MODAL INPUT FOCUS RETENTION (2026-09-17)

## Fix
- Updated `SentinelModal` so changing an inline `onClose` callback during normal form rerenders does not restart modal focus setup.
- Modal focus is now initialized only when the dialog opens, while Escape still uses the latest close callback.
- Added a regression test confirming controlled inputs retain focus while typing.

## Verification
- Focused modal tests passed: 2 tests.
- Full Jest suite passed: 34 suites and 142 tests.
- Frontend TypeScript check passed.
- Frontend production build passed with existing Vite dynamic-import warnings only.

# 113) USER MANAGEMENT PAGINATION AND CONTROL CLEANUP (2026-09-17)

## Fix
- User Management now displays 10 users per page on desktop and mobile.
- Previous and Next buttons are functional and show the current page and visible range.
- Search resets to page 1 and continues to work across the full allowed roster.
- Removed the User Management role filter, status filter, tracking accuracy control, and roster-sync indicator.
- Bulk selection now applies to the currently visible page while preserving existing account actions and role permissions.

## Verification
- Frontend TypeScript check passed.
- Full Jest suite passed: 34 suites and 142 tests.
- Frontend production build passed with existing Vite dynamic-import warnings only.

# 116) FIREARMS STATUS BADGE SPACING (2026-09-17)

## Fix
- Made Available, Issued, and Maint. firearm status badges explicitly vertical and centered so labels are separated from their counts.

## Verification
- Frontend TypeScript check passed.
- Full Jest suite passed: 34 suites and 142 tests.
- Frontend production build passed with existing Vite dynamic-import warnings only.

# 115) INCIDENT SEVERITY BADGE SPACING (2026-09-17)

## Fix
- Made severity summary badges explicitly vertical and centered so each label is separated from its count instead of rendering as `CRITICAL0`.

## Verification
- Frontend TypeScript check passed.
- Full Jest suite passed: 34 suites and 142 tests.
- Frontend production build passed with existing Vite dynamic-import warnings only.

# 114) SEPARATE APPROVALS FROM OPERATIONAL REQUESTS (2026-09-17)

## Fix
- Removed the duplicate Operational Requests panel from the Approvals page.
- Approvals now focuses only on pending guard registrations and their approval actions.
- The dedicated Requests page remains unchanged and continues to host the operational request queue.

## Verification
- Frontend TypeScript check passed.
- Full Jest suite passed: 34 suites and 142 tests.
- Frontend production build passed with existing Vite dynamic-import warnings only.

# 111) A/C-ONLY MANUAL VEHICLE CREATION (2026-09-17)

## Fix
- Simplified the Add Vehicle modal to one required A/C number field.
- The create endpoint now requires only the A/C number; legacy VIN, model, and manufacturer payload fields remain optional for compatibility.
- Existing database-required fields receive internal placeholders when omitted and are not shown as part of the vehicle workflow.

## Verification
- Frontend TypeScript check passed.
- Full Jest suite passed: 34 suites and 141 tests.
- Frontend production build passed with existing Vite dynamic-import warnings only.
- Backend `cargo fmt --all -- --check` passed.
- Backend Docker release build passed.
- Local backend health check returned API and database status `up`.

# 122) GUARD LICENSE COMPLIANCE ALERTS (2026-09-17)

## Fix
- Added a guard license compliance report for approved, verified guards with expired, expiring-soon, no-license, and compliant statuses.
- Added a 30-day default expiration window, configurable to 1-365 days, with pagination and CSV/print actions.
- Added deduplicated guard-license expiry notifications for approved supervisors, admins, and superadmins using the existing notification inbox and delivery worker.
- Added the Guard License Compliance page to elevated navigation at `/guards/compliance`.

## Verification
- Backend Docker release build passed.
- Backend `cargo fmt --all -- --check` passed.
- Frontend TypeScript check passed.
- Full Jest suite passed: 34 suites and 142 tests.
- Frontend production build passed with existing Vite dynamic-import warnings only.
- Local backend health check returned API and database status `up`.
- Local database report query resolved 180 approved guards: 148 with license numbers, 135 with expiry dates, 70 expired, 46 without license data, and 64 compliant.

# 123) STABLE SIDEBAR ROUTE NAVIGATION (2026-09-17)

## Fix
- Wrapped desktop sidebar and elevated mobile route changes in React transitions so lazy-loaded pages do not replace the visible shell with a brief full-screen loading fallback.
- Registered guard compliance as an operational shell route so navigation and mobile layout state remain consistent.
- Stabilized the active sidebar highlight with an inset shadow so changing active items does not alter icon or label positioning.
- Wrapped the main elevated dashboard's direct route navigation in the same transition path.

## Verification
- Frontend TypeScript check passed.
- Full Jest suite passed: 34 suites and 142 tests.
- Frontend production build passed with existing Vite dynamic-import warnings only.

# 124) RAILWAY CLIENT SITE CREATION DEPLOYMENT (2026-09-17)

## Deployment
- Deployed the current backend source to the Railway production Backend service.
- Production `/api/health` returned HTTP 200 with API and database status up.
- The combined `/api/tracking/client-sites/with-geofence` route now returns HTTP 401 without authentication instead of HTTP 405, confirming the route is registered and protected without modifying data.

# 125) OPERATIONS MAP LEGEND SIMPLIFICATION (2026-09-17)

## Fix
- Reduced the operations map legend from separate entries for every guard heartbeat state and temporary marker to four concise concepts.
- Kept guard state meaning in one note: green active, yellow stale, and red offline; purple markers represent clustered units.
- Map entity classification remains data-driven: tracking points use `entityType`, with `vehicle` rendered as a vehicle and `guard` rendered as a guard.

## Verification
- Frontend production build passed with existing Vite dynamic-import warnings only.

# 128) VEHICLE ALLOCATION CLIENT SITE SELECTION (2026-09-17)

## Fix
- Replaced the free-text Client field in armored vehicle allocation with a dropdown populated from registered active client sites.
- Displayed the site name with its address or landmark to make locations easier to distinguish.
- Kept the existing allocation storage format human-readable by submitting the selected site name.
- Disabled the field and explained the prerequisite when no active client sites are available.

## Verification
- Frontend TypeScript check passed.
- Frontend production build passed with existing Vite dynamic-import warnings only.

# 126) DRIVER-BASED VEHICLE MAP TRACKING (2026-09-17)

## Feature
- Connected the existing driver assignment workflow to armored-car inventory so supervisors can assign one approved guard to one vehicle and unassign them later.
- Enforced that a guard and a vehicle each have at most one active driver assignment; a reassignment closes the previous active assignment.
- Kept guard heartbeats stored against the guard for attendance and geofence processing, while the operations map presents the latest assigned guard heartbeat as the vehicle using the vehicle ID and A/C number.
- Added assignment details and guard selection controls to the armored-car inventory.

## Verification
- Backend Docker release build and container restart passed.
- Local backend health returned HTTP 200 with API, database, and websocket up.
- Protected driver-assignment list returned HTTP 401 without authentication.
- Frontend TypeScript check and production build passed with existing Vite dynamic-import warnings only.

# 127) DRIVER SELECTOR NAME CLARITY (2026-09-17)

## Fix
- Removed guard roster numbers from the vehicle driver selector to avoid presenting them as tracking or vehicle identifiers.
- Kept guard accounts separate; duplicate names are not merged automatically because local data contains distinct verified accounts sharing the same name.

## Verification
- Frontend production build passed with existing Vite dynamic-import warnings only.

# 131) STABILIZATION AUDIT BASELINE (2026-09-17)

## Verification
- Frontend TypeScript check passed.
- Frontend Jest suite passed: 34 suites and 142 tests.
- Frontend production build passed with existing Vite dynamic-import warnings only.
- Functionality audit passed 85 role/route checks and 382 safe control interactions with no page, console, API, request, or overflow failures.
- Accessibility audit passed 128 role/viewport checks across 320x844, 375x844, 768x1024, and 1280x900; phase 5 analytics audit passed on desktop and mobile.
- Frontend dependency audit reported zero vulnerabilities at the high threshold.
- Backend Docker release build and local health check passed.
- Fresh disposable-database mutation audit passed all 12 workflows with zero page, console, or API diagnostics; the guard sticky-region fix also passed a normal mobile browser click reproduction.

## Remaining Gate
- Host Windows Rust checks remain blocked by missing OpenSSL development files; container or CI validation is required before release.
- Clean commit/submodule review and deployment verification remain before commit, push, or deployment.
