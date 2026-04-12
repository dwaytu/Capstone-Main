# Noticed, Not Touching

Capture adjacent issues or improvements without expanding scope.

## Format

```
DATE: YYYY-MM-DD
AGENT: sentinel-*
CATEGORY: ux | backend | qa | security | release | docs | capstone
ITEM: short description
EVIDENCE: file, route, or observation
NEXT_STEP: smallest useful follow-up
STATUS: open
```

DATE: 2026-04-10
AGENT: sentinel-backend-engineer
CATEGORY: backend
ITEM: Migration file additions may not execute during app startup
EVIDENCE: src/db.rs run_migrations() is hardcoded and does not load SQL files from migrations/ such as migrations/add_feedback_system.sql
NEXT_STEP: Pick one migration path (file-based sqlx migrate or db.rs runtime DDL) and align new migrations to it
STATUS: open

DATE: 2026-04-10
AGENT: sentinel-security-reviewer
CATEGORY: security
ITEM: Frontend role normalization defaults unknown roles to guard for tracking-related UI gating
EVIDENCE: DasiaAIO-Frontend/src/types/auth.ts returns 'guard' for invalid role input; trackingAccessPolicy.test.ts expects unknown-role and user to retain tracking access
NEXT_STEP: Tighten frontend role normalization to fail closed for unknown roles and update tests to match the four valid SENTINEL roles only
STATUS: open

DATE: 2026-04-12
AGENT: sentinel-security-reviewer
CATEGORY: security
ITEM: Supervisor heartbeats currently enter guard-only history, path, and geofence semantics
EVIDENCE: DasiaAIO-Backend/src/handlers/tracking.rs writes supervisor heartbeats as entity_type='guard', and downstream reads/alerts query tracking_points where entity_type IN ('guard')
NEXT_STEP: Decide explicitly whether supervisor movement belongs in guard operational channels; if not, separate entity typing or add downstream role-aware filtering before calling the shortcut safe
STATUS: open
