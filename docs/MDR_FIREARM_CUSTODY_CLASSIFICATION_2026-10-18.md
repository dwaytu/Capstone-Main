# MDR Firearm Custody Classification - 2026-10-18

## Scope and Decision Boundary

This is a read-only classification of the 35 firearms in MDR batch
`ac536804-edf4-4b10-b7e2-6f3e35695ace` that are currently marked `allocated`
but have no active `firearm_allocations` row. No database rows were changed.

Each firearm has one or more staged MDR rows with the same serial number.
However, all 35 have both of the following conditions:

- no staged `matched_firearm_id` equal to the current firearm ID;
- no staged `matched_guard_id` that can establish a custody relationship.

Serial-number equality is useful source evidence, but is not an auditable
custody link. The current `allocated` status alone also does not establish a
custodian, issue date, or return date. Therefore, every record is classified
as `MANUAL REVIEW`. Candidate accounts listed below are comparison results
only; they must not be used to create or repair a custody link without an
approved source record.

## Category Counts

| Defensible target state | Count | Basis |
| --- | ---: | --- |
| KEEP ALLOCATED | 0 | No row has a direct firearm-to-guard custody link. |
| SET AVAILABLE | 0 | No MDR row explicitly establishes a return, vault receipt, or availability state. |
| CREATE/REPAIR CUSTODY LINK | 0 | No row has both direct firearm and guard matches; no issue date may be inferred. |
| MANUAL REVIEW | 35 | Serial-only MDR evidence, no active custody record, and no direct staged links. |

## Row-Level Classification

### 1. Serial `1054371`

- **FIREARM ID:** `7aef982d-f1c0-4e1e-9a6e-5d63405d2535`
- **SERIAL / MAKE / CURRENT STATUS:** `1054371` / `Armscor` / `allocated`
- **MDR BATCH:** `ac536804-edf4-4b10-b7e2-6f3e35695ace`
- **MDR ROW REF:** `PULL OUT .:188`; `Sheet1:20`
- **SOURCE GUARD:** EUGENIO GILBERT, guard number 142 on both rows.
- **SOURCE CUSTODY/STATUS DATA:** `history` and `clients` sections; no pullout status or firearm remarks; both rows are `new`.
- **MATCHED CURRENT GUARD?:** No direct staged guard match. The name/number comparison finds EUGENIO GILBERT, currently inactive.
- **MATCHED VALID FIREARM?:** No direct staged firearm match; serial-only source match.
- **DEFENSIBLE TARGET STATE / CONFIDENCE:** `MANUAL REVIEW` / High for this conservative classification.
- **RECOMMENDED ACTION:** `MANUAL REVIEW`.
- **REASON:** No active allocation or direct MDR custody relationship; source rows do not prove current custody or a return.

### 2. Serial `1054403`

- **FIREARM ID:** `3d1efac9-d7f4-461c-9e34-defe27f3e0f0`
- **SERIAL / MAKE / CURRENT STATUS:** `1054403` / `Armscor` / `allocated`
- **MDR BATCH:** `ac536804-edf4-4b10-b7e2-6f3e35695ace`
- **MDR ROW REF:** `MARCH:144`
- **SOURCE GUARD:** VASQUEZ, ROMEO, guard number 101.
- **SOURCE CUSTODY/STATUS DATA:** `clients` section; no pullout status or firearm remarks; row is `new`.
- **MATCHED CURRENT GUARD?:** No direct staged guard match. The name/number comparison finds VASQUEZ, ROMEO, currently inactive.
- **MATCHED VALID FIREARM?:** No direct staged firearm match; serial-only source match.
- **DEFENSIBLE TARGET STATE / CONFIDENCE:** `MANUAL REVIEW` / High for this conservative classification.
- **RECOMMENDED ACTION:** `MANUAL REVIEW`.
- **REASON:** Source identification does not establish an active custody record or a supported return state.

### 3. Serial `1059939`

- **FIREARM ID:** `eb23de27-f468-4b40-a42c-02f5a416b0b2`
- **SERIAL / MAKE / CURRENT STATUS:** `1059939` / `Armscor` / `allocated`
- **MDR BATCH:** `ac536804-edf4-4b10-b7e2-6f3e35695ace`
- **MDR ROW REF:** `PULL OUT .:180`; `Sheet1:12`
- **SOURCE GUARD:** BUNGAOS, REYNALDO B., guard number 132 on both rows.
- **SOURCE CUSTODY/STATUS DATA:** `history` row is `new`; `clients` row is `matched`; neither has pullout status or firearm remarks.
- **MATCHED CURRENT GUARD?:** No direct staged guard match. Current guard number 132 resolves to CERVANTES, ANTONY, which conflicts with the MDR name.
- **MATCHED VALID FIREARM?:** No direct staged firearm match; serial-only source match.
- **DEFENSIBLE TARGET STATE / CONFIDENCE:** `MANUAL REVIEW` / High for this conservative classification.
- **RECOMMENDED ACTION:** `MANUAL REVIEW`.
- **REASON:** Current account evidence conflicts with the source name, so no custody link may be inferred.

### 4. Serial `1067255`

