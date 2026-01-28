# Core Web Vitals Reference

## Philosophy

**Core Web Vitals are Google's way of quantifying user experience.** They're not arbitrary metrics - they measure what users actually feel: how fast content appears, how quickly they can interact, and how stable the page is. These metrics affect SEO rankings and directly correlate with conversion rates.

---

## 1. Largest Contentful Paint (LCP)

### What It Measures
Time until the largest content element is visible in the viewport.

### Thresholds
| Rating | Time |
|--------|------|
| Good | < 2.5s |
| Needs Improvement | 2.5s - 4.0s |
| Poor | > 4.0s |

### What Elements Count as LCP
- `<img>` elements
- `<image>` inside SVG
- `<video>` poster image
- Background images via `url()`
- Block-level text elements

### Common LCP Issues

| Issue | Impact | Fix |
|-------|--------|-----|
| Slow server response | Delays everything | Improve TTFB, use CDN |
| Render-blocking resources | Delays first paint | Defer JS, inline critical CSS |
| Slow resource load | Image/video loads slowly | Optimize, compress, CDN |
| Client-side rendering | Content built in JS | SSR/SSG, prerender |

### LCP Optimization Checklist

- [ ] **TTFB < 800ms**?
- [ ] **LCP element preloaded** (`<link rel="preload">`)?
- [ ] **No render-blocking JS** before LCP element?
- [ ] **LCP image optimized** (WebP, compressed)?
- [ ] **LCP image responsive** (srcset)?
- [ ] **fetchpriority="high"** on LCP image?
- [ ] **Critical CSS inlined**?
- [ ] **SSR/SSG** for above-fold content?

### LCP Debugging

```javascript
// Find LCP element
new PerformanceObserver((list) => {
  const entries = list.getEntries();
  const lastEntry = entries[entries.length - 1];
  console.log('LCP element:', lastEntry.element);
  console.log('LCP time:', lastEntry.startTime);
}).observe({ type: 'largest-contentful-paint', buffered: true });
```

### LCP Prioritization

```html
<!-- Preload LCP image -->
<link rel="preload" as="image" href="hero.webp">

<!-- High priority for LCP image -->
<img src="hero.webp" fetchpriority="high" alt="Hero">

<!-- Low priority for below-fold images -->
<img src="footer.webp" fetchpriority="low" loading="lazy" alt="Footer">
```

---

## 2. Interaction to Next Paint (INP)

### What It Measures
Responsiveness - how long from user interaction to visual update.

*Replaced First Input Delay (FID) in March 2024*

### Thresholds
| Rating | Time |
|--------|------|
| Good | < 200ms |
| Needs Improvement | 200ms - 500ms |
| Poor | > 500ms |

### What Interactions Count
- Clicks
- Taps
- Key presses

Does NOT include:
- Scroll
- Hover

### INP Breakdown

Total INP = Input Delay + Processing Time + Presentation Delay

| Phase | What It Is | Target |
|-------|-----------|--------|
| Input Delay | Time before handler starts | < 50ms |
| Processing Time | Handler execution | < 100ms |
| Presentation Delay | Render/paint time | < 50ms |

### Common INP Issues

| Issue | Impact | Fix |
|-------|--------|-----|
| Long tasks blocking main thread | Input delay | Code split, defer work |
| Expensive event handlers | Processing time | Optimize, debounce, Web Worker |
| Heavy DOM updates | Presentation delay | Virtual DOM, batch updates |
| Hydration blocking | Input delay | Progressive hydration |

### INP Optimization Checklist

- [ ] **No long tasks** (> 50ms) on main thread?
- [ ] **Event handlers < 100ms**?
- [ ] **Heavy computation** in Web Workers?
- [ ] **Debounced/throttled** input handlers?
- [ ] **requestIdleCallback** for non-urgent work?
- [ ] **Optimistic UI** updates?

### INP Debugging

```javascript
// Find slow interactions
new PerformanceObserver((list) => {
  for (const entry of list.getEntries()) {
    if (entry.duration > 200) {
      console.log('Slow interaction:', {
        target: entry.target,
        type: entry.name,
        duration: entry.duration,
        inputDelay: entry.processingStart - entry.startTime,
        processingTime: entry.processingEnd - entry.processingStart,
        presentationDelay: entry.startTime + entry.duration - entry.processingEnd
      });
    }
  }
}).observe({ type: 'event', buffered: true, durationThreshold: 16 });
```

### INP Optimization Patterns

