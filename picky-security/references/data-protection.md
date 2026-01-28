# Data Protection Security Audit

## Audit Philosophy

**Data is the target.** Attackers don't want your code - they want your data. Every piece of PII, every credit card, every health record, every password hash is a target. Your job is to find EVERY data exposure risk - collection, storage, transmission, logging, and retention vulnerabilities.

---

## 1. Sensitive Data Identification

### 1.1 PII (Personally Identifiable Information)
- [ ] **Names** - Full name, first/last
- [ ] **Email addresses** - Personal and work
- [ ] **Phone numbers** - Mobile, home, work
- [ ] **Physical addresses** - Home, billing, shipping
- [ ] **Date of birth** - Full or partial
- [ ] **Government IDs** - SSN, passport, driver's license
- [ ] **Biometric data** - Fingerprint, face, voice
- [ ] **IP addresses** - Can identify location/person
- [ ] **Device identifiers** - Can track individuals

```bash
# Find PII field names in schema/models
grep -rn "firstName\|lastName\|email\|phone\|address\|ssn\|dateOfBirth\|dob\|birthDate" --include="*.prisma" --include="*.ts" --include="*.js" --include="*.py" | head -30

# Find PII in database queries
grep -rn "SELECT.*email\|SELECT.*name\|SELECT.*phone\|SELECT.*address" --include="*.ts" --include="*.js" --include="*.sql"
```

### 1.2 Financial Data
- [ ] **Credit card numbers** - Full PAN
- [ ] **Bank accounts** - Account numbers
- [ ] **Payment tokens** - Stripe tokens, etc.
- [ ] **Transaction history** - Purchase records
- [ ] **Balance information** - Account balances
- [ ] **Tax information** - Tax IDs, returns

```bash
# Find financial data handling
grep -rn "card\|credit\|payment\|bank\|account.*number\|routing\|balance\|transaction" --include="*.ts" --include="*.js" --include="*.py" | grep -v "test\|spec\|mock" | head -30
```

### 1.3 Authentication Data
- [ ] **Passwords** - Even hashed
- [ ] **Password reset tokens** - Time-limited
- [ ] **Session tokens** - Current sessions
- [ ] **API keys** - User-owned
- [ ] **MFA secrets** - TOTP seeds
- [ ] **Security questions** - Answers

```bash
# Find auth data handling
grep -rn "password\|token\|secret\|sessionId\|apiKey\|mfa\|totp" --include="*.ts" --include="*.js" --include="*.py" | grep -v "type\|interface\|schema" | head -30
```

### 1.4 Health Data (if applicable)
- [ ] **Medical records** - HIPAA sensitive
- [ ] **Prescriptions** - Medication info
- [ ] **Health conditions** - Diagnoses
- [ ] **Insurance info** - Policy numbers

### 1.5 Other Sensitive Data
- [ ] **Location data** - GPS, geolocation
- [ ] **Communication content** - Messages, emails
- [ ] **Browsing history** - Activity tracking
- [ ] **Purchase history** - Buying patterns
- [ ] **Employment info** - Salary, performance

---

## 2. Data Collection Audit

### 2.1 Minimal Collection
- [ ] **Only necessary data** - Purpose-limited
- [ ] **Optional vs required** - Clearly marked
- [ ] **Purpose documented** - Why collected
- [ ] **Consent obtained** - If required

```bash
# Find form fields
grep -rn "<input\|<Input\|<TextField\|required" --include="*.tsx" --include="*.jsx" | head -30

# Find data models
grep -rn "schema\|model\|interface" --include="*.prisma" --include="*.ts" | head -30
```

### 2.2 Collection Points
- [ ] **Registration forms** - What's collected
- [ ] **Profile updates** - Additional data
- [ ] **Payment forms** - Financial data
- [ ] **Contact forms** - Communication data
- [ ] **Analytics** - Tracking data

### 2.3 Third-Party Collection
- [ ] **Analytics scripts** - What they collect
- [ ] **Social login** - Data from providers
- [ ] **Embedded content** - Third-party tracking
- [ ] **CDN logging** - Request logging

---

## 3. Data Storage Security

### 3.1 Database Security
- [ ] **Encryption at rest** - Database encrypted
- [ ] **Access controls** - Row-level security
- [ ] **Connection security** - TLS to database
- [ ] **Credential security** - DB creds secured

```bash
# Find database configuration
grep -rn "DATABASE_URL\|connectionString\|pg\|mysql\|mongo" --include="*.ts" --include="*.js" --include="*.env*"

# Find raw queries (potential exposure)
grep -rn "\$queryRaw\|\.query\s*(\|execute\s*(" --include="*.ts" --include="*.js" | head -20
```

