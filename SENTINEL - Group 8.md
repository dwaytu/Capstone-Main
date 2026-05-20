SENTINEL: AN INTEGRATED SECURITY OPERATIONS MANAGEMENT SYSTEM FOR DAVAO SECURITY & INVESTIGATION AGENCY, INC.

**A Capstone Project **

**Proposal Presented to the Faculty of the**

**Information and Communications Technology Program STI College Tagum**

**In Partial Fulfillment**

**of the Requirements for the Degree Bachelor of Science in Information Systems**

**HANZ LOURENZ FRANK J. RIBU**

**HECTOR PHILLIP P. LACIERDA**

**APPLE JOHN D. LUMINGKIT**

**DWIGHT KARL B. GAGA-A**

**GAD ABRAHAM M. JOSE**

**May 2026**

ENDORSEMENT FORM FOR PROPOSAL DEFENSE

**TITLE OF RESEARCH:    SENTINEL: An Integrated Security Operations Management System for Davao Security & Investigation Agency, INC.**

**NAME OF PROPONENTS:    **Hanz Lourenz Frank J. Ribu

    Hector Phillip P. Lacierda

    Apple John D. Lumingkit

    Dwight Karl B. Gaga-a

    Gad Abraham M. Jose

In Partial Fulfilment of the Requirements

for the degree Bachelor of Science in Information Systems

has been examined and is recommended for Proposal Defense.

**ENDORSED BY:**

Mr. Eldito C. Loquinio, MIT

**Capstone Project Adviser**

**APPROVED FOR PROPOSAL DEFENSE:**

Mr. Allimar M. Nuevo, MM, CGSP, CHIA

**Capstone Project Coordinator**

**NOTED BY:**

Mr. Eldito C. Loquinio, MIT

**Program Head**

**May 12, 2026**

APPROVAL SHEET

This capstone project proposal titled: **SENTINEL: An Integrated Security Operations Management System for Davao Security & Investigation Agency, INC. **prepared and submitted by **Hanz Lourenz Frank J. Ribu, Hector Phillip P. Lacierda, Apple John D. Lumingkit**, **Dwight Karl B. Gaga-a** and **Gad Abraham M. Jose**, in partial fulfillment of the requirements for the degree of Bachelor of Science in Information Systems, has been examined and is recommended for acceptance and approval.

**Mr. Eldito C. Loquinio, MIT**

Capstone Project Adviser

Accepted and approved by the Capstone Project Review Panel in partial fulfillment of the requirements for the degree of Bachelor of Science in Information Systems

Ms. Iris Mae Mendoza, MIT

Mr. Allimar M. Nuevo, MM, CGSP, CHIA

**Panel Member**

**Panel Member**

Mr. Benjamin M. Mahinay, MIT

**Lead Panelist**

**Noted:**

Mr. Allimar M. Nuevo, MM, CGSP, CHIA

Mr. Eldito C. Loquinio, MIT

**Capstone Project Coordinator**

**Program Head**

**May 12, 2026**

TABLE OF CONTENTS

TITLE PAGE    i
ENDORSEMENT FORM FOR PROPOSAL DEFENSE    ii
APPROVAL SHEET    iii
TABLE OF CONTENTS    iv
INTRODUCTION    1
Project Context    1
Purpose and Description    3
Objectives    4
Scope and Limitations    9
Review of Related Literature/Studies/Systems    13
METHODOLOGY    22
Requirements Analysis    28
Design of Software, System, Product, and/or Processes    34
REFERENCES    55
INTRODUCTION

Project Context

The private security global industry is transitioning toward automated, high-integrity digital ecosystems to address the discovery lag inherent in human-led monitoring. Global research in workforce capacity indicates that manual, reactive responses to personnel gaps significantly increase vacancy time, which remains a primary driver of security breaches in critical infrastructure (Shiyanbola et al., 2023). This movement is supported by modern performance management theories which emphasize that transparent, data-driven tracking is essential to maintaining accountability and preventing social loafing, a phenomenon where individual reliability decreases in the absence of structured, real-time monitoring (Aguinis, 2022).
         The necessity for these technological advancements is echoed in recent Philippine legislation through the Private Security Services Industry Act, also known as Republic Act No. 11917 (2022). This law introduced a regime of professionalized accountability where agencies face strict liability for administrative negligence. Under the law’s Implementing Rules and Regulations, agencies can be fined up to P5,000,000 or face license revocation for deploying personnel with expired licenses or unauthorized firearms (Jur.ph, 2025). Furthermore, national studies on the effectiveness of Philippine security guards identify that absenteeism and the abandonment of posts are most prevalent in agencies that lack advanced patrol monitoring and digital reporting systems (Abad, 2025).
        In the specific context of the Davao Region, the Davao Security and Investigation Agency, Inc. operates in a landscape that has prioritized a culture of security to sustain its position as a leading safe haven in Southeast Asia (PIA, 2025). According to the Davao Regional Development Plan 2023 to 2028, the region's rapid economic growth has increased the demand for advanced technology and innovation to ensure peace and security in high-traffic logistics and commercial hubs like Tagum City (NEDA XI, 2024). Recent local research conducted in the Davao Region specifically highlights that compensation, punctuality, and alertness are the primary determinants of guard performance, yet many regional agencies still struggle with inattentiveness and abandonment of posts due to inconsistent manual oversight (Ondos and Origines, 2025). For DASIA Tagum, this represents a critical vulnerability where site vacancies may go undetected for hours, directly compromising the safety of local clients.
          SENTINEL is an integrated digital ecosystem designed to resolve these cumulative vulnerabilities by centralizing personnel profiles, firearm telemetry, and shift logs into a high-performance single source of truth. The system works by embedding real-time compliance checks into the daily operational workflow. Before a guard can be deployed, the system automatically verifies their license validity and firearm authorization against central records. To manage high-concurrency requests from hundreds of guards, SENTINEL utilizes the Rust programming language and the Axum framework, providing native memory safety and asynchronous performance that prevents the data races typical of legacy systems (Scofield, 2025). When an operational gap such as a missed check-in is detected, the system immediately flags the vacancy and identifies the nearest qualified replacement, ensuring that the agency moves from a reactive stance to a proactive, legally defensible model of security management.

Purpose and Description

The primary purpose of this capstone project is to design, implement, and deliver SENTINEL as an integrated security operations and decision-support platform for Davao Security and Investigation Agency, Inc. The study addresses fragmented manual oversight by consolidating core operational processes into a role-governed environment that supports timely command decisions, field coordination, and institutional accountability.

SENTINEL provides unified support for identity and access governance, workforce administration, asset and permit compliance, incident coordination, support and notification workflows, and real-time situational awareness. Role-based and policy-based controls restrict sensitive functions to authorized users and preserve traceable records for institutional review. In the current user-facing product, protected access is administrator-mediated, approval-governed, and policy-gated rather than exposed as open public self-registration through the login experience.
         Operationally, the system supports scheduling, attendance, no-show detection, replacement handling, and role-specific dashboard workflows to sustain deployment continuity. For field use, the implemented guard experience includes check-in and check-out actions, emergency contact access, panic escalation, and selected offline continuity for high-priority actions. SENTINEL also manages firearm and vehicle lifecycles, including issuance, return, maintenance, trip visibility, and permit-sensitive checks, to strengthen asset accountability and reduce service disruption.

