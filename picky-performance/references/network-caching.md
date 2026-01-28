# Network & Caching Performance Checklist

## Philosophy

**The fastest request is one never made.** Every network round-trip adds latency. Every uncached resource is a missed opportunity. Audit network performance like you're paying for every byte transferred - because your users' time and data plans are valuable.

---

## 1. Protocol Optimization

### 1.1 HTTP Version Check

```bash
# Check HTTP version
curl -sI https://example.com | grep -i "http/"

# Or via Chrome DevTools Network tab > Protocol column
```

- [ ] **HTTP/2 or HTTP/3** enabled?
- [ ] **ALPN negotiation** working?
- [ ] **Fallback** to HTTP/1.1 for compatibility?

HTTP/2 benefits:
- Multiplexing (multiple requests on one connection)
- Header compression
- Server push
- Stream prioritization

### 1.2 Connection Optimization

- [ ] **No domain sharding** (anti-pattern for HTTP/2)
- [ ] **Connection reuse** enabled (keep-alive)
- [ ] **TLS session resumption** configured

```bash
# Check keep-alive
curl -sI https://example.com | grep -i "connection:"
# Should show: Connection: keep-alive
```

### 1.3 TLS Performance

- [ ] **TLS 1.3** supported (faster handshake)
- [ ] **OCSP stapling** enabled
- [ ] **Session tickets** enabled
- [ ] **Modern cipher suites** (no slow algorithms)

```bash
# Check TLS version
curl -sI -v https://example.com 2>&1 | grep "SSL connection"
```

---

## 2. Compression

### 2.1 Text Resource Compression

For EVERY text resource (HTML, CSS, JS, JSON, SVG):

| Resource | Content-Encoding | Size | Compressed | Savings |
|----------|-----------------|------|------------|---------|
| /app.js | br | 450KB | 120KB | 73% |
| /styles.css | gzip | 80KB | 18KB | 78% |
| /api/data | none | 25KB | - | MISSING |

```bash
# Check compression for a resource
curl -sI -H "Accept-Encoding: gzip, br" https://example.com/app.js | grep -i "content-encoding"
```

### 2.2 Compression Levels

- [ ] **Brotli** preferred over Gzip (better ratio)
- [ ] **Gzip fallback** for older clients
- [ ] **Pre-compressed** static assets (br, gz files)
- [ ] **Dynamic compression** for API responses

Brotli vs Gzip savings:
| Resource Type | Gzip | Brotli | Additional Savings |
|--------------|------|--------|-------------------|
| JavaScript | 65-70% | 70-75% | ~15% smaller |
| CSS | 70-75% | 75-80% | ~10% smaller |
| HTML | 60-65% | 65-70% | ~10% smaller |

### 2.3 What NOT to Compress

- [ ] Already compressed formats excluded:
  - Images (JPEG, PNG, WebP, GIF)
  - Videos (MP4, WebM)
  - Fonts (WOFF2 - already compressed)
  - PDFs
  - ZIP files

### 2.4 Compression Configuration

**Nginx:**
```nginx
gzip on;
gzip_vary on;
gzip_types text/plain text/css application/json application/javascript text/xml application/xml;
gzip_min_length 1000;

brotli on;
brotli_types text/plain text/css application/json application/javascript;
```

**Cloudflare/CDN:**
- [ ] Brotli enabled in CDN settings
- [ ] Compression level optimized (quality vs CPU)

---

## 3. Caching Strategy

### 3.1 Cache-Control Headers

For EVERY resource type:

| Resource Type | Cache-Control | Expected |
|--------------|---------------|----------|
| HTML pages | no-cache or private | Revalidate each request |
| Hashed JS/CSS | max-age=31536000 | 1 year (immutable) |
| Unhashed static | max-age=86400 | 1 day + ETag |
| API responses | varies | Depends on data freshness |
| Images | max-age=2592000 | 30 days |
| Fonts | max-age=31536000 | 1 year |

```bash
# Check cache headers for each resource type
curl -sI https://example.com/ | grep -i "cache-control"
curl -sI https://example.com/app.abc123.js | grep -i "cache-control"
curl -sI https://example.com/logo.png | grep -i "cache-control"
```

### 3.2 Cache-Control Directives

- [ ] **max-age** set appropriately per resource type
- [ ] **immutable** for hashed/versioned assets
- [ ] **stale-while-revalidate** for graceful updates
- [ ] **no-store** for sensitive data
- [ ] **private** for user-specific content

```
# Optimal for hashed assets
Cache-Control: public, max-age=31536000, immutable

# Optimal for HTML
Cache-Control: no-cache

# Optimal for user-specific API data
Cache-Control: private, max-age=0, must-revalidate

# With graceful degradation
Cache-Control: max-age=3600, stale-while-revalidate=86400
```

