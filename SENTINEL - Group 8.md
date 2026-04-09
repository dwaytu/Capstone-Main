SENTINEL: AN INTEGRATED SECURITY
OPERATIONS MANAGEMENT SYSTEM FOR
DAVAO SECURITY & INVESTIGATION AGENCY,
INC.

A Capstone Project
Proposal Presented to the Faculty of the
Information and Communications Technology
Program STI College Tagum

In Partial Fulfillment
of the Requirements for the Degree
Bachelor of Science in Information Systems

DWIGHT KARL B. GAGA-A
GAD ABRAHAM M. JOSE
APPLE JOHN D. LUMINGKIT
 HECTOR PHILLIP P. LACIERDA
HANZ LOURENZ FRANK J. RIBU

March 2026



---

ENDORSEMENT FORM FOR PROPOSAL DEFENSE

TITLE OF RESEARCH:

SENTINEL: An Integrated Security Operations
Management System

NAME OF PROPONENTS:

Dwight Karl B. Gaga-a
Gad Abraham M. Jose
Apple John D. Lumingkit
Hector Phillip P. Lacierda
Hanz Lourenz Frank J. Ribu

In Partial Fulfilment of the Requirements
for the degree of Bachelor of Science in Information
System
has been examined and is recommended for Outline Defense.

ENDORSED BY:

Capstone Project Adviser Name
Capstone Project Adviser

APPROVED FOR PROPOSAL DEFENSE:

Capstone Project Coordinator Name
Capstone Project Coordinator

NOTED BY:

Program Head Name
Program Head

Date of Proposal Defense



---

APPROVAL SHEET

This capstone project proposal titled: SENTINEL: An Integrated Security Operations Management System prepared and submitted by
Dwight Karl B. Gaga-a, Gad Abraham M. Jose, Apple John D. Lumingkit, Hector Phillip P. Lacierda, and Hanz Lourenz Frank J. Ribu, in partial fulfillment of the requirements for the
degree of Bachelor of Science in Information Systems, has been examined and is recommended
for acceptance and approval.

Capstone Project Adviser Name
Capstone Project Adviser

Accepted and approved by the Capstone Project Review
Panel in partial fulfillment of the requirements for the degree
of Bachelor of Science in Information Systems

Panel Member Name  Panel Member Name

Panel Member

Panel Member

Lead Panelist Name
Lead Panelist

Noted:

Capstone Project Coordinator Name
Capstone Project Coordinator

Program Head Name
Program Head

Date of Proposal Defense



---

INTRODUCTION

Project Context

This section presents the big-picture context of the study by describing who is affected, what operational problem exists, where it occurs, and why the project is necessary for current agency conditions.

The global private security industry is transitioning toward automated, high-integrity digital ecosystems to address the discovery lag inherent in human-led monitoring. Workforce-capacity research shows that manual, reactive responses to personnel gaps increase vacancy time, which remains a major contributor to security breaches in critical infrastructure environments (Shiyanbola et al., 2023). This transition is also supported by modern performance-management theory, which emphasizes transparent, data-driven tracking as a prerequisite for accountability and for reducing social loafing, where individual reliability declines when oversight is weak or delayed (Aguinis, 2022).

The need for these technological controls is reinforced by Philippine legislation through the Private Security Services Industry Act, or Republic Act No. 11917 (2022). The law formalizes a professional accountability regime in which agencies face strict liability for administrative negligence. Under the law's Implementing Rules and Regulations, agencies may be fined up to P5,000,000 or face license revocation for deploying personnel with expired licenses or unauthorized firearms (Jur.ph, 2025). National studies likewise indicate that absenteeism and post abandonment are more prevalent in agencies that still rely on weak patrol monitoring and manual reporting mechanisms (Abad, 2025).



---

In the Davao Region, Davao Security and Investigation Agency, Inc. operates within a policy environment that actively prioritizes public safety to sustain the city's standing as a regional safe haven (PIA, 2025). The Davao Regional Development Plan 2023-2028 further notes that accelerated economic activity has increased demand for technology-enabled peace-and-order operations, particularly in high-traffic logistics and commercial areas such as Tagum City (NEDA XI, 2024). Local evidence also indicates that compensation, punctuality, and alertness are key determinants of guard performance, yet many agencies continue to experience inattentiveness and post abandonment due to inconsistent manual oversight (Ondos and Origines, 2025). For DASIA Tagum, this creates a direct operational vulnerability: coverage gaps can remain undetected long enough to compromise client safety.

SENTINEL is positioned as an integrated digital ecosystem that addresses these cumulative vulnerabilities by consolidating personnel profiles, firearm telemetry, and shift records into a single operational source of truth. It embeds real-time compliance checks directly into daily workflows. Before deployment, the system verifies license validity and firearm authorization against centralized records. To handle high-concurrency request volume across active personnel, SENTINEL uses Rust and Axum, combining memory safety with asynchronous throughput suitable for mission-critical operations (Scofield, 2025). When an operational gap, such as a missed check-in, is detected, the system flags the vacancy and identifies qualified replacements, enabling a shift from reactive response to proactive, legally defensible security operations.



---

Purpose and Description

This section presents the project purpose and implemented system capabilities.

The primary purpose of this capstone project is to design, implement, and deliver SENTINEL as an integrated security operations and decision-support platform for Davao Security and Investigation Agency, Inc. The study addresses fragmented manual oversight by consolidating core operational processes into a role-governed environment that supports timely command decisions, field coordination, and institutional accountability.

SENTINEL provides unified support for identity and access governance, workforce administration, asset and permit compliance, incident coordination, support and notification workflows, and real-time situational awareness. Role-based and policy-based controls restrict sensitive functions to authorized users and preserve traceable records for institutional review. In the current user-facing product, protected access is administrator-mediated, approval-governed, and policy-gated rather than exposed as open public self-registration through the login experience.

Operationally, the system supports scheduling, attendance, no-show detection, replacement handling, and role-specific dashboard workflows to sustain deployment continuity. For field use, the implemented guard experience includes check-in and check-out actions, emergency contact access, panic escalation, and selected offline continuity for high-priority actions. SENTINEL also manages firearm and vehicle lifecycles, including issuance, return, maintenance, trip visibility, and permit-sensitive checks, to strengthen asset accountability and reduce service disruption. The implemented platform additionally supports Monthly Deployment Report (MDR) ingestion through a staged import, match-and-review workflow, and controlled batch commit or rejection.

At the command level, the platform integrates live tracking signals with structured operational records to provide timely visibility of personnel movement, incident status, deployment conditions, and site-aware activity. Geofence monitoring, notifications, quick Inbox timelines, and incident workflows support faster coordination across command and field roles.

SENTINEL further includes analytics and hybrid AI-assisted decision support for staffing risk, maintenance risk, incident classification, and incident summarization, with deterministic fallback behavior where continuity is required. These outputs are assistive and preserve human authority for final operational decisions.

Security and governance controls are embedded as core functions, including secure session management, legal-policy acceptance gating, audit and forensic logging, rate limiting, and service-health monitoring. Cross-platform delivery across Web, Desktop, and Android maintains consistent behavior and policy enforcement across runtime environments, although some secondary workflows are still delivered through shared dashboard panels, tabs, and shell overlays rather than fully separated standalone pages.



---

Objectives

General Objective

To design, implement, and validate SENTINEL as an integrated, role-governed, multi-platform security operations management system that strengthens workforce continuity, asset accountability, incident coordination, live monitoring, and governance visibility across Web, Desktop, and Android environments.

Specific Objectives

1. Strengthen identity, access, and legal-policy governance for all users.

a. Support account onboarding, identity verification, secure authentication, and password recovery under administrator-governed approval controls.

b. Maintain role-based approval and account-activation controls for operational users.

c. Preserve session continuity, revocation, and first-use legal-policy acceptance with traceable metadata.

2. Operationalize centralized personnel administration and command visibility.

a. Manage personnel records and role assignments for superadmin, administrator, supervisor, and guard.

b. Maintain guard approval queues, approval status tracking, and searchable role-based listings.

c. Surface role-appropriate dashboard views, shared command-shell task access, and quick-action workflows for command and field users.

3. Strengthen scheduling, attendance, and workforce continuity processes.

a. Manage shift schedules and duty assignments with conflict-aware coordination.

b. Capture attendance, check-in/check-out, and presence history with traceable records.

c. Detect no-show events, coordinate replacements, and manage guard availability.

