import fs from 'node:fs';
import path from 'node:path';

const specPath = path.resolve('docs/diagrams/activity/activity-diagrams-spec.json');
const outDir = path.resolve('docs/diagrams/activity');
const spec = JSON.parse(fs.readFileSync(specPath, 'utf8'));

const laneWidth = 320;
const laneHeightPadding = 170;
const rowGap = 125;
const topY = 80;

function esc(v = '') {
  return String(v)
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;')
    .replaceAll("'", '&apos;');
}

function makeCell(id, attrs = {}, geometry = null) {
  const attrText = Object.entries(attrs)
    .map(([k, v]) => `${k}="${esc(v)}"`)
    .join(' ');
  if (!geometry) {
    return `    <mxCell id="${id}" ${attrText} />`;
  }
  const geoAttrs = Object.entries(geometry)
    .map(([k, v]) => `${k}="${esc(v)}"`)
    .join(' ');
  return [
    `    <mxCell id="${id}" ${attrText}>`,
    `      <mxGeometry ${geoAttrs} as="geometry" />`,
    `    </mxCell>`
  ].join('\n');
}

function vertexStyle(type) {
  if (type === 'start') {
    return 'ellipse;whiteSpace=wrap;html=1;aspect=fixed;fillColor=#111827;strokeColor=#111827;fontColor=#111827;';
  }
  if (type === 'end') {
    return 'ellipse;whiteSpace=wrap;html=1;aspect=fixed;shape=mxgraph.basic.doubleEllipse;fillColor=#ffffff;strokeColor=#111827;fontColor=#111827;';
  }
  if (type === 'decision') {
    return 'rhombus;whiteSpace=wrap;html=1;fillColor=#fef3c7;strokeColor=#1f2937;fontColor=#111827;';
  }
  return 'rounded=1;whiteSpace=wrap;html=1;fillColor=#ffffff;strokeColor=#1f2937;fontColor=#111827;';
}

function edgeStyle(kind = 'normal') {
  if (kind === 'loop') {
    return 'edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#9a3412;dashed=1;endArrow=block;endFill=1;';
  }
  if (kind === 'no') {
    return 'edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#9a3412;endArrow=block;endFill=1;';
  }
  return 'edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#1f2937;endArrow=block;endFill=1;';
}

for (const diagram of spec.diagrams) {
  let idCounter = 2;
  const nextId = () => String(idCounter++);

  const steps = diagram.steps;
  const laneCount = spec.lanes.length;
  const diagramWidth = laneCount * laneWidth + 60;
  const diagramHeight = topY + steps.length * rowGap + laneHeightPadding;

  const rows = [];
  rows.push('<?xml version="1.0" encoding="UTF-8"?>');
  rows.push(`<mxfile host="app.diagrams.net" modified="${new Date().toISOString()}" agent="Codex" version="24.7.17" type="device">`);
  rows.push(`  <diagram id="${esc(diagram.slug)}" name="${esc(diagram.title)}">`);
  rows.push(`  <mxGraphModel dx="1920" dy="1080" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="${diagramWidth}" pageHeight="${diagramHeight}" math="0" shadow="0">`);
  rows.push('  <root>');
  rows.push('    <mxCell id="0" />');
  rows.push('    <mxCell id="1" parent="0" />');

  const laneIds = [];
  for (let i = 0; i < laneCount; i++) {
    const laneId = nextId();
    laneIds.push(laneId);
    rows.push(
      makeCell(
        laneId,
        {
          value: spec.lanes[i],
          style: 'swimlane;fontStyle=1;childLayout=stackLayout;horizontal=0;startSize=34;horizontalStack=0;resizeParent=0;resizeLast=0;collapsible=0;whiteSpace=wrap;html=1;fillColor=#f8fafc;strokeColor=#94a3b8;',
          vertex: '1',
          parent: '1'
        },
        {
          x: 20 + i * laneWidth,
          y: 50,
          width: laneWidth,
          height: diagramHeight - 90
        }
      )
    );
  }

  const stepCells = new Map();
  for (let i = 0; i < steps.length; i++) {
    const step = steps[i];
    const cellId = nextId();

    let w = 250;
    let h = 62;
    if (step.type === 'decision') {
      w = 180;
      h = 90;
    }
    if (step.type === 'start' || step.type === 'end') {
      w = 30;
      h = 30;
    }

    const x = Math.max(18, Math.floor((laneWidth - w) / 2));
    const y = topY + i * rowGap;

    rows.push(
      makeCell(
        cellId,
        {
          value: step.label,
          style: vertexStyle(step.type),
          vertex: '1',
          parent: laneIds[step.lane]
        },
        { x, y, width: w, height: h }
      )
    );

    stepCells.set(step.id, { cellId, step, x, y, w, h });

    if (step.type === 'decision' && step.no) {
      const n = step.no;
      const noCellId = nextId();
      const noW = 220;
      const noH = 56;
      const nx = Math.max(16, laneWidth - noW - 14);
      const ny = y;
      rows.push(
        makeCell(
          noCellId,
          {
            value: n.label,
            style: 'rounded=1;whiteSpace=wrap;html=1;fillColor=#fff7ed;strokeColor=#9a3412;fontColor=#7c2d12;',
            vertex: '1',
            parent: laneIds[n.lane]
          },
          { x: nx, y: ny, width: noW, height: noH }
        )
      );
      stepCells.set(`${step.id}__NO`, { cellId: noCellId, step: n, x: nx, y: ny, w: noW, h: noH, isNo: true });
    }
  }

  // Main flow edges
  for (let i = 0; i < steps.length - 1; i++) {
    const from = stepCells.get(steps[i].id);
    const to = stepCells.get(steps[i + 1].id);
    const edgeId = nextId();
    const label = steps[i].type === 'decision' ? 'Yes' : '';
    rows.push(
      makeCell(
        edgeId,
        {
          value: label,
          style: edgeStyle('normal'),
          edge: '1',
          parent: '1',
          source: from.cellId,
          target: to.cellId
        },
        { relative: '1' }
      )
    );
  }

  // No branches and loops
  for (const step of steps) {
    if (step.type !== 'decision' || !step.no) continue;
    const noObj = step.no;
    const dec = stepCells.get(step.id);
    const noCell = stepCells.get(`${step.id}__NO`);

    const noEdgeId = nextId();
    rows.push(
      makeCell(
        noEdgeId,
        {
          value: 'No',
          style: edgeStyle('no'),
          edge: '1',
          parent: '1',
          source: dec.cellId,
          target: noCell.cellId
        },
        { relative: '1' }
      )
    );

    if (noObj.loopTo) {
      const loopTarget = stepCells.get(noObj.loopTo);
      if (loopTarget) {
        const loopEdgeId = nextId();
        rows.push(
          makeCell(
            loopEdgeId,
            {
              value: '',
              style: edgeStyle('loop'),
              edge: '1',
              parent: '1',
              source: noCell.cellId,
              target: loopTarget.cellId
            },
            { relative: '1' }
          )
        );
      }
    }
  }

  rows.push('  </root>');
  rows.push('  </mxGraphModel>');
  rows.push('  </diagram>');
  rows.push('</mxfile>');

  const xml = rows.join('\n');
  fs.writeFileSync(path.join(outDir, `${diagram.slug}.drawio`), xml, 'utf8');
}

console.log(`Generated ${spec.diagrams.length} drawio files in ${outDir}`);