### 3.2 Password Storage
- [ ] **Strong hashing** - bcrypt, scrypt, Argon2
- [ ] **Unique salts** - Per-password
- [ ] **Adequate cost factor** - bcrypt cost 10+
- [ ] **No reversible encryption** - Never AES for passwords

```bash
# Find password hashing
grep -rn "bcrypt\|scrypt\|argon2\|pbkdf2\|hashPassword" --include="*.ts" --include="*.js" --include="*.py"

# Find dangerous hashing
grep -rn "md5\|sha1\|SHA1\|createHash.*md5" --include="*.ts" --include="*.js"
```

### 3.3 Token Storage
- [ ] **Session tokens hashed** - In database
- [ ] **Reset tokens hashed** - Before storage
- [ ] **API keys hashed** - Only show once
- [ ] **Refresh tokens secured** - Encrypted or hashed

### 3.4 File Storage Security
- [ ] **Files encrypted** - Sensitive uploads
- [ ] **Access controlled** - Per-user/per-role
- [ ] **No direct URLs** - Signed URLs or proxied
- [ ] **Metadata stripped** - EXIF, etc. removed

```bash
# Find file upload/storage
grep -rn "upload\|Storage\|S3\|bucket\|blob" --include="*.ts" --include="*.js" | head -20
```

### 3.5 Local Storage
- [ ] **No sensitive data in localStorage** - XSS accessible
- [ ] **No sensitive data in cookies** - Unless httpOnly
- [ ] **Session storage appropriate** - Cleared on close
- [ ] **IndexedDB encrypted** - If sensitive data

```bash
# Find local storage usage
grep -rn "localStorage\|sessionStorage\|IndexedDB" --include="*.ts" --include="*.tsx" --include="*.js" --include="*.jsx"
```

---

## 4. Data Transmission Security

### 4.1 Transport Security
- [ ] **HTTPS everywhere** - No HTTP
- [ ] **TLS 1.2+** - No old protocols
- [ ] **Certificate valid** - Not expired
- [ ] **HSTS enabled** - Force HTTPS

### 4.2 API Security
- [ ] **Data minimization** - Only needed fields
- [ ] **Response filtering** - Based on role
- [ ] **No over-fetching** - GraphQL particularly
- [ ] **Pagination** - Limit data returned

```bash
# Find API responses
grep -rn "res\.json\|res\.send\|return\s*{" --include="*.ts" --include="*.js" | head -30

# Find select/projection in queries
grep -rn "select:\|include:\|projection:" --include="*.ts" --include="*.js" | head -20
```

### 4.3 Internal Communication
- [ ] **Service-to-service TLS** - Internal encryption
- [ ] **mTLS if needed** - Mutual authentication
- [ ] **Internal APIs secured** - Auth required

---

## 5. Data Logging Audit

### 5.1 Sensitive Data in Logs
- [ ] **No passwords** - Ever logged
- [ ] **No tokens** - Session, API, JWT
- [ ] **No full PAN** - Credit card masked
- [ ] **No full SSN** - Only last 4 if any
- [ ] **No auth headers** - Bearer tokens masked
- [ ] **Request bodies scrubbed** - Sensitive fields

```bash
# Find logging statements
grep -rn "console\.log\|logger\.\|log\." --include="*.ts" --include="*.js" | head -50

# Find what might be logged
grep -rn "log.*req\.\|log.*body\|log.*user\|log.*password\|log.*token" --include="*.ts" --include="*.js"

# Find request logging middleware
grep -rn "morgan\|express-winston\|request.*log\|requestLog" --include="*.ts" --include="*.js"
```

### 5.2 Log Configuration
- [ ] **Log level appropriate** - Not debug in prod
- [ ] **PII scrubbing configured** - Automatic masking
- [ ] **Log access controlled** - Not everyone can see
- [ ] **Log retention defined** - Auto-deletion

### 5.3 Error Logging
- [ ] **Stack traces safe** - No PII in variables
- [ ] **Error context safe** - No sensitive request data
- [ ] **Third-party error services** - PII scrubbing

```bash
# Find error logging
grep -rn "error\|Error" --include="*.ts" --include="*.js" | grep -i "log\|console\|sentry\|bugsnag" | head -20
```

---

## 6. Data Exposure in UI

### 6.1 Sensitive Data Display
- [ ] **Masking in UI** - SSN, card numbers
- [ ] **Password fields masked** - type="password"
- [ ] **Copy protection** - Where needed
- [ ] **Screenshot protection** - Sensitive areas

```bash
# Find data display
grep -rn "\.ssn\|\.cardNumber\|\.accountNumber\|\.password" --include="*.tsx" --include="*.jsx" | head -20

# Find masking logic
grep -rn "mask\|Mask\|\*\*\*\|••" --include="*.ts" --include="*.tsx" --include="*.js" --include="*.jsx"
```