d. Support guard safety escalation and selected offline continuity for critical field actions.

4. Enforce firearm inventory, issuance, and custody accountability.

a. Maintain firearm records, status tracking, and permit-sensitive deployment checks.

b. Record issuance and return activities, active allocations, and overdue custody cases.

c. Track firearm maintenance schedules, pending work, and completion records.

5. Sustain permit and compliance-sensitive deployment management.

a. Maintain permit records, including expiring, valid, and revoked credentials.

b. Apply automated expiry awareness and compliance-sensitive workflow checks.

c. Enforce permit-aware workflows that reduce deployment of non-compliant personnel and assets.

6. Manage armored vehicle fleet and trip operations.

a. Maintain armored vehicle records, allocations, returns, and active-use visibility.

b. Manage driver assignment, driver-vehicle linkage, and trip preparation.

c. Document trip lifecycles from assignment to completion with historical traceability.

d. Track vehicle maintenance schedules, service history, and operational status.

7. Support mission operations and merit-based performance evaluation.

a. Support mission assignment, deployment monitoring, and field instructions review.

b. Generate merit scores and ranked guard results for staffing and supervision decisions.

c. Capture client evaluations, review performance evidence, and identify overtime or replacement candidates.

8. Deliver support, communication, notification, and emergency-escalation services.

a. Provide support ticket submission and role-appropriate case review.

b. Deliver notifications, status tracking, and operational message management.

c. Issue timely alerts for incidents, workflow exceptions, and decision-critical events.

d. Provide a unified role-based action inbox and workflow timeline for prioritized tasks and operational history.

e. Support emergency contact access and panic-incident escalation for guards during field operations.

9. Strengthen incident management and real-time movement intelligence.

a. Support incident recording, active incident monitoring, and status progression.

b. Capture live location points, guard presence signals, and map-linked operational context.

c. Maintain client-site records, shift proximity awareness, and deployment visibility.

d. Support live tracking, path replay, patrol reconstruction, and active roster monitoring.

e. Detect geofence transitions and raise anomaly alerts for leadership review.

f. Expose geofence-driven monitoring outcomes for supervisory review and operational response.

10. Provide analytics, predictive intelligence, and decision support.

a. Present operational overviews, trend indicators, guard reliability insights, and command metrics.

b. Generate predictive alerts for permit expiry, maintenance risk, absenteeism patterns, and staffing capacity risk.

c. Apply hybrid AI assistance for guard absence risk, replacement suggestions, maintenance risk, incident classification, and incident summarization, with deterministic fallback behavior when needed.

11. Enable map-based situational awareness for command and field operations.

a. Visualize guards, routes, vehicles, and client sites through map-based operational displays.

b. Provide continuous live-tracking updates for command monitoring.

c. Support map-linked situational review and proximity-based operational alerts.

12. Institutionalize governance, security, and auditability mechanisms.

a. Maintain audit logs and forensic event records for critical operational actions.

b. Enforce authenticated access, authorization checks, presence monitoring, and session revocation controls.

c. Sustain service readiness and abuse protection through health monitoring, throttling, and rate controls.

d. Preserve authorization-denial and access-failure records for forensic accountability.

e. Provide forensic audit intelligence for filtered timelines, actor-specific reconstruction, and anomaly detection.

13. Implement and validate cross-platform runtime delivery.

a. Deliver a web runtime for browser-based command and operational access.

b. Deliver a desktop runtime through Tauri packaging for command-center deployment.

c. Deliver a mobile runtime through Capacitor Android packaging for field operations.

d. Validate consistent behavior, connectivity, and session governance across Web, Desktop, and Android targets.

e. Enforce controlled release governance and verified Android distribution.

14. Maintain compliant and accessible operational use.

a. Require first-use acceptance of Terms of Agreement, Privacy Policy, and Acceptable Use Policy before protected access.

b. Preserve legal acceptance metadata, including timestamp, policy version, requester IP, and user agent.

c. Maintain accessible, role-appropriate command surfaces for desktop and field use, including readable status presentation and touch-safe critical controls.
---

Scope and Limitations

Scope

The SENTINEL system covers the implemented operational, compliance, and governance requirements of a private security agency within the regulatory context of Republic Act No. 11917 (2022). The scope includes role-governed command and field workflows, centralized operational records, quick-action coordination surfaces, real-time situational monitoring, decision-support outputs, forensic audit visibility, and cross-platform delivery across Web, Desktop, and Android environments.

Data

- Personnel profiles, role and approval data, licensing and permit records, schedules, attendance logs, availability status, merit indicators, and legal-consent records.
- Firearm inventory records, allocations, maintenance history, and permit-compliance data.
- Armored vehicle assets, allocations, driver assignments, trip records, and maintenance history.
- Missions, incidents, support tickets, notifications, predictive alerts, emergency alerts, location records, inbox summaries, workflow history, and audit logs.
- Geofence events, site geofence definitions, movement-history records, forensic activity traces, and anomaly evidence for post-incident review.
- Authentication lockout records, session lifecycle records, and audit source-IP traces for security accountability.
- Release and service-health records required for runtime governance and operational monitoring.

Process

- Account lifecycle workflows, including controlled onboarding, verification, authentication, recovery, and profile maintenance.
- Approval workflows for newly onboarded guard accounts before operational access is granted.
- Role-based dashboards for command monitoring, approvals, analytics, scheduling, audit review, and profile management.
- Desktop command dashboards support adjustable navigation density while preserving usable shell behavior across desktop and mobile form factors.
- Role-based inbox and quick-action workflows for prioritized tasks, approvals, incidents, notifications, asset-related actions, shift issues, and workflow history.
- Mission-first guard workflows for field reporting, attendance actions, instructions review, emergency-contact access, panic escalation, selected offline continuity, and map-supported navigation.
- Shift scheduling, attendance validation, no-show detection, replacement coordination, and supervisor oversight.
- Firearm issuance and return workflows with permit validation, maintenance scheduling, and custody traceability.
- MDR ingestion workflows that stage imported roster rows, apply matching and reviewer resolution, and commit or reject batches with auditable status transitions.
- Vehicle allocation, driver assignment, trip lifecycle management, and preventive and corrective maintenance tracking.
- Incident reporting, emergency escalation, support ticket handling, notification delivery, and live operational monitoring.
- Guard movement reconstruction, including active roster monitoring, historical trail replay, patrol reconstruction, and geofence escalation.
- Audit forensics workflows, including timeline filtering, actor-specific activity reconstruction, anomaly review, and case sequencing.
- Session security workflows, including renewal control, sign-out revocation, and lockout persistence.
- Legal confirmation workflows, including policy review, mandatory acceptance capture, and access gating until accepted.

People

- Superadmin, Administrator, Supervisor, and Guard roles with distinct permissions and dashboard views.

Technology

- Web-based application accessible on desktop and mobile browsers.
- Cross-platform runtime deployment for Web, Desktop (Tauri), and Mobile Android (Capacitor).
- React + TypeScript frontend and Rust + Axum backend services.
- Centralized PostgreSQL database with relational integrity, auditability, and role-based data control.
- Dockerized deployment and service-based architecture with live tracking synchronization, audit telemetry, and governed release packaging.

Limitation of the Study

- The implementation does not include direct integration with external payroll, HR, or government licensing systems.
- Location intelligence is derived from application-generated updates; dedicated hardware telematics is outside the study scope.
- AI-assisted and predictive outputs are assistive and do not replace human command decisions.
- Direct interoperability with third-party security hardware ecosystems (for example CCTV, IoT sensors, and access-control turnstiles) is excluded.
- Field operations remain dependent on device GPS accuracy and network availability; the current implementation provides partial offline queuing for selected high-priority guard actions but does not deliver full offline-first system coverage.
- Native wrapper deployment in this study is limited to Windows desktop and Android; iOS and macOS are excluded.
- Some backend-supported capabilities, such as direct training-record administration and full geofence-zone administration, are not yet exposed through complete end-user command surfaces in the current implementation.
- Some workflows remain consolidated inside shared dashboard panels, tabs, or shell overlays rather than fully separated standalone pages.
---

Review of Related Literature/Studies/Systems

This review synthesizes published evidence and related systems to establish the study foundation, with emphasis on recent and relevant sources that directly support the implemented SENTINEL scope.

Related Literature

The Philippine private security sector is currently navigating its most significant legal

transition  in  over  fifty  years.  The  enactment  of  the  Private  Security  Services  Industry  Act

