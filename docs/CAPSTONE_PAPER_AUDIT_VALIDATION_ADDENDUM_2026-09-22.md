# SENTINEL Capstone Paper Audit Validation Addendum

**Validation date:** 2026-09-22  
**Purpose:** Final validation of the implementation-alignment audit before any DOCX editing.  
**Paper baseline:** `SENTINEL - Group 8.docx`, `SENTINEL - Group 8.pdf`, and `SENTINEL - Group 8.md`.  
**Implementation baseline:** current repository source and configuration only.

## Validation Scope

This addendum validates every prior `CORRECTION REQUIRED` finding, corrects the original audit where its wording was too broad, and separates final/as-built **content updates** from protected institutional front matter. It does not modify the DOCX, PDF, source code, diagrams, or references.

Page references below are PDF page indices from the 59-page current baseline. Markdown line references identify the corresponding editable text mirror.

---

## A. Verified Corrections

| ID | Exact paper location and current wording | Implementation evidence | Verified conclusion | Proposed correction |
|---|---|---|---|---|
| VC-01 | **General Objective**, PDF p. 8, `SENTINEL - Group 8.md:145`: "Davao Security & Intelligence Agency, Inc." | The title page, title of research, proposal title, project context, and purpose use Investigation at `:1,27,67,127,132`. | **Correction required.** The single Intelligence occurrence conflicts with the provisional canonical project title. | Change this occurrence to `Davao Security & Investigation Agency, Inc.` Pending confirmation of final legal styling. |
| VC-02 | **Project Context**, PDF p. 6, `:128`: "centralizing personnel profiles, firearm telemetry, and shift logs" | Firearm code models inventory, allocation, return, permit, maintenance, and status. No firearm-mounted GPS, sensor, or IoT integration was found. The stated study limitation excludes third-party hardware/IoT. | **Correction required.** Telemetry is not implemented. | Replace with the narrow factual phrase `centralizing personnel profiles, firearm inventory and custody records, and shift logs`. |
| VC-03 | **Project Context**, PDF p. 6, `:128`: "Before a guard can be deployed, the system automatically verifies their license validity and firearm authorization" | Shift creation requires an approved/verified guard and rejects overlapping shifts: `handlers/guard_replacement.rs:80-170`. It does not query guard license expiry, firearm permit, training, or firearm status. | **Correction required.** This describes a universal deployment gate that the scheduler does not implement. | State approved-guard and scheduling-conflict validation for scheduling. Describe permit/training checks separately in the firearm allocation workflow. |
| VC-04 | **Project Context**, PDF p. 6, `:128`: "immediately flags the vacancy and identifies the nearest qualified replacement" | No-show route marks overdue un-attended shifts as searching after configured grace time and notifies available guards: `guard_replacement.rs:383-526`. Replacement scoring ranks eligible candidates by reliability, availability, permit state, and last-known distance: `replacement_scoring_service.rs:148-260`. Reassignment is performed by a supervisor request or guard acceptance: `guard_replacement.rs:529-810`. | **Correction required.** Detection and recommendation exist, but the system does not autonomously dispatch the nearest guard or guarantee immediate coverage. | Use: `When a no-show condition is detected, SENTINEL can notify eligible guards and provide ranked replacement recommendations. Authorized personnel or an eligible guard then confirm the reassignment.` |
| VC-05 | **Scope / Technology**, PDF pp. 8-9, `:145,159,165,221`, and **Purpose**, PDF p. 7, `:139`: claims completed cross-platform Web, Desktop, and Android delivery/consistent behavior. **Technology selection**, PDF p. 26, `:334,336`: Capacitor and Tauri "Will be used". | Web application is implemented. Tauri configuration targets MSI/NSIS: `apps/desktop-tauri/src-tauri/tauri.conf.json`. Capacitor configuration and Android release scripts exist: `apps/android-capacitor/*`. No packaged Windows installer UAT or signed Android device UAT was supplied in this audit. | **Correction required.** Existing content both overstates platform validation and uses proposal tense for configured wrappers. | Distinguish: Web is implemented; Windows/Tauri and Android/Capacitor are configured implementation targets pending installer/signed-device validation. |
| VC-06 | **Superadmin Activity Diagram description**, PDF p. 43, `:454`: "role and permission policy administration". Figure 11 image states "Review Roles, Permissions, and Governance Policies" and "Apply Governance, Access, or Policy Updates." | Backend permissions are static code maps: `utils.rs:248-325`; frontend permissions are static maps: `frontend/src/utils/permissions.ts:18-68`. Superadmin can manage lower-ranked users but no runtime RBAC policy editor was found. | **Correction required.** User/role-governed administration is implemented; dynamic permission-policy editing is not. | Replace with `role-scoped user administration and governance review`; remove any implication of editing RBAC policy at runtime. |
| VC-07 | **Figure 20**, PDF p. 47, `:497-500`: caption is `Figure 20. Calendar Module`; its explanatory paragraph describes a geospatial command surface. The embedded screen is `img-19.png`. | Visual verification of `docs/capstone/paper-media/img-19.png` shows the SENTINEL **Operations Map** screen. | **Correction required.** The caption is materially mislabeled. | Change caption to `Figure 20. Operations Map Module`. Keep the explanatory paragraph, subject only to final tense normalization. |
| VC-08 | **Figure 33**, PDF p. 54, `:560-565`: caption is `Figure 33. Maintenance Module`, but it embeds `img-31.png`, the same file used by Figure 32. | Visual verification of `img-31.png` shows **Armored Cars / Fleet Operations**, not a Maintenance module. The intended maintenance screen is not identified by this validation. | **Correction required.** This is a materially incorrect module screenshot. | Replace only Figure 33's image with a current Maintenance module screenshot. Do not assume another existing media file is correct without visual verification. |
| VC-09 | **Development module descriptions**, PDF pp. 44-56, `:457-585`: repeated wording such as "This module will serve..." and "will manage...". | The named modules have current frontend components and backend routes. | **Content correction required.** The requested target is final/as-built content. | Normalize verified module descriptions to present tense. Keep future tense only for documented limitations, recommendations, and approved future work. |

