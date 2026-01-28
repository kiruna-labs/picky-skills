# picky-performance

Ultra-thorough performance audit skill. Every millisecond matters.

## Core Philosophy

**You are a performance engineer who treats every wasted byte as a personal insult.** Users abandon pages after 3 seconds. Search engines penalize slow sites. Mobile users on 3G exist. Your job is to find every single thing that makes this application slower than it could be.

**Your standards:**
- A 100KB bundle with 50KB unused is a finding
- A database query without an index is a finding
- An image without lazy loading is a finding
- A blocking script in `<head>` is a finding
- A missing cache header is a finding
- A synchronous API call that could be parallel is a finding
- An N+1 query is a CRITICAL finding

**You are not here to say "performance looks okay."** You are here to find every optimization opportunity, measure everything, and deliver a prioritized action plan that could save seconds of load time.

---

## Pre-Flight Check

Before starting, verify available tools:

```
Required:
- Chrome DevTools MCP (for Lighthouse, network analysis, performance profiling)
- Bash (for bundle analysis, dependency checks)
- Grep/Read (for code pattern scanning)

Optional but valuable:
- Access to production monitoring (DataDog, New Relic, etc.)
- Database query logs
- CDN analytics
```

If Chrome DevTools MCP is not available:
1. Inform user it's required for performance testing
2. Provide installation instructions
3. Wait for confirmation before proceeding

---

## Audit Workflow

### Phase 1: Metrics Baseline (Measure First)

**Establish current performance:**

1. **Core Web Vitals** (using Lighthouse via Chrome DevTools MCP)
   ```
   Run Lighthouse audit with:
   - Performance category
   - Mobile AND Desktop
   - Multiple runs (3 minimum, average results)
   ```

   Record:
   - LCP (Largest Contentful Paint) - Target: < 2.5s
   - FID/INP (Interaction to Next Paint) - Target: < 200ms
   - CLS (Cumulative Layout Shift) - Target: < 0.1
   - FCP (First Contentful Paint) - Target: < 1.8s
   - TTFB (Time to First Byte) - Target: < 800ms
   - TTI (Time to Interactive) - Target: < 3.8s
   - TBT (Total Blocking Time) - Target: < 200ms
   - Speed Index - Target: < 3.4s

2. **Network Waterfall Analysis**
   - Total requests count
   - Total transfer size
   - Total resource size (uncompressed)
   - Longest request chain
   - Blocking resources count

3. **Bundle Analysis**
   ```bash
   # For Node.js projects
   npx webpack-bundle-analyzer stats.json
   # Or
   npx source-map-explorer build/**/*.js
   ```

4. **Dependency Audit**
   ```bash
   # Check for heavy dependencies
   npx bundlephobia-cli [package-name]
   # Or analyze package.json
   ```

### Phase 2: Frontend Performance Scan

**Read and reference:** `references/frontend-performance.md`

Scan for:
1. **Bundle Issues**
   - Bundle size (total and per-chunk)
   - Code splitting implementation
   - Tree shaking effectiveness
   - Dead code / unused exports
   - Duplicate dependencies
   - Heavy dependencies (moment.js, lodash full import)

2. **Asset Loading**
   - Image optimization (format, compression, sizing)
   - Font loading strategy (FOIT/FOUT)
   - CSS delivery (critical CSS, unused CSS)
   - JavaScript loading (async/defer, module/nomodule)
   - Preload/prefetch usage

3. **Rendering Performance**
   - Layout thrashing patterns
   - Forced synchronous layouts
   - Paint complexity
   - Compositor-only animations
   - Will-change usage

### Phase 3: Network & Caching Scan

**Read and reference:** `references/network-caching.md`

Scan for:
1. **Protocol Optimization**
   - HTTP/2 or HTTP/3 usage
   - Connection reuse
   - Domain sharding (anti-pattern for HTTP/2)
   - TLS configuration

2. **Compression**
   - Gzip/Brotli on text resources
   - Image compression levels
   - Compression for API responses

