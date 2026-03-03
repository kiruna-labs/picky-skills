# Frontend Performance Checklist

## Philosophy

**Every kilobyte shipped is a tax on your users.** Every render-blocking resource is stolen time. Every unnecessary re-render is wasted CPU cycles. Audit frontend performance like bandwidth costs money - because for many users, it literally does.

---

## 1. JavaScript Bundle Analysis

### 1.1 Bundle Size Audit

**Total bundle budget: < 300KB gzipped for initial load**

For EVERY JavaScript file:
- [ ] Size recorded (raw and gzipped)
- [ ] Purpose documented
- [ ] Loaded eagerly vs lazily
- [ ] Could be deferred?
- [ ] Could be eliminated?

| File | Raw Size | Gzipped | Load | Purpose | Action |
|------|----------|---------|------|---------|--------|
| main.js | XXX KB | XXX KB | eager | core app | - |
| vendor.js | XXX KB | XXX KB | eager | deps | split? |

### 1.2 Code Splitting

- [ ] **Route-based splitting** implemented?
- [ ] **Component-based splitting** for heavy components?
- [ ] **Vendor splitting** (framework vs app code)?
- [ ] **Dynamic imports** for conditional features?

Check for missing opportunities:
```javascript
// BAD: Eager import of heavy component
import HeavyChart from './HeavyChart';

// GOOD: Dynamic import
const HeavyChart = lazy(() => import('./HeavyChart'));
```

Scan patterns:
```bash
# Find large component imports that could be lazy
grep -r "^import.*from.*['\"]\./" --include="*.tsx" --include="*.jsx" | head -50
```

### 1.3 Tree Shaking Effectiveness

- [ ] **Named imports** used (not default/namespace)?
- [ ] **sideEffects: false** in package.json?
- [ ] **Dead code eliminated** in production build?

Bad patterns to find:
```bash
# Full library imports (tree shaking killer)
grep -r "import \* as" --include="*.ts" --include="*.tsx" --include="*.js"
grep -r "import _ from ['\"]lodash['\"]" --include="*.ts" --include="*.js"
grep -r "import moment from ['\"]moment['\"]" --include="*.ts" --include="*.js"

# Should be:
# import { debounce } from 'lodash-es'
# import dayjs from 'dayjs'
```

### 1.4 Unused Code Detection

Using Chrome DevTools Coverage:
- [ ] **Unused JavaScript** percentage
- [ ] **Unused CSS** percentage
- [ ] Files with > 50% unused code flagged

Target: < 30% unused code on initial load

### 1.5 Heavy Dependencies

Check for known heavy packages:

| Package | Typical Size | Lighter Alternative |
|---------|-------------|---------------------|
| moment | 329KB | dayjs (7KB), date-fns (tree-shakeable) |
| lodash | 531KB | lodash-es (tree-shakeable), native |
| jquery | 87KB | native DOM APIs |
| axios | 29KB | fetch API, ky (3KB) |
| uuid | 12KB | crypto.randomUUID() |
| classnames | 1KB | clsx (228B) |

```bash
# Check package.json for heavy deps
grep -E "moment|lodash[^-]|jquery|rxjs|@angular|antd|material-ui" package.json
```

### 1.6 Duplicate Dependencies

```bash
# Find duplicate packages in node_modules
npm ls --all | grep -E "^[├└]" | sort | uniq -c | sort -rn | head -20

# Or use dedicated tool
npx duplicate-package-checker-webpack-plugin
```

---

## 2. CSS Performance

### 2.1 CSS Size Audit

**CSS budget: < 100KB total, < 50KB critical**

- [ ] Total CSS size
- [ ] Critical CSS extracted?
- [ ] Unused CSS removed?
- [ ] CSS-in-JS runtime cost?

### 2.2 Critical CSS

- [ ] Above-the-fold CSS inlined in `<head>`?
- [ ] Non-critical CSS loaded asynchronously?

```html
<!-- Good: Critical CSS inlined -->
<style>/* Critical styles */</style>

<!-- Good: Non-critical CSS async loaded -->
<link rel="preload" href="styles.css" as="style" onload="this.rel='stylesheet'">
```

### 2.3 Unused CSS

Tools to detect:
```bash
# PurgeCSS analysis
npx purgecss --css dist/**/*.css --content dist/**/*.html dist/**/*.js

# Chrome DevTools Coverage tab
# Record page load and interactions
```

Common unused CSS sources:
- [ ] CSS frameworks (Bootstrap, Tailwind without purge)
- [ ] Removed components' styles still present
- [ ] Theme variations not used
- [ ] Print styles (if not needed)

