# Frontend Security Audit Checklist

## Audit Philosophy

**The frontend is enemy territory.** Every line of JavaScript runs on a machine you don't control. Every input comes from a user you can't trust. Every API response could be intercepted. Your job is to find EVERY vulnerability before attackers do - XSS, data leaks, insecure storage, and DOM manipulation attacks.

---

## 1. Cross-Site Scripting (XSS) Audit

### 1.1 Reflected XSS
- [ ] **URL parameters sanitized** - Query strings not rendered directly
- [ ] **Hash fragments sanitized** - window.location.hash not trusted
- [ ] **Referrer not rendered** - document.referrer not injected
- [ ] **Error messages sanitized** - Error params not reflected

```bash
# Find URL parameter usage
grep -rn "searchParams\|URLSearchParams\|query\.\|req\.query\|useSearchParams\|location\.search" --include="*.tsx" --include="*.jsx" --include="*.ts"

# Find hash fragment usage
grep -rn "location\.hash\|window\.location\.hash" --include="*.tsx" --include="*.jsx" --include="*.ts"

# Find URL rendering
grep -rn "router\.query\|useRouter\|params\." --include="*.tsx" --include="*.jsx" | head -30
```

### 1.2 Stored XSS
- [ ] **User content escaped** - All user-generated content sanitized
- [ ] **Database content escaped** - Data from DB treated as untrusted
- [ ] **API responses escaped** - External API data sanitized
- [ ] **Comments/reviews sanitized** - Rich text areas XSS-safe
- [ ] **Profile fields sanitized** - Usernames, bios, etc.

```bash
# Find places rendering user/external content
grep -rn "user\.\|data\.\|response\.\|content\.\|body\.\|message\.\|comment\." --include="*.tsx" --include="*.jsx" | grep -v "console\|import\|type\|interface" | head -50
```

### 1.3 DOM-Based XSS
- [ ] **innerHTML avoided** - Using textContent or safe alternatives
- [ ] **dangerouslySetInnerHTML audited** - Every usage reviewed
- [ ] **document.write never used** - Legacy danger function
- [ ] **jQuery .html() avoided** - If jQuery present
- [ ] **v-html audited** - Vue directive reviewed
- [ ] **ng-bind-html audited** - Angular directive reviewed

```bash
# Find dangerous DOM methods
grep -rn "innerHTML\|outerHTML\|dangerouslySetInnerHTML\|document\.write\|\.html\(" --include="*.tsx" --include="*.jsx" --include="*.ts" --include="*.vue" --include="*.html"

# Find template literal injection
grep -rn "\`.*\${" --include="*.tsx" --include="*.jsx" | grep -i "html\|render\|insert"
```

### 1.4 XSS Sinks
- [ ] **eval() never used** - Extremely dangerous
- [ ] **new Function() never used** - Dynamic code execution
- [ ] **setTimeout/setInterval with strings** - Use functions instead
- [ ] **javascript: URLs blocked** - href="javascript:..."
- [ ] **data: URLs sanitized** - Can execute scripts

```bash
# Find code execution sinks
grep -rn "\beval\s*(\|new\s*Function\s*(\|setTimeout\s*(\s*['\"\`]\|setInterval\s*(\s*['\"\`]" --include="*.tsx" --include="*.jsx" --include="*.ts"

# Find dangerous URL schemes
grep -rn "javascript:\|data:\s*text/html" --include="*.tsx" --include="*.jsx" --include="*.html"
```

### 1.5 XSS in Third-Party Context
- [ ] **PostMessage validated** - Origin checked on message handlers
- [ ] **Iframe sandbox** - Embedded content sandboxed
- [ ] **Third-party scripts audited** - CDN scripts reviewed

```bash
# Find postMessage usage
grep -rn "postMessage\|addEventListener.*message\|onmessage" --include="*.tsx" --include="*.jsx" --include="*.ts"

# Find iframe usage
grep -rn "<iframe\|<Iframe" --include="*.tsx" --include="*.jsx" --include="*.html"
```

---

## 2. Client-Side Data Exposure

