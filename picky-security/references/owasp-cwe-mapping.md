# OWASP & CWE Reference Mapping

## Quick Reference for Security Findings

This document maps common vulnerabilities to their OWASP and CWE identifiers for standardized reporting.

---

## OWASP Top 10 (2025)

### A01:2025 - Broken Access Control
**Remains #1. Now absorbs SSRF (previously A10:2021).**

| Vulnerability | CWE | Description |
|--------------|-----|-------------|
| IDOR | CWE-639 | Access to unauthorized objects via ID manipulation |
| Path Traversal | CWE-22 | Accessing files outside intended directory |
| Privilege Escalation | CWE-269 | Gaining unauthorized privileges |
| Missing Function Level Access | CWE-285 | Unprotected admin functions |
| CORS Misconfiguration | CWE-942 | Overly permissive cross-origin |
| Forced Browsing | CWE-425 | Accessing unlinked pages |
| JWT Token Manipulation | CWE-284 | Modifying token claims |
| SSRF | CWE-918 | Server makes request to attacker-controlled URL |
| Cloud Metadata Access | CWE-918 | Accessing 169.254.169.254 |
| Internal Service Access | CWE-918 | Accessing internal APIs |

### A02:2025 - Security Misconfiguration
**Moved up from #5 in 2021. Includes XXE.**

| Vulnerability | CWE | Description |
|--------------|-----|-------------|
| Default Credentials | CWE-1188 | Unchanged default passwords |
| Debug Enabled in Prod | CWE-489 | Debug features exposed |
| Missing Security Headers | CWE-693 | No CSP, HSTS, etc. |
| Verbose Errors | CWE-209 | Stack traces exposed |
| XXE | CWE-611 | XML external entity |
| Open Cloud Storage | CWE-284 | Public S3 buckets |
| Directory Listing | CWE-548 | Index of exposed |
| Unnecessary Features | CWE-1188 | Unused services enabled |

### A03:2025 - Software Supply Chain Failures
**New in 2025. Expanded from A06:2021 "Vulnerable Components" to cover full supply chain.**

| Vulnerability | CWE | Description |
|--------------|-----|-------------|
| Known Vulnerable Dependency | CWE-1395 | Outdated packages with known CVEs |
| Unmaintained Component | CWE-1104 | Abandoned libraries |
| Non-Updateable Component | CWE-1329 | Dependency that cannot be updated |
| Insufficiently Trustworthy Component | CWE-1357 | Unvetted or suspicious packages |
| Obsolete Function Usage | CWE-477 | Using deprecated/obsolete functions |
| Compromised Build Pipeline | CWE-829 | Malicious changes in CI/CD or distribution |
| Component Without License | N/A | Legal/security risk |

### A04:2025 - Cryptographic Failures
**Moved down from #2 in 2021.**

| Vulnerability | CWE | Description |
|--------------|-----|-------------|
| Weak Hashing | CWE-328 | MD5/SHA1 for passwords |
| Insufficient Entropy | CWE-331 | Predictable random values |
| Cleartext Storage | CWE-312 | Unencrypted sensitive data |
| Cleartext Transmission | CWE-319 | HTTP instead of HTTPS |
| Missing Encryption | CWE-311 | Sensitive data not encrypted |
| Hardcoded Credentials | CWE-798 | Secrets in source code |
| Weak Key Generation | CWE-326 | Insufficient key size |

### A05:2025 - Injection
**Moved down from #3 in 2021. Includes XSS.**

| Vulnerability | CWE | Description |
|--------------|-----|-------------|
| SQL Injection | CWE-89 | SQL command injection |
| NoSQL Injection | CWE-943 | MongoDB/similar injection |
| Command Injection | CWE-78 | OS command injection |
| LDAP Injection | CWE-90 | LDAP query injection |
| XPath Injection | CWE-643 | XML path injection |
| XSS (Reflected) | CWE-79 | Reflected script injection |
| XSS (Stored) | CWE-79 | Persistent script injection |
| XSS (DOM) | CWE-79 | Client-side script injection |
| Template Injection | CWE-94 | Server-side template injection |
| Header Injection | CWE-113 | HTTP header injection |
| Log Injection | CWE-117 | Log entry injection |