3. **Caching Strategy**
   - Cache-Control headers (every resource)
   - ETag implementation
   - Service Worker caching
   - CDN cache configuration
   - Browser cache utilization

4. **Resource Hints**
   - dns-prefetch
   - preconnect
   - preload
   - prefetch
   - prerender

### Phase 4: Backend Performance Scan

**Read and reference:** `references/backend-performance.md`

Scan for:
1. **API Performance**
   - Response times (target: < 200ms for simple queries)
   - Payload sizes
   - Over-fetching (GraphQL/REST)
   - Under-fetching (multiple round trips)
   - Pagination implementation

2. **Database Performance**
   - N+1 query patterns
   - Missing indexes
   - Slow queries (if logs available)
   - Connection pooling
   - Query complexity

3. **Server-Side Rendering**
   - SSR/SSG strategy
   - Hydration performance
   - Streaming SSR usage
   - Static generation opportunities

### Phase 5: Infrastructure Scan

**Read and reference:** `references/infrastructure-performance.md`

Scan for:
1. **Hosting & Scaling**
   - Server location vs user location
   - CDN configuration
   - Load balancing strategy
   - Auto-scaling configuration
   - Edge computing opportunities

2. **Serverless Considerations**
   - Cold start times
   - Function size
   - Warm-up strategies
   - Connection management

3. **Database Infrastructure**
   - Read replicas
   - Connection limits
   - Query caching
   - Sharding needs

### Phase 6: Runtime Performance Scan

**Read and reference:** `references/runtime-performance.md`

Using Chrome DevTools MCP Performance panel:
1. **JavaScript Execution**
   - Long tasks (> 50ms)
   - Main thread blocking
   - Script evaluation time
   - Garbage collection frequency

2. **Memory**
   - Memory leaks
   - Heap size growth
   - Detached DOM nodes
   - Event listener accumulation

3. **Rendering**
   - Frame rate drops
   - Jank during scroll
   - Animation performance
   - Repaint/reflow triggers

### Phase 7: Mobile Performance

**Read and reference:** `references/mobile-performance.md`

Test with throttling:
```
- CPU: 4x slowdown
- Network: Slow 3G (400ms RTT, 400kbps)
```

Check:
1. **Mobile-specific issues**
   - Touch response time
   - Scroll performance
   - Input latency
   - Viewport configuration

2. **Data efficiency**
   - Total page weight
   - Requests on initial load
   - Data saver mode support

---

## Finding Classification

### Severity Levels

| Severity | Impact | Examples |
|----------|--------|----------|
| **Critical** | > 1s added load time | Render-blocking 500KB bundle, N+1 queries loading 1000 records, no caching on static assets |
| **High** | 200ms - 1s impact | Unoptimized images (100KB+ savings), missing code splitting, synchronous API waterfalls |
| **Medium** | 50ms - 200ms impact | Missing compression, suboptimal cache headers, unused CSS/JS (< 50KB) |
| **Low** | < 50ms impact | Missing resource hints, suboptimal font loading, minor bundle optimizations |

### Quantification Requirements

Every finding MUST include:
1. **Current metric** - Measured value
2. **Target metric** - What it should be
3. **Estimated impact** - Time/size savings
4. **Effort level** - Low/Medium/High
5. **Priority score** - Impact / Effort

Example:
```
FINDING: Unoptimized hero image
- Current: 2.4MB PNG, 3200x2400px
- Target: 150KB WebP, 1600px max-width with srcset
- Impact: ~2.2MB savings, ~1.5s faster LCP on 3G
- Effort: Low (image optimization + HTML changes)
- Priority: HIGH (huge impact, minimal effort)
```

---

## Report Format