### 2.1 Sensitive Data in JavaScript
- [ ] **No secrets in bundles** - API keys, passwords not in JS
- [ ] **No PII in initial state** - Personal data not hardcoded
- [ ] **Environment variables checked** - Only NEXT_PUBLIC_* exposed
- [ ] **Source maps disabled in production** - Code not readable

```bash
# Find potential secrets
grep -rn "apiKey\|api_key\|secret\|password\|token" --include="*.tsx" --include="*.jsx" --include="*.ts" | grep -v "type\|interface\|process\.env\|\.env"

# Find environment variable exposure
grep -rn "process\.env\." --include="*.tsx" --include="*.jsx" --include="*.ts"

# Check for bearer tokens in code
grep -rn "Bearer\s" --include="*.tsx" --include="*.jsx" --include="*.ts"
```

### 2.2 Console & Debug Leaks
- [ ] **console.log cleaned** - No sensitive data logged
- [ ] **Debug mode disabled** - No debug flags in production
- [ ] **Error details hidden** - Stack traces not shown to users
- [ ] **Redux DevTools disabled** - In production builds

```bash
# Find console statements
grep -rn "console\.\(log\|debug\|info\|warn\|error\)" --include="*.tsx" --include="*.jsx" --include="*.ts" | grep -v "test\|spec\|mock"

# Find debug flags
grep -rn "debug\s*[=:]\s*true\|DEBUG\|isDev\|isDebug" --include="*.tsx" --include="*.jsx" --include="*.ts"
```

### 2.3 Local Storage Security
- [ ] **No tokens in localStorage** - Use httpOnly cookies instead
- [ ] **No sensitive data in localStorage** - Accessible to XSS
- [ ] **No PII in localStorage** - Personal data exposure
- [ ] **Encryption if necessary** - Encrypt sensitive local data

```bash
# Find localStorage usage
grep -rn "localStorage\|sessionStorage" --include="*.tsx" --include="*.jsx" --include="*.ts"

# Check what's being stored
grep -rn "localStorage\.\(setItem\|getItem\)" --include="*.tsx" --include="*.jsx" --include="*.ts" -A 1
```

### 2.4 Browser History Exposure
- [ ] **Sensitive URLs avoided** - No tokens in URLs
- [ ] **History.replaceState for sensitive** - Don't leave trace
- [ ] **Query params sanitized** - No sensitive params logged

### 2.5 Network Tab Exposure
- [ ] **Sensitive data in POST body** - Not GET params
- [ ] **Response filtering** - API doesn't over-return data
- [ ] **No credentials in URLs** - Not visible in network tab

---

## 3. Content Security Policy (CSP)

### 3.1 CSP Headers Present
- [ ] **CSP header exists** - Content-Security-Policy set
- [ ] **default-src restrictive** - Not 'unsafe-inline' 'unsafe-eval'
- [ ] **script-src defined** - Script sources whitelisted
- [ ] **style-src defined** - Style sources whitelisted
- [ ] **img-src defined** - Image sources whitelisted
- [ ] **connect-src defined** - XHR/fetch destinations whitelisted

```bash
# Find CSP configuration
grep -rn "Content-Security-Policy\|contentSecurityPolicy\|csp" --include="*.ts" --include="*.tsx" --include="*.js" --include="*.json" --include="*.config.*"

# Check for unsafe directives
grep -rn "unsafe-inline\|unsafe-eval" --include="*.ts" --include="*.tsx" --include="*.js" --include="*.json"
```

### 3.2 CSP Violations
- [ ] **No inline scripts** - Or nonce/hash if necessary
- [ ] **No inline styles** - Or nonce/hash if necessary
- [ ] **No eval()** - Ever
- [ ] **No data: URIs for scripts** - Unless explicitly needed

### 3.3 CSP Reporting
- [ ] **report-uri configured** - CSP violations reported
- [ ] **report-to configured** - Modern reporting API
- [ ] **Violations monitored** - Reports are reviewed

---

## 4. Subresource Integrity (SRI)

### 4.1 External Scripts
- [ ] **CDN scripts have integrity** - SRI hashes present
- [ ] **crossorigin="anonymous"** - Required for SRI
- [ ] **Fallback if SRI fails** - Graceful degradation

