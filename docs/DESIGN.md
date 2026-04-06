# SENTINEL — Visual Design Direction

> Comprehensive design specification for the authenticated dashboard UI/UX overhaul.
> This document is the single source of truth for all visual, layout, and interaction decisions.
> Every section is implementation-ready and references real CSS tokens, utility classes, and component names.

---

## 1. Visual Direction

### 1.1 Color Philosophy

SENTINEL is a **security operations command center** — not a generic SaaS dashboard. Color serves operational clarity first, aesthetics second.

**Dark Mode** — the primary operating mode for ops centers and low-light environments:

| Layer | Token | Light Value | Dark Value | Purpose |
|---|---|---|---|---|
| Canvas | `--color-background` | `#f5f7fb` | `#0b1220` | Deep, cool base — no true black |
| Surface | `--color-surface` | `#ffffff` | `#111827` | Card/panel backgrounds |
| Elevated | `--color-surface-elevated` | `#f3f6fb` | `#172133` | Raised surfaces, headers, sidebars |
| Hover | `--color-surface-hover` | `#eef3f9` | `#1c2940` | Interactive surface feedback |

Dark mode uses a subtle gradient body (`linear-gradient(165deg, #0b1220, #0f172a, #111827)`) with a cyan radial glow at 12% opacity (`--color-info` splash) for depth without distraction.

Light mode is clean and professional: flat white surfaces on a cool gray canvas. No gradients on body — reserve visual weight for content.

**Rules:**
- Never use raw hex values in components. Always reference Tailwind semantic tokens: `bg-surface`, `bg-surface-elevated`, `text-text-primary`, `border-border`.
- Dark mode surfaces are layered by adding 1-2 elevation steps — not by lightening the base color.
- The `body::before` radial gradient is the ONLY decorative background element. Do not add more.

### 1.2 Status & Severity Colors

Status colors carry **operational meaning**. Never use them decoratively.

| Semantic | Token Prefix | Light Text | Dark Text | Use |
|---|---|---|---|---|
| Success | `--color-success-*` | `#166534` | `#86efac` | On-shift, operational, approved |
| Warning | `--color-warning-*` | `#854d0e` | `#fde68a` | Pending, expiring, attention needed |
| Danger | `--color-danger-*` | `#991b1b` | `#fecaca` | Critical, failed, rejected, SOS |
| Info | `--color-info-*` | `#1e40af` | `#bae6fd` | Informational, neutral highlight |

Each semantic color has a triple: `{status}-bg`, `{status}-border`, `{status}-text`. Use all three together:

```html
<!-- Correct: full semantic triple -->
<div class="rounded-lg border border-warning-border bg-warning-bg p-3 text-sm text-warning-text">
  3 permits expire this week
</div>

<!-- Wrong: mixing tokens, using raw colors -->
<div class="bg-yellow-100 text-red-600">...</div>
```

**Color is never the only cue.** Every status indicator must pair color with:
- An icon (Lucide icon from `lucide-react`)
- Text label ("Active", "Pending", "Critical")

Status dots (`.status-light-*`) include a matching glow `box-shadow` for low-light legibility.

### 1.3 Typography Hierarchy

Two font families enforce visual hierarchy without relying on weight alone:

| Element | Font | Class | Size | Weight | Tracking | Transform |
|---|---|---|---|---|---|---|
| Page title | Rajdhani | `.soc-page-title` | 22px | 800 | 0.04em | UPPERCASE |
| Section title | Rajdhani | `.soc-section-title` | 16px | 700 | 0.05em | UPPERCASE |
| Card title | Rajdhani | `.soc-card-title` | 14px | 700 | 0.05em | UPPERCASE |
| Body text | Space Grotesk | `.soc-body` | 13px | 400 | normal | none |
| Label/caption | Space Grotesk | `.soc-label` | 11px | 700 | 0.12em | UPPERCASE |

**Rules:**
- Headings (`h1`–`h4`) automatically use Rajdhani via the CSS base layer.
- Page titles in `Header` component must NOT use `truncate`. SENTINEL page titles are short uppercase strings.
- Body text minimum is 13px (0.8125rem). Never go below for readability.
- Labels at 11px must be uppercase + bold + wide-tracked to remain legible at small size.
- Heading levels must never be skipped. Each dashboard page starts with an implicit `h1` in the Header.

### 1.4 Spacing System

Built on an 8px base unit (`--space-unit: 8px`):

| Token | Value | Use |
|---|---|---|
| `--space-1` | 0.25rem (4px) | Inline gaps, icon margins |
| `--space-2` | 0.5rem (8px) | Tight padding, small gaps |
| `--space-3` | 0.75rem (12px) | Card internal padding |
| `--space-4` | 1rem (16px) | Section gaps, standard padding |
| `--space-5` | 1.25rem (20px) | Group separation |
| `--space-6` | 1.5rem (24px) | Major section separation |

**Rules:**
- Card padding: `calc(var(--space-unit) * 2)` = 16px (from `.soc-dashboard-card`).
- Page-level content padding: `p-4 md:p-6` (from OperationalShell scroll area).
- Grid gaps between dashboard cards: `gap-4` (16px).
- Within a card, stack elements with `gap-2` (8px) or `gap-3` (12px).

### 1.5 Surface Elevation Model

Surfaces are differentiated by background, border, and shadow — not by z-axis overlap.

