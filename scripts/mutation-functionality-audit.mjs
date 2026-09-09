import fs from 'node:fs/promises'
import path from 'node:path'
import { createRequire } from 'node:module'
import { fileURLToPath } from 'node:url'

const scriptDir = path.dirname(fileURLToPath(import.meta.url))
const root = path.resolve(scriptDir, '..')
const frontendRequire = createRequire(path.join(root, 'DasiaAIO-Frontend', 'package.json'))
const { chromium } = frontendRequire('playwright')
const XLSX = frontendRequire('xlsx')

const webBaseUrl = process.env.MUTATION_WEB_URL || 'http://127.0.0.1:5174'
const apiBaseUrl = process.env.MUTATION_API_URL || 'http://127.0.0.1:5001'
const password = process.env.MUTATION_PASSWORD || 'password123'
const artifactDir = path.join(root, 'output', 'mutation-audit')
const tag = `MUTATION-${new Date().toISOString().replace(/[-:.TZ]/g, '').slice(0, 14)}`

const fixture = {
  guardId: '0a1b2c3d-4e5f-6789-abcd-ef0123456789',
  guardUsername: 'aaa_mutation_guard_20260819',
  siteName: 'oogabooga',
  firearmId: '4e8d7c2b-1a09-4f6e-b5c4-3d2e1f0a9b87',
  pendingUserId: '7b1a0f9e-4d32-4c8f-e7a6-5b4c3d2e1f09',
}

const results = []

function record(name, status, details = {}) {
  const entry = { name, status, ...details }
  results.push(entry)
  console.log(`[${status}] ${name}${details.message ? `: ${details.message}` : ''}`)
  return entry
}

async function parseResponse(response) {
  const text = await response.text()
  if (!text) return null
  try {
    return JSON.parse(text)
  } catch {
    return text
  }
}

async function apiLogin(identifier) {
  const response = await fetch(`${apiBaseUrl}/api/login`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ identifier, password }),
  })
  const body = await parseResponse(response)
  if (!response.ok) throw new Error(`Login ${identifier} failed (${response.status}): ${JSON.stringify(body)}`)
  return body
}

async function apiRequest(token, pathname, options = {}) {
  const headers = {
    Accept: 'application/json',
    Authorization: `Bearer ${token}`,
    ...(options.body ? { 'Content-Type': 'application/json' } : {}),
    ...(options.headers || {}),
  }
  const response = await fetch(`${apiBaseUrl}${pathname}`, { ...options, headers })
  const body = await parseResponse(response)
  return { response, body }
}

function localDateTimeInput(date) {
  const pad = (value) => String(value).padStart(2, '0')
  return {
    date: `${date.getFullYear()}-${pad(date.getMonth() + 1)}-${pad(date.getDate())}`,
    time: `${pad(date.getHours())}:${pad(date.getMinutes())}`,
  }
}

async function loginPage(page, identifier) {
  await page.goto(`${webBaseUrl}/login`, { waitUntil: 'domcontentloaded' })
  await page.locator('#identifier, input[name="identifier"], input[autocomplete="username"], input[type="email"]').first().fill(identifier)
  await page.locator('#password, input[type="password"]').first().fill(password)
  await page.getByRole('button', { name: /^login$/i }).click()
  await page.waitForTimeout(1800)
  if (page.url().includes('/login')) {
    const alert = (await page.locator('[role="alert"]').allTextContents()).join(' | ')
    throw new Error(`login did not complete for ${identifier}${alert ? `: ${alert}` : ''}`)
  }
}

function attachPageDiagnostics(page, role, diagnostics) {
  page.on('pageerror', (error) => diagnostics.pageErrors.push(`${role}: ${error.message}`))
  page.on('console', (message) => {
    if (message.type() === 'error') diagnostics.consoleErrors.push(`${role}: ${message.text()}`)
  })
  page.on('response', (response) => {
    if (response.status() >= 400 && response.url().includes('/api/')) {
      diagnostics.apiErrors.push(`${role}: ${response.status()} ${response.url()}`)
    }
  })
}

async function requireMutationResponse(page, pathname, method, action) {
  const responsePromise = page.waitForResponse(
    (response) => response.url().includes(pathname) && response.request().method() === method,
    { timeout: 15000 },
  )
  await action()
  const response = await responsePromise
  const body = await parseResponse(response)
  if (!response.ok()) throw new Error(`${action} ${pathname} returned ${response.status()}: ${JSON.stringify(body)}`)
  return body
}

