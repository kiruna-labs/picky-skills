# Mobile Performance Checklist

## Philosophy

**Mobile is not a small desktop.** Slower CPUs, constrained memory, unreliable networks, touch interactions, battery concerns - mobile has unique challenges. And for many users globally, mobile IS the internet. Audit mobile performance like you're on a 3-year-old phone with a flaky connection - because many of your users are.

---

## 1. Mobile Network Simulation

### 1.1 Test Conditions

Test at these network conditions:

| Profile | Latency | Download | Upload | Use Case |
|---------|---------|----------|--------|----------|
| Fast 3G | 150ms | 1.5 Mbps | 750 Kbps | Good mobile |
| Slow 3G | 400ms | 400 Kbps | 400 Kbps | Poor mobile |
| Offline | - | 0 | 0 | No connection |
| Lie-Fi | 2000ms | 50 Kbps | 50 Kbps | Barely working |

Chrome DevTools: Network tab > Throttling dropdown

### 1.2 Network Performance Targets

| Metric | Fast 3G | Slow 3G |
|--------|---------|---------|
| FCP | < 3s | < 5s |
| LCP | < 4s | < 8s |
| TTI | < 5s | < 10s |
| Total weight | < 1MB | < 500KB |

### 1.3 Save-Data Header

- [ ] **Save-Data** header respected?
- [ ] **Reduced assets** when Save-Data: on?
- [ ] **Lower quality images** served?
- [ ] **Non-essential features** disabled?

```javascript
// Detect Save-Data preference
if (navigator.connection?.saveData) {
  // Load low-res images, skip non-essential features
}

// Server-side (check header)
if (req.headers['save-data'] === 'on') {
  // Serve lightweight version
}
```

---

## 2. CPU Throttling

### 2.1 CPU Simulation

Test with CPU throttled:
- **4x slowdown** = Average mobile device
- **6x slowdown** = Budget/older device

Chrome DevTools: Performance tab > CPU dropdown

### 2.2 CPU-Intensive Operations

| Operation | Desktop | 4x Throttle | Status |
|-----------|---------|-------------|--------|
| Initial render | 100ms | 400ms | ? |
| List scroll | 2ms/frame | 8ms/frame | ? |
| Search filter | 50ms | 200ms | ? |
| Modal open | 30ms | 120ms | ? |

Target: All operations < 100ms on 4x throttle

### 2.3 JavaScript Execution

- [ ] **No long tasks** (> 50ms) during interaction?
- [ ] **Main thread** not blocked?
- [ ] **Heavy computation** moved to Web Worker?

---

## 3. Touch Performance

### 3.1 Touch Response Time

| Interaction | Delay | Target | Status |
|-------------|-------|--------|--------|
| Tap to visual feedback | Xms | < 100ms | ? |
| Tap to action complete | Xms | < 300ms | ? |
| Scroll start | Xms | Instant | ? |
| Swipe gesture | Xms | Instant | ? |

### 3.2 Touch Event Handling

- [ ] **Passive event listeners** for touch/scroll?
- [ ] **No 300ms tap delay**? (touch-action: manipulation)
- [ ] **Immediate visual feedback** on touch?

```css
/* Remove 300ms tap delay */
html {
  touch-action: manipulation;
}

/* Or on specific elements */
.button {
  touch-action: manipulation;
}
```

```javascript
// Passive touch listeners
element.addEventListener('touchstart', handler, { passive: true });
element.addEventListener('touchmove', handler, { passive: true });
```

### 3.3 Touch Target Sizes

- [ ] **Minimum 44x44px** (Apple HIG)?
- [ ] **Preferably 48x48px** (Material)?
- [ ] **8px+ spacing** between targets?

```bash
# In DevTools Console, find small touch targets
document.querySelectorAll('button, a, [role="button"]').forEach(el => {
  const rect = el.getBoundingClientRect();
  if (rect.width < 44 || rect.height < 44) {
    console.log('Small target:', el, rect.width, rect.height);
  }
});
```

### 3.4 Scroll Performance

- [ ] **60fps scroll** maintained?
- [ ] **No janky scroll** during list virtualization?
- [ ] **Momentum scrolling** on iOS? (`-webkit-overflow-scrolling: touch`)

```css
/* Enable momentum scrolling on iOS */
.scrollable {
  overflow-y: auto;
  -webkit-overflow-scrolling: touch;
}
```

---

## 4. Page Weight Budget

### 4.1 Mobile Weight Targets

| Resource Type | Budget | Current | Status |
|---------------|--------|---------|--------|
| HTML | < 50 KB | ? | ? |
| CSS | < 50 KB | ? | ? |
| JS (initial) | < 150 KB | ? | ? |
| Images (initial) | < 300 KB | ? | ? |
| Fonts | < 50 KB | ? | ? |
| **Total** | **< 500 KB** | ? | ? |

### 4.2 Critical Request Audit

First 14KB delivered in initial TCP window - what's in it?

- [ ] **Critical CSS** inlined?
- [ ] **Essential HTML** in first response?
- [ ] **No blocking JS** before content?