- **FIREARM ID:** `09b16483-0eb0-44a8-aa57-b1e6dacfe4a6`
- **SERIAL / MAKE / CURRENT STATUS:** `1067255` / `Armscor` / `allocated`
- **MDR BATCH:** `ac536804-edf4-4b10-b7e2-6f3e35695ace`
- **MDR ROW REF:** `MARCH:138`
- **SOURCE GUARD:** PANTOJAN, ROMULO, guard number 95.
- **SOURCE CUSTODY/STATUS DATA:** `clients`; no pullout status or firearm remarks; row is `new`.
- **MATCHED CURRENT GUARD?:** No direct staged guard match. The name/number comparison finds PANTOJAN, ROMULO, currently inactive.
- **MATCHED VALID FIREARM?:** No direct staged firearm match; serial-only source match.
- **DEFENSIBLE TARGET STATE / CONFIDENCE:** `MANUAL REVIEW` / High for this conservative classification.
- **RECOMMENDED ACTION:** `MANUAL REVIEW`.
- **REASON:** No supported active custody or returned state exists.

### 5. Serial `1102003`

- **FIREARM ID:** `ffffa0e0-f328-4402-af41-6a7b5095363a`
- **SERIAL / MAKE / CURRENT STATUS:** `1102003` / `Armscor` / `allocated`
- **MDR BATCH:** `ac536804-edf4-4b10-b7e2-6f3e35695ace`
- **MDR ROW REF:** `MARCH:153`
- **SOURCE GUARD:** MONGO, ARNEL, guard number 110.
- **SOURCE CUSTODY/STATUS DATA:** `clients`; no pullout status or firearm remarks; row is `new`.
- **MATCHED CURRENT GUARD?:** No direct staged guard match. The name/number comparison finds MONGO, ARNEL, currently inactive.
- **MATCHED VALID FIREARM?:** No direct staged firearm match; serial-only source match.
- **DEFENSIBLE TARGET STATE / CONFIDENCE:** `MANUAL REVIEW` / High for this conservative classification.
- **RECOMMENDED ACTION:** `MANUAL REVIEW`.
- **REASON:** No source evidence supports a present custodian or availability correction.

### 6. Serial `1266039`

- **FIREARM ID:** `c5b386d6-678e-491a-9b33-f796e5bac7a5`
- **SERIAL / MAKE / CURRENT STATUS:** `1266039` / `Armscor` / `allocated`
- **MDR BATCH:** `ac536804-edf4-4b10-b7e2-6f3e35695ace`
- **MDR ROW REF:** `MARCH:150`
- **SOURCE GUARD:** TUMANDA ROMEL, guard number 107.
- **SOURCE CUSTODY/STATUS DATA:** `clients`; no pullout status or firearm remarks; row is `new`.
- **MATCHED CURRENT GUARD?:** No direct staged guard match. The name/number comparison finds TUMANDA ROMEL, currently inactive.
- **MATCHED VALID FIREARM?:** No direct staged firearm match; serial-only source match.
- **DEFENSIBLE TARGET STATE / CONFIDENCE:** `MANUAL REVIEW` / High for this conservative classification.
- **RECOMMENDED ACTION:** `MANUAL REVIEW`.
- **REASON:** No supported current custody or return evidence exists.

### 7. Serial `1312109`

- **FIREARM ID:** `ad5e3bed-e239-42cd-b6b4-2210ff2c144c`
- **SERIAL / MAKE / CURRENT STATUS:** `1312109` / `Armscor` / `allocated`
- **MDR BATCH:** `ac536804-edf4-4b10-b7e2-6f3e35695ace`
- **MDR ROW REF:** `MARCH:8`; `PULL OUT .:97`
- **SOURCE GUARD:** BAGSAC, RODRIGO, guard number 1 on both rows.
- **SOURCE CUSTODY/STATUS DATA:** `clients` and `history`; no pullout status or firearm remarks; both rows are `new`.
- **MATCHED CURRENT GUARD?:** No direct staged guard match. The name/number comparison finds BAGSAC, RODRIGO, currently inactive.
- **MATCHED VALID FIREARM?:** No direct staged firearm match; serial-only source match.
- **DEFENSIBLE TARGET STATE / CONFIDENCE:** `MANUAL REVIEW` / High for this conservative classification.
- **RECOMMENDED ACTION:** `MANUAL REVIEW`.
- **REASON:** Historical and client rows are not a valid current custody ledger.

### 8. Serial `1364581`

- **FIREARM ID:** `3a1ed5ed-f76f-4c45-888c-be151f16bc55`
- **SERIAL / MAKE / CURRENT STATUS:** `1364581` / `Rock Island` / `allocated`
- **MDR BATCH:** `ac536804-edf4-4b10-b7e2-6f3e35695ace`
- **MDR ROW REF:** `MARCH:162`
- **SOURCE GUARD:** QUIDANG RIENO, guard number 119.
- **SOURCE CUSTODY/STATUS DATA:** `clients`; no pullout status or firearm remarks; row is `new`.
- **MATCHED CURRENT GUARD?:** No direct staged guard match. The name/number comparison finds QUIDANG RIENO, currently inactive.
- **MATCHED VALID FIREARM?:** No direct staged firearm match; serial-only source match.
- **DEFENSIBLE TARGET STATE / CONFIDENCE:** `MANUAL REVIEW` / High for this conservative classification.
- **RECOMMENDED ACTION:** `MANUAL REVIEW`.
- **REASON:** The record lacks a direct firearm-to-guard link and custody dates.