```bash
# Find external script tags
grep -rn "<script.*src.*http\|<Script.*src.*http" --include="*.tsx" --include="*.jsx" --include="*.html"

# Check for integrity attribute
grep -rn "integrity=" --include="*.tsx" --include="*.jsx" --include="*.html"
```

### 4.2 External Stylesheets
- [ ] **CDN styles have integrity** - SRI for CSS too
- [ ] **Font integrity** - If loading fonts from CDN

---

## 5. Clickjacking Protection

### 5.1 Frame Protection
- [ ] **X-Frame-Options header** - DENY or SAMEORIGIN
- [ ] **frame-ancestors in CSP** - Modern protection
- [ ] **Framebusting JavaScript** - Last resort backup

```bash
# Find frame options configuration
grep -rn "X-Frame-Options\|frame-ancestors" --include="*.ts" --include="*.tsx" --include="*.js" --include="*.json" --include="*.config.*"
```

### 5.2 Sensitive Actions
- [ ] **CSRF protection** - For state-changing actions
- [ ] **Confirmation dialogs** - For destructive actions
- [ ] **Re-authentication** - For highly sensitive actions

---

## 6. Authentication Security (Frontend)

### 6.1 Credential Handling
- [ ] **Passwords not stored** - Never in localStorage/state
- [ ] **Tokens in httpOnly cookies** - Not accessible to JS
- [ ] **Session managed server-side** - Not client-side
- [ ] **Logout clears everything** - Complete cleanup

```bash
# Find credential handling
grep -rn "password\|credential\|auth" --include="*.tsx" --include="*.jsx" --include="*.ts" | grep -v "type\|interface\|test"
```

### 6.2 Token Handling
- [ ] **Access tokens short-lived** - Refresh token pattern
- [ ] **Refresh tokens httpOnly** - Not accessible to XSS
- [ ] **Token rotation** - Refresh tokens rotated on use
- [ ] **Token revocation** - Logout invalidates tokens

### 6.3 Login Form Security
- [ ] **Autocomplete appropriate** - autocomplete="current-password"
- [ ] **No password visibility by default** - Show toggle, but hidden default
- [ ] **Rate limiting feedback** - Show lockout info
- [ ] **HTTPS only** - Mixed content blocked

---

## 7. Input Validation (Client-Side)

### 7.1 Form Validation
- [ ] **Client validation for UX** - Not security, just UX
- [ ] **Server validation mandatory** - Never trust client
- [ ] **Type coercion handled** - "123" vs 123 issues
- [ ] **Length limits enforced** - Max lengths set

```bash
# Find form validation
grep -rn "validate\|validation\|schema\|yup\|zod" --include="*.tsx" --include="*.jsx" --include="*.ts"

# Find form handling
grep -rn "onSubmit\|handleSubmit\|form\." --include="*.tsx" --include="*.jsx"
```

### 7.2 File Upload Security
- [ ] **File type validation** - MIME type and extension
- [ ] **File size limits** - Client-side max size
- [ ] **Filename sanitization** - Special chars removed
- [ ] **No direct URLs to uploads** - Served through API

```bash
# Find file upload handling
grep -rn "type=\"file\"\|input.*file\|FileReader\|FormData" --include="*.tsx" --include="*.jsx" --include="*.ts"

# Find file processing
grep -rn "\.files\|accept=\|multiple" --include="*.tsx" --include="*.jsx"
```

### 7.3 URL Validation
- [ ] **URL scheme whitelist** - Only http/https allowed
- [ ] **No javascript: URLs** - Block completely
- [ ] **Redirect URL validation** - Open redirect prevention

```bash
# Find URL handling
grep -rn "href=\|window\.open\|location\.href\|location\.assign\|location\.replace" --include="*.tsx" --include="*.jsx" --include="*.ts"

# Find redirect handling
grep -rn "redirect\|returnUrl\|returnTo\|next=\|callbackUrl" --include="*.tsx" --include="*.jsx" --include="*.ts"
```

---

## 8. Third-Party Integration Security

### 8.1 Script Loading
- [ ] **CDN scripts pinned** - Version-specific URLs
- [ ] **SRI for external scripts** - Integrity verification
- [ ] **Minimal third-party scripts** - Only what's needed
- [ ] **Script loading audited** - Review what they do