(Republic  Act  No.  11917,  2022)  effectively  repealed  the  outdated  RA  5487,  shifting  the

industry toward a regime of "Professionalized Accountability." According to Jur.ph (2025),

the law's Implementing Rules and Regulations (IRR) mandate that Private Security Agencies

(PSAs) maintain highly accurate, digitized records of License to Exercise Security Profession

(LESP)  and  firearm  permits.  The  act  introduces  a  "strict  liability"  framework  where

administrative negligence, such as deploying an unlicensed guard, can result in fines ranging

from P50,000 to P100,000 per violation, or up to P5,000,000 for agency-wide license failures.

This  regulatory  pressure  has  necessitated  a  move  toward  Automated  Regulatory

Compliance Tracking (ARCT). Research by Khinvasara, T., Shankar, A., & Wong, C. (2024)

suggests  that  for  organizations  managing  complex,  shifting  rules,  the  use  of  automated

monitoring  is  a  "significant  advancement"  that  eliminates  the  "discovery  lag"  inherent  in

manual  audits.  By  leveraging  system-driven  triggers  for  license  expirations,  PSAs  can

transition from reactive compliance to a proactive stance, ensuring that no personnel or asset

is deployed without valid legal authorization.

Operational continuity in the private security sector is heavily dependent on reliable

guard presence. As identified in the operational risks of DASIA Tagum, "No-Show" incidents

represent a critical vulnerability where manual processes relying on phone calls and delayed

human  intervention  fail  to  address  "discovery  lag."  Research  in  workforce  capacity



---

optimization  emphasizes  that  manual,  reactive  responses  to  workforce  gaps  significantly

increase  "vacancy  time,"  directly  correlating  with  higher  security  breach  probabilities

(Shiyanbola et al., 2023).

Modern  systems  mitigate  this  by  automating  the  identification  and  deployment  of

replacements based on real-time availability, shifting the organizational stance from reactive

crisis  management  to  proactive  risk  mitigation  (Al-Khafajiy  et  al.,  2022).  Furthermore,

advanced algorithms now enable "predictive scheduling," which analyzes historical No-Show

data  to  alert  administrators  of  potential  gaps  before  they  occur,  drastically  reducing  the

operational vacancy time (TrackTik, 2025).

The  transition  from  inconsistent,  manual  tracking  to  a  structured,  data-driven

framework  is  essential  for  maintaining  Distributive  Justice,  the  perceived  fairness  of  how

shifts,  rewards,  and  responsibilities  are  allocated  within  an  organization.  Aguinis  (2022)

posits that the absence of a structured performance management framework leads to "Social

Loafing," a psychological phenomenon where employees decrease effort due to a perceived

lack of individual accountability.

For  security  agencies  like  DASIA  Tagum,  implementing  centralized  performance

metrics such as punctuality and client feedback logs ensures that shift allocation is based on

objective data rather than subjective selection. This transparency not only increases overall

guard reliability but also fosters a culture of accountability, as guards understand that their

performance is directly linked to future opportunities (Tan et al., 2024).



---

The systematic allocation of firearms is a matter of both Chain of Custody (CoC) and

legal necessity under the Private Security Services Industry Act (Republic Act No. 11917,

2022). The law mandates  strict accountability  for firearms,  requiring that  only  authorized,

trained, and compliant guards carry weapons. Manual processes often suffer from "data drift,"

where the status of a weapon and the permit validity of the assigned guard are not reconciled

in  real-time,  leading  to  potential  administrative  negligence.  Centralized  digital  tracking  is

identified as the primary defense against the misallocation of high-risk equipment and is a

prerequisite  for  generating  the  legally  defensible  audit  logs  required  by  the  National

Cybersecurity Plan 2022-2028 (DICT, 2024; PNP-SOSIA, 2022).

The selection of the backend technical stack is a core security decision for mission-

critical systems. Scofield, M. B. (2025) argues that Rust's "ownership and borrowing" model

provides a fundamental architectural advantage: Memory Safety without a Garbage Collector.

This  ensures  that  SENTINEL  is  natively  resistant  to  buffer  overflows  and  data  races,

vulnerabilities  that  often  plague  systems  handling  high-concurrency  data  like  real-time

firearm tracking.

Complementing  the language is  the  Axum framework, which is  built  on  the Tokio

asynchronous  runtime.  As  highlighted  by  NashTech  (2025),  Axum  is  designed  for  high-

performance  web  services  where  scalability  and  raw  speed  are  non-negotiable.  For

SENTINEL, this means the Attendance Tracking and No-Show Detection modules can handle

hundreds  of  simultaneous  "check-in"  requests  during  shift  rotations  without  performance

degradation. This "asynchronous-first" design allows the system to remain responsive even

when processing complex relational logic across personnel, vehicle, and firearm databases.



---

In  an  Integrated  Operations  Platform,  the  database  must  serve  as  the  immutable

"Single  Source  of  Truth."  PostgreSQL  (2025)  is  recognized  as  the  premier  open-source

RDBMS for enterprise planning due to its strict adherence to ACID (Atomicity, Consistency,

Isolation,  Durability)  properties.  Nguyen,  R.  (2025)  emphasizes  that  PostgreSQL's

implementation of Foreign Key Constraints and Unique Exclusion Constraints is the primary

defense against "data drift."

In  the  SENTINEL  ecosystem,  these  constraints  ensure  that  a  firearm  or  armored

vehicle cannot be logically "double-booked" or assigned to a guard who does not exist in the

personnel  table.  This  high  level  of  relational  integrity  is  a  prerequisite  for  generating  the

legally defensible Audit Logs required by the National Cybersecurity Plan 2023-2028 (DICT,

2024), ensuring that every asset movement is tied to a verifiable digital identity.


---

Related Studies and/or Systems

Empirical  research  confirms  that  automated  oversight  is  a  primary  driver  of

operational integrity. A study by Atlam, H. F., & Yang, Y. (2025) found that organizations

utilizing unified Access Control and Resource Planning (ERP) systems saw a 27% drop in

unauthorized  access  violations  and  reclaimed  36%  of  staff  time  previously  lost  to  manual

verification. These findings suggest that hardwiring compliance into the system architecture,

rather than treating it as an afterthought,  tightens process  integrity  and  reduces the  risk of

internal data tampering.

Furthermore,  research  by  Shiyanbola,  J.  O.,  et  al.  (2023)  on  "Workforce  Capacity

Optimization"  highlights  a  flaw  in  traditional  security:  "discovery  lag."  This  occurs  when

supervisors only identify a personnel gap after a shift has failed. Their study demonstrates

that real-time, asynchronous detection models allow for a proactive 11.8% improvement in

site coverage reliability. Locally, ResearchGate (2025) cites a study by Respicio (2023) which

found  that  Philippine  security  guards  operating  under  digital  monitoring  exhibited

significantly  higher  levels  of  alertness  and  punctuality  because  the  system  provided  a

transparent,  inescapable  layer  of  accountability  that  manual  logs  could  not  match.  The

functional  blueprint  of  SENTINEL  is  informed  by  the  performance  of  several  industry-

leading platforms such as TrackTik and Guardhouse.



---

TrackTik

Figure 1. TrackTik

TrackTik  (2025)  has  redefined  security  workforce  management  by  moving  beyond

static  scheduling  toward  an  integrated,  AI-driven  operational  model.  According  to  the

Trackforce 2025 Physical Security Operations Benchmark Report, the industry is currently

facing an "AI adoption paradox" where the value of predictive scheduling is recognized, but

cost  remains a barrier for mid-sized firms.  TrackTik's success  is  anchored in  its  ability to

consolidate alarm monitoring, guard dispatch, and business administration into a single 24/7

resilient  architecture,  which  users  report  has

increased  operational  efficiency  by

approximately  20%.  This  efficiency  is  primarily  attributed  to  the  reduction  of  manual

administrative  burdens  through  automated  compliance  tracking  and  real-time  intelligence



---

Guardhouse

Figure 2. Guardhouse

Guardhouse  (2026),  in  contrast,  is  engineered  around  a  model  of  "Administrative

Compression," where the goal is to streamline repetitive workflow to minimize cognitive load

on  supervisors.  NODE  Magazine  (2026)  reports  that  this  platform  architecture  has  been

associated with a 17% reduction in daily administrative overhead for medium-sized security

firms. Its key differentiator lies in role-sensitive interface segmentation, where each user class

(admin, supervisor, guard) is assigned a curated operational dashboard to avoid role confusion

