# SENTINEL Codex Workflow

This is the default workflow when using Codex as the primary engineering assistant for this repository.

## Ground Rules

1. `SENTINEL - Group 8.md` is the main project documentation reference.
2. No new features unless explicitly requested.
3. Every implementation task ends with verification evidence.
4. Keep web, desktop, and Android behavior aligned unless scope says otherwise.

## Standard Loop

1. Confirm scope and acceptance criteria.
2. Inspect affected files and constraints (`AGENTS.md`, relevant `.github/instructions/*`).
3. Implement minimal changes.
4. Run verification.
5. Report changes, evidence, and residual risk.

## Verification Commands

From repo root:

```powershell
npm run verify:all
```

Manual equivalents:

```powershell
cd DasiaAIO-Frontend
npm test -- --runInBand
npm run build

cd ../DasiaAIO-Backend
cargo test
cargo build
```

## Useful Daily Commands

```powershell
# Frontend dev
cd DasiaAIO-Frontend
npm run dev

# Backend dev
cd DasiaAIO-Backend
cargo run --bin server

# Full verification from repo root
npm run verify:all
```

## Change Types

- Safe-default tasks:
  - bug fixes
  - refactors without behavior change
  - test improvements
  - docs alignment
  - release hardening
- Explicit-approval tasks:
  - new features
  - major architecture changes
  - cross-domain schema/contract redesign

## Done Criteria

A task is complete when:

1. Scope is satisfied.
2. Relevant checks pass.
3. No unintended feature additions.
4. Documentation is updated when behavior changed.