At the command level, the platform integrates live tracking signals with structured operational records to provide timely visibility of personnel movement, incident status, deployment conditions, and site-aware activity. Geofence monitoring, notifications, quick Inbox timelines, and incident workflows support faster coordination across command and field roles.

SENTINEL further includes analytics and hybrid AI-assisted decision support for staffing risk, maintenance risk, incident classification, and incident summarization, with deterministic fallback behavior where continuity is required. These outputs are assistive and preserve human authority for final operational decisions.

Security and governance controls are embedded as core functions, including secure session management, legal-policy acceptance gating, audit and forensic logging, rate limiting, and service-health monitoring. Cross-platform delivery across Web, Desktop, and Android maintains consistent behavior and policy enforcement across runtime environments, although some secondary workflows are still delivered through shared dashboard panels, tabs, and shell overlays rather than fully separated standalone pages.

Objectives

**General Objective**

The main objective of this study is to develop a system named SENTINEL, an integrated, role-governed, multi-platform security operations management system for the stakeholders of Davao Security & Intelligence Agency, Inc. The purpose of this system is to improve their workforce continuity, asset accountability, incident coordination, live monitoring, and governance visibility across Web, Desktop, and Android platforms.

**Specific Objectives**

1. Strengthen identity, access, and legal-policy governance for all users.
2. Support account onboarding, identity verification, secure authentication, and password recovery under administrator-governed approval controls.
3. Maintain role-based approval and account-activation controls for operational users.
4. Preserve session continuity, revocation, and first-use legal-policy acceptance with traceable metadata.
5. Operationalize centralized personnel administration and command visibility.
6. Manage personnel records and role assignments for superadmin, administrator, supervisor, and guard.
7. Maintain guard approval queues, approval status tracking, and searchable role-based listings.
8. Surface role-appropriate dashboard views, shared command-shell task access, and quick-action workflows for command and field users.
9. Strengthen scheduling, attendance, and workforce continuity processes.
10. Manage shift schedules and duty assignments with conflict-aware coordination.
11. Capture attendance, check-in/check-out, and presence history with traceable records.
12. Detect no-show events, coordinate replacements, and manage guard availability.
13. Support guard safety escalation and selected offline continuity for critical field actions.
14. Enforce firearm inventory, issuance, and custody accountability.
    1. Maintain firearm records, status tracking, and permit-sensitive deployment checks.
    2. Record issuance and return activities, active allocations, and overdue custody cases.
    3. Track firearm maintenance schedules, pending work, and completion records.
15. Sustain permit and compliance-sensitive deployment management.
16. Maintain permit records, including expiring, valid, and revoked credentials.
17. Apply automated expiry awareness and compliance-sensitive workflow checks.
18. Enforce permit-aware workflows that reduce deployment of non-compliant personnel and assets.
19. Manage armored vehicle fleet and trip operations.
20. Maintain armored vehicle records, allocations, returns, and active-use visibility.
21. Manage driver assignments, driver-vehicle linkage, and trip preparation.
22. Document trip lifecycles from assignment to completion with historical traceability.
23. Track vehicle maintenance schedules, service history, and operational status.
24. Manage mission operations and merit-based performance evaluation.
25. Coordinate mission assignment, deployment monitoring, and field instructions review.
26. Generate merit scores and ranked guard results for staffing and supervision decisions.
27. Capture client evaluations, review performance evidence, and identify overtime or replacement candidates.
28. Deliver support, communication, notification, and emergency-escalation services.
29. Handle ticket submission and role-appropriate case review.
30. Deliver notifications, status tracking, and operational message management.
31. Issue timely alerts for incidents, workflow exceptions, and decision-critical events.
32. Provide a unified role-based action inbox and workflow timeline for prioritized tasks and operational history.
33. Enable emergency contact access and panic-incident escalation for guards during field operations.
34. Strengthen incident management and real-time movement intelligence.
35. Record incident recording, active incident monitoring, and status progression.
36. Capture live location points, guard presence signals, and map-linked operational context.
37. Maintain client-site records, shift proximity awareness, and deployment visibility.
38. Provide live tracking, path replay, patrol reconstruction, and active roster monitoring.
39. Detect geofence transitions and raise anomaly alerts for leadership review.
40. Expose geofence-driven monitoring outcomes for supervisory review and operational response.
41. Provide analytics, predictive intelligence, and decision support.
42. Present operational overviews, trend indicators, guard reliability insights, and command metrics.
43. Generate predictive alerts for permit expiry, maintenance risk, absenteeism patterns, and staffing capacity risk.
44. Apply hybrid AI assistance for guard absence risk, replacement suggestions, maintenance risk, incident classification, and incident summarization, with deterministic fallback behavior when needed.
45. Enable map-based situational awareness for command and field operations.
46. Visualize guards, routes, vehicles, and client sites through map-based operational displays.
47. Provide continuous live-tracking updates for command monitoring.
48. Enable map-linked situational review and proximity-based operational alerts.
49. Institutionalize governance, security, and auditability mechanisms.
50. Maintain audit logs and forensic event records for critical operational actions.
51. Enforce authenticated access, authorization checks, presence monitoring, and session revocation controls.
52. Sustain service readiness and abuse protection through health monitoring, throttling, and rate controls.
53. Preserve authorization-denial and access-failure records for forensic accountability.
54. Provide forensic audit intelligence for filtered timelines, actor-specific reconstruction, and anomaly detection.
55. Implement and validate cross-platform runtime delivery.
    1. Deliver the web runtime for browser-based command and operational access.
    2. Deliver the desktop runtime through Tauri packaging for command-center deployment.
    3. Deliver the mobile runtime through Capacitor Android packaging for field operations.
    4. Validate consistent behavior, connectivity, and session governance across Web, Desktop, and Android targets.
    5. Enforce controlled release governance and verified Android distribution.
56. Maintain compliant and accessible operational use.
    1. Require first-use acceptance of Terms of Agreement, Privacy Policy, and Acceptable Use Policy before protected access.
    2. Preserve legal acceptance metadata, including timestamp, policy version, requester IP, and user agent.
    3. Maintain accessible, role-appropriate command surfaces for desktop and field use, including readable status presentation and touch-safe critical controls.

Scope and Limitations

**Scope**

**        **The SENTINEL system covers the implemented operational, compliance, and governance requirements of a private security agency within the regulatory context of Republic Act No. 11917 (2022). The scope includes role-governed command and field workflows, centralized operational records, quick-action coordination surfaces, real-time situational monitoring, decision-support outputs, forensic audit visibility, and cross-platform delivery across Web, Desktop, and Android environments.

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
- React \+ TypeScript frontend and Rust \+ Axum backend services.
- Centralized PostgreSQL database with relational integrity, auditability, and role-based data control.
- Dockerized deployment and service-based architecture with live tracking synchronization, audit telemetry, and governed release packaging.

**Limitation of the Study**

