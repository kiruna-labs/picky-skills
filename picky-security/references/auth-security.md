# Authentication & Authorization Security Audit

## Audit Philosophy

**Auth is the crown jewels.** A single auth bypass can compromise your entire application. A session hijack exposes all user data. A privilege escalation turns any user into an admin. Your job is to find EVERY weakness in authentication, session management, and access control.

---

## 1. Authentication Mechanisms

### 1.1 Password Authentication
- [ ] **Password hashing strong** - bcrypt, scrypt, or Argon2
- [ ] **Salt unique per password** - Not global salt
- [ ] **Work factor adequate** - bcrypt cost 10+, Argon2 tuned
- [ ] **No MD5/SHA1 for passwords** - Cryptographically weak
- [ ] **Password not logged** - Never in logs, errors, or console

```bash
# Find password hashing
grep -rn "bcrypt\|scrypt\|argon2\|pbkdf2\|hashPassword\|hash\s*(" --include="*.ts" --include="*.js" --include="*.py"

# Find dangerous hashing
grep -rn "md5\|sha1\|SHA1\|createHash\s*(\s*['\"]md5\|createHash\s*(\s*['\"]sha1" --include="*.ts" --include="*.js" --include="*.py"

# Find password handling
grep -rn "password" --include="*.ts" --include="*.js" | grep -v "type\|interface\|\.d\.ts" | head -30
```

### 1.2 Password Policy
- [ ] **Minimum length enforced** - 8+ characters (12+ preferred)
- [ ] **Complexity reasonable** - Not just "needs uppercase"
- [ ] **Breached password check** - Against HaveIBeenPwned
- [ ] **No maximum length** - Or very high (200+)
- [ ] **No character restrictions** - Allow all Unicode

```bash
# Find password validation
grep -rn "password.*length\|password.*min\|validatePassword\|passwordSchema" --include="*.ts" --include="*.js" --include="*.py"
```

### 1.3 Multi-Factor Authentication
- [ ] **MFA available** - For sensitive accounts
- [ ] **MFA enforced** - For admin accounts
- [ ] **TOTP implemented correctly** - 30-second window
- [ ] **Backup codes secure** - One-time use, stored hashed
- [ ] **Recovery process secure** - Can't bypass MFA easily

```bash
# Find MFA implementation
grep -rn "totp\|2fa\|mfa\|authenticator\|speakeasy\|otplib" --include="*.ts" --include="*.js" --include="*.py"
```

### 1.4 Authentication Bypass Testing
- [ ] **Empty password blocked** - Can't submit blank
- [ ] **Type juggling safe** - Strict comparison
- [ ] **NULL password handled** - Doesn't match anything
- [ ] **Case sensitivity correct** - For usernames/emails

---

## 2. Session Management

### 2.1 Session Token Generation
- [ ] **Cryptographically random** - crypto.randomBytes, not Math.random
- [ ] **Sufficient entropy** - 128+ bits
- [ ] **Unpredictable** - Not sequential, not timestamp-based
- [ ] **Not user-derivable** - Can't guess from user data

```bash
# Find session/token generation
grep -rn "randomBytes\|randomUUID\|crypto\.random\|uuid\|nanoid\|token" --include="*.ts" --include="*.js" --include="*.py"

# Find insecure random
grep -rn "Math\.random\|random\.randint\|time\.\|Date\.now" --include="*.ts" --include="*.js" --include="*.py" | grep -i "token\|session\|id\|secret"
```

### 2.2 Session Token Storage (Server)
- [ ] **Tokens hashed in DB** - Not stored plaintext
- [ ] **Expiration tracked** - Tokens have TTL
- [ ] **User association secure** - Can't modify user link
- [ ] **Revocation possible** - Can invalidate tokens

### 2.3 Session Token Transport
- [ ] **httpOnly cookie** - Not accessible to JS
- [ ] **Secure flag** - Only over HTTPS
- [ ] **SameSite attribute** - Lax or Strict
- [ ] **Domain scoped** - Not too broad
- [ ] **Path scoped** - If applicable

```bash
# Find cookie configuration
grep -rn "httpOnly\|secure\|sameSite\|cookie\|Cookie" --include="*.ts" --include="*.js" --include="*.py"

# Find session configuration
grep -rn "session\s*[\(:{]\|express-session\|next-auth\|passport" --include="*.ts" --include="*.js"
```

### 2.4 Session Lifecycle
- [ ] **Login creates new session** - Session fixation prevention
- [ ] **Logout invalidates server-side** - Token revoked
- [ ] **Idle timeout** - Inactive sessions expire
- [ ] **Absolute timeout** - Sessions expire after max time
- [ ] **Concurrent session handling** - Policy defined

