# Coding Conventions

## Backend

- Handlers return `AppResult<T>`
- Avoid `.unwrap()` in handlers
- Use `sqlx::query!`/`.bind()` style parameterized SQL
- Normalize role values before authorization checks
- Keep service modules free of `axum::State`

## Frontend

- Use semantic token classes (`bg-surface`, `text-text-primary`, etc.)
- Use relative imports (no `@/` alias)
- Keep `OperationalShell` visible for loading/error/empty states
- Mobile elevated tabs order: Dashboard, Approvals, Schedule, Alerts, More
- Cancel/abort in-flight effects on unmount

## Governance

- No feature creep beyond explicit capstone objective support
- Keep capstone paper updates panel-friendly and user-facing
