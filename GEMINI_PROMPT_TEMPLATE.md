# Template: How to Ask Gemini About SENTINEL

## Step 1: Copy-Paste This Template to Gemini

Replace `[YOUR QUESTION]` with your actual question. Always include the context reference first.

---

```
SYSTEM CONTEXT REFERENCE:
Please refer to the complete SENTINEL system documentation available at:
FILE: d:\Capstone Main\GEMINI_SYSTEM_CONTEXT_PROMPT.md
QUICK REFERENCE: d:\Capstone Main\GEMINI_QUICK_REFERENCE.md

Current System Date: February 27, 2026
Organization: Davao Security & Investigation Agency, Inc.
System Status: Production-Ready (24-day operational simulation completed)

Key Context Points:
- Backend: Rust/Axum + PostgreSQL
- Frontend: React 18.2/TypeScript + Tailwind CSS
- User Roles: 4 (User, Admin, Superadmin, System)
- API Endpoints: 100+
- Database Tables: 20+ relational tables
- Regulatory Compliance: RA 11917 (Philippine security law)
- Recent Fixes: CalendarDashboard mobile nav + backend error handling (Feb 27, 2026)

---

QUESTION:

[YOUR QUESTION]

Please provide:
- Specific code examples where applicable
- Reference the relevant database tables/API endpoints
- Consider all 4 user roles and their permissions
- Align with RA 11917 compliance requirements if relevant
- Consider the 24/7 operational context
```

---

## Step 2: Example Questions to Ask

### Example 1: Bug Investigation
```
I'm seeing an issue where [symptom]. Can you:
1. Identify the likely root cause
2. Reference the specific code files and line numbers
3. Suggest a fix with code examples
4. Verify it works with the rest of the system
```

### Example 2: Feature Development
```
I need to implement [feature]. Please:
1. Design the database schema changes needed
2. List all API endpoints required
3. Identify which React components need updates
4. Specify which user roles have access
5. Consider any compliance implications
6. Provide step-by-step implementation guide
```

### Example 3: Performance Optimization
```
The system is experiencing [performance issue]. Can you:
1. Analyze the architecture (Rust/Axum, PostgreSQL connection pool)
2. Identify the bottleneck
3. Propose optimization approaches
4. Provide code changes
5. Estimate improvement impact
```

### Example 4: Integration Question
```
How should [module 1] integrate with [module 2]? Please:
1. Reference existing patterns in the codebase
2. Show data flow diagrams
3. List API contracts
4. Consider role-based access control
5. Provide implementation example
```

### Example 5: Compliance/Regulatory
```
How does the system handle [regulatory requirement from RA 11917]? Please:
1. Explain current implementation
2. Verify compliance adequacy
3. Suggest improvements if needed
4. Reference relevant database tables/API endpoints
```

---

## Step 3: Specific Question Templates

### 🗄️ Database-Related Questions
```
SYSTEM CONTEXT: [Include template above]

Regarding the [table_name] table:
- What are the relationships to other tables?
- How is this data used in workflows?
- What are the validation rules?
- Which API endpoints interact with this table?
- Which user roles can access this data?
```

### 🔌 API-Related Questions
```
SYSTEM CONTEXT: [Include template above]

Regarding the [ENDPOINT] endpoint:
- What are the request/response schemas?
- Which roles can access this endpoint?
- What validations are performed?
- How does this integrate with other endpoints?
- What are the potential error cases?
```

### 🎨 Frontend Component Questions
```
SYSTEM CONTEXT: [Include template above]

Regarding the [ComponentName] component:
- What state does it manage?
- Which API endpoints does it call?
- How does it handle mobile responsiveness?
- What user roles can access it?
- What are the known issues or limitations?
```

### ⚙️ Workflow-Related Questions
```
SYSTEM CONTEXT: [Include template above]

Regarding the [WORKFLOW_NAME] workflow (e.g., "No-Show Detection"):
- What are the detailed steps?
- Which database tables involved?
- What are the success/failure conditions?
- How are errors handled?
- What automation happens?
- Can this be optimized?
```

### 🐛 Bug Investigation Questions
```
SYSTEM CONTEXT: [Include template above]

I found a bug: [DESCRIPTION]
Observed behavior: [ACTUAL]
Expected behavior: [EXPECTED]
Affected component/endpoint: [WHERE]
Steps to reproduce: [HOW]

Can you:
1. Identify the root cause
2. Show the problematic code
3. Provide a fix with test cases
4. Verify it doesn't break other components
```

### ✨ Feature Request Questions
```
SYSTEM CONTEXT: [Include template above]

Feature Request: [DESCRIPTION]
Business Requirement: [WHY]
Target Users: [WHO]
Success Criteria: [MEASUREMENT]

Please provide:
1. Architecture design (database, API, frontend)
2. Implementation roadmap
3. Code examples
4. Testing strategy
5. Compliance considerations
6. Performance impact
```

---

## Step 4: What Info to Include

### ALWAYS Include
- ✓ System context reference (template at top)
- ✓ Specific file names or component names
- ✓ Current date context (February 27, 2026)
- ✓ Relevant error messages or logs
- ✓ User role context (if permission-related)
- ✓ Any recent changes or fixes relevant to the question

### GOOD To Include
- ✓ Code snippets showing current implementation
- ✓ Expected vs actual behavior
- ✓ Steps to reproduce (for bugs)
- ✓ Performance metrics (if relevant)
- ✓ Compliance requirements (if relevant)