### 2.4 CSS Delivery

- [ ] **No @import** in CSS files (blocks parallel download)
- [ ] **Media queries** for non-essential stylesheets
- [ ] **Minified** in production

```html
<!-- Good: Conditional loading -->
<link rel="stylesheet" href="print.css" media="print">
<link rel="stylesheet" href="large.css" media="(min-width: 1200px)">
```

### 2.5 CSS-in-JS Considerations

If using CSS-in-JS (styled-components, emotion):
- [ ] Runtime cost measured
- [ ] SSR extraction configured
- [ ] Babel plugin for optimization

---

## 3. Image Optimization

### 3.1 Format Audit

For EVERY image:

| Image | Current | Size | Recommended | Potential Savings |
|-------|---------|------|-------------|-------------------|
| hero.png | PNG | 2.4MB | WebP/AVIF | ~90% |
| logo.png | PNG | 45KB | SVG | ~80% |
| photo.jpg | JPEG | 890KB | WebP | ~30% |

Format recommendations:
- **Photos**: WebP (fallback JPEG), AVIF if supported
- **Graphics/logos**: SVG
- **Icons**: SVG or icon font
- **Animations**: WebP animated, or video for long ones

### 3.2 Responsive Images

- [ ] **srcset** attribute for different sizes?
- [ ] **sizes** attribute accurate?
- [ ] **Art direction** with `<picture>` where needed?

```html
<!-- Good: Responsive images -->
<img
  src="image-800.webp"
  srcset="image-400.webp 400w, image-800.webp 800w, image-1200.webp 1200w"
  sizes="(max-width: 600px) 400px, (max-width: 1000px) 800px, 1200px"
  alt="Description"
  loading="lazy"
  decoding="async"
>
```

### 3.3 Lazy Loading

- [ ] **loading="lazy"** on below-fold images?
- [ ] **Intersection Observer** for advanced lazy loading?
- [ ] **Placeholder/skeleton** while loading?

```bash
# Find images without lazy loading
grep -r "<img" --include="*.html" --include="*.tsx" --include="*.jsx" | grep -v "loading="
```

### 3.4 Image Dimensions

- [ ] **Explicit width/height** to prevent CLS?
- [ ] **aspect-ratio** CSS for responsive?

```html
<!-- Good: Prevents layout shift -->
<img src="photo.jpg" width="800" height="600" alt="...">

<!-- Or with CSS -->
<img src="photo.jpg" style="aspect-ratio: 4/3; width: 100%;" alt="...">
```

### 3.5 Image CDN Usage

- [ ] Images served from CDN?
- [ ] Automatic format conversion (WebP/AVIF)?
- [ ] Automatic resizing?
- [ ] Compression level optimized?

Popular image CDNs: Cloudinary, imgix, Cloudflare Images

---

## 4. Font Optimization

### 4.1 Font Audit

**Font budget: < 100KB total**

| Font | Weights | Size | Subset | WOFF2 |
|------|---------|------|--------|-------|
| Inter | 400,500,700 | 180KB | No | Yes |

### 4.2 Font Loading Strategy

- [ ] **font-display: swap** or **optional**?
- [ ] **Preload** critical fonts?
- [ ] **Local fallback** in font stack?

```css
/* Good: Swap prevents FOIT */
@font-face {
  font-family: 'CustomFont';
  src: url('font.woff2') format('woff2');
  font-display: swap;
}
```

```html
<!-- Good: Preload critical font -->
<link rel="preload" href="font.woff2" as="font" type="font/woff2" crossorigin>
```

### 4.3 Font Subsetting

- [ ] Only used characters included?
- [ ] Latin subset for English-only sites?

```bash
# Subset font to specific characters
pyftsubset font.ttf --unicodes="U+0020-007F" --output-file="font-subset.ttf"
```

### 4.4 Variable Fonts

- [ ] Using variable fonts for multiple weights?
- [ ] Single file vs multiple weight files size comparison?

### 4.5 System Font Alternative

Consider system font stack:
```css
font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
```
**Cost: 0KB**

---

## 5. Script Loading

### 5.1 Loading Attributes

For EVERY `<script>` tag:

| Script | async | defer | type=module | Blocking? |
|--------|-------|-------|-------------|-----------|
| analytics.js | Yes | - | - | No |
| main.js | - | Yes | - | No |
| inline | - | - | - | YES |

- [ ] **No render-blocking scripts** in `<head>`
- [ ] **async** for independent scripts
- [ ] **defer** for scripts needing DOM
- [ ] **type="module"** for modern browsers

### 5.2 Third-Party Scripts