and cross-functional task spillover.

In a legal context, Guardhouse's verification workflows align with the compliance intent

of Republic Act No. 11917 by reducing undocumented assignment overrides and unvalidated

personnel deployment. According to GetApp (2026), agencies using this model reported better

audit-readiness due to centralized event logging and role-bound authorization structures.



---

MySecuritas

Figure 3. MySecuritas

MySecuritas  (2026)  demonstrates  how  integrated  digital  supervision  can  influence

human behavior in security operations. According to Securitas Technology (2025), platforms

with embedded patrol validation and incident transparency contribute to measurable increases

in guard punctuality and post adherence. This aligns with findings from Respicio (2023), cited

via ResearchGate (2025), where guards under digitally monitored deployment showed higher

behavioral discipline due to increased traceability.

From  an  operational  psychology  standpoint,  this  supports  Expectancy  Theory,  where

employees increase effort when they perceive that performance outcomes are visible and fairly

evaluated  (Aguinis,  2022).  For  SENTINEL,  this  principle  validates  the  inclusion  of

attendance-led  merit  scoring  and  alert-based  accountability  as  core  mechanisms  for

maintaining reliable field presence.



---

Silvertrac Software

Figure 4. Silvertrac Software

Silvertrac  Software  (2026)  is  recognized  for  strong  Incident-Centric  Reporting

frameworks,  particularly  in  mobile  guard  workflows  for  patrol  logs,  activity  reports,  and

exception handling. While effective for event documentation, Hardcat (2025) notes that many

incident-first systems underperform in complex asset governance, particularly for weapons and

high-risk equipment requiring strict chain-of-custody controls.

This gap is critical for Philippine PSAs operating under RA 11917, where legal exposure

extends beyond incident response into pre-incident compliance, such as firearm eligibility and

assignment validation. SENTINEL addresses this by integrating firearm permit compliance and

asset allocation controls directly into operational workflows rather than treating them as isolated

back-office processes.



---

The  collective  literature  establishes  a  clear  strategic  pattern:  modern  security

operations require systems that fuse compliance intelligence, workforce continuity, and real-

time decision support. Existing platforms provide valuable modular solutions, but most remain

domain-specific and do not fully align with the legal, operational, and accountability demands

faced by local PSAs under the current Philippine regulatory framework.

Thus,  the  identified  gap  is  not  the  absence  of  digital  tools,  but  the  absence  of  an

integrated, legally synchronized, and operationally predictive system that combines personnel

management, high-risk asset governance, and responsive incident intelligence in one coherent

architecture. SENTINEL is designed to fill this gap by consolidating these capabilities into a

single compliance-aware operational platform tailored to DASIA Tagum's real-world context.



---

REFERENCES

Abad,  R.  (2025).  How  Effective  Is  Your  Security  Guard?  An  Inquiry  into  the  Philippine

Private

Security

Industry.

Retrieved

from

https://doi.org/10.13140/RG.2.2.30981.41442

Aguinis, H. (2022). Performance Management (5th ed.). SAGE Publications. Retrieved from

https://edge.sagepub.com/aguinispm5e

Al-Khafajiy, M., et al. (2022). Enabling high performance fog computing through fog-2-fog

coordination  model.  Future  Generation  Computer  Systems.  Retrieved  from

https://doi.org/10.1016/j.future.2022.06.012

Atlam,  H.  F.,  &  Yang,  Y.  (2025).  Enhancing  Healthcare  Security:  A  Unified  RBAC  and

ABAC

Risk-Aware

Access

Control

Approach.

Retrieved

from

https://doi.org/10.3390/fi17060262

Department of Information and Communications Technology (DICT). (2024). National

Cybersecurity  Plan  2023-2028:  A  Whole-of-Nation  Roadmap.  Retrieved  from

https://dict.gov.ph/national-cyber-security-plan

GetApp.  (2026).  Guardhouse  2026  Pricing,  Features,  Reviews  &  Alternatives.  Retrieved

from https://www.getapp.com/operations-management-software/a/guardhouse/

Guardhouse.  (2026).  2026  Pricing,  Features,  Reviews  &  Alternatives.  Retrieved  from

https://www.getapp.com/operations-management-software/a/guardhouse/

Hardcat. (2025). Law Enforcement Equipment & Armory Management System: Challenges

in  Managing  Firearms  Securely.  Retrieved  from  https://hardcat.com/police-

equipment-inventory-tracking/

Jur.ph.  (2025).  The  Private  Security  Services  Industry  Act:  Law  Summary  and  IRR.

Retrieved from https://jur.ph/law/summary/the-private-security-services-industry-act



---

Khinvasara,  T.,  Shankar,  A.,  &  Wong,  C.  (2024).  Survey  of  Artificial  Intelligence  for

Automated

Regulatory

Compliance

Tracking.

Retrieved

from

https://doi.org/10.9734/jerr/2024/v26i71217

NashTech.  (2025).  Building  High-Performance  Web  Services  with  Rust  and  Axum.

Retrieved

from  https://blog.nashtechglobal.com/building-high-performance-web-

services-with-rust-and-axum/

NEDA XI. (2024). Davao Regional Development Plan 2023-2028. National Economic and

Development  Authority.  Retrieved  from  https://rdc11.neda.gov.ph/rdc-xi-approves-

davao-regional-development-plan-2023-2028/

Nguyen,  R.  (2025).  PostgreSQL  ACID  In-Depth:  Reliability  and  Consistency  in  Modern

Transactions.  Retrieved  from  https://medium.com/engineering/postgresql-acid-in-

depth

NODE Magazine.  (2026). Why 2026 is the Year Businesses  Must  Finally Address Admin

Overload.  Retrieved  from  https://www.node-magazine.com/thoughtleadership/why-

2026-is-the-year-businesses-must-finally-address-admin-overload

Ondos,  M.  U.,  &  Origines,  D.  V.  (2025).  Android-Based  Guard  Monitoring  and  Site

Surveillance

System.

Retrieved

from

https://www.ojs.udb.ac.id/icohetech/article/view/5657

PIA.  (2025).  Davao  City  Maintains  Top  Safety  Ranking  in  Southeast  Asia.  Philippine

Information  Agency.  Retrieved  from  https://pia.gov.ph/news/davao-city-maintains-

top-safety-ranking-in-southeast-asia/

PostgreSQL  Global  Development  Group.  (2025).  PostgreSQL  17  Documentation:  Data

Integrity

and

ACID

Compliance.

Retrieved

from

https://www.postgresql.org/docs/17/acid.html

PNP-SOSIA.  (2022).  Implementing  Rules  and  Regulations  of  Republic  Act  No.  11917.



---

Retrieved  from  https://www.scribd.com/document/691228276/Approved-IRR-RA-

11917

Republic Act No. 11917. (2022). The Private Security Services Industry Act. Retrieved from

https://elibrary.judiciary.gov.ph/thebookshelf/showdocs/2/95597

Scofield, M. B. (2025). Rust Axum Web Development: Build High-Performance APIs and

Services.  Retrieved  from  https://www.amazon.com/Rust-Axum-Web-Development-

High-Performance/dp/B0CX7N4K6J

Securitas.  (2026).  Control  Security  from  Anywhere  -  MySecuritas  Product  Overview.

Retrieved from https://www.securitas.com/en/security-solutions/mysecuritas/

Securitas  Technology.  (2025).  2026  Global  Technology  Outlook  Report:  The  State  of

Security

Technology.

Retrieved

from

https://www.securitastechnology.com/news/securitas-technology-releases-2026-

global-technology-outlook-report

Shiyanbola,  J.  O.,  et  al.  (2023).  A  Workforce  Capacity  Optimization  Model  for  Lean

Environments. Retrieved from https://www.irejournals.com/paper-details/1704408

Tan, K., et al. (2024). The digital transformation of security and the role of AI. Securitas

White Paper. Retrieved from https://www.securitas.ie/news-insights/whitepapers/the-

digital-transformation-of-security-and-the-role-of-ai/

TrackTik.  (2025).  Top  5  End-to-End  Security  Guard  Management  Software  for  2025.

Retrieved  from  https://www.tracktik.com/resources/blog-articles/top-5-end-to-end-

security-guard-management-software-for-2025/

TrackTik.  (2025).  Physical  Security  Operations  Benchmark  Report  2025.  Retrieved  from

https://www.tracktik.com/wp-content/uploads/2025/10/2025BenchmarkReport-1.pdf



---