### A06:2025 - Insecure Design
**Moved down from #4 in 2021.**

| Vulnerability | CWE | Description |
|--------------|-----|-------------|
| Race Condition | CWE-362 | Time-of-check/time-of-use |
| Business Logic Flaw | CWE-840 | Logic errors in workflow |
| Trust Boundary Violation | CWE-501 | Mixing trusted/untrusted |
| Missing Threat Model | CWE-1059 | No security requirements |

### A07:2025 - Authentication Failures
**Renamed from "Identification & Authentication Failures" in 2021.**

| Vulnerability | CWE | Description |
|--------------|-----|-------------|
| Weak Password Policy | CWE-521 | No complexity requirements |
| Credential Stuffing | CWE-307 | No rate limiting on auth |
| Session Fixation | CWE-384 | Session ID not rotated |
| Missing MFA | CWE-308 | No second factor |
| Insecure Password Recovery | CWE-640 | Weak reset mechanism |
| Session Not Invalidated | CWE-613 | Logout doesn't work |
| Exposed Session Tokens | CWE-598 | Tokens in URLs |

### A08:2025 - Software or Data Integrity Failures
**Same position as 2021. Includes Insecure Deserialization.**

| Vulnerability | CWE | Description |
|--------------|-----|-------------|
| Insecure Deserialization | CWE-502 | Untrusted data deserialized |
| Prototype Pollution | CWE-1321 | JavaScript object pollution |
| CI/CD Compromise | CWE-829 | Insecure build pipeline |
| Unsigned Updates | CWE-494 | Missing code signing |
| SRI Missing | CWE-353 | No subresource integrity |

### A09:2025 - Security Logging & Alerting Failures
**Renamed from "Monitoring" to "Alerting" to emphasize active alerting.**

| Vulnerability | CWE | Description |
|--------------|-----|-------------|
| Insufficient Logging | CWE-778 | Security events not logged |
| Log Injection | CWE-117 | Forged log entries |
| Sensitive Data in Logs | CWE-532 | PII/credentials logged |
| Missing Alerting | CWE-223 | No security alerts |

### A10:2025 - Mishandling of Exceptional Conditions
**New in 2025. 24 CWEs covering improper error handling, failing open, and logic errors.**

| Vulnerability | CWE | Description |
|--------------|-----|-------------|
| Sensitive Error Messages | CWE-209 | Error messages leak sensitive info |
| Debug Info Exposure | CWE-215 | Sensitive info in debugging code |
| Uncaught Exception | CWE-248 | Unhandled exceptions crash or leak |
| Unchecked Return Value | CWE-252 | Ignoring function return values |
| NULL Pointer Dereference | CWE-476 | Crash on null reference |
| Failing Open | CWE-636 | Security bypass on error conditions |
| Improper Exception Handling | CWE-703 | Catch-all or missing exception handling |
| Missing Parameter Handling | CWE-234 | No handling for missing input |
| Insufficient Privilege Handling | CWE-274 | Improper handling of insufficient privileges |
| Divide By Zero | CWE-369 | Unguarded division operations |
| Missing Default Case | CWE-478 | Switch without default case |
| Generic Exception Catching | CWE-396 | Overly broad catch blocks |

---

## OWASP API Security Top 10 (2023)

### API1:2023 - Broken Object Level Authorization
| Vulnerability | CWE | Description |
|--------------|-----|-------------|
| IDOR | CWE-639 | Accessing other users' objects |
| Horizontal Privilege Escalation | CWE-639 | User A accesses User B's data |

