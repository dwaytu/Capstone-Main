const fs = require('fs')
const path = require('path')

function normalizeVersion(input) {
  const raw = (input || '').toString().trim()
  if (!raw) {
    throw new Error('Release version is required (for example: v1.2.3 or 1.2.3).')
  }

  const normalized = raw.replace(/^v/i, '')
  const match = normalized.match(/^(\d+)\.(\d+)\.(\d+)(?:[-+][0-9A-Za-z.-]+)?$/)
  if (!match) {
    throw new Error(`Invalid release version: ${raw}. Expected semantic version (for example: v1.2.3).`)
  }

  return {
    releaseTag: `v${match[1]}.${match[2]}.${match[3]}`,
    appVersion: `${match[1]}.${match[2]}.${match[3]}`,
    major: Number(match[1]),
    minor: Number(match[2]),
    patch: Number(match[3]),
  }
}

function computeAndroidVersionCode(major, minor, patch) {
  return major * 10000 + minor * 100 + patch
}

function readRootPackageVersion() {
  const packagePath = path.join(__dirname, '..', 'package.json')
  if (!fs.existsSync(packagePath)) {
    return null
  }

  try {
    const packageJson = JSON.parse(fs.readFileSync(packagePath, 'utf8'))
    return typeof packageJson.version === 'string' ? packageJson.version : null
  } catch {
    return null
  }
}

function getVersionInfo(explicitVersion) {
  const sourceVersion = explicitVersion || process.env.RELEASE_VERSION || process.env.GITHUB_REF_NAME || readRootPackageVersion()
  const parsed = normalizeVersion(sourceVersion)

  return {
    sourceVersion,
    releaseTag: parsed.releaseTag,
    appVersion: parsed.appVersion,
    androidVersionCode: computeAndroidVersionCode(parsed.major, parsed.minor, parsed.patch),
  }
}

function parseArgs(argv) {
  const args = { version: null, githubOutputPath: null, envOutputPath: null }

  for (let index = 0; index < argv.length; index += 1) {
    const token = argv[index]
    if (token === '--version') {
      args.version = argv[index + 1] || null
      index += 1
      continue
    }

    if (token === '--github-output') {
      args.githubOutputPath = argv[index + 1] || null
      index += 1
      continue
    }

    if (token === '--env-output') {
      args.envOutputPath = argv[index + 1] || null
      index += 1
      continue
    }
  }

  return args
}

function appendLines(filePath, lines) {
  fs.appendFileSync(filePath, `${lines.join('\n')}\n`, 'utf8')
}

if (require.main === module) {
  try {
    const args = parseArgs(process.argv.slice(2))
    const info = getVersionInfo(args.version)

    if (args.githubOutputPath) {
      appendLines(args.githubOutputPath, [
        `release_tag=${info.releaseTag}`,
        `app_version=${info.appVersion}`,
        `android_version_code=${info.androidVersionCode}`,
      ])
    }

    if (args.envOutputPath) {
      appendLines(args.envOutputPath, [
        `RELEASE_VERSION=${info.releaseTag}`,
        `SENTINEL_APP_VERSION=${info.appVersion}`,
        `SENTINEL_ANDROID_VERSION_CODE=${info.androidVersionCode}`,
      ])
    }

    process.stdout.write(`${JSON.stringify(info, null, 2)}\n`)
  } catch (error) {
    process.stderr.write(`[release-version] ${error.message}\n`)
    process.exit(1)
  }
}

module.exports = {
  normalizeVersion,
  computeAndroidVersionCode,
  getVersionInfo,
}