### 9. Serial `1428739`

- **FIREARM ID:** `34ecbc99-3fa1-4acf-bdec-09b9ef7bde57`
- **SERIAL / MAKE / CURRENT STATUS:** `1428739` / `Armscor` / `allocated`
- **MDR BATCH:** `ac536804-edf4-4b10-b7e2-6f3e35695ace`
- **MDR ROW REF:** `MARCH:12`; `PULL OUT .:101`
- **SOURCE GUARD:** ORONOS, ROLLY, guard number 4 on both rows.
- **SOURCE CUSTODY/STATUS DATA:** `clients` and `history`; no pullout status or firearm remarks; both rows are `new`.
- **MATCHED CURRENT GUARD?:** No direct staged guard match. The name/number comparison finds ORONOS, ROLLY, currently inactive.
- **MATCHED VALID FIREARM?:** No direct staged firearm match; serial-only source match.
- **DEFENSIBLE TARGET STATE / CONFIDENCE:** `MANUAL REVIEW` / High for this conservative classification.
- **RECOMMENDED ACTION:** `MANUAL REVIEW`.
- **REASON:** No current custody record or explicit return evidence exists.

### 10. Serial `1444924`

- **FIREARM ID:** `5b2d09fe-c468-459d-ac13-2ca3ccf6180b`
- **SERIAL / MAKE / CURRENT STATUS:** `1444924` / `Armscor` / `allocated`
- **MDR BATCH:** `ac536804-edf4-4b10-b7e2-6f3e35695ace`
- **MDR ROW REF:** `PULL OUT .:177`; `Sheet1:9`
- **SOURCE GUARD:** PIDO, JAYSON, guard number 127 on both rows.
- **SOURCE CUSTODY/STATUS DATA:** `history` and `clients`; no pullout status or firearm remarks; both rows are `new`.
- **MATCHED CURRENT GUARD?:** No direct staged guard match. Guard number 127 has two current-account candidates, GASPAN, FRECH and PIDO, JAYSON, both inactive.
- **MATCHED VALID FIREARM?:** No direct staged firearm match; serial-only source match.
- **DEFENSIBLE TARGET STATE / CONFIDENCE:** `MANUAL REVIEW` / High for this conservative classification.
- **RECOMMENDED ACTION:** `MANUAL REVIEW`.
- **REASON:** Duplicate guard-number candidates make any inferred custody link unsafe.

### 11. Serial `1545027`

- **FIREARM ID:** `59039839-6245-4f01-b1c2-d6466f058326`
- **SERIAL / MAKE / CURRENT STATUS:** `1545027` / `Armscor` / `allocated`
- **MDR BATCH:** `ac536804-edf4-4b10-b7e2-6f3e35695ace`
- **MDR ROW REF:** `MARCH:23`; `PULL OUT .:112`
- **SOURCE GUARD:** IGNACIO C, LAVIÑA, guard number 11 (`MARCH:23`); MASINADING, JANELITO T., guard number 11 (`PULL OUT .:112`).
- **SOURCE CUSTODY/STATUS DATA:** `clients` and `history`; no pullout status or firearm remarks; both rows are `new`.
- **MATCHED CURRENT GUARD?:** No direct staged guard match. Number 11 resolves to active IGNACIO C, LAVIÑA, but the historical row names a different guard.
- **MATCHED VALID FIREARM?:** No direct staged firearm match; serial-only source match.
- **DEFENSIBLE TARGET STATE / CONFIDENCE:** `MANUAL REVIEW` / High for this conservative classification.
- **RECOMMENDED ACTION:** `MANUAL REVIEW`.
- **REASON:** Conflicting source guards and no direct custody relationship preclude a repair.

### 12. Serial `22-PH02805`

- **FIREARM ID:** `5efc3f34-1c7d-40ad-a2e4-643451db9c1f`
- **SERIAL / MAKE / CURRENT STATUS:** `22-PH02805` / `DERCA` / `allocated`
- **MDR BATCH:** `ac536804-edf4-4b10-b7e2-6f3e35695ace`
- **MDR ROW REF:** `MARCH:170`
- **SOURCE GUARD:** GASPAN,FRECH, guard number 127.
- **SOURCE CUSTODY/STATUS DATA:** `clients`; no pullout status or firearm remarks; row is `new`.
- **MATCHED CURRENT GUARD?:** No direct staged guard match. Guard number 127 has two current-account candidates, GASPAN, FRECH and PIDO, JAYSON, both inactive.
- **MATCHED VALID FIREARM?:** No direct staged firearm match; serial-only source match.
- **DEFENSIBLE TARGET STATE / CONFIDENCE:** `MANUAL REVIEW` / High for this conservative classification.
- **RECOMMENDED ACTION:** `MANUAL REVIEW`.
- **REASON:** Duplicate guard-number candidates make any inferred custody link unsafe.

### 13. Serial `30122`

