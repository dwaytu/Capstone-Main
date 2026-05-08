import fs from 'node:fs';
import path from 'node:path';

const specPath = path.resolve('docs/diagrams/activity/activity-diagrams-spec.json');
const outDir = path.resolve('docs/diagrams/activity');
const spec = JSON.parse(fs.readFileSync(specPath, 'utf8'));

const laneWidth = 320;
const marginX = 40;
const topPad = 120;
const rowGap = 125;
const nodeW = 250;
const nodeH = 62;
const decisionW = 190;
const decisionH = 90;

function esc(s) {
  return String(s)
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;');
}

function wrap(text, max = 32) {
  const words = text.split(' ');
  const lines = [];
  let line = '';
  for (const w of words) {
    if ((line + ' ' + w).trim().length > max) {
      if (line) lines.push(line.trim());
      line = w;
    } else {
      line += ` ${w}`;
    }
  }
  if (line.trim()) lines.push(line.trim());
  return lines;
}

function nodeCenter(step, idx) {
  const x = marginX + laneWidth * step.lane + laneWidth / 2;
  const y = topPad + idx * rowGap;
  return { x, y };
}

function shape(step, idx) {
  const { x, y } = nodeCenter(step, idx);
  if (step.type === 'start' || step.type === 'end') {
    return { cx: x, cy: y, kind: step.type };
  }
  if (step.type === 'decision') {
    return { cx: x, cy: y, w: decisionW, h: decisionH, kind: 'decision' };
  }
  return { cx: x, cy: y, w: nodeW, h: nodeH, kind: 'process' };
}

function topAnchor(sh) {
  if (sh.kind === 'start' || sh.kind === 'end') return { x: sh.cx, y: sh.cy - 15 };
  return { x: sh.cx, y: sh.cy - sh.h / 2 };
}

function bottomAnchor(sh) {
  if (sh.kind === 'start' || sh.kind === 'end') return { x: sh.cx, y: sh.cy + 15 };
  return { x: sh.cx, y: sh.cy + sh.h / 2 };
}

function rightAnchor(sh) {
  if (sh.kind === 'start' || sh.kind === 'end') return { x: sh.cx + 15, y: sh.cy };
  return { x: sh.cx + sh.w / 2, y: sh.cy };
}

