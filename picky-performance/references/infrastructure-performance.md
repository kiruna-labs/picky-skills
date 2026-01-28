# Infrastructure Performance Checklist

## Philosophy

**Infrastructure is the foundation of performance.** You can optimize code all day, but if the server is on the wrong continent, or the database is undersized, or there's no CDN, you're fighting physics. Audit infrastructure like you're designing for 10x your current traffic - because someday you might have it.

---

## 1. Server Location & Latency

### 1.1 Geographic Analysis

| User Location | Server Location | Latency | Target | Status |
|---------------|----------------|---------|--------|--------|
| US East | us-east-1 | 20ms | < 50ms | OK |
| US West | us-east-1 | 70ms | < 50ms | SLOW |
| Europe | us-east-1 | 120ms | < 100ms | SLOW |
| Asia | us-east-1 | 200ms | < 150ms | SLOW |

### 1.2 Multi-Region Consideration

- [ ] **User distribution** analyzed?
- [ ] **Multi-region deployment** needed?
- [ ] **Edge functions** for latency-sensitive operations?
- [ ] **Database replication** across regions?

### 1.3 Latency Measurement

```bash
# Measure latency from different locations
# Use tools like: ping, traceroute, mtr, or cloud-based tests

# Cloudflare speed test
curl -w "TTFB: %{time_starttransfer}s\nTotal: %{time_total}s\n" -o /dev/null -s https://example.com

# Measure from multiple locations
# Use services like: Pingdom, KeyCDN tools, or synthetic monitoring
```

---

## 2. CDN Configuration

### 2.1 CDN Coverage

- [ ] **CDN enabled** for static assets?
- [ ] **CDN enabled** for dynamic content (if applicable)?
- [ ] **Edge locations** cover user base?

### 2.2 CDN Settings Audit

| Setting | Current | Recommended |
|---------|---------|-------------|
| Static TTL | ? | 1 year for hashed |
| Dynamic TTL | ? | 0-60s based on content |
| Query string handling | ? | Ignore for static |
| Compression | ? | Brotli + Gzip |
| HTTP/2 | ? | Enabled |
| HTTP/3 | ? | Enabled if available |

### 2.3 Origin Shield

- [ ] **Origin shield** enabled?
  - Reduces load on origin server
  - Single point of cache for all edge POPs
  - Recommended for high-traffic sites

### 2.4 CDN Cache Hit Ratio

Target: > 90% for static assets, > 70% for dynamic

```bash
# Check cache status headers
curl -sI https://example.com/app.js | grep -i "x-cache\|cf-cache"
# HIT = good, MISS = investigate
```

### 2.5 CDN Features

- [ ] **Image optimization** at edge?
- [ ] **Minification** at edge?
- [ ] **Early hints** (103)?
- [ ] **Argo/smart routing**?
- [ ] **WAF** performance impact assessed?

---

## 3. Load Balancing

### 3.1 Load Balancer Configuration

| Setting | Current | Recommended |
|---------|---------|-------------|
| Algorithm | ? | Least connections or Round robin |
| Health checks | ? | Every 10-30s |
| Connection draining | ? | Enabled, 30s timeout |
| Session affinity | ? | Disabled unless required |
| Keep-alive | ? | Enabled |

### 3.2 Health Checks

- [ ] **Health endpoint** exists (`/health` or `/healthz`)?
- [ ] **Health check** verifies actual functionality?
- [ ] **Graceful degradation** when dependencies fail?

```javascript
// Good: Health check that verifies dependencies
app.get('/health', async (req, res) => {
  try {
    await db.query('SELECT 1');
    await redis.ping();
    res.json({ status: 'healthy', timestamp: Date.now() });
  } catch (error) {
    res.status(503).json({ status: 'unhealthy', error: error.message });
  }
});
```

### 3.3 Load Distribution

- [ ] **Even distribution** across instances?
- [ ] **No hot spots**?
- [ ] **Sticky sessions** only if absolutely necessary?

---

## 4. Auto-Scaling

### 4.1 Scaling Configuration

| Metric | Scale Up | Scale Down | Current | Status |
|--------|----------|------------|---------|--------|
| CPU | > 70% | < 30% | ? | ? |
| Memory | > 80% | < 40% | ? | ? |
| Requests/s | > 1000 | < 500 | ? | ? |
| Queue depth | > 100 | < 10 | ? | ? |

### 4.2 Scaling Speed

- [ ] **Scale-up time** acceptable? (Target: < 2 min)
- [ ] **Scale-down** not too aggressive?
- [ ] **Minimum instances** for baseline traffic?
- [ ] **Maximum instances** capped for cost control?