- **FIREARM ID:** `636aafa2-ed3f-4f9a-aa85-c03d7abe35f3`
- **SERIAL / MAKE / CURRENT STATUS:** `30122` / `Armscor` / `allocated`
- **MDR BATCH:** `ac536804-edf4-4b10-b7e2-6f3e35695ace`
- **MDR ROW REF:** `PULL OUT .:190`; `Sheet1:22`
- **SOURCE GUARD:** SUAN, WELSON, guard number 145 on both rows.
- **SOURCE CUSTODY/STATUS DATA:** `history` and `clients`; no pullout status or firearm remarks; both rows are `new`.
- **MATCHED CURRENT GUARD?:** No direct staged guard match. The name/number comparison finds SUAN, WELSON, currently inactive.
- **MATCHED VALID FIREARM?:** No direct staged firearm match; serial-only source match.
- **DEFENSIBLE TARGET STATE / CONFIDENCE:** `MANUAL REVIEW` / High for this conservative classification.
- **RECOMMENDED ACTION:** `MANUAL REVIEW`.
- **REASON:** Source rows do not establish current custody or a return.

### 14. Serial `30299`

- **FIREARM ID:** `71f9480d-5e4d-4ab3-acf8-7fc2c00b2ae1`
- **SERIAL / MAKE / CURRENT STATUS:** `30299` / `Armscor` / `allocated`
- **MDR BATCH:** `ac536804-edf4-4b10-b7e2-6f3e35695ace`
- **MDR ROW REF:** `MARCH:97`
- **SOURCE GUARD:** PALMA, FORTUNATO, guard number 55.
- **SOURCE CUSTODY/STATUS DATA:** `clients`; no pullout status or firearm remarks; row is `new`.
- **MATCHED CURRENT GUARD?:** No direct staged guard match. The name/number comparison finds PALMA, FORTUNATO, currently inactive.
- **MATCHED VALID FIREARM?:** No direct staged firearm match; serial-only source match.
- **DEFENSIBLE TARGET STATE / CONFIDENCE:** `MANUAL REVIEW` / High for this conservative classification.
- **RECOMMENDED ACTION:** `MANUAL REVIEW`.
- **REASON:** No evidence supports an active custody link or availability change.

### 15. Serial `31612`

- **FIREARM ID:** `947678de-1df8-4b3e-be3c-c4fdfbaf05ea`
- **SERIAL / MAKE / CURRENT STATUS:** `31612` / `Armscor` / `allocated`
- **MDR BATCH:** `ac536804-edf4-4b10-b7e2-6f3e35695ace`
- **MDR ROW REF:** `PULL OUT .:183`; `Sheet1:15`
- **SOURCE GUARD:** IDONG, BRENDO, guard number 135 on both rows.
- **SOURCE CUSTODY/STATUS DATA:** `history` and `clients`; no pullout status or firearm remarks; both rows are `new`.
- **MATCHED CURRENT GUARD?:** No direct staged guard match. The name/number comparison finds IDONG, BRENDO, currently inactive.
- **MATCHED VALID FIREARM?:** No direct staged firearm match; serial-only source match.
- **DEFENSIBLE TARGET STATE / CONFIDENCE:** `MANUAL REVIEW` / High for this conservative classification.
- **RECOMMENDED ACTION:** `MANUAL REVIEW`.
- **REASON:** A serial match alone cannot establish custody history.

### 16. Serial `5559379`

- **FIREARM ID:** `73c2e808-09fc-4efe-b159-b99bfe3195aa`
- **SERIAL / MAKE / CURRENT STATUS:** `5559379` / `Akkar` / `allocated`
- **MDR BATCH:** `ac536804-edf4-4b10-b7e2-6f3e35695ace`
- **MDR ROW REF:** `MARCH:9`; `PULL OUT .:98`
- **SOURCE GUARD:** BASA, XIEL BRYAN N., guard number 2 on both rows.
- **SOURCE CUSTODY/STATUS DATA:** `clients` row is `matched`; `history` row is `new`; neither has pullout status or firearm remarks.
- **MATCHED CURRENT GUARD?:** No direct staged guard match and no exact current-account candidate from the source name/number comparison.
- **MATCHED VALID FIREARM?:** No direct staged firearm match; serial-only source match.
- **DEFENSIBLE TARGET STATE / CONFIDENCE:** `MANUAL REVIEW` / High for this conservative classification.
- **RECOMMENDED ACTION:** `MANUAL REVIEW`.
- **REASON:** The MDR row status is not a custody link; the row lacks both required direct matches.

### 17. Serial `5570977`

- **FIREARM ID:** `d3ed26a3-57e0-45aa-b9b5-5f029cb8f6e2`
- **SERIAL / MAKE / CURRENT STATUS:** `5570977` / `Armscor` / `allocated`
- **MDR BATCH:** `ac536804-edf4-4b10-b7e2-6f3e35695ace`
- **MDR ROW REF:** `MARCH:164`; `PULL OUT .:173`; `Sheet1:5`
- **SOURCE GUARD:** MACUA, ENRIQUE, guard number 121 (`MARCH:164`); CARILLO, MARJON NMN, guard number 123 on the remaining rows.
- **SOURCE CUSTODY/STATUS DATA:** `clients` rows are `matched`; `history` is `new`; no pullout status or firearm remarks.
- **MATCHED CURRENT GUARD?:** No direct staged guard match. Number 121 is shared by inactive MACUA, ENRIQUE and GERONA, NORBERTO; number 123 resolves to inactive CARILLO, MARJON NMN.
- **MATCHED VALID FIREARM?:** No direct staged firearm match; serial-only source match.
- **DEFENSIBLE TARGET STATE / CONFIDENCE:** `MANUAL REVIEW` / High for this conservative classification.
- **RECOMMENDED ACTION:** `MANUAL REVIEW`.
- **REASON:** Multiple conflicting source guards and duplicate guard-number candidates prohibit a custody repair.