The limitations of this study refer to the exclusions and constraints that were beyond the intended scope and implementation coverage of the developed system. These include, but are not limited to: (1) the exclusion of direct integration with external payroll systems, human resource platforms, government licensing databases, and third-party security hardware ecosystems such as CCTV, IoT sensors, and access-control devices; (2) technological constraints related to the system’s dependence on application-generated location updates, device GPS accuracy, network stability, and the provision of only partial offline support for selected high-priority guard actions. While GPS-based tracking provides more accurate and reliable location data for operational monitoring, IP-based location tracking remains less precise and may not consistently reflect the exact real-time position of field personnel. In addition, AI-assisted and predictive outputs remain advisory in nature and do not supersede human operational judgment; (3) platform constraints, wherein the implemented native runtime support of the system is limited to Web, Windows desktop, and Android environments, thereby excluding iOS and macOS deployment within the present study; and (4) implementation constraints, wherein certain backend-supported capabilities, such as direct training-record administration and full geofence-zone administration, are not yet fully exposed through complete end-user command surfaces, while some workflows remain consolidated within shared dashboard panels, tabs, and shell overlays rather than being deployed as fully independent standalone modules.

Review of Related Literature/Studies/Systems

**Related Literature**

    The Philippine private security sector is currently navigating its most significant legal transition in over fifty years. The enactment of the Private Security Services Industry Act (Republic Act No. 11917, 2022) effectively repealed the outdated RA 5487, shifting the industry toward a regime of "Professionalized Accountability." According to Jur.ph (2025), the law’s Implementing Rules and Regulations (IRR) mandate that Private Security Agencies (PSAs) maintain highly accurate, digitized records of License to Exercise Security Profession (LESP) and firearm permits. The act introduces a "strict liability" framework where administrative negligence, such as deploying an unlicensed guard, can result in fines ranging from ₱50,000 to ₱100,000 per violation, or up to ₱5,000,000 for agency-wide license failures.

This regulatory pressure has necessitated a move toward Automated Regulatory Compliance Tracking (ARCT). Research by Khinvasara, T., Shankar, A., & Wong, C. (2024) suggests that for organizations managing complex, shifting rules, the use of automated monitoring is a "significant advancement" that eliminates the "discovery lag" inherent in manual audits. By leveraging system-driven triggers for license expirations, PSAs can transition from reactive compliance to a proactive stance, ensuring that no personnel or asset is deployed without valid legal authorization.

Operational continuity in the private security sector is heavily dependent on reliable guard presence. As identified in the operational risks of DASIA Tagum, "No-Show" incidents represent a critical vulnerability where manual processes relying on phone calls and delayed human intervention fail to address "discovery lag." Research in workforce capacity optimization emphasizes that manual, reactive responses to workforce gaps significantly increase "vacancy time," directly correlating with higher security breach probabilities (Shiyanbola et al., 2023).

Modern systems mitigate this by automating the identification and deployment of replacements based on real-time availability, shifting the organizational stance from reactive crisis management to proactive risk mitigation (Al-Khafajiy et al., 2022). Furthermore, advanced algorithms now enable "predictive scheduling," which analyzes historical No-Show data to alert administrators of potential gaps before they occur, drastically reducing the operational vacancy time (TrackTik, 2025).

The transition from inconsistent, manual tracking to a structured, data-driven framework is essential for maintaining Distributive Justice, the perceived fairness of how shifts, rewards, and responsibilities are allocated within an organization. Aguinis (2022) posits that the absence of a structured performance management framework leads to "Social Loafing," a psychological phenomenon where employees decrease effort due to a perceived lack of individual accountability.

For security agencies like DASIA Tagum, implementing centralized performance metrics such as punctuality and client feedback logs ensures that shift allocation is based on objective data rather than subjective selection. This transparency not only increases overall guard reliability but also fosters a culture of accountability, as guards understand that their performance is directly linked to future opportunities (Tan et al., 2024).

The systematic allocation of firearms is a matter of both Chain of Custody (CoC) and legal necessity under the Private Security Services Industry Act (Republic Act No. 11917, 2022). The law mandates strict accountability for firearms, requiring that only authorized, trained, and compliant guards carry weapons. Manual processes often suffer from "data drift," where the status of a weapon and the permit validity of the assigned guard are not reconciled in real-time, leading to potential administrative negligence. Centralized digital tracking is identified as the primary defense against the misallocation of high-risk equipment and is a prerequisite for generating the legally defensible audit logs required by the National Cybersecurity Plan 2022-2028 (DICT, 2024; PNP-SOSIA, 2022).

The selection of the backend technical stack is a core security decision for mission-critical systems. Scofield, M. B. (2025) argues that Rust’s "ownership and borrowing" model provides a fundamental architectural advantage: Memory Safety without a Garbage Collector. This ensures that SENTINEL is natively resistant to buffer overflows and data races, vulnerabilities that often plague systems handling high-concurrency data like real-time firearm tracking.

Complementing the language is the Axum framework, which is built on the Tokio asynchronous runtime. As highlighted by NashTech (2025), Axum is designed for high-performance web services where scalability and raw speed are non-negotiable. For SENTINEL, this means the Attendance Tracking and No-Show Detection modules can handle hundreds of simultaneous "check-in" requests during shift rotations without performance degradation. This "asynchronous-first" design allows the system to remain responsive even when processing complex relational logic across personnel, vehicle, and firearm databases.

In an Integrated Operations Platform, the database must serve as the immutable "Single Source of Truth." PostgreSQL (2025) is recognized as the premier open-source RDBMS for enterprise planning due to its strict adherence to ACID (Atomicity, Consistency, Isolation, Durability) properties. Nguyen, R. (2025) emphasizes that PostgreSQL’s implementation of Foreign Key Constraints and Unique Exclusion Constraints is the primary defense against "data drift."

In the SENTINEL ecosystem, these constraints ensure that a firearm or armored vehicle cannot be logically "double-booked" or assigned to a guard who does not exist in the personnel table. This high level of relational integrity is a prerequisite for generating the legally defensible Audit Logs required by the National Cybersecurity Plan 2023-2028 (DICT, 2024), ensuring that every asset movement is tied to a verifiable digital identity.

    Empirical research confirms that automated oversight is a primary driver of operational integrity. A study by Atlam, H. F., & Yang, Y. (2025) found that organizations utilizing unified Access Control and Resource Planning (ERP) systems saw a 27% drop in unauthorized access violations and reclaimed 36% of staff time previously lost to manual verification. These findings suggest that hardwiring compliance into the system architecture, rather than treating it as an afterthought, tightens process integrity and reduces the risk of internal data tampering.

Furthermore, research by Shiyanbola, J. O., et al. (2023) on "Workforce Capacity Optimization" highlights a flaw in traditional security: "discovery lag." This occurs when supervisors only identify a personnel gap after a shift has failed. Their study demonstrates that real-time, asynchronous detection models allow for a proactive 11.8% improvement in site coverage reliability. Locally, ResearchGate (2025) cites a study by Respicio (2023) which found that Philippine security guards operating under digital monitoring exhibited significantly higher levels of alertness and punctuality because the system provided a transparent, inescapable layer of accountability that manual logs could not match. The functional blueprint of SENTINEL is informed by the performance of several industry-leading platforms such as TrackTik and Guardhouse.

