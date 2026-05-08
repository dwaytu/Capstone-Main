import fs from 'node:fs';
import path from 'node:path';

const outDir = path.resolve('docs/diagrams/activity');

const style = {
  start: 'ellipse;whiteSpace=wrap;html=1;fillColor=#111827;strokeColor=#111827;fontColor=#ffffff;',
  end: 'shape=mxgraph.basic.doubleEllipse;whiteSpace=wrap;html=1;fillColor=#ffffff;strokeColor=#111827;fontColor=#111827;',
  process: 'rounded=1;whiteSpace=wrap;html=1;fillColor=#ffffff;strokeColor=#1f2937;fontColor=#111827;',
  decision: 'rhombus;whiteSpace=wrap;html=1;fillColor=#fef3c7;strokeColor=#1f2937;fontColor=#111827;',
  edge: 'edgeStyle=orthogonalEdgeStyle;rounded=1;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#1f2937;endArrow=block;endFill=1;',
  loopEdge: 'edgeStyle=orthogonalEdgeStyle;rounded=1;orthogonalLoop=1;jettySize=auto;html=1;strokeColor=#9a3412;dashed=1;endArrow=block;endFill=1;'
};

function esc(v=''){
  return String(v)
    .replaceAll('&','&amp;')
    .replaceAll('<','&lt;')
    .replaceAll('>','&gt;')
    .replaceAll('"','&quot;')
    .replaceAll("'",'&apos;');
}

function make(diagram) {
  let id = 2;
  const next = ()=> String(id++);
  const nodeIdMap = new Map();
  const lines = [];

  const width = 1200;
  const height = diagram.height;

  lines.push('<?xml version="1.0" encoding="UTF-8"?>');
  lines.push(`<mxfile host="app.diagrams.net" modified="${new Date().toISOString()}" agent="Codex" version="24.7.17" type="device">`);
  lines.push(`  <diagram id="${esc(diagram.slug)}" name="${esc(diagram.title)}">`);
  lines.push(`    <mxGraphModel dx="1920" dy="1080" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="${width}" pageHeight="${height}" math="0" shadow="0">`);
  lines.push('      <root>');
  lines.push('        <mxCell id="0" />');
  lines.push('        <mxCell id="1" parent="0" />');

  // title box
  const titleId = next();
  lines.push(`        <mxCell id="${titleId}" value="${esc(diagram.title)}" style="text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;fontStyle=1;fontSize=18;fontColor=#0f172a;" vertex="1" parent="1">`);
  lines.push('          <mxGeometry x="300" y="10" width="600" height="30" as="geometry" />');
  lines.push('        </mxCell>');

  for (const n of diagram.nodes) {
    const cid = next();
    nodeIdMap.set(n.id, cid);
    const w = n.w ?? (n.type === 'decision' ? 200 : (n.type === 'start' || n.type === 'end' ? 34 : 280));
    const h = n.h ?? (n.type === 'decision' ? 92 : (n.type === 'start' || n.type === 'end' ? 34 : 64));
    const s = style[n.type];
    lines.push(`        <mxCell id="${cid}" value="${esc(n.label)}" style="${s}" vertex="1" parent="1">`);
    lines.push(`          <mxGeometry x="${n.x}" y="${n.y}" width="${w}" height="${h}" as="geometry" />`);
    lines.push('        </mxCell>');
  }

  for (const e of diagram.edges) {
    const cid = next();
    const from = nodeIdMap.get(e.from);
    const to = nodeIdMap.get(e.to);
    const s = e.loop ? style.loopEdge : style.edge;
    lines.push(`        <mxCell id="${cid}" value="${esc(e.label || '')}" style="${s}" edge="1" parent="1" source="${from}" target="${to}">`);
    lines.push('          <mxGeometry relative="1" as="geometry">');
    if (e.points && e.points.length) {
      lines.push('            <Array as="points">');
      for (const p of e.points) {
        lines.push(`              <mxPoint x="${p.x}" y="${p.y}" />`);
      }
      lines.push('            </Array>');
    }
    lines.push('          </mxGeometry>');
    lines.push('        </mxCell>');
  }

  lines.push('      </root>');
  lines.push('    </mxGraphModel>');
  lines.push('  </diagram>');
  lines.push('</mxfile>');

  fs.writeFileSync(path.join(outDir, `${diagram.slug}.drawio`), lines.join('\n'), 'utf8');
}