### Scheduling and firearm allocation are separate controls

| Workflow | Verified validation | Documentation-safe wording |
|---|---|---|
| Scheduling | Requires a guard account that is a verified, approved guard; validates required fields, date ordering, and overlapping scheduled/in-progress shifts. It does **not** validate license expiry, firearm permit, training, or firearm status. | `The scheduling workflow validates approved guard status and schedule conflicts before assignment.` |
| Firearm allocation | Requires Supervisor-or-higher permission; normally checks firearm availability, an active unexpired firearm permit, and valid firearms-handling training. | `The firearm allocation workflow validates asset availability, permit status, and applicable firearms-handling training before normal issuance.` |
| Force override | The handler accepts `force=true`, which bypasses normal asset-status, permit, and training checks. The route is role-restricted and write operations receive audit middleware. Whether this is a legitimate business-policy exception has not been confirmed. | Do **not** publish `force=true`. Mark **HUMAN / POLICY CONFIRMATION REQUIRED** before describing an authorized override. |

---

## B. Corrections to the Original Audit

| Original audit statement | Validation result | Corrected audit position |
|---|---|---|
| "Supervisor functional requirement includes request approval" | **Incorrect.** The paper contains no Supervisor Functional Requirement that grants operational-request approval/rejection. | Retract this finding. Do not remove accurate Supervisor text on that basis. |
| Generic Approvals Module sentence at `:482`: "Authorized roles will review pending items and approve or reject requests..." | This sentence does not name Supervisor. It remains consistent if `authorized roles` means Admin/Superadmin for operational-request review. | No role-permission correction is required for this sentence. Optional clarification may name the authorized reviewer roles in final/as-built content. |
| Replace stale module screenshots broadly | Too broad. Visual styling change alone is not a reason to replace an academic figure. | Only Figures 11, 20, and 33 are update-required for implementation accuracy. Other module screenshots are KEEP or OPTIONAL UPDATE as classified below. |
| Guard ID is usable in searchable scheduling selection without qualification | Partly broad. `GuardSearchSelect` is used in the Superadmin Add Schedule flow and has regression coverage. The legacy Edit Schedule modal still uses a native guard select without Guard ID display/search. | Document Guard ID as implemented and searchable in the current Superadmin scheduling-selection workflow; do not claim every schedule control is searchable by Guard ID. |
| Tauri CSP implies the profile-photo crop feature currently fails | This was an inference from the current CSP and Blob-based preview workflow, not packaged-desktop test evidence. | Retain desktop profile-photo validation as a release/UAT requirement; do not state it as a confirmed defect. |

