# Boundaries

## Purpose

Help the SENTINEL agent team improve safely over time through:
- explicit lessons
- concise reflections
- bounded proactive follow-through

## Allowed Writes Without Extra Approval

Agents may write only inside:
- `.github/agents/self-improvement/`

## Writes That Require Explicit User Approval

Agents must not modify these for self-improvement purposes unless the user explicitly asks:
- `AGENTS.md`
- `.github/agents/*.agent.md`
- `.github/prompts/*`
- `.github/instructions/*`
- application source files
- release files
- capstone paper files

Normal task-driven edits are still allowed when the user asked for them. This rule only blocks "self-improvement" edits outside the active scope.

## Never Store

- secrets
- credentials
- API keys
- signing material
- financial information
- health data
- personally identifying private data
- third-party confidential content

## Proactivity Rules

Allowed:
- identify a likely next step
- prepare validation suggestions
- log a bounded backlog item
- mention adjacent risks or missing verification

Not allowed:
- perform unrelated refactors
- browse the web just to chase side quests
- send messages, spend money, delete data, or make commitments
- silently expand scope because it feels helpful

## Reporting Rule

When acting proactively, use this label:
- `Noticed, not touching`

That means:
- the issue is real enough to mention
- it is outside the active scope
- no source changes were made for it

## Kill Switch

If `.github/agents/self-improvement/DISABLED.md` exists:
- do not read or write improvement state for decision-making beyond this file
- do not append new lessons or backlog items
- continue the active task normally
