# Testing and Verification

## Frontend

- Unit/integration: Jest + Testing Library
- Browser E2E/smoke: Playwright
- Build gate: `npm run build`

## Backend

- Build/check: Cargo
- Tests: `cargo test`
- Runtime validation requires DB connectivity and env readiness

## Platform

- Desktop build path: root `build:desktop`
- Android build path: root `build:android`

## Current Verification Pattern

- Objective-critical smoke checks per phase
- Build + smoke evidence captured under docs readiness artifacts
