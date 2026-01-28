# Backend Security Audit Checklist

## Audit Philosophy

**The backend is your last line of defense.** Never trust the frontend. Never trust user input. Never trust external services. Every request could be an attack. Every piece of data could be malicious. Your job is to find EVERY injection point, authentication bypass, and data exposure vulnerability.

---

## 1. SQL Injection Audit

### 1.1 Direct SQL Vulnerabilities
- [ ] **String concatenation in queries** - Never concatenate user input
- [ ] **Template literals in queries** - Same as concatenation
- [ ] **Raw queries with user input** - Should use parameterized
- [ ] **ORM raw methods audited** - Sequelize.query, Prisma.$queryRaw, etc.

```bash
# Find SQL string concatenation
grep -rn "SELECT.*\+\|INSERT.*\+\|UPDATE.*\+\|DELETE.*\+\|WHERE.*\+" --include="*.ts" --include="*.js" --include="*.py"

# Find template literal SQL
grep -rn "\`SELECT\|\`INSERT\|\`UPDATE\|\`DELETE" --include="*.ts" --include="*.js"

# Find raw query methods
grep -rn "\.query\s*(\|\.raw\s*(\|\$queryRaw\|\$executeRaw\|raw_sql\|execute_sql" --include="*.ts" --include="*.js" --include="*.py"

# Find dynamic table/column names
grep -rn "FROM\s*\${\|FROM\s*\"\s*\+\|ORDER BY\s*\${" --include="*.ts" --include="*.js"
```

### 1.2 ORM Safety
- [ ] **Parameterized queries used** - Prepared statements
- [ ] **Input validation before ORM** - Don't rely on ORM alone
- [ ] **Dynamic column names validated** - Whitelist approach
- [ ] **Batch operations safe** - Bulk insert/update secure

```bash
# Find ORM usage patterns
grep -rn "prisma\.\|sequelize\.\|mongoose\.\|knex\.\|typeorm\.\|sqlalchemy\." --include="*.ts" --include="*.js" --include="*.py" | head -50

# Find where user input enters ORM
grep -rn "where:\s*{\|findOne\|findMany\|create\|update\|delete" --include="*.ts" --include="*.js" | head -50
```

### 1.3 SQL Injection Sinks
- [ ] **LIKE patterns escaped** - User input in LIKE clauses
- [ ] **ORDER BY validated** - Only allowed columns
- [ ] **LIMIT/OFFSET validated** - Positive integers only
- [ ] **IN clauses parameterized** - Array inputs safe

---

## 2. NoSQL Injection Audit

### 2.1 MongoDB Injection
- [ ] **No $where with user input** - Allows arbitrary JS
- [ ] **No $regex with user input** - ReDoS possible
- [ ] **Operator injection blocked** - $gt, $lt, etc. from user
- [ ] **JSON parsing validated** - Parsed JSON could contain operators

```bash
# Find MongoDB dangerous operators
grep -rn "\$where\|\$regex\|\$function\|\$accumulator" --include="*.ts" --include="*.js"

# Find MongoDB queries with user input
grep -rn "\.find\s*(\|\\.findOne\s*(\|\.aggregate\s*(" --include="*.ts" --include="*.js" | head -30

# Find potential operator injection
grep -rn "JSON\.parse.*body\|JSON\.parse.*query\|JSON\.parse.*params" --include="*.ts" --include="*.js"
```

### 2.2 Query Operator Safety
- [ ] **Input type validated** - Strings stay strings
- [ ] **Object keys sanitized** - $ prefix blocked from user input
- [ ] **Nested object depth limited** - Deep nesting attack
- [ ] **Array input validated** - Array methods can be exploited

### 2.3 Aggregation Pipeline
- [ ] **$lookup restricted** - Cross-collection access controlled
- [ ] **$out and $merge restricted** - Write operations audited
- [ ] **User input not in stages** - Stages from code, not user

---

## 3. Command Injection Audit

### 3.1 Shell Execution
- [ ] **exec/spawn with user input** - Direct shell access
- [ ] **Command building from input** - Template injection
- [ ] **Environment variable injection** - env vars from user
- [ ] **Working directory manipulation** - cwd from user input

```bash
# Find shell execution
grep -rn "exec\s*(\|execSync\|spawn\|spawnSync\|child_process\|shelljs\|execa" --include="*.ts" --include="*.js"
grep -rn "subprocess\|os\.system\|os\.popen\|Popen\|shell=True" --include="*.py"
grep -rn "system\s*(\|exec\s*(\|popen\|backtick\|\`" --include="*.rb" --include="*.php"

# Find command string building
grep -rn "\`.*\${\|exec\s*(\s*['\"\`].*\+" --include="*.ts" --include="*.js"
```