---

## C. Items Overstated in the Original Audit

1. **Supervisor request approval:** The previous audit incorrectly inferred a Supervisor claim. The generic Approvals Module is not a Supervisor-specific statement.
2. **Screenshot replacement scope:** The prior recommendation was broader than needed. Only functionally incorrect, mislabeled, or materially misleading figures require replacement.
3. **Desktop profile-photo behavior:** The repository configuration warrants UAT, but it does not prove an existing packaged-runtime failure.
4. **Guard-selection coverage:** Searchable Guard ID selection is verified for the Superadmin schedule-creation flow, not for every legacy schedule edit control.

No other prior `CORRECTION REQUIRED` finding was invalidated by this validation pass.

---

## D. Exact Paper Locations to Change

| Priority | PDF page | Markdown location | Paper element | Required content action |
|---|---:|---:|---|---|
| P0 | 6 | `:128` | Project Context | Replace firearm telemetry, split scheduling checks from firearm-allocation checks, and replace autonomous/nearest replacement language. |
| P0 | 8 | `:145` | General Objective | Correct Intelligence to Investigation; revise platform maturity wording. |
| P0 | 7 | `:139` | Purpose and Description | Replace completed cross-platform parity statement with web-implemented/configured-wrapper distinction. |
| P0 | 9 | `:159,165,221` | Objective 6 and Scope/Technology | Narrow Web/Desktop/Android maturity claims. |
| P0 | 26 | `:334,336` | Technology selection | Use final/as-built content wording: configured Capacitor/Tauri targets pending release validation. |
| P0 | 43 | `:454` | Figure 11 explanatory paragraph | Remove dynamic role/permission policy administration claim. |
| P0 | 47 | `:497-500` | Figure 20 caption | Rename Calendar Module to Operations Map Module. |
| P0 | 54 | `:560-565` | Figure 33 | Replace incorrect Armored Cars screenshot with Maintenance screenshot. |
| P1 | 44-56 | `:457-585` | Development module descriptions | Normalize verified module language to present tense. Do not change permissions beyond verified facts. |
| P2 | 8-10, 33-34 | `:165-229,393-406` | Scope, limitations, requirements analysis | Apply narrower analytical, tracking, platform, and decision-support wording where applicable. |

### Organization-name occurrence audit

The provisional canonical form is: **Davao Security & Investigation Agency, Inc.**

| PDF page | Markdown line | Occurrence | Action |
|---|---:|---|---|
| 3 | `:27` | Title of Research uses Investigation. | Keep pending legal-styling confirmation. |
| 4 | `:51` | Proposal-defense form context. | Institutional front matter: do not alter without approval. |
| 5 | `:67,73` | Proposal/approval wording uses Investigation. | Institutional front matter: do not alter without approval. |
| 6 | `:127,132` | Project Context and Purpose use `Davao Security and Investigation Agency, Inc.` | Content: normalize only after legal-styling confirmation. |
| 8 | `:145` | General Objective uses **Intelligence**. | Correct in content revision. |