![TrackTik](docs/capstone/paper-media/img-01.png)

Figure 1. TrackTik

TrackTik (2025) has redefined security workforce management by moving beyond static scheduling toward an integrated, AI-driven operational model. According to the Trackforce 2025 Physical Security Operations Benchmark Report, the industry is currently facing an "AI adoption paradox" where the value of predictive scheduling is recognized, but cost remains a barrier for mid-sized firms. TrackTik’s success is anchored in its ability to consolidate alarm monitoring, guard dispatch, and business administration into a single 24/7 resilient architecture, which users report has increased operational efficiency by approximately 20%. This efficiency is primarily attributed to the reduction of manual administrative burdens through automated compliance tracking and real-time intelligence feeds (TrackTik, 2025).

**![](docs/capstone/paper-media/img-02.png)**

Figure 2. Guardhouse

Guardhouse (2026) addresses the specific administrative "overload" that has become a measurable barrier to performance in the mid-2020s. Research from NODE Magazine (2026) indicates that security employees often lose an average of 15 hours per week to routine administrative tasks, such as re-entering data across fragmented systems. Guardhouse mitigates this by unifying scheduling, GPS tracking, and invoicing into a streamlined workflow, reportedly reducing office-based administrative time by 40–60%. Its "Confidence in Compliance" module provides a specialized framework for daily license verification, a logic that SENTINEL adapts to specifically meet the stringent requirements of RA 11917 (GetApp, 2026).

![Strážní Securitas dostávají novou zbraň. Globální softwarová platforma  zvýší efektivitu ostrahy | SECURITY MAGAZÍN](docs/capstone/paper-media/img-03.jpeg)

Figure 3. MySecuritas

Securitas "MySecuritas" (2026) represents the industry’s shift toward "Situational Understanding" and proactive risk management. The Securitas 2026 Global Technology Outlook Report identifies that the rapid advancement of generative AI for contextual understanding is now a top priority for 30% of security decision-makers (Securitas Technology, 2025). MySecuritas operationalizes this by providing a unified dashboard that transforms disparate incident reports into actionable statistics and trend highlights. This allows supervisors to identify risk patterns before they escalate, a core design principle mirrored in SENTINEL’s Performance Analytics Dashboard (Securitas, 2026).

![How Our Security Software Works | Silvertrac Software](docs/capstone/paper-media/img-04.png)

Figure 4. Silvertrac Software

Silvertrac Software (2026) is widely utilized for "Proof of Performance" and on-site accountability, particularly in parking and property management environments. While it excels in field reporting and checkpoint verification via mobile applications, its architectural focus remains on incident management and officer accountability (Silvertrac Software, 2026). Technical evaluations of generic guard management systems suggest a persistent "visibility gap" in specialized asset tracking; most platforms lack the deep relational logic required for a Digital Chain of Custody for high-risk assets like firearms and armored car fleets (Hardcat, 2025). SENTINEL fills this niche by integrating these high-stakes logistics, traditionally managed in siloed armory or fleet software, into the primary workforce management ecosystem.

Across the reviewed literature, several consistent themes emerge. Researchers emphasize the importance of integrating operational data to improve organizational visibility and decision-making. Studies from both Philippine and international contexts highlight the limitations of fragmented monitoring tools and manual processes.

Technological trends such as automated scheduling algorithms, attendance tracking, and operational dashboards are increasingly adopted across industries. However, existing systems often address only a single domain of operations, such as workforce scheduling or surveillance monitoring. Global systems like TrackTik and Guardhouse demonstrate that the industry standard is defined by Real-Time Accountability and Centralized Data Ownership. However, these systems often fail to accommodate the granular administrative nuances of Philippine law.

The reviewed literature therefore reveals a clear research gap in integrated systems that combine workforce management, compliance monitoring, and operational oversight within a unified platform tailored to security agencies. The SENTINEL system addresses this void by combining high-concurrency Rust/Axum architecture with modules specifically for Philippine-specific licensing (RA 11917), Firearm Custody, and Armored Car Fleet Management, allowing local agencies to achieve multinational levels of visibility and compliance. It provides a centralized solution that integrates scheduling automation, regulatory compliance verification, and real-time operational dashboards within a single enterprise system.

METHODOLOGY

![Agile Methodology. Agile Methodology | by Chathmini Jayathilaka | Medium](docs/capstone/paper-media/img-05.png)This study adopted Agile methodology, specifically Scrum, to deliver SENTINEL through incremental, testable, and reviewable capability sets.

Figure 5. Agile Model

    Development was organized into successive sprints that covered planning, implementation, integration, validation, packaging, review, and refinement. Each sprint used prioritized backlog items tied to operational risk and institutional requirements.

    Sprint planning and backlog refinement emphasized high-risk domains, including account governance, workforce continuity, asset compliance, incident coordination, movement monitoring, notification and inbox workflows, guard-safety functions, and decision-support features. Regular integration checkpoints ensured consistency of workflows, system rules, and data behavior.

    Validation was embedded throughout the Scrum cycle through scenario-based testing, integration checks, role-permission verification, browser-based acceptance review, and cross-platform runtime review. Sprint reviews documented completed increments, while acceptance checks verified that each increment satisfied defined criteria before carry-forward.

    Release readiness was evaluated through structured quality checks, build verification, and governed platform packaging before each major milestone to support controlled rollout decisions and reduce operational disruption. Overall, the methodology shows an Agile approach in which reliability, accountability, security, and usability were developed together with functional scope.

![](docs/capstone/paper-media/img-06.png)

Figure 6. Work Breakdown Structure

**Technical Background**

**Technologies to be used in the System**

**    **SENTINEL is implemented as a web-first integrated security operations platform with desktop and mobile runtime wrappers. Technology selection was based on concrete implementation requirements: role-based dashboards, secure API contracts, high-concurrency backend operations, traceable relational data, real-time tracking, and cross-platform delivery without codebase duplication. The proponents used the following technologies in the current implementation:
    Hardware specifications play a crucial role in the development of a web-based platform like SENTINEL, as they directly affect system performance and reliability. To ensure smooth operation during development, deployment, and daily use, the system requires a computer or laptop running on Windows 10 or Windows 11. A processor equivalent to at least a Ryzen 3 is recommended to handle basic processing tasks efficiently. The system should have a minimum of 8 GB of RAM, although 16 GB is preferred for better multitasking and performance. In terms of storage, a 250 GB SSD is required to provide faster data access and improved system responsiveness. Integrated graphics are sufficient for the system’s visual requirements, and a screen resolution of at least 1366x768 is needed for proper interface display. Additionally, a stable broadband internet connection is necessary to support the system’s web-based functionalities.