```bash
# Find third-party script loading
grep -rn "<script.*src=\|<Script.*src=" --include="*.tsx" --include="*.jsx" --include="*.html"

# Find dynamic script injection
grep -rn "createElement.*script\|appendChild.*script" --include="*.tsx" --include="*.jsx" --include="*.ts"
```

### 8.2 Third-Party Data Sharing
- [ ] **Analytics minimal** - Only necessary data
- [ ] **No PII to analytics** - Personal data anonymized
- [ ] **Cookie consent** - GDPR compliance
- [ ] **Third-party cookies blocked** - If not needed

### 8.3 OAuth/Social Login
- [ ] **State parameter used** - CSRF in OAuth
- [ ] **Nonce parameter used** - Replay prevention
- [ ] **PKCE implemented** - For SPAs
- [ ] **Redirect URI exact match** - No wildcards

```bash
# Find OAuth implementations
grep -rn "oauth\|OAuth\|signin\|signIn\|google\|facebook\|github" --include="*.tsx" --include="*.jsx" --include="*.ts" | grep -v "test\|mock"
```

---

## 9. Browser APIs Security

### 9.1 Dangerous APIs
- [ ] **Geolocation permission** - Only when needed, user consent
- [ ] **Camera/microphone** - Explicit permission, clear purpose
- [ ] **Clipboard access** - User-initiated only
- [ ] **Notification permission** - Not requested immediately

```bash
# Find browser API usage
grep -rn "geolocation\|getUserMedia\|navigator\.clipboard\|Notification\|permissions" --include="*.tsx" --include="*.jsx" --include="*.ts"
```

### 9.2 Web Storage APIs
- [ ] **IndexedDB sensitive data** - Encrypted if sensitive
- [ ] **Cache API** - Not storing sensitive responses
- [ ] **Service Worker** - Careful with cached data

### 9.3 Fetch/XHR Security
- [ ] **credentials mode appropriate** - same-origin, include, omit
- [ ] **CORS headers checked** - Server returns proper headers
- [ ] **Response validation** - Check Content-Type, status

```bash
# Find fetch/XHR usage
grep -rn "fetch\s*(\|axios\.\|XMLHttpRequest" --include="*.tsx" --include="*.jsx" --include="*.ts"

# Check credentials mode
grep -rn "credentials:\|withCredentials" --include="*.tsx" --include="*.jsx" --include="*.ts"
```

---

## 10. Error Handling Security

### 10.1 Error Disclosure
- [ ] **Stack traces hidden** - Not shown in production
- [ ] **Generic error messages** - No internal details to user
- [ ] **Error boundaries** - Graceful React error handling
- [ ] **API errors sanitized** - Server errors not exposed verbatim

```bash
# Find error handling
grep -rn "catch\s*(\|\.catch\|onError\|ErrorBoundary\|error\s*=>" --include="*.tsx" --include="*.jsx" --include="*.ts"

# Find error display
grep -rn "error\.\(message\|stack\|details\)" --include="*.tsx" --include="*.jsx"
```

### 10.2 Error Logging
- [ ] **Errors logged safely** - No sensitive data in error logs
- [ ] **Error service configured** - Sentry, LogRocket, etc.
- [ ] **PII scrubbed from errors** - Before sending to service

---

## 11. State Management Security

### 11.1 Global State
- [ ] **No secrets in Redux/store** - Visible in DevTools
- [ ] **Sensitive state encrypted** - If must be in state
- [ ] **State cleared on logout** - Complete reset

```bash
# Find state management
grep -rn "createStore\|configureStore\|useReducer\|useState\|zustand\|mobx\|recoil" --include="*.tsx" --include="*.jsx" --include="*.ts"

# Find what's being stored
grep -rn "dispatch\|setState\|set\s*(" --include="*.tsx" --include="*.jsx" | grep -v "test\|spec" | head -50
```

### 11.2 URL State
- [ ] **No sensitive data in URL** - Visible in history, logs
- [ ] **State serialization safe** - XSS through URL state

### 11.3 Form State
- [ ] **Sensitive fields not persisted** - Password not in form state
- [ ] **Form state cleared** - After submission or navigation

---

## 12. Build & Deployment Security

