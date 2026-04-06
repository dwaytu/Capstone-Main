# PROJECT_MEMORY.md — SENTINEL Security Operations Platform

> This file is the persistent working memory for AI coding agents (Codex / Copilot / orchestrators) working on SENTINEL.
>
> Purpose:
> - keep product, UX, architecture, deployment, and documentation aligned
> - prevent random feature drift
> - help AI think like a startup CTO + product designer + capstone engineer

---

# 1) PROJECT IDENTITY

## Product Name
**SENTINEL**

## Product Category
Security Operations Platform / Command & Control System / Guard Operations Management System

## Core Vision
SENTINEL should feel like a **real operational platform**, not a student dashboard project.

Conceptually, it should move toward:
- **Palantir-style operational intelligence**
- **mission-centric workflows**
- **role-based decision support**
- **high-trust field usability**

SENTINEL is NOT meant to be “feature-stuffed.”
It should be:
- cohesive
- reliable
- readable under pressure
- deployable
- believable as a real product

---

# 2) PRIMARY PRODUCT GOAL

SENTINEL exists to help security agencies manage:

- guards
- schedules
- incidents
- firearms
- armored vehicles
- missions / trips
- approvals
- real-time tracking
- operational awareness

The system should help users **make decisions quickly**, not just view data.

---

# 3) TARGET USERS

## Primary Users
### Guards
The guard is the most important user.
The system must work for them under:
- stress
- low connectivity
- mobile-only conditions
- emergency scenarios

### Supervisors
Need:
- situational awareness
- rapid incident prioritization
- fast escalation visibility

### Admin / Superadmin
Need:
- command center visibility
- approvals
- staffing / scheduling control
- resource / incident overview
- auditability

---

# 4) CORE PRODUCT PRINCIPLES

All future work MUST follow these principles:

## 4.1 Guard-first usability
If a guard cannot use it quickly at 2AM, it is bad UX.

## 4.2 Clarity over complexity
Do NOT add UI clutter or cleverness that reduces readability.

## 4.3 Decisions over dashboards
Dashboards must help users act, not just observe.

## 4.4 Real trust over fake polish
Never fake system intelligence, fake metrics, fake contacts, fake activity, or fake confidence.

## 4.5 Product cohesion
Everything should feel like ONE connected system, not isolated modules.

## 4.6 Production readiness
The system should always move toward:
- deployability
- reliability
- maintainability
- realistic use

---

# 5) CURRENT PLATFORMS

SENTINEL currently targets:

- **Web**
- **Desktop (Tauri)**
- **Mobile Android (Capacitor)**

All 3 should:
- use the same backend
- use the same database
- share the same business logic and product behavior
- feel like the same product

No platform should feel “secondary” or broken.

---

# 6) KNOWN PROJECT DIRECTION

## 6.1 DO NOT add random new features
The project has already passed the “feature accumulation” stage.

Current priority is:
- improve what exists
- make it stable
- make it trustworthy
- make it polished

## 6.2 Maintain the current design language
The goal is NOT to completely redesign the product.
The goal is to:
- refine it
- mature it
- professionalize it

## 6.3 Think like a startup + capstone
Every improvement should satisfy BOTH:
- “Would this make the product more real?”
- “Would this help in capstone defense?”

---

# 7) ARCHITECTURE MEMORY

## 7.1 Frontend (known structure)
Frontend is React-based and includes:
- role-based dashboards
- modular dashboard panels
- operational map components
- theme system
- local state + hooks
- role-aware navigation

Known dashboard/page structure includes:
- SuperadminDashboard
- AdminDashboard
- AnalyticsDashboard
- CalendarDashboard
- PerformanceDashboard
- MeritScoreDashboard
- ArmoredCarDashboard
- ProfileDashboard
- Guard/User dashboard
- Command center modules

## 7.2 Backend (known structure)
Backend is Rust-based and includes:
- route-centric API registration
- handlers
- services
- middleware
- DB bootstrap / schema logic

Known domains:
- auth
- users
- approvals
- firearms
- schedules
- attendance
- notifications
- incidents
- tracking
- analytics
- AI endpoints
- trips
- armored cars
- merit / evaluation
- support tickets

## 7.3 Database
Shared operational DB.
The system should remain **single-source-of-truth**, not fragmented per platform.

---

# 8) MAJOR PRODUCT THEMES

## 8.1 Operational Command Interface
SENTINEL should feel like:
- a command center
- an operational console
- a field support system

NOT:
- a school dashboard template
- a generic admin panel

## 8.2 Live Operational Storytelling
Important operational events should connect across:
- map
- alerts
- live feed
- incidents
- deployment views
- AI suggestions

The system should tell a live operational story.

## 8.3 Role-based decision support
Each role should be designed around:
- what they must decide
- what they must do next
- what they need to notice first

