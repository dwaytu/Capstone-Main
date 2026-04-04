# SENTINEL UI System Report

## Scope
This report documents the current SENTINEL shell and dashboard UI using runtime screenshots captured from the live frontend at localhost. Evidence includes role dashboards, role modules, global header components, and mobile viewport states.

## Capture Method
- Frontend runtime: Vite dev app on localhost
- Screenshot source: Browser automation against rendered UI
- Backend mode: Controlled API response mode for deterministic module rendering and role-state coverage
- Output directory: [docs/assets](assets)

## Global Shell Verification
### Sidebar Behavior
Verified sidebar behavior aligns with target architecture:
- Sidebar is navigation-focused
- Inbox and Settings are no longer primary sidebar items
- Global actions are available in top header

Representative captures:
- Superadmin shell: ![Superadmin shell](assets/role-superadmin-global-sidebar-header.png)
- Admin shell: ![Admin shell](assets/role-admin-global-sidebar-header.png)
- Supervisor shell: ![Supervisor shell](assets/role-supervisor-global-sidebar-header.png)

### Header Global Actions
All roles include accessible global controls in the top header:
- Quick inbox (bell)
- Settings panel (gear)
- Profile dropdown

Evidence by role:
- Superadmin inbox: ![Superadmin inbox tray](assets/role-superadmin-global-inbox-tray.png)
- Superadmin settings: ![Superadmin settings panel](assets/role-superadmin-global-settings-panel.png)
- Superadmin profile: ![Superadmin profile dropdown](assets/role-superadmin-global-profile-dropdown.png)
- Admin inbox: ![Admin inbox tray](assets/role-admin-global-inbox-tray.png)
- Admin settings: ![Admin settings panel](assets/role-admin-global-settings-panel.png)
- Admin profile: ![Admin profile dropdown](assets/role-admin-global-profile-dropdown.png)
- Supervisor inbox: ![Supervisor inbox tray](assets/role-supervisor-global-inbox-tray.png)
- Supervisor settings: ![Supervisor settings panel](assets/role-supervisor-global-settings-panel.png)
- Supervisor profile: ![Supervisor profile dropdown](assets/role-supervisor-global-profile-dropdown.png)
- Guard inbox: ![Guard inbox tray](assets/role-guard-global-inbox-tray.png)
- Guard settings: ![Guard settings panel](assets/role-guard-global-settings-panel.png)
- Guard profile: ![Guard profile dropdown](assets/role-guard-global-profile-dropdown.png)

## Role-by-Role Dashboard and Module Coverage

## Superadmin
### Dashboard
- Desktop: ![Superadmin desktop dashboard](assets/role-superadmin-dashboard-desktop.png)
- Mobile: ![Superadmin mobile dashboard](assets/role-superadmin-dashboard-mobile.png)

### Modules Captured
- Dashboard: ![Superadmin Dashboard module](assets/role-superadmin-module-dg-dashboard.png)
- Approvals: ![Superadmin Approvals module](assets/role-superadmin-module-ap-approvals.png)
- Calendar: ![Superadmin Calendar module](assets/role-superadmin-module-cl-calendar.png)
- Analytics: ![Superadmin Analytics module](assets/role-superadmin-module-an-analytics.png)
- System Audit Log: ![Superadmin Audit Log module](assets/role-superadmin-module-al-system-audit-log.png)
- Trip Management: ![Superadmin Trip Management module](assets/role-superadmin-module-tr-trip-management.png)
- Schedule: ![Superadmin Schedule module](assets/role-superadmin-module-sc-schedule.png)
- Missions: ![Superadmin Missions module](assets/role-superadmin-module-ms-missions.png)
- Performance: ![Superadmin Performance module](assets/role-superadmin-module-pf-performance.png)
- Merit Scores: ![Superadmin Merit Scores module](assets/role-superadmin-module-mr-merit-scores.png)
- Firearms: ![Superadmin Firearms module](assets/role-superadmin-module-fa-firearms.png)
- Permits: ![Superadmin Permits module](assets/role-superadmin-module-pm-permits.png)
- Maintenance: ![Superadmin Maintenance module](assets/role-superadmin-module-mt-maintenance.png)
- Armored Cars: ![Superadmin Armored Cars module](assets/role-superadmin-module-ac-armored-cars.png)

## Admin
### Dashboard
- Desktop: ![Admin desktop dashboard](assets/role-admin-dashboard-desktop.png)
- Mobile: ![Admin mobile dashboard](assets/role-admin-dashboard-mobile.png)