CHAPTER 2

METHODOLOGY

This study adopted Agile methodology, specifically Scrum, to deliver SENTINEL through incremental, testable, and reviewable capability sets.

Development was organized into successive sprints that covered planning, implementation, integration, validation, packaging, review, and refinement. Each sprint used prioritized backlog items tied to operational risk and institutional requirements.

Sprint planning and backlog refinement emphasized high-risk domains, including account governance, workforce continuity, asset compliance, incident coordination, movement monitoring, notification and inbox workflows, guard-safety functions, and decision-support features. Regular integration checkpoints ensured consistency of workflows, system rules, and data behavior.

Validation was embedded throughout the Scrum cycle through scenario-based testing, integration checks, role-permission verification, browser-based acceptance review, and cross-platform runtime review. Sprint reviews documented completed increments, while acceptance checks verified that each increment satisfied defined criteria before carry-forward.

Release readiness was evaluated through structured quality checks, build verification, and governed platform packaging before each major milestone to support controlled rollout decisions and reduce operational disruption.

Overall, the methodology shows an Agile approach in which reliability, accountability, security, and usability were developed together with functional scope.

Figure 4. Scrum Model

Technical Background

Technologies to be Used in the System

SENTINEL is an integrated mission and decision-support platform delivered across web, desktop, and mobile environments. Technology selection was guided by the need for secure workflows, reliable records, real-time situational awareness, controlled release behavior, and cross-platform consistency. The following technologies were used in the implemented system:

1. React + TypeScript: Used to implement reusable, role-aware interface components and dashboard modules. Type safety improves consistency in data handling and interface behavior.

	Reusable inbox and workflow-timeline patterns are applied across guard, supervisor, administrator, and superadmin views to preserve consistency and reduce duplicated logic.

2. Vite: Used for development startup and production build generation to support rapid iteration.

3. Tailwind CSS: Used for responsive, utility-based styling across command, operations, and resource modules.

4. Leaflet + OpenStreetMap: Used for map rendering, live marker visualization, and client-site geospatial views.

5. Rust + Axum: Used for backend services, middleware, and orchestration to support secure and reliable asynchronous processing.

6. PostgreSQL: Used as the centralized transactional database for personnel, operations, asset, incident, movement, analytics, and audit records.

7. Docker + Docker Compose: Used to standardize service orchestration and reduce environment inconsistency across development and deployment contexts.

8. Secure token-based authentication: Used to enforce protected access and stable session management across user roles.

9. Real-time tracking transport: Used to maintain live operational updates through WebSocket streaming enabled by default across all deployment targets, with automatic polling fallback for continuity under unstable connectivity.

10. Forensic audit intelligence services: Used to transform audit records into timeline and anomaly views for investigative review.

11. Capacitor: Used to package the web frontend for Android field deployment under a signed release-governance process.

12. Tauri: Used to package the web frontend for Windows desktop command-center deployment.

13. Resend with managed delivery tooling: Used for account-related messaging and controlled deployment workflows.

14. Web-based documentation portal: Used to publish release references, architecture summaries, and legal policy documents.

15. Android release signing tooling: Used to generate, encode, and manage the release keystore required for signed APK and AAB distribution, supporting controlled and verifiable release governance for the Android deployment target.

Figure 5. Work Breakdown Structure

The Work Breakdown Structure (WBS) organizes the project into major deliverables and sub-deliverables to support schedule control, responsibility assignment, and progress monitoring.

WBS Diagram (Mermaid Model)

```mermaid
flowchart LR
	ROOT["Work Breakdown Structure\nSENTINEL System"]

	subgraph P1["Phase 1: Planning"]
		direction TB
		P1_1["1.1 Define scope and objectives"]
		P1_2["1.2 Identify stakeholders and roles"]
		P1_3["1.3 Prepare sprint roadmap"]
		P1_D["Deliverable:\nApproved project plan"]
		P1_1 --> P1_2 --> P1_3 --> P1_D
	end

	subgraph P2["Phase 2: Requirements Engineering"]
		direction TB
		P2_1["2.1 Gather functional requirements"]
		P2_2["2.2 Define non-functional requirements"]
		P2_3["2.3 Validate with client"]
		P2_D["Deliverable:\nApproved requirements spec"]
		P2_1 --> P2_2 --> P2_3 --> P2_D
	end

	subgraph P3["Phase 3: System Design"]
		direction TB
		P3_1["3.1 Design architecture and database"]
		P3_2["3.2 Define API contracts"]
		P3_3["3.3 Prepare storyboard and navigation"]
		P3_D["Deliverable:\nDesign specification"]
		P3_1 --> P3_2 --> P3_3 --> P3_D
	end

	subgraph P4["Phase 4: Development"]
		direction TB
		P4_1["4.1 Build auth, RBAC, and approvals"]
		P4_2["4.2 Build scheduling, attendance, and replacement"]
		P4_3["4.3 Build firearms, permits, and compliance"]
		P4_4["4.4 Build fleet, trips, incidents, and support/notification"]
		P4_5["4.5 Build dashboards, inbox, AI, tracking, and cross-platform"]
		P4_D["Deliverable:\nIntegrated system build"]
		P4_1 --> P4_2 --> P4_3 --> P4_4 --> P4_5 --> P4_D
	end

	subgraph P5["Phase 5: Testing and QA"]
		direction TB
		P5_1["5.1 Module and integration testing"]
		P5_2["5.2 Security and role testing"]
		P5_3["5.3 Fix defects and regressions"]
		P5_D["Deliverable:\nValidated release candidate"]
		P5_1 --> P5_2 --> P5_3 --> P5_D
	end

	subgraph P6["Phase 6: Documentation and Deployment"]
		direction TB
		P6_1["6.1 Deploy and verify runtime"]
		P6_2["6.2 Finalize technical and user docs"]
		P6_3["6.3 Prepare defense and turnover"]
		P6_D["Deliverable:\nFinal documented system"]
		P6_1 --> P6_2 --> P6_3 --> P6_D
	end

	ROOT --> P1
	ROOT --> P2
	ROOT --> P3
	ROOT --> P4
	ROOT --> P5
	ROOT --> P6

	P1 --- P2 --- P3 --- P4 --- P5 --- P6

	classDef head fill:#a7d7df,stroke:#4c7680,color:#111,stroke-width:1px;
	classDef task fill:#ffffff,stroke:#6a6a6a,color:#111,stroke-width:1px;
	classDef out fill:#bfe8ef,stroke:#4c7680,color:#111,stroke-width:1px;

	class ROOT head;
	class P1_1,P1_2,P1_3,P2_1,P2_2,P2_3,P3_1,P3_2,P3_3,P4_1,P4_2,P4_3,P4_4,P4_5,P5_1,P5_2,P5_3,P6_1,P6_2,P6_3 task;
	class P1_D,P2_D,P3_D,P4_D,P5_D,P6_D out;
```

WBS Diagram (Text Model)

1.0 Project Management
1.1 Project initiation and scope definition
1.2 Stakeholder consultation and approvals
1.3 Sprint planning and monitoring

2.0 Requirements Engineering
2.1 Requirements elicitation
2.2 Functional and non-functional analysis
2.3 Requirements validation and sign-off

3.0 System Design
3.1 Architecture and database design
3.2 API and module design
3.3 Storyboard and interface design

4.0 System Development
4.1 Authentication, RBAC, and approval workflows
4.2 Scheduling, attendance, and replacement workflows
4.3 Firearms, permits, and compliance workflows
4.4 Fleet, trip, incident, support, and notification workflows
4.5 Dashboards, inbox, AI, map tracking, and cross-platform delivery

5.0 Testing and Quality Assurance
5.1 Module and integration testing
5.2 Security and role-permission testing
5.3 Defect fixing and regression testing

6.0 Documentation and Deployment
6.1 Deployment and runtime validation
6.2 Technical and user documentation
6.3 Defense preparation and final turnover

Gantt Chart of Activities

The project timeline is organized into phased milestones covering initiation, planning, requirements consolidation, Agile sprint development, integration, browser and runtime validation, documentation, and defense preparation. Activities are sequenced so that each completed output serves as an input to the next phase.

Figure 6. Gantt Chart of Activities

Gantt Chart of Activities (Mermaid Model)

