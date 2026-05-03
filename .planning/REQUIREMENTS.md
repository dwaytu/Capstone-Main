# Requirements: SENTINEL Security Operations Platform

**Defined:** 2026-05-03
**Core Value:** Reliable, role-governed operational decision support across web, desktop, and Android.

## v1 Requirements

### Identity and Governance

- [ ] **AUTH-01**: Role-based login supports `guard`, `supervisor`, `admin`, `superadmin`.
- [ ] **AUTH-02**: Protected routes enforce role authorization and session validity.
- [ ] **AUTH-03**: Legal/policy acceptance gating is recorded and auditable.

### Operations Command and Staffing

- [ ] **OPS-01**: Elevated roles can access dashboard, approvals, schedule, and alerts via operational shell.
- [ ] **OPS-02**: Shift/swap and replacement flows function with controlled degraded handling when backend parity endpoints are unavailable.
- [ ] **OPS-03**: Mission/trip/assignment views remain role-appropriate and operationally usable.

### Field Guard Workflow

- [ ] **GRD-01**: Guard mission workspace supports check-in/out and incident submission.
- [ ] **GRD-02**: Guard SOS and emergency-contact actions remain accessible on mobile.
- [ ] **GRD-03**: Offline queue preserves critical field actions until connectivity is restored.

### Asset and Compliance

- [ ] **AST-01**: Firearm and armored-car management workflows are available to authorized roles.
- [ ] **AST-02**: Permit/compliance checks and status surfaces are visible and actionable.
- [ ] **AST-03**: MDR import staging/review/commit flow is available with guarded commit behavior.

### Situational Awareness and Reliability

- [ ] **MAP-01**: Theme-aware map panels render across roles (dark/light tile parity).
- [ ] **MAP-02**: Tracking and presence endpoints support operational map visibility.
- [ ] **REL-01**: Web, desktop, and Android build paths complete in governed pipeline.

## v2 Requirements

### Process Improvement

- **REL-02**: Expanded automated cross-platform smoke evidence per release
- **DOC-01**: Stronger objective-to-evidence trace automation for capstone defense pack

## Out of Scope

| Feature | Reason |
|---------|--------|
| Public self-service sign-up | Conflicts with controlled operational onboarding |
| Non-objective feature additions | Increases capstone risk and scope drift |
| AO-heavy orchestration default | Higher credit consumption than needed |

## Traceability

| Requirement | Phase | Status |
|-------------|-------|--------|
| AUTH-01 | Phase 1 | Pending |
| AUTH-02 | Phase 1 | Pending |
| AUTH-03 | Phase 1 | Pending |
| OPS-01 | Phase 1 | Pending |
| OPS-02 | Phase 2 | Pending |
| OPS-03 | Phase 2 | Pending |
| GRD-01 | Phase 2 | Pending |
| GRD-02 | Phase 2 | Pending |
| GRD-03 | Phase 3 | Pending |
| AST-01 | Phase 3 | Pending |
| AST-02 | Phase 3 | Pending |
| AST-03 | Phase 3 | Pending |
| MAP-01 | Phase 4 | Pending |
| MAP-02 | Phase 4 | Pending |
| REL-01 | Phase 4 | Pending |

**Coverage:**
- v1 requirements: 15 total
- Mapped to phases: 15
- Unmapped: 0

---
*Requirements defined: 2026-05-03*
*Last updated: 2026-05-03 after GSD brownfield initialization*
