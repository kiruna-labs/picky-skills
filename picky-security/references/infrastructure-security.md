# Infrastructure Security Audit Checklist

## Audit Philosophy

**Infrastructure is your foundation - cracks here bring down everything.** A leaked secret compromises the whole system. A vulnerable dependency opens a backdoor. A misconfigured header exposes users to attacks. Your job is to find EVERY infrastructure weakness - secrets, dependencies, headers, configurations, and deployment security.

---

## 1. Secrets Management Audit

### 1.1 Hardcoded Secrets
- [ ] **No API keys in code** - Check all files
- [ ] **No passwords in code** - Literal strings
- [ ] **No tokens in code** - JWT, bearer, etc.
- [ ] **No private keys in code** - RSA, EC keys
- [ ] **No connection strings** - With credentials

```bash
# Run comprehensive secret scan
grep -rn "password\s*[:=]\s*['\"][^'\"]*['\"]" --include="*.ts" --include="*.js" --include="*.py" --include="*.json" --include="*.yml" --include="*.yaml"

# API keys patterns
grep -rn "api[_-]?key\s*[:=]\s*['\"][^'\"]*['\"]" --include="*.ts" --include="*.js" --include="*.py" --include="*.json" --include="*.yml"

# AWS keys
grep -rn "AKIA[0-9A-Z]\{16\}\|aws_secret_access_key\|aws_access_key_id" --include="*.ts" --include="*.js" --include="*.env*" --include="*.json"

# Private keys
grep -rn "BEGIN.*PRIVATE KEY\|BEGIN RSA PRIVATE\|BEGIN EC PRIVATE" --include="*.ts" --include="*.js" --include="*.pem" --include="*.key"

# JWT secrets
grep -rn "jwt[_-]?secret\|JWT_SECRET\|token[_-]?secret" --include="*.ts" --include="*.js" --include="*.env*"

# Database URLs
grep -rn "postgres://\|mongodb://\|mysql://\|redis://\|DATABASE_URL" --include="*.ts" --include="*.js" --include="*.env*"

# OAuth secrets
grep -rn "client[_-]?secret\|oauth.*secret\|GITHUB_SECRET\|GOOGLE_SECRET" --include="*.ts" --include="*.js" --include="*.env*"

# Generic secrets
grep -rn "secret\s*[:=]\s*['\"][^'\"]*['\"]" --include="*.ts" --include="*.js" --include="*.py" | grep -v "createSecret\|secretName\|const secret\s*="

# Bearer tokens
grep -rn "Bearer\s\+[A-Za-z0-9_-]\{20,\}" --include="*.ts" --include="*.js"

# Stripe keys
grep -rn "sk_live_\|pk_live_\|sk_test_\|pk_test_" --include="*.ts" --include="*.js" --include="*.env*"

# SendGrid/Mailgun/etc
grep -rn "SG\.\|api\.sendgrid\|api\.mailgun" --include="*.ts" --include="*.js"
```

### 1.2 Environment Variables
- [ ] **Secrets in env vars** - Not in code
- [ ] **.env in .gitignore** - Not committed
- [ ] **.env.example exists** - Without real values
- [ ] **Production env separate** - Different from dev
- [ ] **Env vars validated** - Required vars checked on startup

```bash
# Check .gitignore for env files
cat .gitignore 2>/dev/null | grep -i "\.env"

# Find .env files (shouldn't be many)
find . -name ".env*" -not -name ".env.example" -not -name ".env.sample" 2>/dev/null

# Check what env vars are used
grep -rn "process\.env\.\|import\.meta\.env\.\|os\.environ" --include="*.ts" --include="*.js" --include="*.py" | head -50

# Check for environment validation
grep -rn "z\.string\|required:\|throw.*env\|missing.*env" --include="*.ts" --include="*.js" | grep -i "env"
```

### 1.3 Secret Storage
- [ ] **Secrets manager used** - AWS SSM, Vault, etc.
- [ ] **Secrets not in CI/CD logs** - Masked in output
- [ ] **Secrets rotated** - Regular rotation
- [ ] **Access audited** - Who accessed what

### 1.4 Git History
- [ ] **No secrets in history** - Check past commits
- [ ] **No secrets in branches** - All branches clean
- [ ] **Git hooks for prevention** - Pre-commit scanning