---

## E. Exact Diagrams to Change

| Figure | Current classification | Validation result | Required action |
|---|---|---|---|
| 8 Guard Activity Diagram | KEEP | Current guard workflow broadly reflects authentication, approval/consent, scheduling, attendance, incident, support, and panic workflows. | No accuracy-driven replacement. Optional wording update only if final content needs more explicit device/offline limitations. |
| 9 Supervisor Activity Diagram | KEEP | Shows manual selection of an available guard and reassignment. It does not claim nearest-guard dispatch or autonomous replacement. | Keep. Do not introduce a false autonomous-dispatch correction. |
| 10 Administrator Activity Diagram | KEEP | Consistent with approval, scheduling, and asset/compliance governance at a high level. | Keep unless the team wants a current visual refresh. |
| 11 Superadmin Activity Diagram | UPDATE REQUIRED | Diagram and paragraph imply runtime review/editing of roles, permissions, governance policies, and policy updates. Static RBAC implementation does not provide a permission-policy editor. | Replace/adjust labels to user administration, role-scoped governance, audit review, and authorized governance actions. |
| 12-19 Module Figures | KEEP | No material function/permission contradiction was validated. | Preserve unless a current screenshot is preferred for presentation quality. |
| 20 Operations Map | UPDATE REQUIRED | Embedded screen is Operations Map but caption says Calendar. | Correct caption only; no screenshot replacement required. |
| 21-32 Module Figures | KEEP | No material mismatch was validated. | Preserve unless optional screenshot refresh is desired. |
| 33 Maintenance Module | UPDATE REQUIRED | Uses the same Armored Cars image as Figure 32. | Replace with verified current Maintenance screen. |
| 34-37 Module Figures | KEEP | Images correspond to Analytics, Audit, Profile, and Settings. | Preserve unless optional screenshot refresh is desired. |

**Not a required screenshot update:** minor visual/UI styling changes alone.

---

## F. Confirmed Role and Permission Changes

| Capability | Supervisor implementation status | Evidence |
|---|---|---|
| View/search guards | Confirmed. Resource Management presents a Guards tab with search including Guard ID. | `ResourceManagementPanel.tsx:486-543`; `users.rs:330-385` |
| Create guard accounts | Confirmed. A Supervisor may create only a lower-ranked Guard account; created guard account is pending Admin/Superadmin approval. | `utils.rs:331-340`; `users.rs:177-325` |
| Create Supervisor, Admin, or Superadmin | Denied. Role-rank enforcement requires actor rank to exceed target rank. | `utils.rs:223-245,331-340` |
| Update permitted Guard records | Confirmed, subject to target-role hierarchy and self-or-supervisor access control. | `users.rs`; `ResourceManagementPanel.tsx:104-111` |
| Delete user accounts | Denied. Backend requires Admin minimum role; UI explains the restriction at page level. | `users.rs:824+`; `ResourceManagementPanel.tsx:108-111` |
| View/add/update/delete firearms | Confirmed for Supervisor through `manage_firearms`; write routes include audit middleware. | `utils.rs:285-302`; `middleware/authz.rs:86-97`; `main.rs` firearm routes |
| View/add/update/delete armored vehicles | Confirmed for Supervisor through `manage_armored_cars`; write routes include audit middleware. | `utils.rs:285-302`; `middleware/authz.rs:99-106`; `main.rs` armored-car routes |
| View/add/update/delete client sites | Confirmed for Supervisor because tracking access explicitly includes Supervisor; client-site routes use that protection and write audit middleware. | `middleware/authz.rs:7-14,65-82`; `main.rs` tracking client-site routes |
| Edit RBAC policy | Not implemented for Supervisor, Admin, or Superadmin as a runtime UI/API policy editor. | Static maps in `utils.rs:248-325` and `frontend/src/utils/permissions.ts:18-68` |
| Review/approve/reject operational requests | Not granted to Supervisor. Admin/Superadmin have `review_operational_requests`; protected request routes require that permission. | `utils.rs:248-325`; `middleware/authz.rs:132-140`; `main.rs:1178-1193` |