```javascript
// BAD: Synchronous heavy work
button.addEventListener('click', () => {
  processLargeDataset(); // Blocks for 500ms
  updateUI();
});

// GOOD: Break up work
button.addEventListener('click', () => {
  // Immediate visual feedback
  showSpinner();

  // Defer heavy work
  requestIdleCallback(() => {
    processLargeDataset();
    updateUI();
    hideSpinner();
  });
});

// BETTER: Use Web Worker
button.addEventListener('click', () => {
  showSpinner();
  worker.postMessage(data);
});

worker.onmessage = (e) => {
  updateUI(e.data);
  hideSpinner();
};
```

---

## 3. Cumulative Layout Shift (CLS)

### What It Measures
Visual stability - how much content moves around unexpectedly.

### Thresholds
| Rating | Score |
|--------|-------|
| Good | < 0.1 |
| Needs Improvement | 0.1 - 0.25 |
| Poor | > 0.25 |

### How CLS Is Calculated

```
CLS = Impact Fraction × Distance Fraction

Impact Fraction = % of viewport affected by shift
Distance Fraction = Distance moved / viewport height
```

Example: Element covers 50% of viewport, moves 25% of viewport height
CLS contribution = 0.5 × 0.25 = 0.125

### What DOESN'T Count
- Shifts within 500ms of user interaction
- Shifts during scroll
- Shifts of invisible elements

### Common CLS Causes

| Cause | Impact | Fix |
|-------|--------|-----|
| Images without dimensions | Large shift | Add width/height |
| Ads/embeds without reserved space | Large shift | Reserve space |
| Web fonts causing FOUT | Text shift | font-display, preload |
| Dynamically injected content | Content pushes down | Reserve space |
| Animations using top/left | Repeated shifts | Use transform |

### CLS Optimization Checklist

- [ ] **All images** have width/height attributes?
- [ ] **All videos/iframes** have dimensions?
- [ ] **Ad slots** have reserved space?
- [ ] **Web fonts** use font-display: optional or swap with fallback sizing?
- [ ] **Dynamic content** has reserved space?
- [ ] **Animations** use transform, not position?

### CLS Debugging

```javascript
// Find elements causing shifts
new PerformanceObserver((list) => {
  for (const entry of list.getEntries()) {
    if (entry.value > 0) {
      console.log('Layout shift:', {
        value: entry.value,
        sources: entry.sources?.map(s => s.node)
      });
    }
  }
}).observe({ type: 'layout-shift', buffered: true });
```

### Preventing CLS

```html
<!-- Always set dimensions on images -->
<img src="photo.jpg" width="800" height="600" alt="Photo">

<!-- Or use aspect-ratio -->
<img src="photo.jpg" style="aspect-ratio: 4/3; width: 100%;">

<!-- Reserve space for ads -->
<div style="min-height: 250px;">
  <!-- Ad will load here -->
</div>

<!-- Reserve space for dynamic content -->
<div id="dynamic-content" style="min-height: 100px;">
  Loading...
</div>
```

```css
/* Prevent font swap layout shift */
@font-face {
  font-family: 'CustomFont';
  src: url('font.woff2') format('woff2');
  font-display: optional; /* Never causes shift */
}

/* Or match fallback metrics */
@font-face {
  font-family: 'CustomFont';
  src: url('font.woff2') format('woff2');
  font-display: swap;
  /* Size-adjust, ascent-override, etc. to match fallback */
}
```

---

## 4. Supporting Metrics

### Time to First Byte (TTFB)

Time until first byte of response.

| Rating | Time |
|--------|------|
| Good | < 800ms |
| Needs Improvement | 800ms - 1.8s |
| Poor | > 1.8s |

Affects: LCP (directly)

### First Contentful Paint (FCP)

Time until first content appears.

| Rating | Time |
|--------|------|
| Good | < 1.8s |
| Needs Improvement | 1.8s - 3.0s |
| Poor | > 3.0s |

Affects: Perceived performance

### Time to Interactive (TTI)

Time until page is fully interactive.

| Rating | Time |
|--------|------|
| Good | < 3.8s |
| Needs Improvement | 3.8s - 7.3s |
| Poor | > 7.3s |

Affects: INP (indirect)

### Total Blocking Time (TBT)

Sum of blocking time from long tasks.

| Rating | Time |
|--------|------|
| Good | < 200ms |
| Needs Improvement | 200ms - 600ms |
| Poor | > 600ms |

Correlates with: INP

### Speed Index

How quickly content is visually displayed.

| Rating | Time |
|--------|------|
| Good | < 3.4s |
| Needs Improvement | 3.4s - 5.8s |
| Poor | > 5.8s |

---

## 5. Measurement Tools

### Lab Tools (Synthetic)
- **Lighthouse** (Chrome DevTools, CLI, CI)
- **WebPageTest**
- **PageSpeed Insights**

