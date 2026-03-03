# Performance Audit Report: Acme E-Commerce

**Audit Date**: 2025-01-27
**Auditor**: Claude (picky-performance skill)
**URL**: https://acme-store.example.com
**Pages Tested**: Home, Product Listing, Product Detail, Cart, Checkout

---

## Executive Summary

### Core Web Vitals (Field Data - CrUX)

| Metric | Mobile | Desktop | Target | Status |
|--------|--------|---------|--------|--------|
| **LCP** | 4.2s | 2.8s | < 2.5s | POOR / NEEDS IMPROVEMENT |
| **INP** | 320ms | 180ms | < 200ms | POOR / GOOD |
| **CLS** | 0.18 | 0.05 | < 0.1 | NEEDS IMPROVEMENT / GOOD |

### Lighthouse Scores (Mobile, Simulated)

| Page | Performance | Accessibility | Best Practices | SEO |
|------|-------------|---------------|----------------|-----|
| Home | 42 | 87 | 92 | 95 |
| Product Listing | 38 | 89 | 92 | 93 |
| Product Detail | 45 | 85 | 92 | 94 |
| Cart | 52 | 88 | 92 | 91 |
| Checkout | 48 | 82 | 87 | 89 |

### Key Metrics Summary

| Metric | Current | Target | Gap |
|--------|---------|--------|-----|
| Total Page Weight (Home) | 4.2 MB | < 1.5 MB | 2.7 MB |
| Initial JS Bundle | 890 KB | < 300 KB | 590 KB |
| Request Count (Home) | 127 | < 50 | 77 |
| TTFB | 1.4s | < 800ms | 600ms |

### Estimated Impact of Fixes

| Category | Time Savings | Weight Savings |
|----------|--------------|----------------|
| Image Optimization | ~1.5s LCP | ~1.8 MB |
| JavaScript Reduction | ~800ms TTI | ~500 KB |
| Caching Improvements | ~600ms repeat visits | N/A |
| Critical CSS | ~400ms FCP | N/A |
| **Total Potential** | **~2.5s faster LCP** | **~2.3 MB smaller** |

---

## Critical Issues (Fix Immediately)

### CRIT-001: Hero image is 2.8 MB unoptimized PNG

**Location**: Homepage hero section
**Current**: `hero-banner.png` - 2.8 MB, 3840x2160 PNG
**Impact**: Primary cause of 4.2s LCP on mobile

**Evidence**:
```
Network waterfall shows hero.png taking 3.1s to download on Slow 3G
LCP element identified as: <img src="/images/hero-banner.png">
```

**Fix**:
1. Convert to WebP with AVIF fallback
2. Implement responsive images with srcset
3. Add `fetchpriority="high"` and preload

```html
<!-- Before -->
<img src="/images/hero-banner.png" alt="Hero">

<!-- After -->
<link rel="preload" as="image" href="/images/hero-800.webp"
      imagesrcset="/images/hero-400.webp 400w, /images/hero-800.webp 800w, /images/hero-1200.webp 1200w"
      imagesizes="100vw">
<picture>
  <source type="image/avif" srcset="/images/hero-400.avif 400w, /images/hero-800.avif 800w">
  <source type="image/webp" srcset="/images/hero-400.webp 400w, /images/hero-800.webp 800w">
  <img src="/images/hero-800.webp"
       srcset="/images/hero-400.webp 400w, /images/hero-800.webp 800w, /images/hero-1200.webp 1200w"
       sizes="100vw"
       fetchpriority="high"
       alt="Hero banner">
</picture>
```

**Estimated Savings**: 2.5 MB, ~1.5s LCP improvement

---

### CRIT-002: 890 KB JavaScript bundle blocks interactivity

**Location**: `main.bundle.js`
**Current**: 890 KB gzipped, single bundle
**Impact**: 320ms INP on mobile, 2.1s parse/compile time

**Evidence**:
```
Bundle analysis reveals:
- moment.js: 329 KB (72 locales unused)
- lodash: 531 KB (full import, only 3 functions used)
- react-pdf: 180 KB (only used on 1 page)
- chart.js: 165 KB (only used in admin)
```

**Fix**:
1. Replace moment.js with dayjs (2 KB)
2. Use lodash-es with named imports
3. Code-split react-pdf and chart.js
4. Implement route-based code splitting

```javascript
// Before
import moment from 'moment';
import _ from 'lodash';
import { Document } from 'react-pdf';

// After
import dayjs from 'dayjs';
import { debounce, throttle, groupBy } from 'lodash-es';
const PDFViewer = lazy(() => import('./PDFViewer'));
```

**Estimated Savings**: 500 KB, ~800ms TTI improvement

---

### CRIT-003: N+1 database query on product listing

**Location**: `/api/products` endpoint
**Current**: 1 query for products + N queries for each product's images
**Impact**: 2.3s API response time for 50 products

**Evidence**:
```sql
-- Currently executing:
SELECT * FROM products WHERE category_id = 1 LIMIT 50;
-- Then for EACH product:
SELECT * FROM product_images WHERE product_id = ?;
-- Total: 51 queries
```