### 18. Serial `70349`

- **FIREARM ID:** `f1252330-565b-4807-8d97-a484a7168d33`
- **SERIAL / MAKE / CURRENT STATUS:** `70349` / `s&w` / `allocated`
- **MDR BATCH:** `ac536804-edf4-4b10-b7e2-6f3e35695ace`
- **MDR ROW REF:** `MARCH:175`
- **SOURCE GUARD:** QUEZON, SAMUEL, guard number 129.
- **SOURCE CUSTODY/STATUS DATA:** `tower`; no pullout status or firearm remarks; row is `new`.
- **MATCHED CURRENT GUARD?:** No direct staged guard match. Guard number 129 has two inactive candidates, QUEZON, SAMUEL and MANGUIOB, DARYLL.
- **MATCHED VALID FIREARM?:** No direct staged firearm match; serial-only source match.
- **DEFENSIBLE TARGET STATE / CONFIDENCE:** `MANUAL REVIEW` / High for this conservative classification.
- **RECOMMENDED ACTION:** `MANUAL REVIEW`.
- **REASON:** The source does not provide a defensible unique current custodian.

### 19. Serial `873574`

- **FIREARM ID:** `e687d26e-5cb9-4cfe-b879-0966643ae8b1`
- **SERIAL / MAKE / CURRENT STATUS:** `873574` / `Armscor` / `allocated`
- **MDR BATCH:** `ac536804-edf4-4b10-b7e2-6f3e35695ace`
- **MDR ROW REF:** `MARCH:70`; `PULL OUT .:158`
- **SOURCE GUARD:** CALASANG, DONALD, guard number 35 on both rows.
- **SOURCE CUSTODY/STATUS DATA:** `clients` and `history`; no pullout status or firearm remarks; both rows are `new`.
- **MATCHED CURRENT GUARD?:** No direct staged guard match. The name/number comparison finds CALASANG, DONALD, currently inactive.
- **MATCHED VALID FIREARM?:** No direct staged firearm match; serial-only source match.
- **DEFENSIBLE TARGET STATE / CONFIDENCE:** `MANUAL REVIEW` / High for this conservative classification.
- **RECOMMENDED ACTION:** `MANUAL REVIEW`.
- **REASON:** No current custody or return state is established.

### 20. Serial `883191`

- **FIREARM ID:** `d2c7afcb-4c9c-4a04-8f63-cee47ac9c5e6`
- **SERIAL / MAKE / CURRENT STATUS:** `883191` / `Armscor` / `allocated`
- **MDR BATCH:** `ac536804-edf4-4b10-b7e2-6f3e35695ace`
- **MDR ROW REF:** `MARCH:160`
- **SOURCE GUARD:** MANSANADES,ARIEL, guard number 117.
- **SOURCE CUSTODY/STATUS DATA:** `clients`; no pullout status or firearm remarks; row is `new`.
- **MATCHED CURRENT GUARD?:** No direct staged guard match. The name/number comparison finds MANSANADES, ARIEL, currently inactive.
- **MATCHED VALID FIREARM?:** No direct staged firearm match; serial-only source match.
- **DEFENSIBLE TARGET STATE / CONFIDENCE:** `MANUAL REVIEW` / High for this conservative classification.
- **RECOMMENDED ACTION:** `MANUAL REVIEW`.
- **REASON:** No source evidence supports a current custody relation.

### 21. Serial `885397`

- **FIREARM ID:** `893df464-3254-4f1f-82db-6c7540643251`
- **SERIAL / MAKE / CURRENT STATUS:** `885397` / `Armscor` / `allocated`
- **MDR BATCH:** `ac536804-edf4-4b10-b7e2-6f3e35695ace`
- **MDR ROW REF:** `MARCH:146`
- **SOURCE GUARD:** NOLI ESCOVILLA, guard number 103.
- **SOURCE CUSTODY/STATUS DATA:** `clients`; no pullout status or firearm remarks; row is `new`.
- **MATCHED CURRENT GUARD?:** No direct staged guard match. The name/number comparison finds NOLI ESCOVILLA, currently inactive.
- **MATCHED VALID FIREARM?:** No direct staged firearm match; serial-only source match.
- **DEFENSIBLE TARGET STATE / CONFIDENCE:** `MANUAL REVIEW` / High for this conservative classification.
- **RECOMMENDED ACTION:** `MANUAL REVIEW`.
- **REASON:** No direct custody relationship was retained by the import.

### 22. Serial `886045`

