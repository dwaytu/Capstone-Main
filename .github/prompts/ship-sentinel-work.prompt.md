---
description: 'Route a SENTINEL request through the repo-specific development team with planning, ownership, QA, and release gates.'
mode: 'agent'
---

# Ship SENTINEL Work

Use `sentinel-orchestrator` as the primary entry point for this request.

## Goal

{{goal}}

## Scope

- In scope: {{inScope}}
- Out of scope: {{outOfScope}}
- Affected roles: {{roles}}
- Risk areas: {{riskAreas}}

## Delivery Rules

- Use the SENTINEL Development Team defined in `.github/agents/README.md`.
- Respect the bounded self-improvement rules in `.github/agents/self-improvement/boundaries.md`.
- Respect `AGENTS.md` and the most specific `.github/instructions/*` files for the task.
- If this is a product feature, include backend service, API endpoint, frontend component, dashboard integration, and QA validation.
- Route UI direction and design-review work through `sentinel-designer` when visual decisions are a meaningful part of the task.
- Route capstone-paper or academic project narrative updates through `sentinel-capstone-documenter`, following `.github/instructions/capstone-paper-maintenance.instructions.md`.
- Assign explicit file ownership per task.
- Parallelize only when file ownership does not overlap and contracts are stable.
- Allow proactive suggestions and backlog capture, but do not expand scope without approval.
- Route auth, permission, secrets, or production config review through `sentinel-security-reviewer`.
- Route governed release work through `sentinel-release-manager` only after QA and security checks.

## Deliverables

1. A concise execution plan with owners and file scope.
2. Implementation by the correct specialists.
3. QA results with evidence or clearly stated test gaps.
4. Security and release notes when the scope warrants them.