```mermaid
gantt
	title SENTINEL Project Gantt Chart
	dateFormat  YYYY-MM-DD
	axisFormat  %b

	section Planning
	Project Initiation                  :a1, 2026-02-01, 30d
	Requirements Gathering              :a2, 2026-03-01, 31d
	System Architecture and UI Planning :a3, 2026-04-01, 30d

	section Development Sprints
	Sprint 1 Auth RBAC Approvals         :b1, 2026-05-01, 31d
	Sprint 2 Schedule Attendance Replace :b2, 2026-06-01, 30d
	Sprint 3 Firearms Permits Compliance :b3, 2026-07-01, 31d
	Sprint 4 Fleet Trips Incident Support :b4, 2026-08-01, 31d
	Sprint 5 Dashboard Inbox AI Xplat    :b5, 2026-09-01, 30d

	section Validation and Closeout
	Integration Testing and Bug Fixing  :c1, 2026-10-01, 31d
	User Validation and Documentation   :c2, 2026-11-01, 30d
	Final Review Defense and Turnover   :c3, 2026-12-01, 31d
```

Gantt Chart of Activities (Planned Timeline)

Month: February
Activity: Project initiation and problem definition

Month: March
Activity: Requirements gathering and validation

Month: April
Activity: System architecture and interface planning

Month: May
Activity: Sprint 1 implementation (authentication, RBAC, and approvals)

Month: June
Activity: Sprint 2 implementation (scheduling, attendance, replacement)

Month: July
Activity: Sprint 3 implementation (firearms, permits, and compliance controls)

Month: August
Activity: Sprint 4 implementation (fleet, trips, incidents, notifications, and support)

Month: September
Activity: Sprint 5 implementation (dashboards, inbox, analytics, AI, map tracking, and cross-platform packaging)

Month: October
Activity: Integration testing and bug fixing

Month: November
Activity: User validation, documentation, and refinements

Month: December
Activity: Final review, defense preparation, and turnover

Calendar of Activities

The calendar of activities operationalizes the WBS and Gantt sequence by specifying each period's objective, personnel involvement, and resource requirements.

1. February - Project initiation and problem definition.
Purpose: Define project boundaries, objectives, and target operational issues.
Persons involved: Proponents, adviser, client representative.
Resources needed: Consultation sessions, initial proposal documents, reference studies.

2. March - Requirements gathering and validation.
Purpose: Elicit and validate functional and non-functional requirements.
Persons involved: Proponents, operations users, adviser.
Resources needed: Interview guides, requirement templates, process notes.

3. April - System architecture and interface planning.
Purpose: Define system architecture, data model, and storyboard screens.
Persons involved: Proponents and adviser.
Resources needed: ERD tools, wireframe tools, architecture notes.

4. May - Sprint 1: Authentication, role governance, and approvals.
Purpose: Implement secure account lifecycle, access governance, and approval workflows.
Persons involved: Proponents.
Resources needed: VS Code, Rust toolchain, Node.js, PostgreSQL, Docker.

5. June - Sprint 2: Scheduling, attendance, and replacement.
Purpose: Implement shift management, attendance recording, no-show detection, and replacement workflows.
Persons involved: Proponents.
Resources needed: API test scripts, schedule datasets, integration logs.

6. July - Sprint 3: Firearms, permits, and compliance.
Purpose: Implement inventory, allocation, maintenance, permit, and compliance-sensitive workflows.
Persons involved: Proponents.
Resources needed: Firearm/permit data templates, compliance validation cases.

7. August - Sprint 4: Fleet, trips, incidents, notifications, and support.
Purpose: Implement armored car management, trip lifecycle, incident handling, support-ticket workflows, and notification delivery.
Persons involved: Proponents.
Resources needed: Fleet/trip datasets, incident scenarios, runtime logs.

8. September - Sprint 5: Dashboards, inbox, analytics, AI, tracking, and cross-platform packaging.
Purpose: Implement command dashboards, role-based inbox workflows, predictive modules, map tracking, real-time monitoring, and cross-platform build alignment.
Persons involved: Proponents.
Resources needed: Analytics test data, AI validation scenarios, platform build toolchains.

9. October - Integration testing and bug fixing.
Purpose: Validate end-to-end modules, role permissions, and real-time flows; resolve regressions.
Persons involved: Proponents, adviser, selected testers.
Resources needed: Test scripts, issue tracker, runtime diagnostics.

10. November - User validation, documentation, and refinements.
Purpose: Validate operational usability, finalize documentation content, and apply approved refinements.
Persons involved: Proponents, adviser, selected client-side validators.
Resources needed: Validation checklists, manuscript drafts, review notes.

11. December - Final review, defense preparation, and turnover.
Purpose: Consolidate final outputs, prepare defense materials, and complete project handover.
Persons involved: Proponents and adviser.
Resources needed: Final manuscript file, presentation slides, appendices.

Resources

Hardware Requirements (Recommended)

Table 1 presents the recommended hardware requirements for development and operational deployment of the implemented SENTINEL system.

Table 1: Hardware Requirements

Development Workstation
Operating System: Windows 10/11 (64-bit)
Processor: Intel Core i5 (10th gen or newer) or AMD Ryzen 5 (equivalent or newer)
Memory / RAM: 16 GB recommended (8 GB minimum)
Storage: 512 GB SSD recommended (250 GB minimum)
Network: Stable broadband connection for package installation, container pulls, and API testing
Display: 1366x768 minimum; 1920x1080 recommended for dashboard development and testing

Deployment Environment
Application Server: 4 vCPU minimum, 8-16 GB RAM, SSD-backed storage, Docker-capable host
Database Server: PostgreSQL-capable host (co-located or separate) with regular backup storage
Command Center Endpoints: Windows desktop systems capable of running the Tauri desktop build
Field Endpoints: Android smartphones/tablets with GPS and reliable mobile data/Wi-Fi connectivity for guard tracking and attendance workflows

Software Requirements

The software stack is grouped into development-time and runtime requirements to reflect implementation and deployment conditions.

Development Requirements

1. Visual Studio Code for frontend, backend, and documentation workflow management.

2. Node.js and npm for React/Vite dependency management, development server execution, and production frontend builds.

3. Rust toolchain (rustup, cargo) for building and validating the Axum backend services.

4. Docker Desktop and Docker Compose for local orchestration of backend and PostgreSQL services.

5. PostgreSQL tooling (local or containerized) for schema validation, data checks, and operational query verification.

6. Git and GitHub for version control, branch-based collaboration, and release workflow integration.

7. Markdown/Jekyll-compatible documentation tooling for maintaining GitHub Pages deployment content and release documentation artifacts.

8. Playwright for browser-based smoke and role-navigation validation, including verification that header-based quick Inbox access, profile-menu workflows, and role-specific dashboard entry points render correctly across supported operational roles.

9. Android keystore management tooling (PowerShell-based) for generating, encoding, and securely distributing Android release signing credentials required for the Capacitor mobile deployment target.

Runtime Requirements

1. Modern web browser (Chromium-based or equivalent) for the web deployment target.

2. Windows desktop operating system for the Tauri-based desktop deployment target.

3. Android operating system for the Capacitor-based mobile deployment target.

4. Network connectivity between client runtimes and backend API services, including websocket access for live tracking views.

5. Stable connectivity to the system's audit and forensic services to support command-level investigation and operational review.

Requirements Analysis

Requirement analysis in this study used an operational risk lens to determine who is affected, which activities are vulnerable, and where existing procedures create delays, compliance gaps, or weak accountability.

The requirements baseline was derived from observed agency needs: role-governed access, workforce continuity, asset custody control, incident coordination, real-time monitoring, and command-level decision support. Emphasis was placed on requirements that strengthen traceability and reduce delayed intervention in field operations.

Beyond basic data recording, the analysis includes intelligence-oriented requirements such as movement-history reconstruction, geofence transition awareness, and forensic audit interpretation. These requirements support proactive supervision and evidence-based review.

Usability requirements focus on reducing decision friction by consolidating urgent tasks and workflow context in role-specific command surfaces. Compliance requirements similarly treat policy acceptance as an enforceable access condition, with recorded legal metadata for institutional accountability.

Security and continuity requirements include authenticated access, authorization control, session integrity, abuse protection, and traceable denial events. Real-time monitoring requirements prioritize resilient field visibility under variable network conditions.

Cross-platform requirements require behavior parity across Web, Desktop, and Android environments, while release and maintainability requirements prioritize controlled distribution and verifiable deployment integrity.

Requirements Documentation

This section documents the implemented functional and non-functional requirements that define the current behavior of the system.

The requirements listed below are aligned with verified module coverage and storyboard-based interface flow expectations.

