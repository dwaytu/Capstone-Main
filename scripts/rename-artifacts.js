const fs = require('fs')
const path = require('path')
const { normalizeVersion } = require('./release-version')

function parseArgs(argv) {
  const args = {
    platform: null,
    version: null,
    input: null,
    outputDir: null,
  }

  for (let index = 0; index < argv.length; index += 1) {
    const token = argv[index]
    if (token === '--platform') {
      args.platform = argv[index + 1] || null
      index += 1
      continue
    }
    if (token === '--version') {
      args.version = argv[index + 1] || null
      index += 1
      continue
    }
    if (token === '--input') {
      args.input = argv[index + 1] || null
      index += 1
      continue
    }
    if (token === '--output-dir') {
      args.outputDir = argv[index + 1] || null
      index += 1
      continue
    }
  }

  if (!args.platform || !args.version || !args.input || !args.outputDir) {
    throw new Error('Usage: node scripts/rename-artifacts.js --platform <web|desktop|android> --version <vX.Y.Z> --input <path> --output-dir <dir>')
  }

  return args
}

function resolveExtension(filePath) {
  const normalized = filePath.toLowerCase()
  if (normalized.endsWith('.tar.gz')) {
    return '.tar.gz'
  }
  return path.extname(filePath)
}

function buildBaseName(platform, normalizedVersion) {
  if (platform === 'web') return `sentinel-web-v${normalizedVersion}`
  if (platform === 'desktop') return `sentinel-desktop-windows-v${normalizedVersion}`
  if (platform === 'android') return `SENTINEL_v${normalizedVersion}`
  throw new Error(`Unsupported platform: ${platform}`)
}

function run() {
  const args = parseArgs(process.argv.slice(2))
  const normalizedVersion = normalizeVersion(args.version).appVersion
  const extension = resolveExtension(args.input)

  const absoluteInput = path.resolve(args.input)
  if (!fs.existsSync(absoluteInput)) {
    throw new Error(`Input artifact not found: ${absoluteInput}`)
  }

  const outputDir = path.resolve(args.outputDir)
  fs.mkdirSync(outputDir, { recursive: true })

  const fileName = `${buildBaseName(args.platform, normalizedVersion)}${extension}`
  const outputPath = path.join(outputDir, fileName)
  fs.copyFileSync(absoluteInput, outputPath)

  process.stdout.write(`${outputPath}\n`)
}

if (require.main === module) {
  try {
    run()
  } catch (error) {
    process.stderr.write(`[rename-artifacts] ${error.message}\n`)
    process.exit(1)
  }
}