### API2:2023 - Broken Authentication
| Vulnerability | CWE | Description |
|--------------|-----|-------------|
| Weak Authentication | CWE-287 | Easy to bypass auth |
| JWT Issues | CWE-347 | Token vulnerabilities |

### API3:2023 - Broken Object Property Level Authorization
| Vulnerability | CWE | Description |
|--------------|-----|-------------|
| Mass Assignment | CWE-915 | Modifying protected fields |
| Excessive Data Exposure | CWE-213 | Returning too much data |

### API4:2023 - Unrestricted Resource Consumption
| Vulnerability | CWE | Description |
|--------------|-----|-------------|
| Missing Rate Limiting | CWE-770 | No request throttling |
| DoS via API | CWE-400 | Resource exhaustion |

### API5:2023 - Broken Function Level Authorization
| Vulnerability | CWE | Description |
|--------------|-----|-------------|
| Vertical Privilege Escalation | CWE-269 | User becomes admin |
| Missing Admin Auth | CWE-285 | Admin API unprotected |

### API6:2023 - Unrestricted Access to Sensitive Business Flows
| Vulnerability | CWE | Description |
|--------------|-----|-------------|
| Business Flow Abuse | CWE-799 | Automated abuse of flows |

### API7:2023 - Server Side Request Forgery
| Vulnerability | CWE | Description |
|--------------|-----|-------------|
| SSRF | CWE-918 | Server-side URL fetching |

### API8:2023 - Security Misconfiguration
| Vulnerability | CWE | Description |
|--------------|-----|-------------|
| CORS Misconfiguration | CWE-942 | Overly permissive |
| Verbose Errors | CWE-209 | Information disclosure |

### API9:2023 - Improper Inventory Management
| Vulnerability | CWE | Description |
|--------------|-----|-------------|
| Shadow APIs | CWE-1059 | Undocumented endpoints |
| Version Confusion | CWE-1059 | Old API versions exposed |

### API10:2023 - Unsafe Consumption of APIs
| Vulnerability | CWE | Description |
|--------------|-----|-------------|
| Third-Party Trust | CWE-829 | Blindly trusting external APIs |

---

## CWE Quick Reference by Category

### Input Validation
| CWE | Name | Common In |
|-----|------|-----------|
| CWE-20 | Improper Input Validation | All |
| CWE-79 | XSS | Frontend |
| CWE-89 | SQL Injection | Backend |
| CWE-78 | OS Command Injection | Backend |
| CWE-22 | Path Traversal | Backend |
| CWE-611 | XXE | Backend |
| CWE-918 | SSRF | Backend |

### Authentication
| CWE | Name | Common In |
|-----|------|-----------|
| CWE-287 | Improper Authentication | All |
| CWE-384 | Session Fixation | Backend |
| CWE-613 | Insufficient Session Expiration | Backend |
| CWE-307 | Improper Restriction of Auth Attempts | Backend |
| CWE-521 | Weak Password Requirements | Backend |
| CWE-640 | Weak Password Recovery | Backend |

### Authorization
| CWE | Name | Common In |
|-----|------|-----------|
| CWE-284 | Improper Access Control | All |
| CWE-285 | Improper Authorization | Backend |
| CWE-639 | IDOR | Backend/API |
| CWE-269 | Improper Privilege Management | Backend |
| CWE-915 | Mass Assignment | Backend/API |

### Cryptography
| CWE | Name | Common In |
|-----|------|-----------|
| CWE-311 | Missing Encryption | All |
| CWE-312 | Cleartext Storage | Backend |
| CWE-319 | Cleartext Transmission | All |
| CWE-327 | Broken/Risky Crypto | All |
| CWE-328 | Reversible Hash | Backend |
| CWE-798 | Hardcoded Credentials | All |

### Data Exposure
| CWE | Name | Common In |
|-----|------|-----------|
| CWE-200 | Information Exposure | All |
| CWE-209 | Error Message Exposure | All |
| CWE-532 | Sensitive Data in Logs | Backend |
| CWE-213 | Excessive Data Exposure | API |
| CWE-598 | Sensitive Info in GET | All |

