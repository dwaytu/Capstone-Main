import fs from 'node:fs/promises'
import path from 'node:path'
import { fileURLToPath } from 'node:url'
import { createRequire } from 'node:module'

const scriptDir = path.dirname(fileURLToPath(import.meta.url))
const root = path.resolve(scriptDir, '..')
const frontendRequire = createRequire(path.join(root, 'DasiaAIO-Frontend', 'package.json'))
const { chromium, devices } = frontendRequire('playwright')

const baseUrl = process.env.SIM_BASE_URL || 'https://dasiasentinel.xyz'
const password = process.env.SIM_PASSWORD || 'password123'
const tag = `LIVE1D-${new Date().toISOString().replace(/[-:.TZ]/g, '').slice(0, 12)}`
const runDir = path.join(root, 'output', `playwright-live-day-${tag}`)

const roles = [
  { role: 'superadmin', username: 'superadmin', mobile: false },
  { role: 'admin', username: 'admin', mobile: false },
  { role: 'supervisor', username: 'supervisor', mobile: false },
  { role: 'guard', username: 'guard', mobile: true },
]

const wait = (ms) => new Promise((resolve) => setTimeout(resolve, ms))

async function exists(locator) {
  return locator.isVisible().catch(() => false)
}

async function safeClick(locator) {
  if (!(await exists(locator))) return false
  await locator.click({ timeout: 4000 }).catch(() => {})
  return true
}

async function capture(page, fileName) {
  await page.screenshot({
    path: path.join(runDir, fileName),
    fullPage: true,
  })
}

async function dismissPrompts(page) {
  const names = [
    /prompt location access/i,
    /protect location access/i,
    /dismiss/i,
    /close/i,
    /not now/i,
    /later/i,
    /decline/i,
  ]
  for (const name of names) {
    const btn = page.getByRole('button', { name }).first()
    if (await exists(btn)) {
      await btn.click().catch(() => {})
      await wait(200)
    }
  }
}

async function login(page, username, pw) {
  await page.goto(`${baseUrl}/login`, { waitUntil: 'domcontentloaded' })
  await dismissPrompts(page)

  const identifier = page
    .locator(
      'input[name="identifier"], input[autocomplete="username"], input[type="email"], input[placeholder*="email" i], input[placeholder*="username" i], input[placeholder*="identifier" i]',
    )
    .first()
  const passwordInput = page.locator('input[type="password"]').first()

  await identifier.fill(username)
  await passwordInput.fill(pw)
  await page.getByRole('button', { name: /^login$/i }).click()

  await page.waitForURL((url) => !url.pathname.includes('/login'), { timeout: 15000 })
  await wait(1000)
  await dismissPrompts(page)
}

async function openNavIfNeeded(page) {
  const menu = page.getByRole('button', { name: /menu|open navigation|navigation/i }).first()
  await safeClick(menu)
}

async function clickNav(page, label) {
  const button = page.getByRole('button', { name: new RegExp(`^${label}$`, 'i') }).first()
  const link = page.getByRole('link', { name: new RegExp(`^${label}$`, 'i') }).first()
  if (await safeClick(button)) return true
  if (await safeClick(link)) return true
  await openNavIfNeeded(page)
  if (await safeClick(button)) return true
  if (await safeClick(link)) return true
  return false
}

async function simulateElevated(page, role, evidence) {
  const roleEvidence = {
    role,
    steps: [],
    consoleErrors: [],
    apiErrors: [],
  }

  page.on('console', (msg) => {
    if (msg.type() === 'error') roleEvidence.consoleErrors.push(msg.text())
  })
  page.on('response', (resp) => {
    if (resp.status() >= 400 && resp.url().includes('/api/')) {
      roleEvidence.apiErrors.push(`${resp.status()} ${resp.url()}`)
    }
  })

  await capture(page, `${role}-01-dashboard.png`)
  roleEvidence.steps.push('login_dashboard')

  if (await clickNav(page, 'Operations Map')) {
    await wait(1200)
    await capture(page, `${role}-02-operations-map.png`)
    roleEvidence.steps.push('operations_map_opened')
  } else {
    roleEvidence.steps.push('operations_map_nav_not_found')
  }

  if (await clickNav(page, 'Schedule')) {
    await wait(1200)
    await capture(page, `${role}-03-schedule.png`)
    roleEvidence.steps.push('schedule_opened')

    const addSchedule = page.getByRole('button', { name: /add schedule|add new schedule/i }).first()
    if (await safeClick(addSchedule)) {
      await wait(600)
      await capture(page, `${role}-04-add-schedule-modal.png`)
      roleEvidence.steps.push('add_schedule_modal_opened')

      const siteSelect = page.locator('label:has-text("Site/Location") + select, select').first()
      if (await exists(siteSelect)) {
        const optionCount = await siteSelect.locator('option').count().catch(() => 0)
        roleEvidence.steps.push(`site_dropdown_visible_options_${optionCount}`)
      } else {
        roleEvidence.steps.push('site_dropdown_not_visible')
      }
    } else {
      roleEvidence.steps.push('add_schedule_button_not_found')
    }
  } else {
    roleEvidence.steps.push('schedule_nav_not_found')
  }

  evidence.roles.push(roleEvidence)
}

