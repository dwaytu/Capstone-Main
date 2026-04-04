---
description: 'Rust/Axum backend conventions for SENTINEL handlers and services'
applyTo: 'DasiaAIO-Backend/**/*.rs'
---

# SENTINEL Backend Conventions

## Handler Rules
- All handlers return `AppResult<T>` — never use `.unwrap()` in handlers; propagate with `?`.
- Use `sqlx::query!` / `.bind()` exclusively — no raw SQL string concatenation.
- Paginated endpoints use `utils::PaginationQuery` → response shape: `{ total, page, pageSize, items }`.
- Normalize roles with `utils::normalize_role()` before comparison. Valid roles: `guard`, `supervisor`, `admin`, `superadmin`.
- Generate IDs with `utils::generate_id()` (UUID v4).

## Service Modules
- Service modules in `src/services/` receive `&PgPool` directly — do not use `axum::State` inside services.
- Each new module must be declared in the parent `mod.rs`.
- One `tokio::spawn` per background loop — spawn before `axum::serve()` in `main.rs`.

## Error Handling

```rust
AppError::NotFound(String)
AppError::Unauthorized(String)
AppError::BadRequest(String)
AppError::DatabaseError(String)
AppError::InternalError(String)
```

Map sqlx errors: `.map_err(|e| AppError::DatabaseError(e.to_string()))`

## Rate Limiting
- Rate limiting is per-route, not global. Each sensitive endpoint has its own limiter.
- Auth routes at `/api/login` and `/api/auth/login` both exist for backward compatibility.

## AI / Ollama
- `services::incident_ai_classifier::classify_incident_async(description)` calls Ollama with keyword-classifier fallback.
- Env: `OLLAMA_BASE_URL`, `OLLAMA_MODEL`, `OLLAMA_API_KEY`.