### 4.3 Request Count

Target for mobile: < 30 requests on initial load

| Request Type | Count | Target |
|--------------|-------|--------|
| HTML | 1 | 1 |
| CSS | X | < 3 |
| JS | X | < 5 |
| Images | X | < 10 |
| Fonts | X | < 2 |
| API | X | < 5 |
| Third-party | X | < 5 |

---

## 5. Image Optimization for Mobile

### 5.1 Responsive Images

- [ ] **srcset** with mobile sizes?
- [ ] **sizes** attribute accurate?
- [ ] **Art direction** for mobile (different crop)?

```html
<!-- Good: Mobile-first responsive images -->
<img
  src="hero-400.webp"
  srcset="hero-400.webp 400w,
          hero-800.webp 800w,
          hero-1200.webp 1200w"
  sizes="(max-width: 600px) 100vw,
         (max-width: 1000px) 50vw,
         33vw"
  loading="lazy"
  decoding="async"
  alt="Hero image"
>

<!-- Art direction for mobile -->
<picture>
  <source media="(max-width: 600px)" srcset="hero-mobile.webp">
  <source media="(min-width: 601px)" srcset="hero-desktop.webp">
  <img src="hero-desktop.webp" alt="Hero">
</picture>
```

### 5.2 Lazy Loading

- [ ] **All below-fold images** lazy loaded?
- [ ] **Native lazy loading** (`loading="lazy"`)?
- [ ] **Placeholder/blur-up** for better UX?

### 5.3 Image Formats

| Format | Use Case | Mobile Support |
|--------|----------|----------------|
| WebP | Photos, general | 97%+ |
| AVIF | Photos (better) | 85%+ |
| SVG | Icons, logos | 100% |
| PNG | Transparency needed | 100% |

### 5.4 Image Compression

For mobile, aggressive compression is acceptable:

| Image Type | Quality | Target Size |
|------------|---------|-------------|
| Hero image | 70-80% | < 100KB |
| Product thumbnail | 70-80% | < 30KB |
| Avatar | 60-70% | < 10KB |
| Icon | SVG | < 5KB |

---

## 6. Font Loading on Mobile

### 6.1 Font Budget

Mobile font budget: < 50KB total

| Font | Weights | Size | Status |
|------|---------|------|--------|
| System fonts | - | 0KB | Best |
| Variable font | All | 50KB | Good |
| Multiple files | 2-3 | 80KB | Reduce |

### 6.2 Font Loading Strategy

```css
/* Good: Swap to prevent FOIT */
@font-face {
  font-family: 'CustomFont';
  src: url('font.woff2') format('woff2');
  font-display: swap;
}
```

- [ ] **font-display: swap** or **optional**?
- [ ] **WOFF2 only** (best compression)?
- [ ] **Subset** to used characters?

### 6.3 System Font Stack

Consider system fonts for mobile (0KB):

```css
body {
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto,
               Oxygen-Sans, Ubuntu, Cantarell, "Helvetica Neue", sans-serif;
}
```

---

## 7. JavaScript for Mobile

### 7.1 JavaScript Budget

| JS Type | Desktop Budget | Mobile Budget |
|---------|----------------|---------------|
| Initial load | 300KB | 150KB |
| Total lazy | 500KB | 300KB |
| Third-party | 100KB | 50KB |

### 7.2 Code Splitting for Mobile

- [ ] **Route-based splitting**?
- [ ] **Component-based splitting** for heavy features?
- [ ] **Conditional loading** for mobile-only features?

```javascript
// Good: Load heavy feature only when needed
const ChartComponent = lazy(() => import('./Chart'));

// Good: Load mobile-specific component
const MobileMenu = lazy(() => import('./MobileMenu'));
```

### 7.3 Mobile-Specific Optimizations

- [ ] **Reduced animations** on mobile?
- [ ] **Simpler interactions** on mobile?
- [ ] **prefers-reduced-motion** respected?

```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    transition-duration: 0.01ms !important;
  }
}
```

---

## 8. Viewport & Rendering

### 8.1 Viewport Configuration

```html
<!-- Good: Standard mobile viewport -->
<meta name="viewport" content="width=device-width, initial-scale=1">
```

- [ ] **viewport meta** present?
- [ ] **No user-scalable=no** (accessibility)?
- [ ] **No maximum-scale=1.0** (accessibility)?

### 8.2 Cumulative Layout Shift (CLS)

Mobile CLS issues:
- [ ] **Images** have dimensions?
- [ ] **Ads** have reserved space?
- [ ] **Fonts** don't cause shift?
- [ ] **Dynamic content** doesn't shift?

```html
<!-- Good: Reserve space for image -->
<img src="photo.jpg" width="400" height="300" loading="lazy">

<!-- Good: CSS aspect ratio -->
<img src="photo.jpg" style="aspect-ratio: 4/3; width: 100%;">
```

### 8.3 Content Stability

Test by watching page load:
- [ ] **No content jumping**?
- [ ] **No buttons moving**?
- [ ] **No text reflow** after fonts load?