| Level | Background | Border | Shadow | Example |
|---|---|---|---|---|
| **Base** | `bg-background` | none | none | Page canvas |
| **Surface** | `bg-surface` | `border-border-subtle` | `--shadow-bento` | Standard cards |
| **Elevated** | `bg-surface-elevated` | `border-border-elevated` | `--shadow-elevated` | Modal panels, sticky regions |
| **Floating** | `bg-surface-elevated` | `border-border` | `--shadow-modal` | Dropdowns, popovers, modals |

Named surface classes:
- `.command-panel` — gradient surface with inset info glow + bento shadow
- `.soc-dashboard-card` — standard card with hover lift (translateY -2px)
- `.bento-card` — same as dashboard card, alternative naming
- `.soc-surface` — 1rem radius, subtle border, bento shadow
- `.soc-kpi` — compact KPI tile with gradient background

**Hover behavior:** Cards lift 2px (`translateY(-2px)`) with border color transitioning from `border-subtle` to `border-elevated` and shadow upgrading to `--shadow-bento-hover`.

### 1.6 Border Radius Scale

| Token | Value | Use |
|---|---|---|
| `--radius-sm` | 0.5rem | Buttons, small inputs, chips |
| `--radius-md` | 0.75rem | Alerts, inline panels |
| `--radius-card` | 10px | Cards, panels, containers |
| `--radius-lg` | 1rem | Modals, large panels |
| `--radius-pill` | 999px | Badges, chips, toggles |

---

## 2. Hierarchy Rules

### 2.1 Visual Weight System

Every dashboard page uses a three-tier weight system to guide the eye:

| Tier | Weight | Role | Example |
|---|---|---|---|
| **Primary** | Heavy — large, prominent, high-contrast | The single most important metric or status | Hero metric card, status banner |
| **Secondary** | Medium — standard cards, normal text | Supporting data and actions | KPI row, data tables, action buttons |
| **Tertiary** | Light — muted, compact, de-emphasized | Context and reference | Timestamps, labels, metadata |

**Implementation pattern:**
- Primary uses `.soc-page-title` + large metric value (text-2xl or text-3xl) + semantic color accent
- Secondary uses `.soc-section-title` + `.soc-dashboard-card` at standard size
- Tertiary uses `.soc-label` + `text-text-secondary` or `text-text-tertiary`

### 2.2 Dashboard Zone Model

Every role's dashboard follows a **three-zone layout** from top to bottom:

```
┌─────────────────────────────────────────┐
│  HERO ZONE — 1 card or banner           │
│  Status overview, primary metric         │
│  Full-width, visually dominant           │
└─────────────────────────────────────────┘
┌────────┬────────┬────────┬──────────────┐
│ KPI    │ KPI    │ KPI    │ KPI          │
│ tile   │ tile   │ tile   │ tile         │
└────────┴────────┴────────┴──────────────┘
┌─────────────────┬───────────────────────┐
│  ACTION ZONE    │  DETAIL ZONE          │
│  Tables, lists  │  Charts, breakdowns   │
│  Quick actions  │  Drill-down data      │
└─────────────────┴───────────────────────┘
```

**Hero Zone:**
- Maximum 1 hero element per page. Not every page needs one.
- Uses `.command-panel` or full-width `.soc-dashboard-card` with accent border.
- Guard hero: status hero (on-duty/off-duty banner)
- Superadmin hero: system health overview
- Supervisor hero: live incident summary

**KPI Row:**
- 2–4 tiles using `.soc-kpi` class on a responsive grid.
- `.guard-kpi-row`: 1-col mobile → 2-col sm → 4-col md.
- Each KPI: `.soc-kpi-label` (category) + `.soc-kpi-value` (number) + trend indicator.
- Maximum 4 KPIs per row. If more data needed, use a second grouped section below.

**Action/Detail Zone:**
- 2-column grid on desktop (`grid-cols-1 lg:grid-cols-2`), stacking on mobile.
- Tables on the left (action-primary), charts/breakdowns on the right (context).
- Or full-width table if no chart context is needed.

### 2.3 Reducing Cognitive Load

Audit finding: *"Elevated-role shell has too many similarly weighted panels, weak hierarchy."*

**Rules to enforce:**
1. **No more than 6 cards visible above the fold on desktop.** If a page has more, group them into collapsible sections.
2. **Section headers are mandatory.** Every group of related cards gets a `.soc-section-title` with an optional `.soc-section-badge` count.
3. **De-duplicate information.** If a fact appears in the hero zone, do NOT repeat it in a KPI tile. Example: guard duty status appears in the status hero only.
4. **Progressive disclosure.** Use expandable sections for less-critical data. Default to collapsed for reference sections (attendance history, archived permits).
5. **Remove repeated chrome.** Page-level refresh buttons, avatar pills, and status strips are handled by the Header. Individual cards do NOT get their own refresh buttons.

### 2.4 Card Sizing Guidelines

| Card Type | Width | Height | Padding | Use |
|---|---|---|---|---|
| KPI tile | flexible (grid child) | auto (~80px) | `0.85rem` | Single metric |
| Dashboard card | flexible (grid child) | auto (min ~120px) | `16px` | Standard content |
| Hero card | full-width | auto (~100-140px) | `16px–24px` | Page-level status |
| Table container | full-width or 2/3 | auto | `0` (table handles own padding) | Data tables |

---

## 3. Shell & Navigation Rules

### 3.1 OperationalShell — The Single Authenticated Shell

**Every authenticated page renders inside `OperationalShell`.** No exceptions.

File: `components/layout/OperationalShell.tsx`

