# SENTINEL firearm register reconciliation

The read-only audit covered the Railway database behind `dasiasentinel.xyz`. The frontend domain, backend target marker `capstone_presentation`, and Postgres service were verified before any deployment. The backup was fully restored into disposable PostgreSQL 17. The release preserves historic records, their source links, and the issuance requirements.

| Origin | Active | Returned | Unverified status | Total before | Total after |
| --- | ---: | ---: | ---: | ---: | ---: |
| Application-recorded | 0 | 0 | 0 | 0 | 0 |
| Imported | 0 | 1 | 64 | 65 | 65 |
| Presentation / test | 0 | 528 | 0 | 528 | 528 |
| Unknown | 0 | 0 | 0 | 0 | 0 |
| **Total** | **0** | **529** | **64** | **593** | **593** |

The register counts allocation rows. Returning a firearm updates the existing row and sets its return timestamp. The 529 returned statuses include 528 presentation records and one imported record. Import origin and returned status therefore overlap by one row. No row is marked active. Separately, 46 inventory records are marked issued and have no active register entry. They remain flagged for custody review.

## Correction log

| Correction | Reason and supporting reference |
| --- | --- |
| Classify the 528 presentation rows explicitly | Source `capstone_custody`, batch `sentinel-october-2026-firearm-custody-v1`, and membership in `capstone_seed_records` independently establish presentation provenance. The former register API treated the absence of an MDR batch as application-recorded. |
| Show all 65 imported rows in the origin totals | Each has an MDR batch and source row reference. The former imported KPI counted the 64 rows with raw status `imported` and omitted the one imported row with raw status `returned`. The new breakdown shows both without double counting them in the total. The legacy API status count remains available for its existing consumers. |
| Separate active status from document verification | No active row exists in the audited data. If raw active rows appear under the current schema, the page reports the documentation count as unverified. Inventory status, an application date, and imported status do not establish verified custody. |
| Keep legacy default sources conservative | Source `runtime` is a schema default and cannot establish provenance by itself. The new view uses explicit application provenance for future application-created rows. Older rows without an explicit source or ledger link remain unknown. |

The current security guard license count is 89 among active, approved accounts. The hosted permits and training tables contain zero rows. The available MDR workbook and importer mappings describe guard licenses and inventory/history records. They provided no approved guard-specific firearm permit and firearms-handling training evidence with both dates and an attributable source. No qualification was imported, no existing database row was rewritten, and no guard became newly eligible.

## Deployment and verification

- Railway frontend deployment `7e931194-7d78-4c4e-80a4-f371c5622fc3` and backend deployment `41612884-d86a-42d6-a8ca-da918b8ee644` succeeded. The hosted site and backend health returned HTTP 200.
- Backup `sentinel-before-register-reconciliation-20261118.dump` lives in the local `sentinel-presentation-20261118` temporary release directory. Its SHA-256 is `c6b4cca676d7102c49ce7a99af9597b12bd22e788c4c5ca37504d590e8489685`.
- The exact reporting query against the restored backup and a read-only query against the deployed view returned the same breakdown. PostgreSQL tests in the isolated restore also distinguished explicit application origin from the legacy default.
- TypeScript, Vite, Rust formatting, Git whitespace checks, 239 Jest tests, 55 Rust server tests, and seven isolated Playwright scenarios passed. Browser verification on the final hosted frontend at 1440, 768, 390, and 320 pixels used the freshly queried aggregate counts through API interception. It did not require a live privileged login. Screenshots and assertions are in `DasiaAIO-Frontend/output/playwright/register-hosted/`.
