# SENTINEL Release-Readiness Guide

**Purpose:** define the next controlled phase after the system bug audit: keep the fixes, complete the panel-requested functionality, prove the important workflows repeatedly, and prepare the application for a controlled pilot or release.

**Current baseline:** the full audit remediation, DTR increment, firearm compliance increment, and current-iteration browser acceptance audit are complete as of 2026-08-19. The next gate is functionality completion for the remaining in-scope workflows.

## 1. Target Outcome

The project is ready for a controlled pilot or release when:

- the active paper scope, architecture notes, and application use the same feature names;
- the frontend and backend compile under strict checks;
- automated tests pass with no dependency vulnerabilities;
- the live API starts against the current database schema;
- the critical workflows work for each role;
- the guard mobile safety layout has no overlap or horizontal overflow;
- every in-scope requirement is traceable to a working route, UI workflow, authorization rule, and regression check;
- remaining external dependencies are documented instead of being represented as completed functionality.

## 2. Scope of This Phase

### Included

- RBAC and account-management regression checks;
- schedule creation, local time conversion, overnight shifts, attendance, and no-show handling;
- incident and offline-queue behavior;
- performance metrics, evaluation, and graphical analytics;
- mobile guard controls, emergency contacts, and SOS placement;
- requirement-to-feature traceability;
- repeatable local verification and live smoke checks.

### Excluded

- new AI/LLM integrations;
- new major operational modules before the gate passes;
- production database changes without backup and rollback evidence;
- treating rule-based scores as automatic decisions. Supervisors and administrators retain final authority.

## 3. Post-Defense Implementation Roadmap

These are the five improvement phases from the panel recommendations. They are separate from the release-readiness gate: feature work follows this roadmap, while the gate verifies each completed increment before it is demonstrated or deployed.

### Phase 1: Documentation and Scope Revision

**Status:** Complete for the current paper revision; no further implementation work is required for this phase.

**Work:**

- Use the revised general and specific objectives as the single scope reference.
- Remove AI hybrid assistance from the active scope, objectives, system description, and presentation claims.
- Describe remaining automated outputs as deterministic rule-based analytics, risk indicators, or generated summaries.
- Keep historical AI references in protected Review of Related Literature and References sections only when required by the paper-maintenance rules.
- Keep the revised paper as the scope reference for implementation and acceptance testing.

**Completion evidence:** paper/objective cross-check, route scan, and active-scope verification.

### Phase 2: DTR and Attendance Enhancement

**Status:** Implemented in the current increment; live API and browser validation are complete.

**Work:**

- Generate Daily Time Record entries from transactional check-in and check-out records.
- Include scheduled start/end, actual check-in/out, late minutes, absence/no-show status, and total hours where available.
- Add a DTR report endpoint with guard, date-range, site, and status filters.
- Add an elevated-role DTR table with sorting, empty/error states, print layout, and CSV export.
- Keep the existing shift-specific, transactional, and idempotent attendance rules as the source of truth.

**Dependency:** attendance and no-show data must remain correct before report totals are trusted.

**Completion evidence:** API tests for date/filter boundaries, live endpoint probes, DTR desktop/mobile screenshots, and print/CSV controls in the elevated-role report.

### Phase 3: Firearm Compliance Enhancement

**Status:** Implemented for the current increment; live API and browser validation are complete.

**Work:**

- Added a consolidated firearm compliance report showing firearm status, current holder, permit status, maintenance status, and custody dates.
- Added configurable 1-to-365-day expiration windows with expired, expiring-soon, no-permit, maintenance, allocated, unallocated, and compliant filters.
- Added supervisor/admin notification synchronization with 24-hour duplicate suppression.
- Corrected firearm, permit, allocation, and allocation-view JSON responses to use the frontend camelCase contract.
- Added idempotent startup migrations for allocation return dates, notes, and issuer metadata required by existing allocation workflows.

**Completion evidence:** live report response for 132 firearms, invalid-window validation, notification synchronization, desktop/mobile browser smoke, CSV/print controls, and backend/frontend regression tests.

### Current Iteration Acceptance Audit

**Status:** Passed for the current implemented scope on 2026-09-17.

**Coverage:**

- Authenticated superadmin, admin, supervisor, and guard accounts.
- 85 desktop/mobile route checks across the role-specific route matrix.
- 382 safe browser control interactions, including filters, refresh, print, CSV export, calendar navigation, compliance alert synchronization, quick inbox, profile menu, responsive navigation, logout, and maintenance controls.
- No page errors, console errors, API errors, request failures, or horizontal overflow in the final audit.
- Destructive actions such as delete, suspend, approval, SOS, and record creation were intentionally excluded from this non-mutating audit and require controlled test fixtures for end-to-end mutation testing.

**Evidence:** `DasiaAIO-Frontend/test-results/system-audit/manual-functionality-audit.json` and screenshots in `DasiaAIO-Frontend/test-results/system-audit/`.

### Fixture-Based Mutation Audit

**Status:** Passed against a disposable clone of the local PostgreSQL database on 2026-09-17.

**Coverage:**

