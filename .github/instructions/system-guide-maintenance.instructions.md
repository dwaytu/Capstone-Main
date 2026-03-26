---
description: "Keep CHATGPT_SYSTEM_GUIDE.md and SENTINEL - Group 8.md fully synchronized with system implementation"
applyTo: "**"
---

# SENTINEL Documentation Synchronization Instructions

When making ANY changes that affect system behavior, architecture, or features, you MUST update BOTH:

- `CHATGPT_SYSTEM_GUIDE.md` (technical system reference)
- `SENTINEL - Group 8.md` (capstone documentation)

This must be done in the SAME session as the change.

---

# 🔴 TRIGGER CONDITIONS (MANDATORY UPDATE)

You MUST update documentation when changes affect:

- Authentication / authorization (JWT, RBAC, approvals)
- Roles and permissions (superadmin, admin, supervisor, guard)
- Dashboards or UI flows (all dashboards including command center, calendar, analytics, etc.)
- API routes, handlers, or request/response contracts
- Database schema, migrations, or relationships
- AI features (prediction, classification, summarization, alerts)
- Real-time systems (websocket, tracking, live feeds)
- Cross-platform behavior (web, Tauri desktop, Capacitor mobile)
- Security features (middleware, audit logs, rate limiting, etc.)

---

# 🧠 REQUIRED UPDATE PROCESS

## 1. ANALYZE SYSTEM CHANGES

Inspect:

- Frontend:
  - components
  - dashboards
  - hooks
  - role-based UI logic

- Backend:
  - handlers
  - services (AI modules)
  - middleware (authz, audit, presence)
  - route definitions

- Data layer:
  - schema changes
  - new tables/fields
  - relationship updates

---

## 2. IDENTIFY IMPACT

Determine:

- Newly added features
- Modified behaviors
- Removed or deprecated features
- Changes to user flows or permissions
- Changes affecting system architecture or data flow

---

## 3. UPDATE `CHATGPT_SYSTEM_GUIDE.md`

You MUST:

- Reflect real system architecture and modules
- Update:
  - endpoints
  - handlers
  - services
  - dashboards
  - real-time flows
  - AI features
- Keep it technical and implementation-focused

### Quality Rules

- Use concrete file references and endpoint names
- Align strictly with actual code behavior
- Do NOT assume undocumented features

---

## 4. UPDATE `SENTINEL - Group 8.md`

You MUST:

- Keep EXACT section structure
- DO NOT rename or reorder headings

Update content inside these sections:

- Objectives
- Scope and Limitations
- Methodology
- Technical Background
- Hardware Requirements
- Software Requirements
- Requirements Analysis and Documentation
- Design of Software, System, Product, and/or Processes
- Development

### Academic Writing Rules

- Use formal, capstone-level tone
- Avoid generic textbook explanations
- Reflect REAL implemented features only
- Ensure consistency with system guide

---

## 5. VALIDATION UPDATE (MANDATORY)

After updating documentation, include:

- What was verified:
  - build status
  - test results
  - runtime behavior

- Any risks:
  - incomplete features
  - known limitations
  - future improvements

---

# ⚖️ GLOBAL RULES

- System code is the SINGLE SOURCE OF TRUTH
- Documentation must ALWAYS match implementation
- NEVER:
  - invent features
  - leave outdated descriptions
  - change document structure (for capstone file)

---

# ✅ MINIMUM QUALITY BAR

- Accurate and up-to-date
- Covers both frontend and backend when applicable
- Includes real endpoints, modules, and flows
- Clear, structured, and professional

---

# 🚀 QUICK COMMAND SUPPORT

When asked:

- "Sync documentation"
- "Update docs"
- "Reflect latest changes"

You MUST:

1. Analyze the current codebase
2. Apply all rules above
3. Update BOTH documentation files
4. Ensure full consistency across system and paper