1. React \+ TypeScript: Will be used to build reusable, role-aware UI components and dashboard modules with strict typing.
2. Vite: Will be used for fast local startup and production build pipelines.
3. Tailwind CSS: Will be used for utility-driven, responsive interface implementation across command center, operations, and resource modules.
4. Leaflet \+ OpenStreetMap:** **Will be used for operational map rendering, live marker visualization, and client-site management.
5. Rust \+ Axum: Will be used for backend API handlers, middleware, and service orchestration.
6. PostgreSQL: Will be sed as the central transactional database for users, approvals, schedules, attendance, firearms, vehicles, incidents, notifications, tracking points, AI outputs, and audit logs.
7. Docker \+ Docker Compose: Will be ed to standardize local backend/database orchestration and deployment parity.
8. Secure token-based authentication:** **Will be used to enforce protected access and stable session management across user roles.
9. Capacitor:** **Will be used to package the web frontend for Android field deployment.
10. Tauri: Will be used to package the same frontend for Windows desktop command-center deployment.
11. Resend: Will be used for transactional email delivery such as verification codes, password reset codes, and operational notifications.
12. Railway: Will be used as a cloud deployment platform for backend runtime and managed service hosting.
13. Namecheap: Will be used for domain registration and domain-level DNS management.
14. Git and GitHub: Will be used for version control, collaboration, change tracking, and managing the release of MSI and EXE files.
15. Android release signing tooling:** **Will be used to generate, encode, and manage the release keystore required for signed APK and AAB distribution, supporting controlled and verifiable release governance for the Android deployment target.

**Gantt Chart of Activities**

MONTH

FEBRUARY

MARCH

APRIL

MAY

JUNE

JULY

AUGUST

SEPTEMBER

OCTOBER

NOVEMBER

DECEMBER

ACTIVITY

Project Initiation

Define scope and objectives

Initial planning and scheduling

Planning Kickoff and requirements alignment Sprint planning and reporting setup

Iteration 1: Core architecture and database design Frontend shell, testing, and review

Iteration 2: Scheduling, attendance, and replacement

Review, testing, and retrospective

Iteration 3: Asset, permit, vehicle, and trip modules

Review, testing, and retrospective

Testing and Quality Assurance

System and integration testing

Security, UAT, and defect resolution

Deployment Release preparation and environment setup

User training and technical documentation

Maintenance and Refinement Monitoring and refinements Support and documentation updates

Project Closure Final review and turnover Defense preparation and final submission

Figure 7. Gantt Chart of Activities

Completed

Ongoing

Not Started

Legends:

**Calendar of Activities**

**    **Figure 7 represents the Gantt chart of activities that summarizes the tasks and their duration. Activities are listed on the left, and the schedule is at the top right. Bars indicate task progress, with each bar representing a week.    The calendar of activities summarizes the same phased sequence defined in the WBS and Gantt schedule, including objectives, involved personnel, and required resources.

Table 1:** **Calendar of Activities**    **

**Month**

**Activity**

**Purpose**

February 2026

Phase 1 - Project Initiation

To define the project scope, identify stakeholders, and prepare the initial development schedule

March 2026

Phase 2 - Planning

To conduct kickoff activities, organize the product backlog, and establish sprint and reporting mechanisms

April - May 2026

Phase 3 - Iteration 1

To build the project foundation through architecture design, database setup, authentication, RBAC, approvals, and frontend shell development

June - July 2026

Phase 4 - Iteration 2

To implement workforce continuity workflows, including scheduling, attendance, replacement, incident handling, notifications, and support workflows

August - September 2026

Phase 5 - Iteration 3

To implement asset, compliance, tracking, analytics, AI-assisted, and cross-platform packaging features

October 2026

Phase 6 - Testing and Quality Assurance

To validate end-to-end system behavior, security, role permissions, user acceptance, and defect correction

November 2026

Phase 7 - Deployment

To prepare release builds, configure runtime environments, and conduct user training and documentation turnover

November - December 2026

Phase 8 - Maintenance and Refinement

To monitor system performance, address issues, update documentation, and incorporate approved stakeholder feedback

December 2026

Phase 9 - Project Closure

To complete the final review, consolidate project outputs, prepare defense materials, and hand over deliverables

Table 1 presents the scheduled activities for the development of the SENTINEL system. It outlines the project phases, major activities, and purposes throughout the implementation process.

Requirements Analysis

Table 3.** **Comparison of the Existing Process and the Proposed Process

**Process Area**

**Existing / Old Process**

**Proposed Process in SENTINEL**

**Expected Improvement**

Scheduling and workforce continuity

Scheduling, attendance, no-show detection, and replacement coordination depend on manual monitoring and delayed communication.

SENTINEL centralizes schedules, attendance actions, no-show detection, and replacement workflows in a unified operational platform.

Faster response to workforce gaps and improved deployment continuity.

Asset and compliance monitoring

Firearm, permit, vehicle, and trip records are managed through separate or manual records, increasing compliance and traceability risks.

SENTINEL manages firearm, permit, vehicle, trip, and maintenance workflows through centralized and auditable records.

Better compliance visibility, improved accountability, and reduced record fragmentation.

Incident handling and live monitoring

Incident reporting and field monitoring rely on manual updates, weak patrol visibility, and delayed supervisory awareness.

SENTINEL provides structured incident workflows, notifications, live tracking, geofence monitoring, and command dashboards.

Improved situational awareness, faster coordination, and more timely operational intervention.

Auditability and decision support

Operational review depends on scattered records and manual analysis, limiting traceability and data-driven decision-making.

SENTINEL provides audit logs, forensic visibility, operational dashboards, analytics, and AI-assisted decision-support outputs.

Stronger traceability, improved review capability, and better-informed command decisions.