### 3.3 ETag Implementation

- [ ] **ETag header** present for dynamic content?
- [ ] **If-None-Match** requests working?
- [ ] **304 responses** being served?

```bash
# Get ETag
ETAG=$(curl -sI https://example.com/data | grep -i etag | awk '{print $2}')

# Test conditional request
curl -sI -H "If-None-Match: $ETAG" https://example.com/data | head -1
# Should return: HTTP/2 304
```

### 3.4 Last-Modified / If-Modified-Since

- [ ] **Last-Modified** header present?
- [ ] **If-Modified-Since** conditional requests working?

### 3.5 Vary Header

- [ ] **Vary: Accept-Encoding** for compressed resources
- [ ] **Vary: Accept** for content negotiation
- [ ] **No over-varying** (kills cache efficiency)

```bash
curl -sI https://example.com/app.js | grep -i "vary:"
# Should include: Vary: Accept-Encoding
```

---

## 4. CDN Configuration

### 4.1 CDN Coverage

- [ ] **Static assets** served from CDN?
- [ ] **Multiple edge locations** (global coverage)?
- [ ] **Origin shield** configured (reduces origin load)?

### 4.2 CDN Cache Settings

- [ ] **Browser TTL** vs **Edge TTL** configured separately?
- [ ] **Query string handling** (ignore for static assets)?
- [ ] **Cache key** optimized (no unnecessary variations)?

### 4.3 CDN Features

- [ ] **HTTP/2 push** configured (if beneficial)?
- [ ] **Early hints** (103) enabled?
- [ ] **Auto minification** enabled?
- [ ] **Image optimization** at edge?

### 4.4 Cache Hit Ratio

Target: > 90% cache hit ratio for static assets

```bash
# Check CDN cache status (varies by CDN)
curl -sI https://example.com/app.js | grep -i "x-cache\|cf-cache-status"
# Should show: HIT
```

---

## 5. Resource Hints

### 5.1 DNS Prefetch

For third-party domains that will be used:

```html
<link rel="dns-prefetch" href="//fonts.googleapis.com">
<link rel="dns-prefetch" href="//analytics.example.com">
```

- [ ] **All third-party domains** prefetched?
- [ ] **Not overused** (diminishing returns after ~6)

### 5.2 Preconnect

For critical third-party connections:

```html
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link rel="preconnect" href="https://api.example.com">
```

- [ ] **Critical API endpoints** preconnected?
- [ ] **Font CDNs** preconnected?
- [ ] **crossorigin** attribute when needed?

### 5.3 Preload

For critical resources discovered late:

```html
<link rel="preload" href="/fonts/inter.woff2" as="font" type="font/woff2" crossorigin>
<link rel="preload" href="/critical.css" as="style">
<link rel="preload" href="/hero.webp" as="image">
```

- [ ] **Critical fonts** preloaded?
- [ ] **Above-fold images** preloaded?
- [ ] **Critical CSS** preloaded (if external)?
- [ ] **Not overused** (competes for bandwidth)

### 5.4 Prefetch

For resources needed on next navigation:

```html
<link rel="prefetch" href="/next-page.js">
<link rel="prefetch" href="/next-page-data.json">
```

- [ ] **Likely next pages** prefetched?
- [ ] **Only on fast connections** (respect Save-Data)?

### 5.5 Prerender (Speculation Rules)

```html
<script type="speculationrules">
{
  "prerender": [
    {"source": "list", "urls": ["/likely-next-page"]}
  ]
}
</script>
```

---

## 6. Service Worker Caching

### 6.1 Service Worker Present?

```bash
# Check for service worker registration
grep -r "serviceWorker.register" --include="*.js" --include="*.ts"
grep -r "navigator.serviceWorker" --include="*.js" --include="*.ts"
```

### 6.2 Caching Strategies

| Resource Type | Strategy | Description |
|--------------|----------|-------------|
| App shell | Cache first | Fast load, update in background |
| Static assets | Cache first | Immutable, always serve from cache |
| API data | Network first | Fresh data, cache fallback |
| Images | Stale-while-revalidate | Show cached, fetch update |

### 6.3 Cache Invalidation

- [ ] **Versioned cache names**?
- [ ] **Old caches cleaned up** on activation?
- [ ] **Cache size limits** implemented?

### 6.4 Offline Support

- [ ] **Offline fallback page**?
- [ ] **Critical assets cached** for offline?
- [ ] **Background sync** for failed requests?

---

## 7. API Response Optimization

### 7.1 Response Size

For EVERY API endpoint:

| Endpoint | Response Size | Fields Used | Waste |
|----------|--------------|-------------|-------|
| /api/users | 45KB | 12/48 fields | 75% |
| /api/products | 120KB | 8/25 fields | 68% |