**Fix**:
```sql
-- Single query with JOIN
SELECT p.*, pi.url as image_url
FROM products p
LEFT JOIN product_images pi ON pi.product_id = p.id AND pi.is_primary = true
WHERE p.category_id = 1
LIMIT 50;
-- Total: 1 query
```

Or with ORM:
```javascript
// Before
const products = await Product.findAll({ where: { categoryId: 1 } });
for (const product of products) {
  product.images = await ProductImage.findAll({ where: { productId: product.id } });
}

// After
const products = await Product.findAll({
  where: { categoryId: 1 },
  include: [{ model: ProductImage, as: 'images' }]
});
```

**Estimated Savings**: 2s API response time

---

## High Priority Issues (Fix This Sprint)

### HIGH-001: No cache headers on static assets

**Location**: All static assets (JS, CSS, images, fonts)
**Current**: `Cache-Control: no-cache` or missing
**Impact**: Full re-download on every visit

**Evidence**:
```bash
$ curl -sI https://acme-store.example.com/assets/app.abc123.js | grep -i cache
Cache-Control: no-cache
# Should be: Cache-Control: public, max-age=31536000, immutable
```

**Fix**: Configure CDN/server to set proper cache headers

| Resource Type | Recommended Header |
|---------------|-------------------|
| Hashed JS/CSS | `public, max-age=31536000, immutable` |
| Images | `public, max-age=2592000` (30 days) |
| Fonts | `public, max-age=31536000, immutable` |
| HTML | `no-cache` or `private, max-age=0` |

**Estimated Savings**: ~600ms on repeat visits

---

### HIGH-002: No Brotli compression

**Location**: Server/CDN configuration
**Current**: Gzip only (or no compression on some endpoints)
**Impact**: 15-20% larger transfer sizes

**Evidence**:
```bash
$ curl -sI -H "Accept-Encoding: br, gzip" https://acme-store.example.com/api/products | grep content-encoding
content-encoding: gzip
# Brotli not supported
```

**Fix**: Enable Brotli compression on CDN/server

**Estimated Savings**: ~15% additional compression (~200 KB)

---

### HIGH-003: Product images not lazy loaded

**Location**: Product listing page
**Current**: All 50 product images load eagerly
**Impact**: 3.2 MB of images on initial load, delays LCP

**Evidence**:
```html
<!-- Current: All images eager -->
<img src="/products/1.jpg" alt="Product 1">
<img src="/products/2.jpg" alt="Product 2">
<!-- ... 48 more -->
```

**Fix**:
```html
<!-- First 4 images eager (above fold) -->
<img src="/products/1.jpg" alt="Product 1">
<img src="/products/2.jpg" alt="Product 2">
<img src="/products/3.jpg" alt="Product 3">
<img src="/products/4.jpg" alt="Product 4">

<!-- Rest lazy loaded -->
<img src="/products/5.jpg" alt="Product 5" loading="lazy">
<!-- ... -->
```

**Estimated Savings**: ~2.8 MB deferred, ~500ms LCP improvement

---

### HIGH-004: Layout shift from product cards loading

**Location**: Product listing page
**Current**: CLS of 0.18 from images loading without dimensions

**Evidence**:
```html
<!-- Current: No dimensions -->
<img src="/products/1.jpg" alt="Product">

<!-- Cards shift when images load -->
```

**Fix**:
```html
<!-- With dimensions -->
<img src="/products/1.jpg" width="300" height="300" alt="Product">

<!-- Or with aspect-ratio -->
<img src="/products/1.jpg" style="aspect-ratio: 1/1; width: 100%;" alt="Product">
```

**Estimated Savings**: CLS reduced to < 0.1

---

### HIGH-005: 127 requests on homepage

**Location**: Homepage
**Current**: 127 HTTP requests
**Impact**: Connection overhead, slower load

**Evidence**:
```
Breakdown:
- 45 product images (should be lazy)
- 23 third-party scripts (analytics, chat, ads)
- 18 font files (6 families × 3 weights)
- 15 CSS files (not bundled)
- 12 JS files (not code-split properly)
- 14 other
```

**Fix**:
1. Lazy load below-fold images (saves ~40 requests)
2. Audit third-party scripts (remove unused)
3. Subset fonts and reduce to 2-3 weights
4. Bundle CSS files

**Estimated Savings**: ~70 requests eliminated

---

## Medium Priority Issues

### MED-001: Third-party scripts blocking main thread

**Location**: `<head>` section
**Current**: Chat widget, analytics, A/B testing loaded synchronously
**Impact**: 450ms of main thread blocking

**Evidence**:
```html
<!-- Currently in <head> -->
<script src="https://chat-widget.example.com/widget.js"></script>
<script src="https://analytics.example.com/track.js"></script>
<script src="https://ab-test.example.com/experiment.js"></script>
```

**Fix**:
```html
<!-- Async loading -->
<script src="https://analytics.example.com/track.js" async></script>

<!-- Defer non-critical -->
<script src="https://chat-widget.example.com/widget.js" defer></script>

<!-- Or load after interaction (facade pattern) -->
<div id="chat-placeholder" onclick="loadChat()">Need help?</div>
```

