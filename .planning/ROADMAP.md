# Roadmap: SENTINEL Security Operations Platform

## Overview

This roadmap stabilizes and verifies objective-critical operational paths on the existing SENTINEL system without introducing feature creep. Execution focuses on governed reliability, role workflow parity, and release confidence.

## Phases

- [x] **Phase 1: Governance Baseline Lock** - Validate current scope, map objective-critical flows, and close high-risk auth/shell regressions.
- [x] **Phase 2: Role Workflow Reliability** - Harden elevated + guard operational workflows across desktop/mobile with smoke-backed fixes.
- [x] **Phase 3: Asset and MDR Integrity** - Stabilize asset lifecycle and MDR import/review/commit critical paths.
- [ ] **Phase 4: Platform Release Confidence** - Verify web/desktop/android release readiness and objective evidence coverage.

## Phase Details

### Phase 1: Governance Baseline Lock
**Goal**: Ensure core governance/auth/shell paths are consistently functional and measurable.
**Depends on**: Nothing (first phase)
**Requirements**: AUTH-01, AUTH-02, AUTH-03, OPS-01
**Success Criteria**:
1. All four roles can reach intended primary shell/dashboard entry points.
2. Auth-protected routes and legal-policy gating do not regress under smoke checks.
3. Baseline defects and fixes are documented with reproducible evidence paths.
**Plans**: TBD

Plans:
- [x] 01-01: Baseline route/shell/access verification and defect catalog
- [x] 01-02: Auth + shell bugfix batch with smoke rerun

### Phase 2: Role Workflow Reliability
**Goal**: Stabilize role-specific operational workflows and mobile parity.
**Depends on**: Phase 1
**Requirements**: OPS-02, OPS-03, GRD-01, GRD-02
**Success Criteria**:
1. Elevated-role mobile + desktop dashboard flows behave consistently.
2. Guard mission/incident/SOS paths remain available in degraded network scenarios.
3. Workflow blockers have explicit PASS/FAIL smoke evidence.
**Plans**: TBD

Plans:
- [x] 02-01: Elevated workflow reliability fixes
- [x] 02-02: Guard workflow reliability fixes

### Phase 3: Asset and MDR Integrity
**Goal**: Ensure operational asset and MDR flows stay correct under real usage.
**Depends on**: Phase 2
**Requirements**: GRD-03, AST-01, AST-02, AST-03
**Success Criteria**:
1. Asset management actions and compliance surfaces are role-consistent.
2. MDR import/review/commit path is stable with clear operator feedback.
3. Critical backend/frontend mismatch defects are eliminated or explicitly gated.
**Plans**: TBD

Plans:
- [x] 03-01: Asset + permit workflow stabilization
- [x] 03-02: MDR workflow stabilization and validation

### Phase 4: Platform Release Confidence
**Goal**: Validate cross-platform delivery and capstone objective evidence coverage.
**Depends on**: Phase 3
**Requirements**: MAP-01, MAP-02, REL-01
**Success Criteria**:
1. Web/desktop/android build and smoke checks pass with evidence artifacts.
2. Theme-aware map and tracking surfaces work for command + guard roles.
3. Objective-to-evidence mapping is updated for defense readiness.
**Plans**: TBD

Plans:
- [ ] 04-01: Cross-platform smoke and release verification
- [ ] 04-02: Objective evidence consolidation

## Progress

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 1. Governance Baseline Lock | 2/2 | Completed | 2026-05-03 |
| 2. Role Workflow Reliability | 2/2 | Completed | 2026-05-03 |
| 3. Asset and MDR Integrity | 2/2 | Completed | 2026-05-03 |
| 4. Platform Release Confidence | 0/2 | Not started | - |
