# SENTINEL: Capstone Paper vs Current System Implementation Audit

**Audit date:** 2026-09-22  
**Audit type:** evidence-based documentation discrepancy review  
**Paper baseline reviewed:** `SENTINEL - Group 8.docx` (text extraction) and its maintained text mirror, `SENTINEL - Group 8.md`  
**Implementation baseline reviewed:** current workspace source in `DasiaAIO-Frontend`, `DasiaAIO-Backend`, `apps/android-capacitor`, `apps/desktop-tauri`, root release scripts, and tests.

## Audit Method and Status Legend

This is a source and configuration audit, not a production certification. It confirms what the current repository implements or configures. It does not prove that a production deployment, signed Android artifact, desktop installer, live data migration, external service, or cited reference is currently valid.

| Status | Meaning |
|---|---|
| **ALIGNED** | Paper claim is supported by current implementation evidence. |
| **PARTIAL** | A related feature exists, but the paper overstates automation, coverage, role access, or maturity. |
| **UNSUPPORTED / UNVERIFIED** | No confirming implementation evidence was found, or release/runtime proof is required. |
| **CORRECTION REQUIRED** | Naming, caption, tense, or claim is materially inaccurate. |

No capstone paper, source code, diagrams, or references were changed during this audit.

---

## A. Executive Summary

SENTINEL is substantially implemented as a role-governed security operations platform. The repository contains a React/TypeScript/Vite frontend, Rust/Axum backend, PostgreSQL-oriented schema initialization, 208 registered API routes, WebSocket tracking with polling fallback, and configured Capacitor Android and Tauri desktop wrappers. The paper is therefore no longer accurately described as a purely proposed system.

The paper broadly matches the implemented product in authentication, approval-gated guard onboarding, scheduling and attendance, firearm/permit workflows, vehicle and trip management, incidents, support, notifications, mapping, audit, feedback, profile, settings, and role-specific dashboards.

The highest-priority paper corrections are:

1. **Client identity mismatch:** the official client name is predominantly **Davao Security & Investigation Agency, Inc.**, but the General Objective says **Davao Security & Intelligence Agency, Inc.**
2. **Overstated compliance automation:** scheduling verifies an approved guard and prevents schedule conflicts, but it does not perform the paper's claimed universal automatic license and firearm authorization check before every deployment. Firearm allocation performs permit and firearms-handling training checks, with an explicit `force=true` override.
3. **Unsupported "firearm telemetry" claim:** the repository has firearm inventory/custody records, not GPS/IoT telemetry from firearms.
4. **Decision-support terminology:** replacement, incident severity, and vehicle-maintenance outputs are deterministic rule/formula-based services, not demonstrated machine-learning predictions or autonomous deployment decisions.
5. **Platform maturity:** Android and desktop packaging are configured, but this audit found no signed release artifact or installation/UAT proof. Tauri's current CSP also excludes `blob:` image URLs, which requires desktop validation for the current profile-photo crop/preview workflow.
6. **Proposal/final-document inconsistency:** the front matter and technology descriptions retain proposal/future-tense language while the paper elsewhere states that functionality is implemented.
7. **Figure and module defects:** Figure 20 is captioned "Calendar Module" while its description is the Operations Map module. The Superadmin diagram/text implies editable role/permission policy administration, while permissions are currently static in backend/frontend code.

**Audit conclusion:** The paper is not ready for a final "as-built" submission without a controlled revision pass and human confirmation of platform-release evidence, organizational naming, compliance-policy wording, and reference verification.

---

## B. Current System Inventory

