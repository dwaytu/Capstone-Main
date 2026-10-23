# SENTINEL Presentation Data Consistency and Realism Audit

**Environment:** `https://dasiasentinel.xyz` (Railway capstone presentation environment)  
**Audit date:** 2026-10-18, Asia/Manila  
**Scope:** Read-only application, database, source-code, and capstone-runner review. No database rows were inserted, updated, deleted, reset, or reseeded during this audit.

## Method and Evidence

- Executed the read-only `capstone-dataset consistency-audit` command against the Railway backend database.
- Executed the existing capstone schedule, enrichment, fleet, and attributed-audit validations.
- Reviewed the firearm allocation API, MDR import service, paginated firearm and user APIs, and the allocation screen data loading logic.
- Confirmed the runner still validates 55 capstone guards, 11 stable site rosters, 564 shifts, 528 attendance records, 66 Sunday coverage slots, zero shift overlaps, and zero insufficient-rest violations.

## Findings

| Severity | Module | Issue | Expected | Actual | Root cause | Proposed fix |
| --- | --- | --- | --- | --- | --- | --- |
| High | Firearms / custody | Firearm status does not reconcile to active custody. | Each firearm marked `allocated`/`deployed` has one active allocation, unless a separately defined status explains otherwise. | 99 firearms are allocated; 64 active allocations exist; 35 allocated firearms have no active custody record. | All 35 are MDR-linked. The MDR importer marks a newly encountered firearm `allocated` before it has established a valid guard-firearm pair; it creates an allocation only when both records can be used. | Fix the importer so status follows the resulting custody state. After backup, classify each of the 35 legacy rows from its MDR staging evidence before any targeted status repair. Do not bulk-mark them available. |
| High | Firearms / UI | Allocation screen reports incomplete inventory and misleading eligibility. | Inventory, availability, and guard eligibility should reflect complete API data and backend rules. | Database: 110 firearms and 3 available. Screen: 50 registered in Resource Management and 0 available in Allocation; Allocation displays 48 eligible guards. | `FirearmAllocation.tsx` fetches `/api/firearms` and `/api/users` without pagination; both endpoints default to 50. It filters the partial user page by role and calls that eligibility. | Add complete paginated loading or a dedicated summary/eligibility endpoint; show separate Available firearms and Eligible guards cards; disable allocation only when complete availability is zero. |
| High | Firearms / authorization | Guard eligibility is not enforced as a complete business rule on issue. | A normal issue must target an approved, active guard with valid permit and firearms-handling training. | The issue handler only verifies that a user exists, then checks permit and training. It does not verify guard role, active status, or approval state. The policy-complete audit count is 0 eligible guards. | The handler's guard lookup is `SELECT id FROM users`; policy requirements are distributed and not represented by a shared eligibility query. | Enforce role/status/approval in the backend transaction and expose the same predicate for the allocation selector. Preserve `force=true` as the explicit authorized override path only. |
| Medium | Firearms / historical realism | All 65 allocation records carry the same date. | Historical allocation dates should represent known custody dates or clearly represent import processing when source dates are unavailable. | All 65 allocation rows are MDR-linked and dated 2026-09-18. | The importer inserts allocations with the database default timestamp rather than a source event date. | Retain the original rows and provenance. Add an import-context label in the UI; backfill dates only where the MDR source contains a defensible custody date. |
| Medium | Firearms / data quality | Manufacturer naming is inconsistent and three firearms have no make. | Display manufacturer consistently when the source identifies it. | `Armscor` 86, `Amscor` 2, plus mixed casing and 3 blank makes. | MDR source normalization preserves raw make values. | Define a small authoritative normalization map with an exception review list; preserve serial numbers and raw MDR provenance. |
| Medium | Tracking | Historical tracking contains orphan guard targets outside the current capstone batch. | `entity_type=guard` points to an existing user. | 108 of 807 guard tracking points point to removed users; none belong to the current capstone seed ledger. | Legacy/non-current tracking rows use an unconstrained `entity_id`; only `user_id` has a foreign key. | Do not delete them blindly. Inventory the 108 legacy rows, then either map them to retained historical actors or archive them with explicit provenance after approval. Add a guard-target integrity check to ongoing validation. |
| Medium | Notifications | The inbox has a large unread backlog. | Presentation inbox should communicate current operational attention, not accumulate indistinguishable stale alerts. | 195 of 226 notifications are unread; none have orphan recipients. | Historical notification state has not been curated after prior imports/seeds. | Review age/type/recipient distribution, then mark only demonstrably historical notices read or create a bounded presentation inbox view. Do not mass-mark records without approval. |
| Low | Incident intelligence | Classification coverage is partial, though references are valid. | Every classification links to a valid incident; whether every incident requires classification is a product decision. | 19 incidents, 7 classifications, zero orphan classifications. | The enrichment batch classifies selected scenarios rather than every incident. | Decide whether classification is required for all incidents. If so, add deterministic classifications to the 12 unclassified rows; otherwise label the metric as coverage, not a data error. |

