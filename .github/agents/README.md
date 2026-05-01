# SENTINEL Development Team

This repo now includes a smaller, repo-specific development team for AI-assisted delivery.

The design is a hybrid of:
- Gem Team's spec-first, gated workflow:
  https://github.com/mubaidr/gem-team
- Burke Holland's ultralight orchestration model:
  https://gist.github.com/burkeholland/0e68481f96e94bbb98134fa6efd00436

The result is intentionally narrower than the generic Gem stack:
- smaller core squad
- explicit frontend and backend ownership
- file-scoped parallelization
- browser-first QA
- dedicated design direction
- governed academic documentation support
- safe self-improvement and bounded proactivity
- security and release specialists for high-risk work

## Core Team

| Agent | Model | Role | Primary Use |
| --- | --- | --- | --- |
| `sentinel-orchestrator` | `GPT-5.3-Codex` | Coordinates work and sequencing | Cross-stack features, complex fixes, release prep |
| `sentinel-planner` | `GPT-5.3-Codex` | Converts requests into a delivery plan | Scope, phases, file ownership, verification |
| `sentinel-backend-engineer` | `GPT-5.3-Codex` | Owns Rust/Axum/Postgres work | Services, handlers, routes, SQL, auth |
| `sentinel-frontend-engineer` | `GPT-5.3-Codex` | Owns React/Tailwind/Tauri/Capacitor work | Dashboards, shells, UI states, responsive UX |
| `sentinel-designer` | `GPT-5.3-Codex` | Owns UI direction and design critique | Visual hierarchy, responsive direction, premium UX |
| `sentinel-qa-lead` | `GPT-5.3-Codex` | Owns browser-first validation | Acceptance, regressions, mobile/desktop, evidence |

## Support Specialists

| Agent | Model | Role | Use When |
| --- | --- | --- | --- |
| `sentinel-capstone-documenter` | `GPT-5.3-Codex` | Governed academic/project documentation | Capstone paper updates, evidence-backed narrative alignment |
| `sentinel-security-reviewer` | `GPT-5.3-Codex` | Security, auth, route exposure, OWASP review | Auth, permissions, secrets, sensitive config |
| `sentinel-release-manager` | `GPT-5.3-Codex` | Governed multi-platform release execution | Versioning, artifacts, release workflow |

## Leadership Structure

This repo uses a software-company style delegation model:

- CTO: `sentinel-orchestrator`
- Head of Planning: `sentinel-planner`
- Head of Backend Engineering: `sentinel-backend-engineer`
- Head of Frontend Engineering: `sentinel-frontend-engineer`
- Head of Design: `sentinel-designer`
- Head of QA: `sentinel-qa-lead`
- Head of Security: `sentinel-security-reviewer`
- Head of Release/DevOps: `sentinel-release-manager`
- Head of Documentation: `sentinel-capstone-documenter`

## Model Policy

- Default model for SENTINEL orchestration and coding work is `GPT-5.3-Codex`.
- For coding tasks, do not switch away from `GPT-5.3-Codex` unless the user explicitly requests a different model.
- Keep delegation role-based and file-scoped to preserve accountability.

## Operating Model

1. Intake
- Start with `sentinel-orchestrator` for anything that touches more than one subsystem.
- Route trivial one-owner tasks directly to the owner agent.

2. Plan
- Use `sentinel-planner` for medium or complex work.
- Every task must have:
  - one owner
  - explicit file ownership
  - acceptance criteria
  - verification commands

3. Build
- `sentinel-backend-engineer` owns Rust/Axum/Postgres changes.
- `sentinel-frontend-engineer` owns React/Tailwind/Tauri/Capacitor changes.
- `sentinel-designer` owns design direction and UI critique.
- Run backend and frontend in parallel only when contracts are already settled and files do not overlap.

4. Verify
- `sentinel-qa-lead` validates the user flow in browser-first mode.
- `sentinel-security-reviewer` blocks unsafe auth, permission, or config changes.

5. Ship
- `sentinel-release-manager` is used only after implementation and QA are complete.

6. Document
- `sentinel-capstone-documenter` updates the capstone paper and related project narrative only from verified repo evidence.

## Parallelization Rules

Run in parallel when:
- tasks touch different files or directories
- backend and frontend are working from a stable API contract
- design review is complete enough that implementation can proceed safely

Run sequentially when:
- two tasks need the same file
- schema, route, or response shape is still moving
- dashboard integration depends on a newly created backend contract
- release work depends on unfinished QA or security review

Always give each specialist:
- exact files or directories they own
- the outcome to deliver
- the repo constraints that matter

Do not delegate overlapping file ownership in the same phase.

## SENTINEL Non-Negotiables

- New user-facing features include backend service, API endpoint, frontend component, and dashboard integration.
- Frontend work keeps `OperationalShell` visible for loading, empty, and error states.
- Frontend uses semantic Tailwind tokens and relative imports only.
- Backend handlers return `AppResult<T>` and do not use `.unwrap()`.
- Backend SQL uses `sqlx::query!` or bound queries. No string-built SQL.
- Role-sensitive logic uses normalized roles.
- QA checks the relevant roles and validates desktop/mobile behavior when workflows are role-specific or field-facing.

## Suggested Entry Points

- Use `sentinel-orchestrator` for most feature work.
- Use `sentinel-planner` when the user asks for a plan or the request is ambiguous.
- Use `sentinel-designer` for UI direction, design review, or premium visual polish before or alongside implementation.
- Use `sentinel-qa-lead` for review, acceptance, browser testing, or release readiness.
- Use `sentinel-capstone-documenter` when updating `SENTINEL - Group 8.md` or aligning academic writeups with the current codebase.
- Use `sentinel-security-reviewer` before merging auth, permission, CORS, secrets, or release-signing changes.

Gem Team can remain as a broader fallback system, but the `sentinel-*` agents should be the default team for this repo.

## Self-Improvement Mode

The SENTINEL team now supports a bounded self-improving and proactive mode.

State lives under:
- `.github/agents/self-improvement/`

This mode is intentionally conservative:
- repo-local only
- append-first memory
- no hidden steering edits
- no source changes outside task scope
- `Noticed, not touching` for adjacent findings

If you want it disabled, create:
- `.github/agents/self-improvement/DISABLED.md`