Structure:
```
┌──────────────────────────────────────────┐
│ [Skip Link]                               │
├──────────┬───────────────────────────────┤
│          │  Header                        │
│ Sidebar  │  ┌───────────────────────────┐│
│          │  │ soc-scroll-area (content) ││
│          │  │                           ││
│          │  │                           ││
│          │  └───────────────────────────┘│
└──────────┴───────────────────────────────┘
```

**Rules:**
- Sidebar is hidden on mobile; opens as a drawer via hamburger menu.
- Guard role does NOT use OperationalShell. Guards get custom layout with `guard-sticky-region` bottom nav.
- `AnalyticsDashboard` and `AuditDashboard` MUST be wrapped in OperationalShell (currently they render without any navigation chrome — this is a bug).
- `FirearmInventory` MUST use the shell's nav system, not hardcode its own nav array.
- The main content area uses `.soc-scroll-area` for scrollbar gutter stability and overscroll containment.

### 3.2 Sidebar Structure

The sidebar (`components/Sidebar.tsx`) renders role-filtered navigation. Every role sees ONLY their relevant items, grouped into logical sections.

**Sidebar visual spec:**
- Background: `.soc-sidebar-shell` (94% surface opacity, right border)
- Active item: `.soc-sidebar-nav-item-active` (gradient background, left accent border 3px `--color-info`)
- Inactive item: `.soc-sidebar-nav-item` (text-secondary, hover → surface-hover + text-primary)
- Section headings: `.soc-sidebar-heading` (muted tertiary, uppercase label)
- Logout button: `.soc-sidebar-logout` (danger soft, transparent bg → danger-soft-bg on hover)
- Avatar: `.soc-avatar-gradient` with `.soc-role-chip` / `.soc-role-chip-admin` / `.soc-role-chip-guard`
- Top accent bar: `.soc-sidebar-accent` (gradient from info → accent)

### 3.3 Navigation Items Per Role

Labels are clean, single-word. No developer prefixes.

#### Superadmin
| Icon | Label | Route | Group |
|---|---|---|---|
| LayoutDashboard | Dashboard | `/dashboard` | Core |
| ClipboardCheck | Approvals | `/approvals` | Core |
| Calendar | Schedule | `/schedule` | Core |
| BarChart3 | Analytics | `/analytics` | Intelligence |
| ShieldCheck | Audit | `/audit` | Intelligence |
| Crosshair | Firearms | `/firearms` | Resources |
| Truck | Armored Cars | `/armored-cars` | Resources |
| Settings | Settings | `/settings` | System |

#### Admin
| Icon | Label | Route | Group |
|---|---|---|---|
| LayoutDashboard | Dashboard | `/dashboard` | Core |
| ClipboardCheck | Approvals | `/approvals` | Core |
| Calendar | Schedule | `/schedule` | Core |
| Users | Allocation | `/allocation` | Operations |
| Crosshair | Firearms | `/firearms` | Resources |
| Truck | Armored Cars | `/armored-cars` | Resources |
| Wrench | Maintenance | `/maintenance` | Resources |

#### Supervisor
| Icon | Label | Route | Group |
|---|---|---|---|
| LayoutDashboard | Dashboard | `/dashboard` | Core |
| Calendar | Schedule | `/schedule` | Core |
| Target | Missions | `/missions` | Field |
| ClipboardCheck | Approvals | `/approvals` | Operations |
| Users | Allocation | `/allocation` | Operations |

#### Guard
Guards do NOT use the sidebar. They use the **bottom nav** (see 3.5).

### 3.4 Header Rules

File: `components/shared/Header.tsx`

The Header is rendered by OperationalShell and provides:
- Page title (`.soc-page-title`, never truncated)
- Optional badge label (`.soc-section-badge`)
- Hamburger menu trigger (mobile only)
- User menu (avatar → dropdown: Profile, Settings, Inbox, Logout)
- Optional right slot for page-specific actions (single primary action, e.g. "Create" button)

**What the Header does NOT have:**
- Per-page refresh buttons (removed — use pull-to-refresh gesture on mobile, or ctrl+R)
- Repeated status strips or connection indicators
- Breadcrumbs (pages are flat — sidebar provides navigation context)

### 3.5 Mobile Bottom Nav

#### Guard Bottom Nav
Implemented via `.guard-sticky-region` fixed at viewport bottom:

```
┌────────────────────────────────────────┐
│ [Emergency Contacts Bar]                │ ← EmergencyContactsBar (expanded default)
├──────────┬──────────┬────────┬─────────┤
│ Mission  │ Resources│ Support│   Map   │ ← .guard-sticky-nav (4-col grid)
├──────────┴──────────┴────────┴─────────┤
│ [Check In]          [Report Incident]   │ ← .guard-sticky-action-row (2-col)
└────────────────────────────────────────┘
```

- Touch targets: minimum 44px height (per WCAG 2.5.8). Contact pills ≥ 44px.
- Backdrop blur: `backdrop-filter: blur(12px)` via `.guard-sticky-inner`.
- Bottom safe area: `env(safe-area-inset-bottom)` padding.
- Content must pad bottom by `--guard-sticky-region-height` (12rem) to avoid sticky overlap.

#### Elevated Role Mobile Bottom Nav
For superadmin/admin/supervisor on mobile screens (< 768px), show a bottom tab bar:

| Tab | Icon | Route | Priority |
|---|---|---|---|
| Dashboard | LayoutDashboard | `/dashboard` | Always |
| Approvals | ClipboardCheck | `/approvals` | High |
| Schedule | Calendar | `/schedule` | High |
| Notifications | Bell | `/notifications` | Medium |
| More | MoreHorizontal | drawer | Low |

"More" opens an overlay drawer with remaining nav items.

**Rules:**
- Bottom nav is ONLY visible below 768px breakpoint.
- Maximum 5 tabs. "More" is always the last item.
- Active tab: `--color-info` icon + text. Inactive: `text-text-secondary`.
- Use `--z-mobile-nav: 64` for stacking.
- Do not show bottom nav for guard role — they have their own specialized bottom region.

---

## 4. Page-Level Patterns

### 4.1 Dashboard Card Anatomy

Every dashboard card follows this internal structure:

```
┌──────────────────────────────────────┐
│ ■ CARD TITLE          [Action Link] │ ← .soc-card-title + optional pill/link
│                                      │
│   42                                 │ ← Primary metric (text-2xl font-bold)
│   ▲ 12% from last week              │ ← Trend line (success or danger color)
│                                      │
│   [Optional sparkline or mini-chart] │
│                                      │
│   [View Details →]                   │ ← Optional footer action
└──────────────────────────────────────┘
```

CSS class: `.soc-dashboard-card`

**Rules:**
- Title is ALWAYS top-left, using `.soc-card-title`.
- No more than ONE primary metric per card. If two metrics needed, use two cards.
- Trend indicators: `▲` with `text-success-text` for positive, `▼` with `text-danger-text` for negative.
- Card actions (links, buttons) are aligned right or as a footer. Maximum 1 primary action per card.

### 4.2 Table Patterns

CSS classes: `.table-glass`, `.thead-glass`

```html
<div class="table-glass overflow-hidden rounded-[var(--radius-card)]">
  <table class="w-full text-left text-sm">
    <thead class="thead-glass">
      <tr>
        <th class="soc-label px-4 py-3">Name</th>
        <th class="soc-label px-4 py-3">Status</th>
        <th class="soc-label px-4 py-3">Actions</th>
      </tr>
    </thead>
    <tbody>
      <tr class="border-b border-border-subtle transition-colors hover:bg-surface-hover">
        <td class="px-4 py-3">...</td>
      </tr>
    </tbody>
  </table>
</div>
```

**Rules:**
- Table header uses `.thead-glass` (sticky top, elevated surface, bottom border shadow).
- Rows have `hover:bg-surface-hover` transition (150ms ease via `.table-glass tbody tr`).
- Column headers use `.soc-label` styling (11px, uppercase, tracked).
- Cell padding: `px-4 py-3` consistently.
- Pagination below table: simple "Page X of Y" with previous/next buttons using `.soc-btn-secondary`.
- Status columns use `.soc-chip` with appropriate `status-*` modifier.

### 4.3 Form Patterns

```
┌──────────────────────────────────────┐
│ LABEL                                │ ← .soc-label, above field
│ ┌──────────────────────────────────┐ │
│ │ Input value                      │ │ ← bg-surface, border-border, rounded-[--radius-sm]
│ └──────────────────────────────────┘ │
│ Helper text or error                 │ ← text-text-tertiary or text-danger-text
│                                      │
│ LABEL *                              │ ← * for required (+ aria-required="true")
│ ┌──────────────────────────────────┐ │
│ │ Input value                      │ │
│ └──────────────────────────────────┘ │
│ ⚠ This field is required            │ ← aria-invalid="true" + aria-describedby
│                                      │
│              [Cancel] [Submit]       │ ← .soc-btn-secondary + .soc-btn-primary
└──────────────────────────────────────┘
```

**Rules:**
- Labels always ABOVE the field, never floating/disappearing.
- Required: asterisk + `aria-required="true"`.
- Validation errors: `aria-invalid="true"` on field, error text with `text-danger-text`, connected via `aria-describedby`.
- On submit with errors: focus first invalid field.
- Submit buttons are NEVER disabled to prevent submission. Show errors after attempt.
- Cancel and Submit are right-aligned. Submit is `.soc-btn-primary`, Cancel is `.soc-btn-secondary`.
- Form containers use `.soc-surface` or `.command-panel` as wrapper.

### 4.4 Detail / Drill-Down Patterns

When navigating from a list to a single item (e.g., incident detail, guard profile):

- Use a modal (`.soc-modal-backdrop` + `.soc-modal-panel`) for quick reads (< 4 fields).
- Use a dedicated page section (inline expand or route) for complex detail (incident timeline, audit log).
- Detail headers repeat the title + status chip from the list row for context continuity.
- Back navigation: use sidebar (already provides it) or a breadcrumb above the detail.

---

## 5. Role Differentiation Rules

### 5.1 Superadmin — System Commander

**Visual identity:** Broadest view, aggregate-first, compliance-focused.

- Dashboard hero: **System Health** — single aggregate status (Operational / Degraded / Critical) with sub-counts.
- KPI focus: Total active guards, pending approvals count, open incidents, compliance score.
- Tone: authoritative, high-level. Charts showing trends over weeks/months.
- Unique access: Analytics, Audit, Settings, system-wide user management.
- **Does NOT see:** Individual shift check-in UIs, guard-specific quick actions, field-level map tracking.

### 5.2 Admin — Operations Manager

**Visual identity:** Staffing-focused, resource allocation, approval workflows.