## Verified Healthy Areas

| Module | Result |
| --- | --- |
| Identity and audit integrity | 155 users; zero duplicate guard codes; 18,473 audit rows; zero orphan actors; all 174 `capstone_seed` actors are registered to the batch. |
| Firearm record uniqueness | 110 firearms; zero duplicate serial numbers; all firearm statuses recognized; zero duplicate active firearm allocations; zero guards with multiple active firearms. |
| Allocation chronology | Zero active allocations with return dates, zero returned allocations without return dates, zero invalid allocation/return chronologies. One returned row remains associated with an `allocated` firearm and is included in the 35 custody-status mismatch. |
| Schedule and attendance | 564 shifts, 528 attendance rows, zero attendance without a shift, zero guard-shift mismatches, zero check-out-before-check-in, zero future completed attendance, zero overlap, and zero insufficient-rest violations. |
| Fleet and trips | Five allocated vehicles, 75 completed trips, zero trip chronology errors, zero completed trips without an end, zero vehicle overlaps, zero future trips, and no Sunday trips by intentional fleet policy. |
| Requests, feedback, and support | 11 requests and 26 events with zero orphan/before-request events; 23 feedback entries with zero orphan users and a 3.96 average rating; 10 tickets with zero orphan guards. |
| Referential integrity | Zero orphan notifications, classifications, feedback users, support-ticket guards, and seeded audit actors. |

## Stage 2 Targeted Remediation Plan

1. **Preserve first.** Create and validate a recoverable PostgreSQL backup; record the real verification timestamp before any write.
2. **Correct current behavior without altering history.** Add complete pagination/summary loading to the firearm and allocation views, separate the five allocation metrics, implement search/filter/pagination, and use a backend-backed eligible-guard result.
3. **Close the future-integrity gap.** Make firearm issue/return operations transactional, enforce the normal guard eligibility predicate, and add a partial unique index for one active allocation per firearm. Do not add a one-firearm-per-guard rule because the current business model does not establish that constraint.
4. **Repair only provenance-supported firearm rows.** Review the 35 MDR-linked firearms against their staging rows. Apply status changes only when a row's MDR evidence supports a target state; retain `mdr_batch_id`, `mdr_row_ref`, and audit entries for every change. Do not invent backdated allocation dates.
5. **Handle non-current legacy records separately.** Produce a row-level inventory for the 108 orphan tracking points and notification backlog, then remediate only an approved, clearly classified subset. Re-run the reusable integrity checks, schedule/fleet validations, and authenticated live UI verification after each approved group.

## Approval Boundary

No Stage 2 data mutation has been performed. Approval is required before the backup-and-fix stage, particularly for any repair to the 35 MDR-linked firearm statuses, the 108 legacy tracking points, or notification read states.
