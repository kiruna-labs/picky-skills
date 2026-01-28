# Backend Performance Checklist

## Philosophy

**The server should never be the bottleneck.** Every slow query is a user waiting. Every missing index is a full table scan. Every synchronous operation that could be async is wasted time. Audit backend performance like you're paying for every millisecond of compute - because you probably are.

---

## 1. API Response Time Audit

### 1.1 Endpoint Response Times

For EVERY API endpoint, measure:

| Endpoint | Method | p50 | p95 | p99 | Target | Status |
|----------|--------|-----|-----|-----|--------|--------|
| /api/users | GET | 45ms | 120ms | 250ms | < 200ms | OK |
| /api/products | GET | 180ms | 450ms | 890ms | < 200ms | SLOW |
| /api/orders | POST | 320ms | 780ms | 1.2s | < 500ms | SLOW |

Target response times:
- Simple reads: < 100ms
- Complex reads: < 200ms
- Writes: < 500ms
- Batch operations: < 2s

### 1.2 Response Time Breakdown

For slow endpoints, break down time:

| Phase | Time | % |
|-------|------|---|
| Network/TLS | 20ms | 5% |
| Server processing | 50ms | 13% |
| Database queries | 300ms | 75% |
| Serialization | 30ms | 7% |

- [ ] **Database time** identified?
- [ ] **External service time** identified?
- [ ] **Processing time** identified?
- [ ] **Serialization time** identified?

---

## 2. Database Performance

### 2.1 N+1 Query Detection

**This is the #1 backend performance killer.**

Patterns to find:
```javascript
// BAD: N+1 query
const users = await User.findAll();
for (const user of users) {
  user.posts = await Post.findAll({ where: { userId: user.id } });
}

// GOOD: Eager loading
const users = await User.findAll({
  include: [Post]
});
```

```python
# BAD: N+1 query
users = User.objects.all()
for user in users:
    posts = user.posts.all()  # Query per user!

# GOOD: Prefetch
users = User.objects.prefetch_related('posts').all()
```

Scan for patterns:
```bash
# Find loops that might contain queries
grep -r "for.*{" --include="*.ts" --include="*.js" -A 5 | grep -E "find|select|query|fetch"

# Find ORM calls inside functions (potential N+1)
grep -r "await.*find\|await.*query" --include="*.ts" --include="*.js"
```

### 2.2 Missing Index Detection

**Every query should use an index.**

Check for:
- [ ] **WHERE clause columns** indexed?
- [ ] **JOIN columns** indexed?
- [ ] **ORDER BY columns** indexed?
- [ ] **Composite indexes** for multi-column queries?

```sql
-- Find slow queries (PostgreSQL)
SELECT query, calls, mean_time, total_time
FROM pg_stat_statements
ORDER BY mean_time DESC
LIMIT 20;

-- Check for sequential scans
SELECT relname, seq_scan, idx_scan
FROM pg_stat_user_tables
WHERE seq_scan > idx_scan;

-- Find missing indexes
SELECT schemaname, relname, seq_scan, seq_tup_read,
       idx_scan, idx_tup_fetch
FROM pg_stat_user_tables
WHERE seq_scan > 0
ORDER BY seq_tup_read DESC;
```

### 2.3 Query Analysis

For each slow query, run EXPLAIN ANALYZE:

```sql
EXPLAIN ANALYZE SELECT * FROM orders
WHERE user_id = 123
AND status = 'pending'
ORDER BY created_at DESC
LIMIT 10;
```

Look for:
- [ ] **Seq Scan** on large tables (needs index)
- [ ] **Sort** operations (could use index)
- [ ] **Hash Join** vs **Nested Loop** (might need optimization)
- [ ] **Rows estimated vs actual** (statistics stale?)

### 2.4 Connection Pooling

- [ ] **Connection pool** configured?
- [ ] **Pool size** appropriate for load?
- [ ] **Connection timeout** configured?
- [ ] **Idle connection cleanup**?

Recommended pool sizes:
- connections = (cpu_cores * 2) + effective_spindle_count
- Typical: 10-20 for web servers

