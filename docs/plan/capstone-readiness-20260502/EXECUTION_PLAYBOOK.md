# Capstone Proposal/Defense Execution Playbook

## Goal

Convert SENTINEL from "feature-rich" to "panel-defensible" by proving every specific objective with reproducible evidence.

## Phase 1 - Objective Baseline (Day 1)

1. Freeze objective wording from `SENTINEL - Group 8.md`.
2. Assign objective owners (backend/frontend/qa/security/release).
3. Set objective status baseline in `OBJECTIVE_COMPLIANCE_MATRIX.md`.

Exit gate:

- All 14 objectives have owners and initial status.

## Phase 2 - Evidence-First Validation (Day 2-4)

1. Run automated checks:

```powershell
npm run verify:capstone:quick
```

2. Collect manual cross-platform artifacts for objective flows not automatable.
3. Fill `EVIDENCE_REGISTER_TEMPLATE.md` entries.

Exit gate:

- Every objective has at least one evidence entry.
- Objectives 3, 9, 11, 13, 14 have Android + Web/Desktop evidence.

## Phase 3 - Gap Closure Sprint (Day 5-8)

Priority order:

1. Governance/security blockers (1, 5, 12, 14)
2. Operational continuity blockers (3, 9, 11)
3. Platform parity blockers (13)
4. Remaining partials

Rules:

- Fix only objective blockers.
- Each fix must add/refresh evidence in `evidence/`.

Exit gate:

- No objective remains `FAIL`.

## Phase 4 - Full Gate Validation (Day 9-10)

1. Run full readiness gate:

```powershell
npm run verify:capstone:full
```

2. Confirm latest report artifacts:
   - `latest-readiness-report.json`
   - `latest-readiness-report.md`
3. Reconcile report with objective matrix and evidence register.

Exit gate:

- Automated gate passes.
- Matrix + evidence register are aligned with report output.

## Phase 5 - Defense Pack Finalization (Day 11-12)

Deliverables:

1. Objective compliance matrix (final)
2. Evidence register (final)
3. Readiness report (latest)
4. Demo script mapped by objective
5. Known limitations and mitigations (if any)

Exit gate:

- Team can answer every panel question with objective reference + evidence artifact.

## Daily Cadence

1. Start: run `verify:capstone:quick`
2. Work: close highest-risk objective gaps
3. End: update matrix + evidence register
4. Freeze: no undocumented changes