- **FIREARM ID:** `546aa077-4b3d-4e81-a636-235b2e6d31c7`
- **SERIAL / MAKE / CURRENT STATUS:** `886045` / `Armscor` / `allocated`
- **MDR BATCH:** `ac536804-edf4-4b10-b7e2-6f3e35695ace`
- **MDR ROW REF:** `MARCH:103`
- **SOURCE GUARD:** GOLOSINO, ALLAN JAY, guard number 61.
- **SOURCE CUSTODY/STATUS DATA:** `clients`; no pullout status or firearm remarks; row is `new`.
- **MATCHED CURRENT GUARD?:** No direct staged guard match. The name/number comparison finds GOLOSINO, ALLAN JAY, currently inactive.
- **MATCHED VALID FIREARM?:** No direct staged firearm match; serial-only source match.
- **DEFENSIBLE TARGET STATE / CONFIDENCE:** `MANUAL REVIEW` / High for this conservative classification.
- **RECOMMENDED ACTION:** `MANUAL REVIEW`.
- **REASON:** The source does not document current custody or a return.

### 23. Serial `924778`

- **FIREARM ID:** `1994ee4d-316c-4212-b1fc-06eb9593c065`
- **SERIAL / MAKE / CURRENT STATUS:** `924778` / `Armscor` / `allocated`
- **MDR BATCH:** `ac536804-edf4-4b10-b7e2-6f3e35695ace`
- **MDR ROW REF:** `MARCH:99`
- **SOURCE GUARD:** BACIA, JINILITO, guard number 57.
- **SOURCE CUSTODY/STATUS DATA:** `clients`; no pullout status or firearm remarks; row is `new`.
- **MATCHED CURRENT GUARD?:** No direct staged guard match. The name/number comparison finds BACIA, JINILITO, currently inactive.
- **MATCHED VALID FIREARM?:** No direct staged firearm match; serial-only source match.
- **DEFENSIBLE TARGET STATE / CONFIDENCE:** `MANUAL REVIEW` / High for this conservative classification.
- **RECOMMENDED ACTION:** `MANUAL REVIEW`.
- **REASON:** No active custody row or direct MDR relationship exists.

### 24. Serial `931012`

- **FIREARM ID:** `58af7589-1dcc-4c2d-9482-ccc88efa9c65`
- **SERIAL / MAKE / CURRENT STATUS:** `931012` / `Armscor` / `allocated`
- **MDR BATCH:** `ac536804-edf4-4b10-b7e2-6f3e35695ace`
- **MDR ROW REF:** `MARCH:135`
- **SOURCE GUARD:** BALDOMERO, GEALYN, guard number 92.
- **SOURCE CUSTODY/STATUS DATA:** `clients`; no pullout status or firearm remarks; row is `new`.
- **MATCHED CURRENT GUARD?:** No direct staged guard match. The name/number comparison finds BALDOMERO, GEALYN, currently inactive.
- **MATCHED VALID FIREARM?:** No direct staged firearm match; serial-only source match.
- **DEFENSIBLE TARGET STATE / CONFIDENCE:** `MANUAL REVIEW` / High for this conservative classification.
- **RECOMMENDED ACTION:** `MANUAL REVIEW`.
- **REASON:** There is no evidence for a safe status or custody correction.

### 25. Serial `931027`

- **FIREARM ID:** `e44abb42-ca58-452e-bc57-7f7a2fcd51c6`
- **SERIAL / MAKE / CURRENT STATUS:** `931027` / `Armscor` / `allocated`
- **MDR BATCH:** `ac536804-edf4-4b10-b7e2-6f3e35695ace`
- **MDR ROW REF:** `MARCH:156`
- **SOURCE GUARD:** LUAYON MARJUN ,E, guard number 113.
- **SOURCE CUSTODY/STATUS DATA:** `clients`; no pullout status or firearm remarks; row is `new`.
- **MATCHED CURRENT GUARD?:** No direct staged guard match. The name/number comparison finds LUAYON MARJUN, E, currently inactive.
- **MATCHED VALID FIREARM?:** No direct staged firearm match; serial-only source match.
- **DEFENSIBLE TARGET STATE / CONFIDENCE:** `MANUAL REVIEW` / High for this conservative classification.
- **RECOMMENDED ACTION:** `MANUAL REVIEW`.
- **REASON:** Formatting variation in the name does not substitute for a direct custody link.

### 26. Serial `931028`

- **FIREARM ID:** `da088550-1fac-472b-866b-5a61aa6e598d`
- **SERIAL / MAKE / CURRENT STATUS:** `931028` / `Armscor` / `allocated`
- **MDR BATCH:** `ac536804-edf4-4b10-b7e2-6f3e35695ace`
- **MDR ROW REF:** `MARCH:121`
- **SOURCE GUARD:** JAMIN, JAIME, guard number 79.
- **SOURCE CUSTODY/STATUS DATA:** `clients`; no pullout status or firearm remarks; row is `new`.
- **MATCHED CURRENT GUARD?:** No direct staged guard match. The name/number comparison finds JAMIN, JAIME, currently inactive.
- **MATCHED VALID FIREARM?:** No direct staged firearm match; serial-only source match.
- **DEFENSIBLE TARGET STATE / CONFIDENCE:** `MANUAL REVIEW` / High for this conservative classification.
- **RECOMMENDED ACTION:** `MANUAL REVIEW`.
- **REASON:** No record supports either an issue or a return correction.

### 27. Serial `969607`

