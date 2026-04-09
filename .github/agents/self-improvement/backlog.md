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