- Dashboard hero: **Today's Operations** — guards on shift, vehicles deployed, pending requests.
- KPI focus: Staffing coverage %, vehicles available, pending approvals, upcoming schedule gaps.
- Tone: operational, workflow-driven. Tables and lists dominate.
- Unique access: Allocation, Maintenance, guard record management.
- **Does NOT see:** Audit logs, system analytics, live field tracking map.

### 5.3 Supervisor — Field Commander

**Visual identity:** Real-time, tactical, response-oriented.

- Dashboard hero: **Active Field Status** — guards on post, active incidents, response status.
- KPI focus: Guards on duty now, incidents open, average response time, area coverage.
- Tone: urgent, live. Real-time updates, map-centric, minimal historical data.
- Unique access: Live map, incidents, mission coordination.
- **Does NOT see:** HR-level staffing allocation, vehicle maintenance logs, audit/compliance reports.

### 5.4 Guard — Field Operator

**Visual identity:** Mobile-first, glanceable, action-oriented.

- Layout: NO sidebar. Bottom nav with sticky action buttons.
- Hero: **Status Hero** — am I checked in? Where? When does shift end? Am I trackable?
- KPI row: Post | Shift Time | Tracking Status (3 items max).
- Tone: minimal, high contrast, large touch targets. No paragraphs — short phrases.
- Unique access: Check-in/out, incident reporting, emergency contacts, equipment checklist.
- **Does NOT see:** Approvals, analytics, audit, vehicles, allocation, maintenance, settings (except personal profile).
- Off-duty state: Upcoming schedule list + availability toggle + equipment checklist (not bare "No active shifts").

### 5.5 Route Protection

- Guard attempting to navigate to elevated routes (`/analytics`, `/audit`, `/vehicles`, `/armored-cars`, `/inbox`, etc.) → **silent redirect to `/overview`**. No error page, no flash.
- Elevated roles attempting guard-only routes → redirect to `/dashboard`.
- Implementation: route guard in the router checks role against allowed routes, redirects via `navigate(fallback, { replace: true })`.

---

## 6. Empty/Loading/Error State System

### 6.1 Shared EmptyState Component

**Spec:** `components/shared/EmptyState.tsx`

```tsx
interface EmptyStateProps {
  icon: LucideIcon            // Semantic icon (not generic)
  title: string               // Action-oriented title
  subtitle?: string           // Brief helpful context
  action?: {
    label: string
    onClick: () => void
  }
}
```

Visual spec:
```
┌──────────────────────────────────────┐
│                                      │
│            [  Icon  ]                │ ← 48px, text-text-tertiary, opacity-60
│                                      │
│     No incidents to review           │ ← text-lg font-semibold text-text-primary
│   Your sector is clear. Keep watch.  │ ← text-sm text-text-secondary
│                                      │
│        [Create Incident]             │ ← .soc-btn (optional)
│                                      │
└──────────────────────────────────────┘
```

CSS: `.soc-empty-state` (dashed border, centered, elevated background).

**Copywriting rules:**
- NEVER: "No data found", "Nothing here", "Empty"
- ALWAYS: action-oriented, role-appropriate, specific to the page context
- Include what the user CAN do, not just what's missing

#### Specific Empty State Messages

| Page | Icon | Title | Subtitle |
|---|---|---|---|
| Schedule | Calendar | No shifts scheduled | Schedule will appear here once assigned by your supervisor. |
| Trips | MapPin | No active trips | Trips will appear here when armored car runs are dispatched. |
| Allocation | Users | No allocation records | Staff assignments will appear when scheduling is configured. |
| Maintenance | Wrench | No maintenance requests | Vehicle maintenance requests will be listed here. Create one to get started. |
| Permits | FileCheck | No permits on file | Firearm permits and licenses will display here once uploaded. |
| Incidents | AlertTriangle | All clear | No incidents reported. Maintain operations as normal. |
| Support | MessageSquare | No support tickets | Need help? Create a ticket and our team will respond. |
| Guard off-duty | Clock | Off duty | Your next shift starts [date/time]. Review your equipment checklist below. |

### 6.2 Loading Skeleton Pattern

CSS class: `.soc-skeleton`

Skeletons match the shape of the content they replace:

| Content | Skeleton Shape | Example Class |
|---|---|---|
| KPI tile | Rounded rect, 80px tall | `.soc-skeleton h-20 rounded-[var(--radius-card)]` |
| Dashboard card | Rounded rect, 120px tall | `.soc-skeleton h-30 rounded-[var(--radius-card)]` |
| Table row | 3-4 horizontal bars | `.soc-skeleton h-4 rounded` per cell |
| Text block | Varying-width bars | `.soc-skeleton h-3 w-3/4 rounded` |

**Rules:**
- Every page that fetches data MUST show skeletons during loading. No blank white/black screens.
- Skeletons use the shimmer animation: `background-size: 200% 100%` + `animation: shimmer 1.4s ease infinite`.
- Skeleton count should match expected content count. A 4-KPI row shows 4 skeleton tiles.
- Skeletons fade out by swapping to real content (`.soc-animated-entry` with `fade-in-up 240ms`).

### 6.3 Error State Pattern

```
┌──────────────────────────────────────┐
│                                      │
│           [ AlertCircle ]            │ ← 48px, text-danger
│                                      │
│    Something went wrong              │ ← text-lg font-semibold
│    We couldn't load this section.    │ ← text-sm text-text-secondary
│                                      │
│    [Retry]   [Contact Support]       │ ← .soc-btn-primary + .soc-btn-secondary
│                                      │
└──────────────────────────────────────┘
```