for (const diagram of spec.diagrams) {
  const steps = diagram.steps;
  const laneCount = spec.lanes.length;
  const width = marginX * 2 + laneCount * laneWidth;
  const height = topPad + steps.length * rowGap + 120;

  const positions = new Map();
  steps.forEach((s, i) => positions.set(s.id, { ...shape(s, i), idx: i, step: s }));

  let svg = '';
  svg += `<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"${width}\" height=\"${height}\" viewBox=\"0 0 ${width} ${height}\">\n`;
  svg += `<defs>\n`;
  svg += `<marker id=\"arrow\" markerWidth=\"10\" markerHeight=\"7\" refX=\"9\" refY=\"3.5\" orient=\"auto\">`;
  svg += `<polygon points=\"0 0, 10 3.5, 0 7\" fill=\"#1f2937\"/></marker>\n`;
  svg += `</defs>\n`;
  svg += `<rect x=\"0\" y=\"0\" width=\"${width}\" height=\"${height}\" fill=\"#f8fafc\"/>\n`;
  svg += `<text x=\"${width / 2}\" y=\"36\" text-anchor=\"middle\" font-family=\"Arial\" font-size=\"20\" font-weight=\"700\" fill=\"#0f172a\">${esc(diagram.title)}</text>\n`;

  for (let i = 0; i < laneCount; i++) {
    const x = marginX + i * laneWidth;
    const fill = i % 2 === 0 ? '#ffffff' : '#f1f5f9';
    svg += `<rect x=\"${x}\" y=\"56\" width=\"${laneWidth}\" height=\"${height - 70}\" fill=\"${fill}\" stroke=\"#cbd5e1\"/>\n`;
    svg += `<text x=\"${x + laneWidth / 2}\" y=\"84\" text-anchor=\"middle\" font-family=\"Arial\" font-size=\"13\" font-weight=\"700\" fill=\"#0f172a\">${esc(spec.lanes[i])}</text>\n`;
  }

  const edge = (from, to, label = '', mode = 'vertical') => {
    const a = bottomAnchor(from);
    const b = topAnchor(to);
    if (mode === 'branch') {
      const r = rightAnchor(from);
      const m1x = r.x + 70;
      const m1y = r.y;
      const m2x = m1x;
      const m2y = b.y - 10;
      svg += `<path d=\"M ${r.x} ${r.y} L ${m1x} ${m1y} L ${m2x} ${m2y} L ${b.x} ${b.y}\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"1.6\" marker-end=\"url(#arrow)\"/>\n`;
      if (label) {
        svg += `<text x=\"${r.x + 28}\" y=\"${r.y - 8}\" font-family=\"Arial\" font-size=\"11\" font-weight=\"700\" fill=\"#7c2d12\">${esc(label)}</text>\n`;
      }
      return;
    }
    svg += `<path d=\"M ${a.x} ${a.y} L ${b.x} ${b.y}\" fill=\"none\" stroke=\"#1f2937\" stroke-width=\"1.6\" marker-end=\"url(#arrow)\"/>\n`;
    if (label) {
      svg += `<text x=\"${a.x + 10}\" y=\"${(a.y + b.y) / 2 - 6}\" font-family=\"Arial\" font-size=\"11\" font-weight=\"700\" fill=\"#065f46\">${esc(label)}</text>\n`;
    }
  };

  for (let i = 0; i < steps.length; i++) {
    const s = steps[i];
    const sh = positions.get(s.id);
    if (sh.kind === 'start') {
      svg += `<circle cx=\"${sh.cx}\" cy=\"${sh.cy}\" r=\"12\" fill=\"#111827\"/>\n`;
    } else if (sh.kind === 'end') {
      svg += `<circle cx=\"${sh.cx}\" cy=\"${sh.cy}\" r=\"14\" fill=\"#ffffff\" stroke=\"#111827\" stroke-width=\"2\"/>\n`;
      svg += `<circle cx=\"${sh.cx}\" cy=\"${sh.cy}\" r=\"8\" fill=\"#111827\"/>\n`;
    } else if (sh.kind === 'decision') {
      const x = sh.cx, y = sh.cy, w = sh.w / 2, h = sh.h / 2;
      svg += `<polygon points=\"${x},${y - h} ${x + w},${y} ${x},${y + h} ${x - w},${y}\" fill=\"#fef3c7\" stroke=\"#1f2937\" stroke-width=\"1.5\"/>\n`;
    } else {
      svg += `<rect x=\"${sh.cx - sh.w / 2}\" y=\"${sh.cy - sh.h / 2}\" rx=\"10\" ry=\"10\" width=\"${sh.w}\" height=\"${sh.h}\" fill=\"#ffffff\" stroke=\"#1f2937\" stroke-width=\"1.5\"/>\n`;
    }

    if (sh.kind !== 'start' && sh.kind !== 'end') {
      const lines = wrap(s.label, sh.kind === 'decision' ? 24 : 30);
      lines.forEach((line, li) => {
        const y = sh.cy - ((lines.length - 1) * 14) / 2 + li * 14;
        svg += `<text x=\"${sh.cx}\" y=\"${y}\" text-anchor=\"middle\" font-family=\"Arial\" font-size=\"11\" fill=\"#111827\">${esc(line)}</text>\n`;
      });
    } else {
      svg += `<text x=\"${sh.cx + 20}\" y=\"${sh.cy + 4}\" font-family=\"Arial\" font-size=\"11\" fill=\"#111827\">${esc(s.label)}</text>\n`;
    }

    if (i < steps.length - 1) {
      const next = positions.get(steps[i + 1].id);
      edge(sh, next, s.type === 'decision' ? 'Yes' : '', 'vertical');
    }

    if (s.type === 'decision' && s.no) {
      const branch = s.no;
      const bId = `${s.id}__NO`;
      const main = positions.get(s.id);
      const by = main.cy;
      const bx = marginX + laneWidth * Math.min(branch.lane + 0.85, 3.7);
      const bw = 210;
      const bh = 56;
      const temp = { cx: bx, cy: by, w: bw, h: bh, kind: 'process' };
      svg += `<rect x=\"${bx - bw / 2}\" y=\"${by - bh / 2}\" rx=\"9\" ry=\"9\" width=\"${bw}\" height=\"${bh}\" fill=\"#fff7ed\" stroke=\"#9a3412\" stroke-width=\"1.2\"/>\n`;
      const blines = wrap(branch.label, 27);
      blines.forEach((line, li) => {
        const y = by - ((blines.length - 1) * 13) / 2 + li * 13;
        svg += `<text x=\"${bx}\" y=\"${y}\" text-anchor=\"middle\" font-family=\"Arial\" font-size=\"10.5\" fill=\"#7c2d12\">${esc(line)}</text>\n`;
      });
      edge(main, temp, 'No', 'branch');

      const target = positions.get(branch.loopTo);
      if (target) {
        const ta = topAnchor(target);
        const from = bottomAnchor(temp);
        const x1 = from.x;
        const y1 = from.y;
        const x2 = x1;
        const y2 = ta.y - 8;
        svg += `<path d=\"M ${x1} ${y1} L ${x2} ${y2} L ${ta.x} ${ta.y}\" fill=\"none\" stroke=\"#9a3412\" stroke-width=\"1.2\" stroke-dasharray=\"5,4\" marker-end=\"url(#arrow)\"/>\n`;
      }
    }
  }

  svg += `</svg>\n`;
  fs.writeFileSync(path.join(outDir, `${diagram.slug}.svg`), svg, 'utf8');
}

console.log(`Generated ${spec.diagrams.length} activity diagram SVG files in ${outDir}`);
