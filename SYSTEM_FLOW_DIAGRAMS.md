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
flowchart TD
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
    U -->|Bearer Token + Requests| P2
    P1 -->|Verification/Reset Emails| M
    M -->|Codes| U

    P1 -->|Create/Update| D1
    P1 -->|Create/Validate| D2
    D1 -->|User + Role + Status| P1
    D2 -->|Token Validation| P1

    P1 -->|JWT + Session Context| P2
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

## 4. Data Flow Diagram (Level 2)

### 4.1 Auth and Account Lifecycle (Level 2)

```mermaid
flowchart TD
        U[User] -->|Register/Login/Reset Input| P11[1.1 Validate Request]
        P11 --> P12[1.2 Register Guard]
        P11 --> P13[1.3 Authenticate Login]
        P11 --> P14[1.4 Password Recovery]
        P11 --> P15[1.5 Email Verification]

        P12 --> D1[(Users)]
        P12 --> D2[(Verifications)]
        P12 --> D5[(Notifications)]

        P15 --> D2
        P15 --> D1

        P13 --> D1
        P13 --> U

        P14 --> D6[(Password Reset Tokens)]
        P14 --> D1
        P14 --> U

        D1 --> P16[1.6 Approval Gate Check]
        D2 --> P16
        P16 -->|Approved + Verified| P17[1.7 JWT Session Issue]
        P16 -->|Rejected/Pending| U
        P17 --> U
```

### 4.2 Operations Core (Firearms, Vehicles, Trips, Missions)

```mermaid
flowchart TD
        E[Elevated User] --> P31[3.1 Resource Catalog Access]
        E --> P32[3.2 Allocation + Assignment]
        E --> P33[3.3 Trip and Mission Control]
        E --> P34[3.4 Maintenance and Permit Oversight]

        P31 <--> D31[(Firearms)]
        P31 <--> D32[(Armored Cars)]

        P32 <--> D33[(Firearm Allocations)]
        P32 <--> D34[(Car Allocations)]
        P32 <--> D35[(Driver Assignments)]

        P33 <--> D36[(Trips)]
        P33 <--> D37[(Missions)]
        P33 <--> D38[(Shifts + Attendance)]

        P34 <--> D39[(Firearm Maintenance)]
        P34 <--> D40[(Vehicle Maintenance)]
        P34 <--> D41[(Guard Permits)]

        P32 --> P35[3.5 Operational Status Aggregation]
        P33 --> P35
        P34 --> P35
        P35 --> E
```

### 4.3 Support, Notification, Merit, Analytics

```mermaid
flowchart TD
        U[User]

        subgraph Interaction Processes
            P41[4.1 Ticket Submission + Tracking]
            P42[4.2 Notification Center]
            P43[4.3 Merit and Performance Views]
            P44[4.4 Analytics Dashboard]
        end

        subgraph Data Stores
            D41[(Support Tickets)]
            D42[(Notifications)]
            D43[(Merit Scores + Evaluations)]
            D44[(Operational Aggregates)]
        end

        U --> P41
        U --> P42
        U --> P43
        U --> P44

        P41 <--> D41
        P42 <--> D42
        P43 <--> D43
        P44 <--> D44

        P41 --> P45[4.5 Alert + Event Propagation]
        P43 --> P45
        P45 --> D42

        D42 --> P42
        P42 --> U
        P44 --> U
```

## 5. Role-Based Swimlane Activity Diagram

```mermaid
flowchart TB
        subgraph Guard Lane
            G1[Login] --> G2[View Schedule and Assignments]
            G2 --> G3[Check-In/Check-Out]
            G3 --> G4[View Permits and Notifications]
            G4 --> G5[Create Support Ticket]
        end

        subgraph Supervisor Lane
            S1[Login] --> S2[View Dashboard and Alerts]
            S2 --> S3[Approve/Reject Pending Guards]
            S3 --> S4[Coordinate Shifts and Replacements]
            S4 --> S5[Monitor Trips and Equipment Status]
        end

        subgraph Admin Lane
            A1[Login] --> A2[Operate Elevated Dashboard]
            A2 --> A3[Manage Users below Superadmin]
            A3 --> A4[Manage Firearms, Vehicles, Allocations]
            A4 --> A5[Review Analytics, Merit, Tickets]
        end

        subgraph Superadmin Lane
            SA1[Login] --> SA2[Global Operational Oversight]
            SA2 --> SA3[Create/Manage Admin and Supervisor Accounts]
            SA3 --> SA4[Mission Assignment and High-Risk Decisions]
            SA4 --> SA5[Audit and Policy Enforcement]
        end

        G5 --> S2
        S5 --> A2
        A5 --> SA2
        SA5 --> S2
```

## 6. PNG Export-Ready Outputs

Use Mermaid CLI to export PNG files from this document.

```powershell
cd "d:\Dwight\Capstone Main"
npx -y @mermaid-js/mermaid-cli -w 2480 -H 3508 -i SYSTEM_FLOW_DIAGRAMS.md -o SYSTEM_FLOW_DIAGRAMS.png
```

Note: Mermaid CLI keeps tight content bounds, so each image may still be smaller than full A4 canvas.
To force exact A4 page size for each PNG, pad the exports with this command:

```powershell
cd "d:\Dwight\Capstone Main"
Add-Type -AssemblyName System.Drawing
$targetW = 2480
$targetH = 3508
Get-ChildItem SYSTEM_FLOW_DIAGRAMS-*.png | ForEach-Object {
    $srcPath = $_.FullName
    $img = [System.Drawing.Image]::FromFile($srcPath)
    $bmp = New-Object System.Drawing.Bitmap($targetW, $targetH)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.Clear([System.Drawing.Color]::White)
    $x = [int](($targetW - $img.Width) / 2)
    $y = [int](($targetH - $img.Height) / 2)
    $g.DrawImage($img, $x, $y, $img.Width, $img.Height)
    $img.Dispose(); $g.Dispose()
    $tmp = "$srcPath.a4.tmp.png"
    $bmp.Save($tmp, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
    Move-Item -Force $tmp $srcPath
}
```

If your Mermaid CLI version does not support multi-diagram markdown input, export each diagram by placing each code block in its own `.mmd` file and run:

```powershell
npx -y @mermaid-js/mermaid-cli -i process-flow.mmd -o process-flow.png
npx -y @mermaid-js/mermaid-cli -i activity-flow.mmd -o activity-flow.png
npx -y @mermaid-js/mermaid-cli -i dfd-level1.mmd -o dfd-level1.png
npx -y @mermaid-js/mermaid-cli -i dfd-level2-auth.mmd -o dfd-level2-auth.png
npx -y @mermaid-js/mermaid-cli -i dfd-level2-ops.mmd -o dfd-level2-ops.png
npx -y @mermaid-js/mermaid-cli -i dfd-level2-support.mmd -o dfd-level2-support.png
npx -y @mermaid-js/mermaid-cli -i swimlane-roles.mmd -o swimlane-roles.png
```