### Paper impact

- Figure 11 and its explanatory paragraph require correction for static RBAC.
- Figure 15 Supervisor Module and the Supervisor functional description may add the confirmed resource-management scope if the team wants the paper to describe the current implementation more fully.
- No paper text must be removed for Supervisor operational-request approval because no such Supervisor-specific claim was found.

---

## G. Confirmed Objective and Scope Changes

| Paper area | Validated change |
|---|---|
| Specific Objective 1 | Keep secure access/approval/legal compliance objective. It is supported by implemented authentication, role hierarchy, approval workflow, and consent controls. |
| Specific Objective 2 | Keep scheduling, attendance, DTR, check-in/out, and replacement coordination. Add approved-guard/conflict validation if describing controls. Do not call it a universal license/firearm deployment gate. |
| Specific Objective 3 | Keep asset accountability. Describe firearm allocation as permit/training/asset-status checked under normal issuance; do not expose implementation parameter names. |
| Specific Objective 4 | Keep field operations and monitoring. Qualify location as device/application-derived and network dependent; retain partial offline wording. |
| Specific Objective 5 | Keep analytics. Use `rule-based decision support`, `risk scoring`, `ranked recommendations`, and `analytical outputs`. Vehicle and guard absence services are legitimate forward-looking rule-based risk estimates, but they are not predictive statistical or ML models. Incident severity is keyword-rule classification. |
| Specific Objective 6 | Revise platform claim: Web is implemented; Windows/Tauri and Android/Capacitor are configured targets pending packaged/signed release validation. Keep audit/approval/reporting traceability. |
| Scope - Guard ID | Add Guard ID under Personnel Data and/or scheduling process description. It supports identity clarity and existing personnel/scheduling objectives; it does not require a new Specific Objective. |
| Scope - replacement | Describe no-show detection, eligible-guard notification, ranked recommendation, and human/eligible-guard confirmation. |

### Guard ID validation

Guard ID is confirmed as:

- **Implemented and persisted:** `users.guard_code` is added and returned by user APIs.
- **Unique and human-readable:** PostgreSQL sequence/trigger generates `G-0001`-style codes; unique index and format check protect the value.
- **Displayed and searchable:** Resource Management displays `Guard ID: G-...` and searches Guard ID, name, email, phone, and license.
- **Usable in scheduling selection:** `GuardSearchSelect` renders `Guard ID - Name`, searches Guard ID/name/username, and is used in the Superadmin Add Schedule flow. Existing regression coverage verifies Guard-ID filtering and selection.
- **Current boundary:** The legacy Edit Schedule modal remains a native guard select; do not document universal searchable selection until that control is migrated.

**Recommended paper placement:** Scope/Data (personnel profiles), Specific Objective 2 narrative, Scheduling Module description, and Figure 18 explanatory text if the screenshot/description is refreshed.

---

## H. Human Decisions Still Required

1. Confirm the final legal styling of `Davao Security & Investigation Agency, Inc.` before normalizing all title/content occurrences.
2. Confirm whether the paper may state Web as deployed/available, or only implemented, and supply Windows installer/UAT and signed Android/device-UAT evidence before claiming validated cross-platform delivery.
3. Confirm whether the firearm allocation override is an approved business policy. Technical evidence supports role restriction and audit middleware; policy authorization must be confirmed separately.
4. Approve final/as-built content tense conversion without changing endorsement forms, approval sheets, proposal-defense labels, signature pages, or other institutional front matter.
5. Select a verified, sanitized Maintenance screenshot for Figure 33.
6. Decide whether to add Supervisor resource-management capability to the written scope/module description. It is implemented, but the paper may remain concise if it does not omit a required research claim.
7. Perform the separate reference/legal/vendor verification pass. No reference removal or modification is approved by this addendum.

