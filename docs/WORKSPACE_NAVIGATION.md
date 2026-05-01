# SENTINEL Workspace Navigation

This guide is the fastest way to orient in the repository without scanning the full tree.

## Primary Folders

- `DasiaAIO-Frontend/`: React web app, shared UI for web/desktop/mobile wrappers.
- `DasiaAIO-Backend/`: Rust/Axum API, auth, operations logic, PostgreSQL access.
- `apps/android-capacitor/`: Android wrapper and release pipeline integration.
- `apps/desktop-tauri/`: Desktop wrapper and Tauri build/release integration.
- `docs/`: project documentation, design references, planning artifacts.
- `.github/`: AI routing instructions, skills, and release/workflow governance.

## Root Files You Will Use Often

- `AGENTS.md`: project operating rules and AI task routing.
- `PROJECT_MEMORY.md`: persistent cross-session context.
- `SENTINEL - Group 8.md`: capstone paper.
- `README.md`: product overview and run/release commands.
- `COPILOT.md`: detailed technical reference.

## Backend Orientation

- Entry: `DasiaAIO-Backend/src/main.rs`
- Config/env validation: `DasiaAIO-Backend/src/config.rs`
- DB bootstrap/migrations: `DasiaAIO-Backend/src/db.rs`
- Handlers: `DasiaAIO-Backend/src/handlers/`
- Services: `DasiaAIO-Backend/src/services/`
- Middleware: `DasiaAIO-Backend/src/middleware/`

## Frontend Orientation

- Entry: `DasiaAIO-Frontend/src/main.tsx`
- App shell/router: `DasiaAIO-Frontend/src/App.tsx`, `DasiaAIO-Frontend/src/router/index.tsx`
- Guard dashboard: `DasiaAIO-Frontend/src/components/guards/UserDashboard.tsx`
- Shared layout: `DasiaAIO-Frontend/src/components/layout/`
- API/runtime config: `DasiaAIO-Frontend/src/utils/api.ts`, `DasiaAIO-Frontend/src/config.ts`

## Common Commands

From repository root:

```powershell
npm run build:web
npm run build:desktop
npm run build:android
npm run verify:all
```

Backend local run:

```powershell
cd DasiaAIO-Backend
cargo run --bin server
```

Frontend local run:

```powershell
cd DasiaAIO-Frontend
npm run dev
```

## Workspace Presentation

Open `Capstone Main.code-workspace` for the curated multi-root view:

- `00 Root Governance`
- `01 Frontend`
- `02 Backend`
- `03 Apps`
- `04 Docs`

The workspace hides generated folders (`node_modules`, `target`, `dist`, `tmp`) and enables file nesting for cleaner browsing.
