# Explanation

This document explains how the current system works, what was improved, and why the changes make the platform faster and safer.

## 1. System Architecture

The workspace contains two main applications:

- `DasiaAIO-Frontend`: React + TypeScript + Vite web client.
- `DasiaAIO-Backend`: Rust + Axum API service with PostgreSQL.

High-level flow:

1. Frontend sends HTTP requests to backend endpoints.
2. Backend reads/writes data in PostgreSQL.
3. Frontend renders modules like dashboards, schedules, and calendar views using API responses.

## 2. Calendar Module (Frontend)

Primary file:
- `DasiaAIO-Frontend/src/components/CalendarDashboard.tsx`

### What it does

- Fetches multiple event sources:
  - shifts
  - trips
  - missions
  - maintenance (admin)
- Normalizes each source to a shared `CalendarEvent` shape.
- Displays monthly calendar and per-day details.

### What was improved

1. Reduced repeated work
- Previously, the component repeatedly filtered/count events in render paths.
- It now precomputes memoized structures:
  - `eventsByDate`
  - `filteredEventsByDate`
  - `eventStats`

2. Better data safety
- Added `safeIsoToDateKey` to validate dates before using them.
- Invalid records are skipped safely instead of introducing render/runtime errors.

3. Better resilience
- Data sources are loaded with `Promise.allSettled`.
- If one source fails, the rest still render.
- User gets a clear partial-load warning.

## 3. API Utility Layer

Primary file:
- `DasiaAIO-Frontend/src/utils/api.ts`

### What it does

- Parses response bodies.
- Produces user-friendly error messages.
- Provides `fetchJsonOrThrow` helper for consistent request behavior.

### What was improved

1. Non-JSON response handling
- If backend returns text/HTML instead of JSON, parser now returns a structured fallback object.

2. Timeout support
- `fetchJsonOrThrow` now supports request timeout using `AbortController`.
- Avoids hanging calls and improves UX during network stalls.

## 4. Validation and Error Handling

Improvements include:

- Input sanity checks for event dates before mapping.
- Defensive parsing with safe fallbacks.
- Consistent user-visible errors without breaking entire views.

## 5. Testing Strategy Applied

Frontend tests added:
- `DasiaAIO-Frontend/src/__tests__/api.test.ts`

Coverage includes:
- JSON parsing success path.
- Non-JSON parsing fallback.
- API fallback message behavior.
- Success and error flows in `fetchJsonOrThrow`.

Runtime checks:
- Frontend production build verified.
- Backend containers verified via Docker.
- Backend health endpoint verified (`/api/health`).

## 6. Why These Changes Matter

1. Performance
- Less repeated filtering/counting in React render path.
- Better scaling with larger event sets.

2. Reliability
- Partial API outages no longer blank the entire calendar.
- Non-JSON and timeout conditions are handled predictably.

3. Maintainability
- Cleaner derived state and clearer data flow.
- Shared utility behavior covered by tests.

## 7. How to Re-Verify Locally

Frontend:

```bash
cd DasiaAIO-Frontend
npm test -- --runInBand
npm run build
```

Backend (Docker):

```bash
cd DasiaAIO-Backend
docker compose up -d
docker compose ps
```

Health check:

```powershell
Invoke-WebRequest -Uri "http://localhost:5000/api/health" -UseBasicParsing
```

Expected response body:

```json
{"status":"ok"}
```
