# SENTINEL — Copilot Reference

SENTINEL is an integrated security operations platform for **Davao Security & Investigation Agency (DSIA)**.
It is a Rust/Axum REST API backed by PostgreSQL, consumed by a React 18 / TypeScript / Vite / Tailwind CSS
single-page application, and packaged for desktop via Tauri and for mobile via Capacitor.

---

## 1. Project Layout

```
DasiaAIO-Backend/   Rust + Axum API
DasiaAIO-Frontend/  React 18 + TypeScript SPA
```

---

## 2. Backend Conventions

### 2.1 Stack
| Layer | Choice |
|---|---|
| Web framework | `axum` 0.8 |
| Database | `sqlx` 0.8 with PostgreSQL |
| Async runtime | `tokio` |
| HTTP client | `reqwest` 0.12 with `json` feature |
| Auth | JWT (`jsonwebtoken`) |

### 2.2 Error handling

All handlers return `AppResult<T>` which is `Result<T, AppError>`.
`AppError` variants:

```rust
AppError::NotFound(String)
AppError::Unauthorized(String)
AppError::BadRequest(String)
AppError::DatabaseError(String)
AppError::InternalError(String)
```

Never use `.unwrap()` in handlers. Propagate with `?` or map with `.map_err(|e| AppError::DatabaseError(e.to_string()))`.

### 2.3 Pagination

Use `utils::PaginationQuery` for paginated list endpoints:

```rust
pub async fn get_items(
    State(db): State<Arc<PgPool>>,
    Query(pagination): Query<utils::PaginationQuery>,
) -> AppResult<Json<serde_json::Value>> {
    let (limit, offset) = utils::resolve_pagination(&pagination);
    // SQL: ORDER BY created_at DESC LIMIT $1 OFFSET $2
}
```

Response shape: `{ total, page, pageSize, items: [...] }`

### 2.4 Role system

Four roles are recognised: `guard`, `supervisor`, `admin`, `superadmin`.
Use `utils::normalize_role(role)` to lower-case and trim before any comparison.
Never assume `user` is a valid role — the legacy `user → guard` shim has been removed.

### 2.5 ID generation

```rust
let id = utils::generate_id(); // UUID v4
```

### 2.6 AI / Ollama integration

`services::incident_ai_classifier::classify_incident_async(description)` calls the Ollama HTTP API
with a keyword-classifier fallback. Env vars:

| Var | Default |
|---|---|
| `OLLAMA_BASE_URL` | `http://localhost:11434` |
| `OLLAMA_MODEL` | `llama3` |
| `OLLAMA_API_KEY` | *(none)* |

### 2.7 Guard absence prediction weights

Configurable via env vars (all `f64`, must sum to 1.0 for best results):

| Var | Default |
|---|---|
| `ABSENCE_WEIGHT_ABSENCES` | `0.5` |
| `ABSENCE_WEIGHT_LATE` | `0.3` |
| `ABSENCE_WEIGHT_LEAVE` | `0.2` |

### 2.8 Geofence background task

`services::geofence_alert_service::run_geofence_alert_loop(pool)` runs a Tokio interval (every
`GEOFENCE_ALERT_INTERVAL_SECS` seconds, default 300) that checks for guards whose most recent
`geofence_events` row has `event_type = 'exit'` and sends a notification to supervisors/admins
when no alert has been sent within the last 15 minutes for that guard–site pair.

---

## 3. Frontend Conventions

### 3.1 Stack
| Layer | Choice |
|---|---|
| Framework | React 18.x |
| Language | TypeScript (strict) |
| Bundler | Vite |
| Styling | Tailwind CSS v4 |
| State | `useState` / `useEffect` (no Redux) |
| Testing | Jest + Testing Library |

### 3.2 API base URL

```ts
import { API_BASE_URL } from '../config';

const response = await fetch(`${API_BASE_URL}/api/resource`, {
  headers: { Authorization: `Bearer ${getAuthToken()}` },
});
```

`getAuthToken()` is exported from `src/utils/api.ts`.

### 3.3 Component conventions

- Functional components with `FC<Props>` or inline type annotation.
- Props interfaces are co-located with the component file when they are used only in that file.
- Shared types live in `src/types/`.
- `useEffect` cleanup functions must cancel/abort in-flight fetches to prevent state updates on
  unmounted components.

### 3.4 Design tokens (Tailwind CSS v4)

Use semantic token classes **only** — do not scatter raw hex values or arbitrary Tailwind palette
numbers across components.