### 12.1 Build Process
- [ ] **Source maps disabled** - In production
- [ ] **Console statements stripped** - Build removes them
- [ ] **Dead code eliminated** - No unused endpoints
- [ ] **Bundle analyzed** - Know what's in there

```bash
# Check build configuration
cat next.config.* package.json vite.config.* 2>/dev/null | grep -i "sourceMap\|devtool\|console"

# Find build scripts
grep -n "build\|prod\|production" package.json 2>/dev/null
```

### 12.2 Environment Variables
- [ ] **Only public vars exposed** - NEXT_PUBLIC_*, VITE_*, REACT_APP_*
- [ ] **No build-time secret leaks** - Secrets not in bundle
- [ ] **.env files gitignored** - Not committed

```bash
# Check .gitignore for env files
cat .gitignore 2>/dev/null | grep -i "\.env"

# Find environment variable usage
grep -rn "process\.env\.\|import\.meta\.env\." --include="*.tsx" --include="*.jsx" --include="*.ts"
```

### 12.3 Dependencies
- [ ] **npm audit clean** - No known vulnerabilities
- [ ] **Lockfile committed** - package-lock.json in repo
- [ ] **Dependencies audited** - Know what you're using
- [ ] **Minimal dependencies** - Only what's needed

```bash
# Run dependency audit
npm audit 2>/dev/null || yarn audit 2>/dev/null || pnpm audit 2>/dev/null

# Check for outdated
npm outdated 2>/dev/null || yarn outdated 2>/dev/null
```

---

## Code Search Commands Summary

```bash
# === XSS VULNERABILITIES ===
# Dangerous DOM methods
grep -rn "innerHTML\|outerHTML\|dangerouslySetInnerHTML\|document\.write" --include="*.tsx" --include="*.jsx" --include="*.ts"

# Code execution
grep -rn "\beval\s*(\|new\s*Function\s*(" --include="*.tsx" --include="*.jsx" --include="*.ts"

# Template injection
grep -rn "\`.*\${.*user\|\`.*\${.*data\|\`.*\${.*input" --include="*.tsx" --include="*.jsx"

# === DATA EXPOSURE ===
# Secrets in code
grep -rn "apiKey\|api_key\|secret\|password\|token" --include="*.tsx" --include="*.jsx" --include="*.ts" | grep -v "type\|interface"

# Console logging
grep -rn "console\." --include="*.tsx" --include="*.jsx" --include="*.ts" | wc -l

# LocalStorage sensitive data
grep -rn "localStorage\.setItem.*token\|localStorage\.setItem.*password\|localStorage\.setItem.*user" --include="*.tsx" --include="*.jsx" --include="*.ts"

# === URL HANDLING ===
# Open redirects
grep -rn "redirect\|returnUrl\|returnTo\|callbackUrl" --include="*.tsx" --include="*.jsx" --include="*.ts"

# Dangerous URL schemes
grep -rn "javascript:\|data:text/html" --include="*.tsx" --include="*.jsx" --include="*.html"

# === AUTHENTICATION ===
# Token handling
grep -rn "Bearer\|authorization\|Authorization" --include="*.tsx" --include="*.jsx" --include="*.ts"

# Credential storage
grep -rn "localStorage.*password\|localStorage.*token\|sessionStorage.*password" --include="*.tsx" --include="*.jsx" --include="*.ts"

# === THIRD PARTY ===
# External scripts
grep -rn "<script.*src=.*http" --include="*.tsx" --include="*.jsx" --include="*.html"

# PostMessage
grep -rn "postMessage\|addEventListener.*message" --include="*.tsx" --include="*.jsx" --include="*.ts"
```

---

## OWASP/CWE References

| Vulnerability | OWASP | CWE |
|--------------|-------|-----|
| Reflected XSS | A03:2021 | CWE-79 |
| Stored XSS | A03:2021 | CWE-79 |
| DOM-based XSS | A03:2021 | CWE-79 |
| Sensitive Data Exposure | A02:2021 | CWE-200 |
| Missing CSP | A05:2021 | CWE-1021 |
| Clickjacking | A05:2021 | CWE-1021 |
| Insecure Storage | A02:2021 | CWE-922 |
| Open Redirect | A01:2021 | CWE-601 |