Table 3 presents the comparison between the existing process and the proposed process in the SENTINEL system. It highlights the major operational areas in which the traditional manual or fragmented procedures are improved through a more centralized, role-governed, and system-supported approach.
    The requirements baseline for SENTINEL was defined from actual private-security operational pain points: fragmented coordination, delayed visibility, compliance exposure, and weak traceability of sensitive asset workflows. Based on current implementation, the requirements analysis prioritizes role-governed access, real-time operational awareness, and auditable process execution across personnel, equipment, vehicle, incident, and analytics domains.
     Technology and software selection was treated as a requirements decision, not only an implementation preference. For the frontend layer, React \+ TypeScript \+ Vite was selected to satisfy modular dashboard composition, strict role-based rendering, and rapid iteration. Angular was considered because it provides a full framework with built-in dependency injection and strong conventions; however, its heavier project structure was less aligned with the team's component-by-component delivery pace. Vue was considered for its simpler learning curve and progressive adoption model, but the existing codebase and shared component strategy were already established around React patterns. Plain JavaScript React was also considered, but TypeScript was chosen to reduce contract errors in role logic, API payload mapping, and cross-module state handling.
     For backend processing, Rust \+ Axum was selected to meet concurrency, security, and reliability requirements for authentication, approvals, tracking, and analytics endpoints. Node.js \+ Express was considered because of rapid API prototyping and broad ecosystem support, but the project prioritized compile-time safety and stricter runtime guarantees for security-sensitive operations. Java \+ Spring Boot was considered for enterprise-grade structure and mature tooling, yet it introduces a larger operational footprint and greater configuration overhead for this capstone scope. Go \+ Gin/Fiber was also considered for performance and simplicity, but Rust \+ Axum better matched the team's objective of memory-safe, middleware-centric API enforcement with fine-grained control.
     For persistence, PostgreSQL was selected because SENTINEL requires relational integrity across users, approvals, shifts, attendance, firearms, vehicles, incidents, and audit records. MySQL/MariaDB were considered because they are widely used relational systems, but PostgreSQL was preferred for stronger advanced SQL features, robust JSONB support, and flexible indexing for mixed transactional and analytical workloads. MongoDB was considered because of schema flexibility and rapid document modeling; however, SENTINEL's compliance and cross-entity constraints require strong relational guarantees that are more naturally enforced in PostgreSQL.
     For mapping and geospatial visualization, OpenStreetMap \+ Leaflet was selected to satisfy real-time operational map requirements, client-site management, and location marker rendering while retaining implementation control. Google Maps Platform was considered because it provides high-quality basemaps, geocoding, and route services, but usage-based billing and API quota sensitivity are less favorable for continuous monitoring views. Mapbox was considered because it offers strong vector map tooling and customizable styles, yet recurring usage costs and token-governed access create additional operational dependency for long-running dashboards. ArcGIS was considered for enterprise GIS depth, but its platform complexity exceeds current implementation needs. OpenStreetMap \+ Leaflet was therefore chosen for cost efficiency, integration flexibility, and direct alignment with the implemented web map architecture.
     For real-time operational visibility, websocket streaming with polling fallback was selected as a hybrid requirement. Server-Sent Events (SSE) was considered because it simplifies one-way streaming, but websocket transport better supports bidirectional session handling and live snapshot exchange patterns used in tracking views. Polling-only models were considered for implementation simplicity, but they introduce higher latency and unnecessary repeated requests for active command-center monitoring. The implemented websocket-plus-polling model balances responsiveness with continuity when persistent connections are interrupted.
     For deployment targets, the system uses a web-first core with Tauri (desktop) and Capacitor (Android) wrappers to meet cross-platform access requirements without maintaining separate business logic per platform. Electron was considered for desktop packaging because of mature tooling, but Tauri was preferred for a lighter runtime footprint and tighter security posture. React Native and fully native Android/desktop tracks were considered for platform-specific delivery, but they would require duplicate UI and integration maintenance. The chosen wrapper strategy preserves feature parity across Web, Desktop, and Android while reducing implementation divergence.
     For operational tooling, Docker/Compose, managed runtime deployment, and version-controlled release workflows were selected to satisfy reproducibility and maintainability requirements. Manual host-based installation was considered but increases environment drift and onboarding inconsistency. Alternative orchestration-heavy stacks (for example, immediate Kubernetes adoption) were considered excessive for current scale and capstone constraints. The selected tooling stack provides repeatable setup, traceable change history, and controlled release validation that directly supports the implemented system lifecycle.
**Requirements Documentation**
**     **Serves as the blueprint for the system’s development, defining the specific capabilities and quality standards necessary to modernize security operations for DASIA. It is divided into Functional Requirements, which detail the distinct tools and permissions for each user role (from high-level Superadmin oversight to Guard field actions), and Non-Functional Requirements, which establish the technical benchmarks for security, real-time performance, and legal compliance.

1. All Users
    - The system shall support administrator-mediated onboarding, verification, approval, secure authentication, password-reset workflows, role-based access control, mandatory legal-policy acceptance, cross-platform runtime delivery across Web, Windows desktop, and Android, and access to a release-oriented documentation portal.
2. Superadmin
    - The system shall provide superadmin users with command-level dashboards, shared quick Inbox workflows, AI-assisted decision-support outputs, ticketing and notification visibility, a feedback dashboard for aggregate and record-level review, audit-log visibility, and forensic audit intelligence for investigative review.
3. Admin
    - The system shall enable administrator users to govern personnel workflows, support scheduling and workforce coordination, manage firearm and armored vehicle lifecycle records, access command dashboards and quick Inbox workflows, handle operational ticketing and notifications, and submit authenticated feedback through the constrained feedback workflow.
4. Supervisor
    - The system shall enable supervisor users to monitor schedules, attendance, no-show conditions, and replacement actions; access real-time tracking, movement-history, active-deployment, and geofence-alert views; use command dashboards, quick Inbox workflows, and AI-assisted decision-support outputs; manage ticketing and notification workflows; and submit authenticated feedback.
5. Guard
    - The system shall enable guard users to access personal schedules and assigned resources, perform attendance-related actions, receive and respond to notifications, submit incident and support-related workflows, use self-scoped live tracking and movement-history features subject to policy and consent controls, access mission-critical field actions such as panic escalation, and submit authenticated feedback.

**Non-functional Requirements**

The non-functional requirements of SENTINEL emphasize security, performance, usability, reliability, scalability, and compliance traceability. In terms of security, the system shall enforce strong authentication, role-based authorization, approval-gated access, auditable security events, account-protection controls, and abuse-resistance measures to preserve the integrity of operational data and workflows. In terms of performance, the system shall maintain responsive dashboards and timely operational updates suitable for near-real-time supervisory decision-making. With respect to usability, the system shall provide role-centered dashboards and modular user-interface navigation that reduce operator context switching, while further minimizing workflow friction through the use of a shared quick Inbox action for urgent operational work and timeline context. In terms of reliability, the system shall maintain secure session continuity, renewal, and termination behaviors to protect ongoing operations. With respect to scalability, the system architecture shall remain API-driven and modular so that additional modules, integrations, and platform targets may be introduced without requiring a full redesign. Finally, for compliance traceability, legal acceptance and policy-governance events shall be recorded with timestamped metadata suitable for institutional review, accountability, and regulatory compliance.

![](docs/capstone/paper-media/img-07.png)Design of Software, System, Product, and/or Processes

Figure 8. Guard Activity Diagram

Figure 8 illustrates the Guard workflow from authentication to duty completion and secure logout. The flow first validates credentials, then verifies whether account approval and policy acceptance are already in a valid state; if a requirement is missing, the guard completes the required approval or acceptance step before dashboard access proceeds. From the mission-first guard dashboard, the process branches based on whether an active shift is available. If no active shift is assigned, the guard remains on non-duty activities such as reviewing alerts, sending support concerns, and updating profile details. If an active shift exists, the guard performs check-in, confirms location/device access for tracking, executes patrol or assigned field duty, and stays in a duty-monitoring loop. When an incident or urgent support event occurs, the guard submits an incident or panic/support escalation record, then returns to monitoring until check-out and session closure.

![](docs/capstone/paper-media/img-08.png)Figure 9. Supervisor Activity Diagram

Figure 9 presents the Supervisor workflow from authenticated access to end-of-session review. After login and access-state validation, the supervisor opens the dashboard to inspect schedules, attendance, and team status. The main control point is staffing-gap detection: when no-show, absence, or coverage gaps are detected, the supervisor initiates replacement coordination by selecting available personnel, issuing reassignment, and confirming deployment before updating operational status. When no immediate gap exists, the supervisor continues command monitoring activities, including incidents, alerts, and support workload. The workflow then moves to live tracking and team-performance review, with an escalation branch for operational issues that requires corrective action logging before returning to monitoring, followed by secure logout.

![](docs/capstone/paper-media/img-09.png)Figure 10. Administrator Activity Diagram