Functional Requirements

FR-01. The system shall support administrator-mediated onboarding, verification, approval, authentication, and password-reset workflows for operational users.

FR-02. The system shall enforce role-based access for superadmin, admin, supervisor, and guard, including role-appropriate dashboard and API access.

FR-03. The system shall support guard management workflows including profile governance, shift assignment, attendance capture, no-show detection, and replacement processing.

FR-04. The system shall support firearm lifecycle management including records, issuance/return, permit-state awareness, and maintenance tracking.

FR-05. The system shall support armored vehicle lifecycle management including records, driver assignment, trip operations, and maintenance tracking.

FR-06. The system shall provide real-time tracking through live location updates, attendance signaling, and site-aware monitoring, with access governed by authorized operational roles.

FR-06a. The system shall provide movement-history and active-deployment insights to support replay-based monitoring and command decisions.

FR-06b. The system shall detect and persist geofence enter/exit transitions and expose these alerts in live map snapshots for supervisory awareness.

FR-07. The system shall provide analytics and command-level dashboards for operational summaries, trends, approvals, and decision support.

FR-07a. The system shall provide a role-centric quick Inbox action that surfaces prioritized items and workflow timelines through shared header overlays and role-specific data mappings, while preserving fallback full-view access when deeper review is required.

FR-08. The system shall provide AI-assisted decision-support outputs for absence risk, replacement recommendation, incident classification, incident summarization, and predictive alerts.

FR-09. The system shall provide ticketing and notification workflows, including dashboard-embedded and overlay-based delivery surfaces, to support operational communication and exception handling.

FR-10. The system shall support cross-platform runtime delivery for web, Windows desktop (Tauri), and Android mobile (Capacitor).

FR-11. The system shall provide audit-log visibility for authorized superadmin users, with filterable and paginated audit records.

FR-11a. The system shall provide forensic audit intelligence for user-activity timelines and anomaly identification to support investigative workflows.

FR-12. The system shall require recorded acceptance of Terms of Agreement, Privacy Policy, and Acceptable Use Policy before users can access restricted operational functions.

FR-13. The system shall provide a release-oriented documentation portal that includes download channels, security profile, architecture references, and legal-policy links for web, desktop, and Android distribution.

Non-Functional Requirements

NFR-01. Security: The system shall enforce strong authentication, role-based authorization, approval-gated access, auditable security events, account-protection controls, and abuse resistance measures.

NFR-02. Performance: The system shall maintain responsive dashboards and timely operational updates suitable for near-real-time supervisory decision-making.

NFR-03. Usability: The system shall provide role-centered dashboards and modular UI navigation that reduce operator context switching during active operations.

NFR-03a. Workflow Focus: The system shall minimize dashboard navigation friction by placing urgent operational work and timeline context behind a single quick Inbox action in the shared header for each supported role.

NFR-04. Reliability: The system shall maintain robust session continuity, secure session renewal, and explicit session termination to protect ongoing operations.

NFR-05. Scalability: The system architecture shall remain API-driven and modular so additional modules, integrations, and platform targets can be added without redesigning the full stack.

NFR-06. Compliance Traceability: Legal acceptance and policy governance events shall be persisted with timestamped metadata suitable for operational and compliance review.

Storyboard (Proposed Interface Flow)

The storyboard describes the user-facing flow of major screens and role actions in the implemented system.

1. Login and Account Verification Screen

- Users will enter credentials to access the system.
- Newly onboarded or pending guard accounts, where applicable, will complete email verification and approval checks before protected access.
- Forgot-password users will request and validate reset codes.

2. Role-Based Dashboard Screen

- Superadmin will view command-level system metrics and governance modules.
- Administrators will view operational resources, approvals, and assignments.
- Supervisors will view schedules, attendance, alerts, and replacement actions.
- Guards will view personal schedules, check-in controls, and assigned resources.
- Each role will access shared header actions for theme control, quick Inbox access, and profile-menu workflows so urgent tasks and operator controls remain available without expanding sidebar navigation.
- Elevated resource dashboards reuse the same header-action pattern and preserve `Inbox` and `Settings` as valid fallback routes, while the sidebar remains restricted to primary operational destinations.
- Elevated sidebar navigation now includes `Calendar` as a primary destination for superadmin, administrator, and supervisor command workflows.
- Elevated URL-accessible deep-link routes intentionally kept outside the sidebar include `/permits`, `/inbox`, `/profile`, `/support`, `/shift-swaps`, `/notifications`, and `/trips`.
- Elevated-role mobile navigation now prioritizes `Dashboard`, `Approvals`, `Schedule`, `Alerts`, and `More` through shell-level tabs, while guard navigation remains mission-focused and single-sourced in the dedicated guard bottom workflow region.
- Elevated Inbox workflows keep approvals, asset-related actions, and workflow history available through one role-appropriate access path with fallback full-view navigation when deeper review is needed.
- Shift-swap activity degrades gracefully when historical data is unavailable so manual request workflows remain usable without blocking the guard interface.
- Operational map views use theme-aware presentation and readable command surfaces in both light and dark modes to support sustained monitoring.
- Command-center AI alert, severity, and summary cards use consistent semantic status treatment to preserve readable contrast and faster signal recognition.
- Connectivity, notification, and recovery prompts are positioned to support ongoing command work without obscuring primary navigation.

3. Personnel and Scheduling Screen

- Authorized users will create, edit, and monitor schedules.
- Attendance status, no-show events, and replacement workflows will be displayed.

4. Asset and Compliance Screen

- Firearm inventory, allocations, permit statuses, and maintenance entries will be managed.
- Fleet records, driver assignments, trip details, and maintenance schedules will be monitored.

5. Incident, Support, and Notification Screen

- Users will submit incidents and support tickets.
- The system will display notification updates, unread counts, and response history through dashboard panels, inbox timelines, and shared shell overlays.

6. Analytics and Reporting Screen

- Authorized users will view KPI summaries, trends, and reliability metrics.
- Operational and compliance reports will be generated for review and decision support.

7. Tracking and Map Screen

- The system will visualize guard, vehicle, and site data through a map-based operational display with theme-aware presentation.
- Live updates and proximity alerts will support real-time monitoring activities.
- Client-site management controls (add, edit, delete) are restricted to elevated command roles, while guards retain role-scoped map visibility without unauthorized tracking-management actions.

Activity Diagrams (Role-Based)

The following activity diagrams present the process flow for each user role in the proposed system.

Figure 8. Guard Activity Diagram

Figure 8 illustrates the Guard workflow from authentication to shift execution and secure logout. After login, the guard enters a mission-first dashboard that prioritizes the current post, immediate next action, and readiness cues before lower-priority workflows. The guard then performs check-in and check-out when a shift is active, and may review alerts, submit support tickets, request shift swaps, and update profile information as needed.

```mermaid
flowchart LR
	A([Start]) --> B[Open login]
	B --> C[Enter credentials]
	C --> D{Credentials valid?}
	D -- No --> E[Show error]
	E --> C
	D -- Yes --> F[Open Guard dashboard]
	F --> G[View schedule and duty]
	G --> H{Shift is active?}
	H -- No --> I[View alerts or submit ticket]
	I --> J[Update profile]
	J --> K[Logout]
	K --> L([End])
	H -- Yes --> M[Perform check-in]
	M --> N[Perform duty]
	N --> O[Perform check-out]
	O --> I
```

Figure 9. Supervisor Activity Diagram

Figure 9 presents the Supervisor workflow, beginning with dashboard access and continuing through attendance review, gap detection, and replacement coordination. When no immediate staffing issue exists, the supervisor proceeds with alert, incident, and team monitoring tasks before secure session closure.

```mermaid
flowchart LR
	A([Start]) --> B[Login as Supervisor]
	B --> C[Open Supervisor dashboard]
	C --> D[Review schedule and attendance]
	D --> E{No-show or gap detected?}
	E -- Yes --> F[Start replacement workflow]
	F --> G[Assign available guard]
	G --> H[Confirm deployment]
	E -- No --> I[Monitor alerts and incidents]
	H --> I
	I --> J[Review team performance]
	J --> K[Logout]
	K --> L([End])
```

Figure 10. Administrator Activity Diagram

Figure 10 outlines the Administrator workflow for approvals, scheduling, asset records, incident and support review, and analytics-assisted monitoring. The process includes a corrective-action loop for detected issues and concludes with secure logout for traceable session closure.