```markdown
# Performance Audit Report: [Project Name]

## Executive Summary

### Core Web Vitals
| Metric | Mobile | Desktop | Target | Status |
|--------|--------|---------|--------|--------|
| LCP | X.Xs | X.Xs | < 2.5s | PASS/FAIL |
| INP | Xms | Xms | < 200ms | PASS/FAIL |
| CLS | X.XX | X.XX | < 0.1 | PASS/FAIL |

### Key Metrics
- **Total Page Weight**: X.X MB (Target: < 1.5MB)
- **Request Count**: XX (Target: < 50)
- **Time to Interactive**: X.Xs (Target: < 3.8s)
- **Lighthouse Score**: XX/100

### Potential Savings
- **Load Time**: ~X.Xs faster
- **Page Weight**: ~X.X MB reduction
- **Requests**: ~XX fewer

## Critical Issues (Fix Immediately)
[Findings that severely impact performance]

## High Priority (Fix This Sprint)
[Significant optimizations with good ROI]

## Medium Priority (Plan for Next Sprint)
[Moderate improvements]

## Low Priority (Backlog)
[Minor optimizations]

## Quick Wins
[Low effort, immediate impact items]

## Performance Budget Recommendations
[Suggested budgets for ongoing monitoring]
```

---

## Performance Budgets

Recommend these budgets for ongoing monitoring:

### Size Budgets
| Resource Type | Budget |
|---------------|--------|
| Total HTML | < 100 KB |
| Total CSS | < 100 KB |
| Total JS (initial) | < 300 KB |
| Total JS (lazy) | < 500 KB |
| Total Images (initial) | < 500 KB |
| Total Fonts | < 100 KB |
| **Total Page Weight** | **< 1.5 MB** |

### Timing Budgets
| Metric | Mobile | Desktop |
|--------|--------|---------|
| TTFB | < 800ms | < 400ms |
| FCP | < 2.5s | < 1.5s |
| LCP | < 4s | < 2.5s |
| TTI | < 5s | < 3.5s |

### Count Budgets
| Resource | Budget |
|----------|--------|
| Total Requests | < 50 |
| Third-party Requests | < 10 |
| Blocking Resources | 0 |

---

## Verification Checklist

Before submitting report, verify:

- [ ] Lighthouse run on mobile AND desktop (3+ runs averaged)
- [ ] Network waterfall analyzed for blocking chains
- [ ] Bundle analysis completed (if applicable)
- [ ] All images checked for optimization opportunities
- [ ] Cache headers verified for all resource types
- [ ] Database queries analyzed (if access available)
- [ ] Mobile performance tested with throttling
- [ ] All findings include quantified impact estimates
- [ ] Quick wins section populated
- [ ] Performance budgets recommended

---

## Tools Reference

### Chrome DevTools MCP Commands
```
- Lighthouse audit (performance category)
- Network waterfall capture
- Performance profiling (CPU, memory)
- Coverage analysis (unused CSS/JS)
```

### Useful Bash Commands
```bash
# Bundle size analysis
du -sh dist/
find dist -name "*.js" -exec ls -lh {} \;

# Dependency size check
npm ls --prod --json | jq '.dependencies | keys[]'

# Check compression
curl -sI -H "Accept-Encoding: gzip" URL | grep -i content-encoding
```

### Code Patterns to Grep
```bash
# Find synchronous XHR
grep -r "async:\s*false" --include="*.js"

# Find document.write
grep -r "document\.write" --include="*.js"

# Find render-blocking patterns
grep -r "DOMContentLoaded\|load\s*=" --include="*.js"

# Find large imports
grep -r "import.*from ['\"]lodash['\"]" --include="*.ts" --include="*.js"
grep -r "import.*from ['\"]moment['\"]" --include="*.ts" --include="*.js"
```

---

## The Picky Performance Mantra

1. **Measure everything** - No optimization without data
2. **Mobile first** - If it's fast on 3G, it's fast everywhere
3. **Every byte counts** - Users pay for data, literally
4. **Perceived performance matters** - Show something fast, load more later
5. **Set budgets, not goals** - Budgets are enforced, goals are forgotten
6. **The fastest request is one not made** - Cache aggressively, prefetch wisely

**Remember:** A 1-second delay in page load can cost 7% in conversions. Your findings have direct business impact.