| Domain | Current implementation evidence | Audit status |
|---|---|---|
| Identity, sessions, legal gating | Login, refresh-token rotation/revocation, logout, account lockout, reset flows, audit logging, legal-consent fields, and approval state are implemented in `DasiaAIO-Backend/src/handlers/auth.rs` and `handlers/legal.rs`. | ALIGNED |
| Role governance | Four real roles are ranked `guard < supervisor < admin < superadmin`; permissions and target-role controls are enforced server-side in `src/utils.rs` and user handlers. | ALIGNED |
| Guard identity | PostgreSQL-backed `G-####` guard codes are generated, backfilled, constrained, returned by the API, and searchable in selector UI. | ALIGNED |
| Workforce operations | Shift creation, conflicts, approved-guard validation, attendance/check-in/out, no-show detection, availability, and replacement workflow routes exist in `handlers/guard_replacement.rs`. | ALIGNED, with automation limits |
| Firearm compliance and custody | Firearms, permits, allocation/return, maintenance, overdue checks, and valid-permit/training checks are implemented. | ALIGNED, with override caveat |
| Vehicle operations | Armored-car/vehicle records, plate number, allocation, guard-driver assignment, trips, and maintenance endpoints are implemented. | ALIGNED |
| Field and support workflows | Guard dashboard, incident reporting, panic escalation, emergency contacts, offline queue, support tickets, notifications, missions, and operational requests are present. | ALIGNED |
| Situational awareness | Leaflet/OpenStreetMap command map, client sites, geofences, consent, heartbeats, points, active guards, history/path playback, WebSocket delivery, and polling fallback are implemented. | ALIGNED |
| Analytics / decision support | Analytics, merit, absence-risk, replacement suggestions, vehicle-risk, incident-severity, incident-summary, and audit anomaly routes exist. Current classification/scoring logic is rule/formula based. | PARTIAL for predictive/AI wording |
| Governance and feedback | Audit timeline/anomaly views, health/system version routes, inboxes, notification triage, feedback submission and feedback dashboard are implemented. | ALIGNED |
| User experience infrastructure | Shared modal, confirmation, toast/feedback patterns, searchable selectors, switch controls, profile/settings, responsive shell/sidebar, and focused regression tests exist. | ALIGNED |
| Web platform | React 18, TypeScript, Vite, Tailwind CSS, component/hook architecture and web deployment scripts are present. | ALIGNED |
| Desktop platform | Tauri configuration produces MSI/NSIS targets and consumes the built frontend. Installer/UAT evidence was not audited. | CONFIGURED; release validation required |
| Android platform | Capacitor Android wrapper, native geolocation/push/status-bar/secure-storage dependencies, and release build scripts are present. Signed-release/UAT evidence was not audited. | CONFIGURED; release validation required |

---

## C. Discrepancy and Update Matrix