### 2.5 Session Token Client-Side
- [ ] **Not in localStorage** - XSS accessible
- [ ] **Not in URL** - Visible in logs, referrer
- [ ] **Not in form fields** - Visible in page source
- [ ] **Cleared on logout** - Client-side cleanup

---

## 3. JWT Security

### 3.1 JWT Algorithm
- [ ] **Algorithm explicit** - Not from header
- [ ] **Algorithm strong** - RS256, RS384, RS512, ES256, etc.
- [ ] **No algorithm: none** - Disabled completely
- [ ] **No HS256 with public key** - If using asymmetric

```bash
# Find JWT configuration
grep -rn "jwt\|jsonwebtoken\|jose\|JWT" --include="*.ts" --include="*.js" --include="*.py"

# Find algorithm configuration
grep -rn "algorithm\|alg:" --include="*.ts" --include="*.js" | grep -i "jwt\|token\|auth"

# Find dangerous algorithm settings
grep -rn "none\|HS256\|alg\s*:\s*header" --include="*.ts" --include="*.js"
```

### 3.2 JWT Claims
- [ ] **exp claim present** - Token expires
- [ ] **iat claim present** - Issued-at for tracking
- [ ] **nbf claim if needed** - Not-before time
- [ ] **iss claim validated** - Issuer checked
- [ ] **aud claim validated** - Audience checked
- [ ] **sub claim for user** - Subject identifies user

### 3.3 JWT Validation
- [ ] **Signature always verified** - Before using claims
- [ ] **Expiration always checked** - Not just if present
- [ ] **Clock skew handled** - Small tolerance
- [ ] **Claims validated** - Not just decoded and used

### 3.4 JWT Storage
- [ ] **Access token short-lived** - 15 minutes or less
- [ ] **Refresh token httpOnly** - Not accessible to JS
- [ ] **Refresh token rotation** - New token on refresh
- [ ] **Token revocation possible** - Blocklist or versioning

---

## 4. OAuth/OIDC Security

### 4.1 OAuth Implementation
- [ ] **State parameter used** - CSRF prevention
- [ ] **State validated** - On callback
- [ ] **PKCE implemented** - For SPAs/mobile
- [ ] **Code verifier strong** - High entropy
- [ ] **Redirect URI exact match** - No wildcards

```bash
# Find OAuth implementation
grep -rn "oauth\|OAuth\|openid\|OIDC\|passport\|next-auth\|authjs" --include="*.ts" --include="*.js" --include="*.py"

# Find state parameter
grep -rn "state\s*[=:]\|generateState\|validateState" --include="*.ts" --include="*.js" | grep -v "useState"

# Find PKCE
grep -rn "code_verifier\|code_challenge\|PKCE\|pkce" --include="*.ts" --include="*.js"
```

### 4.2 Token Handling
- [ ] **Access token scoped** - Minimum needed scopes
- [ ] **Token storage secure** - Server-side preferred
- [ ] **Token refresh handled** - Before expiration
- [ ] **Revocation on unlink** - When user disconnects

### 4.3 Provider Security
- [ ] **Trusted providers only** - Known OAuth providers
- [ ] **Provider config secure** - No secrets exposed
- [ ] **ID token validated** - If using OIDC
- [ ] **Nonce validated** - For OIDC

---

## 5. Password Reset Security

### 5.1 Reset Token
- [ ] **Cryptographically random** - Not predictable
- [ ] **Single use** - Invalidated after use
- [ ] **Short-lived** - 1 hour or less
- [ ] **Hashed in storage** - Not stored plaintext
- [ ] **User-bound** - Can't use for other users

```bash
# Find password reset implementation
grep -rn "reset.*password\|password.*reset\|forgot.*password\|recovery" --include="*.ts" --include="*.js" --include="*.py"

# Find reset token generation
grep -rn "resetToken\|passwordToken\|recoveryToken" --include="*.ts" --include="*.js" --include="*.py"
```

### 5.2 Reset Process
- [ ] **User enumeration prevented** - Same response for valid/invalid
- [ ] **Rate limited** - Prevent abuse
- [ ] **Notification sent** - To old email
- [ ] **Old sessions invalidated** - After reset
- [ ] **MFA not bypassed** - If previously enabled

### 5.3 Reset Verification
- [ ] **Token in URL safe** - HTTPS, not logged
- [ ] **Token consumed on load** - Or separate POST
- [ ] **Re-authentication required** - Enter new password only

---

## 6. Access Control (Authorization)