```bash
# Check git history for secrets (limited scan)
git log -p --all -S "password" -- "*.ts" "*.js" "*.json" 2>/dev/null | head -50
git log -p --all -S "api_key" -- "*.ts" "*.js" "*.json" 2>/dev/null | head -50
git log -p --all -S "secret" -- "*.ts" "*.js" "*.json" 2>/dev/null | head -50
```

---

## 2. Dependency Security Audit

### 2.1 Known Vulnerabilities
- [ ] **npm audit clean** - No high/critical vulns
- [ ] **yarn audit clean** - If using yarn
- [ ] **pip audit clean** - If Python
- [ ] **Snyk/Dependabot enabled** - Automated scanning

```bash
# Run dependency audits
npm audit 2>/dev/null
yarn audit 2>/dev/null
pnpm audit 2>/dev/null

# Check for audit fix possibilities
npm audit fix --dry-run 2>/dev/null

# Python dependencies
pip-audit 2>/dev/null
safety check 2>/dev/null
```

### 2.2 Dependency Hygiene
- [ ] **Lockfile committed** - package-lock.json, yarn.lock
- [ ] **Dependencies pinned** - Exact versions or ranges
- [ ] **Outdated packages reviewed** - Regular updates
- [ ] **Unused dependencies removed** - depcheck

```bash
# Check for lockfile
ls -la package-lock.json yarn.lock pnpm-lock.yaml 2>/dev/null

# Check for outdated packages
npm outdated 2>/dev/null
yarn outdated 2>/dev/null

# Check for unused dependencies
npx depcheck 2>/dev/null | head -30
```

### 2.3 Supply Chain Security
- [ ] **Dependencies from trusted sources** - npm, PyPI official
- [ ] **No typosquatting** - Package names verified
- [ ] **Minimal dependencies** - Only what's needed
- [ ] **Transitive deps reviewed** - Know what's pulled in

```bash
# Count direct vs transitive dependencies
npm ls --depth=0 2>/dev/null | wc -l
npm ls 2>/dev/null | wc -l

# Check for suspicious packages
grep -i "hack\|exploit\|crack" package.json 2>/dev/null
```

### 2.4 Build Dependencies
- [ ] **Dev deps not in prod** - devDependencies separate
- [ ] **Build tools updated** - webpack, vite, etc.
- [ ] **Bundler plugins audited** - webpack plugins, etc.

---

## 3. Security Headers Audit

### 3.1 Required Headers
- [ ] **Strict-Transport-Security** - Force HTTPS
- [ ] **X-Content-Type-Options: nosniff** - No MIME sniffing
- [ ] **X-Frame-Options** - Clickjacking protection
- [ ] **Content-Security-Policy** - XSS mitigation
- [ ] **X-XSS-Protection: 0** - Deprecated, disable
- [ ] **Referrer-Policy** - Control referrer leakage
- [ ] **Permissions-Policy** - Control browser features

```bash
# Find helmet/security headers configuration
grep -rn "helmet\|Helmet\|Content-Security-Policy\|X-Frame\|Strict-Transport" --include="*.ts" --include="*.js" --include="*.py"

# Check next.js headers configuration
grep -rn "headers\s*(" --include="next.config.*" -A 20

# Find security-related middleware
grep -rn "securityHeaders\|addSecurityHeaders" --include="*.ts" --include="*.js"
```

### 3.2 HSTS Configuration
- [ ] **max-age adequate** - 1 year minimum for production
- [ ] **includeSubDomains** - If applicable
- [ ] **preload ready** - If adding to preload list

### 3.3 CSP Configuration
- [ ] **default-src restrictive** - 'self' minimum
- [ ] **script-src specific** - No 'unsafe-inline' ideally
- [ ] **style-src specific** - No 'unsafe-inline' ideally
- [ ] **object-src 'none'** - Block plugins
- [ ] **base-uri 'self'** - Prevent base tag injection
- [ ] **form-action 'self'** - Prevent form hijacking
- [ ] **frame-ancestors** - Clickjacking in CSP

```bash
# Find CSP configuration
grep -rn "Content-Security-Policy\|contentSecurityPolicy\|CSP" --include="*.ts" --include="*.js" --include="*.json"

# Check for unsafe directives
grep -rn "unsafe-inline\|unsafe-eval" --include="*.ts" --include="*.js"
```