---

### MED-002: Web fonts causing layout shift

**Location**: Global CSS
**Current**: `font-display: block` (FOIT), then shifts on load
**Impact**: 0.05 CLS contribution

**Fix**:
```css
@font-face {
  font-family: 'BrandFont';
  src: url('brand.woff2') format('woff2');
  font-display: swap; /* or optional */
}
```

Plus preload critical font:
```html
<link rel="preload" href="/fonts/brand.woff2" as="font" type="font/woff2" crossorigin>
```

---

### MED-003: Missing index on orders.user_id

**Location**: Database
**Current**: Full table scan on orders query
**Impact**: 800ms query time for order history

**Evidence**:
```sql
EXPLAIN ANALYZE SELECT * FROM orders WHERE user_id = 123 ORDER BY created_at DESC;
-- Shows: Seq Scan on orders, rows=1000000
```

**Fix**:
```sql
CREATE INDEX idx_orders_user_id_created ON orders(user_id, created_at DESC);
```

**Estimated Savings**: Query time 800ms → 5ms

---

### MED-004: API responses not compressed

**Location**: `/api/*` endpoints
**Current**: JSON responses sent uncompressed
**Impact**: 3x larger transfer size for API calls

**Fix**: Enable compression middleware

```javascript
// Express
const compression = require('compression');
app.use(compression());
```

---

## Low Priority Issues

### LOW-001: Unused CSS from component library

**Location**: `styles.bundle.css`
**Current**: 180 KB CSS, 65% unused
**Impact**: ~120 KB wasted bandwidth

**Fix**: Configure PurgeCSS or Tailwind JIT mode

---

### LOW-002: Console errors affecting performance

**Location**: Browser console
**Current**: 23 errors per page load
**Impact**: Minor, but indicates technical debt

```
Mixed Content warnings: 8
404 for missing images: 7
React key warnings: 5
Deprecated API warnings: 3
```

---

### LOW-003: Missing resource hints

**Location**: `<head>` section
**Current**: No preconnect/dns-prefetch

**Fix**:
```html
<link rel="preconnect" href="https://api.acme-store.example.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link rel="dns-prefetch" href="https://analytics.example.com">
```

---

## Quick Wins (Low Effort, High Impact)

| Fix | Effort | Impact | Priority |
|-----|--------|--------|----------|
| Add `loading="lazy"` to images | 30 min | -2.8 MB | Do now |
| Add image dimensions | 1 hour | CLS < 0.1 | Do now |
| Enable Brotli compression | 30 min | -15% size | Do now |
| Preload hero image | 10 min | -500ms LCP | Do now |
| Add `async` to analytics | 10 min | -200ms blocking | Do now |
| Preconnect to API | 5 min | -100ms | Do now |
| Replace moment with dayjs | 2 hours | -327 KB | This week |
| Add cache headers | 2 hours | -600ms repeat | This week |

---

## Performance Budget Recommendations

### Size Budgets
| Resource | Budget | Current | Action |
|----------|--------|---------|--------|
| Total Page | 1.5 MB | 4.2 MB | Reduce 65% |
| JavaScript | 300 KB | 890 KB | Reduce 66% |
| Images | 500 KB | 2.8 MB | Reduce 82% |
| CSS | 100 KB | 180 KB | Reduce 44% |
| Fonts | 100 KB | 156 KB | Reduce 36% |

### Timing Budgets
| Metric | Budget | Current | Gap |
|--------|--------|---------|-----|
| LCP | 2.5s | 4.2s | -1.7s |
| INP | 200ms | 320ms | -120ms |
| CLS | 0.1 | 0.18 | -0.08 |
| TTI | 3.8s | 6.2s | -2.4s |

### Request Budget
| Type | Budget | Current |
|------|--------|---------|
| Total | 50 | 127 |
| Third-party | 10 | 23 |
| Images (initial) | 10 | 50 |

---

## Monitoring Recommendations

1. **Set up Real User Monitoring (RUM)**
   - Track Core Web Vitals in production
   - Segment by device, connection, geography

2. **Add Performance Budgets to CI**
   - Fail build if bundle > 300 KB
   - Fail build if Lighthouse < 60

3. **Track Key Metrics Weekly**
   - LCP p75 from CrUX
   - INP p75 from CrUX
   - Lighthouse scores

---

## Summary

**Most Impactful Fixes:**
1. Optimize hero image (CRIT-001) - Saves ~1.5s LCP
2. Reduce JS bundle (CRIT-002) - Saves ~800ms TTI
3. Fix N+1 queries (CRIT-003) - Saves 2s API time
4. Enable caching (HIGH-001) - Saves 600ms repeat visits
5. Lazy load images (HIGH-003) - Saves 2.8 MB bandwidth

**Estimated Total Impact:**
- LCP: 4.2s → 2.2s (47% improvement)
- INP: 320ms → 180ms (44% improvement)
- Page Weight: 4.2 MB → 1.2 MB (71% reduction)
- Lighthouse Score: 42 → 75+ (projected)

---

*Report generated by picky-performance skill*
*"Every millisecond matters. Every byte counts."*