### 4.3 Predictive Scaling

- [ ] **Scheduled scaling** for known traffic patterns?
- [ ] **Predictive scaling** based on historical data?

---

## 5. Database Infrastructure

### 5.1 Database Sizing

| Metric | Current | Recommended | Status |
|--------|---------|-------------|--------|
| CPU cores | ? | Based on query load | ? |
| Memory | ? | > working set size | ? |
| IOPS | ? | Based on write load | ? |
| Storage | ? | 2x current + growth | ? |
| Connections | ? | Based on app instances | ? |

### 5.2 Read Replicas

- [ ] **Read replicas** for read-heavy workloads?
- [ ] **Replica lag** monitored and acceptable?
- [ ] **Read routing** to replicas implemented?

### 5.3 Connection Limits

```
Max connections formula:
connections = ((core_count * 2) + effective_spindle_count) per server

For cloud:
- PostgreSQL: Default 100, adjust based on instance size
- MySQL: Default 151, adjust based on instance size

Application pool size:
- Target: Total app instances * pool size < DB max connections
```

### 5.4 Database Caching

- [ ] **Query cache** enabled (if applicable)?
- [ ] **Buffer pool** sized correctly?
- [ ] **Application-level caching** (Redis/Memcached)?

PostgreSQL:
```sql
-- Check buffer cache hit ratio
SELECT
  sum(heap_blks_hit) / (sum(heap_blks_hit) + sum(heap_blks_read)) as ratio
FROM pg_statio_user_tables;
-- Target: > 99%
```

### 5.5 Database Backups & Maintenance

- [ ] **Automated backups** enabled?
- [ ] **Point-in-time recovery** available?
- [ ] **Vacuum/maintenance** scheduled (PostgreSQL)?
- [ ] **Index maintenance** scheduled?

---

## 6. Caching Infrastructure

### 6.1 Redis/Memcached Configuration

| Setting | Current | Recommended |
|---------|---------|-------------|
| Max memory | ? | Based on dataset |
| Eviction policy | ? | allkeys-lru for cache |
| Persistence | ? | Disabled for pure cache |
| Cluster mode | ? | If > 25GB or HA needed |

### 6.2 Cache Sizing

- [ ] **Memory size** sufficient for working set?
- [ ] **Eviction rate** acceptable?
- [ ] **Hit rate** > 80%?

```bash
# Redis: Check memory usage
redis-cli INFO memory | grep used_memory_human

# Redis: Check hit rate
redis-cli INFO stats | grep keyspace
# Calculate: hits / (hits + misses)
```

### 6.3 Cache High Availability

- [ ] **Replication** configured?
- [ ] **Failover** automatic?
- [ ] **Sentinel/Cluster** for production?

---

## 7. Serverless Performance

### 7.1 Cold Start Analysis

| Function | Runtime | Cold Start | Warm | Frequency |
|----------|---------|------------|------|-----------|
| api-handler | Node.js | 800ms | 50ms | 1000/min |
| image-resize | Python | 1.5s | 200ms | 10/min |

### 7.2 Cold Start Optimization

- [ ] **Function size** minimized?
- [ ] **Dependencies** minimized?
- [ ] **Provisioned concurrency** for critical functions?
- [ ] **Warm-up strategy** implemented?

```javascript
// Good: Minimal function size
// Move large dependencies to layers
// Use dynamic imports for rarely-used code
```

### 7.3 Connection Management

- [ ] **Connection reuse** outside handler?
- [ ] **Connection pooling** compatible with serverless?
- [ ] **Database proxy** (RDS Proxy, PlanetScale) for connection management?

```javascript
// Good: Connection outside handler for reuse
const db = new Database(connectionString);

exports.handler = async (event) => {
  // Reuses existing connection
  const result = await db.query('SELECT ...');
  return result;
};
```

### 7.4 Timeout Configuration

- [ ] **Function timeout** appropriate?
- [ ] **API Gateway timeout** aligned?
- [ ] **Database timeout** < function timeout?

---

## 8. Container/Kubernetes Performance

### 8.1 Resource Limits

| Resource | Request | Limit | Current Usage |
|----------|---------|-------|---------------|
| CPU | 100m | 500m | ? |
| Memory | 256Mi | 512Mi | ? |

- [ ] **Requests** set based on normal usage?
- [ ] **Limits** set with headroom for spikes?
- [ ] **No OOM kills** occurring?
- [ ] **No CPU throttling** occurring?

### 8.2 Pod Configuration

- [ ] **Liveness probe** configured correctly?
- [ ] **Readiness probe** configured correctly?
- [ ] **Startup probe** for slow-starting apps?