CSS: `.soc-alert-error` (danger border, danger background, danger text).

**Rules:**
- Error states include a retry action as the primary button.
- If retry fails twice, show "Contact Support" as fallback.
- API error messages are NEVER shown raw to users. Map to human-readable text.
- Page-level errors appear in the OperationalShell content area (`error` prop).
- Section-level errors appear inline within the card/section that failed.

---

## 7. Responsive Behavior Guidance

### 7.1 Breakpoint Strategy

| Name | Width | Tailwind | Target |
|---|---|---|---|
| Mobile | 375px+ | (default) | Guard phones, small devices |
| Tablet | 768px+ | `md:` | Tablets, small laptops |
| Desktop | 1280px+ | `lg:` or `xl:` | Standard monitors |
| Wide | 1920px+ | `2xl:` | Ops center wide screens |

### 7.2 Grid Collapse Rules

| Desktop Layout | Tablet | Mobile |
|---|---|---|
| 4-column KPI grid | 2-column | 1-column |
| 3-column card grid | 2-column | 1-column |
| 2-column (table + chart) | Stacked | Stacked |
| Sidebar + content | Drawer + content | Drawer + content |

Standard pattern:
```html
<div class="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4">
```

### 7.3 Touch Targets

Per WCAG 2.5.8:
- All interactive elements: minimum 44×44px touch area.
- Emergency contact pills: ≥ 44px tall.
- Bottom nav items: full grid cell height, minimum 44px.
- Action buttons on guard dashboard: `min-h-[2.75rem]` (44px).
- Spacing between adjacent touch targets: minimum 8px gap to prevent accidental taps.

### 7.4 Mobile-Specific Patterns

**Guard mobile layout:**
```
┌────────────────────┐
│ Header (compact)   │ ← --guard-main-reserved-height: 4.25rem
├────────────────────┤
│                    │
│  Content scroll    │ ← .guard-sticky-main (padded bottom)
│  area              │
│                    │
├────────────────────┤
│ guard-sticky-region│ ← Fixed bottom, --guard-sticky-region-height: 12rem
│ EmergencyContacts  │
│ [Nav tabs]         │
│ [Action buttons]   │
└────────────────────┘
```

**Elevated role mobile:**
- Sidebar collapses to drawer (hamburger trigger in Header).
- Bottom tab bar appears below 768px.
- Cards stack to single column.
- Tables scroll horizontally within their container (no content loss).

### 7.5 Safe Areas

Capacitor-wrapped mobile builds use safe area insets:
```css
padding-top: env(safe-area-inset-top, 0);
padding-bottom: env(safe-area-inset-bottom, 0);
```
- Applied to `body.platform-mobile`.
- Guard sticky region includes `env(safe-area-inset-bottom)` in its padding.
- OperationalShell scroll area includes `env(safe-area-inset-bottom)` in its bottom padding.

---

## 8. Micro-Interaction Patterns

### 8.1 Section Entrance Animation

Class: `.animate-section-enter`

```css
.animate-section-enter {
  animation: fade-in-up 0.4s ease-out both;
}
/* Staggered: each child delays +50ms */
.animate-section-enter:nth-child(2) { animation-delay: 0.05s; }
.animate-section-enter:nth-child(3) { animation-delay: 0.1s; }
/* ... up to :nth-child(6) at 0.25s */
```

**Usage:** Apply to dashboard cards and sections as direct children of a grid/flex container. Cards fade in from 8px below with staggered delays.

**Reduced motion:** `@media (prefers-reduced-motion: reduce)` collapses all animation durations to 0.01ms. Content appears instantly.

### 8.2 Card & Button Hover

Cards (`.soc-dashboard-card`, `.bento-card`):
- `translateY(-2px)` + border upgrade + shadow upgrade
- Duration: 180ms ease
- Only `transform`, `box-shadow`, and `border-color` animate (GPU-safe)

Buttons (`.soc-btn` family):
- `translateY(-1px)` + shadow upgrade
- Duration: 160ms ease

Active state: `.terminal-login-btn:active` uses `scale(0.985)` for press feedback.

### 8.3 Status Indicators

Pulsing status dot: `.status-light-pulse` uses `status-pulse` animation (2.4s, scale 0.95↔1.08, opacity 0.72↔1.0).

Critical glow: `.critical-glow` uses `pulse-critical` animation (1.8s, box-shadow range 10px↔22px red glow).

Both pulse animations respect `prefers-reduced-motion`.

### 8.4 Notification / Toast Pattern

Position: fixed bottom-right (or bottom-center on mobile), z-index `--z-toast: 80`.

```
┌──────────────────────────────────┐
│ ✓ Shift check-in confirmed       │ ← icon + message
│                         [Dismiss]│ ← auto-dismiss after 4s
└──────────────────────────────────┘
```

- Enter: slide up 16px + fade in (300ms ease-out).
- Exit: fade out (200ms ease-in).
- Stack: newest on bottom, max 3 visible.
- Semantic color: success/info/warning/danger with matching `--color-{status}-bg` background.

### 8.5 Skeleton → Content Transition

When data loads:
1. Skeleton disappears instantly (no exit animation needed — avoiding double animation).
2. Real content enters with `.soc-animated-entry` (`fade-in-up 240ms ease both`).

---

## 9. Data Visualization Direction

### 9.1 Technology

**Native SVG only.** The `recharts` library is NOT installed and must not be added.

