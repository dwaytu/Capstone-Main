# SENTINEL Security Operations Platform

[![Docs](https://img.shields.io/badge/Docs-GitHub%20Pages-2563eb)](https://dwaytu.github.io/Capstone-Main/)
[![Release](https://img.shields.io/github/v/release/dwaytu/Capstone-Main)](https://github.com/dwaytu/Capstone-Main/releases)
[![Release Workflow](https://github.com/dwaytu/Capstone-Main/actions/workflows/release.yml/badge.svg)](https://github.com/dwaytu/Capstone-Main/actions/workflows/release.yml)
[![Docs Workflow](https://github.com/dwaytu/Capstone-Main/actions/workflows/deploy-docs.yml/badge.svg)](https://github.com/dwaytu/Capstone-Main/actions/workflows/deploy-docs.yml)

SENTINEL is a role-governed security operations platform for Davao Security & Investigation Agency (DSIA). The platform unifies workforce operations, incident response, tracking intelligence, and governance workflows across Web, Desktop, and Android.

## Live Links

- Documentation: https://dwaytu.github.io/Capstone-Main/
- Web application: https://dasiasentinel.xyz/
- Latest releases (Desktop + Android artifacts): https://github.com/dwaytu/Capstone-Main/releases/latest

## Repository Topology

This workspace is a coordinated root repository with platform/service repositories:

- Root governance/release repo: `dwaytu/Capstone-Main`
- Frontend application repo: `dwaytu/DasiaAIO-Frontend`
- Backend API repo: `dwaytu/DasiaAIO-Backend`

Local structure:

```text
Capstone Main/
  DasiaAIO-Frontend/      React + TypeScript + Vite
  DasiaAIO-Backend/       Rust + Axum + PostgreSQL
  apps/desktop-tauri/     Desktop wrapper (Tauri)
  apps/android-capacitor/ Android wrapper (Capacitor)
  docs/                   GitHub Pages source
```

## Tech Stack

- Frontend: React 18, TypeScript, Vite, Tailwind CSS, Jest, Playwright
- Backend: Rust, Axum, SQLx, PostgreSQL, Tokio
- Packaging: Tauri (Desktop), Capacitor (Android)
- Delivery: GitHub Actions, GitHub Pages, Railway

## Quick Start

### 1. Prerequisites

- Node.js 20+
- npm 10+
- Rust stable toolchain
- PostgreSQL 14+

### 2. Install dependencies

```bash
npm install
npm install --prefix DasiaAIO-Frontend
```

### 3. Run development servers

Frontend:

```bash
npm run dev --prefix DasiaAIO-Frontend
```

Backend:

```bash
cd DasiaAIO-Backend
cargo run --bin server
```

## Build and Release Commands (Root)

```bash
npm run build:web
npm run build:desktop
npm run build:android
```

```bash
npm run release:web
npm run release:desktop
npm run release:android
npm run release:all
```

Verification:

```bash
npm run verify:all
```

## Deployment Model

- Production deployment is Railway-native, configured at the service level in Railway.
- Root CI remains responsible for release orchestration and documentation deployment.
- GitHub Pages serves directly from the `docs/` directory via `.github/workflows/deploy-docs.yml`.

## Security and Governance Notes

- Protected access is role-based: `guard`, `supervisor`, `admin`, `superadmin`.
- Legal-policy acceptance is enforced before protected workflows.
- Production backend startup enforces hardening checks (JWT secret strength, CORS, admin code policy).

## Documentation Index

- System docs: `docs/`
- Workspace navigation: `docs/WORKSPACE_NAVIGATION.md`
- Railway deployment runbook: `docs/RAILWAY_AUTODEPLOY.md`
- Product memory for AI sessions: `PROJECT_MEMORY.md`

## License

UNLICENSED (internal academic and organizational use).
