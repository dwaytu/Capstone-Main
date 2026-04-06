# SENTINEL Self-Improvement And Proactivity

This folder is a repo-local adaptation of the ideas from:
- Self-Improving + Proactive Agent: https://clawhub.ai/ivangdavila/self-improving
- Proactivity (Proactive Agent): https://clawhub.ai/ivangdavila/proactivity

The goal is not to make the SENTINEL team "autonomous" in a risky way.
The goal is to make the team:
- better at learning from repeated mistakes
- better at preserving reusable repo-specific lessons
- better at surfacing the next useful move
- safer against passive repetition and context loss

## Safe Adaptation

Unlike the reference skills, this repo version is intentionally conservative:
- all state stays inside this repo under `.github/agents/self-improvement/`
- no home-directory storage
- no hidden workspace steering edits
- no changes to `AGENTS.md`, agent files, prompts, or other steering files unless the user explicitly asks
- proactive behavior is bounded to suggestions, prep, and backlog capture unless the current task already authorizes the work

## Files

- `boundaries.md`: hard safety rules
- `memory.md`: hot, always-useful operating rules
- `corrections.md`: reusable lessons from mistakes or user corrections
- `reflections.md`: short post-task lessons
- `proactivity.md`: when to anticipate the next step and when to stay quiet
- `backlog.md`: "noticed, not touching" improvements
- `heartbeat-state.md`: lightweight maintenance markers

## Kill Switch

If `.github/agents/self-improvement/DISABLED.md` exists, agents must:
- stop writing to this folder
- stop proactive backlog capture
- continue normal task execution only

## Default Behavior

Agents may:
- read this folder at task start
- append concise lessons after significant work
- add bounded follow-up ideas to `backlog.md`

Agents may not:
- expand scope on their own
- silently modify source files because a proactive idea seems useful
- store secrets, credentials, PII, or private third-party data

## Promotion Rule

A one-off note stays in `corrections.md` or `reflections.md`.
Only repeated, stable lessons should be promoted into `memory.md`.
