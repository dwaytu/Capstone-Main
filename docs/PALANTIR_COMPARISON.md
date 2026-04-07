# SENTINEL vs Palantir — Capability Comparison

## Executive Summary

SENTINEL is a purpose-built security operations platform for private security agencies (specifically Davao Security & Investigation Agency). Palantir Technologies is a $4.48B-revenue enterprise data analytics platform serving intelligence agencies, militaries, and corporations globally. This document compares capabilities in the context of **physical security operations management** — the domain SENTINEL directly addresses.

---

## Company & Product Positioning

| Dimension | SENTINEL | Palantir |
|-----------|----------|---------|
| **Focus** | Private security operations management | Enterprise data integration and analytics |
| **Primary market** | Private security agencies (Philippines) | Government intelligence, military, law enforcement, and enterprise |
| **Core product** | Integrated web/desktop/mobile SOC platform | Gotham (defense/intel), Foundry (commercial), AIP (AI platform) |
| **Scale** | Single-agency, multi-role | Multi-organization, multi-domain |
| **Revenue** | Pre-revenue / capstone product | US$4.48 billion (2025) |
| **Employees** | Student capstone team | 4,429 (2025) |
| **Deployment** | Self-hosted or Railway cloud | On-premise, cloud, and edge (Apollo) |

---

## Feature Comparison: Physical Security Operations

### 1. Real-Time Personnel Tracking

| Capability | SENTINEL | Palantir Gotham |
|------------|----------|-----------------|
| Live GPS tracking | Yes — guard locations via Capacitor GPS, WebSocket feed | Yes — geospatial analysis across multiple sensor inputs |
| Map visualization | Leaflet/OpenStreetMap with dark/light theme tiles | Proprietary geospatial analysis engine |
| Guard movement trails | Yes — path playback with timeline slider | Yes — historical movement reconstruction from data streams |
| Geofence alerts | Yes — configurable client site boundaries with alert feed | Yes — advanced geofencing with multi-source correlation |
| Clustering at zoom levels | Yes — clustered markers at low zoom for readability | Yes — enterprise-scale spatial clustering |
| Offline tracking | Yes — IndexedDB queue with Background Sync | Depends on deployment; edge capability via Skykit |

**Assessment**: SENTINEL provides purpose-built guard tracking with mobile-first ergonomics. Palantir provides broader geospatial intelligence that requires significant configuration for physical security use cases.

### 2. Incident Management

| Capability | SENTINEL | Palantir |
|------------|----------|---------|
| Incident logging | Yes — 2-field form (description + priority), auto-generated title, GPS auto-fill | Via configurable ontology and data pipelines |
| Severity classification | Yes — heuristic AI severity estimation | Yes — ML-powered classification at scale |
| Incident summarization | Yes — AI-assisted summary generation | Yes — LLM-powered analysis via AIP |
| Emergency SOS | Yes — 1-tap PanicButton with GPS + offline queue | Not specifically designed for guard SOS |
| Alert feed | Yes — real-time incident alert feed in command center | Yes — configurable real-time alerting (Foundry Rules) |

**Assessment**: SENTINEL's incident flow is optimized for field guard ergonomics (minimal-field forms, one-tap SOS, offline-capable). Palantir's approach is more analytically powerful but requires enterprise integration effort.

### 3. Role-Based Access & Workforce Management

| Capability | SENTINEL | Palantir |
|------------|----------|---------|
| Role hierarchy | 4 roles: guard → supervisor → admin → superadmin | Configurable per deployment; typically tied to customer IAM |
| Shift scheduling | Yes — built-in shift management with swap requests | Not native; requires Foundry pipeline customization |
| Attendance/check-in | Yes — guard check-in/check-out with location verification | Not specifically designed for physical attendance |
| Firearm allocation | Yes — authorization workflow with custody tracking | Not applicable |
| Merit scoring | Yes — guard performance scoring system | Analytics-possible but not purpose-built |
| Approval workflows | Yes — multi-level approval chains (leave, shift swap, etc.) | Configurable via ontology actions |

**Assessment**: SENTINEL has purpose-built workforce management for security guards. Palantir has no equivalent out-of-the-box; achieving similar functionality would require custom Foundry application development.

### 4. Command Center / Dashboard

| Capability | SENTINEL | Palantir |
|------------|----------|---------|
| SOC-style dashboard | Yes — dark-mode command center with operational panels | Yes — Gotham provides military-grade command centers |
| Role-specific views | Yes — 4 distinct dashboard experiences per role | Yes — fully configurable per user/role |
| Live operations feed | Yes — real-time event feed with map integration | Yes — streaming data integration |
| Analytics widgets | Yes — native SVG charts, operational metrics | Yes — full BI/analytics suite |
| Predictive intelligence | Yes — AI prediction panels (advisory) | Yes — enterprise ML/AI pipeline with AIP |

**Assessment**: Comparable at the dashboard level. Palantir's dashboards serve broader intelligence analysis; SENTINEL's dashboards are tuned for physical security operational workflows.

### 5. Platform & Deployment