| Paper section / claim | Current implementation | Status | Evidence | Recommended paper update |
|---|---|---|---|---|
| Title pages and Purpose: "Davao Security and Investigation Agency, Inc." | This is the predominant product/repository identity. | ALIGNED | `SENTINEL - Group 8.md:1,127,132` | Retain after client confirmation of official legal styling. |
| General Objective: "Davao Security & Intelligence Agency, Inc." | Conflicts with title/purpose wording. | CORRECTION REQUIRED | `SENTINEL - Group 8.md:145` | Replace "Intelligence" with "Investigation." |
| "Centralizing personnel profiles, firearm telemetry, and shift logs" | Firearm inventory, permits, allocations, maintenance, and custody are implemented; no firearm GPS/IoT telemetry integration was found. | CORRECTION REQUIRED | `handlers/firearm_allocation.rs`; paper `:127` | Use "firearm inventory and custody records," unless physical telemetry is later integrated. |
| "Before a guard can be deployed, the system automatically verifies their license validity and firearm authorization" | Shift creation requires an approved guard and checks overlap; firearm allocation separately checks active permit and firearms-handling training. | PARTIAL | `guard_replacement.rs:116-170`; `firearm_allocation.rs:58-97` | State the two controls separately. Do not claim a universal schedule/deployment gate. |
| "Immediately flags vacancy and identifies nearest qualified replacement" | No-show detection/replacement routes and scored suggestions exist. Suggestions rank eligible guards by reliability, availability, and last-known distance; deployment remains a human workflow. | PARTIAL | `main.rs:783-806`; `replacement_scoring_service.rs:148+` | Say "supports detection and ranked replacement recommendations," not autonomous or guaranteed immediate replacement. |
| WebSocket-plus-polling tracking model | Frontend opens `/api/tracking/ws` and retains 30-second fallback loading; backend exposes tracking WebSocket route. | ALIGNED | `useOperationalMapData.ts:483-616`; `main.rs:1680` | Retain; describe as near-real-time rather than an unconditional real-time guarantee. |
| "Decision support" / "prediction" language | Incident severity is keyword rules; vehicle risk is a documented weighted heuristic; replacement is a transparent weighted formula. | PARTIAL | `incident_severity_classifier.rs`; `vehicle_predictive_service.rs`; `replacement_scoring_service.rs` | Call these "rule-based decision-support and risk-scoring outputs." Do not imply ML/AI without a model, evaluation, and data governance evidence. |
| Scope: Web, Desktop, Android delivery | Web is implemented. Tauri and Capacitor wrappers/build scripts are configured. No artifact, signing, installation, or role-workflow UAT evidence was reviewed. | PARTIAL | `apps/desktop-tauri/src-tauri/tauri.conf.json`; `apps/android-capacitor/package.json` | Describe wrappers as implemented/configured only after release proof is attached; otherwise say "targeted platforms." |
| Platform parity | Tauri CSP permits `data:` images but not `blob:`; current profile image crop/preview uses Blob/File workflows. | UNVERIFIED | `tauri.conf.json`; frontend profile-photo components | Add a limitation until desktop photo workflow passes packaged-app UAT. |
| "Superadmin manages role and permission policy administration" | Role permissions are static code maps; no dynamic role/permission policy administration surface was found. | PARTIAL | `utils.rs:248-325`; `frontend/src/utils/permissions.ts:18-68` | State "governs users and role-scoped access" or implement/administer dynamic policy management before claiming it. |
| "All users ... access to a release-oriented documentation portal" | Release documents/scripts exist in the repository; no authenticated user-facing documentation portal was found. | UNSUPPORTED / UNVERIFIED | `package.json`; repository docs | Remove this functional requirement or document a real in-product portal. |
| Supervisor functional requirement includes request approval | Supervisor can create/view operational requests but backend permission map does not grant review/fulfill approval rights. | CORRECTION REQUIRED | `utils.rs:285-302`; `main.rs:1178-1193` | State that admins/superadmins review requests; supervisors create/view and coordinate operational work. |
| Firearm permit compliance | Active, unexpired permit and valid firearms-handling training are checked before normal allocation. | ALIGNED with caveat | `firearm_allocation.rs:58-97` | Retain, but document the authorized `force=true` override and audit/control policy. |
| Firearm/vehicle "telemetry" / physical hardware | Paper limitation correctly excludes third-party hardware, CCTV, IoT, and access control. | ALIGNED if terminology corrected | paper `:229+` | Keep limitation and remove conflicting "firearm telemetry" phrase. |
| Guard offline continuity | Offline queue is implemented for high-priority guard actions, not every workflow. | ALIGNED | `AGENTS.md` guard rules; `utils/offlineQueue.ts` | Retain "selected/partial offline continuity," not offline-complete operation. |
| Full training-record and geofence administration | Backend support exists; paper itself says some command surfaces remain incomplete. | ALIGNED | paper limitations; `main.rs:1060-1078,1731-1766` | Retain as an implementation limitation until end-user command surfaces are validated. |
| Figure 20 "Calendar Module" | Caption duplicates Figure 19 while text describes Operations Map. | CORRECTION REQUIRED | `SENTINEL - Group 8.md:497-500` | Rename Figure 20 and its module heading to "Operations Map Module." |
| Module descriptions "will serve" | Most listed modules already have source and routes. | CORRECTION REQUIRED | paper `:457-585`; backend routes and frontend components | Convert verified implementation descriptions to present/past tense once document status is confirmed. |
| Proposal front matter vs implemented-system claims | Document describes a proposal while many sections say "implemented/current." | CORRECTION REQUIRED | DOCX front matter; paper `:135,165,457+` | Human decision required: keep a proposal document, or update it to final/as-built documentation. |

---

## D. Six Specific Objectives Traceability

