# API Security Audit Checklist

## Audit Philosophy

**APIs are the new attack surface.** Every endpoint is a door. Every parameter is a potential injection point. Every response could leak sensitive data. Your job is to find EVERY API vulnerability - broken access control, injection, mass assignment, rate limiting bypass, and data exposure.

---

## 1. API Authentication Audit

### 1.1 Authentication Presence
- [ ] **All endpoints require auth** - Unless explicitly public
- [ ] **Public endpoints documented** - Known and intentional
- [ ] **OPTIONS/HEAD same auth** - Not bypassing via method
- [ ] **Websocket auth present** - If websockets used
- [ ] **GraphQL auth enforced** - On all operations

```bash
# Find route/endpoint definitions
grep -rn "app\.\(get\|post\|put\|patch\|delete\)\|router\.\(get\|post\|put\|patch\|delete\)\|@Get\|@Post\|@Put\|@Patch\|@Delete" --include="*.ts" --include="*.js"

# Find auth middleware application
grep -rn "authenticate\|isAuthenticated\|requireAuth\|authMiddleware\|@UseGuards\|@Authenticated" --include="*.ts" --include="*.js"

# Find potentially unprotected endpoints
grep -rn "\.get\s*(\|\.post\s*(\|\.put\s*(\|\.delete\s*(" --include="*.ts" --include="*.js" | grep -v "auth\|Auth\|protect\|guard"
```

### 1.2 Authentication Validation
- [ ] **Token validated every request** - Not cached
- [ ] **Token expiration checked** - Before processing
- [ ] **Token signature verified** - Not just decoded
- [ ] **Invalid token = 401** - Consistent response

### 1.3 API Key Authentication
- [ ] **Keys in header** - Not in URL
- [ ] **Keys not logged** - Scrubbed from logs
- [ ] **Keys rotatable** - Without downtime
- [ ] **Key scopes enforced** - Limited permissions

---

## 2. API Authorization Audit

### 2.1 Endpoint Authorization
- [ ] **Admin endpoints protected** - Role check
- [ ] **User endpoints scoped** - Only own resources
- [ ] **Bulk operations authorized** - Each item checked
- [ ] **GraphQL resolvers authorized** - Field-level

```bash
# Find admin/privileged endpoints
grep -rn "admin\|Admin" --include="*.ts" --include="*.js" | grep -i "route\|endpoint\|path\|api"

# Find authorization checks
grep -rn "authorize\|hasPermission\|canAccess\|checkRole\|@Roles\|@Policy" --include="*.ts" --include="*.js"
```

### 2.2 Resource Authorization (BOLA/IDOR)
- [ ] **Resource ID ownership verified** - User owns resource
- [ ] **Nested resources verified** - All levels checked
- [ ] **Reference IDs verified** - Foreign keys checked
- [ ] **Batch operations verified** - Each item in batch

```bash
# Find ID-based lookups
grep -rn "params\.id\|params\.\w*Id\|req\.params\." --include="*.ts" --include="*.js"

# Check if authorization follows
grep -rn "params\.id" --include="*.ts" --include="*.js" -A 15 | grep -i "user\.\|userId\|owner\|authorize"
```

### 2.3 Property Authorization (BFLA)
- [ ] **Write operations field-limited** - Can't write admin fields
- [ ] **Read operations field-limited** - Can't read sensitive fields
- [ ] **Update operations scoped** - Only allowed fields

---

## 3. Input Validation Audit

### 3.1 Schema Validation
- [ ] **Request body validated** - Schema enforcement
- [ ] **Query params validated** - Type/format checked
- [ ] **Path params validated** - Format verified
- [ ] **Headers validated** - If custom headers used
- [ ] **Files validated** - Type, size, content

```bash
# Find validation libraries
grep -rn "zod\|yup\|joi\|class-validator\|express-validator\|ajv\|typebox" --include="*.ts" --include="*.js" --include="package.json"

# Find validation usage
grep -rn "validate\|schema\|\.parse\|\.safeParse" --include="*.ts" --include="*.js"

# Find unvalidated input usage
grep -rn "req\.body\.\|req\.query\.\|req\.params\." --include="*.ts" --include="*.js" | grep -v "validate\|schema\|parse"
```

### 3.2 Type Coercion
- [ ] **String IDs stay strings** - No automatic coercion
- [ ] **Numbers validated as numbers** - Type safety
- [ ] **Arrays validated as arrays** - Not single values
- [ ] **Objects validated as objects** - Not strings

### 3.3 Boundary Validation
- [ ] **String length limits** - Max lengths enforced
- [ ] **Array size limits** - Max items enforced
- [ ] **Numeric ranges** - Min/max enforced
- [ ] **Nested depth limits** - Object nesting capped