Figure 10 outlines the Administrator workflow as a governed control cycle rather than a single fixed sequence. After successful authentication and access-state checks, the administrator enters the command dashboard and selects the required management function: user/approval records, scheduling and assignment records, or asset/compliance records (firearm, permit, vehicle, and trip). After each management action, updates are reflected in the incident-support-notification queue and in dashboard analytics for operational visibility. If an operational or compliance issue is detected, the administrator applies corrective action, validates updated records, and returns to the management cycle. If no issue is detected, the administrator finalizes the current workset and closes the session through secure logout.

![](docs/capstone/paper-media/img-10.png)Figure 11. Superadmin Activity Diagram

![](docs/capstone/paper-media/img-11.png)Figure 11 describes the Superadmin workflow as a system-wide governance loop. After login and access-state validation, the superadmin enters the command dashboard and reviews global KPIs, service health, and high-level command status. The role then branches into governance controls: role and permission policy administration, audit-log and forensic review, and cross-module governance actions. The decision node checks for policy, security, or governance issues. When issues exist, policy/access changes are applied, validated across modules and user-role boundaries, and re-evaluated through updated global status review. When no issues are detected, strategic oversight approvals proceed and the superadmin exits through secure logout.
**Development**
     SENTINEL was developed through iterative Agile delivery in which user workflows, governance controls, and operational data services progressed in parallel.
     This module will serve as the secure authentication entry point of the platform. It will validate user credentials, enforce role-based access control, and route users to their authorized operational workspace.

Figure 12. User Login Module

![](docs/capstone/paper-media/img-12.png)This module will serve as the system governance layer for platform-wide control. The Superadmin will monitor global KPIs, review command-level operational status, and manage high-level oversight across all modules.

Figure 13. Superadmin Module

![](docs/capstone/paper-media/img-13.png)This module will serve as the operations management gateway for administrative execution. Administrators will manage users, approvals, schedules, and operational records while maintaining day-to-day system continuity.

Figure 14. Administrator Module

![](docs/capstone/paper-media/img-14.png)This module will serve as the field-supervision workspace for deployment coordination. Supervisors will monitor workforce status, assignments, and frontline execution conditions to maintain duty coverage.

Figure 15. Supervisor Module

![](docs/capstone/paper-media/img-15.png)This module will serve as the field-user workspace for assigned duty execution. Guards will review assignments, update duty actions, submit reports, and use emergency functions for real-time response support.

Figure 16. Guard Module

![](docs/capstone/paper-media/img-16.png)This module will serve as the controlled decision layer for requests requiring authorization. Authorized roles will review pending items and approve or reject requests to maintain policy compliance.

Figure 17. Approvals Module

![](docs/capstone/paper-media/img-17.png)This module will serve as the shift-planning and staffing coordination workspace. Command roles will create and manage duty schedules to ensure personnel availability and deployment readiness.

Figure 18. Scheduling Module

![](docs/capstone/paper-media/img-18.png)This module will serve as the timeline-based view of assignments and duty events. Users will review schedule distributions by date to improve planning visibility and conflict awareness.

Figure 19. Calendar Module

![](docs/capstone/paper-media/img-19.png)This module will serve as the geospatial command surface for operational monitoring. Authorized roles will view deployment context and location-based field information to support situational decision-making.

Figure 20. Calendar Module

![](docs/capstone/paper-media/img-20.png)This module will serve as the administrative records workspace for organizational control. Authorized roles will maintain user-related and operational management data required for system governance.

Figure 21. Management Module

![](docs/capstone/paper-media/img-21.png)This module will serve as the controlled ingestion channel for MDR-based operational records. Administrators will import, validate, and process structured workbook data into system-ready entries.

Figure 22. MDR Import Module

![](docs/capstone/paper-media/img-22.png)This module will serve as the mission coordination workspace for planning and execution tracking. Supervisors and command roles will manage mission records to sustain operational flow.

Figure 23. Missions Module

![](docs/capstone/paper-media/img-23.png)This module will serve as the trip lifecycle tracking workspace for field movement operations. Authorized users will record and monitor trip activities that support deployment and logistics execution.

Figure 24. Trips Module

![](docs/capstone/paper-media/img-24.png)This module will serve as the centralized communication panel for operational messages and workflow updates. Users will review incoming notifications and pending items that require attention.

Figure 25. Inbox Module

![](docs/capstone/paper-media/img-25.png)This module will serve as the internal assistance channel for operational and technical concerns. Users will submit and monitor support requests to resolve system or field-related issues.

Figure 26. Support Module

![](docs/capstone/paper-media/img-26.png)This module will serve as the structured user-input channel for usability and operational feedback. Users will submit feedback entries that support quality improvement and iterative refinement.

Figure 27. Feedback Submission Module

![](docs/capstone/paper-media/img-27.png)This module will serve as the consolidated review panel for submitted feedback. Superadmin users will evaluate feedback trends and prioritize action points for system improvement.

Figure 28. Feedback Dashboard Module

![](docs/capstone/paper-media/img-28.png)This module will serve as the firearm inventory monitoring workspace for controlled assets. Authorized roles will track firearm records, status conditions, and operational availability.

Figure 29. Firearms Module

![](docs/capstone/paper-media/img-29.png)This module will serve as the issuance and assignment control workspace for firearms. Authorized roles will allocate firearms to personnel while preserving assignment traceability.

Figure 30. Firearms Allocation Module

![](docs/capstone/paper-media/img-30.png)This module will serve as the permit compliance workspace for firearm documentation. Authorized roles will monitor permit validity and related regulatory records for compliance assurance.

Figure 31. Firearms Permits Module

![](docs/capstone/paper-media/img-31.png)This module will serve as the armored vehicle management workspace for transport assets. Authorized users will maintain vehicle records and deployment-relevant fleet details.

Figure 32. Armored Cars Module

![](docs/capstone/paper-media/img-32.png)This module will serve as the maintenance control workspace for operational assets. Authorized roles will track service activities and maintenance schedules to sustain readiness and minimize downtime.

Figure 33. Maintenance Module

![](docs/capstone/paper-media/img-33.png)This module will serve as the performance intelligence workspace for command assessment. Decision-makers will review utilization and operational metrics to support data-driven planning.

Figure 34. Analytics Module

![](docs/capstone/paper-media/img-34.png)This module will serve as the accountability and traceability workspace for system actions. Authorized roles will review activity logs and audit records for governance, compliance, and security review.

Figure 35. Audit Module

![](docs/capstone/paper-media/img-35.png)This module will serve as the account identity workspace for user-level information management. Users will review and update allowed profile details within role-specific access boundaries.

Figure 36. Profile Module

![](docs/capstone/paper-media/img-36.png)This module will serve as the configuration workspace for system and account preferences. Authorized users will manage applicable settings that influence workflow behavior and interface operation.

Figure 37. Settings Module

REFERENCES

