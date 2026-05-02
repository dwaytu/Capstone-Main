# Defense Pack (Phase 5)

## A. Panel Demo Flow (Objective-Mapped)

1. Objective 1 and 12
- Show login success + protected access.
- Show API health and ops-health evidence from readiness report.

2. Objective 2
- Show role accounts and role-governed access boundaries.

3. Objective 3, 8, 9, 11
- Show guard/supervisor operational flow:
  - attendance/continuity path
  - panic/support/notification path
  - live tracking and map outputs (role-scoped behavior).

4. Objective 4, 5, 6, 7, 10
- Show asset/compliance lifecycle modules and decision-support panels.

5. Objective 13 and 14
- Show build/runtime evidence set and accessibility/compliance evidence references.

## B. Core Artifacts to Present

- `OBJECTIVE_COMPLIANCE_MATRIX.md`
- `EVIDENCE_REGISTER.md`
- `DEFECT_REGISTER.md`
- `RELEASE_OPS_HARDENING_REPORT.md`
- `evidence/latest-readiness-report.md`
- `evidence/phase5-platform-a11y-summary-20260502.md`

## C. Known Limitations (Explicitly Declared)

- No payroll/HR/government-license system integration.
- No direct CCTV/IoT/access-control integration.
- Native runtime target excludes iOS/macOS in this scope.
- Some platform evidence uses controlled-session smoke capture for deterministic UI verification under auth-rate-limit constraints.

## D. Panel Q&A Quick Answers

1. "How do you prove it is working?"
- Strict automated full gate with API-required mode is passing and timestamped; artifacts are versioned in the evidence folder.

2. "How do you control operational risk?"
- Role-based access, policy/consent checks, audit visibility, and controlled account provisioning in local QA runs.

3. "What if database recovery is needed?"
- Backup artifact and isolated restore drill were executed and documented in the hardening report.

4. "What is still incomplete?"
- Remaining open item is optimization-only (`D-007`: Vite dynamic-import warning cleanup); objective-critical readiness gates are currently passing.