### 3.4 Format Validation
- [ ] **Email format validated** - RFC compliant
- [ ] **URL format validated** - Scheme whitelist
- [ ] **Date format validated** - ISO 8601 or specified
- [ ] **UUID format validated** - If using UUIDs
- [ ] **Phone format validated** - If applicable

---

## 4. Rate Limiting Audit

### 4.1 Rate Limit Presence
- [ ] **Global rate limits** - Per-IP baseline
- [ ] **Per-user limits** - Authenticated users
- [ ] **Per-endpoint limits** - Sensitive endpoints stricter
- [ ] **Per-operation limits** - Cost-based limiting

```bash
# Find rate limiting
grep -rn "rate.*limit\|rateLimit\|throttle\|express-rate-limit\|@Throttle\|limiter" --include="*.ts" --include="*.js" --include="*.py"

# Find rate limit configuration
grep -rn "windowMs\|max:\|limit:\|points:" --include="*.ts" --include="*.js" | head -20
```

### 4.2 Rate Limit Configuration
- [ ] **Login stricter** - Lower limits for auth endpoints
- [ ] **Password reset stricter** - Abuse prevention
- [ ] **API creation stricter** - Resource-intensive ops
- [ ] **Search stricter** - Expensive queries limited

### 4.3 Rate Limit Bypass Prevention
- [ ] **IP spoofing blocked** - X-Forwarded-For validated
- [ ] **Distributed attacks considered** - Not just per-IP
- [ ] **User switching blocked** - Account enumeration via switching
- [ ] **Retry-After header** - Inform clients

### 4.4 Rate Limit Response
- [ ] **429 status returned** - Correct status code
- [ ] **No sensitive info in 429** - Don't reveal user existence
- [ ] **Consistent timing** - Don't reveal info via timing

---

## 5. CORS Configuration Audit

### 5.1 CORS Headers
- [ ] **Origin validated** - Not wildcard with credentials
- [ ] **Origin whitelist** - Specific allowed origins
- [ ] **Methods restricted** - Only needed methods
- [ ] **Headers restricted** - Only needed headers
- [ ] **Credentials handling correct** - If needed

```bash
# Find CORS configuration
grep -rn "cors\|CORS\|Access-Control" --include="*.ts" --include="*.js" --include="*.py"

# Find dangerous CORS
grep -rn "origin:\s*['\"]?\*\|origin:\s*true\|credentials:\s*true" --include="*.ts" --include="*.js"

# Find dynamic origin (potentially dangerous)
grep -rn "origin:\s*function\|origin:\s*\(" --include="*.ts" --include="*.js"
```

### 5.2 CORS Misconfigurations
- [ ] **No wildcard with credentials** - Blocked by browser anyway
- [ ] **No null origin** - CVE potential
- [ ] **No regex bypass** - Subdomain takeover risk
- [ ] **Preflight cached appropriately** - Max-Age set

### 5.3 CORS vs Authentication
- [ ] **CORS doesn't replace auth** - Still need auth
- [ ] **Private APIs restricted** - Not just CORS
- [ ] **Webhook endpoints careful** - May need open CORS

---

## 6. Response Security Audit

### 6.1 Data Exposure
- [ ] **Sensitive fields stripped** - No passwords, tokens
- [ ] **PII minimized** - Only needed fields
- [ ] **Internal IDs hidden** - Or UUIDs used
- [ ] **Error details hidden** - No stack traces
- [ ] **Consistent response shape** - Doesn't reveal existence

```bash
# Find response construction
grep -rn "res\.json\|res\.send\|return\s*{" --include="*.ts" --include="*.js" | head -50

# Find what fields are returned
grep -rn "select:\|include:\|exclude:\|projection:" --include="*.ts" --include="*.js" | head -30

# Find potential sensitive field exposure
grep -rn "password\|token\|secret\|apiKey" --include="*.ts" --include="*.js" | grep -i "return\|res\.\|response"
```

### 6.2 Response Headers
- [ ] **Content-Type correct** - application/json for JSON
- [ ] **X-Content-Type-Options** - nosniff
- [ ] **Cache-Control** - Appropriate for content
- [ ] **No server disclosure** - X-Powered-By removed

### 6.3 Error Responses
- [ ] **Consistent error format** - Standard shape
- [ ] **No stack traces** - In production
- [ ] **No internal paths** - File paths hidden
- [ ] **No query details** - SQL/query not exposed
- [ ] **Generic for auth failures** - Don't reveal user existence