- **FIREARM ID:** `f55bb5cc-118d-4a1e-a47b-7711e56d79df`
- **SERIAL / MAKE / CURRENT STATUS:** `969607` / `Armscor` / `allocated`
- **MDR BATCH:** `ac536804-edf4-4b10-b7e2-6f3e35695ace`
- **MDR ROW REF:** `MARCH:155`
- **SOURCE GUARD:** BAÑADOS, JEEAR, guard number 112.
- **SOURCE CUSTODY/STATUS DATA:** `clients`; no pullout status or firearm remarks; row is `new`.
- **MATCHED CURRENT GUARD?:** No direct staged guard match. The name/number comparison finds BAÑADOS, JEEAR, currently inactive.
- **MATCHED VALID FIREARM?:** No direct staged firearm match; serial-only source match.
- **DEFENSIBLE TARGET STATE / CONFIDENCE:** `MANUAL REVIEW` / High for this conservative classification.
- **RECOMMENDED ACTION:** `MANUAL REVIEW`.
- **REASON:** No direct custody record was created from the MDR source.

### 28. Serial `983607`

- **FIREARM ID:** `d05575c8-c518-44f3-8f68-662fb189dda8`
- **SERIAL / MAKE / CURRENT STATUS:** `983607` / `Armscor` / `allocated`
- **MDR BATCH:** `ac536804-edf4-4b10-b7e2-6f3e35695ace`
- **MDR ROW REF:** `MARCH:18`; `PULL OUT .:107`
- **SOURCE GUARD:** MAYBUENA, JUSTICE, guard number 8 on both rows.
- **SOURCE CUSTODY/STATUS DATA:** `clients` and `history`; no pullout status or firearm remarks; both rows are `new`.
- **MATCHED CURRENT GUARD?:** No direct staged guard match. The name/number comparison finds MAYBUENA, JUSTICE, currently inactive.
- **MATCHED VALID FIREARM?:** No direct staged firearm match; serial-only source match.
- **DEFENSIBLE TARGET STATE / CONFIDENCE:** `MANUAL REVIEW` / High for this conservative classification.
- **RECOMMENDED ACTION:** `MANUAL REVIEW`.
- **REASON:** The history label alone cannot be treated as a return transaction.

### 29. Serial `983619`

- **FIREARM ID:** `58514202-c546-486e-8c61-48869e2b5662`
- **SERIAL / MAKE / CURRENT STATUS:** `983619` / `Armscor` / `allocated`
- **MDR BATCH:** `ac536804-edf4-4b10-b7e2-6f3e35695ace`
- **MDR ROW REF:** `MARCH:69`; `PULL OUT .:157`
- **SOURCE GUARD:** GULO JOEL, guard number 34 on both rows.
- **SOURCE CUSTODY/STATUS DATA:** `clients` and `history`; no pullout status or firearm remarks; both rows are `new`.
- **MATCHED CURRENT GUARD?:** No direct staged guard match. The name/number comparison finds GULO JOEL, currently inactive.
- **MATCHED VALID FIREARM?:** No direct staged firearm match; serial-only source match.
- **DEFENSIBLE TARGET STATE / CONFIDENCE:** `MANUAL REVIEW` / High for this conservative classification.
- **RECOMMENDED ACTION:** `MANUAL REVIEW`.
- **REASON:** No current custody or returned status can be inferred.

### 30. Serial `983718`

- **FIREARM ID:** `7c699999-e109-4768-a8e8-ec94b84cd095`
- **SERIAL / MAKE / CURRENT STATUS:** `983718` / `Armscor` / `allocated`
- **MDR BATCH:** `ac536804-edf4-4b10-b7e2-6f3e35695ace`
- **MDR ROW REF:** `PULL OUT .:171`; `Sheet1:3`
- **SOURCE GUARD:** GERONA, NORBERTO, guard number 121 on both rows.
- **SOURCE CUSTODY/STATUS DATA:** `history` and `clients`; no pullout status or firearm remarks; both rows are `new`.
- **MATCHED CURRENT GUARD?:** No direct staged guard match. Number 121 is shared by inactive MACUA, ENRIQUE and GERONA, NORBERTO.
- **MATCHED VALID FIREARM?:** No direct staged firearm match; serial-only source match.
- **DEFENSIBLE TARGET STATE / CONFIDENCE:** `MANUAL REVIEW` / High for this conservative classification.
- **RECOMMENDED ACTION:** `MANUAL REVIEW`.
- **REASON:** Duplicate guard-number candidates prohibit an inferred custody link.

### 31. Serial `AYT7880`

- **FIREARM ID:** `b346e03c-b079-44e7-a763-dab19e97868f`
- **SERIAL / MAKE / CURRENT STATUS:** `AYT7880` / `Armscor` / `allocated`
- **MDR BATCH:** `ac536804-edf4-4b10-b7e2-6f3e35695ace`
- **MDR ROW REF:** `MARCH:98`
- **SOURCE GUARD:** AMBUHOT, ALBERT, guard number 56.
- **SOURCE CUSTODY/STATUS DATA:** `clients`; no pullout status or firearm remarks; row is `new`.
- **MATCHED CURRENT GUARD?:** No direct staged guard match. The name/number comparison finds AMBUHOT, ALBERT, currently inactive.
- **MATCHED VALID FIREARM?:** No direct staged firearm match; serial-only source match.
- **DEFENSIBLE TARGET STATE / CONFIDENCE:** `MANUAL REVIEW` / High for this conservative classification.
- **RECOMMENDED ACTION:** `MANUAL REVIEW`.
- **REASON:** The source does not establish a current custodian or return.

