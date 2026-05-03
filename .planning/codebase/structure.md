# Codebase Structure

## Monorepo Layout

- `DasiaAIO-Backend/` - Rust/Axum API service
- `DasiaAIO-Frontend/` - React/TypeScript web app
- `apps/desktop-tauri/` - Desktop wrapper
- `apps/android-capacitor/` - Android wrapper
- `docs/` - docs site, readiness packs, technical reports
- root markdown docs - governance, rollout, memory, capstone paper

## Runtime Targets

- Web browser SPA via Vite
- Desktop packaged through Tauri
- Android packaged through Capacitor

## Operational Role Model

- `guard`
- `supervisor`
- `admin`
- `superadmin`

No generic `user` role in current governance model.

## Build Entry Points

- Frontend dev/build: `DasiaAIO-Frontend`
- Backend build/run/test: `DasiaAIO-Backend`
- Platform build wrappers: root npm scripts + app-specific configs