| Objective | Traceability finding | Status | Required documentation wording |
|---|---|---|---|
| 1. Secure approval-governed access, identity, sessions, recovery, legal compliance | Auth, lockout, reset, refresh-token rotation/revocation, approval state, and legal consent are implemented. | ALIGNED | Describe current controls, while avoiding unsupported claims about identity-proofing integrations. |
| 2. Scheduling, attendance, DTR, check-in/out, replacement coordination | Schedules, conflicts, attendance, DTR routes, no-show/replacement workflow and availability exist. Pre-deployment license/firearm validation is not integrated into every shift creation. | PARTIAL | Describe “approved-guard and schedule-conflict validation; separate permit controls for firearm allocation.” |
| 3. Firearm, permit, vehicle accountability | Inventory, allocation/return, permit expiry/revocation, maintenance, vehicles, drivers, trips and plates are implemented. Allocation has a force override. | ALIGNED with governance caveat | Mention the override only if policy allows it; otherwise remove it from product before final claims. |
| 4. Field operations, incidents, emergency, requests, notifications, live monitoring | Guard dashboard, SOS, incident/support, notifications, maps, tracking consent and offline queue are implemented. Location accuracy remains device/network-dependent. | ALIGNED | Retain device/GPS/network limitation. |
| 5. Performance evaluation and analytics | Merit/evaluation and reporting features exist; current “predictive” outputs are deterministic formula/keyword rules. | PARTIAL | Replace AI/predictive language with “rule-based analytical and decision-support outputs.” |
| 6. Traceable Web/Desktop/Android with audit and reports | Audit/forensics and web system are supported. Desktop/Android are configured; this audit does not certify release artifacts or platform parity. | PARTIAL | Separate “implemented web system” from “configured packaging targets pending release validation.” |

---

## E. Role and Permission Matrix

| Capability | Guard | Supervisor | Admin | Superadmin | Implementation note |
|---|---:|---:|---:|---:|---|
| Own dashboard, schedule, field actions, notifications | Yes | N/A | N/A | N/A | Guard workspace is self-scoped. |
| Create guard account | No | Yes, guard only | Yes, lower-ranked roles | Yes, lower-ranked roles | Server enforces rank; supervisor-created guard is pending approval. |
| Approve/reject supervisor-created guard | No | No | Yes | Yes | Rejection reason required. |
| Edit user records | Self-scoped | Yes, subject to role hierarchy | Yes | Yes | Backend enforces target-role hierarchy. |
| Delete user account | No | No | Yes | Yes | Supervisor denial is backend-authorized, not only hidden in UI. |
| Manage schedules / attendance / replacement | Own attendance only | Yes | Yes | Yes | Shift creation requires supervisor minimum role. |
| Manage firearms, permits, allocation, maintenance | No | Yes | Yes | Yes | Backend routes have role middleware/minimum role guards. |
| Manage vehicles, drivers, trips | No | Yes | Yes | Yes | Guard-as-driver association uses guard account/location, not vehicle GPS hardware. |
| Submit operational request | Yes | Yes | Yes | Yes | Guard/supervisor can submit. |
| Review/approve/reject operational request | No | No | Yes | Yes | Paper must not assign this approval permission to supervisor. |
| View analytics / merit | Own/self-scoped merit | Yes | Yes | Yes | Scope varies by endpoint/UI. |
| Audit / forensic governance | No | Not command-level audit role | Limited by navigation/endpoint | Yes | Paper should verify every claimed admin audit view separately. |
| Edit the role-permission model | No | No | No dynamic UI found | No dynamic UI found | Static code permissions; governance is role-scoped user administration, not policy editing. |

**Backend evidence:** `DasiaAIO-Backend/src/utils.rs:248-340`, `handlers/users.rs:177-325,387-544`, and protected routes in `src/main.rs`.

---

## F. Scope Alignment

### Implemented or strongly evidenced within scope

- Role-governed accounts, approval workflow, guarded API routes, audit/security events, consent, sessions, resets, and health checks.
- Personnel profiles, guard codes, schedules, attendance, DTR support, availability, no-show/replacement workflow, merit and evaluation.
- Firearm inventory, allocation/return, permits, expiry/revocation, maintenance and custody history.
- Armored vehicles, plate numbers, allocation, guard-driver assignment, trips and maintenance.
- Missions, incidents, panic escalation, support tickets, notifications, inbox triage, feedback and operational requests.
- Tracking consent, GPS/application-originated location points, active roster, client sites, geofences, live map, history/playback, WebSocket and fallback polling.
- Operational analytics, transparent risk/scoring services, audit timeline/anomalies, profile/settings and responsive shell navigation.

### Scope that needs narrower wording or proof