### 6.1 Role-Based Access Control (RBAC)
- [ ] **Roles defined** - Clear role hierarchy
- [ ] **Permissions granular** - Not just admin/user
- [ ] **Default deny** - No access unless granted
- [ ] **Roles stored server-side** - Not in JWT claims alone

```bash
# Find role checking
grep -rn "role\|permission\|authorize\|isAdmin\|isAuthenticated\|canAccess\|hasPermission" --include="*.ts" --include="*.js" --include="*.py"

# Find access control middleware
grep -rn "middleware\|guard\|interceptor" --include="*.ts" --include="*.js" | grep -i "auth\|role\|permission"
```

### 6.2 Object-Level Authorization (IDOR)
- [ ] **Every object access checked** - Not just list level
- [ ] **User owns object** - Before read/write
- [ ] **No ID enumeration** - UUIDs or access check
- [ ] **Nested objects checked** - user.posts[0].comments

```bash
# Find object access patterns
grep -rn "params\.id\|params\..*Id\|query\.id" --include="*.ts" --include="*.js" | head -30

# Find database queries with IDs
grep -rn "findOne.*id\|findUnique.*id\|where.*id" --include="*.ts" --include="*.js" | head -30

# Check for authorization in same function
grep -rn "params\.id" --include="*.ts" --include="*.js" -A 10 | grep -i "auth\|user\|owner\|permission"
```

### 6.3 Function-Level Authorization
- [ ] **Admin endpoints protected** - Explicit auth check
- [ ] **API endpoints protected** - Not just UI hidden
- [ ] **Internal endpoints secured** - Not exposed
- [ ] **Depreciated endpoints removed** - Old versions

### 6.4 Privilege Escalation Prevention
- [ ] **Horizontal escalation blocked** - Can't access other users
- [ ] **Vertical escalation blocked** - Can't become admin
- [ ] **Role modification secured** - Only admins can change
- [ ] **Self-privilege blocked** - Can't elevate own role

---

## 7. Account Security Features

### 7.1 Account Enumeration
- [ ] **Login errors generic** - "Invalid credentials" for both
- [ ] **Registration errors generic** - Or timing equal
- [ ] **Reset errors generic** - Same response time
- [ ] **Username check rate limited** - If real-time

```bash
# Find error messages
grep -rn "Invalid\|incorrect\|not found\|doesn't exist\|already exists" --include="*.ts" --include="*.js" | grep -i "user\|email\|password\|login"
```

### 7.2 Brute Force Protection
- [ ] **Login rate limited** - Per IP and/or user
- [ ] **Account lockout** - After X failures
- [ ] **Lockout notification** - User informed
- [ ] **Lockout recovery** - Time or admin unlock
- [ ] **CAPTCHA after failures** - Additional barrier

```bash
# Find rate limiting
grep -rn "rate.*limit\|rateLimit\|throttle\|limiter\|express-rate-limit\|@nestjs/throttler" --include="*.ts" --include="*.js" --include="*.py"

# Find lockout logic
grep -rn "lockout\|failedAttempts\|loginAttempts\|blocked\|banned" --include="*.ts" --include="*.js" --include="*.py"
```

### 7.3 Account Takeover Prevention
- [ ] **Email change requires confirmation** - On old and/or new
- [ ] **Password change requires current** - Re-authentication
- [ ] **Critical actions require MFA** - If MFA enabled
- [ ] **Session list viewable** - User can see sessions
- [ ] **Session revocation available** - User can logout others

### 7.4 Suspicious Activity Detection
- [ ] **New device alerts** - Unknown device notification
- [ ] **New location alerts** - Geographic anomaly
- [ ] **Impossible travel detection** - If sophisticated
- [ ] **Concurrent session alerts** - Multiple locations

---

## 8. API Authentication

### 8.1 API Key Security
- [ ] **Keys generated securely** - High entropy
- [ ] **Keys hashed in storage** - Not plaintext
- [ ] **Keys scoped** - Minimum permissions
- [ ] **Key rotation supported** - Without downtime
- [ ] **Keys revocable** - Instant invalidation

```bash
# Find API key handling
grep -rn "apiKey\|api_key\|API_KEY\|x-api-key" --include="*.ts" --include="*.js" --include="*.py"
```

### 8.2 API Authentication Methods
- [ ] **Bearer tokens validated** - Not just present
- [ ] **API keys in header** - Not in URL
- [ ] **Multiple auth supported** - Gracefully handled
- [ ] **Missing auth = 401** - Not 403 or 500