---

# 9) UX MEMORY — MOST IMPORTANT

## 9.1 Biggest current weakness: UI/UX maturity
The system’s biggest weakness is still:
- UI quality
- layout discipline
- visual hierarchy
- “product feel”

This is more important right now than adding features.

## 9.2 Common UX issues previously identified
The project has repeatedly suffered from:

### Layout / responsiveness
- overlapping content
- map overlay issues
- sidebar scrolling incorrectly
- profile hidden on mobile
- modals clipped or blocked
- broken mobile ergonomics

### Visual quality
- bland / flat / skeleton-like screens
- weak hierarchy
- too many equal-looking cards
- low visual confidence
- “unfinished student project” feeling

### Data density problems
- crowded tables
- action columns getting crushed
- weak row readability
- repetitive low-value actions like generic “View Details”

### Theme quality
- weak light mode
- dark mode needing better contrast / depth

---

# 10) UX DESIGN RULES (MUST FOLLOW)

These are non-negotiable.

## 10.1 Glanceability
A user should understand the screen in **< 2 seconds**.

## 10.2 Strong hierarchy
Important things must stand out immediately:
- critical alerts
- status
- primary actions
- role-relevant information

## 10.3 Low friction
Under pressure, users should not have to “figure things out.”

## 10.4 Mobile-first usability
Mobile is not secondary.
All mobile interactions must be:
- readable
- tappable
- unobstructed
- stress-friendly

## 10.5 Operational data grid behavior
For data-heavy screens:
- use fixed/flexible column planning
- avoid overlap
- keep actions accessible
- prefer clear operational tables over generic admin tables

## 10.6 Map should not overpower UI
Map is contextual, not the primary focus all the time.
It must not:
- overpower text
- create visual noise
- block overlays

---

# 11) GUARD EXPERIENCE MEMORY

## The guard is the biggest user base.
This is critical.

The guard experience should feel like:
- a mission screen
- a field tool
- a practical emergency interface

NOT:
- a mini admin dashboard

## Guard UX must prioritize:
- duty status
- assignment
- SOS / emergency actions
- reporting
- supervisor contact
- current operational relevance

## Guard UX must avoid:
- empty dead screens
- weak actions
- low urgency
- confusing labels

---

# 12) MIDNIGHT SHIFT HARDENING MEMORY

This is an important completed milestone.

## Guiding question:
**“Would a real guard trust and rely on this system during an emergency at 2AM?”**

## Result:
**YES — field-ready**, with some deferred non-blockers.

## Major improvements completed:
- removed fake trust signals / fake competence
- simplified emergency workflows
- added 1-tap SOS behavior
- made emergency contacts more visible
- improved offline resilience
- improved command center prioritization
- improved clarity / plain language

## Important trust principle learned:
Never fake:
- status
- monitoring
- support contacts
- operational confidence

---

# 13) CURRENT STRATEGIC PHASE

SENTINEL is now in:

# REFINEMENT / VALIDATION / PRODUCTIZATION PHASE

This means:
- do NOT bloat the feature set
- improve quality
- prove usability
- fix weak points
- harden deployment
- make the system feel finished

---

# 14) WHAT “DONE” LOOKS LIKE

SENTINEL should eventually feel like:

- a real product
- something a security agency could actually pilot
- something a panel would believe
- something that could become a real SaaS

The system should feel:
- stable
- coherent
- trustworthy
- role-aware
- useful under pressure

---

# 15) WHAT THE SYSTEM IS CURRENTLY MISSING (STRATEGIC GAPS)

These are the biggest conceptual gaps still being closed:

## 15.1 Product maturity
Need stronger:
- cohesion
- trust
- polish
- deployment quality

## 15.2 Decision intelligence
Need stronger:
- actionability
- recommendation clarity
- operational narrative

## 15.3 UI confidence
Need stronger:
- visual hierarchy
- ergonomic layout
- screen readability
- command-grade feel

## 15.4 Production confidence
Need stronger:
- release quality
- build reliability
- install/update trust
- real deployment readiness

---

# 16) DEPLOYMENT / RELEASE MEMORY

## Goals
All versions should be **production-ready**:
- web
- desktop
- android

## Known needs
- versioned artifacts
- better GitHub releases
- easier install experience
- auto-update system where appropriate
- professional release notes
- proper changelog generation
- signed builds
- reduced trust friction

## Desired release artifact naming
Examples:
- `SENTINEL_v1.1.1.apk`
- `SENTINEL_v1.1.1.exe`

## Android signing issue (known blocker)
Known recurring issue:
> Android release signing secrets are required for release builds.

This MUST be solved with:
- a real keystore
- GitHub Secrets
- CI workflow integration