- “Real-time” should be qualified as near-real-time and dependent on active device/network updates.
- “Decision support” is accurate; “AI,” autonomous detection/deployment, and predictive-model claims are not supported by current services.
- “Desktop and Android delivery” is correct as configured targets, but release parity needs artifact/UAT evidence.
- “Release governance records” and repository release scripts are not the same as an end-user release portal.
- “Forensic anomaly/case sequencing” needs a workflow/UAT demonstration; audit/anomaly endpoints alone do not prove a fully managed case system.

---

## G. Limitation Alignment

| Paper limitation | Audit result | Action |
|---|---|---|
| No direct payroll, HR, government-license, CCTV, IoT, or access-control integrations | Supported by repository inspection; no external hardware/government integration was identified. | Keep. |
| Location quality depends on application GPS, network and IP fallback; offline is partial | Consistent with browser/device location and selected offline queue behavior. | Keep; do not promise exact real-time location. |
| Training and full geofence administration are backend-supported but not fully exposed in end-user surfaces | Consistent with available routes and current UI-surface limitations. | Keep until validated UI work is complete. |
| Shared panels/tabs/overlays instead of independent pages | Consistent with current dashboard architecture. | Keep if assessing implementation maturity. |
| Missing: physical firearm/vehicle tracking hardware | Necessary because current “telemetry” wording conflicts with the no-IoT limitation. | Add or correct the telemetry claim. |
| Missing: platform release validation | Android signing and desktop installer behavior are not proven by configuration alone. | Add as release limitation until artifacts/UAT are attached. |
| Missing: deterministic analytics limitation | Risk/incident/replacement services use transparent rules/formulas, not trained predictive models. | Add if paper uses predictive/AI language. |
| Missing: authorized force override for firearm allocation | `force=true` can bypass ordinary permit/training gate. | Document operational governance or remove/limit override before final defense. |

---

## H. Functional Requirements by Role

| Role | Paper-aligned requirements that can be retained | Requirements to revise or validate |
|---|---|---|
| All users | Admin-mediated access, secure authentication, reset, role controls, legal acceptance, profile/settings, feedback. | “Release-oriented documentation portal”; cross-platform runtime availability must be evidenced, not assumed. |
| Superadmin | Global dashboard, analytics, audit/forensic review, notifications, feedback dashboard, operational governance. | Do not claim dynamic policy/permission editing unless it is implemented. |
| Admin | User/approval management, scheduling, asset/compliance lifecycle, request review, ticket/notification handling, feedback. | Verify each claimed dashboard/report screenshot is current before inclusion. |
| Supervisor | Schedules, attendance/no-show workflow, replacement coordination, tracking/map, analytics, tickets/notifications, resource management, feedback. | Remove operational-request approval/rejection from supervisor requirement. Clarify no user deletion and guard-only account creation. |
| Guard | Personal schedules/resources, attendance actions, self-scoped tracking with consent, incident/support/notification workflows, panic escalation, feedback. | Describe offline behavior as selected high-priority actions; avoid claiming all features are available offline. |

---

## I. Module Alignment

| Paper module / figure | Current status | Documentation action |
|---|---|---|
| 12 User Login | Implemented | Convert future tense to present/as-built tense after document-status confirmation. |
| 13 Superadmin | Implemented workspace | Remove dynamic permission-policy administration implication. |
| 14 Administrator | Implemented workspace | Update screenshot and present tense. |
| 15 Supervisor | Implemented workspace | Reflect backend limits: no deletion; creates guard accounts pending admin approval. |
| 16 Guard | Implemented workspace | Retain mission/attendance/SOS, qualify offline and location constraints. |
| 17 Approvals | Implemented | Identify eligible reviewer roles accurately. |
| 18 Scheduling | Implemented | Do not claim universal license/firearm gate. |
| 19 Calendar | Implemented | Verify screenshot/current behavior. |
| 20 Operations Map | Implemented, but mislabeled as Calendar | Correct caption/title. |
| 21 Management | Implemented resource/user surface | Clarify role-specific actions. |
| 22 MDR Import | Backend/UI module present | State role restrictions and validate live import workflow. |
| 23 Missions | Implemented | Update screenshot/current terminology. |
| 24 Trips | Implemented | Explain driver-to-vehicle assignment uses selected guard/device location, not vehicle hardware. |
| 25 Inbox | Implemented role-aware panels | Retain. |
| 26 Support | Implemented | Retain. |
| 27 Feedback Submission | Implemented | Retain constrained rating/comment behavior. |
| 28 Feedback Dashboard | Implemented | Retain aggregate and record-level review. |
| 29 Firearms | Implemented | Retain inventory/custody wording, not telemetry. |
| 30 Firearm Allocation | Implemented | State active-permit/training checks and policy around override. |
| 31 Firearm Permits | Implemented | Retain expiry/revoke administration. |
| 32 Armored Cars | Implemented | Use one approved term consistently: vehicle/armored car. |
| 33 Maintenance | Implemented | Call risk logic heuristic/rule-based. |
| 34 Analytics | Implemented | Avoid unsupported ML/prediction claim. |
| 35 Audit | Implemented | Validate forensic/case terminology against actual UI before final text. |
| 36 Profile | Implemented | Revalidate profile photo/cropping on web, desktop, and Android before parity claim. |
| 37 Settings | Implemented | Retain role-aware notification/security/display settings only where runtime-supported. |

