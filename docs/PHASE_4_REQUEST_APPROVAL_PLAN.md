# Phase 4 Plan: Service, Deposit, and Approval Requests

**Status:** Implemented on 2026-09-09; phase-specific acceptance passed. The complete 17-test browser suite is now green, including request pagination and new-request state isolation.
**Purpose:** Implement the panel-requested service/deposit request workflow as a complete, auditable lifecycle before refining Phase 5 analytics.
**Product sequence:** Phase 1 scope revision -> Phase 2 DTR -> Phase 3 firearm compliance -> **Phase 4 requests and approvals** -> Phase 5 analytics refinement.

## 1. Phase Outcome

SENTINEL will provide one controlled workflow for operational requests that currently have no complete approval lifecycle:

- A guard or authorized requester submits a service request or firearm/equipment deposit/return request.
- A supervisor, admin, or superadmin reviews the request according to the approved role policy.
- The reviewer approves, rejects, or returns the request for correction with a reason.
- An authorized operator fulfills the approved request when physical or operational action is required.
- The requester receives status updates.
- Every state change is recorded in a request history and the existing audit log.

The workflow must remain human-controlled. Approval must not silently create, allocate, return, or register an asset unless a separate fulfillment action explicitly performs that domain operation.

## 2. Current Baseline

The existing system has related but separate capabilities:

| Existing capability | Current limitation | Phase 4 treatment |
|---|---|---|
| Guard approval | Handles pending guard registrations only | Keep unchanged; do not reuse its user-specific schema as the request model |
| Support tickets | Guards can create and view tickets | Keep as support communication; do not treat a ticket as an approval request |
| Shift swaps | Has a separate pending/accepted/declined workflow | Keep separate; align status and audit patterns where useful |
| Firearm allocation/return | Authorized staff can issue and return firearms directly | Add approval-gated requests without bypassing existing allocation validation |
| Firearm maintenance | Authorized staff can schedule and complete maintenance | A service request may lead to maintenance, but approval and completion remain separate actions |
| Notifications | In-app user notifications exist | Add request-specific linkage and decision notifications |
| Audit logs | Write requests and authorization failures are logged | Add domain-level request events for readable status history |

Relevant implementation surfaces include:

- `DasiaAIO-Backend/src/main.rs`
- `DasiaAIO-Backend/src/db.rs`
- `DasiaAIO-Backend/src/models.rs`
- `DasiaAIO-Backend/src/handlers/users.rs`
- `DasiaAIO-Backend/src/handlers/support_tickets.rs`
- `DasiaAIO-Backend/src/handlers/notifications.rs`
- `DasiaAIO-Backend/src/middleware/authz.rs`
- `DasiaAIO-Backend/src/middleware/audit.rs`
- `DasiaAIO-Frontend/src/components/guards/UserDashboard.tsx`
- `DasiaAIO-Frontend/src/components/inbox/`
- `DasiaAIO-Frontend/src/components/layout/AppShell.tsx`
- `DasiaAIO-Frontend/src/components/layout/OperationalShell.tsx`
- `DasiaAIO-Frontend/src/components/Sidebar.tsx`

## 3. Scope

### In scope

1. Service requests for an operational service, repair, inspection, or maintenance need.
2. Firearm/equipment deposit or return requests, subject to the confirmed DSIA meaning of "deposit."
3. Firearm registration suggestions routed to a supervisor or authorized asset manager.
4. Requester submission, own-request history, correction, cancellation, and status visibility.
5. Reviewer inbox with filtering, detail review, approve, reject, and return-for-correction actions.
6. Fulfillment/completion tracking for requests that require a physical or system action.
7. In-app notifications and domain history.
8. Role authorization, duplicate prevention, validation, concurrency protection, and audit evidence.
9. Desktop and mobile-responsive web UI using the existing shell and design tokens.

### Out of scope

- Financial deposits, payroll, billing, or payment processing.
- Automatic firearm registration merely because a suggestion was approved.
- Automatic firearm allocation or return without an explicit fulfillment action.
- File attachments or document storage unless an existing approved storage service is provided.
- Replacing support tickets or shift swaps with the new request model.
- AI classification, AI recommendations, or external AI dependencies.
- New analytics metrics beyond the data needed to support Phase 5.

## 4. Decisions Required Before Coding

### Recorded implementation decisions