### 6.2 Debug/Development Exposure
- [ ] **No PII in console** - Browser console clean
- [ ] **DevTools data safe** - Redux state, etc.
- [ ] **Network tab safe** - Responses filtered
- [ ] **Source maps disabled** - In production

### 6.3 URL Exposure
- [ ] **No PII in URLs** - Not in query params
- [ ] **No tokens in URLs** - Use headers/cookies
- [ ] **Sensitive paths opaque** - /user/123 vs UUIDs

---

## 7. Data Access Audit

### 7.1 Access Controls
- [ ] **Role-based access** - To different data types
- [ ] **Row-level security** - User's own data only
- [ ] **Field-level security** - Sensitive fields restricted
- [ ] **Time-based access** - Expiring access

```bash
# Find access control logic
grep -rn "role\|permission\|authorize\|canAccess\|hasAccess" --include="*.ts" --include="*.js" --include="*.py" | head -30

# Find data access patterns
grep -rn "findMany\|findAll\|select\|SELECT" --include="*.ts" --include="*.js" | head -30
```

### 7.2 Query Audit
- [ ] **Queries scoped** - WHERE user_id = ?
- [ ] **Bulk access limited** - Not all records
- [ ] **Joins authorized** - Can access related data
- [ ] **Aggregations safe** - No inference attacks

### 7.3 Export Audit
- [ ] **Export authorized** - Only own data
- [ ] **Export logged** - For compliance
- [ ] **Export limited** - Rate limited
- [ ] **Export filtered** - Sensitive fields removed

---

## 8. Data Retention

### 8.1 Retention Policy
- [ ] **Policy defined** - How long data kept
- [ ] **Policy documented** - Communicated to users
- [ ] **Policy enforced** - Automated deletion
- [ ] **Different data types** - Different retention

```bash
# Find retention/deletion logic
grep -rn "delete\|remove\|purge\|retention\|expire" --include="*.ts" --include="*.js" | grep -v "test\|spec" | head -20

# Find scheduled jobs
grep -rn "cron\|schedule\|job" --include="*.ts" --include="*.js" | head -10
```

### 8.2 Data Deletion
- [ ] **Hard delete capability** - Actually removed
- [ ] **Soft delete secure** - If used, access controlled
- [ ] **Cascading deletes** - Related data removed
- [ ] **Backup data deleted** - Eventually

### 8.3 Account Deletion
- [ ] **Delete capability exists** - GDPR right to erasure
- [ ] **Delete is complete** - All user data
- [ ] **Delete is verified** - Confirmation process
- [ ] **Retention exceptions** - Legal holds, etc.

---

## 9. Encryption Audit

### 9.1 Encryption at Rest
- [ ] **Database encrypted** - Full disk or column
- [ ] **File storage encrypted** - S3, etc.
- [ ] **Backups encrypted** - Critical
- [ ] **Secrets encrypted** - In secrets manager

```bash
# Find encryption usage
grep -rn "encrypt\|decrypt\|cipher\|crypto\|AES\|RSA" --include="*.ts" --include="*.js" --include="*.py"

# Find what's encrypted
grep -rn "encrypt\(" --include="*.ts" --include="*.js" -B 2 -A 2 | head -30
```

### 9.2 Encryption in Transit
- [ ] **TLS everywhere** - All connections
- [ ] **Database TLS** - ?sslmode=require
- [ ] **Internal TLS** - Service-to-service
- [ ] **API TLS** - Third-party calls

### 9.3 Key Management
- [ ] **Keys not in code** - In secrets manager
- [ ] **Key rotation** - Regular rotation
- [ ] **Key access logged** - Who used what
- [ ] **Key backup** - Disaster recovery

### 9.4 Application-Level Encryption
- [ ] **Sensitive fields encrypted** - SSN, etc.
- [ ] **Search on encrypted** - If needed, consider design
- [ ] **Key per tenant** - If multi-tenant
- [ ] **Encryption verified** - Can decrypt

---

## 10. Third-Party Data Sharing

### 10.1 Analytics
- [ ] **PII not sent** - Or anonymized
- [ ] **User IDs hashed** - Not real IDs
- [ ] **IP anonymization** - GA anonymizeIp
- [ ] **Consent obtained** - Cookie banner

```bash
# Find analytics
grep -rn "analytics\|gtag\|ga\(\|mixpanel\|amplitude\|segment" --include="*.ts" --include="*.tsx" --include="*.js" --include="*.html"
```

