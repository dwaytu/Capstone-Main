# SENTINEL

## What This Is

SENTINEL is an integrated security operations platform for DSIA, delivered as a web SPA with desktop (Tauri) and Android (Capacitor) wrappers. It centralizes role-based command workflows across staffing, incidents, tracking, and asset governance.

This repository is the root governance workspace coordinating frontend, backend, docs, release, and capstone-readiness artifacts.

## Core Value

Provide reliable, role-governed operational decision support across web, desktop, and Android without breaking mission-critical command flows.

## Requirements

### Validated

- [x] Role-based auth and dashboards for `guard`, `supervisor`, `admin`, `superadmin`
- [x] Operational shell navigation and command-center dashboard surfaces
- [x] Backend API foundation (Rust/Axum + PostgreSQL) with protected operational routes
- [x] Multi-target build paths (web, desktop-tauri, android-capacitor)

### Active

- [ ] Close objective-critical workflow gaps discovered in capstone readiness checks
- [ ] Keep UI/UX parity and stability across elevated-role mobile + desktop shells
- [ ] Preserve guard mission-critical paths (SOS, incident report, map, offline queue)
- [ ] Maintain deployment reliability for GitHub + Railway release path

### Out of Scope

- Public self-registration reintroduction - violates governed onboarding model
- Decorative fake telemetry features - harms operational trust
- Net-new product verticals not tied to current capstone objectives

## Context

- Backend: `DasiaAIO-Backend` (Rust, Axum, sqlx/Postgres)
- Frontend: `DasiaAIO-Frontend` (React 18, TS, Vite, Tailwind tokenized theme)
- Governance docs and readiness evidence under `docs/` and root markdown files
- Platform wrappers under `apps/desktop-tauri` and `apps/android-capacitor`

## Constraints

- **Architecture**: Existing repo split and APIs are source of truth - must avoid disruptive rewrites.
- **Governance**: Capstone panel-facing docs must stay readable and non-dev-jargon heavy.
- **Security**: Auth, role checks, legal-policy gating, and auditability cannot regress.
- **Delivery**: Changes should remain compatible with existing Railway/GitHub release path.

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Treat this as brownfield planning, not a new product | Existing implementation and objectives already defined | ✓ Good |
| Use GSD for phased execution, keep AO disabled by default | Lower credit cost, retain structured delivery | ✓ Good |
| Keep scope tied to capstone objectives only | Prevent feature creep and proposal risk | ✓ Good |

---
*Last updated: 2026-05-03 after GSD brownfield initialization*