### 8.3 Service-to-Service Auth
- [ ] **Mutual TLS if needed** - For internal services
- [ ] **Service accounts separate** - Not user tokens
- [ ] **Service scope limited** - Only needed operations
- [ ] **Service tokens rotated** - Regular rotation

---

## 9. Registration Security

### 9.1 Registration Process
- [ ] **Email verification required** - Before account active
- [ ] **Verification token secure** - Single-use, time-limited
- [ ] **Duplicate prevention** - Same email blocked
- [ ] **Rate limited** - Prevent mass registration

```bash
# Find registration logic
grep -rn "register\|signup\|createUser\|createAccount" --include="*.ts" --include="*.js" --include="*.py"

# Find email verification
grep -rn "verify.*email\|email.*verify\|confirmation.*token\|verificationToken" --include="*.ts" --include="*.js" --include="*.py"
```

### 9.2 Input Validation
- [ ] **Email format validated** - RFC compliant
- [ ] **Email DNS checked** - MX record exists
- [ ] **Disposable emails blocked** - If needed
- [ ] **Username rules enforced** - Length, characters
- [ ] **Reserved usernames blocked** - admin, support, etc.

### 9.3 Invitation Systems
- [ ] **Invite tokens secure** - Single-use
- [ ] **Invite tokens scoped** - To specific email
- [ ] **Invite expiration** - Time-limited
- [ ] **Invite audit trail** - Who invited whom

---

## 10. Logout Security

### 10.1 Logout Process
- [ ] **Session destroyed server-side** - Token invalidated
- [ ] **Cookie cleared** - Client-side cleanup
- [ ] **All tokens revoked** - JWT refresh, API keys if applicable
- [ ] **Redirect to safe page** - Not back to protected
- [ ] **CSRF protected** - Logout is POST, not GET

```bash
# Find logout implementation
grep -rn "logout\|signout\|sign.*out\|destroySession\|clearSession" --include="*.ts" --include="*.js" --include="*.py"
```

### 10.2 Session Revocation
- [ ] **Logout all devices available** - Global signout
- [ ] **Individual session revoke** - Specific device logout
- [ ] **Immediate effect** - No token caching issues

---

## 11. Remember Me Functionality

### 11.1 Remember Me Token
- [ ] **Separate from session** - Different token type
- [ ] **Cryptographically random** - High entropy
- [ ] **Hashed in storage** - Not plaintext
- [ ] **User-bound** - Validated against user
- [ ] **Longer expiration** - But not infinite

```bash
# Find remember me implementation
grep -rn "rememberMe\|remember.*me\|persistent.*session\|long.*session" --include="*.ts" --include="*.js" --include="*.py"
```

### 11.2 Remember Me Security
- [ ] **Requires re-auth for sensitive** - Password change, etc.
- [ ] **Revocable individually** - User can manage
- [ ] **Limited per user** - Max remembered devices
- [ ] **Device fingerprint optional** - For added security

---

## 12. Admin & Privileged Access

### 12.1 Admin Authentication
- [ ] **Strong auth required** - MFA mandatory
- [ ] **Separate admin sessions** - Different from user
- [ ] **IP restrictions if possible** - VPN, office only
- [ ] **Session timeout shorter** - More aggressive

```bash
# Find admin-specific auth
grep -rn "admin.*auth\|isAdmin\|adminOnly\|requireAdmin" --include="*.ts" --include="*.js" --include="*.py"
```

### 12.2 Admin Actions
- [ ] **All actions logged** - Audit trail
- [ ] **Impersonation logged** - If admin can act as user
- [ ] **Destructive actions confirmed** - Extra step
- [ ] **Recovery possible** - From admin mistakes

### 12.3 Super Admin
- [ ] **Minimal super admins** - One or two
- [ ] **Super admin MFA mandatory** - Hardware key preferred
- [ ] **Super admin actions require approval** - If possible
- [ ] **Super admin access time-limited** - Just-in-time access

---

## OWASP/CWE References

| Vulnerability | OWASP 2021 | CWE |
|--------------|------------|-----|
| Broken Authentication | A07:2021 | CWE-287 |
| Broken Access Control | A01:2021 | CWE-284 |
| Session Fixation | A07:2021 | CWE-384 |
| Insecure Password Storage | A02:2021 | CWE-916 |
| IDOR | A01:2021 | CWE-639 |
| Privilege Escalation | A01:2021 | CWE-269 |
| JWT Algorithm Confusion | A02:2021 | CWE-327 |
| Credential Stuffing | A07:2021 | CWE-307 |
| Account Enumeration | A07:2021 | CWE-204 |
| Insufficient Session Expiration | A07:2021 | CWE-613 |