### AVOID
- ✗ Vague descriptions ("It's broken")
- ✗ Asking without context reference
- ✗ Multi-unrelated questions (1 per prompt)
- ✗ Outdated information (verify against Feb 27 context)
- ✗ Assuming Gemini knows SENTINEL details (always provide context)

---

## Step 5: Follow-Up Questions

After getting an answer, you can ask follow-ups without re-quoting the full context:

```
Thanks for that answer. Follow-up question:
[SPECIFIC FOLLOW-UP]

Based on your previous response about [TOPIC], I need clarification on...
```

---

## Step 6: Common Patterns for Specific Scenarios

### "Help me understand how X works"
```
SYSTEM CONTEXT: [Include top template]

Can you explain how [FEATURE/WORKFLOW] works in SENTINEL?

Include in your explanation:
1. High-level overview
2. Data structures involved
3. Key API endpoints
4. Step-by-step execution flow
5. Error handling
6. User roles that interact with this
7. Compliance implications (if any)
8. Performance considerations
```

### "I need to modify X, what breaks?"
```
SYSTEM CONTEXT: [Include top template]

I need to modify [COMPONENT/TABLE/ENDPOINT]:
Change: [WHAT]
Reason: [WHY]
Expected Impact: [WHAT_CHANGES]

What downstream effects will this have on:
- Database queries
- API responses
- Frontend components
- User workflows
- Compliance/audit trails
- Performance
- Other integrations

Provide specific files, line numbers, and code examples for all breaking changes.
```

### "The system has a performance issue"
```
SYSTEM CONTEXT: [Include top template]

Performance Issue:
Symptom: [WHAT_IS_SLOW]
Affected Component: [WHERE]
Current Performance: [METRICS]
Acceptable Performance: [TARGET]
Impact on Users: [HOW_AFFECTS_USERS]

Diagnosis needed:
1. Root cause analysis
2. Current system bottleneck
3. Database query optimization
4. Caching opportunities
5. Architecture changes needed
6. Short-term vs long-term fixes
7. Estimated improvement

Provide code examples for top 3 recommendations.
```

### "How do we implement compliance requirement X?"
```
SYSTEM CONTEXT: [Include top template]

Compliance Requirement: [FROM_RA_11917]
Requirement Details: [EXACT_TEXT]
Current Implementation: [WHAT_WE_HAVE]
Gaps: [WHAT_WE_NEED]

Questions:
1. Is current implementation sufficient?
2. What code changes are needed?
3. What database changes are needed?
4. What audit logging is required?
5. How do we verify compliance?
6. What are failure scenarios?
7. How do we document compliance for regulators?
```

---

## Step 7: Gemini Response Best Practices

When Gemini responds, you can ask for:

```
I'd also like you to:
- [ ] Provide the complete modified file content
- [ ] Include before/after code comparison
- [ ] Add inline code comments explaining the changes
- [ ] Create test cases showing this works
- [ ] Suggest how to deploy this change
- [ ] Explain any new dependencies needed
- [ ] Show database migration commands (if applicable)
- [ ] Provide frontend component examples
- [ ] Estimate testing time required
- [ ] Flag any security implications
```

---

## Quick Copy-Paste Prompt Template

Save this and use it for every Gemini question:

```
SENTINEL SYSTEM CONTEXT (February 27, 2026):
Docs: d:\Capstone Main\GEMINI_SYSTEM_CONTEXT_PROMPT.md
Quick Ref: d:\Capstone Main\GEMINI_QUICK_REFERENCE.md

System: Integrated Security Operations Platform (Davao Security & Investigation Agency)
Backend: Rust/Axum + PostgreSQL | Frontend: React/TypeScript + Tailwind
User Roles: User, Admin, Superadmin, System | Endpoints: 100+ | Tables: 20+
Compliance: RA 11917 (Philippine security law) | Status: Production (24-day tested)
Recent Fixes: CalendarDashboard mobile (Feb 27), Backend error handling (Feb 27)

QUESTION:
[TYPE YOUR QUESTION HERE]

PLEASE PROVIDE:
- Specific code and file references
- Database table/API endpoint context
- All 4 user roles considered
- Compliance implications if relevant
```

---

## Example: Using This for Your First Question

Here's a complete example you could send to Gemini right now:

```
SENTINEL SYSTEM CONTEXT (February 27, 2026):
Docs: d:\Capstone Main\GEMINI_SYSTEM_CONTEXT_PROMPT.md
Quick Ref: d:\Capstone Main\GEMINI_QUICK_REFERENCE.md

System: Integrated Security Operations Platform (Davao Security & Investigation Agency)
Backend: Rust/Axum + PostgreSQL | Frontend: React/TypeScript + Tailwind
User Roles: User, Admin, Superadmin, System | Endpoints: 100+ | Tables: 20+
Compliance: RA 11917 (Philippine security law) | Status: Production (24-day tested)
Recent Fixes: CalendarDashboard mobile (Feb 27), Backend error handling (Feb 27)

QUESTION:
What are the top 5 performance bottlenecks in the current SENTINEL system, and how would you optimize each one?

PLEASE PROVIDE:
- Specific code files to audit
- Database query analysis
- Concurrent load stress points
- Recommended architectural changes
- Implementation priority (quick wins first)
```

This should generate a high-quality, specific response from Gemini.

---

**Document Created**: February 27, 2026
**Purpose**: Guide users to ask optimal questions to Gemini AI about SENTINEL
**Expected Result**: More accurate, detailed, and context-aware responses
