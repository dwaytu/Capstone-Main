---
description: 'React/TypeScript frontend conventions for SENTINEL components and pages'
applyTo: 'DasiaAIO-Frontend/src/**'
---

# SENTINEL Frontend Conventions

## Stack
- React 18, TypeScript (strict), Vite, Tailwind CSS v4.
- State: `useState` / `useEffect` only — no Redux.
- Use relative imports — no `@/` alias (not configured).

## Design Tokens
Use semantic Tailwind token classes only — no scattered hex values:

| Purpose | Class |
|---------|-------|
| Page background | `bg-surface` |
| Card background | `bg-surface-elevated` |
| Primary text | `text-text-primary` |
| Muted text | `text-text-secondary` |
| Border | `border-border` |
| Focus ring | `ring-focus` |
| Primary button | `soc-btn` |
| Command panel | `command-panel` |

## Charts
`recharts` is NOT installed. Use native SVG for small trend visualizations.

## Fetch Patterns
- `useEffect` cleanup must cancel/abort in-flight fetches.
- Import `API_BASE_URL` from `../config` and `getAuthToken()` from `../utils/api`.

## Roles
Four roles: `guard`, `supervisor`, `admin`, `superadmin`. No `user` role exists.

## Platform Detection
`window.Capacitor` / `window.__TAURI__` — only available after React mounts.
`config.ts` rejects private IPs (`10.x`, `192.168.x`, `172.16–31.x`) in production.

## CSS Variables
All Tailwind colors depend on `--color-*` vars in `index.css`; changes cascade everywhere.