async function runScheduleAndAttendance(superadmin, guard, site, diagnostics) {
  const superPage = await superadmin.newPage()
  attachPageDiagnostics(superPage, 'superadmin', diagnostics)
  await loginPage(superPage, 'superadmin')
  await superPage.goto(`${webBaseUrl}/schedule`, { waitUntil: 'domcontentloaded' })
  await superPage.getByRole('button', { name: /add schedule/i }).first().click()

  const form = superPage.locator('form').filter({ has: superPage.locator('#schedule-guard') }).first()
  await form.locator('#schedule-guard').selectOption(fixture.guardId)
  await form.locator('select').nth(1).selectOption({ label: site.name })

  const now = new Date()
  const start = new Date(now.getTime() - 5 * 60 * 1000)
  const end = new Date(now.getTime() + 45 * 60 * 1000)
  const startInput = localDateTimeInput(start)
  const endInput = localDateTimeInput(end)
  await form.locator('input[type="date"]').fill(startInput.date)
  await form.locator('input[type="time"]').nth(0).fill(startInput.time)
  await form.locator('input[type="time"]').nth(1).fill(endInput.time)

  let createdShift
  try {
    createdShift = await requireMutationResponse(
      superPage,
      '/api/guard-replacement/shifts',
      'POST',
      () => superPage.getByRole('button', { name: /^create schedule$/i }).click(),
    )
    record('schedule creation via UI', 'PASS', { shiftId: createdShift.shiftId })
  } catch (error) {
    record('schedule creation via UI', 'FAIL', { message: error.message })
    await superPage.close()
    throw error
  }

  const guardPage = await guard.newPage()
  attachPageDiagnostics(guardPage, 'guard', diagnostics)
  await loginPage(guardPage, fixture.guardUsername)
  await guardPage.goto(`${webBaseUrl}/overview`, { waitUntil: 'domcontentloaded' })

  try {
    const agreeButton = guardPage.getByRole('button', { name: /agree and continue/i }).first()
    if (await agreeButton.isVisible().catch(() => false)) {
      await guardPage.locator('#toa-agree').check()
      await guardPage.locator('#location-consent').check()
      await agreeButton.click()
      await guardPage.waitForTimeout(500)
    }
    const checkInButton = guardPage.getByRole('button', { name: /check in.*start shift/i }).first()
    await checkInButton.waitFor({ state: 'visible', timeout: 15000 })
    await requireMutationResponse(
      guardPage,
      '/api/guard-replacement/attendance/check-in',
      'POST',
      () => checkInButton.click(),
    )
    await guardPage.getByText(/checked in successfully/i).waitFor({ timeout: 5000 })
    await guardPage.waitForTimeout(1500)
    record('attendance check-in via UI', 'PASS', { shiftId: createdShift.shiftId })
  } catch (error) {
    await guardPage.screenshot({ path: path.join(artifactDir, `${tag}-attendance-check-in-failure.png`), fullPage: true }).catch(() => {})
    console.log(`Guard page URL during check-in failure: ${guardPage.url()}`)
    console.log(`Guard page buttons: ${(await guardPage.getByRole('button').allTextContents()).slice(0, 20).join(' | ')}`)
    record('attendance check-in via UI', 'FAIL', { message: error.message })
    throw error
  }

  try {
    await requireMutationResponse(
      guardPage,
      '/api/guard-replacement/attendance/check-out',
      'POST',
      () => guardPage.getByRole('button', { name: /check out.*end shift/i }).first().click(),
    )
    await guardPage.getByText(/checked out successfully/i).waitFor({ timeout: 5000 })
    record('attendance check-out via UI', 'PASS', { shiftId: createdShift.shiftId })
  } catch (error) {
    record('attendance check-out via UI', 'FAIL', { message: error.message })
    throw error
  }

  return { shiftId: createdShift.shiftId, guardPage, superPage }
}

async function runIncident(guardPage) {
  await guardPage.goto(`${webBaseUrl}/overview`, { waitUntil: 'domcontentloaded' })
  await guardPage.getByRole('button', { name: /report incident/i }).first().click()
  await guardPage.locator('#incident-description').fill(`${tag} incident submission test`)
  await guardPage.locator('#incident-priority').selectOption('medium')
  await requireMutationResponse(
    guardPage,
    '/api/incidents',
    'POST',
    () => guardPage.getByRole('button', { name: /submit report/i }).click(),
  )
  await guardPage.locator('[role="dialog"]').waitFor({ state: 'hidden', timeout: 5000 })
  record('incident submission via UI', 'PASS')
}

async function runSupportTicket(guardPage) {
  await guardPage.goto(`${webBaseUrl}/support`, { waitUntil: 'domcontentloaded' })
  await guardPage.getByRole('button', { name: /new ticket/i }).first().click()
  await guardPage.locator('#ticket-category').selectOption('General')
  await guardPage.locator('#ticket-subject').fill(`${tag} support ticket`)
  await guardPage.locator('#ticket-description').fill(`${tag} support request for mutation workflow verification.`)
  await requireMutationResponse(
    guardPage,
    '/api/support-tickets',
    'POST',
    () => guardPage.getByRole('button', { name: /submit ticket/i }).click(),
  )
  await guardPage.getByText(/ticket submitted successfully/i).waitFor({ timeout: 5000 })
  record('support ticket submission via UI', 'PASS')
}

