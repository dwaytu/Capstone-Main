import fs from 'node:fs/promises'
import path from 'node:path'
import { fileURLToPath } from 'node:url'
import { createRequire } from 'node:module'

const SCRIPT_DIR = path.dirname(fileURLToPath(import.meta.url))
const ROOT = path.resolve(SCRIPT_DIR, '..')
const frontendRequire = createRequire(path.join(ROOT, 'DasiaAIO-Frontend', 'package.json'))
const { chromium, devices } = frontendRequire('playwright')
const OUTPUT_DIR = path.join(ROOT, 'docs', 'assets')
const FRONTEND_BASE_URL = process.env.E2E_BASE_URL || 'http://127.0.0.1:5173'

const CREDENTIALS = {
  superadmin: { route: '/dashboard' },
  admin: { route: '/dashboard' },
  supervisor: { route: '/dashboard' },
  guard: { route: '/overview' },
}

const MOBILE_DEVICE = devices['iPhone 12']

function wait(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms))
}

async function ensureDarkTheme(page) {
  const darkToggle = page.getByRole('button', { name: /switch to dark mode/i }).first()
  if (await darkToggle.isVisible().catch(() => false)) {
    await darkToggle.click()
    await page.waitForTimeout(250)
  }
}

async function dismissLocationPromptIfPresent(page, dismissed) {
  const promptButton = page.getByRole('button', { name: /protect location access/i }).first()
  if (await promptButton.isVisible().catch(() => false)) {
    const dismissButton = page.getByRole('button', { name: /^dismiss$/i }).first()
    if (await dismissButton.isVisible().catch(() => false)) {
      await dismissButton.click()
      dismissed.push('location-prompt')
      await page.waitForTimeout(150)
    }
  }
}

async function dismissConsentDialogIfPresent(page, dismissed) {
  const consentDialog = page.getByRole('dialog', { name: /location tracking consent/i }).first()
  if (!(await consentDialog.isVisible().catch(() => false))) {
    return
  }

  const candidateNames = [/^decline$/i, /^dismiss$/i, /^close$/i, /^not now$/i, /^later$/i]
  for (const name of candidateNames) {
    const button = consentDialog.getByRole('button', { name }).first()
    if (await button.isVisible().catch(() => false)) {
      await button.click({ timeout: 3000 }).catch(() => {})
      dismissed.push('location-consent')
      await page.waitForTimeout(150)
      return
    }
  }

  await page.keyboard.press('Escape').catch(() => {})
  await page.waitForTimeout(150)
}

function buildRoleSession(role) {
  return {
    user: {
      id: `${role}-user-id`,
      username: role,
      email: `${role}@sentinel.local`,
      fullName: `${role.toUpperCase()} Account`,
      role,
      legalConsentAccepted: true,
    },
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

  if (url.includes('/api/users')) return ok({ users: [], total: 0 })
  if (url.includes('/api/alerts')) return ok({ alerts: [] })
  if (url.includes('/api/notifications')) return ok({ notifications: [] })
  if (url.includes('/api/feedback')) return ok({ feedback: [] })
  if (url.includes('/api/incidents')) return ok({ incidents: [] })
  if (url.includes('/api/tracking')) return ok({ guards: [], trips: [], clientSites: [], vehicles: [] })
  if (url.includes('/api/guard-replacement')) return ok({ shifts: [], attendance: [] })
  if (url.includes('/api/support-tickets')) return ok({ tickets: [] })
  if (url.includes('/api/firearm')) return ok({ firearms: [], allocations: [], permits: [] })
  if (url.includes('/api/armored-cars')) return ok({ armored_cars: [] })
  if (url.includes('/api/missions')) return ok({ missions: [] })
  if (url.includes('/api/trips')) return ok({ trips: [] })
  if (url.includes('/api/analytics')) return ok({ items: [], summary: {} })
  if (url.includes('/api/merit')) return ok({ scores: [], evaluations: [] })
  if (url.includes('/api/mdr')) return ok({ batches: [], rows: [] })
  if (url.includes('/api/presence')) return ok({ status: 'ok' })
  if (url.includes('/api/health')) return ok({ status: 'ok' })
  return ok({})
}

async function captureRoleVariant(browser, role, variant, report) {
  const creds = CREDENTIALS[role]
  const session = buildRoleSession(role)
  const isMobile = variant === 'mobile'
  const context = await browser.newContext(
    isMobile
      ? { ...MOBILE_DEVICE, colorScheme: 'dark' }
      : { viewport: { width: 1536, height: 864 }, colorScheme: 'dark' },
  )
  const page = await context.newPage()
  const dismissed = []
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

  await page.addInitScript(() => {
    localStorage.setItem('sentinel-theme', 'dark')
    localStorage.setItem('token', 'sentinel-local-token')
    localStorage.setItem('refreshToken', 'sentinel-local-refresh-token')
  })
  await page.addInitScript((user) => {
    localStorage.setItem('user', JSON.stringify(user))
  }, session.user)
  await page.route('**/api/**', mockApi)

  await page.goto(`${FRONTEND_BASE_URL}${creds.route}`, { waitUntil: 'domcontentloaded' })
  await ensureDarkTheme(page)
  await dismissConsentDialogIfPresent(page, dismissed)
  await dismissLocationPromptIfPresent(page, dismissed)
  await page.waitForTimeout(1000)

  const filename = `role-${role}-dashboard-${variant}.png`
  const screenshotPath = path.join(OUTPUT_DIR, filename)
  await page.screenshot({ path: screenshotPath, fullPage: false })

  report.captures.push({
    role,
    variant,
    route: creds.route,
    finalUrl: page.url(),
    screenshot: `docs/assets/${filename}`,
    dismissed,
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
    mode: 'ui-login-capture-darkmode',
    captures: [],
  }

  try {
    for (const role of ['superadmin', 'admin', 'supervisor', 'guard']) {
      await captureRoleVariant(browser, role, 'desktop', report)
      await captureRoleVariant(browser, role, 'mobile', report)
    }
  } finally {
    await browser.close()
  }

  const reportPath = path.join(OUTPUT_DIR, 'readme-screenshot-refresh-report.json')
  await fs.writeFile(reportPath, JSON.stringify(report, null, 2) + '\n', 'utf8')
  console.log(`Screenshots refreshed at ${OUTPUT_DIR}`)
  console.log(`Report written: ${reportPath}`)
}

main().catch((error) => {
  console.error(error)
  process.exitCode = 1
})