### 32. Serial `E7963258`

- **FIREARM ID:** `86a669ac-10ae-443c-b690-d991b38d43ad`
- **SERIAL / MAKE / CURRENT STATUS:** `E7963258` / `SAM` / `allocated`
- **MDR BATCH:** `ac536804-edf4-4b10-b7e2-6f3e35695ace`
- **MDR ROW REF:** `MARCH:177`
- **SOURCE GUARD:** AVILA, SAMUEL, guard number 131.
- **SOURCE CUSTODY/STATUS DATA:** `tower`; no pullout status or firearm remarks; row is `new`.
- **MATCHED CURRENT GUARD?:** No direct staged guard match. The name/number comparison finds AVILA, SAMUEL, currently inactive.
- **MATCHED VALID FIREARM?:** No direct staged firearm match; serial-only source match.
- **DEFENSIBLE TARGET STATE / CONFIDENCE:** `MANUAL REVIEW` / High for this conservative classification.
- **RECOMMENDED ACTION:** `MANUAL REVIEW`.
- **REASON:** The operational section does not supply an auditable custody transaction.

### 33. Serial `RIA1818217`

- **FIREARM ID:** `2252baf6-b696-4642-b22f-c076e27cf43d`
- **SERIAL / MAKE / CURRENT STATUS:** `RIA1818217` / `Rock Island` / `allocated`
- **MDR BATCH:** `ac536804-edf4-4b10-b7e2-6f3e35695ace`
- **MDR ROW REF:** `MARCH:21`; `PULL OUT .:110`
- **SOURCE GUARD:** MASALI HABIB, guard number 10 on both rows.
- **SOURCE CUSTODY/STATUS DATA:** `clients` and `history`; no pullout status or firearm remarks; both rows are `new`.
- **MATCHED CURRENT GUARD?:** No direct staged guard match. The name/number comparison finds MASALI HABIB, currently inactive.
- **MATCHED VALID FIREARM?:** No direct staged firearm match; serial-only source match.
- **DEFENSIBLE TARGET STATE / CONFIDENCE:** `MANUAL REVIEW` / High for this conservative classification.
- **RECOMMENDED ACTION:** `MANUAL REVIEW`.
- **REASON:** No direct source-to-custody relationship exists.

### 34. Serial `RIA1984335`

- **FIREARM ID:** `3017c67d-04ab-4138-a2d2-700078daba95`
- **SERIAL / MAKE / CURRENT STATUS:** `RIA1984335` / `Armscor` / `allocated`
- **MDR BATCH:** `ac536804-edf4-4b10-b7e2-6f3e35695ace`
- **MDR ROW REF:** `PULL OUT .:11`; `PULL OUT .:184`; `Sheet1:16`
- **SOURCE GUARD:** DE JESUS MELLICENT,V (no guard number) on the `pullout` row; ARIATE, FIDEL, guard number 136 on the `history` and `clients` rows.
- **SOURCE CUSTODY/STATUS DATA:** The `pullout` row records `ESCORT LBP A/C`; the other rows have no pullout status or firearm remarks and are `new`.
- **MATCHED CURRENT GUARD?:** No direct staged guard match. ARIATE, FIDEL is an inactive name/number candidate; the pullout-row guard has no number.
- **MATCHED VALID FIREARM?:** No direct staged firearm match; serial-only source match.
- **DEFENSIBLE TARGET STATE / CONFIDENCE:** `MANUAL REVIEW` / High for this conservative classification.
- **RECOMMENDED ACTION:** `MANUAL REVIEW`.
- **REASON:** The raw `ESCORT LBP A/C` text is not a custody receipt or return date, and source guards conflict.

### 35. Serial `RIA2542524`

- **FIREARM ID:** `aaa3441e-0c08-4308-89a0-9efa23333e1e`
- **SERIAL / MAKE / CURRENT STATUS:** `RIA2542524` / `Not specified` / `allocated`
- **MDR BATCH:** `ac536804-edf4-4b10-b7e2-6f3e35695ace`
- **MDR ROW REF:** `MARCH:56`; `PULL OUT .:145`
- **SOURCE GUARD:** MOLANTA, LOPE, guard number 24 on both rows.
- **SOURCE CUSTODY/STATUS DATA:** `clients` and `history`; no pullout status or firearm remarks; both rows are `new`.
- **MATCHED CURRENT GUARD?:** No direct staged guard match. The name/number comparison finds MOLANTA, LOPE, currently inactive.
- **MATCHED VALID FIREARM?:** No direct staged firearm match; serial-only source match.
- **DEFENSIBLE TARGET STATE / CONFIDENCE:** `MANUAL REVIEW` / High for this conservative classification.
- **RECOMMENDED ACTION:** `MANUAL REVIEW`.
- **REASON:** Missing manufacturer and absent direct custody links rule out an automatic correction.

## Required Approval Before Any Repair

Any later repair must be approved per row and must use a source record that
explicitly establishes the firearm, the responsible guard or vault, and the
relevant custody state. A repair must not infer issue or return dates, actors,
or custodians from these serial-only MDR matches.
