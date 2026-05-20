# Development Module Screenshot Checklist (Current Version)

Use this as the replacement set for the old Development figures.  
Figures 12-19 alone are not complete for the current SENTINEL build.

## A) Completeness check for old set (Figures 12-19)

| Figure | Old caption | Status in current build |
|---|---|---|
| 12 | User Login Module | Valid but needs refreshed screenshot |
| 13 | Superadmin Module | Valid but needs refreshed screenshot |
| 14 | Administrator Module | Valid but needs refreshed screenshot |
| 15 | Supervisor Module | Valid but needs refreshed screenshot |
| 16 | Guard Module | Valid but needs refreshed screenshot |
| 17 | Scheduling and Attendance Module | Incomplete (current system splits Schedule + Calendar and other operations modules) |
| 18 | Asset and Compliance Module | Incomplete (current system has separate Firearms, Allocation, Permits, Armored Cars, Maintenance) |
| 19 | Analytics and Reporting Module | Incomplete (current system also includes Audit and Feedback Dashboard views) |

## B) Full current module figure list (recommended)

| Figure | Final caption (use exactly) | Route | Primary role view | Screenshot path |
|---|---|---|---|---|
| 12 | Figure 12. User Login Module | `/login` | Public/Auth | `docs/screenshots/development-current/Figure-12-user-login-module.png` |
| 13 | Figure 13. Superadmin Dashboard Module | `/dashboard` | superadmin | `docs/screenshots/development-current/Figure-13-superadmin-dashboard-module.png` |
| 14 | Figure 14. Administrator Dashboard Module | `/dashboard` | admin | `docs/screenshots/development-current/Figure-14-administrator-dashboard-module.png` |
| 15 | Figure 15. Supervisor Dashboard Module | `/dashboard` | supervisor | `docs/screenshots/development-current/Figure-15-supervisor-dashboard-module.png` |
| 16 | Figure 16. Guard Dashboard Module | `/overview` | guard | `docs/screenshots/development-current/Figure-16-guard-dashboard-module.png` |
| 17 | Figure 17. Approvals Module | `/approvals` | superadmin | `docs/screenshots/development-current/Figure-17-approvals-module.png` |
| 18 | Figure 18. Scheduling Module | `/schedule` | superadmin | `docs/screenshots/development-current/Figure-18-scheduling-module.png` |
| 19 | Figure 19. Calendar Module | `/calendar` | superadmin | `docs/screenshots/development-current/Figure-19-calendar-module.png` |
| 20 | Figure 20. Operations Map Module | `/operations-map` | superadmin | `docs/screenshots/development-current/Figure-20-operations-map-module.png` |
| 21 | Figure 21. Management Module | `/manage` | superadmin | `docs/screenshots/development-current/Figure-21-management-module.png` |
| 22 | Figure 22. MDR Import Module | `/mdr-import` | superadmin | `docs/screenshots/development-current/Figure-22-mdr-import-module.png` |
| 23 | Figure 23. Missions Module | `/missions` | supervisor | `docs/screenshots/development-current/Figure-23-missions-module.png` |
| 24 | Figure 24. Trips Module | `/trips` | supervisor | `docs/screenshots/development-current/Figure-24-trips-module.png` |
| 25 | Figure 25. Inbox Module | `/inbox` | superadmin | `docs/screenshots/development-current/Figure-25-inbox-module.png` |
| 26 | Figure 26. Support Module | `/support` | guard | `docs/screenshots/development-current/Figure-26-support-module.png` |
| 27 | Figure 27. Feedback Submission Module | `/feedback` | guard | `docs/screenshots/development-current/Figure-27-feedback-submission-module.png` |
| 28 | Figure 28. Feedback Dashboard Module | `/feedback-dashboard` | superadmin | `docs/screenshots/development-current/Figure-28-feedback-dashboard-module.png` |
| 29 | Figure 29. Firearms Module | `/firearms` | superadmin | `docs/screenshots/development-current/Figure-29-firearms-module.png` |
| 30 | Figure 30. Firearm Allocation Module | `/allocation` | admin | `docs/screenshots/development-current/Figure-30-firearm-allocation-module.png` |
| 31 | Figure 31. Firearm Permits Module | `/permits` | superadmin | `docs/screenshots/development-current/Figure-31-firearm-permits-module.png` |
| 32 | Figure 32. Armored Cars Module | `/armored-cars` | admin | `docs/screenshots/development-current/Figure-32-armored-cars-module.png` |
| 33 | Figure 33. Maintenance Module | `/maintenance` | admin | `docs/screenshots/development-current/Figure-33-maintenance-module.png` |
| 34 | Figure 34. Analytics Module | `/analytics` | superadmin | `docs/screenshots/development-current/Figure-34-analytics-module.png` |
| 35 | Figure 35. Audit Module | `/audit` | superadmin | `docs/screenshots/development-current/Figure-35-audit-module.png` |
| 36 | Figure 36. Profile Module | `/profile` | superadmin | `docs/screenshots/development-current/Figure-36-profile-module.png` |
| 37 | Figure 37. Settings Module | `/settings` | superadmin | `docs/screenshots/development-current/Figure-37-settings-module.png` |

## C) Capture evidence

- Capture report: `docs/screenshots/development-current/capture-report.json`
- Total screenshots captured: `26`
- Note: Operations Map screenshot logs websocket retry warnings in local mock mode, but the module surface was captured successfully.