async function runFeedback(guardPage) {
  await guardPage.goto(`${webBaseUrl}/feedback`, { waitUntil: 'domcontentloaded' })
  await guardPage.getByRole('radio', { name: /5 stars/i }).check({ force: true })
  await guardPage.locator('#feedback-comments').fill(`${tag} feedback submission test`)
  await requireMutationResponse(
    guardPage,
    '/api/feedback',
    'POST',
    () => guardPage.getByRole('button', { name: /submit feedback/i }).click(),
  )
  await guardPage.getByText(/feedback.*recorded/i).waitFor({ timeout: 5000 })
  record('feedback submission via UI', 'PASS')
}

async function runApproval(superPage, pendingUserId) {
  await superPage.goto(`${webBaseUrl}/approvals`, { waitUntil: 'domcontentloaded' })
  const row = superPage.locator('tr').filter({ hasText: 'Mutation Pending Guard' }).first()
  await requireMutationResponse(
    superPage,
    `/api/users/${pendingUserId}/approval`,
    'PUT',
    () => row.getByRole('button', { name: /^approve$/i }).click(),
  )
  record('guard approval via UI', 'PASS', { userId: pendingUserId })
}

async function runAllocation(superPage, guardId, firearmId) {
  await superPage.goto(`${webBaseUrl}/allocation`, { waitUntil: 'domcontentloaded' })
  await superPage.getByRole('button', { name: /allocate firearm/i }).first().click()
  const form = superPage.locator('form').filter({ hasText: 'Select a guard' }).first()
  await form.locator('select').nth(0).selectOption(guardId)
  await form.locator('select').nth(1).selectOption(firearmId)
  const body = await requireMutationResponse(
    superPage,
    '/api/firearm-allocation/issue',
    'POST',
    () => form.getByRole('button', { name: /allocate firearm/i }).click(),
  )
  record('firearm allocation via UI', 'PASS', { allocationId: body.allocationId })
  return body.allocationId
}

async function runBrowserContextOnlyMutations(superPage, superToken, allocationId, firearmId) {
  const returnResult = await superPage.evaluate(async ({ apiBaseUrl, token, id }) => {
    const response = await fetch(`${apiBaseUrl}/api/firearm-allocation/return`, {
      method: 'POST',
      headers: { Authorization: `Bearer ${token}`, 'Content-Type': 'application/json' },
      body: JSON.stringify({ allocationId: id }),
    })
    return { status: response.status, body: await response.text() }
  }, { apiBaseUrl, token: superToken, id: allocationId })
  if (returnResult.status < 200 || returnResult.status >= 300) {
    throw new Error(`firearm return returned ${returnResult.status}: ${returnResult.body}`)
  }
  record('firearm return via browser-context API (no UI action exposed)', 'PASS', { allocationId })

  const maintenanceResult = await superPage.evaluate(async ({ apiBaseUrl, token, id }) => {
    const response = await fetch(`${apiBaseUrl}/api/firearm-maintenance/schedule`, {
      method: 'POST',
      headers: { Authorization: `Bearer ${token}`, 'Content-Type': 'application/json' },
      body: JSON.stringify({
        firearmId: id,
        maintenanceType: 'mutation-test',
        description: 'Mutation workflow maintenance test',
        scheduledDate: new Date().toISOString(),
        notes: 'MUTATION-FIXTURE',
      }),
    })
    return { status: response.status, body: await response.text() }
  }, { apiBaseUrl, token: superToken, id: firearmId })
  if (maintenanceResult.status < 200 || maintenanceResult.status >= 300) {
    throw new Error(`maintenance scheduling returned ${maintenanceResult.status}: ${maintenanceResult.body}`)
  }
  const maintenanceBody = JSON.parse(maintenanceResult.body)
  record('firearm maintenance scheduling via browser-context API (no UI action exposed)', 'PASS', { maintenanceId: maintenanceBody.id })

  const completeResult = await superPage.evaluate(async ({ apiBaseUrl, token, id }) => {
    const response = await fetch(`${apiBaseUrl}/api/firearm-maintenance/${id}/complete`, {
      method: 'POST',
      headers: { Authorization: `Bearer ${token}`, 'Content-Type': 'application/json' },
      body: JSON.stringify({ performedBy: 'Mutation QA', notes: 'MUTATION-FIXTURE completed' }),
    })
    return { status: response.status, body: await response.text() }
  }, { apiBaseUrl, token: superToken, id: maintenanceBody.id })
  if (completeResult.status < 200 || completeResult.status >= 300) {
    throw new Error(`maintenance completion returned ${completeResult.status}: ${completeResult.body}`)
  }
  record('firearm maintenance completion via browser-context API (no UI action exposed)', 'PASS', { maintenanceId: maintenanceBody.id })
}