### Field Tools (RUM)
- **Chrome User Experience Report (CrUX)**
- **PageSpeed Insights** (shows field data)
- **Google Search Console** (Core Web Vitals report)
- **web-vitals library** (custom RUM)

### Collect in Production

```javascript
import { onLCP, onINP, onCLS } from 'web-vitals';

function sendToAnalytics(metric) {
  const body = JSON.stringify({
    name: metric.name,
    value: metric.value,
    delta: metric.delta,
    id: metric.id,
    page: location.pathname
  });
  navigator.sendBeacon('/analytics', body);
}

onLCP(sendToAnalytics);
onINP(sendToAnalytics);
onCLS(sendToAnalytics);
```

---

## 6. Lighthouse Performance Score

Score is weighted average of metrics:

| Metric | Weight |
|--------|--------|
| FCP | 10% |
| Speed Index | 10% |
| LCP | 25% |
| TBT | 30% |
| CLS | 25% |

### Score Interpretation

| Score | Rating |
|-------|--------|
| 90-100 | Good (green) |
| 50-89 | Needs Improvement (orange) |
| 0-49 | Poor (red) |

### Running Lighthouse

```bash
# CLI
npx lighthouse https://example.com --preset=desktop
npx lighthouse https://example.com --preset=mobile

# With throttling similar to real users
npx lighthouse https://example.com --throttling-method=devtools

# Output formats
npx lighthouse https://example.com --output=json --output-path=report.json
npx lighthouse https://example.com --output=html --output-path=report.html
```

### CI Integration

```yaml
# GitHub Actions example
- name: Lighthouse CI
  uses: treosh/lighthouse-ci-action@v10
  with:
    urls: |
      https://example.com/
      https://example.com/products
    budgetPath: ./budget.json
    uploadArtifacts: true
```

---

## 7. Performance Budget Example

```json
{
  "timings": [
    { "metric": "interactive", "budget": 3800 },
    { "metric": "first-contentful-paint", "budget": 1800 },
    { "metric": "largest-contentful-paint", "budget": 2500 }
  ],
  "resourceSizes": [
    { "resourceType": "total", "budget": 500 },
    { "resourceType": "script", "budget": 150 },
    { "resourceType": "stylesheet", "budget": 50 },
    { "resourceType": "image", "budget": 200 },
    { "resourceType": "font", "budget": 50 }
  ],
  "resourceCounts": [
    { "resourceType": "total", "budget": 50 },
    { "resourceType": "third-party", "budget": 10 }
  ]
}
```

---

## 8. Quick Reference Table

| Metric | Good | Needs Improvement | Poor | Primary Factor |
|--------|------|-------------------|------|----------------|
| **LCP** | < 2.5s | 2.5s - 4.0s | > 4.0s | Loading |
| **INP** | < 200ms | 200ms - 500ms | > 500ms | Interactivity |
| **CLS** | < 0.1 | 0.1 - 0.25 | > 0.25 | Visual Stability |
| TTFB | < 800ms | 800ms - 1.8s | > 1.8s | Server |
| FCP | < 1.8s | 1.8s - 3.0s | > 3.0s | Loading |
| TTI | < 3.8s | 3.8s - 7.3s | > 7.3s | Interactivity |
| TBT | < 200ms | 200ms - 600ms | > 600ms | Interactivity |
| SI | < 3.4s | 3.4s - 5.8s | > 5.8s | Perceived |

---

## 9. Diagnostic Questions

### If LCP is poor:
1. Is TTFB slow? → Server/CDN issue
2. Is there render-blocking JS? → Defer scripts
3. Is LCP image slow to load? → Optimize, preload, CDN
4. Is content built client-side? → SSR/SSG

### If INP is poor:
1. Are there long tasks? → Code split, defer work
2. Are event handlers slow? → Optimize, Web Workers
3. Is there heavy rendering? → Virtual DOM, optimize
4. Is hydration slow? → Progressive hydration

### If CLS is poor:
1. Are images missing dimensions? → Add width/height
2. Are fonts causing shift? → font-display, size-adjust
3. Is content injected dynamically? → Reserve space
4. Are ads shifting content? → Reserve ad slots

---

## 10. Priority Order for Fixes

1. **Critical**: Fix anything causing "Poor" rating
2. **High**: Fix anything causing "Needs Improvement"
3. **Medium**: Improve metrics already in "Good" range
4. **Low**: Optimize for exceptional performance

Focus on:
- **LCP first** (25% of Lighthouse score)
- **INP second** (correlates with TBT, 30% weight)
- **CLS third** (25% of Lighthouse score)