---

## 9. Offline & Connectivity

### 9.1 Offline Experience

- [ ] **Service Worker** registered?
- [ ] **Offline fallback** page?
- [ ] **Core functionality** works offline?

### 9.2 Connection Detection

```javascript
// Detect connection type
const connection = navigator.connection;
if (connection) {
  const { effectiveType, saveData, downlink } = connection;
  // effectiveType: 'slow-2g', '2g', '3g', '4g'

  if (effectiveType === 'slow-2g' || effectiveType === '2g') {
    // Load minimal version
  }
}
```

### 9.3 Graceful Degradation

- [ ] **Slow connection** detection?
- [ ] **Reduced functionality** on slow connections?
- [ ] **Retry mechanisms** for failed requests?
- [ ] **Offline indicators**?

---

## 10. Battery Considerations

### 10.1 Battery-Draining Patterns

Avoid on mobile:
- [ ] **Continuous animations**?
- [ ] **Frequent polling**?
- [ ] **GPS/location overuse**?
- [ ] **Wake locks**?
- [ ] **Background processing**?

### 10.2 Power-Efficient Patterns

```javascript
// Good: Stop animations when not visible
document.addEventListener('visibilitychange', () => {
  if (document.hidden) {
    pauseAnimations();
    stopPolling();
  } else {
    resumeAnimations();
    startPolling();
  }
});

// Good: Use Intersection Observer instead of scroll events
const observer = new IntersectionObserver(handleIntersect);
observer.observe(element);
```

### 10.3 Background Behavior

- [ ] **Pause** when tab is hidden?
- [ ] **Reduce** when low battery?
- [ ] **Stop** polling when app is backgrounded?

---

## 11. Mobile-Specific Testing

### 11.1 Device Testing Matrix

| Device Type | Example | Viewport | CPU |
|-------------|---------|----------|-----|
| Budget Android | Moto G | 360x640 | Slow |
| Mid-range | Pixel 4a | 393x873 | Medium |
| High-end | iPhone 14 | 390x844 | Fast |
| Tablet | iPad | 768x1024 | Fast |

### 11.2 Real Device Testing

Chrome DevTools mobile emulation is NOT enough for:
- [ ] **Touch responsiveness**
- [ ] **Scroll smoothness**
- [ ] **Keyboard interactions**
- [ ] **Memory constraints**
- [ ] **GPS/sensors**

Use real devices or cloud testing (BrowserStack, LambdaTest)

### 11.3 Mobile Lighthouse

Run Lighthouse with mobile settings:
- Device: Mobile
- Throttling: Simulated (or Applied)
- Clear storage: Yes

Target scores:
- Performance: > 75
- Accessibility: > 90
- Best Practices: > 90
- SEO: > 90

---

## 12. PWA Performance

### 12.1 PWA Checklist

- [ ] **Service Worker** registered?
- [ ] **Manifest** present?
- [ ] **Icons** at all sizes?
- [ ] **Offline mode** functional?
- [ ] **Add to home screen** prompts?

### 12.2 App Shell Performance

- [ ] **App shell** cached?
- [ ] **Instant load** on repeat visit?
- [ ] **Background sync** for offline actions?

### 12.3 PWA Metrics

| Metric | Target | Current |
|--------|--------|---------|
| Time to App Shell | < 1s | ? |
| Cache hit rate | > 95% | ? |
| Offline success rate | 100% | ? |

---

## 13. Mobile Performance Audit Template

```markdown
## Mobile Performance Audit: [Page]

### Test Conditions
- Network: Slow 3G (400ms, 400kbps)
- CPU: 4x slowdown
- Device: Moto G4 (360x640)

### Core Web Vitals (Mobile)
| Metric | Value | Target | Status |
|--------|-------|--------|--------|
| LCP | Xs | < 4s | ? |
| INP | Xms | < 200ms | ? |
| CLS | X.XX | < 0.1 | ? |

### Page Weight
| Resource | Size | Budget | Status |
|----------|------|--------|--------|
| Total | XKB | < 500KB | ? |
| JS | XKB | < 150KB | ? |
| Images | XKB | < 300KB | ? |

### Touch Performance
| Interaction | Response | Target |
|-------------|----------|--------|
| Tap button | Xms | < 100ms |
| Open menu | Xms | < 300ms |
| Scroll | Xfps | 60fps |

### Issues Found
1. [Issue]
2. [Issue]

### Recommendations
1. [Recommendation]
2. [Recommendation]
```

---

## Quick Wins for Mobile

- [ ] Add `loading="lazy"` to all images
- [ ] Add `touch-action: manipulation` to remove tap delay
- [ ] Make touch targets at least 44x44px
- [ ] Enable text compression (Brotli/Gzip)
- [ ] Use system fonts or limit to 1-2 web fonts
- [ ] Implement Service Worker for offline
- [ ] Add `preconnect` for critical third-parties
- [ ] Set viewport correctly
- [ ] Use responsive images with srcset
- [ ] Test on real mobile device or throttled connection