async function createMdrFixture() {
  const rows = Array.from({ length: 9 }, () => [])
  rows[3] = ['MDR AUGUST 2026']
  rows[5] = ['BRANCH: MUTATION TEST']
  rows[8] = ['CLIENT SITES', `${tag} parser fixture`]
  const workbook = XLSX.utils.book_new()
  XLSX.utils.book_append_sheet(workbook, XLSX.utils.aoa_to_sheet(rows), 'Main Roster')
  const filePath = path.join(artifactDir, `${tag}.xlsx`)
  XLSX.writeFile(workbook, filePath)
  return filePath
}

async function runMdr(superPage) {
  const filePath = await createMdrFixture()
  await superPage.goto(`${webBaseUrl}/mdr-import`, { waitUntil: 'domcontentloaded' })
  await superPage.locator('#mdr-file-input').setInputFiles(filePath)
  await superPage.getByText(/workbook parsed successfully/i).waitFor({ timeout: 10000 })
  const responsePromise = superPage.waitForResponse(
    (response) => response.url().endsWith('/api/mdr/import') && response.request().method() === 'POST',
    { timeout: 15000 },
  )
  await superPage.getByRole('button', { name: /upload & process/i }).click()
  const response = await responsePromise
  const body = await parseResponse(response)
  if (!response.ok()) throw new Error(`MDR import returned ${response.status()}: ${JSON.stringify(body)}`)
  const batchId = body.batchId
  await superPage.waitForURL(new RegExp(`/mdr-import/${batchId}$`), { timeout: 10000 })
  await superPage.getByRole('button', { name: /reject batch/i }).click()
  await superPage.getByText(/batch reject succeeded/i).waitFor({ timeout: 5000 })
  record('MDR import and reject via UI', 'PASS', { batchId })
}

async function main() {
  await fs.mkdir(artifactDir, { recursive: true })
  const diagnostics = { pageErrors: [], consoleErrors: [], apiErrors: [] }
  const superLogin = await apiLogin('superadmin')
  const guardLogin = await apiLogin(fixture.guardUsername)
  const siteResponse = await apiRequest(superLogin.token, '/api/tracking/client-sites')
  const sites = Array.isArray(siteResponse.body?.sites) ? siteResponse.body.sites : []
  const site = sites.find((item) => item.name === fixture.siteName) ?? sites[0]
  if (!site) throw new Error('No client site fixture available')

  const browser = await chromium.launch({ headless: true })
  const superContext = await browser.newContext({ viewport: { width: 1536, height: 960 }, colorScheme: 'dark' })
  const guardContext = await browser.newContext({
    viewport: { width: 390, height: 844 },
    colorScheme: 'dark',
    geolocation: { latitude: 7.4478, longitude: 125.8078 },
    permissions: ['geolocation'],
  })

  try {
    const { shiftId, guardPage, superPage } = await runScheduleAndAttendance(superContext, guardContext, site, diagnostics)
    await runIncident(guardPage)
    await runSupportTicket(guardPage)
    await runFeedback(guardPage)
    const allocationId = await runAllocation(superPage, fixture.guardId, fixture.firearmId)
    await runBrowserContextOnlyMutations(superPage, superLogin.token, allocationId, fixture.firearmId)
    await runApproval(superPage, fixture.pendingUserId)
    await runMdr(superPage)

    const report = {
      tag,
      webBaseUrl,
      apiBaseUrl,
      startedAt: new Date().toISOString(),
      results,
      diagnostics,
      trackedIds: { shiftId, allocationId },
    }
    const reportPath = path.join(artifactDir, `${tag}.json`)
    await fs.writeFile(reportPath, `${JSON.stringify(report, null, 2)}\n`, 'utf8')
    console.log(`Mutation audit report: ${reportPath}`)
    if (diagnostics.pageErrors.length || diagnostics.consoleErrors.length || diagnostics.apiErrors.length) {
      console.log(`Diagnostics: page=${diagnostics.pageErrors.length} console=${diagnostics.consoleErrors.length} api=${diagnostics.apiErrors.length}`)
    }
  } finally {
    await superContext.close()
    await guardContext.close()
    await browser.close()
  }
}

main().catch(async (error) => {
  const reportPath = path.join(artifactDir, `${tag}-failed.json`)
  await fs.mkdir(artifactDir, { recursive: true })
  await fs.writeFile(reportPath, `${JSON.stringify({ tag, results, error: error.message }, null, 2)}\n`, 'utf8')
  console.error(error)
  process.exitCode = 1
})