```mermaid
flowchart LR
	A([Start]) --> B[Login as Administrator]
	B --> C[Open Admin dashboard]
	C --> D[Manage users and approvals]
	D --> E[Manage schedules and assignments]
	E --> F[Manage firearms and fleet records]
	F --> G[Review incidents, tickets, notifications]
	G --> H[Access analytics and reports]
	H --> I{Operational issue found?}
	I -- Yes --> J[Apply corrective action]
	J --> G
	I -- No --> K[Logout]
	K --> L([End])
```

Figure 11. Superadmin Activity Diagram

Figure 11 describes the Superadmin workflow for system-wide governance. After authentication, the superadmin reviews global indicators, role-permission policies, and audit records. When policy or security concerns are identified, governance updates are applied and validated before monitoring resumes.

```mermaid
flowchart LR
	A([Start]) --> B[Login as Superadmin]
	B --> C[Open command dashboard]
	C --> D[Review global KPIs and status]
	D --> E[Manage roles and permission policies]
	E --> F[Review audit logs and governance actions]
	F --> G{Policy or security issue detected?}
	G -- Yes --> H[Apply governance and access updates]
	H --> I[Validate changes across modules]
	I --> D
	G -- No --> J[Approve strategic operational settings]
	J --> K[Logout]
	K --> L([End])
```

Development

SENTINEL was developed through iterative Agile delivery in which user workflows, governance controls, and operational data services progressed in parallel.

Development outputs were organized around core agency functions: identity governance, workforce continuity, asset and compliance management, incident and support coordination, live tracking, and analytics-assisted decision support.

At the interface level, development emphasized role-appropriate command views, consolidated action context, and clear operational hierarchy so users can move from signal recognition to decision and action with less navigation overhead. The implemented elevated and guard shells keep sidebar navigation focused on primary operational destinations, while shared header actions provide theme control, quick Inbox access, and profile-menu workflows through reusable interaction patterns. Elevated-role full Inbox fallback navigation remains synchronized with role-specific dashboard state so header-triggered full-view actions open the intended operational context. The implemented guard dashboard specifically uses a mission-first first viewport, where immediate action and readiness guidance are surfaced from existing schedule and device state before deeper content. At the service level, development maintained consistent protection logic for authentication, authorization, legal-consent enforcement, auditability, and resilience controls.

Real-time features integrated field telemetry, geofence signaling, and movement-history capabilities for both immediate supervision and post-incident reconstruction. In current backend behavior, heartbeat ingestion distinguishes GPS-like samples from coarse IP-based fallback samples through server-side accuracy thresholds; coarse fallback samples are retained as approximate map points instead of being discarded, while configurable precision gating remains in effect for normal GPS telemetry. The default tracking accuracy mode is balanced, applying a threshold of thirty-five meters and an eight-minute person recency window; a stricter mode with twenty-meter accuracy and three-minute recency is available through environment configuration. WebSocket-based live tracking is enabled by default across all deployment environments, with automatic polling fallback when WebSocket connections are unavailable. The guard workspace presents a heartbeat status indicator so field users can identify when location sharing is paused. In the command-center implementation, the operational map panel displays computed active guard and active trip counts derived from live tracking data, and selecting a live operations or incident alert entry surfaces contextual event details directly on the operational map when matching field telemetry is available. Incident and support workflows were aligned with notifications and workflow history so response activity remains visible and accountable. Where shift-swap history is unavailable or stale, the implemented frontend preserves manual request guidance and keeps other inbox activity visible instead of blocking the guard workflow.

Decision-support services provide risk-oriented insights while preserving human authority for final operational decisions. In the implemented command-center AI widgets, classification and summarization outputs now support direct operator follow-up inside the command workflow rather than remaining isolated display elements. Cross-platform delivery preserves workflow and policy consistency across Web, Desktop, and Android targets, while controlled release governance protects the integrity of distributed builds.

Security and usability hardening were treated as operational requirements rather than cosmetic refinements. The implemented platform applies centralized session handling, auditable protected actions, responsive and accessible command surfaces, and signed Android release governance to reduce drift between intended controls and deployed behavior. Some lower-priority route surfaces remain lightweight placeholders or fallback entry points while core workflows are concentrated inside the main dashboard shells.

Overall, development outcomes indicate a maintainable, governance-aligned, and decision-oriented platform for private security operations.

Design of Software, System, Product, and/or Processes.

The SENTINEL design follows a layered architecture that separates user interaction, operational processing, and institutional records. This separation supports maintainability, scalability, clear accountability boundaries, and dependable mission decision-making.

The interaction layer applies role-scoped command interfaces so each user group receives context-appropriate controls, signal summaries, and task priorities. Reusable design patterns support interface consistency and reduce training overhead. In the current implementation, the command interface emphasizes dense operational summaries, restrained visual surfaces, and clear hierarchy so urgent work remains prominent without excessive decorative elements. Several workflows are intentionally concentrated inside shared dashboard panels, tabs, and overlays instead of being distributed across fully separate standalone modules.

The process layer standardizes protected actions through a consistent sequence: identity verification, authorization checking, policy-state validation, operational rule execution, and traceable output generation. This sequence reinforces safety, compliance, and accountability for high-impact workflows.

Legal and policy governance are embedded in access control by requiring recorded policy acceptance before protected module use. At the data layer, structured records preserve traceability across workforce operations, asset custody, mobility, incidents, support activities, analytics, and governance events.

The real-time subsystem is designed for continuity under variable network conditions through WebSocket-based low-latency updates with automatic polling fallback. Tracking accuracy is configurable between balanced and strict modes, with balanced as the default to accommodate typical field GPS conditions while maintaining operationally useful position data. Geofence transitions and movement-history views support both active supervision and post-event reconstruction, although full end-user administration of some backend-supported geofence and compliance capabilities remains limited in the current product surface.

Decision-support capabilities are assistive. Analytics and deterministic AI outputs provide risk indicators and recommendations, while final operational authority remains with human decision-makers.

Cross-platform design maintains behavior parity across Web, Desktop, and Android runtimes so users operate under consistent workflow and governance assumptions.

Security design principles are reinforced through centralized authentication header management, ensuring that token handling is isolated to a single utility layer. This reduces the surface area for credential exposure and makes session-management changes predictable and auditable.

Release-process design includes explicit signing-contract enforcement for Android artifacts. Build execution now validates signing material presence before release assembly and uses standardized secret names across scripts and pipeline stages to prevent divergent configuration states.

AI design now follows a hybrid strategy: model-driven classification for semantic incident interpretation and deterministic fallback scoring for continuity under provider unavailability. Confidence outputs are computed from observed language signals rather than static labels, improving interpretability and operational trust.

Interface design decisions incorporate explicit compliance with WCAG 2.5.5 (Minimum Target Size) and WCAG 1.4.3 (Contrast Minimum) standards. Touch targets for critical interactive controls, including location tracking toggles and primary action buttons, meet the minimum 44-CSS-pixel guideline for reliable field operation on mobile devices. Support for Windows Forced Colors and High Contrast accessibility modes is embedded in active control styling to accommodate diverse accessibility requirements across command-center and field deployments.

Overall, the design reflects a role-governed and auditable system aligned with current private security management requirements.

---

Summary of Findings and Conclusions

The current iteration of SENTINEL demonstrates that an integrated, role-governed security operations platform can consolidate identity control, personnel administration, asset accountability, incident coordination, live monitoring, audit visibility, and decision-support services within a single operational environment. Verified implementation coverage now spans Web, Desktop, and Android delivery, role-specific dashboards, shared command-shell workflows, legal-policy gating, and operational data visibility for both field and command users.

Findings indicate that the strongest contribution of the system is workflow consolidation under governed access. Instead of distributing approvals, scheduling, attendance, tracking, incidents, notifications, support cases, and compliance-sensitive asset workflows across disconnected tools, the implemented platform concentrates these activities inside role-scoped dashboards and shared action surfaces. This supports faster operational review, reduced context switching, and improved traceability for administrative and supervisory decision-making.

The study concludes that SENTINEL has progressed beyond a conceptual management proposal into a functioning multi-platform operational system aligned with current private security requirements. Although some backend-supported capabilities remain only partially surfaced through end-user administration views and offline continuity is still limited to selected actions, the present implementation already provides a credible foundation for command decision support, field coordination, and governance-centered operations. Overall, the project shows that a role-governed, auditable, and extensible architecture is suitable for contemporary private security management under current regulatory expectations.