### Modules Captured
- Dashboard: ![Admin Dashboard module](assets/role-admin-module-dg-dashboard.png)
- Approvals: ![Admin Approvals module](assets/role-admin-module-ap-approvals.png)
- Calendar: ![Admin Calendar module](assets/role-admin-module-cl-calendar.png)
- Analytics: ![Admin Analytics module](assets/role-admin-module-an-analytics.png)
- Trip Management: ![Admin Trip Management module](assets/role-admin-module-tr-trip-management.png)
- Schedule: ![Admin Schedule module](assets/role-admin-module-sc-schedule.png)
- Missions: ![Admin Missions module](assets/role-admin-module-ms-missions.png)
- Performance: ![Admin Performance module](assets/role-admin-module-pf-performance.png)
- Merit Scores: ![Admin Merit Scores module](assets/role-admin-module-mr-merit-scores.png)
- Firearms: ![Admin Firearms module](assets/role-admin-module-fa-firearms.png)
- Allocation: ![Admin Allocation module](assets/role-admin-module-as-allocation.png)
- Permits: ![Admin Permits module](assets/role-admin-module-pm-permits.png)
- Maintenance: ![Admin Maintenance module](assets/role-admin-module-mt-maintenance.png)
- Armored Cars: ![Admin Armored Cars module](assets/role-admin-module-ac-armored-cars.png)

## Supervisor
### Dashboard
- Desktop: ![Supervisor desktop dashboard](assets/role-supervisor-dashboard-desktop.png)
- Mobile: ![Supervisor mobile dashboard](assets/role-supervisor-dashboard-mobile.png)

### Modules Captured
- Dashboard: ![Supervisor Dashboard module](assets/role-supervisor-module-dg-dashboard.png)
- Approvals: ![Supervisor Approvals module](assets/role-supervisor-module-ap-approvals.png)
- Calendar: ![Supervisor Calendar module](assets/role-supervisor-module-cl-calendar.png)
- Analytics: ![Supervisor Analytics module](assets/role-supervisor-module-an-analytics.png)
- Trip Management: ![Supervisor Trip Management module](assets/role-supervisor-module-tr-trip-management.png)
- Schedule: ![Supervisor Schedule module](assets/role-supervisor-module-sc-schedule.png)
- Missions: ![Supervisor Missions module](assets/role-supervisor-module-ms-missions.png)
- Performance: ![Supervisor Performance module](assets/role-supervisor-module-pf-performance.png)
- Merit Scores: ![Supervisor Merit Scores module](assets/role-supervisor-module-mr-merit-scores.png)
- Firearms: ![Supervisor Firearms module](assets/role-supervisor-module-fa-firearms.png)
- Allocation: ![Supervisor Allocation module](assets/role-supervisor-module-as-allocation.png)
- Permits: ![Supervisor Permits module](assets/role-supervisor-module-pm-permits.png)
- Maintenance: ![Supervisor Maintenance module](assets/role-supervisor-module-mt-maintenance.png)
- Armored Cars: ![Supervisor Armored Cars module](assets/role-supervisor-module-ac-armored-cars.png)

## Guard
### Dashboard
- Desktop: ![Guard desktop dashboard](assets/role-guard-dashboard-desktop.png)
- Mobile: ![Guard mobile dashboard](assets/role-guard-dashboard-mobile.png)

### Modules Captured
- Mission: ![Guard Mission module](assets/role-guard-module-mission.png)
- Support: ![Guard Support module](assets/role-guard-module-support.png)
- Resources: ![Guard Resources module](assets/role-guard-module-resources.png)
- Map: ![Guard Map module](assets/role-guard-module-map.png)

## Mobile/Responsive Review
Observed from role mobile captures:
- Header action density is high but still functional at narrow width
- Sidebar collapses/flows into mobile shell as expected
- Primary dashboard content remains visible without horizontal page break

Mobile evidence set:
- Superadmin: ![Superadmin mobile](assets/role-superadmin-dashboard-mobile.png)
- Admin: ![Admin mobile](assets/role-admin-dashboard-mobile.png)
- Supervisor: ![Supervisor mobile](assets/role-supervisor-dashboard-mobile.png)
- Guard: ![Guard mobile](assets/role-guard-dashboard-mobile.png)

## Known Issues and Notes
- Controlled-data capture mode was used to guarantee complete role/module visualization while backend session and data availability were variable.
- Real production data widgets may show additional cards, charts, or alert rows not visible in controlled-data captures.
- Backend connectivity status banners can alter vertical spacing in live unstable-network sessions.

## Asset Index
All generated images are available in [docs/assets](assets).