**Abad, R. (2025).** How Effective Is Your Security Guard? An Inquiry into the Philippine Private Security Industry. Retrieved from [https://doi.org/10.13140/RG.2.2.30981.41442](https://doi.org/10.13140/RG.2.2.30981.41442)

**Aguinis, H. (2022).** *Performance Management (5th ed.).* SAGE Publications. Retrieved from [https://edge.sagepub.com/aguinispm5e](https://edge.sagepub.com/aguinispm5e)

**Al-Khafajiy, M., et al. (2022).** *Enabling high performance fog computing through fog-2-fog coordination model.* Future Generation Computer Systems. Retrieved from [https://doi.org/10.1016/j.future.2022.06.012](https://doi.org/10.1016/j.future.2022.06.012)

**Atlam, H. F., & Yang, Y. (2025).** *Enhancing Healthcare Security: A Unified RBAC and ABAC Risk-Aware Access Control Approach*. Retrieved from [https://doi.org/10.3390/fi17060262](https://doi.org/10.3390/fi17060262)

**Department of Information and Communications Technology (DICT). (2024).** National Cybersecurity Plan 2023-2028: A Whole-of-Nation Roadmap. Retrieved from [https://dict.gov.ph/national-cyber-security-plan](https://dict.gov.ph/national-cyber-security-plan)

**GetApp. (2026).** *Guardhouse 2026 Pricing, Features, Reviews & Alternatives*. Retrieved from [https://www.getapp.com/operations-management-software/a/guardhouse/](https://www.getapp.com/operations-management-software/a/guardhouse/)

**Guardhouse. (2026).** 2026 Pricing, Features, Reviews & Alternatives. Retrieved from [https://www.getapp.com/operations-management-software/a/guardhouse/](https://www.getapp.com/operations-management-software/a/guardhouse/)

**Hardcat. (2025).** *Law Enforcement Equipment & Armory Management System: Challenges in Managing Firearms Securely*. Retrieved from [https://hardcat.com/police-equipment-inventory-tracking/](https://hardcat.com/police-equipment-inventory-tracking/)

**Jur.ph. (2025).** The Private Security Services Industry Act: Law Summary and IRR. Retrieved from [https://jur.ph/law/summary/the-private-security-services-industry-act](https://jur.ph/law/summary/the-private-security-services-industry-act)

**Khinvasara, T., Shankar, A., & Wong, C. (2024).** Survey of Artificial Intelligence for Automated Regulatory Compliance Tracking. Retrieved from [https://doi.org/10.9734/jerr/2024/v26i71217](https://doi.org/10.9734/jerr/2024/v26i71217)

**NashTech. (2025).** Building High-Performance Web Services with Rust and Axum. Retrieved from [https://blog.nashtechglobal.com/building-high-performance-web-services-with-rust-and-axum/](https://blog.nashtechglobal.com/building-high-performance-web-services-with-rust-and-axum/)

**NEDA XI. (2024)**. Davao Regional Development Plan 2023-2028. National Economic and Development Authority. Retrieved from [https://rdc11.neda.gov.ph/rdc-xi-approves-davao-regional-development-plan-2023-2028/](https://rdc11.neda.gov.ph/rdc-xi-approves-davao-regional-development-plan-2023-2028/)

**Nguyen, R. (2025).** PostgreSQL ACID In-Depth: Reliability and Consistency in Modern Transactions. Retrieved from [https://medium.com/engineering/postgresql-acid-in-depth](https://www.google.com/search?q=https://medium.com/engineering/postgresql-acid-in-depth)

**NODE Magazine. (2026).** *Why 2026 is the Year Businesses Must Finally Address Admin Overload*. Retrieved from [https://www.node-magazine.com/thoughtleadership/why-2026-is-the-year-businesses-must-finally-address-admin-overload](https://www.node-magazine.com/thoughtleadership/why-2026-is-the-year-businesses-must-finally-address-admin-overload)

**Ondos, M. U., & Origines, D. V. (2025).** *Android-Based Guard Monitoring and Site Surveillance System*. Retrieved from [https://www.ojs.udb.ac.id/icohetech/article/view/5657](https://www.ojs.udb.ac.id/icohetech/article/view/5657) 

**PIA. (2025).** *Davao City Maintains Top Safety Ranking in Southeast Asia*. Philippine Information Agency. Retrieved from [https://pia.gov.ph/news/davao-city-maintains-top-safety-ranking-in-southeast-asia/](https://pia.gov.ph/news/davao-city-maintains-top-safety-ranking-in-southeast-asia/) 

**PostgreSQL Global Development Group. (2025).** PostgreSQL 17 Documentation: Data Integrity and ACID Compliance. Retrieved from [https://www.postgresql.org/docs/17/acid.html](https://www.google.com/search?q=https://www.postgresql.org/docs/17/acid.html)

**PNP-SOSIA. (2022).** Implementing Rules and Regulations of Republic Act No. 11917. Retrieved from [https://www.scribd.com/document/691228276/Approved-IRR-RA-11917](https://www.scribd.com/document/691228276/Approved-IRR-RA-11917)

**Republic Act No. 11917. (2022).** The Private Security Services Industry Act. Retrieved from [https://elibrary.judiciary.gov.ph/thebookshelf/showdocs/2/95597](https://elibrary.judiciary.gov.ph/thebookshelf/showdocs/2/95597)

**Scofield, M. B. (2025).** Rust Axum Web Development: Build High-Performance APIs and Services. Retrieved from [https://www.amazon.com/Rust-Axum-Web-Development-High-Performance/dp/B0CX7N4K6J](https://www.google.com/search?q=https://www.amazon.com/Rust-Axum-Web-Development-High-Performance/dp/B0CX7N4K6J)

**Securitas. (2026).** *Control Security from Anywhere - MySecuritas Product Overview*. Retrieved from [https://www.securitas.com/en/security-solutions/mysecuritas/](https://www.google.com/search?q=https://www.securitas.com/en/security-solutions/mysecuritas/)

**Securitas Technology. (2025).** *2026 Global Technology Outlook Report: The State of Security Technology*. Retrieved from [https://www.securitastechnology.com/news/securitas-technology-releases-2026-global-technology-outlook-report](https://www.securitastechnology.com/news/securitas-technology-releases-2026-global-technology-outlook-report)

**Shiyanbola, J. O., et al. (2023).** *A Workforce Capacity Optimization Model for Lean Environments.* Retrieved from [https://www.irejournals.com/paper-details/1704408](https://www.irejournals.com/paper-details/1704408)

**Tan, K., et al. (2024).** *The digital transformation of security and the role of AI.* *Securitas White Paper.* Retrieved from [https://www.securitas.ie/news-insights/whitepapers/the-digital-transformation-of-security-and-the-role-of-ai/](https://www.securitas.ie/news-insights/whitepapers/the-digital-transformation-of-security-and-the-role-of-ai/)

**TrackTik. (2025).** *Top 5 End-to-End Security Guard Management Software for 2025.* Retrieved from https://www.tracktik.com/resources/blog-articles/top-5-end-to-end-security-guard-management-software-for-2025/

**TrackTik. (2025).** *Physical Security Operations Benchmark Report 2025*. Retrieved from [https://www.tracktik.com/wp-content/uploads/2025/10/2025BenchmarkReport-1.pdf](https://www.tracktik.com/wp-content/uploads/2025/10/2025BenchmarkReport-1.pdf)

