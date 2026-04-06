# AGENTS — SENTINEL Security Operations Platform

## Project Overview

SENTINEL is an integrated security operations platform for Davao Security & Investigation Agency (DSIA). Rust/Axum REST API + PostgreSQL backend, React 18 / TypeScript / Vite / Tailwind CSS frontend, packaged for desktop (Tauri) and mobile (Capacitor).

See [COPILOT.md](COPILOT.md) for detailed stack conventions, API routes, database tables, and env vars.

## Architecture

```
DasiaAIO-Backend/    Rust + Axum API (entry: src/main.rs → bin/server)
DasiaAIO-Frontend/   React 18 SPA (Vite, Tailwind CSS v4)
apps/android-capacitor/  Capacitor wrapper for Android
apps/desktop-tauri/      Tauri wrapper for desktop (Windows/macOS/Linux)
```

- Four roles: `guard`, `supervisor`, `admin`, `superadmin` — no `user` role exists.
- All new features must include: backend service, API endpoint, frontend component, and dashboard integration.
- UI style: SOC command-center dashboard with dark mode via CSS variables.

## Build and Test

| Area | Command | Notes |
|------|---------|-------|
| **Frontend dev** | `cd DasiaAIO-Frontend && npm run dev` | Port 5173 (strict) |
| **Frontend build** | `cd DasiaAIO-Frontend && npm run build` | Output: `app-dist/` |
| **Frontend tests** | `cd DasiaAIO-Frontend && npm test` | Jest + Testing Library |
| **Frontend E2E** | `cd DasiaAIO-Frontend && npm run test:e2e` | Playwright |
| **Backend build** | `cd DasiaAIO-Backend && cargo build` | Requires Rust toolchain |
| **Backend run** | `cd DasiaAIO-Backend && cargo run --bin server` | Needs `DATABASE_URL` |
| **Backend tests** | `cd DasiaAIO-Backend && cargo test` | — |
| **Android** | `npm run build:android` (root) | Builds web + Capacitor sync |
| **Desktop** | `npm run build:desktop` (root) | Builds web + Tauri |
| **Release (all)** | `npm run release:all` (root) | Orchestrates multi-platform |

## Conventions

### Backend (Rust / Axum)
- All handlers return `AppResult<T>` — never use `.unwrap()` in handlers; propagate with `?`.
- Always use `sqlx::query!` / `.bind()` — no raw SQL string concatenation.
- Paginated endpoints use `utils::PaginationQuery` → response shape: `{ total, page, pageSize, items }`.
- Normalize roles with `utils::normalize_role()` before comparison.
- Service modules (`src/services/`) receive `&PgPool` directly — do not use `axum::State` inside services.
- Each new module must be declared in the parent `mod.rs`.

### Frontend (React / TypeScript)
- Use semantic Tailwind token classes only (`bg-surface`, `text-text-primary`, `border-border`, etc.) — no scattered hex values. See [COPILOT.md § 3.4](COPILOT.md) for the full token table.
- `recharts` is **not installed**; use native SVG for small charts.
- Use relative imports — no `@/` alias (not configured in `vite.config.ts`).
- `useEffect` cleanup must cancel/abort in-flight fetches.
- Shell-based pages must keep `OperationalShell` visible for loading, empty, and error states (do not early-return bare content that drops sidebar/header chrome).
- Elevated-role mobile nav (`Dashboard`, `Approvals`, `Schedule`, `Alerts`, `More`) is primary in `OperationalShell` with `AppShell` fallback for non-OperationalShell routes; keep labels and order aligned.
- State: `useState` / `useEffect` only (no Redux).

## Pitfalls

- **CORS fallback chain**: In production, set `CORS_ORIGINS` explicitly or requests fail. Falls back to localhost allow-list in dev only.
- **Auth route duplication**: Both `/api/login` and `/api/auth/login` exist for backward compat—keep consistent when adding auth endpoints.
- **Rate limiting is per-route**, not global — each sensitive endpoint has its own limiter.
- **Private IP validation**: `config.ts` rejects `10.x`, `192.168.x`, `172.16–31.x` in production API URLs.
- **Platform detection**: `window.Capacitor` / `window.__TAURI__` — only available after mount.
- **CSS variable dependency**: All Tailwind colors depend on `--color-*` vars in `index.css`; changes cascade everywhere.
- **Manual chunk splitting**: Leaflet and lucide-react are separate Vite chunks — lazy-loading may cause hydration issues.
- **Firearm allocations API path**: use `/api/firearm-allocations` for list-style fetches. `/api/firearms/allocations` can be captured by `/api/firearms/:id` and surface noisy 404s in live polling.
- **Shift-swap feed parity**: some backend deployments may not expose `/api/shifts/swap-requests`; frontend is expected to degrade to unavailable mode without repeated polling noise.

## Release Governance

- The governed multi-platform release path is `.github/workflows/release.yml`; use it as the source of truth for release docs and artifact expectations.
- Android governed releases are signed-only and require `SENTINEL_ANDROID_KEYSTORE_BASE64`, `SENTINEL_UPLOAD_STORE_PASSWORD`, `SENTINEL_UPLOAD_KEY_ALIAS`, and `SENTINEL_UPLOAD_KEY_PASSWORD`.
- Root `.gitignore` already protects `*.keystore`, `*.jks`, and `sentinel-android-secrets.txt`; do not commit local signing artifacts.

## Guard-Specific Rules