### 3.4 Cookie Security
- [ ] **HttpOnly on session cookies** - JS can't access
- [ ] **Secure flag** - HTTPS only
- [ ] **SameSite attribute** - CSRF protection
- [ ] **Domain scoped properly** - Not too broad
- [ ] **Path scoped properly** - If needed
- [ ] **__Host- prefix** - If maximum security

```bash
# Find cookie configuration
grep -rn "cookie\|Cookie\|httpOnly\|secure\|sameSite" --include="*.ts" --include="*.js" --include="*.py"
```

---

## 4. TLS/HTTPS Audit

### 4.1 HTTPS Enforcement
- [ ] **HTTPS everywhere** - No HTTP in production
- [ ] **HTTP redirects to HTTPS** - 301 redirect
- [ ] **HSTS header set** - Browser remembers HTTPS
- [ ] **Mixed content blocked** - No HTTP resources on HTTPS

```bash
# Find HTTP URLs in code
grep -rn "http://\(localhost\|127\.0\.0\.1\)\@!" --include="*.ts" --include="*.js" --include="*.tsx" --include="*.jsx" | grep -v "https://"
```

### 4.2 TLS Configuration
- [ ] **TLS 1.2 minimum** - No TLS 1.0/1.1
- [ ] **Strong cipher suites** - No weak ciphers
- [ ] **Certificate valid** - Not expired
- [ ] **Certificate chain complete** - Intermediates included

### 4.3 Certificate Management
- [ ] **Auto-renewal configured** - Let's Encrypt, etc.
- [ ] **Certificate monitoring** - Expiration alerts
- [ ] **CAA records set** - Optional but recommended

---

## 5. Logging & Monitoring Audit

### 5.1 Security Logging
- [ ] **Authentication logged** - Login, logout, failures
- [ ] **Authorization logged** - Access denied
- [ ] **Admin actions logged** - All privileged operations
- [ ] **Data access logged** - Sensitive data access

```bash
# Find logging configuration
grep -rn "winston\|pino\|bunyan\|logger\|logging\|log4" --include="*.ts" --include="*.js" --include="package.json"

# Find security-related logging
grep -rn "log.*auth\|log.*login\|log.*fail\|audit" --include="*.ts" --include="*.js"
```

### 5.2 Log Security
- [ ] **No secrets in logs** - Scrubbed
- [ ] **No PII in logs** - Or anonymized
- [ ] **Logs protected** - Access controlled
- [ ] **Log injection prevented** - Newlines escaped

### 5.3 Monitoring & Alerting
- [ ] **Error monitoring** - Sentry, etc.
- [ ] **Security alerts** - Anomaly detection
- [ ] **Uptime monitoring** - Service availability
- [ ] **Resource monitoring** - CPU, memory, disk

---

## 6. Build & Deployment Security

### 6.1 Build Security
- [ ] **Build artifacts clean** - No secrets baked in
- [ ] **Source maps disabled** - In production
- [ ] **Debug mode disabled** - In production
- [ ] **Environment correct** - NODE_ENV=production

```bash
# Check build configuration
grep -rn "sourceMap\|productionSourceMap\|devtool" --include="*.config.*" --include="package.json"

# Check for debug flags
grep -rn "DEBUG\|debug:\s*true\|enableDebug" --include="*.ts" --include="*.js" --include="*.config.*"
```

### 6.2 CI/CD Security
- [ ] **Secrets in CI vault** - Not in code
- [ ] **Branch protection** - Main protected
- [ ] **Review required** - PR reviews enforced
- [ ] **CI steps audited** - Know what runs
- [ ] **Artifact security** - Signed, verified

```bash
# Find CI configuration
find . -name ".github" -o -name ".gitlab-ci*" -o -name "Jenkinsfile" -o -name ".circleci" 2>/dev/null

# Check CI files for secrets
grep -rn "secret\|password\|token\|key" .github/ .gitlab-ci* 2>/dev/null
```

### 6.3 Container Security
- [ ] **Base image official** - From Docker Hub official
- [ ] **Base image updated** - Not outdated
- [ ] **Non-root user** - Not running as root
- [ ] **Minimal image** - Alpine or distroless
- [ ] **No secrets in image** - Use runtime env vars

