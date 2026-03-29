const fs = require('fs')
const path = require('path')
const { normalizeVersion } = require('./release-version')

function parseArgs(argv) {
  const args = {
    version: null,
    changelog: path.join(__dirname, '..', 'CHANGELOG.md'),
    output: path.join(__dirname, '..', 'release-notes.md'),
    summaryOutput: null,
  }

  for (let index = 0; index < argv.length; index += 1) {
    const token = argv[index]
    if (token === '--version') {
      args.version = argv[index + 1] || null
      index += 1
      continue
    }
    if (token === '--changelog') {
      args.changelog = argv[index + 1] || args.changelog
      index += 1
      continue
    }
    if (token === '--output') {
      args.output = argv[index + 1] || args.output
      index += 1
      continue
    }
    if (token === '--summary-output') {
      args.summaryOutput = argv[index + 1] || null
      index += 1
      continue
    }
  }

  if (!args.version) {
    throw new Error('Missing required --version argument.')
  }

  return args
}

function findSection(changelogContent, releaseTag) {
  const normalized = normalizeVersion(releaseTag).appVersion
  const lines = changelogContent.split(/\r?\n/)

  const sectionHeader = new RegExp(`^##\\s+\\[?v?${normalized.replace(/\./g, '\\\\.')}\\]?.*$`, 'i')
  let start = lines.findIndex((line) => sectionHeader.test(line.trim()))

  if (start < 0) {
    start = lines.findIndex((line) => /^##\s+/.test(line.trim()))
    if (start < 0) return null
  }

  let end = lines.length
  for (let index = start + 1; index < lines.length; index += 1) {
    if (/^##\s+/.test(lines[index].trim())) {
      end = index
      break
    }
  }

  const sectionLines = lines.slice(start, end)
  if (sectionLines.length === 0) return null

  const [header, ...rest] = sectionLines
  return {
    header,
    body: rest.join('\n').trim(),
  }
}

function buildSummary(sectionBody) {
  if (!sectionBody.trim()) {
    return 'Platform stability and security improvements.'
  }

  const bulletLines = sectionBody
    .split(/\r?\n/)
    .map((line) => line.trim())
    .filter((line) => line.startsWith('- '))
    .slice(0, 3)
    .map((line) => line.replace(/^-\s+/, '').trim())

  if (bulletLines.length > 0) {
    return bulletLines.join(' | ').slice(0, 320)
  }

  return sectionBody.replace(/\s+/g, ' ').trim().slice(0, 320)
}

function run() {
  const args = parseArgs(process.argv.slice(2))
  const normalized = normalizeVersion(args.version)

  if (!fs.existsSync(args.changelog)) {
    throw new Error(`Changelog not found: ${args.changelog}`)
  }

  const changelogContent = fs.readFileSync(args.changelog, 'utf8')
  const section = findSection(changelogContent, normalized.releaseTag)

  const notesBody = section?.body || 'No detailed release notes were provided for this release.'
  const notes = `# SENTINEL ${normalized.releaseTag}\n\n${notesBody.trim()}\n`

  fs.writeFileSync(args.output, notes, 'utf8')

  if (args.summaryOutput) {
    const summary = buildSummary(notesBody)
    fs.writeFileSync(args.summaryOutput, `${summary}\n`, 'utf8')
  }

  process.stdout.write(`[generate-release-notes] wrote ${args.output}\n`)
}

if (require.main === module) {
  try {
    run()
  } catch (error) {
    process.stderr.write(`[generate-release-notes] ${error.message}\n`)
    process.exit(1)
  }
}
