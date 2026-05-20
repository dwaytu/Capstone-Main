import fs from 'node:fs/promises'
import path from 'node:path'
import { fileURLToPath } from 'node:url'
import { createRequire } from 'node:module'

const SCRIPT_DIR = path.dirname(fileURLToPath(import.meta.url))
const ROOT = path.resolve(SCRIPT_DIR, '..')
const frontendRequire = createRequire(path.join(ROOT, 'DasiaAIO-Frontend', 'package.json'))
const { chromium } = frontendRequire('playwright')

const FRONTEND_BASE_URL = process.env.E2E_BASE_URL || 'http://127.0.0.1:5173'
const OUTPUT_DIR = path.join(ROOT, 'docs', 'screenshots', 'development-current')
const REPORT_PATH = path.join(OUTPUT_DIR, 'capture-report.json')

const VIEWPORT = { width: 1536, height: 864 }

const MODULES = [
  { figure: 12, caption: 'User Login Module', route: '/login', role: null },
  { figure: 13, caption: 'Superadmin Dashboard Module', route: '/dashboard', role: 'superadmin' },
  { figure: 14, caption: 'Administrator Dashboard Module', route: '/dashboard', role: 'admin' },
  { figure: 15, caption: 'Supervisor Dashboard Module', route: '/dashboard', role: 'supervisor' },
  { figure: 16, caption: 'Guard Dashboard Module', route: '/overview', role: 'guard' },
  { figure: 17, caption: 'Approvals Module', route: '/approvals', role: 'superadmin' },
  { figure: 18, caption: 'Scheduling Module', route: '/schedule', role: 'superadmin' },
  { figure: 19, caption: 'Calendar Module', route: '/calendar', role: 'superadmin' },
  { figure: 20, caption: 'Operations Map Module', route: '/operations-map', role: 'superadmin' },
  { figure: 21, caption: 'Management Module', route: '/manage', role: 'superadmin' },
  { figure: 22, caption: 'MDR Import Module', route: '/mdr-import', role: 'superadmin' },
  { figure: 23, caption: 'Missions Module', route: '/missions', role: 'supervisor' },
  { figure: 24, caption: 'Trips Module', route: '/trips', role: 'supervisor' },
  { figure: 25, caption: 'Inbox Module', route: '/inbox', role: 'superadmin' },
  { figure: 26, caption: 'Support Module', route: '/support', role: 'guard' },
  { figure: 27, caption: 'Feedback Submission Module', route: '/feedback', role: 'guard' },
  { figure: 28, caption: 'Feedback Dashboard Module', route: '/feedback-dashboard', role: 'superadmin' },
  { figure: 29, caption: 'Firearms Module', route: '/firearms', role: 'superadmin' },
  { figure: 30, caption: 'Firearm Allocation Module', route: '/allocation', role: 'admin' },
  { figure: 31, caption: 'Firearm Permits Module', route: '/permits', role: 'superadmin' },
  { figure: 32, caption: 'Armored Cars Module', route: '/armored-cars', role: 'admin' },
  { figure: 33, caption: 'Maintenance Module', route: '/maintenance', role: 'admin' },
  { figure: 34, caption: 'Analytics Module', route: '/analytics', role: 'superadmin' },
  { figure: 35, caption: 'Audit Module', route: '/audit', role: 'superadmin' },
  { figure: 36, caption: 'Profile Module', route: '/profile', role: 'superadmin' },
  { figure: 37, caption: 'Settings Module', route: '/settings', role: 'superadmin' },
]

function toSlug(value) {
  return value
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '')
}

function buildRoleSession(role) {
  if (!role) return null
  return {
    id: `${role}-demo-id`,
    username: role,
    email: `${role}@sentinel.local`,
    fullName: `${role.toUpperCase()} Account`,
    role,
    legalConsentAccepted: true,
  }
}

async function dismissCommonPrompts(page) {
  const selectors = [
    page.getByRole('button', { name: /^dismiss$/i }).first(),
    page.getByRole('button', { name: /^not now$/i }).first(),
    page.getByRole('button', { name: /^close$/i }).first(),
    page.getByRole('button', { name: /^decline$/i }).first(),
  ]
  for (const sel of selectors) {
    if (await sel.isVisible().catch(() => false)) {
      await sel.click({ timeout: 800 }).catch(() => {})
      await page.waitForTimeout(150)
    }
  }
}