All charts are implemented as React components rendering `<svg>` elements with Tailwind for layout and CSS custom properties for colors.

### 9.2 Supported Chart Types

| Chart | Use Case | Implementation Notes |
|---|---|---|
| **Sparkline** | Trend within a KPI card | `<polyline>` with `stroke` = semantic color, no axes, 60×24px |
| **Bar chart** | Period comparison (daily/weekly) | `<rect>` elements, horizontal labels below, max 12 bars |
| **Donut/ring** | Proportion (staffing %, compliance) | `<circle>` with `stroke-dasharray`, center label |
| **Trend line** | Time series (incidents, approvals) | `<path>` with filled area below at 10% opacity |
| **Horizontal bar** | Category comparison | `<rect>` horizontal, labels left-aligned |

### 9.3 Chart Color Rules

- Use semantic status colors for meaning-bearing data:
  - Active/Operational: `--color-success`
  - At Risk/Pending: `--color-warning`
  - Critical/Failed: `--color-danger`
  - Neutral/Baseline: `--color-info`

- For categorical data without status meaning, use the tone palette:
  - `tone-guard`: blue (`#2563eb` / `#93c5fd`)
  - `tone-vehicle`: amber (`#f59e0b` / `#fcd34d`)
  - `tone-mission`: purple (`#8b5cf6` / `#c4b5fd`)
  - `tone-maintenance`: red (`#dc2626` / `#fca5a5`)
  - `tone-analytics`: cyan (`#06b6d4` / `#67e8f9`)

- Never use more than 5 colors in a single chart.

### 9.4 Responsive Chart Behavior

