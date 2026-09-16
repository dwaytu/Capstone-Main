# SYSTEM FLOW DIAGRAMS

Updated: 2026-09-16

## 1. Authentication, Approval, and Legal Consent Flow

```mermaid
flowchart TD
    A[Authorized staff creates guard account] --> B[POST /api/users]
    B --> C{Creator role}
    C -- Supervisor --> D[Account created as pending]
    C -- Admin or Superadmin --> E[Account created as approved]
    D --> F[Admin or Superadmin reviews guard details]
    F --> G[PUT /api/users/:id/approval]
    G --> H{Decision}
    H -- Approve --> I[approval_status=approved]
    H -- Reject --> J[approval_status=rejected + reason]
    E --> K[POST /api/login]
    I --> K
    J --> L[Guard cannot log in]
    K --> M[Access token + refresh token]
    M --> N{legal_consent_accepted?}
    N -- No --> O[POST /api/legal/consent]
    O --> P[Consent metadata persisted]
    P --> Q[Protected routes allowed]
    N -- Yes --> Q
```

## 2. Protected API Request Lifecycle

```mermaid
flowchart LR
    A[Frontend request with Bearer token] --> B[CORS layer]
    B --> C[Request timeout middleware]
    C --> D[Global API rate limiter]
    D --> E[AuthZ middleware]
    E --> F[Legal consent enforcement]
    F --> G[Handler execution]
    G --> H[(PostgreSQL)]
    H --> I[Structured JSON response]
    I --> J[Frontend state update]
```

## 3. Tracking and Command Map Data Flow

```mermaid
flowchart TD
    A[Client sends heartbeat] --> B[POST /api/tracking/heartbeat]
    B --> C[tracking_points insert]
    C --> D[Geofence transition evaluation]
    D --> E[geofence_events + notifications]
    E --> F[Broadcast map refresh event]

    G[Command dashboard] --> H[GET /api/tracking/map-data]
    G --> I[GET /api/tracking/ws?token=...]
    I --> J[WebSocket snapshot updates]
    J --> K[Map markers + alerts refresh]

    L[WebSocket unavailable] --> M[Polling fallback]
    M --> H
```

## 4. Cross-Platform Release Pipeline Flow

```mermaid
flowchart TD
    A[Tag push v* or workflow_dispatch] --> B[prepare job]
    B --> C[quality-gate job]
    C --> D[web job]
    C --> E[desktop job]
    C --> F[android job]

    F --> G[Materialize keystore from Actions secrets]
    G --> H[:app:assembleDebug preflight]
    H --> I[:app:assembleRelease + :app:bundleRelease]

    D --> J[sentinel-web-vX.Y.Z.tar.gz]
    E --> K[sentinel-desktop-windows-vX.Y.Z msi/exe]
    I --> L[sentinel-android-vX.Y.Z apk/aab]

    J --> M{Tag-triggered run?}
    K --> M
    L --> M
    M -- Yes --> N[publish job -> GitHub Release assets]
    M -- No --> O[Artifact validation only; publish skipped]
```

## 5. Validation Signals for These Flows

- Frontend tests/build pass (`npm test`, `npm run build` in `DasiaAIO-Frontend`).
- Backend tests/runtime pass (`cargo test`, `docker compose up -d`, `/api/health`).
- Live manual GitHub Actions run `23929317544` completed `prepare`, `quality-gate`, `web`, `desktop`, and `android` successfully.
- Android validation in that run included keystore materialization plus signed APK/AAB artifact generation; publish remained skipped because the run was not tag-driven.