- Schedule creation, guard check-in, and guard check-out through browser UI clicks.
- Incident submission, support ticket submission, and feedback submission through browser UI clicks.
- Firearm allocation through the browser UI, followed by firearm return through the authenticated browser context.
- Firearm maintenance scheduling and completion through the authenticated browser context against the disposable test database.
- Guard approval and MDR import/reject through browser UI clicks.
- 12 mutation workflows passed with zero page errors, console errors, or API errors.
- The original attendance contract defect was fixed: the guard UI now sends `guardId`, `shiftId`, and `attendanceId` to match the Rust API.

**Evidence:** `output/mutation-audit/MUTATION-20260917155027.json` and `scripts/mutation-functionality-audit.mjs`. The shared `guard_firearm_system` database was not mutated; the disposable clone was dropped after the run.

**Resolved UI gap:** firearm return is now available from active allocation rows, while maintenance scheduling and completion controls are available from the maintenance view. Read-only browser verification confirmed the controls render and the scheduling form opens without page or API errors; destructive mutation execution remains covered by the disposable-database mutation audit.

### Phase 4: Request and Approval Enhancement

**Status:** Implemented on 2026-09-09. Phase-specific backend, frontend, live API, database migration, and browser acceptance checks passed. The full 17-test browser suite is green; the frontend CI workflow was also corrected to use Node 22 for the Jest Web API shim.

**Work:**

- Define request types for service requests and firearm/equipment deposits or returns.
- Add request creation with requester, item/service, reason, supporting details, and status history.
- Add supervisor/admin approval, rejection, return-for-correction, and audit events.
- Prevent duplicate pending requests for the same guard, item, and operational event where the business rule requires it.
- Show pending, approved, rejected, and completed requests in the appropriate inbox or approvals view.

**Dependency:** confirm the exact business rule and approving role with the adviser or DSIA representative before adding database constraints.

**Completion evidence:** request lifecycle test from submission to approval/rejection, authorization tests, and audit-log evidence.

### Phase 5: Analytics and Evaluation Enhancement

**Status:** Complete for the current trusted operational data set as of September 10, 2026.

**Work:**

- Show attendance rate, late check-ins, completed shifts, absences/no-shows, incident reports, supervisor and administrator guard evaluation results, merit score, and replacement frequency.
- Keep date filters and per-guard detail alongside summary KPIs and graphical reports.
- Show date-scoped guard evaluation summaries, rating distribution, and trend views using authenticated supervisor or administrator evaluator ownership.
- Label all scores as advisory metrics and preserve the underlying records used to calculate them.
- Show available and unavailable guards, firearms, and vehicles using operational status and assignment records.
- Revalidate the charts whenever attendance, compliance, or request lifecycle rules change their source data.

**Completion evidence:** `/api/analytics`, `/api/analytics/evaluations`, `/api/analytics/guard-performance-report`, metric calculation tests, and `npm run audit:phase5` desktop/mobile screenshots and browser assertions.

### Roadmap Sequence

1. Keep the Phase 1 paper scope frozen as the implementation contract.
2. Implement Phase 2 DTR reporting because it becomes the attendance source for later analytics. **Complete for this increment.**
3. Implement Phase 3 firearm compliance reporting and expiration notifications. **Complete for this increment.**
4. Phase 4 service/deposit request approval workflow. **Complete for this increment.**
5. Recalculate and refine Phase 5 analytics using the expanded trusted data. **Complete for this increment.**
6. Run the functionality-completion gate after each phase and freeze only after all required workflows pass.

## 4. Execution Order

### Phase A: Freeze the scope

1. Use the revised paper and approved objectives as the product contract.
2. Keep the panel-requested removal of AI hybrid assistance reflected in the active product scope and runtime terminology.
3. Describe remaining automated outputs as deterministic rule-based analytics, operational risk indicators, or generated text summaries. Do not describe them as an LLM or AI feature.
4. Record any new request as a post-gate backlog item instead of adding it during stabilization.

### Phase B: Run the quality gate

From the repository root:

```powershell
npm run verify:release
```

This runs TypeScript checking, frontend tests, the frontend production build, the dependency audit, backend compilation, backend tests, and Clippy. Clippy warnings are reported by Rust but the gate fails only when the command exits nonzero.

When Docker and the local backend are running:

```powershell
npm run verify:release -- -RequireApi
```

When the Vite server is running on port 5173 and local QA accounts exist:

```powershell
npm run verify:release -- -RequireApi -RunBrowserSmoke
```

The browser smoke command checks performance and DTR desktop/mobile, guard mobile/narrow-mobile, rendered content, API errors, page errors, horizontal overflow, and SOS/emergency-contact intersections. It writes screenshots to `DasiaAIO-Frontend/test-results/system-audit/`.

For non-default local accounts, set these environment variables before running the smoke check:

```powershell
$env:AUDIT_SUPERADMIN_IDENTIFIER = "your-local-superadmin"
$env:AUDIT_SUPERADMIN_PASSWORD = "your-local-password"
$env:AUDIT_GUARD_IDENTIFIER = "your-local-guard"
$env:AUDIT_GUARD_PASSWORD = "your-local-password"
```