- Charts scale with container width. Use `viewBox` on `<svg>` for proportional scaling.
- On mobile (< 768px): simplify charts — fewer data points, hide axis labels if needed.
- Sparklines remain same size across breakpoints (they're decorative-contextual).
- Bar/donut charts: set `min-height: 200px` on mobile, `min-height: 280px` on desktop.

### 9.5 Chart Accessibility

Every chart `<svg>` MUST have:

```html
<svg role="img" aria-label="Bar chart showing incident count per day this week">
  <title>Incidents per day</title>
  <desc>Monday: 3, Tuesday: 5, Wednesday: 2, Thursday: 4, Friday: 1</desc>
  <!-- chart elements -->
</svg>
```

**Rules:**
- `role="img"` + `aria-label` on every chart SVG.
- `<title>` and `<desc>` elements inside SVG for screen reader detail.
- Do NOT rely on color alone for chart comprehension. Use patterns (dashed strokes, fill patterns) or direct value labels.
- Donut charts: include center text with the primary value as visible text (not SVG-only).
- Forced-colors mode: chart fills default to `CanvasText` — use `currentColor` where possible.

---

## 10. Accessibility Requirements

### 10.1 Standards

WCAG 2.2 Level AA minimum. Go beyond when it meaningfully improves usability.

### 10.2 Contrast Requirements

| Element | Minimum Ratio | Tool |
|---|---|---|
| Normal text (< 24px) | 4.5:1 | `text-text-primary` on `bg-surface` ✓ |
| Large text (≥ 24px or 18.66px bold) | 3:1 | Page titles on surface ✓ |
| UI components (borders, icons) | 3:1 | Focus ring, status indicators |
| Focus indicator | 3:1 vs adjacent | `--color-focus-ring` (#0f4ccf light / #67e8f9 dark) |

Muted text (`text-text-secondary`, `text-text-tertiary`) MUST still meet 4.5:1. The tertiary token in dark mode (`#7f92ac` on `#111827`) is approximately 4.6:1 — acceptable but at the boundary. Do not go lighter.

### 10.3 Focus Management

- Focus visible: 2px solid `--color-primary` (light) or `--color-focus-ring` (dark), offset 2px. Applied globally via base layer `a:focus-visible, button:focus-visible, input:focus-visible`.
- Skip link: `.skip-link` as first focusable element → `#maincontent`. Implemented in OperationalShell.
- Modal focus trap: when `.soc-modal-backdrop` is open, tab cycling is confined to modal content.
- On modal close: return focus to the trigger element.
- Hidden content (`display:none`, `hidden`, `aria-hidden="true"`) MUST NOT be focusable.

### 10.4 Keyboard Navigation

- All interactive elements operable via keyboard.
- Tab order follows visual reading order (left-to-right, top-to-bottom).
- No keyboard traps.
- Sidebar nav items: navigable with Arrow keys if implemented as a composite widget, or Tab if individual links.
- Guard bottom nav: each tab is a button, navigable with Tab.
- Modal: `Escape` to close.
- Dropdown menus: `Escape` to close, Arrow keys to navigate items.

### 10.5 Screen Reader Support

- Semantic landmarks: `<header>`, `<nav>`, `<main>`, `<footer>`.
- `<main id="maincontent" tabindex="-1">` in OperationalShell.
- Live regions for dynamic content: use `aria-live="polite"` for notifications/toasts.
- `aria-live="assertive"` only for critical alerts (SOS, system failure).
- Status changes (shift check-in, incident report): announce via live region, not just visual.
- Charts: `role="img"` + `aria-label` + `<desc>` (see section 9.5).

### 10.6 Color Independence

Every instance where color conveys information MUST have a non-color alternative:
- Status badges: color + icon + text label
- Chart segments: color + pattern or direct value label
- Form errors: red border + error icon + error text
- Notifications: colored background + icon prefix + text

### 10.7 Forced Colors Mode

```css
@media (forced-colors: active) {
  .soc-dashboard-card, .bento-card, .table-glass, .status-live-card {
    border: 1px solid ButtonBorder;
    box-shadow: none;
  }
  .soc-btn, .soc-btn-primary, .soc-btn-secondary {
    border: 1px solid ButtonBorder;
    background: ButtonFace;
    color: ButtonText;
  }
  .guard-sticky-inner {
    border: 1px solid ButtonBorder;
    background: Canvas;
    color: CanvasText;
    box-shadow: none;
  }
}
```

Already implemented in `index.css`. **Rules for new components:**
- Never use `forced-color-adjust: none`.
- SVG icons: use `fill: currentColor` / `stroke: currentColor`.
- Gradients and shadows disappear in forced-colors — ensure borders provide sufficient boundary.
- Test all new components with Windows High Contrast mode.

### 10.8 Reduced Motion

```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
}
```

Already implemented globally. No per-component work needed — all animations automatically collapse. New animations should always use CSS `animation` or `transition` properties (never JS-driven intervals for visual effects).

---

## Appendix A: Z-Index Scale

| Token | Value | Use |
|---|---|---|
| `--z-base` | 0 | Default content |
| `--z-map` | 5 | Leaflet map container |
| `--z-sticky` | 20 | Sticky table headers |
| `--z-header` | 30 | App header |
| `--z-drawer-backdrop` | 40 | Sidebar drawer backdrop |
| `--z-guard-sticky-region` | 42 | Guard bottom nav |
| `--z-drawer` | 48 | Sidebar drawer panel |
| `--z-floating` | 60 | Dropdowns, popovers |
| `--z-mobile-nav` | 64 | Elevated role bottom nav |
| `--z-toast` | 80 | Notifications |
| `--z-banner` | 82 | System banners |
| `--z-rate-limit` | 84 | Rate limit warnings |
| `--z-overlay` | 100 | Modal backdrop |
| `--z-modal` | 110 | Modal panels |

---

## Appendix B: Audit Issue Resolution Map

| # | Finding | Resolution | Section |
|---|---|---|---|
| 1 | CSP blocks Google Fonts | Infrastructure fix: add `fonts.googleapis.com` to `style-src` in production CSP | — |
| 2 | Guards reach admin pages | Silent redirect to `/overview` via route guard | §5.5 |
| 3 | /support is a stub | Full ticket system per EmptyState + form patterns | §4.3, §6.1 |
| 4 | Weak hierarchy on elevated dashboards | Three-zone model + max 6 cards above fold | §2.2, §2.3 |
| 5 | Roles too visually similar | Role-specific dashboard heroes + unique KPI focus | §5 |
| 6 | Dev-like nav labels | Clean single-word labels per nav spec | §3.3 |
| 7 | Repeated chrome | Header handles all chrome; cards have no refresh/avatar | §3.4 |
| 8 | Wrong mobile bottom nav items | Revised bottom nav spec for elevated roles | §3.5 |
| 9 | Analytics/Audit no nav chrome | Wrap in OperationalShell | §3.1 |
| 10 | Thin empty states | Shared EmptyState component with contextual copy | §6.1 |
| 11 | Bare guard off-duty | Schedule + availability toggle + equipment checklist | §5.4 |

---

## Appendix C: CSS Class Quick Reference

### Surfaces
`command-panel` · `soc-dashboard-card` · `bento-card` · `soc-surface` · `soc-kpi` · `status-live-card`

### Typography
`soc-page-title` · `soc-section-title` · `soc-card-title` · `soc-body` · `soc-label`

### Buttons
`soc-btn` · `soc-btn-primary` · `soc-btn-secondary` · `soc-btn-success` · `soc-btn-danger` · `soc-btn-neutral` · `terminal-login-btn`

### Status
`soc-chip status-success` · `soc-chip status-warning` · `soc-chip status-danger` · `soc-chip status-info` · `soc-chip status-neutral`

### Status Bars (left accent)
`status-bar-success` · `status-bar-warning` · `status-bar-critical` · `status-bar-info` · `critical-glow`

### Status Lights
`status-light status-light-success` · `status-light-info` · `status-light-warning` · `status-light-danger` · `status-light-pulse`

### Tables
`table-glass` · `thead-glass`

### Badges
`soc-section-badge` · `soc-role-chip` · `soc-role-chip-admin` · `soc-role-chip-guard` · `status-badge` · `status-badge-pending` · `status-badge-accepted` · `status-badge-declined`

### Tones (category colors)
`tone-guard` · `tone-vehicle` · `tone-mission` · `tone-maintenance` · `tone-analytics` · `tone-guard-surface` · `tone-vehicle-surface` · `tone-mission-surface` · `tone-maintenance-surface` · `tone-analytics-surface`

### Layout
`soc-scroll-area` · `soc-sidebar-shell` · `soc-sidebar-nav-item` · `soc-sidebar-nav-item-active` · `guard-section-frame` · `guard-kpi-row` · `guard-sticky-main` · `guard-sticky-region` · `guard-sticky-inner` · `guard-sticky-nav` · `guard-sticky-action-row`

### State
`soc-skeleton` · `soc-empty-state` · `soc-animated-entry` · `animate-section-enter`

### Modals
`soc-modal-backdrop` · `soc-modal-panel`

### Alerts
`soc-alert-error` · `soc-alert-success` · `soc-warning-banner`

### Accessibility
`sr-only` · `skip-link`