- [ ] **Audit all third parties**
- [ ] **Async loading** for all?
- [ ] **Performance impact** measured?
- [ ] **Necessary?** (each one)

Common offenders:
- Analytics (Google Analytics, Mixpanel)
- Chat widgets (Intercom, Drift)
- Social embeds (Twitter, Facebook)
- Ad scripts
- A/B testing (Optimizely, VWO)

```bash
# Find third-party script tags
grep -r "script.*src=.*http" --include="*.html" --include="*.tsx"
grep -r "script.*src=.*//" --include="*.html" --include="*.tsx"
```

### 5.3 Inline Scripts

- [ ] **Critical JS** inlined?
- [ ] **Non-critical JS** external (cacheable)?
- [ ] **No large inline scripts** (> 10KB)

---

## 6. Rendering Performance

### 6.1 Layout Thrashing

Patterns that cause forced synchronous layout:

```javascript
// BAD: Read then write in loop
elements.forEach(el => {
  const height = el.offsetHeight; // READ
  el.style.height = height + 10 + 'px'; // WRITE
});

// GOOD: Batch reads, then batch writes
const heights = elements.map(el => el.offsetHeight);
elements.forEach((el, i) => {
  el.style.height = heights[i] + 10 + 'px';
});
```

Properties that trigger layout:
- `offsetTop/Left/Width/Height`
- `scrollTop/Left/Width/Height`
- `clientTop/Left/Width/Height`
- `getComputedStyle()`
- `getBoundingClientRect()`

### 6.2 Animation Performance

- [ ] **Compositor-only properties** used?
  - `transform`
  - `opacity`
- [ ] **will-change** for complex animations?
- [ ] **No layout-triggering** animations?

```css
/* Good: GPU-accelerated animation */
.animate {
  transform: translateX(100px);
  transition: transform 0.3s ease;
}

/* Bad: Causes layout on every frame */
.animate {
  left: 100px;
  transition: left 0.3s ease;
}
```

### 6.3 Virtual Scrolling

For long lists (> 100 items):
- [ ] **Virtual scrolling** implemented?
- [ ] Libraries: react-window, react-virtualized, @tanstack/virtual

### 6.4 Debouncing/Throttling

- [ ] **Scroll handlers** throttled?
- [ ] **Resize handlers** debounced?
- [ ] **Input handlers** debounced?

```javascript
// Good: Throttled scroll
window.addEventListener('scroll', throttle(handleScroll, 100));

// Good: Debounced search
input.addEventListener('input', debounce(handleSearch, 300));
```

---

## 7. React-Specific (If Applicable)

### 7.1 Re-render Analysis

Using React DevTools Profiler:
- [ ] **Unnecessary re-renders** identified
- [ ] **Wasted renders** from unchanged props
- [ ] **Context overuse** causing cascading renders

### 7.2 Optimization Techniques

- [ ] **React.memo** for pure components
- [ ] **useMemo** for expensive computations
- [ ] **useCallback** for stable callbacks
- [ ] **Code splitting** with React.lazy

### 7.3 Common React Anti-patterns

```jsx
// BAD: Inline object creates new reference every render
<Component style={{ color: 'red' }} />

// BAD: Inline function creates new reference every render
<Button onClick={() => handleClick(id)} />

// BAD: Index as key
{items.map((item, index) => <Item key={index} />)}
```

---

## 8. Metrics to Capture

### 8.1 Required Measurements

| Metric | Tool | Target |
|--------|------|--------|
| Bundle size | webpack-bundle-analyzer | < 300KB gz |
| Unused CSS | Coverage tool | < 30% |
| Unused JS | Coverage tool | < 30% |
| Image sizes | Network tab | Optimized |
| Font sizes | Network tab | < 100KB |
| Third-party impact | Network tab | Documented |

### 8.2 Lighthouse Specific

| Audit | Target |
|-------|--------|
| Render-blocking resources | 0 |
| Unused JavaScript | < 150KB |
| Unused CSS | < 50KB |
| Legacy JavaScript | 0 (modern bundles) |
| Unminified CSS | 0 |
| Unminified JavaScript | 0 |

---

## Quick Wins Checklist

High impact, low effort optimizations:

- [ ] Add `loading="lazy"` to all below-fold images
- [ ] Add `defer` to non-critical scripts
- [ ] Enable Brotli/Gzip compression
- [ ] Convert images to WebP
- [ ] Add `font-display: swap` to fonts
- [ ] Preload critical fonts
- [ ] Remove unused CSS framework components
- [ ] Replace moment.js with dayjs
- [ ] Add explicit dimensions to images
- [ ] Enable CDN caching