The default credentials in the script are local QA defaults only. Never use them as production credentials.

### Phase C: Validate completed workflows

Use a clean seeded or approved QA database and execute this sequence:

1. Log in as superadmin and show role-based access.
2. Open the command center and show live operational summaries.
3. Open the Guard Performance Report and show date filters, KPI cards, graphical metrics, and the detailed table.
4. Create a schedule using local date/time values, then show that the saved shift is correct. Include one overnight example if asked.
5. Log in as a guard and demonstrate check-in, check-out, and the shift-specific attendance state.
6. Submit an incident with manual priority selection and show the incident lifecycle from open to resolved.
7. Demonstrate the guard mobile workspace, emergency contacts, and SOS control without overlapping controls.
8. Return to an elevated role and show approvals, firearm status/expiration information, and operational alerts.
9. Explain that scores and alerts support human review; they do not replace supervisor approval.

### Phase D: Capture evidence

For every gate run, record:

- date and commit/worktree identifier;
- command used;
- pass/fail result;
- screenshots or JSON output for UI smoke;
- database/environment used;
- any warning that does not block release;
- owner and due date for every failure.

Do not attach passwords, JWTs, production URLs with secrets, or private keys to evidence.

## 5. Acceptance Criteria

| Area | Pass condition |
|---|---|
| Authentication/RBAC | Unauthorized role escalation is rejected; approved self-service actions still work. |
| Users | Invalid dates, aliases, oversized profile data, and unauthorized updates are rejected without partial writes. |
| Scheduling | Only approved verified guards can be scheduled; local times and overnight shifts persist correctly. |
| Attendance | Check-in/out is shift-specific, transactional, and idempotent. |
| DTR reporting | Elevated roles can filter paginated DTR entries and use print/CSV actions without losing the source attendance status. |
| Firearm compliance | Elevated roles can review custody, permit, maintenance, and expiry status, filter the register, and synchronize deduplicated alerts. |
| No-shows | A missed shift creates one punctuality record and one notification event, even if detection runs repeatedly. |
| Analytics | Performance report returns attendance, lateness, completed shifts, no-shows, incidents, supervisor/admin guard evaluation, merit, and replacement metrics. |
| Offline actions | Only network/offline failures are queued; validation and authorization failures remain visible to the user. |
| Mobile safety | No horizontal overflow and no SOS/emergency-contact overlap at 390px and 320px widths. |
| Dependencies | `npm audit --audit-level=high` reports no high or critical vulnerabilities. |
| Documentation | Current routes and feature names do not claim an active LLM/Ollama integration. |

## 6. Panel-Comment Action Register

| Panel direction | Action | Completion evidence |
|---|---|---|
| Performance metrics in graphs | Keep the Guard Performance Report with KPI cards, SVG charts, date filters, and metric table. | Browser smoke plus screenshot and endpoint response. |
| Evaluation/analytics | Aggregate attendance, incidents, supervisor/admin guard ratings, merit, and replacements in one report. | `/api/analytics/guard-performance-report` and UI report. |
| DTR automation | Generate a filterable Daily Time Record from scheduled shifts, check-in/out, and punctuality records. | `/api/attendance/dtr`, DTR desktop/mobile screenshots, and print/CSV controls. |
| Firearm reports/expiration notices | Implement consolidated firearm compliance visibility and deduplicated expiry notifications. | Role-based API/UI evidence, seeded expiry cases, and notification records. |
| Service/deposit requests | Implement approval-gated request flows as a complete lifecycle. | Working route/UI evidence, authorization tests, and audit events. |
| Remove AI hybrid assistance | Keep external AI dependencies removed and use neutral rule-based terminology in active runtime behavior. | Route/documentation scan and deterministic output checks. |
| Summarize objectives | Keep the six revised objectives as the system requirement baseline. | Paper/objective cross-check and requirement traceability. |

## 7. Known Residuals

- `cargo clippy --all-targets` currently reports non-behavioral style warnings; these are cleanup work, not a failing compile/test gate.
- Vite may print dynamic/static import optimization warnings during build; the production build still completes.
- A live deployment requires real test accounts, explicit CORS configuration, production secrets, database backup evidence, and a rollback owner.
- Legacy database migration names may contain historical AI terminology. They are schema compatibility artifacts; current public routes and runtime behavior must remain neutral and deterministic.
- Android signed release validation remains a separate release step and requires the protected signing variables documented in `AGENTS.md`.

## 8. Go/No-Go Decision

**Go** only when all acceptance criteria pass and the controlled-pilot QA account is verified.

**No-go** when a required check fails, the API is using an unverified schema, the demo depends on a hidden manual database edit, or the paper/presentation claims a feature that is not visible in the build.

## 9. Immediate Next Actions

1. Keep the current Phase 4 release stable and monitor the Railway deployment.
2. Recalculate and refine Phase 5 analytics using the expanded trusted data.
3. Run `npm run verify:release -- -RequireApi -RunBrowserSmoke` after each increment.
4. Execute `npm run audit:functionality` with approved local QA accounts after each workflow change.
5. Freeze the build only after all required workflows pass; fix release-blocking defects afterward.