### 3.2 Common Injection Points
- [ ] **File operations with user paths** - Path traversal + injection
- [ ] **Image processing** - ImageMagick, ffmpeg commands
- [ ] **PDF generation** - wkhtmltopdf, puppeteer
- [ ] **Git operations** - git commands with user input
- [ ] **Archive operations** - zip, tar with user filenames

```bash
# Find file/path operations
grep -rn "readFile\|writeFile\|unlink\|rmdir\|mkdir\|createReadStream" --include="*.ts" --include="*.js"
grep -rn "open\s*(\|read\s*(\|write\s*(\|os\.remove\|shutil\." --include="*.py"

# Find image/media processing
grep -rn "sharp\|jimp\|imagemagick\|ffmpeg\|ffprobe" --include="*.ts" --include="*.js"
```

### 3.3 Argument Injection
- [ ] **Arguments array used** - Not string concatenation
- [ ] **Shell option disabled** - shell: false in spawn
- [ ] **Special characters escaped** - If shell necessary
- [ ] **Argument validation** - Whitelist allowed values

---

## 4. Path Traversal Audit

### 4.1 File Read Vulnerabilities
- [ ] **Path joining safe** - Using path.join, not string concat
- [ ] **Relative paths blocked** - No ../ from user input
- [ ] **Symlink following disabled** - Or validated
- [ ] **Allowed directories enforced** - Whitelist approach

```bash
# Find file operations with potential user input
grep -rn "readFile\|createReadStream\|fs\.open\|sendFile\|download\|attachment" --include="*.ts" --include="*.js"
grep -rn "open\s*(\|read\s*(\|Path\|pathlib" --include="*.py"

# Find path construction
grep -rn "path\.join\|path\.resolve\|__dirname\s*\+" --include="*.ts" --include="*.js"

# Find potential traversal vulnerabilities
grep -rn "req\.params\|req\.query\|req\.body" --include="*.ts" --include="*.js" | grep -i "path\|file\|name\|dir"
```

### 4.2 File Write Vulnerabilities
- [ ] **Upload paths validated** - Can't write to arbitrary locations
- [ ] **Filename sanitized** - No special characters
- [ ] **Extension validated** - Whitelist allowed extensions
- [ ] **No code execution paths** - Can't write to web root

### 4.3 Archive Extraction
- [ ] **Zip slip prevented** - Entries validated before extraction
- [ ] **Symlink bombs blocked** - Symlinks in archives
- [ ] **Archive size limits** - Zip bomb protection
- [ ] **File count limits** - Archive entry count limited

---

## 5. Server-Side Request Forgery (SSRF)

### 5.1 URL Fetching
- [ ] **URL scheme whitelist** - Only http/https allowed
- [ ] **Private IP blocked** - No 10.x, 192.168.x, 127.x, etc.
- [ ] **DNS rebinding considered** - Resolve and verify IP
- [ ] **Redirect following controlled** - Limited or disabled

```bash
# Find URL fetching
grep -rn "fetch\s*(\|axios\.\|got\s*(\|request\s*(\|http\.get\|https\.get\|urllib\|requests\." --include="*.ts" --include="*.js" --include="*.py"

# Find URL construction from user input
grep -rn "url\s*=\|href\s*=\|endpoint\s*=" --include="*.ts" --include="*.js" | grep -v "const\|type\|interface" | head -30
```

### 5.2 SSRF Sinks
- [ ] **Image URLs validated** - Profile picture URLs, etc.
- [ ] **Webhook URLs validated** - User-provided webhooks
- [ ] **Import/export URLs** - Data import from URL
- [ ] **Proxy endpoints** - Any proxying functionality
- [ ] **PDF/screenshot services** - URL to render

### 5.3 Internal Service Access
- [ ] **Cloud metadata blocked** - 169.254.169.254
- [ ] **Internal services blocked** - Kubernetes, Docker, etc.
- [ ] **Admin interfaces blocked** - Internal admin panels
- [ ] **Database ports blocked** - Direct DB access attempt

```bash
# Find cloud metadata access
grep -rn "169\.254\.169\.254\|metadata\.\|instance\-data" --include="*.ts" --include="*.js" --include="*.py"
```

---

## 6. XML External Entity (XXE)

### 6.1 XML Parsing
- [ ] **External entities disabled** - In XML parser config
- [ ] **DTD processing disabled** - No doctype processing
- [ ] **XInclude disabled** - No XInclude support
- [ ] **XSLT from trusted source** - If XSLT used

```bash
# Find XML parsing
grep -rn "xml2js\|libxmljs\|xml-parser\|sax\|DOMParser\|parseXML\|etree\|lxml" --include="*.ts" --include="*.js" --include="*.py"

# Find potentially dangerous XML config
grep -rn "resolveExternals\|dtdload\|dtdattr\|network\|EXTERNAL" --include="*.ts" --include="*.js" --include="*.py"
```

