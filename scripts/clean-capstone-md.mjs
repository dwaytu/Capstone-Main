import fs from 'node:fs/promises'
import path from 'node:path'

const ROOT = process.cwd()
const SOURCE_MD = path.join(ROOT, 'SENTINEL - Group 8.md')
const EXTRACTED_IMAGE_DIR = path.join(ROOT, 'tmp', 'docx_clean')
const TARGET_IMAGE_DIR = path.join(ROOT, 'docs', 'capstone', 'paper-media')

function naturalImageSort(a, b) {
  const aNum = Number.parseInt(a.name, 10)
  const bNum = Number.parseInt(b.name, 10)
  if (Number.isNaN(aNum) && Number.isNaN(bNum)) return a.name.localeCompare(b.name)
  if (Number.isNaN(aNum)) return 1
  if (Number.isNaN(bNum)) return -1
  return aNum - bNum
}

async function loadImageInventory() {
  const entries = await fs.readdir(EXTRACTED_IMAGE_DIR, { withFileTypes: true })
  const files = entries
    .filter((entry) => entry.isFile() && /^\d+\.(png|jpe?g)$/i.test(entry.name))
    .sort(naturalImageSort)
    .map((entry, index) => {
      const ext = path.extname(entry.name).toLowerCase()
      const newName = `img-${String(index + 1).padStart(2, '0')}${ext}`
      return {
        source: path.join(EXTRACTED_IMAGE_DIR, entry.name),
        target: path.join(TARGET_IMAGE_DIR, newName),
        markdownPath: `docs/capstone/paper-media/${newName}`,
      }
    })

  return files
}

async function ensureMediaFiles(images) {
  await fs.mkdir(TARGET_IMAGE_DIR, { recursive: true })
  await Promise.all(
    images.map((image) => fs.copyFile(image.source, image.target)),
  )
}

function normalizeMarkdown(text, images) {
  let output = text
  let imageCursor = 0

  output = output.replace(/<a id="[^"]+"><\/a>/g, '')

  output = output.replace(
    /!\[([^\]]*)\]\(data:image\/[a-zA-Z0-9+.-]+;base64,[^)]+\)/g,
    (_, altText) => {
      const image = images[imageCursor]
      if (!image) return `![${altText}](image-missing-${imageCursor + 1})`
      imageCursor += 1
      return `![${altText}](${image.markdownPath})`
    },
  )

  output = output.replace(/^\[(.+?)\]\(#_Toc[^\)]+\)\s*$/gm, '$1')

  output = output.replace(/__([^_\n]+?)__/g, '**$1**')
  output = output.replace(/\\([.\-(),:;!?])/g, '$1')
  output = output.replace(/[ \t]+$/gm, '')
  output = output.replace(/\t/g, '    ')
  output = output.replace(/\n{3,}/g, '\n\n')

  if (!output.endsWith('\n')) {
    output += '\n'
  }

  return { output, replacedImages: imageCursor }
}

async function main() {
  const markdown = await fs.readFile(SOURCE_MD, 'utf8')
  const images = await loadImageInventory()
  await ensureMediaFiles(images)

  const { output, replacedImages } = normalizeMarkdown(markdown, images)
  await fs.writeFile(SOURCE_MD, output, 'utf8')

  console.log(`Cleaned markdown: ${SOURCE_MD}`)
  console.log(`Media assets copied: ${images.length}`)
  console.log(`Inline base64 images replaced: ${replacedImages}`)
  if (replacedImages !== images.length) {
    console.log('Note: image counts differ between markdown and extracted assets; review figure bindings.')
  }
}

main().catch((error) => {
  console.error(error)
  process.exitCode = 1
})