- **Deposit meaning:** non-financial surrender of an actively assigned firearm or equipment item into agency custody.
- **Requester roles:** every authenticated operational role may create its own request; requester identity always comes from the access token.
- **Approving roles:** supervisor, admin, and superadmin may review, but no requester may review their own request.
- **Supervisor scope:** supervisors currently see the full request queue because the database has no authoritative supervisor-to-guard/site ownership relation.
- **Fulfillment roles:** admin and superadmin only.
- **Registration behavior:** approval and completion remain human-recorded review tasks and never create a firearm record automatically.
- **Duplicate rule:** one active deposit/return request per requester, request type, and assigned resource. Separate service requests remain allowed because they can represent different operational needs.
- **Required fields:** all requests require type, subject, reason, and priority; deposit/return requires an assigned resource; firearm registration suggestions require identifying details.

These decisions affect schema constraints and must be confirmed with the adviser or DSIA representative before implementation:

1. **Deposit meaning:** Does "deposit" mean surrendering an issued firearm/equipment for custody, requesting an issue, or a different operational process? The initial plan assumes a custody deposit/return request, not a financial deposit.
2. **Requester roles:** The default proposal is guard-created requests, with elevated roles able to create on behalf of a guard only when explicitly permitted.
3. **Approving roles:** The default proposal is supervisor, admin, and superadmin review. A supervisor should be the normal first reviewer; admin/superadmin are escalation or override roles.
4. **Scope of supervisors:** If no supervisor-to-guard assignment relation exists, the first increment may show all requests to supervisors, with the limitation documented. Do not claim site-level isolation until a reliable organization relation exists.
5. **Fulfillment roles:** Confirm whether supervisors may fulfill requests or whether only admin/superadmin may perform asset changes.
6. **Registration request behavior:** An approved firearm registration request should create a review task, not a firearm record, unless the asset registration business rule is explicitly approved.
7. **Duplicate rule:** Confirm whether one open request is allowed per requester/resource/request type, per shift, or per operational event.
8. **Required details:** Confirm required fields for service type, resource identifier, urgency, target site, shift, and reason.

The implementation must not add database constraints for unresolved business rules. Until confirmed, use conservative server validation and record the assumption in the phase summary.

## 5. Roles and Permissions

Use normalized roles and explicit permissions. Do not infer permission from a frontend route or button visibility.

| Role | Allowed actions |
|---|---|
| Guard | Create own request, view own requests, view request history, cancel own pending request, update a returned request, resubmit corrected request |
| Supervisor | View review queue, view request details, approve, reject, return for correction, and fulfill only if explicitly authorized |
| Admin | Review and fulfill requests across operations; handle escalations and exceptions |
| Superadmin | Full request oversight, review, fulfillment, audit visibility, and emergency correction under existing governance controls |

Proposed permission keys:

- `create_operational_request`
- `view_own_operational_requests`
- `view_operational_requests`
- `review_operational_requests`
- `fulfill_operational_requests`
- `cancel_operational_request`

The backend must enforce both permission and ownership/scope. A guard must never be able to alter the requester, reviewer, status, decision reason, or resource identifiers through a client-controlled payload.

## 6. Request Types and State Machine

### Request types

The first increment uses a single request domain with a constrained type field:

- `service`
- `deposit`
- `return`
- `firearm_registration`

`firearm_registration` is a supervisor-facing registration suggestion. It does not automatically create an asset record.

### Statuses

- `pending`: submitted and awaiting review
- `needs_correction`: reviewer returned it to the requester
- `approved`: reviewer approved the request; fulfillment may still be pending
- `rejected`: reviewer denied the request with a reason
- `in_progress`: an authorized operator started fulfillment
- `completed`: fulfillment was recorded successfully
- `cancelled`: requester or authorized operator cancelled before completion

### Valid transitions

```text
pending -> approved
pending -> rejected
pending -> needs_correction
pending -> cancelled
needs_correction -> pending
needs_correction -> cancelled
approved -> in_progress
approved -> completed       (only for requests with no intermediate action)
approved -> cancelled
in_progress -> completed
in_progress -> cancelled   (with an operator reason)
```

Every transition must be validated on the server and persisted as one event. No endpoint may accept an arbitrary target status.

## 7. Data Model

### `operational_requests`

Add an idempotent startup migration or a governed migration consistent with the existing database bootstrap approach.

Proposed fields:

```text
id VARCHAR(36) PRIMARY KEY
request_type VARCHAR(40) NOT NULL
status VARCHAR(30) NOT NULL DEFAULT 'pending'
requester_id VARCHAR(36) NOT NULL REFERENCES users(id)
resource_type VARCHAR(40)
resource_id VARCHAR(36)
subject VARCHAR(255) NOT NULL
reason TEXT NOT NULL
details TEXT
priority VARCHAR(20) NOT NULL DEFAULT 'normal'
client_site_id VARCHAR(36)
shift_id VARCHAR(36)
operational_event_key VARCHAR(255)
reviewer_id VARCHAR(36) REFERENCES users(id)
reviewed_at TIMESTAMPTZ
decision_reason TEXT
fulfilled_by VARCHAR(36) REFERENCES users(id)
fulfilled_at TIMESTAMPTZ
created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
```

Add check constraints for allowed request types, statuses, and priorities. Add indexes for `(status, created_at DESC)`, `(requester_id, created_at DESC)`, `(request_type, status)`, and `(resource_id, status)`.

### `operational_request_events`

```text
id VARCHAR(36) PRIMARY KEY
request_id VARCHAR(36) NOT NULL REFERENCES operational_requests(id) ON DELETE CASCADE
actor_user_id VARCHAR(36) REFERENCES users(id) ON DELETE SET NULL
from_status VARCHAR(30)
to_status VARCHAR(30) NOT NULL
comment TEXT
metadata JSONB
created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
```

Index by `(request_id, created_at ASC)` and `(actor_user_id, created_at DESC)`.

### Notifications

Add a nullable `related_request_id` to `notifications` and index it. Existing notification clients must continue to work when it is null. Notification creation must be deduplicated per request, recipient, and event type where practical.

### Duplicate protection

After the business rule is confirmed, add a partial unique index or an equivalent transaction-safe deduplication key for active requests. Application-only duplicate checks are insufficient under concurrent submissions.

## 8. API Contract

Use `/api/operational-requests` to avoid collision with support tickets and existing approval routes.

| Method | Route | Purpose |
|---|---|---|
| POST | `/api/operational-requests` | Create a pending request |
| GET | `/api/operational-requests` | List requests using pagination and role scope |
| GET | `/api/operational-requests/:id` | View detail, current status, and history |
| POST | `/api/operational-requests/:id/approve` | Approve a pending request |
| POST | `/api/operational-requests/:id/reject` | Reject with a required reason |
| POST | `/api/operational-requests/:id/return-for-correction` | Return with a required correction note |
| POST | `/api/operational-requests/:id/cancel` | Cancel when the current role/state allows it |
| POST | `/api/operational-requests/:id/start` | Mark approved work as in progress |
| POST | `/api/operational-requests/:id/complete` | Record fulfillment and any linked domain action |
| GET | `/api/operational-requests/:id/events` | Return chronological request history |

### Request creation payload

```json
{
  "requestType": "service",
  "resourceType": "firearm",
  "resourceId": "optional-id",
  "subject": "Firearm inspection request",
  "reason": "Required inspection before next assignment",
  "details": "Additional operational details",
  "priority": "normal",
  "clientSiteId": "optional-id",
  "shiftId": "optional-id"
}
```

The server derives `requesterId` from the bearer token. Reviewer and fulfillment identities also come from the token. List endpoints must use `PaginationQuery` and return `{ total, page, pageSize, items }`.

### Decision payloads

```json
{ "reason": "Decision or correction explanation" }
```

Rejection, return-for-correction, and cancellation reasons are required where they affect another user or an operational record. Action endpoints must use an atomic conditional update such as `WHERE status = 'pending'` to prevent double approval.

## 9. Backend Work Packages

### B1. Schema and models

- Add the two request tables, indexes, constraints, and migration compatibility checks in `db.rs`.
- Add Rust request/event models and validated request payloads in `models.rs` or a dedicated request module.
- Keep all IDs generated server-side with `utils::generate_id()`.

### B2. Request service

Create a service module that owns:

- request validation by type and resource;
- legal transition validation;
- transaction creation of request plus initial event;
- transaction-safe decision updates;
- fulfillment coordination with firearm/equipment handlers when approved;
- notification fan-out;
- duplicate detection;
- history retrieval.

The service receives `&PgPool`, never `axum::State`.

### B3. Handlers and routes

- Add `handlers/operational_requests.rs` and declare it in the handler module.
- Return `AppResult<T>` for every handler and map database errors to `AppError`.
- Add route-level authz middleware and write-audit middleware in `main.rs`.
- Use bound SQL only; do not concatenate request filters into SQL.
- Enforce legal consent through the existing authorization middleware.

### B4. Authorization