const diagrams = [
  {
    slug: 'guard-activity-diagram',
    title: 'Figure 8. Guard Activity Diagram',
    height: 1900,
    nodes: [
      {id:'A',type:'start',label:'',x:520,y:70},
      {id:'B',type:'process',label:'Open Login Screen',x:400,y:140},
      {id:'C',type:'process',label:'Enter Guard Credentials',x:400,y:230},
      {id:'D',type:'decision',label:'Credentials Valid?',x:440,y:320},
      {id:'E',type:'process',label:'Display Error Message',x:760,y:330,w:260},
      {id:'F',type:'decision',label:'Account Approved and Policies Accepted?',x:420,y:460,w:240},
      {id:'G',type:'process',label:'Show Approval or Policy Acceptance Prompt',x:760,y:470,w:300},
      {id:'H',type:'process',label:'Complete Required Verification or Acceptance',x:760,y:560,w:300},
      {id:'I',type:'process',label:'Open Guard Dashboard',x:400,y:600},
      {id:'J',type:'process',label:'Review Schedule, Duty Status, and Notifications',x:370,y:690,w:340},
      {id:'K',type:'decision',label:'Shift or Operational Duty Available?',x:420,y:790,w:240},
      {id:'L',type:'process',label:'Review Alerts, Submit Ticket, or Update Profile',x:760,y:800,w:300},
      {id:'M',type:'process',label:'Logout',x:400,y:1600,w:280},
      {id:'N',type:'end',label:'',x:520,y:1680},
      {id:'O',type:'process',label:'Perform Check-In',x:400,y:900},
      {id:'P',type:'decision',label:'Location Consent and Device Access Available?',x:405,y:995,w:270},
      {id:'Q',type:'process',label:'Resolve Consent or Permission Prompt',x:760,y:1005,w:290},
      {id:'R',type:'process',label:'Perform Patrol and Field Duty',x:400,y:1110},
      {id:'S',type:'decision',label:'Incident or Support Needed?',x:430,y:1200,w:220},
      {id:'T',type:'process',label:'Submit Incident, Support Request, or Panic Escalation',x:760,y:1210,w:320},
      {id:'U',type:'process',label:'Continue Duty Monitoring',x:400,y:1320},
      {id:'V',type:'process',label:'Perform Check-Out',x:400,y:1410},
      {id:'W',type:'process',label:'Review Notifications or Remaining Tasks',x:400,y:1500}
    ],
    edges: [
      {from:'A',to:'B'},
      {from:'B',to:'C'},
      {from:'C',to:'D'},
      {from:'D',to:'E',label:'No'},
      {from:'E',to:'C',loop:true,points:[{x:900,y:220}]},
      {from:'D',to:'F',label:'Yes'},
      {from:'F',to:'G',label:'No'},
      {from:'G',to:'H'},
      {from:'H',to:'F',loop:true,points:[{x:910,y:430}]},
      {from:'F',to:'I',label:'Yes'},
      {from:'I',to:'J'},
      {from:'J',to:'K'},
      {from:'K',to:'L',label:'No'},
      {from:'L',to:'M'},
      {from:'K',to:'O',label:'Yes'},
      {from:'O',to:'P'},
      {from:'P',to:'Q',label:'No'},
      {from:'Q',to:'P',loop:true,points:[{x:920,y:940}]},
      {from:'P',to:'R',label:'Yes'},
      {from:'R',to:'S'},
      {from:'S',to:'T',label:'Yes'},
      {from:'T',to:'U'},
      {from:'S',to:'U',label:'No'},
      {from:'U',to:'V'},
      {from:'V',to:'W'},
      {from:'W',to:'M'},
      {from:'M',to:'N'}
    ]
  },
  {
    slug: 'supervisor-activity-diagram',
    title: 'Figure 9. Supervisor Activity Diagram',
    height: 1700,
    nodes: [
      {id:'A',type:'start',label:'',x:520,y:70},
      {id:'B',type:'process',label:'Login as Supervisor',x:400,y:140},
      {id:'C',type:'decision',label:'Credentials, Approval, and Policy State Valid?',x:395,y:235,w:290},
      {id:'D',type:'process',label:'Reject Access or Require Completion of Missing Requirements',x:760,y:250,w:340},
      {id:'E',type:'process',label:'Open Supervisor Dashboard',x:400,y:370},
      {id:'F',type:'process',label:'Review Schedules, Attendance, and Team Status',x:385,y:460,w:310},
      {id:'G',type:'decision',label:'No-Show, Absence, or Coverage Gap Detected?',x:395,y:560,w:290},
      {id:'H',type:'process',label:'Start Replacement Workflow',x:400,y:680},
      {id:'I',type:'process',label:'Identify Available Guard',x:400,y:770},
      {id:'J',type:'process',label:'Assign Replacement and Confirm Deployment',x:385,y:860,w:310},
      {id:'K',type:'process',label:'Update Operational Status',x:400,y:950},
      {id:'L',type:'process',label:'Monitor Alerts, Incidents, and Support Activity',x:375,y:1040,w:330},
      {id:'M',type:'process',label:'Review Live Tracking, Guard History, and Geofence Alerts',x:360,y:1130,w:360},
      {id:'N',type:'decision',label:'Operational Issue Requires Action?',x:420,y:1230,w:240},
      {id:'O',type:'process',label:'Coordinate Corrective Action or Escalation',x:760,y:1240,w:300},
      {id:'P',type:'process',label:'Record Decision and Continue Monitoring',x:400,y:1330},
      {id:'Q',type:'process',label:'Review Performance and Command Summaries',x:390,y:1420,w:300},
      {id:'R',type:'process',label:'Logout',x:400,y:1510},
      {id:'S',type:'end',label:'',x:520,y:1590}
    ],
    edges: [
      {from:'A',to:'B'},
      {from:'B',to:'C'},
      {from:'C',to:'D',label:'No'},
      {from:'D',to:'B',loop:true,points:[{x:930,y:120}]},
      {from:'C',to:'E',label:'Yes'},
      {from:'E',to:'F'},
      {from:'F',to:'G'},
      {from:'G',to:'H',label:'Yes'},
      {from:'H',to:'I'},
      {from:'I',to:'J'},
      {from:'J',to:'K'},
      {from:'K',to:'L'},
      {from:'G',to:'L',label:'No'},
      {from:'L',to:'M'},
      {from:'M',to:'N'},
      {from:'N',to:'O',label:'Yes'},
      {from:'O',to:'P'},
      {from:'N',to:'P',label:'No'},
      {from:'P',to:'Q'},
      {from:'Q',to:'R'},
      {from:'R',to:'S'}
    ]
  },
  {
    slug: 'administrator-activity-diagram',
    title: 'Figure 10. Administrator Activity Diagram',
    height: 1650,
    nodes: [
      {id:'A',type:'start',label:'',x:520,y:70},
      {id:'B',type:'process',label:'Login as Administrator',x:400,y:140},
      {id:'C',type:'decision',label:'Credentials, Approval, and Policy State Valid?',x:395,y:235,w:290},
      {id:'D',type:'process',label:'Reject Access or Require Completion of Missing Requirements',x:760,y:250,w:340},
      {id:'E',type:'process',label:'Open Administrator Dashboard',x:390,y:370,w:300},
      {id:'F',type:'process',label:'Manage Users, Approvals, and Role-Governed Records',x:360,y:460,w:360},
      {id:'G',type:'process',label:'Manage Schedules, Assignments, and Operational Resources',x:350,y:550,w:380},
      {id:'H',type:'process',label:'Manage Firearm, Permit, Vehicle, and Trip Records',x:365,y:640,w:350},
      {id:'I',type:'process',label:'Review Incidents, Support Tickets, and Notifications',x:365,y:730,w:350},
      {id:'J',type:'process',label:'Access Dashboards, Analytics, and Reports',x:390,y:820,w:300},
      {id:'K',type:'decision',label:'Operational or Compliance Issue Found?',x:410,y:920,w:260},
      {id:'L',type:'process',label:'Apply Corrective or Administrative Action',x:760,y:930,w:300},
      {id:'M',type:'process',label:'Validate Updated Records and Status',x:760,y:1020,w:300},
      {id:'N',type:'process',label:'Finalize Current Administrative Tasks',x:400,y:1110,w:280},
      {id:'O',type:'process',label:'Logout',x:400,y:1200},
      {id:'P',type:'end',label:'',x:520,y:1280}
    ],
    edges: [
      {from:'A',to:'B'},
      {from:'B',to:'C'},
      {from:'C',to:'D',label:'No'},
      {from:'D',to:'B',loop:true,points:[{x:930,y:120}]},
      {from:'C',to:'E',label:'Yes'},
      {from:'E',to:'F'},
      {from:'F',to:'G'},
      {from:'G',to:'H'},
      {from:'H',to:'I'},
      {from:'I',to:'J'},
      {from:'J',to:'K'},
      {from:'K',to:'L',label:'Yes'},
      {from:'L',to:'M'},
      {from:'M',to:'I',loop:true,points:[{x:930,y:700}]},
      {from:'K',to:'N',label:'No'},
      {from:'N',to:'O'},
      {from:'O',to:'P'}
    ]
  },
  {
    slug: 'superadmin-activity-diagram',
    title: 'Figure 11. Superadmin Activity Diagram',
    height: 1650,
    nodes: [
      {id:'A',type:'start',label:'',x:520,y:70},
      {id:'B',type:'process',label:'Login as Superadmin',x:400,y:140},
      {id:'C',type:'decision',label:'Credentials, Approval, and Policy State Valid?',x:395,y:235,w:290},
      {id:'D',type:'process',label:'Reject Access or Require Completion of Missing Requirements',x:760,y:250,w:340},
      {id:'E',type:'process',label:'Open Superadmin Command Dashboard',x:380,y:370,w:320},
      {id:'F',type:'process',label:'Review Global KPIs, Service Health, and Command Status',x:360,y:460,w:360},
      {id:'G',type:'process',label:'Manage Roles, Permissions, and Governance Policies',x:365,y:550,w:350},
      {id:'H',type:'process',label:'Review Audit Logs, Forensic Intelligence, and Governance Actions',x:340,y:640,w:400},
      {id:'I',type:'decision',label:'Security, Policy, or Governance Issue Detected?',x:395,y:740,w:290},
      {id:'J',type:'process',label:'Apply Governance, Access, or Policy Updates',x:760,y:750,w:300},
      {id:'K',type:'process',label:'Validate Changes Across Modules and User Roles',x:760,y:840,w:300},
      {id:'L',type:'process',label:'Review Updated Global Status',x:760,y:930,w:300},
      {id:'M',type:'process',label:'Approve Strategic Settings and Oversight Actions',x:360,y:1030,w:360},
      {id:'N',type:'process',label:'Logout',x:400,y:1120},
      {id:'O',type:'end',label:'',x:520,y:1200}
    ],
    edges: [
      {from:'A',to:'B'},
      {from:'B',to:'C'},
      {from:'C',to:'D',label:'No'},
      {from:'D',to:'B',loop:true,points:[{x:930,y:120}]},
      {from:'C',to:'E',label:'Yes'},
      {from:'E',to:'F'},
      {from:'F',to:'G'},
      {from:'G',to:'H'},
      {from:'H',to:'I'},
      {from:'I',to:'J',label:'Yes'},
      {from:'J',to:'K'},
      {from:'K',to:'L'},
      {from:'L',to:'F',loop:true,points:[{x:930,y:430}]},
      {from:'I',to:'M',label:'No'},
      {from:'M',to:'N'},
      {from:'N',to:'O'}
    ]
  }
];

for (const d of diagrams) make(d);
console.log(`Regenerated ${diagrams.length} drawio diagrams.`);