### 10.2 Third-Party Services
- [ ] **DPA in place** - Data Processing Agreement
- [ ] **Data minimization** - Only needed data
- [ ] **Sub-processor list** - Know where data goes
- [ ] **Security verified** - SOC2, etc.

### 10.3 Webhooks/Integrations
- [ ] **Payload minimal** - Only needed data
- [ ] **Sensitive fields excluded** - No passwords, tokens
- [ ] **HTTPS only** - Encrypted delivery
- [ ] **Signature verification** - Recipient can verify

```bash
# Find webhook payloads
grep -rn "webhook\|Webhook" --include="*.ts" --include="*.js" -A 10 | grep -i "payload\|body\|data" | head -20
```

---

## 11. Compliance Audit

### 11.1 GDPR (if applicable)
- [ ] **Lawful basis** - For each processing activity
- [ ] **Consent management** - When needed
- [ ] **Data subject rights** - Access, delete, port
- [ ] **Privacy policy** - Comprehensive, updated
- [ ] **DPO appointed** - If required
- [ ] **DPIA conducted** - For high-risk processing

### 11.2 CCPA (if applicable)
- [ ] **Notice at collection** - What's collected
- [ ] **Do not sell** - Opt-out mechanism
- [ ] **Consumer rights** - Access, delete
- [ ] **Non-discrimination** - For exercising rights

### 11.3 PCI DSS (if handling cards)
- [ ] **No card storage** - Use tokens
- [ ] **SAQ appropriate** - Self-assessment
- [ ] **Penetration testing** - Regular testing
- [ ] **Network segmentation** - Cardholder data isolated

### 11.4 HIPAA (if health data)
- [ ] **BAA in place** - With vendors
- [ ] **Access controls** - Minimum necessary
- [ ] **Audit logs** - All PHI access
- [ ] **Encryption** - In transit and at rest

---

## 12. Data Breach Preparedness

### 12.1 Detection
- [ ] **Anomaly detection** - Unusual access patterns
- [ ] **Alerting configured** - Real-time alerts
- [ ] **Log monitoring** - Security events
- [ ] **Data loss prevention** - DLP tools

### 12.2 Response Plan
- [ ] **IR plan exists** - Documented procedure
- [ ] **Team identified** - Who to contact
- [ ] **Communication plan** - Notify users, regulators
- [ ] **Legal prepared** - Know requirements

### 12.3 Breach Notification
- [ ] **Timeframes known** - 72 hours GDPR, etc.
- [ ] **Templates ready** - Notification templates
- [ ] **Contact list** - Users, regulators, legal

---

## Data Protection Scan Commands

```bash
# === PII FIELD DISCOVERY ===
# Find likely PII fields
grep -rn "email\|phone\|address\|name\|ssn\|dob\|birth" --include="*.prisma" --include="*.sql" --include="*.ts" | head -30

# === PASSWORD HANDLING ===
# Find password operations
grep -rn "password" --include="*.ts" --include="*.js" | grep -v "type\|interface\|test\|spec" | head -20

# Find hashing
grep -rn "bcrypt\|argon2\|scrypt\|pbkdf2" --include="*.ts" --include="*.js"

# === LOGGING AUDIT ===
# Find what's logged
grep -rn "console\.log\|logger\." --include="*.ts" --include="*.js" | wc -l

# Find potential PII logging
grep -rn "log.*email\|log.*name\|log.*phone\|log.*address" --include="*.ts" --include="*.js"

# === ENCRYPTION ===
# Find encryption usage
grep -rn "encrypt\|decrypt\|cipher" --include="*.ts" --include="*.js"

# Find crypto imports
grep -rn "from 'crypto'\|require('crypto')" --include="*.ts" --include="*.js"

# === DATA ACCESS ===
# Find data queries
grep -rn "findMany\|findAll\|find\(\|SELECT\s" --include="*.ts" --include="*.js" | head -30

# Find where clauses (access scoping)
grep -rn "where:\|WHERE" --include="*.ts" --include="*.js" | head -30

# === ANALYTICS ===
# Find analytics tracking
grep -rn "analytics\|track\|gtag\|ga\(" --include="*.ts" --include="*.tsx" --include="*.js"
```

---

## OWASP/CWE References

| Issue | OWASP | CWE |
|-------|-------|-----|
| Sensitive Data Exposure | A02:2021 | CWE-200 |
| Insufficient Encryption | A02:2021 | CWE-311 |
| Cleartext Transmission | A02:2021 | CWE-319 |
| Cleartext Storage | A02:2021 | CWE-312 |
| Weak Password Storage | A02:2021 | CWE-916 |
| Sensitive Data in Logs | A09:2021 | CWE-532 |
| Missing Access Control | A01:2021 | CWE-284 |
| Excessive Data Exposure | A03:2023 (API) | CWE-213 |