- Add request permissions to the role permission map.
- Add middleware helpers for reviewer and fulfillment actions.
- Re-check ownership and current status inside each handler/service.
- Return `401` for missing/invalid authentication, `403` for insufficient role/permission, `404` for inaccessible records where appropriate, `409` for duplicate or stale transitions, and `422` or `400` for invalid payloads according to existing error conventions.

### B5. Notifications and audit

- Notify eligible reviewers when a request is submitted.
- Notify the requester on approval, rejection, correction, start, completion, and cancellation.
- Write a domain event for every valid transition.
- Preserve the existing middleware audit record for the API write.
- Never place full sensitive request details in notification text or audit metadata.

## 10. Frontend Work Packages

### F1. Shared request UI

Create a small request feature area using existing components and tokens:

- `components/requests/OperationalRequestsPage.tsx`
- `components/requests/RequestForm.tsx`
- `components/requests/RequestList.tsx`
- `components/requests/RequestDetail.tsx`
- `components/requests/RequestDecisionControls.tsx`

The page must support loading, empty, error, stale, submitting, conflict, and success states. All fetch effects must abort on cleanup.

### F2. Guard requester experience

- Add a Requests entry to the guard workspace or support area.
- Provide service/deposit/return/registration request type selection.
- Show only the guard's own requests.
- Provide request details, history, correction note, cancel, and resubmit behavior.
- Keep emergency controls and the guard sticky region unaffected.

### F3. Elevated reviewer experience

- Add request items to the existing Approvals view and role inboxes.
- Provide filters for status, type, priority, date, and requester.
- Show reason, resource, related site/shift, current state, and full event history before decision.
- Require a reason for rejection and return-for-correction.
- Disable controls after a successful decision and refresh the server record.
- Make stale/concurrent decisions show a clear conflict and reload option.

### F4. Navigation and deep links

- Add the request view to the existing route/view mapping and role-aware navigation.
- Keep `OperationalShell` visible for loading, empty, and error states.
- Add request links to notification and inbox actions.
- Use relative imports, semantic Tailwind tokens, familiar lucide icons, and mobile-safe controls of at least 44px height.

## 11. Execution Order

### Workstream 0: Confirm the contract

Deliverable: a short decision record containing the answers in Section 4, approved request types, roles, required fields, duplicate rule, and fulfillment policy.

Gate: no schema constraints or UI copy are finalized before this record exists.

### Workstream 1: Backend domain foundation

1. Add schema and idempotent migrations.
2. Add models and validation helpers.
3. Add request service and transition tests.
4. Add handler routes and permissions.
5. Add notifications and event history.

Gate: backend tests pass, unauthorized requests are rejected, and all transitions are atomic.

### Workstream 2: Requester UI

1. Build request form and list.
2. Connect guard ownership and correction flows.
3. Add detail/history view.
4. Add loading, error, conflict, and empty states.

Gate: a guard can create, view, correct, resubmit, and cancel a request without exposing another guard's data.

### Workstream 3: Reviewer UI

1. Add approval queue API loading.
2. Add request items to the existing inbox and Approvals view.
3. Add detail and decision controls.
4. Add filters and status refresh.

Gate: a reviewer can approve, reject, or return a request and the requester sees the updated state.

### Workstream 4: Fulfillment integration

1. Implement explicit start/complete actions.
2. Link firearm deposit/return completion to existing custody operations only after validating the current allocation state.
3. Keep firearm registration completion as a human-confirmed inventory action.
4. Record the linked asset operation in request history and audit logs.

Gate: no duplicate allocation, return, or registration occurs when completion is retried.

### Workstream 5: QA and release

1. Run unit and integration tests.
2. Run the disposable-database mutation workflow.
3. Run browser tests for guard, supervisor, admin, and superadmin.
4. Check desktop/mobile layouts and keyboard access.
5. Run the existing release verification scripts.
6. Update release-readiness and objective evidence documentation.

## 12. Verification Plan

### Backend tests

- Valid creation for each request type.
- Missing reason, subject, invalid type, invalid priority, and invalid resource rejected.
- Guard requester identity cannot be spoofed.
- Guard cannot list or mutate another guard's request.
- Reviewer-only actions reject guard tokens.
- Rejection and correction require a reason.
- Invalid state transitions return a controlled error.
- Two concurrent decisions produce one successful transition and one conflict.
- Duplicate active request rule is enforced after confirmation.
- Event history is chronological and immutable through public API routes.
- Notification recipient and deduplication behavior is correct.
- Fulfillment retry is idempotent and cannot double-issue or double-return an asset.

### Frontend tests