- [ ] **Over-fetching** identified?
- [ ] **Sparse fieldsets** supported?
- [ ] **Pagination** implemented?
- [ ] **Compression** enabled for JSON?

### 7.2 API Caching

- [ ] **Cache-Control** headers on GET requests?
- [ ] **ETag/Last-Modified** for data freshness?
- [ ] **304 responses** for unchanged data?

```
GET /api/products
Cache-Control: private, max-age=60, stale-while-revalidate=300
ETag: "abc123"
```

### 7.3 GraphQL Specific

- [ ] **Persisted queries** to reduce request size?
- [ ] **Query complexity limits**?
- [ ] **Automatic query batching**?
- [ ] **Response caching**?

---

## 8. Request Optimization

### 8.1 Request Waterfall Analysis

Using Chrome DevTools Network tab:

- [ ] **Critical path** identified
- [ ] **Request chains** minimized
- [ ] **Parallel requests** maximized
- [ ] **No sequential dependencies** that could be parallel

### 8.2 Request Count

| Phase | Requests | Target |
|-------|----------|--------|
| Initial HTML | 1 | 1 |
| Critical CSS/JS | X | < 5 |
| Above-fold images | X | < 5 |
| Fonts | X | < 3 |
| Third-party | X | < 5 |
| **Total (initial)** | **X** | **< 20** |

### 8.3 Request Prioritization

- [ ] **Critical resources** have high priority?
- [ ] **fetchpriority="high"** on LCP image?
- [ ] **fetchpriority="low"** on below-fold images?

```html
<img src="hero.webp" fetchpriority="high" alt="...">
<img src="footer-logo.webp" fetchpriority="low" loading="lazy" alt="...">
```

### 8.4 Avoiding Redundant Requests

- [ ] **No duplicate requests** for same resource?
- [ ] **Request deduplication** in code?
- [ ] **SWR/React Query** for data fetching cache?

---

## 9. Third-Party Performance

### 9.1 Third-Party Inventory

| Third Party | Purpose | Size | Blocking? | Essential? |
|-------------|---------|------|-----------|------------|
| Google Analytics | Analytics | 45KB | No | Maybe |
| Intercom | Chat | 250KB | No | No |
| Stripe | Payments | 120KB | Yes | Yes |

### 9.2 Third-Party Loading

- [ ] **All async/defer** loaded?
- [ ] **Facades** for heavy widgets (YouTube, chat)?
- [ ] **Self-hosted** where possible (fonts, analytics)?

YouTube facade example:
```html
<!-- Don't load YouTube until interaction -->
<lite-youtube videoid="abc123"></lite-youtube>
```

### 9.3 Third-Party Impact

Using Chrome DevTools > Network > Third-party:
- [ ] **Total third-party size** measured
- [ ] **Third-party blocking time** measured
- [ ] **Main thread time** from third-parties

Target: Third-party < 20% of total page weight

---

## 10. Network Resilience

### 10.1 Slow Network Handling

Test with Chrome DevTools throttling:
- Slow 3G (400ms RTT, 400kbps)
- Fast 3G (150ms RTT, 1.5Mbps)

- [ ] **Timeouts** configured appropriately?
- [ ] **Retry logic** with exponential backoff?
- [ ] **Loading states** shown during slow loads?

### 10.2 Offline Handling

- [ ] **Graceful degradation** when offline?
- [ ] **Cached data** available offline?
- [ ] **Clear messaging** about offline state?

### 10.3 Error Recovery

- [ ] **Failed requests** retried appropriately?
- [ ] **Circuit breaker** for failing services?
- [ ] **Fallback content** for failed resources?

---

## 11. Monitoring & Metrics

### 11.1 Key Metrics to Track

| Metric | How to Measure | Target |
|--------|---------------|--------|
| Cache hit ratio | CDN analytics | > 90% |
| TTFB | RUM/Lighthouse | < 800ms |
| Total transfer size | Network tab | < 1.5MB |
| Request count | Network tab | < 50 |
| Third-party % | Network tab | < 20% |

### 11.2 Real User Monitoring

- [ ] **RUM implemented** (navigation timing)?
- [ ] **Resource timing** collected?
- [ ] **Connection type** tracked?
- [ ] **Geographic performance** monitored?

---

## Quick Wins Checklist

- [ ] Enable Brotli compression (if only gzip)
- [ ] Add Cache-Control headers to all static assets
- [ ] Add `immutable` to hashed assets
- [ ] Add preconnect for critical third-parties
- [ ] Add dns-prefetch for all third-party domains
- [ ] Preload critical fonts
- [ ] Add fetchpriority="high" to LCP image
- [ ] Lazy load all third-party widgets
- [ ] Enable CDN for static assets
- [ ] Add stale-while-revalidate for better UX