```bash
# Check Dockerfile
grep -rn "FROM\|USER\|ENV\|COPY.*secret\|COPY.*\.env" Dockerfile* docker-compose* 2>/dev/null
```

### 6.4 Serverless Security
- [ ] **Function permissions minimal** - Least privilege
- [ ] **Secrets in secrets manager** - Not env vars in console
- [ ] **VPC if needed** - Network isolation
- [ ] **Timeout set** - Prevent runaway

---

## 7. Cloud Configuration Audit

### 7.1 AWS Security (if applicable)
- [ ] **IAM roles vs keys** - Prefer roles
- [ ] **Least privilege IAM** - Minimal permissions
- [ ] **S3 buckets private** - No public access
- [ ] **Security groups tight** - Minimal open ports
- [ ] **CloudTrail enabled** - Audit logging
- [ ] **MFA on root** - AWS root account

```bash
# Find AWS configuration
grep -rn "aws-sdk\|@aws-sdk\|boto3\|AWS\." --include="*.ts" --include="*.js" --include="*.py"

# Find S3 operations
grep -rn "S3\|s3\.\|bucket" --include="*.ts" --include="*.js" --include="*.py"
```

### 7.2 GCP Security (if applicable)
- [ ] **Service accounts scoped** - Minimal roles
- [ ] **Cloud Storage ACLs** - Not public
- [ ] **VPC configured** - Network security
- [ ] **Audit logs enabled** - Cloud Logging

### 7.3 Azure Security (if applicable)
- [ ] **Managed identities** - Over service principals
- [ ] **RBAC configured** - Least privilege
- [ ] **Storage private** - No public containers
- [ ] **NSG rules tight** - Minimal access

### 7.4 Database Security
- [ ] **Not publicly accessible** - Private network
- [ ] **Strong credentials** - Complex passwords
- [ ] **SSL/TLS enabled** - Encrypted connections
- [ ] **Backups encrypted** - At-rest encryption
- [ ] **Audit logging** - Query logging if needed

---

## 8. Third-Party Service Security

### 8.1 API Integration Security
- [ ] **API keys secured** - In secrets manager
- [ ] **Keys scoped** - Minimal permissions
- [ ] **Keys rotatable** - Can be changed
- [ ] **Webhook secrets validated** - Signature verification

```bash
# Find third-party integrations
grep -rn "stripe\|twilio\|sendgrid\|mailgun\|firebase\|supabase\|auth0\|clerk" --include="*.ts" --include="*.js" --include="package.json"

# Find webhook handling
grep -rn "webhook\|Webhook" --include="*.ts" --include="*.js"
```

### 8.2 OAuth Providers
- [ ] **Redirect URIs specific** - Not wildcards
- [ ] **Client secrets secured** - Not in frontend
- [ ] **Scopes minimal** - Only needed permissions

### 8.3 CDN Security
- [ ] **Origin protected** - Only CDN can access
- [ ] **HTTPS enforced** - CDN to origin
- [ ] **Headers forwarded correctly** - Security headers

---

## 9. Input/Output Encoding

### 9.1 Encoding Consistency
- [ ] **UTF-8 everywhere** - Consistent encoding
- [ ] **Charset specified** - In Content-Type
- [ ] **No encoding issues** - In file paths, URLs

```bash
# Check charset configuration
grep -rn "charset\|encoding\|UTF-8\|utf-8" --include="*.ts" --include="*.js" --include="*.html"
```

### 9.2 Output Encoding
- [ ] **HTML encoding** - For HTML context
- [ ] **JS encoding** - For JavaScript context
- [ ] **URL encoding** - For URL context
- [ ] **CSS encoding** - For CSS context
- [ ] **JSON encoding** - For JSON context

---

## 10. Error Handling Security

### 10.1 Error Disclosure
- [ ] **Generic errors to users** - No stack traces
- [ ] **Detailed errors to logs** - For debugging
- [ ] **No path disclosure** - File paths hidden
- [ ] **No version disclosure** - Framework versions hidden

```bash
# Find error handling
grep -rn "catch\s*(\|\.catch\|onError\|errorHandler" --include="*.ts" --include="*.js"

# Find error display
grep -rn "error\.\(message\|stack\)" --include="*.ts" --include="*.js" | grep -i "res\.\|send\|json"
```

### 10.2 Default Error Pages
- [ ] **Custom 404** - Not framework default
- [ ] **Custom 500** - Not framework default
- [ ] **No framework branding** - Don't reveal stack