```javascript
// Good: Connection pooling
const pool = new Pool({
  max: 20,
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 2000
});
```

### 2.5 Query Optimization Patterns

- [ ] **SELECT only needed columns** (not SELECT *)
- [ ] **LIMIT on large result sets**
- [ ] **Pagination** for list endpoints
- [ ] **Batch operations** instead of row-by-row
- [ ] **Prepared statements** for repeated queries

```sql
-- BAD
SELECT * FROM users;

-- GOOD
SELECT id, name, email FROM users WHERE active = true LIMIT 100;
```

---

## 3. Caching Layer

### 3.1 Cache Inventory

| Data Type | Cache Location | TTL | Hit Rate | Status |
|-----------|---------------|-----|----------|--------|
| User sessions | Redis | 24h | 98% | OK |
| Product catalog | Memory | 5min | 85% | OK |
| API responses | None | - | 0% | MISSING |

### 3.2 What Should Be Cached

- [ ] **Frequently accessed data** cached?
- [ ] **Expensive computations** cached?
- [ ] **External API responses** cached?
- [ ] **Database query results** cached?
- [ ] **Session data** cached?

### 3.3 Cache Strategy

| Strategy | Use Case |
|----------|----------|
| Cache-aside | General purpose, app manages cache |
| Read-through | Automatic cache population |
| Write-through | Immediate cache update on write |
| Write-behind | Async cache update |

### 3.4 Cache Invalidation

- [ ] **TTL-based** expiration configured?
- [ ] **Event-based** invalidation for mutations?
- [ ] **Cache stampede** prevention?

```javascript
// Good: Cache with TTL and stampede protection
async function getProduct(id) {
  const cacheKey = `product:${id}`;
  let product = await cache.get(cacheKey);

  if (!product) {
    // Lock to prevent stampede
    const lock = await cache.lock(cacheKey + ':lock', 10);
    if (lock) {
      product = await db.products.findById(id);
      await cache.set(cacheKey, product, 300); // 5 min TTL
      await lock.release();
    } else {
      // Wait and retry
      await sleep(100);
      return getProduct(id);
    }
  }

  return product;
}
```

### 3.5 Cache Metrics

- [ ] **Hit rate** monitored? (Target: > 80%)
- [ ] **Miss rate** alerts?
- [ ] **Eviction rate** tracked?
- [ ] **Memory usage** monitored?

---

## 4. Async Processing

### 4.1 Synchronous vs Asynchronous

| Operation | Current | Should Be | Impact |
|-----------|---------|-----------|--------|
| Send email | Sync | Async | 500ms saved |
| Generate PDF | Sync | Async | 2s saved |
| External API call | Sync | Async/cached | 300ms saved |
| Image processing | Sync | Async | 1s saved |

### 4.2 Operations That Should Be Async

- [ ] **Email sending** → Queue
- [ ] **Push notifications** → Queue
- [ ] **File processing** → Background job
- [ ] **Report generation** → Background job
- [ ] **External webhooks** → Queue with retry
- [ ] **Analytics tracking** → Fire and forget / Queue

### 4.3 Job Queue Configuration

- [ ] **Queue system** in place (Redis, SQS, RabbitMQ)?
- [ ] **Worker scaling** configured?
- [ ] **Dead letter queue** for failures?
- [ ] **Retry policy** with exponential backoff?
- [ ] **Job timeout** configured?

```javascript
// Good: Async email with retry
await emailQueue.add('sendEmail', {
  to: user.email,
  template: 'welcome'
}, {
  attempts: 3,
  backoff: {
    type: 'exponential',
    delay: 1000
  }
});
```

### 4.4 Parallel Execution

- [ ] **Independent operations** run in parallel?
- [ ] **Promise.all / asyncio.gather** used appropriately?

```javascript
// BAD: Sequential
const user = await getUser(id);
const orders = await getOrders(id);
const reviews = await getReviews(id);

// GOOD: Parallel
const [user, orders, reviews] = await Promise.all([
  getUser(id),
  getOrders(id),
  getReviews(id)
]);
```

