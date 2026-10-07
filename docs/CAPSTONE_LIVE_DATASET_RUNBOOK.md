# SENTINEL Live Capstone Dataset Runbook

The final capstone dataset runs inside the existing Railway `production`
environment that serves `https://dasiasentinel.xyz`. It does not require a
second browser-facing application and it does not replace the production
database, authentication configuration, or Superadmin accounts.

## Preconditions

Before seed or reset, create a logical PostgreSQL backup and verify its archive
listing. The Railway Postgres volume can also be backed up from the Railway
service's **Backups** panel.

The live target must have:

- at least 50 active guards without an existing feedback record;
- active Tagum City client sites;
- active `OSCAR GAGA-A` Admin and `SENDRICK SOLIS` Supervisor accounts; and
- the protected active Superadmin account identified by its actual ID.

The seeder never creates or updates users, client sites, firearms, armored
vehicles, role assignments, passwords, authentication data, or maintenance
records. It uses existing guards, Tagum sites, OSCAR GAGA-A, and SENDRICK SOLIS.

## Required explicit variables

```powershell
$env:CAPSTONE_DATASET_MODE = 'true'
$env:CAPSTONE_TARGET_ENVIRONMENT = 'production'
$env:CAPSTONE_SEED_CONFIRM = 'LIVE_CAPSTONE_DATASET_CONFIRMED'
$env:CAPSTONE_TARGET_DATABASE_URL = '<production DATABASE_PUBLIC_URL>'
$env:CAPSTONE_PROTECTED_SUPERADMIN_ID = '<active production Superadmin UUID>'
$env:CAPSTONE_REFERENCE_DATE = '2026-10-17T17:00:00+08:00'
```

`CAPSTONE_TARGET_DATABASE_URL` is mandatory. The seeder deliberately does not
fall back to `DATABASE_URL` or `DATABASE_PUBLIC_URL`.

## Commands

```powershell
./DasiaAIO-Backend/scripts/capstone-live-dataset.ps1 seed
./DasiaAIO-Backend/scripts/capstone-live-dataset.ps1 status
./DasiaAIO-Backend/scripts/capstone-live-dataset.ps1 reset
```

`seed` is idempotent: it first removes the existing `capstone-live-october-2026`
batch, then creates the replacement batch. `reset` deletes only IDs stored in
`capstone_seed_records`; it never truncates a table or selects records by a
timestamp, label, or role.

## Provenance and reference time

`capstone_seed_batches` stores the batch, date range, source scope, and existing
actor IDs. `capstone_seed_records` maps every generated row to that batch. Audit
and request-event metadata also include `data_origin=capstone_live_seed` and
the batch ID.

For deterministic capstone views, set these **production Backend** variables:

```text
CAPSTONE_REFERENCE_CLOCK_MODE=capstone-live
CAPSTONE_REFERENCE_DATE=2026-10-17T17:00:00+08:00
```

Only read-side operational calculations that explicitly use `sentinel_now()`
receive the reference time. Authentication events, real audit writes, account
updates, and normal write timestamps continue to use PostgreSQL's actual clock.