---

## 11. Backup & Recovery

### 11.1 Backup Security
- [ ] **Backups encrypted** - At rest
- [ ] **Backup access controlled** - Limited access
- [ ] **Backup tested** - Regular restore tests
- [ ] **Backup offsite** - Geographic redundancy

### 11.2 Disaster Recovery
- [ ] **DR plan exists** - Documented
- [ ] **RTO/RPO defined** - Recovery objectives
- [ ] **DR tested** - Regular drills
- [ ] **Communication plan** - Incident response

---

## 12. Compliance Considerations

### 12.1 Data Handling
- [ ] **PII identified** - Know where it is
- [ ] **Data retention policy** - How long kept
- [ ] **Data deletion capability** - Can delete on request
- [ ] **Data export capability** - GDPR portability

### 12.2 Access Controls
- [ ] **Access logged** - Who accessed what
- [ ] **Access reviewed** - Regular audits
- [ ] **Least privilege** - Minimal access

### 12.3 Encryption
- [ ] **Data at rest encrypted** - Database, storage
- [ ] **Data in transit encrypted** - TLS everywhere
- [ ] **Key management** - Proper key handling

---

## Automated Scanning Script

```bash
#!/bin/bash
# infrastructure-scan.sh - Run from project root

echo "=== INFRASTRUCTURE SECURITY SCAN ==="
echo ""

echo "--- SECRET SCANNING ---"
echo "Checking for hardcoded secrets..."

echo "API Keys:"
grep -rn "api[_-]?key\s*[:=]\s*['\"][^'\"]\{10,\}" --include="*.ts" --include="*.js" --include="*.py" 2>/dev/null | head -10

echo ""
echo "Passwords:"
grep -rn "password\s*[:=]\s*['\"][^'\"]\{3,\}" --include="*.ts" --include="*.js" --include="*.py" 2>/dev/null | grep -v "passwordSchema\|passwordField\|password:" | head -10

echo ""
echo "AWS Keys:"
grep -rn "AKIA[0-9A-Z]\{16\}" --include="*.ts" --include="*.js" --include="*.env*" 2>/dev/null | head -5

echo ""
echo "Private Keys:"
grep -rln "BEGIN.*PRIVATE KEY" . 2>/dev/null | head -5

echo ""
echo "--- ENVIRONMENT FILES ---"
echo ".env files found (excluding examples):"
find . -name ".env*" -not -name "*.example" -not -name "*.sample" -not -path "*/node_modules/*" 2>/dev/null

echo ""
echo "--- DEPENDENCY AUDIT ---"
if command -v npm &> /dev/null && [ -f "package.json" ]; then
    echo "Running npm audit..."
    npm audit --audit-level=high 2>/dev/null | head -30
fi

echo ""
echo "--- SECURITY HEADERS ---"
echo "Helmet/security header configuration:"
grep -rn "helmet\|Content-Security-Policy\|X-Frame-Options\|Strict-Transport" --include="*.ts" --include="*.js" 2>/dev/null | head -10

echo ""
echo "--- BUILD CONFIGURATION ---"
echo "Source maps:"
grep -rn "sourceMap\|productionSourceMap" --include="*.config.*" 2>/dev/null | head -5

echo ""
echo "Debug flags:"
grep -rn "debug.*true\|DEBUG" --include="*.ts" --include="*.js" --include="*.config.*" 2>/dev/null | head -5

echo ""
echo "--- GITIGNORE CHECK ---"
if [ -f ".gitignore" ]; then
    echo "Environment files in .gitignore:"
    grep -i "\.env" .gitignore
else
    echo "WARNING: No .gitignore found!"
fi

echo ""
echo "=== SCAN COMPLETE ==="
```

---

## OWASP/CWE References

| Issue | OWASP | CWE |
|-------|-------|-----|
| Hardcoded Credentials | A02:2021 | CWE-798 |
| Missing Security Headers | A05:2021 | CWE-693 |
| Vulnerable Dependencies | A06:2021 | CWE-1395 |
| Insufficient Logging | A09:2021 | CWE-778 |
| Secrets in Code | A02:2021 | CWE-312 |
| Missing TLS | A02:2021 | CWE-319 |
| Improper Error Handling | A05:2021 | CWE-209 |