---

## J. Diagram Audit and Required Diagram List

### Existing diagrams

| Figure range | Audit finding | Required update |
|---|---|---|
| 1-4 Related systems | Literature/comparison figures, not current SENTINEL implementation diagrams. | Retain only after reference/source permission verification. |
| 5 Agile Model | Methodology diagram. | Ensure methodology tense matches project status. |
| 6 WBS and 7 Gantt | Planning artifacts. | Keep only if dates/status accurately represent the project lifecycle; label historical plan where appropriate. |
| 8 Guard activity | Broadly aligned. | Show consent/location failure and partial offline behavior accurately. |
| 9 Supervisor activity | Partially aligned. | Show human review of replacement recommendations, not autonomous nearest-guard deployment. |
| 10 Admin activity | Broadly aligned. | Verify actual request-review and asset-flow screens. |
| 11 Superadmin activity | Partially aligned. | Remove/qualify role-permission policy editing. |
| 12-37 Module figures | Most modules now exist. | Replace stale screenshots and future-tense descriptions; fix Figure 20 caption. |

### Recommended as-built diagrams before final submission

1. **System architecture diagram:** React/Vite frontend, Rust/Axum API, PostgreSQL, WebSocket tracking, external map tiles, deployment boundary, Capacitor, and Tauri.
2. **RBAC and approval sequence:** four roles, rank hierarchy, supervisor-created guard pending approval, admin/superadmin approval, deletion restriction.
3. **Authentication/session sequence:** login, legal-consent state, access/refresh tokens, rotation, logout/revocation, lockout/reset.
4. **Guard attendance and no-show/replacement flow:** schedule, approved guard, check-in/out, detection, ranked suggestions, human reassignment.
5. **Firearm compliance/custody flow:** inventory, permit/training check, issuance, return, maintenance; explicitly show any force-override control if retained.
6. **Location/tracking data flow:** guard device/browser location, consent, heartbeat, tracking point, WebSocket/polling, map, geofence and history playback.
7. **Vehicle/driver/trip flow:** selected guard as driver, vehicle assignment, trip lifecycle, maintenance record; no physical vehicle GPS assumption.
8. **Cross-platform release topology:** web, desktop target, Android target, backend/API and evidence gates for signed artifacts/UAT.

---

## K. Technology and Architecture Alignment

| Paper technology statement | Current repository evidence | Status / wording guidance |
|---|---|---|
| React + TypeScript + Vite | Frontend package/source structure supports this. | ALIGNED; present tense. |
| Tailwind CSS | Existing frontend styling uses Tailwind token classes and CSS variables. | ALIGNED; present tense. |
| Rust + Axum | Backend entrypoint registers 208 routes and uses Axum handlers/middleware. | ALIGNED; present tense. |
| PostgreSQL | `PgPool`, SQLx/PostgreSQL SQL, schema initialization and DB constraints are used. | ALIGNED; present tense. |
| OpenStreetMap + Leaflet | Operational map uses Leaflet and theme-aware Carto/OpenStreetMap-based tiles. | ALIGNED; present tense. |
| WebSocket with polling fallback | Backend WebSocket route and frontend reconnection/fallback polling are present. | ALIGNED; qualify network dependency. |
| Docker/Compose and controlled release | Repository release tooling/docs exist. Deployment correctness and current production environment were not audited. | PARTIAL; avoid “deployed” without evidence. |
| Tauri desktop | Config targets MSI/NSIS; updater disabled. | CONFIGURED; require packaged UAT. |
| Capacitor Android | Config/scripts/dependencies exist. | CONFIGURED; require signed APK/AAB and device UAT. |
| Resend/Railway/Namecheap | Mentioned in paper technology section, but runtime credentials/configuration were not audited. | UNVERIFIED; retain only with deployment evidence. |