- The live guard workspace is implemented in `DasiaAIO-Frontend/src/components/guards/UserDashboard.tsx`; avoid stale planning references to older guard dashboard paths.
- Guard shift-swap history can be unavailable or stale on some deployments; frontend changes should preserve manual request submission and non-blocking degraded states.
- **PanicButton** (`components/guards/PanicButton.tsx`): 1-tap SOS with GPS + offline queue. Always visible bottom-right of guard dashboard. Touch target is 64px (min-h-16).
- **EmergencyContactsBar** (`components/guards/EmergencyContactsBar.tsx`): Lives inside `guard-sticky-region`. Defaults expanded. Contact pills must be ≥44px tall (WCAG 2.5.8). Contacts sourced from `constants/emergencyContacts.ts`.
- **Emergency contacts** are centralized in `src/constants/emergencyContacts.ts` — single source of truth. Phone numbers are placeholders and must be configured for deployment.
- **Offline queue** (`utils/offlineQueue.ts`): IndexedDB-backed with Background Sync. All guard actions (check-in, check-out, incidents, SOS) use `enqueueOfflineAction()`. Pending badge polls every 5s via `getPendingCount()`.
- **Incident form**: 2 fields only (description + priority). Title auto-generated from first 50 chars. Location auto-filled from GPS state. Do not add fields back.
- **`--guard-sticky-region-height`** in `index.css`: Must account for EmergencyContactsBar (expanded, multi-row contacts) + nav. Currently 12rem. Adjust if contacts bar layout changes.
- **No self-registration**: Login page shows "Contact your administrator." Do not re-add registration forms.
- **No fake telemetry**: Monitoring nodes ticker was removed. Do not re-add decorative status indicators.

## Map & Theme Conventions
- **Map tiles are theme-aware**: `OperationalMapPanel.tsx` uses CartoDB `dark_all` in dark mode and `rastertiles/voyager` in light mode via `useTheme()`. Do not hardcode a single tile URL.
- **CSP policy** in `index.html` must include `https://fonts.googleapis.com` in `style-src` and `https://*.basemaps.cartocdn.com` in `connect-src` for fonts and map tiles to load.
- **Typography**: Space Grotesk (body) + Rajdhani (headings) loaded via `@import` in `index.css`. If CSP `style-src` is modified, ensure `fonts.googleapis.com` remains allowed.
- **Status bar indicators** use `inset 5px 0 0 0` box-shadow (not border) for colored left accents.
- **`animate-section-enter`** CSS class provides staggered entrance animations for dashboard sections using `nth-child` delays.
- **Header titles** in `shared/Header.tsx` must NOT use `truncate` — SENTINEL page titles are short uppercase strings that should always display fully.

## Key Documentation

| Doc | Purpose |
|-----|---------|
| [COPILOT.md](COPILOT.md) | Full technical reference (stack, API routes, DB tables, env vars) |
| [CHATGPT_SYSTEM_GUIDE.md](CHATGPT_SYSTEM_GUIDE.md) | System guide for new AI sessions |
| [CHANGELOG.md](CHANGELOG.md) | Version history |
| [PRODUCTION_ROLLOUT.md](PRODUCTION_ROLLOUT.md) | Multi-platform deployment guide |
| [SYSTEM_FLOW_DIAGRAMS.md](SYSTEM_FLOW_DIAGRAMS.md) | Auth, approval, and operational flow diagrams |
| [DasiaAIO-Backend/scripts/RAILWAY_LIVE_ACCOUNT_RUNBOOK.md](DasiaAIO-Backend/scripts/RAILWAY_LIVE_ACCOUNT_RUNBOOK.md) | Railway production provisioning |

## Repo-Local AI Routing

When working inside this workspace, treat the following `.github` files as the explicit routing table for repo-local AI guidance. These files are supplementary to `AGENTS.md`; they do not replace it.

- **Persistent Codex QA / Gem Team memory**: read `.github/instructions/codex-qa-gem-team.instructions.md`.
- **Capstone paper maintenance**: read `.github/instructions/capstone-paper-maintenance.instructions.md` when editing `SENTINEL - Group 8.md`.
- **Frontend implementation or review**: read `.github/instructions/sentinel-frontend.instructions.md` first.
- **Backend implementation or review**: read `.github/instructions/sentinel-backend.instructions.md` first.
- **General SENTINEL product/domain guidance**: read `.github/instructions/sentinel instructions.instructions.md`.
- **Accessibility-sensitive UI work**: also read `.github/instructions/a11y.instructions.md`.
- **Performance-sensitive work**: also read `.github/instructions/performance-optimization.instructions.md`.
- **Security-sensitive work**: also read `.github/instructions/security-and-owasp.instructions.md`.
- **SENTINEL QA, browser acceptance review, or Gem Team orchestrator prompting**: use `.github/skills/sentinel-qa-orchestrator/SKILL.md`.
- **Local browser QA / Playwright validation**: use `.github/skills/webapp-testing/SKILL.md`.
- **Visual UI audit / design review**: use `.github/skills/web-design-reviewer/SKILL.md`.
- **High-end frontend polish / premium UI direction**: use `.github/skills/premium-frontend-ui/SKILL.md`.

If a task overlaps multiple areas, apply the most specific routing first, then layer the supporting `.github/instructions/*` or `.github/skills/*` files that match the risk area.

Unless the user explicitly chooses another workflow, treat Gem Team as the preferred multi-agent orchestration framework for substantial planning, QA handoff, and spec-driven execution in this repo.
