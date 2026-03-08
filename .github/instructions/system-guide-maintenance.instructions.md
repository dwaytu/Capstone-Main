---
description: "Keep CHATGPT_SYSTEM_GUIDE.md current after system-affecting changes"
applyTo: "**"
---

# System guide maintenance instructions

When making changes that affect auth, roles, dashboards, account lifecycle, or API contracts, you MUST update `CHATGPT_SYSTEM_GUIDE.md` in the same session.

## Required updates

- Backend context updates:
  - route changes
  - handler logic changes
  - migration/schema/data contract changes
- Frontend context updates:
  - role-routing changes
  - dashboard navigation and role behavior changes
  - API/auth-header behavior changes
- Validation updates:
  - what was verified (build/test/runtime)
  - unresolved risks and follow-ups

## Minimum quality bar

- Keep content aligned to current code behavior, not assumptions.
- Prefer concrete file references and endpoint names.
- If both frontend and backend are touched, include both contexts explicitly.