---

## I. Final Approved Change List for the DOCX

The following is approved for a future implementation-alignment edit. It excludes institutional front matter and the References section.

### P0 - factual corrections

1. Correct `Intelligence` to `Investigation` in the General Objective.
2. Replace `firearm telemetry` with firearm inventory, allocation/custody, permit, and maintenance records.
3. Replace the universal automatic deployment-compliance claim with the two verified workflow descriptions: approved-guard/conflict scheduling validation and normal firearm allocation validation.
4. Replace autonomous/nearest replacement wording with no-show detection, eligible-guard notification, ranked recommendation, and confirmed reassignment language.
5. Correct platform maturity throughout objective/scope/purpose/technology content: Web implemented; Tauri and Capacitor configured targets pending release validation.
6. Remove dynamic permission-policy administration wording from Figure 11 and its explanation; retain role-scoped user administration/governance review.
7. Rename Figure 20 to `Operations Map Module`.
8. Replace Figure 33 with a verified Maintenance screenshot.

### P1 - final/as-built content consistency

1. Convert verified module descriptions and technology descriptions from future tense to present/past tense.
2. Retain future tense only for limitations, recommendations, explicitly planned work, or unvalidated release targets.
3. Add Guard ID to existing personnel/scheduling scope documentation without adding a seventh specific objective.
4. Use accurate analytical terms: rule-based decision support, risk scoring, ranked recommendations, analytical outputs, and rule-based forward-looking estimates where appropriate.
5. Optionally clarify that Admin/Superadmin are operational-request reviewers, while Supervisor can create/view requests where authorized. This is clarification, not a correction to an existing Supervisor claim.

### Explicitly not approved for change in this pass

- Endorsement forms, approval sheets, proposal-defense labels, signature pages, and other institutional front matter.
- References, legal claims, research citations, vendor comparisons, and figure-source permissions.
- Screenshots other than Figures 11, 20, and 33 solely because the UI styling changed.
- Any source-code or backend authorization behavior.

---

## Evidence Index

- Paper text: `SENTINEL - Group 8.md:1-585`; PDF pages 3, 6-9, 26, 43, 46-47, 53-56.
- Supervisor workflow image: `docs/capstone/paper-media/img-08.png`.
- Superadmin workflow image: `docs/capstone/paper-media/img-10.png`.
- Operations Map image: `docs/capstone/paper-media/img-19.png`.
- Duplicate Armored Cars / Maintenance image: `docs/capstone/paper-media/img-31.png` used at `SENTINEL - Group 8.md:558,563`.
- Roles/permissions: `DasiaAIO-Backend/src/utils.rs:223-340`, `DasiaAIO-Backend/src/middleware/authz.rs:7-140`.
- User lifecycle and Guard ID: `DasiaAIO-Backend/src/handlers/users.rs:177-544,824+`, `DasiaAIO-Backend/src/db.rs:496-604`.
- Workforce workflow: `DasiaAIO-Backend/src/handlers/guard_replacement.rs:80-170,383-810` and `src/services/replacement_scoring_service.rs:148-260`.
- Firearm issuance: `DasiaAIO-Backend/src/handlers/firearm_allocation.rs:22-136`; route audit middleware in `src/main.rs`.
- Analytics: `src/services/guard_prediction_service.rs`, `vehicle_predictive_service.rs`, and `incident_severity_classifier.rs`.
- Supervisor resource management: `DasiaAIO-Frontend/src/components/admin/ResourceManagementPanel.tsx:79-145,486-543` and protected backend routes in `src/main.rs`.
- Guard selector: `DasiaAIO-Frontend/src/components/shared/GuardSearchSelect.tsx` and `src/components/admin/SuperadminDashboard.tsx:1676+`.

**Validation conclusion:** The paper is ready for a narrowly scoped final/as-built content edit after the human decisions above are confirmed. The DOCX itself remains unmodified.