```bash
# Find error responses
grep -rn "catch\|error\|err\)" --include="*.ts" --include="*.js" | grep -i "res\.\|json\|send" | head -30

# Find what's in errors
grep -rn "error:\|message:\|stack:" --include="*.ts" --include="*.js" | grep -i "catch\|error" | head -20
```

---

## 7. GraphQL-Specific Audit

### 7.1 Query Security
- [ ] **Query depth limited** - Prevent deep nesting
- [ ] **Query complexity limited** - Cost analysis
- [ ] **Introspection disabled in prod** - Or restricted
- [ ] **Batching limited** - Max operations per request
- [ ] **Aliases limited** - Prevent alias-based DOS

```bash
# Find GraphQL configuration
grep -rn "graphql\|GraphQL\|apollo\|type-graphql\|@nestjs/graphql" --include="*.ts" --include="*.js" --include="package.json"

# Find depth/complexity limiting
grep -rn "depth.*limit\|complexity\|maxDepth\|depthLimit\|fieldExtensions" --include="*.ts" --include="*.js"

# Find introspection config
grep -rn "introspection" --include="*.ts" --include="*.js"
```

### 7.2 Mutation Security
- [ ] **All mutations authorized** - Resolver-level auth
- [ ] **Input validation on mutations** - Schema validation
- [ ] **Rate limiting on mutations** - Cost-aware

### 7.3 Field-Level Security
- [ ] **Sensitive fields authorized** - Per-field auth
- [ ] **Computed fields safe** - No injection in resolvers
- [ ] **Nullable handled** - Null vs omission

### 7.4 Subscription Security
- [ ] **Subscriptions authorized** - On connect and message
- [ ] **Connection limits** - Max concurrent
- [ ] **Payload filtered** - Only authorized data

---

## 8. File Upload Audit

### 8.1 Upload Validation
- [ ] **File type whitelist** - Only allowed types
- [ ] **MIME type validated** - Check actual content
- [ ] **Extension validated** - Match MIME
- [ ] **Size limited** - Max file size
- [ ] **Filename sanitized** - Special chars removed

```bash
# Find file upload handling
grep -rn "multer\|formidable\|busboy\|multipart\|upload" --include="*.ts" --include="*.js"

# Find file validation
grep -rn "mimetype\|fileFilter\|allowedTypes\|contentType" --include="*.ts" --include="*.js"

# Find file size limits
grep -rn "maxFileSize\|limits:\|fileSize" --include="*.ts" --include="*.js"
```

### 8.2 Upload Storage
- [ ] **Stored outside webroot** - Can't access directly
- [ ] **Random filename** - Not user-controlled
- [ ] **Extension from server** - Not user-provided
- [ ] **No execution** - Not in executable location

### 8.3 Upload Serving
- [ ] **Content-Disposition** - Forces download if appropriate
- [ ] **Content-Type from validation** - Not from user
- [ ] **No path traversal** - Can't access other files
- [ ] **Signed URLs if private** - Expiring access

### 8.4 Image Uploads
- [ ] **Image reprocessing** - Strip metadata, resize
- [ ] **SVG sanitized** - Or blocked (can contain scripts)
- [ ] **No image tragick** - ImageMagick vulnerabilities

---

## 9. Pagination & Bulk Operations

### 9.1 Pagination Security
- [ ] **Max page size enforced** - Can't request all
- [ ] **Default page size reasonable** - Not too large
- [ ] **Page number validated** - Positive integer
- [ ] **Cursor validated** - If cursor-based

```bash
# Find pagination
grep -rn "limit\|offset\|page\|cursor\|skip\|take" --include="*.ts" --include="*.js" | grep -i "query\|params\|req\." | head -30

# Find pagination limits
grep -rn "maxLimit\|MAX_PAGE\|MAX_LIMIT" --include="*.ts" --include="*.js"
```

### 9.2 Bulk Operations
- [ ] **Bulk read limited** - Max IDs per request
- [ ] **Bulk create limited** - Max items per request
- [ ] **Bulk update authorized** - Each item checked
- [ ] **Bulk delete double-checked** - Extra confirmation

### 9.3 Export Operations
- [ ] **Export rate limited** - Expensive operation
- [ ] **Export size limited** - Max records
- [ ] **Export authorized** - Only own data
- [ ] **Export audited** - Logged for compliance

---

## 10. Webhook Security

### 10.1 Incoming Webhooks
- [ ] **Signature verified** - HMAC or equivalent
- [ ] **Replay attacks prevented** - Timestamp + nonce
- [ ] **IP whitelist if possible** - Known sender IPs
- [ ] **Idempotency handled** - Duplicate delivery safe

