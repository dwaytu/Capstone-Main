---
name: sentinel-qa-orchestrator
description: Perform browser-first QA, UI review, release-readiness validation, and Gem Team orchestrator prompt drafting for the SENTINEL repo. Use when the user asks for QA, visual inspection, role-by-role dashboard review, acceptance checks, production parity checks, or a prompt/brief for gem-orchestrator, Gem Team, PRD creation, DESIGN.md planning, or wave-based execution handoff.
---

# SENTINEL QA And Orchestrator Prompting

Read this skill when the user wants Codex to act as:
- QA lead for SENTINEL
- browser tester for SENTINEL dashboards
- UI reviewer for live or local builds
- prompt writer for `gem-orchestrator`

## Load Order

Start from:
1. `AGENTS.md`
2. `.github/instructions/codex-qa-gem-team.instructions.md`

Then load only what is relevant:
- `.github/instructions/sentinel-frontend.instructions.md`
- `.github/instructions/a11y.instructions.md`
- `.github/instructions/performance-optimization.instructions.md`
- `.github/instructions/security-and-owasp.instructions.md`
- `.github/skills/webapp-testing/SKILL.md`
- `.github/skills/web-design-reviewer/SKILL.md`
- `.github/skills/premium-frontend-ui/SKILL.md`

## QA Workflow

1. Determine the target surface.
   - local build
   - live deployment
   - specific roles
   - specific routes

2. Prefer browser evidence.
   - use real navigation, login, screenshots, console capture, and responsive checks
   - inspect desktop and mobile when dashboard or field UX is involved

3. Separate findings by class.
   - functional regression
   - visual/design weakness
   - permission or route exposure issue
   - deployment/config mismatch
   - loading or empty-state weakness

4. Report findings in severity order.
   - findings first
   - open questions second
   - recommendations third

5. Preserve evidence.
   - store screenshots or browser reports under `DasiaAIO-Frontend/output/playwright/` when useful

## Gem Team Prompt Workflow

1. Convert the user's request into a spec-first handoff.
2. Name the target outcome clearly.
3. State the exact surfaces, roles, and files in scope.
4. Include repo constraints and non-negotiable rules.
5. Tell `gem-orchestrator` which artifacts to produce.
6. Require wave-based execution and verification gates.
7. Require source-cited claims and explicit unresolved decisions.

## Gem Team Memory

Treat Gem Team as SENTINEL's preferred orchestration model unless the user overrides it.

Core expectations:
- `gem-orchestrator` coordinates only
- spec before implementation
- research and critique before execution on medium or complex work
- browser validation for UI work
- reviewer and critic gates for plan quality
- `docs/PRD.yaml`, `docs/DESIGN.md`, and `docs/plan/{plan_id}/plan.yaml` are standard outputs for substantial UI initiatives

## Output Rules

When doing QA:
- lead with findings
- cite evidence paths when possible
- distinguish live-site issues from local-code issues

When drafting orchestrator prompts:
- output a ready-to-paste prompt
- keep it concrete and operational
- include scope, constraints, deliverables, validation, and rollout expectations
