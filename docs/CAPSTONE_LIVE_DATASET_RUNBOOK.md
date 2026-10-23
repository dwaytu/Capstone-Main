# SENTINEL Live Capstone Dataset Runbook

The final capstone presentation dataset runs in the dedicated Railway-backed
presentation environment served at `https://dasiasentinel.xyz`. It does not
require a second browser-facing application. The Railway environment may retain
the platform name `production`; the dataset runner separately requires its
explicit `capstone_presentation` target designation for attributed history.

## Preconditions

Before seed or reset, create a logical PostgreSQL backup and verify its archive
listing. The Railway Postgres volume can also be backed up from the Railway
service's **Backups** panel.

The live target must have:

- enough active, currently available guards without an existing merit score to
  form five-guard primary rosters for every selected Tagum site (up to 55);
- active Tagum City client sites;
- the protected active Superadmin account identified by its actual ID.

The seeder never creates or updates users, client sites, firearms, armored
vehicles, role assignments, passwords, authentication data, or maintenance
records. It uses existing synthetic guards and active Tagum sites only for the
presentation roster. Generated records are tracked by the batch ledger with
`data_origin=capstone_presentation_seed`.

## Required explicit variables

```powershell
$env:CAPSTONE_DATASET_MODE = 'true'
$env:CAPSTONE_TARGET_ENVIRONMENT = 'capstone_presentation'
$env:CAPSTONE_SEED_CONFIRM = 'LIVE_CAPSTONE_DATASET_CONFIRMED'
$env:CAPSTONE_TARGET_DATABASE_URL = '<presentation DATABASE_PUBLIC_URL>'
$env:CAPSTONE_PROTECTED_SUPERADMIN_ID = '<protected Superadmin UUID>'
$env:CAPSTONE_BACKUP_VERIFIED_AT = '<RFC 3339 time of verified logical backup>'
$env:CAPSTONE_REFERENCE_DATE = '2026-10-17T17:00:00+08:00'
```

`CAPSTONE_TARGET_DATABASE_URL` is mandatory. The seeder deliberately does not
fall back to `DATABASE_URL` or `DATABASE_PUBLIC_URL`.

## Commands

```powershell
./DasiaAIO-Backend/scripts/capstone-live-dataset.ps1 seed
./DasiaAIO-Backend/scripts/capstone-live-dataset.ps1 status
./DasiaAIO-Backend/scripts/capstone-live-dataset.ps1 reset
./DasiaAIO-Backend/scripts/capstone-live-dataset.ps1 preflight
./DasiaAIO-Backend/scripts/capstone-live-dataset.ps1 validate
./DasiaAIO-Backend/scripts/capstone-live-dataset.ps1 audit-preflight
./DasiaAIO-Backend/scripts/capstone-live-dataset.ps1 seed-audit-activity
./DasiaAIO-Backend/scripts/capstone-live-dataset.ps1 fleet-preflight
./DasiaAIO-Backend/scripts/capstone-live-dataset.ps1 enrich-fleet
./DasiaAIO-Backend/scripts/capstone-live-dataset.ps1 fleet-validate
```

Run `preflight` first. It prints the exact selected Tagum sites and validates
the stable five-guard rosters, all Sunday coverage, overnight shifts, and
minimum rest before any records are changed. `seed` requires
`CAPSTONE_BACKUP_VERIFIED_AT`, removes only the existing
`capstone-live-october-2026` batch, then creates its replacement. `reset`
also requires the verified-backup timestamp and deletes only IDs stored in
`capstone_seed_records`; it never truncates a table or selects records by a
timestamp, label, or role.

## Synthetic audit history

`seed-audit-activity` is a separate, idempotent batch. It is only available
when all of these explicit controls are set:

```text
CAPSTONE_TARGET_ENVIRONMENT=capstone_presentation
CAPSTONE_PRESENTATION_ENVIRONMENT=true
CAPSTONE_ALLOW_SYNTHETIC_AUDIT_HISTORY=true
```

The command registers only the 55 ledger-tracked synthetic guards and the
ledger-tracked synthetic supervisor and administrator in `capstone_seed_actors`.
It rejects protected Superadmins, non-capstone accounts, inactive users, and
all action types outside its fixed operational allow-list. Each generated row
retains `source=capstone_seed`, `actor_attribution_mode=synthetic_seeded`, its
batch ID, seed time, scenario time, and ledger record for selective reset. It
does not modify authentication-provider or session tables.

## Provenance and reference time

`capstone_seed_batches` stores the batch, date range, source scope, and
`data_origin=capstone_presentation_seed`. `capstone_seed_records` maps every
generated row to its batch. Synthetic audit history is stored in its own child
batch and remains internally traceable without adding a presentation label to
the normal audit table.

The dataset has completed presentation history only through October 16, 2026.
All October 17 shifts are scheduled only: there are no October 17 attendance,
check-out, feedback, or completed audit records.

## Armored fleet enrichment

`enrich-fleet` is a separate, additive, idempotent child batch. It requires the
same verified-backup control as the base write commands and the explicit
presentation-environment controls. Run `fleet-preflight` first; it prints the
exact `VEHICLE | PLATE | DRIVER | PRIMARY BANK` mapping before it writes.

The runner requires exactly five existing armored vehicles and one existing
active driver per vehicle. It creates only a stable active allocation where one
is missing, records one complete daily trip for each vehicle from October 1-17
on Monday-Saturday, and keeps vehicle status `allocated` rather than leaving a
historical vehicle in transit. A daily trip represents the known `DASIA Base ->
assigned bank -> DASIA Base` movement. It does not create a downstream bank
route, extra stops, coordinates, or a fabricated distance. All generated trip
and allocation IDs are ledger-tracked; reset restores only the status that this
child batch originally changed.

For deterministic capstone views, set these presentation Backend variables:

```text
CAPSTONE_REFERENCE_CLOCK_MODE=capstone-live
CAPSTONE_REFERENCE_DATE=2026-10-17T17:00:00+08:00
```

Only read-side operational calculations that explicitly use `sentinel_now()`
receive the reference time. Authentication events, real audit writes, account
updates, and normal write timestamps continue to use PostgreSQL's actual clock.
