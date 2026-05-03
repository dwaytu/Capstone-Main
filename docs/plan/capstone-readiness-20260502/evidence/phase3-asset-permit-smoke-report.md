# Phase 3 Asset + Permit Smoke Report

- Date: 2026-05-03
- Phase: `03-asset-and-mdr-integrity`
- Plan: `03-01`

## Scope

- Backend fail-closed write validation for firearms, armored cars, and permits.
- Frontend degraded-read and blocked-write operator messaging for asset/compliance views.

## Automated Smoke Results

1. `cd DasiaAIO-Backend && cargo test` -> PASS (39 tests passed, 0 failed).
2. `cd DasiaAIO-Frontend && npm run build` -> PASS.
3. `cd DasiaAIO-Frontend && npm test -- --runInBand` -> PASS (99 tests passed, 0 failed).

## Endpoint/Behavior Coverage

- `POST /api/firearms` now rejects invalid `status` with validation error.
- `PUT /api/firearms/:id` now rejects invalid `status` and empty `caliber` values.
- `PUT /api/armored-cars/:id` now rejects invalid armored-car status values.
- `DELETE /api/armored-cars/:id` now returns deterministic `not found` when target is missing.
- `POST /api/guard-firearm-permits` now validates:
  - guard existence and guard role,
  - optional firearm existence,
  - expiry date is later than issued date,
  - permit status allowlist.
- `PUT /api/guard-firearm-permits/:permit_id/revoke` now blocks already non-revocable permits.

## UI Coverage

- `FirearmInventory` shows degraded-read warning when inventory fetch fails.
- `GuardFirearmPermits` shows degraded-read warning when permit fetch fails.
- `ArmoredCarDashboard` shows:
  - degraded-read warning for inventory fetch degradation,
  - explicit blocked-write reason when allocation or maintenance writes are rejected.

## Outcome

- Status: PASS
- Objective mapping: AST-01 and AST-02 guardrails are implemented with explicit operator feedback and deterministic backend write behavior.
