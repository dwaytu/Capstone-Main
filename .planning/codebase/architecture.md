# Architecture Summary

SENTINEL uses API-first architecture with a Rust backend and React frontend. The frontend consumes protected REST routes and renders role-governed operational shells and modules. Platform wrappers (desktop/android) package the same web application runtime.

## High-Level Flow

1. User authenticates.
2. Frontend resolves role + route.
3. Operational shell renders role-relevant modules.
4. Frontend calls backend endpoints for staffing, incidents, tracking, assets, and compliance workflows.
5. Build/release workflows deliver web, desktop, and Android artifacts.

## Reliability Pattern

- Defensive frontend degraded states for missing/non-parity backend endpoints
- Backend guardrails on sensitive operations (auth, approvals, operational writes)
- Smoke + build verification gates in readiness/release flow
