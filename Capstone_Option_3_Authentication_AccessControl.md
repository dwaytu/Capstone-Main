# CAPSTONE OPTION 3

# Integrated Security Personnel Authentication and Access Control System

## CHAPTER 1: INTRODUCTION

### 1.1 Project Context

Security personnel management in Philippine armed security agencies involves complex organizational hierarchies and access control requirements (Philippine National Police, 2022). Personnel operate across multiple roles including guards, supervisors, administrators, and system managers. Each role requires different system capabilities and data access permissions. Additionally, as security agencies grow and expand operations, particularly in emerging economic centers like Tagum City in Davao del Norte (Davao del Norte Provincial Government, 2024), maintaining accurate personnel records, managing credentials, and controlling access to sensitive information becomes increasingly challenging (International Security Industry Association, 2023).

Current personnel management practices in many security agencies suffer from several critical issues. Personnel records may be scattered across multiple systems, spreadsheets, or paper files, making it difficult to maintain current information and identify inconsistencies through fragmented user management. Many systems rely on basic username and password combinations without verification mechanisms, making accounts vulnerable to unauthorized access and weak authentication attacks. Without proper role-based access control, personnel may have access to information or functions beyond their job requirements, creating security risks and limiting operational oversight. There is no standardized way to create, verify, reset, and manage credentials for personnel across the organization, leading to credential management challenges and inconsistent security practices. Many agencies lack comprehensive audit trails showing who accessed what information and when, making compliance verification difficult and hindering security investigations. New personnel require manual account creation, credential distribution, and permission assignment, creating onboarding inefficiencies that result in delays and potential errors. Security personnel require various licenses and certifications (e.g., PNP security guard license, firearms handling certification) that are typically tracked manually in paper files, creating challenges for license and certification tracking and compliance verification.

Modern security infrastructure demands a centralized, secure, and automated solution for managing personnel authentication, access control, and credential verification. Such a system would reduce security risks, improve operational efficiency, and ensure compliance with data protection and access control standards.

### 1.2 Purpose and Description

The primary purpose of this project is to design and develop an integrated Security Personnel Authentication and Access Control System that provides centralized user management, secure authentication, and role-based access control for armed security agencies.

The Integrated Security Personnel Authentication and Access Control System is a web-based application that serves as the central identity and access management platform for security agencies. It provides:

1. **Centralized User Management**: A comprehensive database of all personnel including guards, supervisors, and administrators with complete profile information. Each user record includes personal details, contact information, role assignments, and license information.

2. **User Registration and Onboarding**: Administrators can register new personnel in the system, assign roles, and automatically generate temporary credentials. The system provides a structured onboarding workflow.

3. **Secure Authentication**: Personnel authenticate using email and password combination. The system implements security best practices including password hashing, salting, and strength requirements.

4. **Email Verification**: New users must verify their email address through a verification code sent to their registered email. This ensures email validity and authorized account creation.

5. **Credential Management**: Users can request password resets, which trigger the email verification process. Administrators can generate new credentials for personnel as needed.

6. **Role-Based Access Control**: The system defines multiple roles (Guard, Supervisor, Administrator, Superadmin) with specific permissions and data access levels. Each role has predefined access to different system features and data.

7. **Personnel Profile Management**: Users can view and update their own profile information including contact details. Administrators can modify any personnel record.

8. **License and Certification Tracking**: The system maintains records of security-related licenses and certifications including license type, license number, and expiration dates for compliance verification.

9. **User Activity Audit Log**: The system maintains comprehensive logs of user authentication events, data access, and system modifications for security and compliance auditing.

10. **Account Status Management**: Administrators can activate, deactivate, or suspend user accounts. Deactivated accounts cannot access system resources.

11. **Multi-level Authorization**: Different system modules and data sets are protected with different authorization levels ensuring personnel only access information appropriate to their roles.

12. **Permission Management**: Administrators can manage permissions for users, adding or removing specific capabilities beyond their base role as needed.

### 1.3 Objectives

**General Objective:**
To develop an integrated Security Personnel Authentication and Access Control System that provides centralized, secure, and role-based management of personnel identities and system access for armed security agencies.

**Specific Objectives:**

1. To create a centralized personnel database that maintains complete and current information on all security agency personnel including personal details and role assignments.

2. To implement a secure user registration and onboarding process that streamlines account creation while ensuring proper authorization and verification.

3. To develop a secure authentication system implementing industry-standard cryptographic practices for password storage and verification.

4. To implement an email verification mechanism ensuring that registered email addresses are valid and controlled by authorized personnel.

5. To create a password reset and credential recovery system that maintains security while allowing legitimate users to regain access.

6. To design and implement a comprehensive role-based access control system with predefined roles and permissions for different personnel categories.

7. To develop a personnel profile management module allowing users to view and update their information while enabling administrators to manage all personnel records.