**Mandatory tense correction:** the technology section's repeated “will be used” wording is inconsistent with the actual repository. Use present tense for verified as-built components and future tense only for unimplemented plans.

---

## L. Naming and Terminology Corrections

| Current wording | Issue | Required correction |
|---|---|---|
| Davao Security & Intelligence Agency, Inc. | Conflicts with title/purpose “Investigation.” | Confirm official name; use one exact name throughout. |
| Firearm telemetry | Implies connected physical location/telemetry hardware not evidenced in scope/code. | Use firearm inventory, custody, allocation, permit, and maintenance records. |
| Real-time | Could imply continuous guaranteed updates. | Prefer “near-real-time operational visibility based on application/device updates.” |
| Predictive / AI | Current services are rule/formula/keyword based. | Use “rule-based risk scoring” or “decision support.” |
| Nearest qualified replacement | Distance is one weighted input and data may be last-known/missing; a human accepts/reassigns. | Use “ranked available replacement candidates.” |
| Figure 20 Calendar Module | Duplicate/mistitled caption. | Rename Operations Map Module. |
| Armored Cars / vehicles | Both appear in system language. | Select client-approved canonical term and apply consistently. |
| Superadmin policy administration | Suggests runtime policy editor. | Use “system-wide role-governed oversight” unless dynamic policy management is added. |

---

## M. Tense and Document-State Audit

The paper currently mixes three incompatible states:

- **Proposal state:** title/front matter and many “will serve/will be used” statements.
- **Implementation state:** “implemented operational,” “current user-facing product,” and “was developed.”
- **Future roadmap state:** known incomplete end-user surfaces and packaging/release validation.

### Required human decision

Choose one document status before revising:

1. **Proposal document:** retain future tense and change/remove claims that report current implementation as completed.
2. **Final/as-built capstone document:** revise front matter and technical/module sections to present/past tense; retain future tense only in Limitations, Recommendations, and roadmap sections.

For an as-built final paper, use this pattern:

- **Present tense** for active system behavior: “SENTINEL enforces ...”
- **Past tense** for development/evaluation work: “The team implemented/tested ...”
- **Future tense** only for approved future enhancements: “A future release may ...”

---

## N. References and External Claims Requiring Verification

No web research was performed in this audit. The following must be checked against authoritative original sources before retention:

| Claim/reference area | Why verification is required |
|---|---|
| RA 11917, IRR interpretation, penalty amounts, strict-liability statements | Legal claims and financial penalties must be supported by the statute/official implementing rules, not an unsupported secondary summary. |
| Jur.ph 2025 legal assertions | Confirm source authority, wording, publication date, and that it supports the precise legal claim. |
| PIA 2025, NEDA XI 2024 regional/security statements | Confirm primary/publication source, exact geographic claim, and relevance to DASIA Tagum. |
| Abad 2025, Ondos and Origines 2025, Shiyanbola et al. 2023, Aguinis 2022, Al-Khafajiy et al. 2022, Khinvasara et al. 2024 | Confirm full bibliographic details, accessibility, peer-review/publication status, and that quotations/paraphrases are accurate. |
| Product/vendor references: TrackTik, Guardhouse, MySecuritas, Silvertrac | Confirm screenshots, product features, access dates, permission/fair-use handling, and comparison accuracy. |
| Scofield 2025 Rust/Axum and technology assertions | Replace broad performance/security promises with source-supported statements; do not infer workload capacity from language choice. |
| “Hundreds of guards,” “site vacancies may go undetected for hours,” and agency-specific operational facts | Require client-provided data, interview/protocol evidence, or qualified wording. |
| Namecheap, Railway, Resend, Android signing claims | Require current service/account/deployment evidence. Do not publish credentials, keys, or sensitive operational details. |

---

## O. Controlled Paper Update Plan

