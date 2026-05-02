# Evidence Register Template

Use this file to log proof artifacts per objective and sub-objective.

## Status Legend

- `PASS` = validated and reproducible
- `PARTIAL` = implemented but incomplete evidence or partial platform coverage
- `FAIL` = broken flow or no implementation proof

## Evidence Table

| Evidence ID | Objective | Sub-Objective | Runtime | Scenario | Artifact Path | API/Log Ref | Result | Verified By | Verified At |
|---|---|---|---|---|---|---|---|---|---|
| E-001 | 1 | 1.a | Web | Approval-gated login succeeds | `docs/plan/capstone-readiness-20260502/evidence/...` | `/api/login`, `/api/auth/login` | TBD | TBD | TBD |
| E-002 | 3 | 3.b | Android | Guard check-in/check-out trace | `docs/plan/capstone-readiness-20260502/evidence/...` | attendance endpoints | TBD | TBD | TBD |
| E-003 | 9 | 9.d | Web/Desktop | Tracking + path replay visible | `docs/plan/capstone-readiness-20260502/evidence/...` | tracking endpoints | TBD | TBD | TBD |

## Required Artifact Naming

Use this pattern:

`OBJ<obj>-SUB<sub>-<runtime>-<scenario>-<YYYYMMDD-HHMM>.<ext>`

Examples:

- `OBJ01-SUB1A-web-login-20260502-1030.png`
- `OBJ09-SUB9D-web-tracking-replay-20260502-1115.mp4`
- `OBJ12-SUB12A-backend-audit-query-20260502-1120.json`

## Minimum Evidence Policy

1. Each objective must have at least one evidence row.
2. Objectives 3, 9, 11, 13, and 14 require both desktop/web and Android evidence.
3. Security-sensitive objectives (1, 5, 12, 14) require both UI and API/log evidence.
4. No objective can be marked `PASS` without timestamped artifacts.

