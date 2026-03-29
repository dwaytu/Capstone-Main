const fs = require('fs')
const path = require('path')
const { getVersionInfo } = require('./release-version')

function parseArgs(argv) {
  let version = null
  for (let index = 0; index < argv.length; index += 1) {
    if (argv[index] === '--version') {
      version = argv[index + 1] || null
      index += 1
    }
  }
  return { version }
}

function updateJsonVersion(filePath, appVersion) {
  const absolutePath = path.join(__dirname, '..', filePath)
  const parsed = JSON.parse(fs.readFileSync(absolutePath, 'utf8'))
  parsed.version = appVersion
  fs.writeFileSync(absolutePath, `${JSON.stringify(parsed, null, 2)}\n`, 'utf8')
}

function replaceOrFail(content, search, replacement, description) {
  if (!search.test(content)) {
    throw new Error(`Failed to update ${description}. Pattern not found.`)
  }

  if (search.global || search.sticky) {
    search.lastIndex = 0
  }

  const updated = content.replace(search, replacement)
  return updated
}

function updateTauriCargoVersion(appVersion) {
  const cargoPath = path.join(__dirname, '..', 'apps', 'desktop-tauri', 'src-tauri', 'Cargo.toml')
  const original = fs.readFileSync(cargoPath, 'utf8')
  const packageSectionMatch = original.match(/\[package\][\s\S]*?(?=\n\[|$)/)
  if (!packageSectionMatch) {
    throw new Error('Failed to locate [package] section in Cargo.toml.')
  }

  const packageSection = packageSectionMatch[0]
  const updatedSection = replaceOrFail(
    packageSection,
    /^version\s*=\s*"[^"]+"\r?$/m,
    `version = "${appVersion}"`,
    'Cargo package version line',
  )

  const updated = original.replace(packageSection, updatedSection)
  fs.writeFileSync(cargoPath, updated, 'utf8')
}

function updateFrontendEnvExample(appVersion) {
  const envPath = path.join(__dirname, '..', 'DasiaAIO-Frontend', '.env.example')
  if (!fs.existsSync(envPath)) return

  const original = fs.readFileSync(envPath, 'utf8')
  const updated = replaceOrFail(
    original,
    /^VITE_APP_VERSION=.*$/m,
    `VITE_APP_VERSION=${appVersion}`,
    '.env.example VITE_APP_VERSION',
  )
  fs.writeFileSync(envPath, updated, 'utf8')
}

function updateBackendEnvExample(releaseTag) {
  const envPath = path.join(__dirname, '..', 'DasiaAIO-Backend', '.env.example')
  if (!fs.existsSync(envPath)) return

  const original = fs.readFileSync(envPath, 'utf8')
  const updated = replaceOrFail(
    original,
    /^APP_VERSION=.*$/m,
    `APP_VERSION=${releaseTag}`,
    'backend APP_VERSION',
  )
  fs.writeFileSync(envPath, updated, 'utf8')
}

function run() {
  const args = parseArgs(process.argv.slice(2))
  const versionInfo = getVersionInfo(args.version)

  updateJsonVersion('package.json', versionInfo.appVersion)
  updateJsonVersion(path.join('DasiaAIO-Frontend', 'package.json'), versionInfo.appVersion)
  updateJsonVersion(path.join('apps', 'android-capacitor', 'package.json'), versionInfo.appVersion)
  updateJsonVersion(path.join('apps', 'desktop-tauri', 'package.json'), versionInfo.appVersion)

  const tauriConfigPath = path.join(__dirname, '..', 'apps', 'desktop-tauri', 'src-tauri', 'tauri.conf.json')
  const tauriConfig = JSON.parse(fs.readFileSync(tauriConfigPath, 'utf8'))
  tauriConfig.version = versionInfo.appVersion
  fs.writeFileSync(tauriConfigPath, `${JSON.stringify(tauriConfig, null, 2)}\n`, 'utf8')

  updateTauriCargoVersion(versionInfo.appVersion)
  updateFrontendEnvExample(versionInfo.appVersion)
  updateBackendEnvExample(versionInfo.releaseTag)

  process.stdout.write(`[sync-release-version] synced version ${versionInfo.releaseTag}\n`)
}

if (require.main === module) {
  try {
    run()
  } catch (error) {
    process.stderr.write(`[sync-release-version] ${error.message}\n`)
    process.exit(1)
  }
}
