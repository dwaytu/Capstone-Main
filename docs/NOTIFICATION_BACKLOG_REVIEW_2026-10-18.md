# Notification Backlog Review - 2026-10-18

## Scope and method

This is a read-only review of unread notifications in the SENTINEL capstone
presentation database. Counts were collected with the guarded
`capstone-dataset review-inventory` command. No notification was marked read,
deleted, or reassigned.

## Backlog summary

- Total notifications: **226**
- Unread notifications: **195**
- Oldest unread: **2026-09-09 14:10:52** Asia/Manila
- Newest unread: **2026-10-17 15:46:02** Asia/Manila

### Age distribution

| Age at review | Unread count |
| --- | ---: |
| 0-7 days | 153 |
| 8-30 days | 26 |
| Over 30 days | 16 |

### Unread notification type

| Type | Count |
| --- | ---: |
| missing_check_in | 138 |
| geofence_alert | 40 |
| support_ticket | 4 |
| incident_review | 3 |
| operational_request | 3 |
| operational_request_pending | 3 |
| approval_request | 2 |
| account_approval | 1 |
| operational_request_rejected | 1 |

### Recipient role

| Role | Unread count |
| --- | ---: |
| admin | 63 |
| supervisor | 63 |
| superadmin | 59 |
| guard | 10 |

## Stale-attention impact

The 16 unread notifications older than 30 days are a genuine attention backlog:
they can compete with current operational alerts even though this review does
not infer that they remain unresolved. The overall volume is dominated by
`missing_check_in` (138 of 195), followed by geofence alerts (40), so these
two categories should be triaged first. A role-aware review is appropriate
because 185 of the 195 unread items belong to supervisory or administrative
roles.

## Recommendation

Use the existing Inbox workflows to review, resolve, or mark stale items read
with the relevant operational owner. Do not bulk-delete notifications or mark
them read solely from age. A later workflow improvement may add controlled
bulk triage for clearly superseded alert classes, but it must preserve audit
history and recipient accountability.