8. To create a license and certification tracking system that maintains records of required credentials and alerts administrators to upcoming expirations.

9. To implement comprehensive audit logging of authentication events, access attempts, and system modifications for compliance and security investigations.

10. To provide administrators with account management capabilities including account activation, deactivation, and suspension.

11. To establish permission management capabilities allowing granular control over user access rights beyond standard role definitions.

12. To ensure all authentication and access control operations comply with data protection standards and security best practices.

### 1.4 Scope and Limitations

**Scope:**

The Integrated Security Personnel Authentication and Access Control System includes the following features and components:

**In Scope:**
- Centralized user database with personnel information storage
- User registration and onboarding workflow
- Email-based user verification
- Secure authentication with password hashing and verification
- Password reset and credential recovery functionality
- Role-based access control implementation
- Personnel profile viewing and editing
- License and certification tracking
- Account status management (activate/deactivate/suspend)
- Comprehensive audit logging of authentication and access events
- Administrator permission management
- Email notification system for verification and notifications
- RESTful API for backend operations
- Role-based view restrictions in web frontend
- Expiration date tracking for credentials and licenses

**Out of Scope:**
- Biometric authentication (fingerprint, facial recognition)
- Multi-factor authentication (MFA) or two-factor authentication (2FA)
- Single sign-on (SSO) integration with external identity providers
- LDAP or Active Directory integration
- Integration with government ID databases
- Automated credential distribution through physical mail
- Integration with email servers for direct email management
- Blockchain-based identity verification
- Passwordless authentication mechanisms

**Limitations:**

1. **Email Dependency**: The system relies on email for user verification and password recovery. Users without reliable email access may have difficulty with account verification.

2. **Manual Verification**: Email verification requires users to manually check their email and enter a code. There is no automatic email forwarding or email management.

3. **Password Security**: Security depends on users choosing strong passwords. The system enforces password requirements but cannot prevent weak user choice.

4. **No Biometric Security**: The system provides credential-based authentication only and does not include biometric verification methods.

5. **Single Timezone**: The system operates in a single timezone. Multi-timezone support for international operations is not included.

6. **Limited Integration**: The system operates independently and does not integrate with external identity providers or government systems.

7. **Manual License Entry**: Security licenses and certifications must be manually entered and updated. There is no automatic verification with issuing authorities.

8. **Audit Log Volume**: Comprehensive audit logging generates large data volumes that may impact system performance in scenarios with very high user activity.

### 1.5 Background of the Study

The security industry in the Philippines is highly regulated with multiple overlapping jurisdictions and requirements where armed security personnel must comply with rules set by the Armed Forces of the Philippines (AFP), the Philippine National Police (PNP), regional government units, and individual client organizations. This complex regulatory environment means that security agencies must maintain detailed and accurate personnel records and access documentation. Modern security standards, particularly those aligned with ISO 27001 (Information Security Management) and similar frameworks, require centralized identity management, documented access control policies, comprehensive audit trails, and secure credential management.

Additionally, many security agencies are expanding their operations rapidly, adding new personnel and managing increasing system complexity. The limitations of manual and fragmented identity management become increasingly apparent through current industry challenges including personnel records scattered across multiple systems and paper files, difficulty ensuring all personnel have required licenses and certifications, time-consuming manual account creation and permission assignment, limited ability to audit who accessed what information and when, security risks from weak or shared credentials, and difficulty handling personnel transfers, role changes, or departures. Industry transformation drivers including client organizations increasingly requiring secure access control for vendor personnel, regulatory agencies expecting agencies to demonstrate proper access controls, data protection laws creating liability for unauthorized data access, competition incentivizing agencies to adopt modern systems, and personnel expecting self-service capabilities for profile management and password resets are accelerating the need for modern solutions.

This project addresses these critical needs (National Institute of Standards and Technology, 2025; Open Worldwide Application Security Project, 2026) by developing a modern, secure, and user-friendly authentication and access control system specifically designed for the Philippine security industry context. The system enables agencies to transition from fragmented, manual processes to centralized, automated, and auditable identity and access management.

### 1.6 References

Davao del Norte Provincial Government. (2024). *Davao del Norte development and economic profile*. Provincial Planning and Development Office, Tagum City.

International Security Industry Association. (2023). *Global security industry insights and trends report 2023*. Retrieved from https://www.isiaglobal.com/

National Institute of Standards and Technology. (2025). *Cybersecurity framework and implementation guidance* (NIST SP 800-53 Rev. 5). Retrieved from https://csrc.nist.gov/publications/detail/sp/800-53/rev-5/final

Open Worldwide Application Security Project. (2026). *OWASP: Open Worldwide Application Security Project resources and guidelines*. Retrieved from https://owasp.org/

Philippine National Police. (2022). *Armed security personnel qualification and training standards*. Bureau of Internal Affairs, Philippine National Police.