| Capability | SENTINEL | Palantir |
|------------|----------|---------|
| Web application | Yes — React SPA | Yes — browser-based |
| Desktop application | Yes — Tauri (Windows/macOS/Linux) | Yes — desktop deployment |
| Mobile application | Yes — Capacitor (Android) with offline-first | Limited mobile; Skykit for edge operations |
| Offline capability | Yes — IndexedDB + Background Sync for all guard actions | Skykit provides ruggedized offline capability |
| Self-hosted option | Yes — Docker/Railway | Yes — on-premise deployment |
| Edge deployment | Via Capacitor mobile app | Yes — Apollo for continuous deployment at edge |

**Assessment**: SENTINEL has stronger mobile-first guard ergonomics. Palantir has stronger edge computing and ruggedized deployment options for extreme environments.

### 6. AI & Intelligence Features

| Capability | SENTINEL | Palantir |
|------------|----------|---------|
| Incident severity estimation | Yes — heuristic classification (labeled advisory) | Yes — ML at enterprise scale |
| Report summarization | Yes — AI-assisted brief generation (labeled advisory) | Yes — LLM integration via AIP |
| Predictive analytics | Yes — operational prediction panels (advisory) | Yes — production-grade ML pipelines |
| Honest labeling | Yes — explicitly labeled as "advisory, not authoritative" | Human-in-the-loop policy; varies by deployment |
| LLM agents | Not implemented | Yes — AIP agents with ontology integration |
| Data fusion | PostgreSQL-based analytics | Multi-source data fusion across databases, APIs, and sensors |

**Assessment**: Palantir is categorically ahead in AI/ML maturity. SENTINEL honestly labels its AI features as advisory — an appropriate posture for a capstone product.

---

## Architectural Comparison

| Dimension | SENTINEL | Palantir |
|-----------|----------|---------|
| **Backend** | Rust/Axum REST API | Proprietary Java-based platform |
| **Database** | PostgreSQL | Proprietary data layer (supports many backends) |
| **Frontend** | React 18 / TypeScript / Tailwind CSS v4 | Proprietary web framework |
| **Real-time** | WebSocket | Streaming data pipelines |
| **Auth** | JWT with RBAC (4 roles) | Configurable IAM integration |
| **Deployment** | Docker, Railway, Tauri, Capacitor | Apollo (continuous deployment), on-premise, cloud, edge |
| **Open-source** | Open-source stack | Proprietary (some OSS tooling on GitHub) |

---

## Where SENTINEL Excels

1. **Guard-centric mobile UX**: Purpose-built mobile experience with 1-tap SOS, offline queue, GPS auto-fill, and minimal-field incident forms. Palantir has no equivalent field-guard mobile experience.

2. **Workforce management**: Native shift scheduling, attendance tracking, shift swap requests, firearm allocation, merit scoring, and multi-level approval workflows. These are out-of-the-box in SENTINEL but would require custom development in Palantir.

3. **Deployment simplicity**: A single Rust binary + PostgreSQL vs Palantir's complex enterprise deployment requiring Forward Deployed Engineers and multi-week onboarding boot camps.

4. **Cost accessibility**: Open-source stack deployable on Railway or self-hosted Docker. Palantir contracts run from millions to hundreds of millions of dollars.

5. **Honest AI labeling**: All AI features are explicitly labeled as "advisory, not authoritative" — a transparency standard that aligns with responsible AI practices.

6. **Cross-platform from day one**: Web, desktop (Tauri), and mobile (Capacitor) with offline-first design, from a single codebase.

---

## Where Palantir Excels

1. **Data fusion at scale**: Palantir's core value proposition is connecting siloed databases across entire organizations and agencies. SENTINEL operates within a single agency's data.

2. **AI maturity**: Production-grade ML pipelines, LLM agents (AIP), and enterprise-scale predictive analytics backed by $2.9B annual revenue.

3. **Government/defense certification**: IL5 certification for DoD Mission Critical National Security Systems. Used by CIA, FBI, NSA, DHS, and allied militaries.

4. **Edge computing**: TITAN mobile command vehicles, Skykit ruggedized field kits, MetaConstellation satellite integration.

5. **Ecosystem**: Partnerships with Lockheed Martin, Boeing, Booz Allen Hamilton, Deloitte, and General Dynamics for defense integration.

6. **Geospatial intelligence**: Multi-sensor fusion (drones, satellites, ground sensors) with autonomous tasking capabilities. SENTINEL uses GPS + map tiles.

---

## Key Insight

**SENTINEL and Palantir serve fundamentally different market segments.** Palantir is an enterprise data analytics platform for intelligence agencies and Fortune 500 companies with contracts in the hundreds of millions. SENTINEL is a purpose-built security operations platform for private security agencies that need guard management, shift scheduling, incident handling, and field mobility — features Palantir does not offer natively.

The comparison is most meaningful in the **command center / situational awareness** overlap, where both platforms provide real-time geospatial tracking, alert feeds, and operational dashboards. In this narrow intersection, SENTINEL provides a vertically integrated, mobile-first, cost-accessible alternative that targets the private security niche Palantir does not address.

---

## Sources

- Palantir Wikipedia entry (comprehensive, 380+ references)
- Palantir Gotham product page (palantir.com/platforms/gotham)
- Palantir 2025 Annual Report (SEC 10-K filing)
- SENTINEL codebase analysis (this repository)
- COPILOT.md and AGENTS.md project documentation