---

## 5. API Design for Performance

### 5.1 Payload Size

- [ ] **Over-fetching** avoided?
- [ ] **Field selection** supported?
- [ ] **Compression** enabled for responses?
- [ ] **Pagination** on all list endpoints?

```javascript
// Good: Sparse fieldsets
// GET /api/users?fields=id,name,email

// Good: Pagination
// GET /api/products?page=1&limit=20

// Good: Compressed response
res.setHeader('Content-Encoding', 'gzip');
```

### 5.2 Batching

- [ ] **Batch endpoints** for multiple operations?
- [ ] **GraphQL batching** configured?
- [ ] **Bulk inserts/updates** available?

```javascript
// Good: Batch endpoint
// POST /api/batch
// { operations: [{ method: 'GET', path: '/users/1' }, ...] }
```

### 5.3 Request Deduplication

- [ ] **Duplicate requests** rejected/deduplicated?
- [ ] **Idempotency keys** for mutations?

```javascript
// Good: Idempotency
// POST /api/orders
// Idempotency-Key: abc-123
```

---

## 6. Server-Side Rendering Performance

### 6.1 SSR Metrics

| Metric | Current | Target |
|--------|---------|--------|
| SSR render time | Xms | < 200ms |
| TTFB | Xms | < 800ms |
| HTML size | XKB | < 100KB |

### 6.2 SSR Optimization

- [ ] **Component-level caching**?
- [ ] **Streaming SSR**?
- [ ] **Partial hydration / Islands**?
- [ ] **Static generation** where possible?

### 6.3 Data Fetching in SSR

- [ ] **Parallel data fetching**?
- [ ] **Cached data** used during SSR?
- [ ] **Timeout** for external data?
- [ ] **Fallback** for slow/failed data?

```javascript
// Good: Parallel data fetching with timeout
export async function getServerSideProps() {
  const [user, products] = await Promise.all([
    fetchWithTimeout(getUser(), 2000),
    fetchWithTimeout(getProducts(), 2000)
  ]);
  return { props: { user, products } };
}
```

---

## 7. External Service Calls

### 7.1 External Service Inventory

| Service | Purpose | Avg Latency | Timeout | Cached? |
|---------|---------|-------------|---------|---------|
| Stripe | Payments | 300ms | 10s | No |
| SendGrid | Email | 200ms | 5s | N/A |
| S3 | Storage | 100ms | 5s | Yes |

### 7.2 External Call Optimization

- [ ] **Timeout** configured for all external calls?
- [ ] **Retry** with exponential backoff?
- [ ] **Circuit breaker** for failing services?
- [ ] **Caching** where appropriate?
- [ ] **Async** where possible?

```javascript
// Good: External call with circuit breaker
const breaker = new CircuitBreaker(callExternalAPI, {
  timeout: 3000,
  errorThresholdPercentage: 50,
  resetTimeout: 30000
});

const result = await breaker.fire(params);
```

### 7.3 Connection Management

- [ ] **Keep-alive** for HTTP connections?
- [ ] **Connection pooling** for databases?
- [ ] **Connection reuse** maximized?

---

## 8. Memory Management

### 8.1 Memory Usage

- [ ] **Heap size** monitored?
- [ ] **Memory leaks** detected?
- [ ] **Garbage collection** frequency normal?

```bash
# Node.js: Enable GC logging
node --trace-gc app.js

# Node.js: Heap snapshot
node --inspect app.js
# Then use Chrome DevTools Memory tab
```

### 8.2 Memory Optimization

- [ ] **Streaming** for large files?
- [ ] **Pagination** to limit result set size?
- [ ] **Buffer pools** reused?
- [ ] **WeakMap/WeakSet** for caches?

```javascript
// BAD: Load entire file into memory
const content = fs.readFileSync('large-file.csv');

// GOOD: Stream processing
const stream = fs.createReadStream('large-file.csv');
stream.pipe(csvParser()).pipe(processor);
```

### 8.3 Memory Limits

