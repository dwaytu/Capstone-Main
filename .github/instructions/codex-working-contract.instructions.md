---
description: "Codex-first execution contract for SENTINEL workflow, scope control, and verification discipline"
applyTo: "**"
---

# SENTINEL Codex Working Contract

This file defines the default operating contract when working in this repository with Codex.

## Source Of Truth Order

When guidance conflicts, resolve in this order:
1. Explicit user request in the current session
2. `SENTINEL - Group 8.md` for capstone system framing and project intent
3. `AGENTS.md` and repo-local instructions under `.github/instructions/`
4. Existing implementation in code

## Scope Control

- Do not add new features unless the user explicitly asks for them.
- Prefer stabilization, hardening, correctness, UX clarity, documentation alignment, and release reliability.
- If a requested change can affect behavior outside scope, call out impact before editing.

## Change Discipline

- Make minimal, targeted changes first.
- Preserve established architecture and role model (`guard`, `supervisor`, `admin`, `superadmin`).
- For frontend work, preserve `OperationalShell` behavior and semantic token usage.
- For backend work, keep handler/service/middleware responsibilities clear and maintain `AppResult<T>` error flow.

## Verification Discipline

After code changes, run the strongest practical verification for touched areas.

Default full verification command from repo root:

```powershell
npm run verify:all
```

If full verification is too heavy for the change, run the smallest reliable subset and state what was not run.

## Documentation Discipline

- Keep documentation aligned with implemented behavior.
- Do not rewrite governed academic sections unless explicitly requested.
- For capstone paper edits, obey `.github/instructions/capstone-paper-maintenance.instructions.md`.

## Response Discipline

- Report what changed, why, and verification evidence.
- Distinguish facts from assumptions.
- If blocked, provide exact blocker and next action.
