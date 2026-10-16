# SENTINEL Live Capstone Dataset Runbook

The final capstone presentation dataset runs inside the existing Railway `production`
environment that serves `https://dasiasentinel.xyz`. It does not require a
second browser-facing application and it does not replace the production
database, authentication configuration, or Superadmin accounts.

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
records. It uses existing guards and active Tagum sites only for the
presentation roster. Generated records are tracked by the batch ledger with
`data_origin=capstone_presentation_seed`. It does not generate feedback,
location telemetry, operational requests, or audit activity impersonating a
real user.

## Required explicit variables

```powershell
$env:CAPSTONE_DATASET_MODE = 'true'
$env:CAPSTONE_TARGET_ENVIRONMENT = 'production'
$env:CAPSTONE_SEED_CONFIRM = 'LIVE_CAPSTONE_DATASET_CONFIRMED'
$env:CAPSTONE_TARGET_DATABASE_URL = '<production DATABASE_PUBLIC_URL>'
$env:CAPSTONE_PROTECTED_SUPERADMIN_ID = '<active production Superadmin UUID>'
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
```

Run `preflight` first. It prints the exact selected Tagum sites and validates
the stable five-guard rosters, all Sunday coverage, overnight shifts, and
minimum rest before any records are changed. `seed` requires
`CAPSTONE_BACKUP_VERIFIED_AT`, removes only the existing
`capstone-live-october-2026` batch, then creates its replacement. `reset`
also requires the verified-backup timestamp and deletes only IDs stored in
`capstone_seed_records`; it never truncates a table or selects records by a
timestamp, label, or role.

## Provenance and reference time

`capstone_seed_batches` stores the batch, date range, source scope, and
`data_origin=capstone_presentation_seed`. `capstone_seed_records` maps every
generated row to that batch. The sole generated audit entry has no real-user
actor and identifies `CAPSTONE DATASET SEEDER` in metadata.

The dataset has completed presentation history only through October 16, 2026.
All October 17 shifts are scheduled only: there are no October 17 attendance,
check-out, feedback, or completed audit records.

For deterministic capstone views, set these **production Backend** variables:

```text
CAPSTONE_REFERENCE_CLOCK_MODE=capstone-live
CAPSTONE_REFERENCE_DATE=2026-10-17T17:00:00+08:00
```

Only read-side operational calculations that explicitly use `sentinel_now()`
receive the reference time. Authentication events, real audit writes, account
updates, and normal write timestamps continue to use PostgreSQL's actual clock.