```bash
# Find webhook handling
grep -rn "webhook\|Webhook" --include="*.ts" --include="*.js"

# Find signature verification
grep -rn "signature\|hmac\|verify.*signature\|validateSignature" --include="*.ts" --include="*.js"
```

### 10.2 Outgoing Webhooks
- [ ] **URL validated** - No internal IPs (SSRF)
- [ ] **HTTPS enforced** - Or optional with warning
- [ ] **Timeout set** - Don't hang forever
- [ ] **Retry logic bounded** - Max retries
- [ ] **Payload sanitized** - No sensitive data leaked

---

## 11. API Versioning Audit

### 11.1 Version Management
- [ ] **Versioning strategy clear** - URL, header, or parameter
- [ ] **Old versions secured** - Still patched
- [ ] **Deprecation warnings** - Headers or docs
- [ ] **Sunset dates communicated** - When will be removed

```bash
# Find API versioning
grep -rn "/v1/\|/v2/\|/api/v\|version:" --include="*.ts" --include="*.js"

# Find version handling
grep -rn "api-version\|Accept-Version\|X-API-Version" --include="*.ts" --include="*.js"
```

### 11.2 Version Security
- [ ] **No security bypass via version** - Old version same checks
- [ ] **No data exposure via version** - Same authorization
- [ ] **Consistent security across versions** - Patched uniformly

---

## 12. API Documentation Security

### 12.1 Documentation Exposure
- [ ] **Swagger/OpenAPI secured** - Auth required in prod
- [ ] **No sensitive examples** - No real tokens in docs
- [ ] **No internal endpoints** - Only public APIs documented
- [ ] **Postman collections sanitized** - No secrets

```bash
# Find API documentation
grep -rn "swagger\|openapi\|Swagger\|OpenAPI" --include="*.ts" --include="*.js" --include="package.json"

# Find documentation routes
grep -rn "/docs\|/api-docs\|/swagger\|/openapi" --include="*.ts" --include="*.js"
```

### 12.2 Debug Endpoints
- [ ] **Debug endpoints removed** - In production
- [ ] **Health checks safe** - Don't expose sensitive info
- [ ] **Metrics endpoints protected** - Auth required
- [ ] **Admin endpoints not documented** - If applicable

---

## API Scanning Commands Summary

```bash
# === ENDPOINT DISCOVERY ===
# Find all routes
grep -rn "app\.\|router\.\|@Get\|@Post\|@Put\|@Delete" --include="*.ts" --include="*.js" | grep -E "\.(get|post|put|patch|delete)\s*\("

# Find GraphQL operations
grep -rn "@Query\|@Mutation\|@Subscription\|type Query\|type Mutation" --include="*.ts" --include="*.graphql"

# === AUTHENTICATION ===
# Find unprotected routes
grep -rn "\.get\s*(\|\.post\s*(" --include="*.ts" --include="*.js" | grep -v "auth\|Auth\|protect\|guard\|middleware"

# === AUTHORIZATION ===
# Find ID-based access
grep -rn "params\.id\|params\.\w*Id" --include="*.ts" --include="*.js"

# === VALIDATION ===
# Find raw input usage
grep -rn "req\.body\.\|req\.query\.\|req\.params\." --include="*.ts" --include="*.js"

# === RESPONSE ===
# Find what's returned
grep -rn "res\.json\|res\.send" --include="*.ts" --include="*.js" | head -30

# === RATE LIMITING ===
# Find rate limit config
grep -rn "rateLimit\|throttle" --include="*.ts" --include="*.js"

# === CORS ===
# Find CORS config
grep -rn "cors\|CORS\|Access-Control" --include="*.ts" --include="*.js"
```

---

## OWASP API Security Top 10 (2023) Mapping

| Issue | OWASP API 2023 | Description |
|-------|----------------|-------------|
| Broken Object Level Authorization | API1:2023 | IDOR, can access others' data |
| Broken Authentication | API2:2023 | Auth bypass, weak auth |
| Broken Object Property Level Auth | API3:2023 | Mass assignment, excessive data exposure |
| Unrestricted Resource Consumption | API4:2023 | No rate limiting, DoS |
| Broken Function Level Authorization | API5:2023 | Privilege escalation |
| Server Side Request Forgery | API6:2023 | SSRF via URL params |
| Security Misconfiguration | API7:2023 | Default configs, verbose errors |
| Lack of Protection from Automated Threats | API8:2023 | Bots, credential stuffing |
| Improper Inventory Management | API9:2023 | Old APIs, shadow APIs |
| Unsafe Consumption of APIs | API10:2023 | Trusting third-party APIs |