```yaml
# Good: Probes configured
livenessProbe:
  httpGet:
    path: /health
    port: 8080
  initialDelaySeconds: 10
  periodSeconds: 15
readinessProbe:
  httpGet:
    path: /ready
    port: 8080
  initialDelaySeconds: 5
  periodSeconds: 5
```

### 8.3 Horizontal Pod Autoscaler

- [ ] **HPA configured** for production workloads?
- [ ] **Metrics** appropriate (CPU, memory, custom)?
- [ ] **Min/max replicas** set correctly?

### 8.4 Resource Efficiency

- [ ] **Right-sized** containers (not over-provisioned)?
- [ ] **Multi-stage builds** for smaller images?
- [ ] **Image pull policy** optimized?

---

## 9. Network Infrastructure

### 9.1 DNS Performance

- [ ] **Low TTL** for failover capability?
- [ ] **DNS provider** fast and reliable?
- [ ] **GeoDNS** for multi-region?

```bash
# Check DNS resolution time
dig example.com | grep "Query time"
# Target: < 50ms
```

### 9.2 TLS Configuration

- [ ] **TLS 1.3** enabled?
- [ ] **OCSP stapling** enabled?
- [ ] **Session resumption** enabled?
- [ ] **Modern cipher suites**?

```bash
# Check TLS configuration
curl -svo /dev/null https://example.com 2>&1 | grep "SSL connection using"
# Should show TLS 1.3
```

### 9.3 Internal Network

- [ ] **Private networking** between services?
- [ ] **Service mesh** overhead acceptable?
- [ ] **DNS-based service discovery** vs IP?

---

## 10. Storage Performance

### 10.1 Block Storage (EBS, etc.)

| Volume | Type | IOPS | Throughput | Usage |
|--------|------|------|------------|-------|
| Database | io2 | 10000 | 500MB/s | ? |
| App logs | gp3 | 3000 | 125MB/s | ? |

- [ ] **IOPS** sufficient for workload?
- [ ] **Throughput** sufficient?
- [ ] **Storage type** appropriate (SSD vs HDD)?

### 10.2 Object Storage (S3, etc.)

- [ ] **Transfer acceleration** for large files?
- [ ] **Multi-part upload** for large files?
- [ ] **Intelligent tiering** for cost optimization?
- [ ] **Same-region** as compute?

### 10.3 File System Performance

- [ ] **EFS/NFS** performance mode appropriate?
- [ ] **Provisioned throughput** if needed?
- [ ] **Local SSD** for high-performance needs?

---

## 11. Monitoring & Alerting

### 11.1 Infrastructure Metrics

| Metric | Current | Alert Threshold |
|--------|---------|-----------------|
| CPU utilization | ? | > 80% for 5min |
| Memory utilization | ? | > 85% for 5min |
| Disk utilization | ? | > 80% |
| Network in/out | ? | Based on capacity |
| Error rate | ? | > 1% |
| Latency p99 | ? | > 2x baseline |

### 11.2 Alerting Configuration

- [ ] **Alerts** configured for all critical metrics?
- [ ] **Runbooks** for each alert?
- [ ] **Escalation paths** defined?
- [ ] **Alert fatigue** avoided (not too noisy)?

### 11.3 Distributed Tracing

- [ ] **Tracing** implemented (Jaeger, Zipkin, X-Ray)?
- [ ] **Sampling rate** appropriate?
- [ ] **Trace context** propagated across services?

---

## 12. Cost vs Performance

### 12.1 Cost Analysis

| Resource | Monthly Cost | Performance Benefit |
|----------|-------------|---------------------|
| Larger DB instance | +$500 | -200ms latency |
| CDN | +$100 | -500ms TTFB globally |
| Redis cluster | +$300 | -100ms API response |

### 12.2 Optimization Opportunities

- [ ] **Reserved instances** for stable workloads?
- [ ] **Spot instances** for fault-tolerant workloads?
- [ ] **Right-sizing** based on actual usage?
- [ ] **Unused resources** identified?

---

## Quick Wins Checklist

- [ ] Enable CDN for all static assets
- [ ] Configure proper cache headers at CDN
- [ ] Enable HTTP/2 and HTTP/3
- [ ] Add read replicas for read-heavy databases
- [ ] Configure auto-scaling with appropriate thresholds
- [ ] Enable Brotli compression at CDN/edge
- [ ] Set up health checks on load balancer
- [ ] Configure connection pooling for database
- [ ] Enable TLS 1.3
- [ ] Set up basic infrastructure monitoring/alerts