- [ ] **Container memory limits** appropriate?
- [ ] **OOM killer** not triggering?
- [ ] **Graceful degradation** under memory pressure?

---

## 9. CPU Optimization

### 9.1 CPU-Intensive Operations

| Operation | CPU Time | Frequency | Optimization |
|-----------|----------|-----------|--------------|
| JSON parse large payload | 50ms | 100/s | Stream parsing |
| Regex on large text | 200ms | 10/s | Optimize regex |
| Image resize | 500ms | 5/s | Move to worker |

### 9.2 Offloading CPU Work

- [ ] **Worker threads** for CPU-intensive tasks?
- [ ] **Separate service** for heavy computation?
- [ ] **Caching** computed results?

```javascript
// Good: Offload to worker
const { Worker } = require('worker_threads');

async function processImage(buffer) {
  return new Promise((resolve, reject) => {
    const worker = new Worker('./image-worker.js', {
      workerData: buffer
    });
    worker.on('message', resolve);
    worker.on('error', reject);
  });
}
```

### 9.3 Algorithm Efficiency

- [ ] **O(n²) operations** on large datasets avoided?
- [ ] **Efficient data structures** used?
- [ ] **Early returns** to avoid unnecessary work?

---

## 10. Logging & Monitoring Performance

### 10.1 Logging Impact

- [ ] **Async logging** configured?
- [ ] **Log level** appropriate for production?
- [ ] **Structured logging** for efficiency?
- [ ] **Log sampling** for high-volume events?

```javascript
// Good: Async structured logging
logger.info({ event: 'request', method: 'GET', path: '/api/users', duration: 45 });

// Bad: Sync console.log with string concatenation
console.log('Request: GET /api/users took ' + duration + 'ms');
```

### 10.2 Metrics Collection

- [ ] **Low-overhead** metrics collection?
- [ ] **Sampling** for high-frequency metrics?
- [ ] **Aggregation** before export?

---

## 11. Framework-Specific Checks

### 11.1 Node.js/Express

- [ ] **Cluster mode** or PM2 for multi-core?
- [ ] **Compression middleware** enabled?
- [ ] **ETag** generation efficient?
- [ ] **Static file serving** via nginx/CDN?

### 11.2 Python/Django/FastAPI

- [ ] **Gunicorn/uvicorn workers** configured?
- [ ] **Async views** where applicable?
- [ ] **Database connection pooling**?
- [ ] **Django ORM select_related/prefetch_related**?

### 11.3 Ruby/Rails

- [ ] **Puma workers/threads** configured?
- [ ] **Eager loading** to avoid N+1?
- [ ] **Fragment caching** enabled?
- [ ] **Russian doll caching**?

### 11.4 Java/Spring

- [ ] **Thread pool** sizing appropriate?
- [ ] **HikariCP** connection pool configured?
- [ ] **JVM heap size** optimized?
- [ ] **GC algorithm** appropriate?

---

## 12. Profiling & Benchmarking

### 12.1 Profiling Tools

- [ ] **CPU profiling** completed?
- [ ] **Memory profiling** completed?
- [ ] **Database query profiling** completed?

### 12.2 Load Testing

- [ ] **Baseline performance** established?
- [ ] **Load test** completed (expected traffic)?
- [ ] **Stress test** completed (2-3x expected)?
- [ ] **Soak test** for memory leaks?

```bash
# Example: k6 load test
k6 run --vus 100 --duration 5m script.js
```

### 12.3 Bottleneck Identification

After profiling, identify:
- [ ] **Top 5 slow endpoints**
- [ ] **Top 5 slow queries**
- [ ] **Top 5 memory consumers**
- [ ] **Top 5 CPU consumers**

---

## Quick Wins Checklist

- [ ] Add database indexes for slow queries
- [ ] Enable query result caching
- [ ] Configure connection pooling
- [ ] Move email/notifications to async queue
- [ ] Parallelize independent database queries
- [ ] Add pagination to all list endpoints
- [ ] Enable response compression
- [ ] Configure appropriate timeouts
- [ ] Add circuit breakers for external services
- [ ] Use streaming for large file operations
