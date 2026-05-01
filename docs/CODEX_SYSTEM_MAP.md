# SENTINEL System Map (Codex Quick Reference)

High-signal map for fast orientation and safer edits.

## Core Repositories

- `DasiaAIO-Backend/`: Rust + Axum + PostgreSQL API
- `DasiaAIO-Frontend/`: React 18 + TypeScript + Vite + Tailwind v4
- `apps/desktop-tauri/`: desktop wrapper
- `apps/android-capacitor/`: Android wrapper

## Role Model

- `guard`
- `supervisor`
- `admin`
- `superadmin`

No general `user` role in active product behavior.

## Backend Entry Points

- Server bootstrap and route registration:
  - `DasiaAIO-Backend/src/main.rs`
- Runtime/env validation:
  - `DasiaAIO-Backend/src/config.rs`
- DB init/migrations:
  - `DasiaAIO-Backend/src/db.rs`
- Shared auth/RBAC helpers:
  - `DasiaAIO-Backend/src/utils.rs`
- AuthZ middleware:
  - `DasiaAIO-Backend/src/middleware/authz.rs`

## Frontend Entry Points

- App root:
  - `DasiaAIO-Frontend/src/App.tsx`
- Router:
  - `DasiaAIO-Frontend/src/router/index.tsx`
- Runtime API/platform config:
  - `DasiaAIO-Frontend/src/config.ts`
- Auth/session utilities:
  - `DasiaAIO-Frontend/src/utils/api.ts`
- Guard workspace:
  - `DasiaAIO-Frontend/src/components/guards/UserDashboard.tsx`
- Elevated shell:
  - `DasiaAIO-Frontend/src/components/layout/OperationalShell.tsx`

## Commonly Changed Domains

- Auth and approval:
  - `backend/src/handlers/auth.rs`
  - `backend/src/handlers/users.rs`
- Tracking/map:
  - `backend/src/handlers/tracking.rs`
  - `frontend/src/components/dashboard/OperationalMapPanel.tsx`
- Firearms lifecycle:
  - `backend/src/handlers/firearms.rs`
  - `backend/src/handlers/firearm_allocation.rs`
  - `frontend/src/components/FirearmInventory.tsx`

## Critical Constraints

- Preserve role normalization and permission checks.
- Keep `OperationalShell` visible for loading/empty/error states.
- Use semantic Tailwind tokens; avoid random hex styling.
- Keep API paths consistent with existing compatibility routes.

## Verification Baseline

From repo root:

```powershell
npm run verify:all
```

## Governance Docs

- Main capstone document:
  - `SENTINEL - Group 8.md`
- Engineering conventions:
  - `AGENTS.md`
- Full technical handoff:
  - `CHATGPT_SYSTEM_GUIDE.md`