- Request payload and response parsing.
- Status-to-action mapping.
- Form validation and reason requirements.
- Error, empty, loading, stale, and conflict states.
- Role-specific action visibility.
- Request inbox item mapping and notification deep links.

### Browser acceptance scenarios

1. Guard submits a service request.
2. Supervisor sees it in Approvals/inbox.
3. Supervisor returns it for correction with a note.
4. Guard edits and resubmits it.
5. Supervisor approves it.
6. Authorized operator starts and completes it.
7. Guard sees the full timeline and completion notification.
8. Guard submits a firearm/equipment deposit or return request.
9. Reviewer rejects it with a reason; no asset state changes occur.
10. Duplicate pending submission is blocked with a clear message.
11. Unauthorized role attempts to view or decide another user's request.
12. The same workflow is checked at desktop and mobile widths.

### Evidence artifacts

- API request/response evidence with sensitive values redacted.
- Backend test output.
- Frontend test output.
- Disposable-database mutation audit JSON.
- Browser screenshots for requester, reviewer, decision, and history states.
- Audit-log rows and request-event rows showing the lifecycle.
- Updated `docs/RELEASE_READINESS_GUIDE.md` and objective traceability.

## 13. Risks and Controls

| Risk | Control |
|---|---|
| Ambiguous meaning of deposit | Confirm the business rule before schema constraints or fulfillment logic |
| A guard approves their own request | Enforce reviewer role and requester/reviewer separation in the backend |
| Double approval or double asset mutation | Conditional state updates, transactions, and idempotent fulfillment keys |
| Approval appears complete but physical action is not done | Separate `approved`, `in_progress`, and `completed` statuses |
| Existing support tickets become inconsistent | Keep support tickets separate and add clear labels/links |
| Supervisors see too much data | Use the approved scope rule; document temporary all-supervisor visibility if no relation exists |
| Notifications expose sensitive information | Use minimal text and link to an authorized detail page |
| Schema bootstrap breaks Railway/local startup | Use `IF NOT EXISTS`, additive migrations, and startup tests against an existing database |
| UI claims approval when the server rejected it | Refresh from server after each action and surface conflict/error responses |

## 14. Definition of Done

Phase 4 is complete only when all of the following are true:

- The approved request types and role policy are documented.
- Service and deposit/return requests have a complete server-enforced lifecycle.
- Request history and existing audit logs show every state transition.
- Reviewer decisions require authorization and appropriate reasons.
- Fulfillment is explicit, validated, and idempotent.
- Notifications reach the requester and eligible reviewers without duplication.
- Guard and elevated-role UI flows work on desktop and mobile.
- Existing guard approval, support ticket, shift swap, firearm, and analytics flows still pass regression tests.
- Mutation tests pass against a disposable database with cleanup verification.
- No unresolved page, console, request, authorization, or layout errors remain in the Phase 4 browser audit.
- The release-readiness guide and capstone objective evidence match the implemented behavior.

## 15. Next Action

Phase 4 implementation is complete. Keep the deployed release under observation, then begin Phase 5 analytics refinement using the new request history as an additional trusted operational data source.

## 16. Implementation Result

- Added idempotent request/event schema, request-linked notifications, constrained types/statuses/priorities, and transaction-safe active-resource duplicate protection.
- Added server-owned requester/reviewer/fulfiller identity, ownership-scoped reads, explicit RBAC middleware, fixed transition endpoints, reason requirements, and chronological event history.
- Added explicit custody fulfillment: completing a firearm deposit/return marks the active allocation returned and the firearm available in one transaction; equipment completion unassigns the item.
- Added guard and elevated request workspaces with submission, assigned-resource selection, correction/resubmission, cancellation, review, fulfillment, status/type/priority/requester/date filters, and history.
- Added the request queue to elevated role inboxes, Approvals, role navigation, deep links, and the guard sticky navigation without removing SOS or emergency contacts.
- Backend verification: 37 unit tests plus 17 integration/release-blocker tests passed; live API role and lifecycle probes passed; local database startup migration passed.
- Frontend verification: TypeScript passed, 26 Jest suites / 123 tests passed, production build passed, and the complete 17-test Playwright suite passed. Request pagination and new-request state isolation have regression coverage.
- Live mutation evidence covered submission, correction, resubmission, requester cancellation, supervisor approval, admin start/completion, authorization denials, event chronology, and atomic firearm custody return. Temporary records were cleaned up.
- Strict Clippy has no Phase 4 findings; it remains globally blocked by 27 pre-existing findings in unrelated modules.
