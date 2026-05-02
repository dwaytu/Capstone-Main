# AO Team Setup for SENTINEL

This setup uses:
- `awesome-codex-skills` (installed into `~/.codex/skills`)
- `ComposioHQ/agent-orchestrator` (`ao` CLI)

## Installed Skills (project-relevant)

- `create-plan`
- `webapp-testing`
- `issue-triage`
- `gh-fix-ci`
- `gh-address-comments`
- `changelog-generator`
- `deploy-pipeline`
- `file-organizer`
- `pr-review-ci-fix`
- `codebase-migrate`
- `agent-orchestrator`

## Team Structure

- CTO: `cm-orchestrator-1`
- Department heads (spawned worker sessions):
  - planner
  - backend
  - frontend
  - designer
  - QA
  - security
  - release
  - capstone documenter

Prompt files live in:
- `docs/ao-team/prompts/`

## Commands

From repo root (`D:\Dwight\Capstone Main`):

```powershell
# Full bootstrap (start AO, send CTO prompt, spawn all heads, show status)
powershell -ExecutionPolicy Bypass -File scripts/ao-team-bootstrap.ps1 -Action bootstrap

# Start AO only
powershell -ExecutionPolicy Bypass -File scripts/ao-team-bootstrap.ps1 -Action start

# Send/re-send CTO orchestrator prompt
powershell -ExecutionPolicy Bypass -File scripts/ao-team-bootstrap.ps1 -Action send-cto

# Spawn department heads only
powershell -ExecutionPolicy Bypass -File scripts/ao-team-bootstrap.ps1 -Action spawn-heads

# Status
powershell -ExecutionPolicy Bypass -File scripts/ao-team-bootstrap.ps1 -Action status

# Stop
powershell -ExecutionPolicy Bypass -File scripts/ao-team-bootstrap.ps1 -Action stop
```

## Notes

- Default project in AO config is `capstone-main`.
- This setup assumes `ao` and `codex` are available in PATH.
- If AO dashboard is not needed, pass `-NoDashboard` with `-Action start` or `-Action bootstrap`.
- On Windows, `scripts/ao-team-bootstrap.ps1` now auto-applies an AO runtime compatibility patch (PowerShell bridge for `runtime-process`) before AO actions.

## AO + Skills Usage

Yes, AO can use your awesome Codex skills indirectly by instruction/routing:
- Skills are available to the Codex agent runtime from `~/.codex/skills`.
- CTO and department-head prompts should explicitly tell agents which skills to use for each task lane (`webapp-testing`, `gh-fix-ci`, `deploy-pipeline`, etc.).
- Keep this explicit in prompts so the orchestration behavior stays consistent.

## Troubleshooting

- `Error: write EPIPE` on `ao send`:
  - usually means the target session process already exited.
  - run `ao session ls --include-terminated` and then re-send (AO can restore/continue when supported).
- Sessions rapidly marked `runtime_lost` / `process_missing` on Windows:
  - run:
  - `powershell -ExecutionPolicy Bypass -File scripts/ao-windows-runtime-fix.ps1 -Apply`
- Notifier warnings (`discord/slack/webhook/openclaw`) are expected unless you configure those channels.