No step below has been executed. Each step should be reviewed and approved before document editing.

1. **Confirm document identity and status.** Confirm the official client name, whether the deliverable is proposal or final/as-built, and which environments are permitted to be represented as deployed.
2. **Correct critical facts first.** Fix Investigation/Intelligence mismatch, remove firearm telemetry claim, narrow automatic compliance/replacement language, correct request-review roles, and repair Figure 20 caption.
3. **Normalize scope, role matrix, and objectives.** Apply this audit's verified permission/workflow language and retain explicit limitations for offline, device location, hardware exclusion, unexposed command surfaces, heuristics, and release readiness.
4. **Update the architecture and workflow diagrams.** Replace stale module screenshots and add the eight as-built diagrams listed above. Use only verified flows and current UI/screens.
5. **Rewrite module and technology sections.** Apply the selected tense model; use current stack names only where source/configuration evidence exists; separate configured packaging from released platform evidence.
6. **Perform a reference and evidence pass.** Verify every external citation and legal/product claim, add access dates where required, and link screenshots/figures to the tested build/version.
7. **Run acceptance and release evidence.** Record the frontend/backend test suite results, web UAT, desktop installer UAT, Android signed-device UAT, and environment/deployment proof before claiming production-ready multi-platform delivery.
8. **Final consistency review.** Check titles, names, objectives, figures, tables, captions, acronym first use, tense, role labels, scope/limitations, references, and page numbering; then render the DOCX/PDF for visual QA.

---

## P. Human Confirmation Required Before Any Paper Revision

| Confirmation | Required decision / evidence |
|---|---|
| Official client name | Is the legal/project name exactly “Davao Security & Investigation Agency, Inc.” including ampersand, punctuation, and any acronym? |
| Document status | Is this still a proposal, or should it become a final/as-built capstone paper? |
| Platform claims | Which of Web, Windows desktop, and Android have completed release artifacts and representative role-based UAT? |
| Deployment claims | Which Railway/hosting/domain/email statements may be published as current facts? |
| Compliance policy | Is `force=true` firearm allocation an authorized operational override? If yes, who may use it and how is it audited? |
| Analytics terminology | Does the team want to document the current deterministic heuristics honestly, or is there a separately validated predictive/ML component not present in this repository? |
| Tracking policy | Confirm whether “near-real-time,” device-derived location, IP fallback, consent, and offline limits accurately reflect the client-approved behavior. |
| Screenshot/diagram evidence | Which build date/environment and accounts may be used for final figures without exposing personal or operational data? |
| Reference verification | Who will supply/approve authoritative legal, organizational, and research sources for citation validation? |

---

## Evidence Index

- Paper text baseline: `SENTINEL - Group 8.md:121-585`; DOCX baseline: `SENTINEL - Group 8.docx`.
- Role policy and rank controls: `DasiaAIO-Backend/src/utils.rs:223-340`.
- User lifecycle, approval, hierarchy, and guard-code API: `DasiaAIO-Backend/src/handlers/users.rs:177-544`.
- Guard-code schema generation and uniqueness: `DasiaAIO-Backend/src/db.rs:496-604`.
- Scheduling and approved-guard/conflict validation: `DasiaAIO-Backend/src/handlers/guard_replacement.rs:104-170`.
- Firearm issuance compliance checks: `DasiaAIO-Backend/src/handlers/firearm_allocation.rs:22-136`.
- Permit lifecycle: `DasiaAIO-Backend/src/handlers/permits.rs:16-200`.
- Replacement scoring: `DasiaAIO-Backend/src/services/replacement_scoring_service.rs:148+`.
- Incident classification: `DasiaAIO-Backend/src/services/incident_severity_classifier.rs`.
- Vehicle risk heuristic: `DasiaAIO-Backend/src/services/vehicle_predictive_service.rs`.
- API route registration: `DasiaAIO-Backend/src/main.rs:375-2007`.
- Operational tracking client: `DasiaAIO-Frontend/src/hooks/useOperationalMapData.ts:236-616`.
- Mobile wrapper: `apps/android-capacitor/capacitor.config.ts`, `apps/android-capacitor/package.json`.
- Desktop wrapper and CSP: `apps/desktop-tauri/src-tauri/tauri.conf.json`.
- Root release scripts: `package.json`.