| Purpose | Class |
|---|---|
| Page background | `bg-surface` |
| Card background | `bg-surface-elevated` |
| Primary text | `text-text-primary` |
| Muted / secondary text | `text-text-secondary` |
| Border | `border-border` |
| Focus ring | `ring-focus` |
| Primary button | `soc-btn` |
| Command panel heading container | `command-panel` |

For dynamic risk / severity colours use `color-mix()` so they work in both light and dark mode:

```tsx
const riskClass = {
  LOW: 'bg-[color-mix(in_srgb,#22c55e_15%,transparent)] text-green-300',
  HIGH: 'bg-[color-mix(in_srgb,#ef4444_15%,transparent)] text-red-300',
};
```

### 3.5 Charts

`recharts` is **not installed**. Use native SVG for small trend visualisations:

```tsx
const points = data.map((d, i) => `${(i / (data.length - 1)) * W},${H - (d.value / max) * H}`).join(' ');
<polyline points={points} fill="none" stroke="currentColor" strokeWidth={2} />
```

### 3.6 Guards — availability toggle

`ProfileDashboard` renders an ARIA `role="switch"` toggle (visible only when `user.role === 'guard'`)
backed by:

- `GET /api/guard-replacement/availability/:guard_id`
- `POST /api/guard-replacement/set-availability` — body `{ guardId: string, available: boolean }`

---

## 4. Key API Routes (partial)

| Method | Path | Purpose |
|---|---|---|
| POST | `/api/auth/login` | JWT login |
| POST | `/api/auth/register` | User registration |
| GET | `/api/firearms?page=&pageSize=` | Paginated firearms list |
| GET | `/api/guard-replacement/availability/:id` | Guard availability |
| POST | `/api/guard-replacement/set-availability` | Toggle available flag |
| GET | `/api/tracking/guard/:id/history` | Guard location history |
| POST | `/api/tracking/guard/:id/checkin` | Guard check-in |
| POST | `/api/incidents` | Create incident |
| POST | `/api/ai/classify-incident` | LLM severity classification |
| GET | `/api/notifications` | Current user notifications |
| POST | `/api/shifts/swap-request` | Guard shift swap request |
| GET | `/api/shifts/swap-requests` | List swap requests |
| PATCH | `/api/shifts/swap-requests/:id/respond` | Accept / decline swap |

---

## 5. Database Key Tables

| Table | Purpose |
|---|---|
| `users` | All accounts (roles: guard/supervisor/admin/superadmin) |
| `guard_availability` | UNIQUE on `guard_id`; `available BOOLEAN` |
| `tracking_points` | GPS breadcrumbs (`entity_type = 'guard'`, `entity_id = guard_id`) |
| `geofence_events` | `enter` / `exit` events per guard × client site |
| `site_geofences` | `radius` or `polygon` zones per `client_site_id` |
| `client_sites` | Sites with `latitude` / `longitude` |
| `notifications` | In-app notifications (`type`, `user_id`, `related_shift_id`) |
| `guard_shift_swaps` | Shift swap requests (`requester_id`, `target_id`, `status`) |
| `incidents` | Reported incidents with AI-assigned severity |
| `firearm_allocations` | Guard ↔ firearm allocation records |

---

## 6. Environment Variables

```env
# Server
DATABASE_URL=postgres://...
JWT_SECRET=...
SERVER_HOST=0.0.0.0
SERVER_PORT=8080

# Ollama AI
OLLAMA_BASE_URL=http://localhost:11434
OLLAMA_MODEL=llama3
OLLAMA_API_KEY=

# Prediction weights (must sum to 1.0)
ABSENCE_WEIGHT_ABSENCES=0.5
ABSENCE_WEIGHT_LATE=0.3
ABSENCE_WEIGHT_LEAVE=0.2

# Background tasks
GEOFENCE_ALERT_INTERVAL_SECS=300
```

---

## 7. Patterns to Follow

- **No raw SQL string concatenation** — always use `sqlx::query!` / `.bind()` to prevent SQL injection.
- **One `tokio::spawn` per background loop** — spawn before `axum::serve()` in `main.rs`.
- **Service modules** in `src/services/` are async helpers; do **not** use `axum::State` in them —
  pass `&PgPool` directly.
- **`mod.rs` registration** — every new service/handler module must be declared in the parent
  `mod.rs` before use.
- **Frontend imports** — use relative paths from the component file, not absolute `@/` aliases
  (alias is not configured in the current `vite.config.ts`).
