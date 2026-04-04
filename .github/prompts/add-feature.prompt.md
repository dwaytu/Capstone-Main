---
description: 'Scaffold a new SENTINEL feature end-to-end: backend handler, API route, frontend component, dashboard integration'
mode: 'agent'
---

# Add Feature: {{featureName}}

Create a new SENTINEL feature called **{{featureName}}** that follows the full-stack pattern.

## Requirements

Generate the following in order:

### 1. Backend Service
- Create `DasiaAIO-Backend/src/services/{{featureName}}.rs` (or add to existing service)
- Follow `AppResult<T>` return type, `sqlx::query!` for DB access
- Register module in parent `mod.rs`

### 2. Backend Handler
- Create handler in `DasiaAIO-Backend/src/handlers/`
- Add route(s) in `main.rs` under the appropriate path prefix
- Include pagination via `utils::PaginationQuery` if listing data

### 3. Frontend Component
- Create component under `DasiaAIO-Frontend/src/components/`
- Use semantic Tailwind tokens (`bg-surface-elevated`, `text-text-primary`, etc.)
- Include proper fetch with `useEffect` cleanup and abort controller
- Use relative imports only

### 4. Dashboard Integration
- Wire the component into the appropriate role dashboard
- Guard → `UserDashboard.tsx`, Admin/Superadmin → their respective dashboards
- Ensure the feature is accessible via navigation or direct action

## Validation Checklist
- [ ] Backend compiles (`cargo build`)
- [ ] Frontend compiles (`npm run build` in DasiaAIO-Frontend)
- [ ] New module declared in `mod.rs`
- [ ] No `.unwrap()` in handlers
- [ ] No raw SQL string concatenation
- [ ] Semantic Tailwind tokens used (no hex values)
