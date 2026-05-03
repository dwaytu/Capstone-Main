# Phase 3: Asset and MDR Integrity - Context

**Gathered:** 2026-05-03
**Status:** Ready for planning
**Source:** $gsd-discuss-phase 3

<domain>
## Phase Boundary

Stabilize existing asset, permit/compliance, and MDR import/review/commit flows under real operational usage. Scope is reliability and governance hardening only; no new product capabilities.

</domain>

<decisions>
## Implementation Decisions

### Asset source of truth
- Existing system records remain source of truth when MDR payload conflicts with persisted firearm, armored-car, or permit data.
- MDR conflicts are flagged for operator review and resolution; MDR data does not auto-overwrite authoritative records.

### MDR commit guardrails
- Commit is blocked if any staging row remains in `pending`, `ambiguous`, or `error` match state.
- Operator feedback must show:
  - unresolved counts by status,
  - explicit blocking reason,
  - actionable row-level path for remediation.

### Offline queue boundary (GRD-03)
- Queue must cover all guard-critical actions:
  - incident submission,
  - check-in/check-out,
  - SOS,
  - tracking consent updates.

### Offline replay policy
- Retry strategy: exponential backoff + maximum attempts + explicit manual retry path after max retries.
- Conflict policy on replay: server wins; failed queued items remain visible with failure reason and retry controls.

### Degraded behavior policy
- Fail-open reads, fail-closed writes.
- Read surfaces should remain available with degraded-state messaging.
- Mutating operations must not silently succeed when backend validation/path is unavailable.

### Phase priority
- Balanced execution across MDR integrity, asset/permit compliance, and offline queue reliability.

</decisions>

<canonical_refs>
## Canonical References

Downstream agents MUST read these before planning or implementing.

### Phase governance and requirements
- `.planning/PROJECT.md` - project scope, constraints, and objective boundaries.
- `.planning/REQUIREMENTS.md` - GRD-03, AST-01, AST-02, AST-03 requirement targets.
- `.planning/ROADMAP.md` - phase boundary and plan split (03-01, 03-02).

### Frontend workflow surfaces
- `DasiaAIO-Frontend/src/components/mdr/MdrBatchReview.tsx` - unresolved count UX, resolve actions, commit/reject controls.
- `DasiaAIO-Frontend/src/components/mdr/MdrImportPage.tsx` - MDR role exposure and entry flow.
- `DasiaAIO-Frontend/src/utils/offlineQueue.ts` - queued action persistence/retry mechanisms.
- `DasiaAIO-Frontend/src/components/guards/UserDashboard.tsx` - guard action surface for queued operations.

### Backend workflow surfaces
- `DasiaAIO-Backend/src/handlers/mdr.rs` - MDR batch lifecycle endpoints and blocking semantics.
- `DasiaAIO-Backend/src/services/mdr_import_service.rs` - staging match logic and commit validation.
- `DasiaAIO-Backend/src/handlers/firearms.rs` - firearm lifecycle API behavior.
- `DasiaAIO-Backend/src/handlers/armored_cars.rs` - armored-car lifecycle and allocation behavior.
- `DasiaAIO-Backend/src/handlers/permits.rs` - permit/compliance workflow behavior.

### Evidence baseline
- `docs/plan/capstone-readiness-20260502/evidence/phase2-workflow-smoke-report.md` - latest role workflow baseline before asset/MDR hardening.

</canonical_refs>

<specifics>
## Specific Ideas

- Preserve panel-facing trust: when commit is blocked, reason must be explicit and traceable to unresolved rows.
- Avoid hidden auto-merge behavior for MDR conflicts; require deterministic operator intervention.
- Keep guard workflow safe under intermittent network by preserving failed queue entries with clear retry semantics.

</specifics>

<deferred>
## Deferred Ideas

- None. New capability proposals remain out of scope for this phase.

</deferred>

---

*Phase: 03-asset-and-mdr-integrity*
*Context gathered: 2026-05-03 via discuss-phase*
