# Legacy Tracking Review - 2026-10-18

## Scope and method

This is a read-only review of historical tracking points whose `entity_type` is
`guard` but whose `entity_id` does not resolve to a current `users` row. The
evidence was collected from the guarded `capstone-dataset review-inventory`
command against the SENTINEL capstone presentation database. No tracking point,
firearm, user, or audit record was changed by this review.

## Result

- Orphan guard-target tracking points: **108**
- All 108 points are older than 30 days relative to the presentation clock.
- All four target IDs have `target_user_exists=false` and `user_ref=false`.
- All four groups retain a `created_by` reference, but none is registered in
  `capstone_seed_records`; they are legacy data, not records from the current
  capstone seed batch.

| Entity ID | Points | First recorded (Asia/Manila) | Last recorded (Asia/Manila) | Label | Target user exists | User reference | Creator reference | Current capstone provenance |
| --- | ---: | --- | --- | --- | --- | --- | --- | --- |
| `15ddd0bc-891a-4b6c-9892-48527d41809e` | 5 | 2026-05-06 18:43:07 | 2026-05-06 18:45:11 | abcd | No | No | Yes | No |
| `58889b64-1c10-45fe-8de5-ab7732d6f5f2` | 35 | 2026-04-05 11:11:02 | 2026-04-10 02:24:45 | Guard User | No | No | Yes | No |
| `97298b88-520f-4d54-b2d9-149a2d4da2f8` | 16 | 2026-05-06 18:48:24 | 2026-05-06 18:58:18 | guard | No | No | Yes | No |
| `c4d1cc5e-b066-45e9-a6e2-977ad2fe1a51` | 52 | 2026-04-13 20:12:33 | 2026-04-24 15:13:51 | guardtest01 | No | No | Yes | No |

## Live/current assessment

These points cannot represent a current guard location in the present system:
their target IDs have no current user record, and they have no valid `user_id`
reference. They should not be used for current operational tracking or guard
history. The points remain in the database as historical legacy evidence; this
stage intentionally does not delete, reassign, or synthesize a replacement
identity for them.

## Recommendation

Keep the 108 points out of current-operational views and queue a separate,
approved data-governance decision: either preserve them as archived legacy
history with an explicit provenance label, or remove them only after a reviewed
retention decision. Do not automatically attach them to a current guard based
on a label such as `Guard User` or `guardtest01`.