### 6.2 SVG/Office Documents
- [ ] **SVG sanitized** - SVG can contain scripts, XXE
- [ ] **Office docs scanned** - DOCX/XLSX are XML archives
- [ ] **PDF processed safely** - PDF can have embedded content

---

## 7. Deserialization Vulnerabilities

### 7.1 Dangerous Deserialization
- [ ] **No eval of user data** - Never eval untrusted JSON
- [ ] **No pickle of user data** - Python pickle is unsafe
- [ ] **No YAML load without safe** - Use safe_load
- [ ] **No PHP unserialize** - Of user data

```bash
# Find dangerous deserialization
grep -rn "eval\s*(\|JSON\.parse.*body\|JSON\.parse.*request" --include="*.ts" --include="*.js"
grep -rn "pickle\.load\|yaml\.load\|yaml\.unsafe_load\|marshal\.load" --include="*.py"
grep -rn "unserialize\|ObjectInputStream" --include="*.php" --include="*.java"
```

### 7.2 Prototype Pollution (JavaScript)
- [ ] **Object merge safe** - Using Object.assign carefully
- [ ] **Deep merge libraries audited** - lodash.merge, etc.
- [ ] **__proto__ blocked** - In user input
- [ ] **constructor blocked** - In user input

```bash
# Find deep merge operations
grep -rn "merge\|assign\|extend\|deepMerge\|defaultsDeep" --include="*.ts" --include="*.js"

# Find object spread with user data
grep -rn "\.\.\.req\.\|\.\.\.body\|\.\.\.params\|\.\.\.query" --include="*.ts" --include="*.js"
```

---

## 8. Mass Assignment Vulnerabilities

### 8.1 Model Assignment
- [ ] **Whitelist fields for create** - Only allowed fields
- [ ] **Whitelist fields for update** - Only allowed fields
- [ ] **Admin fields protected** - isAdmin, role, etc.
- [ ] **Timestamps protected** - createdAt, updatedAt

```bash
# Find direct object assignment
grep -rn "\.create\s*(\s*req\.\|\.update\s*(\s*req\.\|\.insert\s*(\s*req\." --include="*.ts" --include="*.js"

# Find spread assignment
grep -rn "data:\s*\.\.\.\|\.create\(\s*{\s*\.\.\.body" --include="*.ts" --include="*.js"

# Find dangerous field names
grep -rn "isAdmin\|role\|permissions\|verified\|approved\|credits\|balance" --include="*.ts" --include="*.js" --include="*.prisma" --include="*.py"
```

### 8.2 GraphQL Mass Assignment
- [ ] **Input types restricted** - Only defined fields
- [ ] **Nested inputs controlled** - Can't create related unauthorized
- [ ] **Mutations validate input** - Server-side validation

---

## 9. Business Logic Vulnerabilities

### 9.1 Race Conditions
- [ ] **Double-submit prevention** - Idempotency keys
- [ ] **Balance operations atomic** - Transaction/locks
- [ ] **Inventory operations atomic** - Prevent overselling
- [ ] **Rate limiting per operation** - Not just per endpoint

```bash
# Find financial/inventory operations
grep -rn "balance\|credits\|inventory\|quantity\|amount\|price\|transfer\|payment" --include="*.ts" --include="*.js" --include="*.py"

# Find potential race conditions (non-atomic reads followed by writes)
grep -rn "findOne.*update\|get.*then.*update\|read.*write" --include="*.ts" --include="*.js" | head -20
```

### 9.2 Integer Overflow
- [ ] **Numeric bounds checked** - Before arithmetic
- [ ] **Negative values handled** - Quantity, price, etc.
- [ ] **Currency calculations safe** - Decimal handling
- [ ] **BigInt for large numbers** - If needed

### 9.3 Logic Flaws
- [ ] **Price manipulation blocked** - Can't send negative/zero
- [ ] **Coupon stacking controlled** - Multi-coupon logic
- [ ] **Referral abuse prevented** - Self-referral, circular
- [ ] **Free trial abuse prevented** - Multiple signups

---

## 10. Server Configuration

### 10.1 Error Handling
- [ ] **Generic error messages** - No stack traces to users
- [ ] **Error logging internal** - Log details server-side
- [ ] **Sensitive data not in errors** - No passwords in logs
- [ ] **Default error handlers** - Not framework defaults

```bash
# Find error handling
grep -rn "catch\s*(\|\.catch\|errorHandler\|onError" --include="*.ts" --include="*.js"

# Find error responses
grep -rn "error\.\|err\.\|exception" --include="*.ts" --include="*.js" | grep -i "res\.\|response\.\|send\|json" | head -30
```