### Required GitHub secrets
- `ANDROID_KEYSTORE_BASE64`
- `ANDROID_KEYSTORE_PASSWORD`
- `ANDROID_KEY_ALIAS`
- `ANDROID_KEY_PASSWORD`

## Important keystore rule
Keystore must be treated as critical identity.
If lost, update continuity is at risk.

---

# 17) AUTO-UPDATES MEMORY

## Desktop
Tauri updater should be considered for production-grade desktop updates.
Tauri’s updater requires signed update artifacts and a persistent signing key.

## Mobile / Web
Update UX should include:
- “What’s New”
- version awareness
- clean release messaging

---

# 18) PUSH NOTIFICATIONS MEMORY

Push notifications are one of the few deferred features worth implementing next because guards may not always have the app open.

## Recommended direction
Use **Firebase Cloud Messaging (FCM)** for Android and web notifications.
FCM supports Android and web, including foreground/background handling and topic/device targeting.

## Android considerations
Android 13+ requires runtime notification permission (`POST_NOTIFICATIONS`) for reliable notification delivery.

## Web considerations
Web push requires:
- HTTPS
- service worker
- VAPID key configuration in Firebase / web app.

---

# 19) DOCUMENTATION MEMORY

Documentation must remain synchronized with the system.

But synchronization does NOT mean:
- dumping implementation details
- writing commit logs into the paper
- exposing component-level dev narration

## Required documentation style
Documentation should be:
- professional
- concise
- academically appropriate
- product/system focused

## Documentation must avoid
- component names unless absolutely necessary
- dev jargon
- implementation chronology (“later pass”, “implemented first”, etc.)
- AI-sounding over-technical phrasing

## Preferred style
Describe:
- what the system does
- why it matters
- how it supports operations

Not:
- how every internal component was coded

## Important docs
- `SENTINEL - Group 8.md`
- `CHATGPT_SYSTEM_GUIDE.md`
- deployment / release / runbook docs

---

# 20) AGENT ORCHESTRATION MEMORY

The user uses a multi-agent orchestration workflow with agents like:
- browser tester
- code simplifier
- critic
- debugger
- designer
- devops
- documentation writer
- implementer
- orchestrator
- planner
- researcher
- reviewer

## Required orchestrator behavior
The orchestrator should NOT just obey instructions.

It should:
- think independently
- critique the product
- detect issues proactively
- propose multiple solutions
- choose the best one
- implement carefully
- self-review
- refine again

## Desired orchestrator mindset
Think like:
- startup CEO
- CTO
- product manager
- UX lead
- capstone student
- real field user

---

# 21) HOW AI AGENTS SHOULD WORK ON THIS PROJECT

Whenever an AI agent changes SENTINEL, it should ask:

## Product questions
- Does this improve real usability?
- Does this make the product more believable?
- Does this make a role’s job easier?

## UX questions
- Is this clearer in 2 seconds?
- Is this easier under pressure?
- Is this less cluttered?
- Is this more mobile-safe?

## Engineering questions
- Is this stable?
- Is this production-safe?
- Does this break any cross-platform behavior?

## Documentation questions
- Does documentation remain aligned?
- Is the explanation too technical or too verbose?

---

# 22) WHAT TO PRIORITIZE NEXT

Unless explicitly overridden, prioritize in this order:

## Priority 1 — UI / UX maturity
- hierarchy
- layout stability
- mobile usability
- clarity
- “finished product” feel

## Priority 2 — Real-world validation
- click-through testing
- stress scenarios
- friction elimination
- role-by-role usability

## Priority 3 — Production readiness
- Android signing
- CI/CD stability
- release quality
- install/update experience

## Priority 4 — Documentation quality
- capstone-ready language
- alignment with real system behavior

## Priority 5 — Selective deferred features only if high-value
Examples:
- push notifications
- minimal supervisor incident visibility improvements

---

# 23) THINGS TO AVOID

Avoid:
- random features
- fake intelligence
- fake data
- overengineering
- academic-writing pollution from raw implementation details
- UI complexity without operational value
- “pretty but unusable” design

---

# 24) SUCCESS TEST

Before considering any improvement “done,” ask:

## Core trust test
**Would a real guard trust this at 2AM?**

## Product test
**Would this make the system feel more like a real product?**

## Capstone test
**Would this strengthen defense / credibility?**

If the answer is no, the work is incomplete.

---

# 25) LIVE ENVIRONMENT MEMORY

## Production web app
Known live deployment:
- `https://dasiasentinel.xyz`

Agents may be instructed to:
- test it live
- click through it
- inspect console/network behavior
- critique and improve UI from real behavior

This should be used as a validation target when appropriate.

---

# 26) FINAL WORKING IDENTITY

SENTINEL should ultimately become:

> A guard-first, supervisor-aware, command-grade operational platform that feels deployable, believable, and professionally designed.

That is the north star.