async function simulateGuard(page, evidence) {
  const roleEvidence = {
    role: 'guard',
    steps: [],
    consoleErrors: [],
    apiErrors: [],
  }

  page.on('console', (msg) => {
    if (msg.type() === 'error') roleEvidence.consoleErrors.push(msg.text())
  })
  page.on('response', (resp) => {
    if (resp.status() >= 400 && resp.url().includes('/api/')) {
      roleEvidence.apiErrors.push(`${resp.status()} ${resp.url()}`)
    }
  })

  await capture(page, `guard-01-mission.png`)
  roleEvidence.steps.push('login_mission_view')

  const promptLocation = page.getByRole('button', { name: /prompt location access|protect location access/i }).first()
  if (await safeClick(promptLocation)) {
    await wait(1000)
    roleEvidence.steps.push('location_prompt_clicked')
  }

  const enableConsent = page.getByRole('button', { name: /enable consent/i }).first()
  if (await safeClick(enableConsent)) {
    await wait(1200)
    roleEvidence.steps.push('enable_consent_clicked')
    await capture(page, `guard-02-after-enable-consent.png`)
  }

  if (await clickNav(page, 'Map')) {
    await wait(1000)
    await capture(page, `guard-03-map.png`)
    roleEvidence.steps.push('map_opened')
  } else {
    roleEvidence.steps.push('map_nav_not_found')
  }

  if (await clickNav(page, 'Dashboard')) {
    await wait(800)
  }

  const sos = page.getByRole('button', { name: /^sos$/i }).first()
  if (await safeClick(sos)) {
    await wait(600)
    const confirmSos = page.getByRole('button', { name: /confirm|send sos|trigger|yes/i }).first()
    await safeClick(confirmSos)
    await wait(800)
    await capture(page, `guard-04-sos.png`)
    roleEvidence.steps.push('sos_trigger_attempted')
  } else {
    roleEvidence.steps.push('sos_button_not_found')
  }

  const reportIncidentBtn = page.getByRole('button', { name: /report incident|report/i }).first()
  if (await safeClick(reportIncidentBtn)) {
    await wait(500)
    const description = page
      .locator('textarea[placeholder*="what happened" i], textarea[name="description"], textarea')
      .first()
    if (await exists(description)) {
      await description.fill(`[${tag}] Guard incident simulation for one operational day`)
      const submit = page.getByRole('button', { name: /submit incident|submit/i }).first()
      await safeClick(submit)
      await wait(900)
      roleEvidence.steps.push('incident_submission_attempted')
      await capture(page, `guard-05-incident-submit.png`)
    } else {
      roleEvidence.steps.push('incident_form_not_found')
    }
  } else {
    roleEvidence.steps.push('report_incident_button_not_found')
  }

  if (await clickNav(page, 'Support')) {
    await wait(800)
    await capture(page, `guard-06-support.png`)
    roleEvidence.steps.push('support_opened')
  } else {
    roleEvidence.steps.push('support_nav_not_found')
  }

  evidence.roles.push(roleEvidence)
}

async function main() {
  await fs.mkdir(runDir, { recursive: true })

  const evidence = {
    tag,
    baseUrl,
    startedAt: new Date().toISOString(),
    roles: [],
  }

  const browser = await chromium.launch({ headless: true })

  try {
    for (const roleDef of roles) {
      const context = roleDef.mobile
        ? await browser.newContext({
            ...devices['iPhone 12'],
            colorScheme: 'dark',
            geolocation: { latitude: 7.4478, longitude: 125.8078 },
            permissions: ['geolocation'],
          })
        : await browser.newContext({ viewport: { width: 1536, height: 864 }, colorScheme: 'dark' })
      const page = await context.newPage()

      try {
        await login(page, roleDef.username, password)
        if (roleDef.role === 'guard') {
          await simulateGuard(page, evidence)
        } else {
          await simulateElevated(page, roleDef.role, evidence)
        }
      } catch (error) {
        evidence.roles.push({
          role: roleDef.role,
          steps: ['simulation_failed'],
          error: error instanceof Error ? error.message : String(error),
          consoleErrors: [],
          apiErrors: [],
        })
        await capture(page, `${roleDef.role}-error.png`).catch(() => {})
      } finally {
        await context.close()
      }
    }
  } finally {
    await browser.close()
  }

  evidence.finishedAt = new Date().toISOString()
  const reportPath = path.join(runDir, 'report.json')
  await fs.writeFile(reportPath, `${JSON.stringify(evidence, null, 2)}\n`, 'utf8')

  console.log(`Live one-day simulation completed. Evidence: ${runDir}`)
}

main().catch((error) => {
  console.error(error)
  process.exitCode = 1
})
