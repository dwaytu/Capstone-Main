# Phase 3 MDR + Offline Queue Smoke Report

- Date: 2026-05-03
- Phase: `03-asset-and-mdr-integrity`
- Plan: `03-02`

## Scope

- MDR unresolved-row commit guardrails and operator-facing blocking detail.
- Guard offline queue replay reliability: exponential backoff, max attempts, and manual retry visibility.

## Automated Smoke Results

1. `cd DasiaAIO-Backend && cargo test` -> PASS (39 tests passed, 0 failed).
2. `cd DasiaAIO-Frontend && npm run build` -> PASS.
3. `cd DasiaAIO-Frontend && npm test -- --runInBand` -> PASS (99 tests passed, 0 failed).

## MDR Guardrail Coverage

- Backend service now computes unresolved breakdown (`pending`, `ambiguous`, `error`, `total`).
- `POST /api/mdr/batches/:id/commit` now returns deterministic block payload on unresolved rows:
  - HTTP 409
  - `status: blocked`
  - `reason: unresolved_rows`
  - unresolved counts by status.
- Commit service keeps fail-closed guard in place to block race-window unresolved commits.
- MDR review UI now surfaces unresolved breakdown counts and blocking reason directly.

## Offline Queue Coverage (GRD-03)

- Queue records now persist retry metadata (`attempts`, `maxAttempts`, `nextRetryAt`, `lastError`).
- Service-worker replay now:
  - processes only due actions,
  - applies exponential backoff,
  - preserves failed actions instead of deleting them,
  - stops retry escalation at configured max attempts.
- Guard dashboard now exposes:
  - pending queue count,
  - failed queue count,
  - manual reset/retry action for max-attempt entries.

## Queue Action Scope

Validated in code paths for:
- check-in,
- check-out,
- incident submission,
- SOS panic incident,
- tracking-consent grant/revoke updates.

## Outcome

- Status: PASS
- Objective mapping:
  - AST-03 commit-block and review signaling: PASS.
  - GRD-03 offline replay policy: PASS for retry/backoff/manual-retry mechanics and critical action persistence (including tracking-consent queue coverage).
