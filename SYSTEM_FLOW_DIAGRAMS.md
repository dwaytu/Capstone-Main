# SENTINEL System Diagrams

This file contains reusable Mermaid diagrams for SENTINEL:
- Process Flow Diagram
- Activity Diagram
- Data Flow Diagram (Level 1)

## 1. Process Flow Diagram

```mermaid
flowchart TD
    A[User Opens SENTINEL Frontend] --> B{Has Account?}
    B -- No --> C[Register Guard Account]
    C --> D[Email Verification]
    D --> E[Pending Approval Queue]
    E --> F[Reviewer Approves or Rejects]
    F --> G{Approved?}
    G -- No --> H[Notify Guard: Rejected]
    G -- Yes --> I[Notify Guard: Approved]

    B -- Yes --> J[Login with Identifier + Password]
    I --> J

    J --> K{Auth Valid + Verified + Approved?}
    K -- No --> L[Return Auth Error]
    K -- Yes --> M[Issue JWT + User Session]

    M --> N{Role?}
    N -- Superadmin/Admin/Supervisor --> O[Elevated Dashboard Shell]
    N -- Guard --> P[Guard Dashboard Shell]

    O --> Q[Operate Modules]
    P --> Q

    Q --> R[Users + Approvals + Scheduling]
    Q --> S[Firearms + Allocation + Permits + Maintenance]
    Q --> T[Armored Cars + Trips + Missions]
    Q --> U[Analytics + Merit + Tickets + Notifications]

    R --> V[API Request with Bearer Token]
    S --> V
    T --> V
    U --> V

    V --> W[Backend AuthZ + Handler Logic]
    W --> X[(PostgreSQL)]
    X --> Y[API Response]
    Y --> Z[UI Refresh + Command Center Metrics]
```

## 2. Activity Diagram

```mermaid
flowchart TD
    A([Start]) --> B[Load Frontend App]
    B --> C[Restore Token + User from Local Storage]
    C --> D{Session Exists?}

    D -- No --> E[Show Login Page]
    E --> F[User Enters Credentials]
    F --> G[POST /api/login]
    G --> H{Login Success?}
    H -- No --> I[Display Error Message]
    I --> F
    H -- Yes --> J[Persist JWT + User]

    D -- Yes --> J
    J --> K[Normalize Role]
    K --> L{Role Type}

    L -- Elevated --> M[Open Elevated Dashboard]
    L -- Guard --> N[Open Guard Dashboard]

    M --> O[Fetch Summary + Assets + Shifts + Notifications]
    N --> P[Fetch Guard-Specific Data]

    O --> Q{User Action?}
    P --> Q

    Q -- Navigate --> R[Change Active View]
    Q -- Create/Update/Delete --> S[Send Protected API Request]
    Q -- Logout --> T[Clear Session + Return Login]

    R --> U[Render Target Module]
    S --> V{Authorized?}
    V -- No --> W[Show Permission/Request Error]
    V -- Yes --> X[Write/Read DB + Audit]
    X --> Y[Return Updated Data]
    Y --> U
    U --> Q

    T --> Z([End])
```

## 3. Data Flow Diagram (Level 1)

```mermaid
flowchart LR
    %% External Entities
    U[User\nSuperadmin Admin Supervisor Guard]
    M[Mail Provider\nVerification + Reset Codes]

    %% Processes
    P1[1.0 Authentication\nRegister Login Verify Reset]
    P2[2.0 Access Control\nRole + Permission Checks]
    P3[3.0 Operations Management\nUsers Schedules Firearms Vehicles Trips Missions]
    P4[4.0 Support + Insights\nTickets Notifications Merit Analytics]

    %% Data Stores
    D1[(D1 Users + Roles + Approval Status)]
    D2[(D2 Verification + Reset Tokens)]
    D3[(D3 Operations Data\nShifts Attendance Firearms Allocations Permits Maintenance Cars Trips Missions)]
    D4[(D4 Support + Insights Data\nNotifications Tickets Merit Audit Logs)]

    %% Flows
    U -->|Credentials Registration Data| P1
    P1 -->|Verification/Reset Emails| M
    M -->|Codes| U

    P1 -->|Create/Update| D1
    P1 -->|Create/Validate| D2
    D1 -->|User + Role + Status| P1
    D2 -->|Token Validation| P1

    P1 -->|JWT + Session Context| P2
    U -->|Bearer Token + Requests| P2
    P2 -->|Authorized Requests| P3
    P2 -->|Authorized Requests| P4
    P2 -->|Denied/Error| U

    P3 -->|CRUD + Query| D3
    D3 -->|Operational Results| P3
    P3 -->|Responses| U

    P4 -->|Read/Write| D4
    D4 -->|Metrics Alerts Tickets Notifications| P4
    P4 -->|Responses| U

    P3 -->|Write Audit Events| D4
    P4 -->|Write Audit Events| D4
```