---

## Severity Classification Reference

### Critical (CVSS 9.0-10.0)
- Remote Code Execution (RCE)
- SQL Injection (with data access)
- Authentication Bypass
- Hardcoded Admin Credentials
- SSRF to Internal Systems
- Exposed Database

### High (CVSS 7.0-8.9)
- Stored XSS
- IDOR (sensitive data)
- Privilege Escalation
- Insecure Deserialization
- XXE (with file read)
- Command Injection

### Medium (CVSS 4.0-6.9)
- Reflected XSS
- CSRF
- Information Disclosure
- Missing Rate Limiting
- CORS Misconfiguration
- Open Redirect

### Low (CVSS 0.1-3.9)
- Missing Security Headers
- Verbose Error Messages
- Username Enumeration
- Clickjacking (low-impact pages)
- Missing SRI
- Debug Information

---

## Report Template References

```markdown
### [FINDING-001] [Vulnerability Name]

**Severity**: [Critical/High/Medium/Low]
**CVSS Score**: X.X
**OWASP Category**: [A01:2025 - Broken Access Control]
**CWE**: [CWE-XXX - Name]

**Description**:
[Clear description of the vulnerability]

**Location**:
- File: `path/to/file.ts`
- Line: 42-56
- Endpoint: `POST /api/users/:id`

**Evidence**:
```code
[Code snippet or request/response]
```

**Impact**:
[What an attacker could do]

**Remediation**:
[How to fix with code example]

**References**:
- [OWASP Link]
- [CWE Link]
```

---

## External References

### OWASP
- [OWASP Top 10 2025](https://owasp.org/Top10/2025/)
- [OWASP API Security Top 10 2023](https://owasp.org/API-Security/)
- [OWASP Testing Guide](https://owasp.org/www-project-web-security-testing-guide/)
- [OWASP Cheat Sheets](https://cheatsheetseries.owasp.org/)

### CWE
- [CWE List](https://cwe.mitre.org/data/index.html)
- [CWE Top 25](https://cwe.mitre.org/top25/)

### CVE
- [CVE Database](https://cve.mitre.org/)
- [NVD](https://nvd.nist.gov/)

### Scoring
- [CVSS Calculator](https://www.first.org/cvss/calculator/3.1)
- [CVSS Specification](https://www.first.org/cvss/specification-document)

---

## Legacy: OWASP Top 10 2021 Mapping

This appendix preserves the 2021 category mapping for reference when reviewing older reports or codebases audited against the 2021 standard.

| 2021 Category | 2025 Equivalent | Notes |
|---------------|-----------------|-------|
| A01:2021 - Broken Access Control | A01:2025 - Broken Access Control | Now also includes SSRF |
| A02:2021 - Cryptographic Failures | A04:2025 - Cryptographic Failures | Moved to #4 |
| A03:2021 - Injection | A05:2025 - Injection | Moved to #5 |
| A04:2021 - Insecure Design | A06:2025 - Insecure Design | Moved to #6 |
| A05:2021 - Security Misconfiguration | A02:2025 - Security Misconfiguration | Moved up to #2 |
| A06:2021 - Vulnerable Components | A03:2025 - Software Supply Chain Failures | Expanded scope, moved to #3 |
| A07:2021 - Identification & Authentication Failures | A07:2025 - Authentication Failures | Renamed |
| A08:2021 - Software and Data Integrity Failures | A08:2025 - Software or Data Integrity Failures | Minor rename ("and" → "or") |
| A09:2021 - Security Logging & Monitoring Failures | A09:2025 - Security Logging & Alerting Failures | "Monitoring" → "Alerting" |
| A10:2021 - Server-Side Request Forgery (SSRF) | Merged into A01:2025 | SSRF absorbed into Broken Access Control |
| N/A | A10:2025 - Mishandling of Exceptional Conditions | New category in 2025 |