### 10.2 Headers
- [ ] **X-Powered-By removed** - Don't reveal framework
- [ ] **Server header removed** - Don't reveal server software
- [ ] **X-Content-Type-Options: nosniff** - Prevent MIME sniffing
- [ ] **X-Frame-Options** - Clickjacking protection
- [ ] **Strict-Transport-Security** - Force HTTPS

```bash
# Find security headers configuration
grep -rn "helmet\|X-Frame\|X-Content-Type\|Strict-Transport\|X-XSS\|X-Powered-By" --include="*.ts" --include="*.js" --include="*.py"
```

### 10.3 CORS Configuration
- [ ] **Origin whitelist** - Not * for authenticated
- [ ] **Credentials handling correct** - credentials: true requires specific origin
- [ ] **Methods restricted** - Only needed methods
- [ ] **Headers restricted** - Only needed headers

```bash
# Find CORS configuration
grep -rn "cors\|Access-Control-Allow\|CORS" --include="*.ts" --include="*.js" --include="*.py"

# Find * origin (dangerous with credentials)
grep -rn "origin:\s*['\"]?\*\|Allow-Origin.*\*" --include="*.ts" --include="*.js"
```

---

## 11. Logging Security

### 11.1 Sensitive Data in Logs
- [ ] **No passwords logged** - Ever
- [ ] **No tokens logged** - Session, JWT, API keys
- [ ] **No PII logged** - Or anonymized
- [ ] **No credit cards logged** - PCI compliance
- [ ] **No request bodies logged** - Unless sanitized

```bash
# Find logging statements
grep -rn "console\.log\|logger\.\|log\.\|logging\.\|winston\.\|pino\.\|bunyan\." --include="*.ts" --include="*.js" --include="*.py" | head -50

# Find potential sensitive logging
grep -rn "log.*password\|log.*token\|log.*secret\|log.*key\|log.*auth\|log.*session" --include="*.ts" --include="*.js" --include="*.py"

# Find request logging (check what's logged)
grep -rn "log.*req\.\|log.*request\.\|log.*body" --include="*.ts" --include="*.js"
```

### 11.2 Log Injection
- [ ] **Newlines stripped** - From logged user input
- [ ] **Special chars escaped** - In structured logs
- [ ] **Length limited** - No log flooding

---

## 12. Denial of Service Prevention

### 12.1 Resource Limits
- [ ] **Request body size limited** - Max payload size
- [ ] **File upload size limited** - Max file size
- [ ] **Query complexity limited** - GraphQL depth, etc.
- [ ] **Pagination enforced** - Max page size

```bash
# Find body parser config
grep -rn "bodyParser\|body-parser\|json\(\s*{" --include="*.ts" --include="*.js" | grep -i "limit"

# Find file upload config
grep -rn "multer\|formidable\|busboy\|upload" --include="*.ts" --include="*.js" | grep -i "limit\|max\|size"
```

### 12.2 ReDoS Prevention
- [ ] **Regex audited** - No catastrophic backtracking
- [ ] **Regex timeout** - If using user input in regex
- [ ] **Safe regex library** - re2 for untrusted patterns

```bash
# Find regex usage with user input
grep -rn "new RegExp\|RegExp\s*(\|\.match\|\.test\|\.search\|\.replace" --include="*.ts" --include="*.js"

# Find potentially dangerous regex patterns
grep -rn "(\.\*\)+\|(\.\+\)+\|(a+)+\|(a\|a)+\|(a\|aa)+" --include="*.ts" --include="*.js"
```

### 12.3 Algorithm Complexity
- [ ] **Pagination on lists** - No unbounded queries
- [ ] **Search limitations** - Limit wildcard searches
- [ ] **Sorting validated** - Only indexed columns
- [ ] **Aggregation limits** - Limit complex aggregations

---

## OWASP/CWE References

| Vulnerability | OWASP 2021 | CWE |
|--------------|------------|-----|
| SQL Injection | A03:2021-Injection | CWE-89 |
| NoSQL Injection | A03:2021-Injection | CWE-943 |
| Command Injection | A03:2021-Injection | CWE-78 |
| Path Traversal | A01:2021-Broken Access | CWE-22 |
| SSRF | A10:2021-SSRF | CWE-918 |
| XXE | A05:2021-Misconfiguration | CWE-611 |
| Deserialization | A08:2021-Integrity | CWE-502 |
| Mass Assignment | A01:2021-Broken Access | CWE-915 |
| Race Conditions | A04:2021-Insecure Design | CWE-362 |
| Log Injection | A09:2021-Logging | CWE-117 |
| ReDoS | A05:2021-Misconfiguration | CWE-1333 |
