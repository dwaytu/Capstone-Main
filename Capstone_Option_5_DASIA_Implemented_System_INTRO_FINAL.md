# DASIA: AN INTEGRATED SECURITY OPERATIONS MANAGEMENT PLATFORM FOR DAVAO SECURITY & INVESTIGATION AGENCY, INC.

## CHAPTER 1: INTRODUCTION

### 1.1 Project Context

Armed security agencies in the Philippines operate under Philippine National Police (PNP) regulatory oversight managing complex operational functions including personnel deployment, equipment allocation, vehicle logistics, and incident response. Traditional security operations management relies on fragmented systems—separate platforms for personnel scheduling, equipment tracking, and vehicle management, or manual coordination through spreadsheets. This fragmentation creates operational inefficiencies including scheduling conflicts, equipment accountability gaps, inability to coordinate rapid personnel replacements, and incomplete audit trails.

Enterprise Resource Planning (ERP) systems address similar integration challenges by consolidating business processes and enabling real-time information access (O'Brien, 2011). Applied to security operations, an integrated platform provides comprehensive workforce management, integrated equipment lifecycle tracking with audit logging, and unified operational visibility. This aligns with broader organizational digital transformation trends, where 71% of organizations in the United States have adopted advanced digital technologies to improve operational efficiency (European Investment Bank, 2022).

### 1.2 Purpose and Description

The primary purpose of this capstone project is to deliver a fully functional, production-ready Integrated Security Operations Management Platform that consolidates guard personnel management, equipment allocation, vehicle operations, and access control into a unified system.

DASIA is a comprehensive web-based application with a Rust/Axum backend API, PostgreSQL database, and React/TypeScript frontend with responsive design, deployed via Docker containerization. The platform provides core modules for: (1) Guard Management—shift scheduling, attendance tracking, performance monitoring, and replacement coordination ensuring continuous personnel coverage; (2) Equipment Management—firearm inventory, allocation workflows, permit tracking, and maintenance scheduling complying with PNP licensing requirements; (3) Vehicle Operations—armored car fleet management, vehicle allocation, driver assignment with certification verification, and trip tracking; and (4) Access Control—role-based permissions, authentication, and comprehensive audit logging. The system has been validated through 24-day operational simulation covering 24 distinct business scenarios and resolving 15+ production issues.

### 1.3 Objectives

**General Objective:**
To deliver a fully implemented, tested, and production-ready Integrated Security Operations Management Platform that unifies personnel management, equipment allocation, vehicle operations, and access control into a single robust system with proven reliability through comprehensive operational simulation.

**Specific Objectives:**

1. To integrate guard management, firearm tracking, and vehicle operations into a seamlessly connected platform with real-time data synchronization.

2. To implement automated workflows for scheduling, equipment allocation, and replacement coordination reducing manual coordination overhead.

3. To establish role-based access control with distinct permission levels ensuring appropriate data access and operational boundaries.

4. To provide real-time operational monitoring through role-specific dashboards offering unified situational awareness.

5. To implement comprehensive audit logging for all critical operations supporting regulatory compliance and incident investigations.

6. To develop performance analytics and reporting systems enabling data-driven operational decisions.

7. To ensure production reliability through comprehensive testing including 24-day operational simulation covering 24 distinct business scenarios.

8. To provide mobile-responsive interfaces enabling secure operation from any device for field personnel and administrators.

9. To implement robust error handling, input validation, and data consistency mechanisms preventing data corruption and system instability.

10. To deliver comprehensive documentation supporting future system maintenance and enhancement.

### 1.4 Scope and Limitations

**Implemented and Fully Functional:**
- Guard personnel management (profiles, shift scheduling, attendance, performance tracking)
- Firearm inventory and allocation workflows
- Armored vehicle fleet management and trip tracking
- Role-based access control (four permission levels)
- Attendance and compliance reporting
- Real-time operational dashboards
- Support ticket system
- Email-based authentication with verification

**Validated Through Comprehensive Testing:**
- 24-day operational simulation covering 24 distinct business scenarios
- Automated no-show detection and replacement workflow
- Real-time performance analytics and reporting
- 15+ production issues identified and resolved
- Edge case and error condition handling

**Limitations and Future Enhancements:**
- GPS real-time vehicle location tracking not implemented  
- No integration with external payroll or HR systems
- Web-responsive design only (no native mobile application)
- Advanced machine learning predictive analytics not included
- Biometric authentication not implemented
- Multi-timezone support not provided
- Third-party security equipment integration (cameras, sensors) not included

### 1.5 Review of Related Literature

**Enterprise Resource Planning Systems**
Enterprise Resource Planning (ERP) systems integrate multiple business functions—finance, human resources, supply chain management, and operations—into unified systems sharing common databases (O'Brien, 2011). ERP principles apply directly to security operations, where separate systems for personnel, equipment, and vehicles prevent holistic management. Research on public sector implementations identifies cultural factors and organizational change management as critical success elements applicable to security agencies (Chang, Gable, Smythe, & Timbrell, 2000).

**Workforce Management**
Workforce Management (WFM) systems optimize personnel productivity and engagement through automated scheduling, forecasting, and performance management (Wikipedia, 2025). Modern approaches emphasize not only cost reduction but also employee engagement and work-life balance. Field service management principles—applying WFM to geographically dispersed operations—directly apply to security personnel management across multiple client sites (Wikipedia, 2025).

**Digital Transformation and Operations Management**
Digital transformation extends beyond isolated system implementations to fundamental organizational redesign using digital technologies (Vial, 2019). For security operations, transformation encompasses process automation, data integration, real-time visibility, and compliance automation. Research identifies the TOP framework addressing transformation success: Technology (appropriate systems and infrastructure), Organization (cultural and governance changes), and People (workforce skill development) (Wamba & Queiroz, 2022).

**Security Operations and Access Control**
Security management addresses protection of physical assets, information, and operations through systematic risk management (Schneier, 2008). Role-based access control represents a foundational principle, enabling appropriate operational boundaries and audit capability (Mead & Goel, 2012). Comprehensive logging and monitoring support regulatory compliance and incident investigations (NIST, 2013).

**Technology Stack Literature**
Rust programming language emphasis on memory safety and thread safety reduces common security vulnerabilities in systems code (Klabnik & Nichols, 2023). React's component-based architecture enables maintainable, testable user interface development (Meta Platforms, Inc., 2024). PostgreSQL's advanced features enable efficient modeling of relational security operations data (PostgreSQL Global Development Group, 2024). Docker containerization facilitates reproducible deployment across environments (Docker Inc., 2023).

---

## CHAPTER 2: SYSTEM IMPLEMENTATION DETAILS