async function mockApi(route) {
  const url = route.request().url()
  const ok = (payload) =>
    route.fulfill({
      status: 200,
      contentType: 'application/json',
      body: JSON.stringify(payload),
    })

  if (url.includes('/api/health')) return ok({ status: 'ok' })
  if (url.includes('/api/tracking/consent')) return ok({ accepted: true })
  if (url.includes('/api/users/pending-approvals')) return ok({ count: 0, users: [] })
  if (url.includes('/api/users')) return ok({ users: [], total: 0, page: 1, pageSize: 20, items: [] })
  if (url.includes('/api/guard-replacement')) return ok({ shifts: [], attendance: [] })
  if (url.includes('/api/missions')) return ok([])
  if (url.includes('/api/trips')) return ok([])
  if (url.includes('/api/incidents')) return ok({ incidents: [], items: [] })
  if (url.includes('/api/alerts')) return ok({ alerts: [], items: [] })
  if (url.includes('/api/notifications')) return ok({ notifications: [], items: [] })
  if (url.includes('/api/inbox')) return ok({ items: [] })
  if (url.includes('/api/support')) return ok({ tickets: [], items: [] })
  if (url.includes('/api/feedback')) return ok([])
  if (url.includes('/api/firearms')) return ok([])
  if (url.includes('/api/firearm-allocations')) return ok([])
  if (url.includes('/api/permits')) return ok([])
  if (url.includes('/api/armored-cars')) return ok([])
  if (url.includes('/api/car-allocations/active')) return ok([])
  if (url.includes('/api/car-maintenance/')) return ok([])
  if (url.includes('/api/maintenance')) return ok([])
  if (url.includes('/api/analytics')) {
    return ok({
      overview: {
        total_guards: 120,
        active_guards: 78,
        total_missions: 94,
        completed_missions: 62,
        active_missions: 18,
        total_firearms: 210,
        allocated_firearms: 134,
        total_vehicles: 28,
        deployed_vehicles: 16,
      },
      performance_metrics: {
        mission_completion_rate: 81.5,
        average_mission_duration: 5.8,
        guard_attendance_rate: 93.2,
        firearm_availability_rate: 97.1,
        vehicle_utilization_rate: 74.9,
      },
      resource_utilization: {
        firearms_in_use: 134,
        firearms_available: 76,
        vehicles_deployed: 16,
        vehicles_available: 12,
        guards_on_duty: 78,
        guards_available: 42,
      },
      mission_stats: {
        total_missions_this_month: 94,
        completed_missions_this_month: 62,
        pending_missions: 18,
        average_guards_per_mission: 3.6,
        average_duration_hours: 5.8,
      },
    })
  }
  if (url.includes('/api/audit/logs')) {
    return ok({
      items: [],
      meta: {
        total: 0,
        page: 1,
        page_size: 25,
        has_more: false,
      },
    })
  }
  if (url.includes('/api/audit/anomalies')) {
    return ok({
      windowHours: 24,
      total: 0,
      anomalies: [],
    })
  }
  if (url.includes('/api/audit/user-activity/')) {
    return ok({
      userId: 'demo-user',
      windowHours: 72,
      eventCount: 0,
      timeline: [],
      heatmap: [],
    })
  }
  if (url.includes('/api/audit')) return ok([])
  if (url.includes('/api/mdr')) return ok({ batches: [], rows: [], items: [] })
  if (url.includes('/api/presence')) return ok({ status: 'ok' })
  if (url.includes('/api/')) return ok({})

  return route.continue()
}

async function captureModule(browser, moduleEntry, report) {
  const context = await browser.newContext({ viewport: VIEWPORT, colorScheme: 'dark' })
  const page = await context.newPage()
  const roleSession = buildRoleSession(moduleEntry.role)
  const consoleErrors = []
  const networkErrors = []

  page.on('console', (msg) => {
    if (msg.type() === 'error') {
      consoleErrors.push(msg.text())
    }
  })

  page.on('response', (resp) => {
    if (resp.status() >= 400 && resp.url().includes('/api/')) {
      networkErrors.push(`${resp.status()} ${resp.url()}`)
    }
  })

  await page.route('**/api/**', mockApi)

  await page.addInitScript(() => {
    localStorage.setItem('sentinel-theme', 'dark')
  })

  if (roleSession) {
    await page.addInitScript((user) => {
      localStorage.setItem('token', 'sentinel-local-token')
      localStorage.setItem('refreshToken', 'sentinel-local-refresh-token')
      localStorage.setItem('user', JSON.stringify(user))
    }, roleSession)
  } else {
    await page.addInitScript(() => {
      localStorage.removeItem('token')
      localStorage.removeItem('refreshToken')
      localStorage.removeItem('user')
    })
  }

  const targetUrl = `${FRONTEND_BASE_URL}${moduleEntry.route}`
  await page.goto(targetUrl, { waitUntil: 'domcontentloaded' })
  await dismissCommonPrompts(page)
  await page.waitForTimeout(900)

  const fileName = `Figure-${moduleEntry.figure}-${toSlug(moduleEntry.caption)}.png`
  const filePath = path.join(OUTPUT_DIR, fileName)
  await page.screenshot({ path: filePath, fullPage: false })

  report.captures.push({
    figure: moduleEntry.figure,
    caption: moduleEntry.caption,
    route: moduleEntry.route,
    role: moduleEntry.role,
    url: page.url(),
    screenshot: `docs/screenshots/development-current/${fileName}`,
    consoleErrors,
    networkErrors,
  })

  await context.close()
}

async function main() {
  await fs.mkdir(OUTPUT_DIR, { recursive: true })

  const browser = await chromium.launch({ headless: true })
  const report = {
    generatedAt: new Date().toISOString(),
    frontendBaseUrl: FRONTEND_BASE_URL,
    totalModules: MODULES.length,
    captures: [],
  }

  try {
    for (const moduleEntry of MODULES) {
      await captureModule(browser, moduleEntry, report)
    }
  } finally {
    await browser.close()
  }

  await fs.writeFile(REPORT_PATH, JSON.stringify(report, null, 2) + '\n', 'utf8')
  console.log(`Saved ${report.captures.length} screenshots to ${OUTPUT_DIR}`)
  console.log(`Report: ${REPORT_PATH}`)
}

main().catch((error) => {
  console.error(error)
  process.exitCode = 1
})
