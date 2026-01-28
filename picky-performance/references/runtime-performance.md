# Runtime Performance Checklist

## Philosophy

**Performance isn't just about load time - it's about every interaction.** A page that loads fast but stutters during scroll is a failure. An app that responds quickly but freezes during data processing is broken. Audit runtime performance like every dropped frame is a user noticing something is wrong - because they will.

---

## 1. JavaScript Execution Performance

### 1.1 Long Tasks Detection

Using Chrome DevTools Performance panel:

**Long Task = > 50ms on main thread**

| Task | Duration | Location | Impact |
|------|----------|----------|--------|
| Script evaluation | 250ms | app.bundle.js | Blocks interaction |
| Event handler | 80ms | click handler | Delays feedback |
| Layout | 120ms | DOM manipulation | Causes jank |

Target: No tasks > 50ms during interaction

### 1.2 Main Thread Analysis

Record a Performance profile and analyze:

- [ ] **Total blocking time** (TBT) measured
- [ ] **Largest tasks** identified
- [ ] **Scripting time** vs **Rendering time**
- [ ] **Idle time** percentage

Target breakdown:
- Scripting: < 30%
- Rendering: < 20%
- Painting: < 10%
- Idle: > 40%

### 1.3 Script Evaluation

- [ ] **Parse time** for bundles measured?
- [ ] **Compile time** measured?
- [ ] **Execution time** measured?

Optimization:
```javascript
// BAD: Large synchronous script
<script src="huge-bundle.js"></script>

// GOOD: Code split + defer
<script src="critical.js"></script>
<script src="non-critical.js" defer></script>
```

### 1.4 Event Handler Performance

For EVERY event handler type:

| Event | Typical Duration | Debounced/Throttled | Status |
|-------|-----------------|---------------------|--------|
| click | < 50ms | N/A | ? |
| scroll | < 16ms | Yes (rAF) | ? |
| resize | < 16ms | Yes (debounce) | ? |
| input | < 50ms | Yes (debounce) | ? |
| mousemove | < 16ms | Yes (throttle) | ? |

```javascript
// Good: Throttled scroll handler
let ticking = false;
window.addEventListener('scroll', () => {
  if (!ticking) {
    requestAnimationFrame(() => {
      handleScroll();
      ticking = false;
    });
    ticking = true;
  }
});
```

---

## 2. Rendering Performance

### 2.1 Frame Rate Analysis

Using Performance panel, analyze frames:

- [ ] **Consistent 60fps** during animations?
- [ ] **No dropped frames** during scroll?
- [ ] **No jank** during interactions?

Frame budget: 16.67ms (1000ms / 60fps)

### 2.2 Layout Thrashing Detection

Patterns that force synchronous layout:

```javascript
// BAD: Read-write-read-write pattern
elements.forEach(el => {
  const width = el.offsetWidth;      // READ - forces layout
  el.style.width = width + 10 + 'px'; // WRITE
});

// GOOD: Batch reads, then batch writes
const widths = elements.map(el => el.offsetWidth); // All READs
elements.forEach((el, i) => {
  el.style.width = widths[i] + 10 + 'px'; // All WRITEs
});
```

Properties that trigger layout (avoid reading in animation loops):
- `offsetTop`, `offsetLeft`, `offsetWidth`, `offsetHeight`
- `scrollTop`, `scrollLeft`, `scrollWidth`, `scrollHeight`
- `clientTop`, `clientLeft`, `clientWidth`, `clientHeight`
- `getComputedStyle()`
- `getBoundingClientRect()`

### 2.3 Paint Performance

Using Performance panel > Enable Paint Flashing:

- [ ] **Minimal paint areas** during animations?
- [ ] **No full-page repaints**?
- [ ] **Compositor layers** for animated elements?

### 2.4 Compositor-Only Animations

Only these properties can be animated without layout/paint:
- `transform` (translate, scale, rotate)
- `opacity`

```css
/* GOOD: Compositor-only animation */
.animate {
  transform: translateX(100px);
  transition: transform 0.3s ease;
}

/* BAD: Triggers layout on every frame */
.animate {
  left: 100px;
  transition: left 0.3s ease;
}

/* BAD: Triggers paint on every frame */
.animate {
  background-color: red;
  transition: background-color 0.3s ease;
}
```

### 2.5 Will-Change Optimization

```css
/* Good: Hint to browser for upcoming animation */
.will-animate {
  will-change: transform;
}

/* Remove after animation completes */
.animation-done {
  will-change: auto;
}
```

- [ ] **will-change** used sparingly?
- [ ] **Not overused** (causes memory overhead)?
- [ ] **Removed** after animation completes?

---

## 3. Memory Performance

### 3.1 Memory Leak Detection

Using Chrome DevTools Memory panel:

1. Take heap snapshot (baseline)
2. Perform action that might leak
3. Take another heap snapshot
4. Compare snapshots
5. Look for objects that should have been collected

Common leak patterns:
- [ ] **Detached DOM nodes**
- [ ] **Event listeners not removed**
- [ ] **Closures holding references**
- [ ] **Global variables accumulating**
- [ ] **Timers not cleared**
- [ ] **Observers not disconnected**

### 3.2 Memory Usage Over Time

Record Performance with Memory checkbox:

- [ ] **Heap size stable** over time?
- [ ] **No sawtooth pattern** (constant GC)?
- [ ] **No unbounded growth**?

### 3.3 Event Listener Cleanup

```javascript
// BAD: Listener never removed
useEffect(() => {
  window.addEventListener('resize', handleResize);
}, []);

// GOOD: Cleanup on unmount
useEffect(() => {
  window.addEventListener('resize', handleResize);
  return () => window.removeEventListener('resize', handleResize);
}, []);
```

Scan for patterns:
```bash
# Find addEventListener without removeEventListener
grep -r "addEventListener" --include="*.js" --include="*.ts" -l | while read f; do
  add=$(grep -c "addEventListener" "$f")
  remove=$(grep -c "removeEventListener" "$f")
  if [ "$add" -gt "$remove" ]; then
    echo "$f: $add adds, $remove removes"
  fi
done
```

### 3.4 DOM Size Management

- [ ] **Total DOM nodes** < 1500?
- [ ] **DOM depth** < 32 levels?
- [ ] **Virtual scrolling** for long lists?
- [ ] **Removed nodes** garbage collected?

```javascript
// Check DOM size
document.querySelectorAll('*').length
// Target: < 1500
```

---

## 4. Garbage Collection

### 4.1 GC Frequency

In Performance recording:

- [ ] **GC events** not too frequent (< 1/second)?
- [ ] **GC duration** not too long (< 10ms)?
- [ ] **No GC during animations**?

### 4.2 Reducing GC Pressure

```javascript
// BAD: Creates garbage every frame
function animate() {
  const position = { x: 0, y: 0 }; // New object every frame
  // ...
  requestAnimationFrame(animate);
}

// GOOD: Reuse objects
const position = { x: 0, y: 0 };
function animate() {
  position.x = calculateX();
  position.y = calculateY();
  // ...
  requestAnimationFrame(animate);
}
```

### 4.3 Object Pooling

For frequently created/destroyed objects:

```javascript
// Object pool for particles, projectiles, etc.
const pool = [];

function getObject() {
  return pool.pop() || createNewObject();
}

function releaseObject(obj) {
  resetObject(obj);
  pool.push(obj);
}
```

---

## 5. Scroll Performance

### 5.1 Scroll Jank Detection

- [ ] **Scroll handlers** throttled/passive?
- [ ] **No layout in scroll handlers**?
- [ ] **Compositor layers** for sticky elements?

```javascript
// GOOD: Passive scroll listener
window.addEventListener('scroll', handleScroll, { passive: true });
```

### 5.2 Passive Event Listeners

- [ ] **touchstart** passive?
- [ ] **touchmove** passive?
- [ ] **wheel** passive?
- [ ] **scroll** passive?

```javascript
// Check if passive listeners are used
// In DevTools Console:
getEventListeners(window).scroll
// Look for 'passive: true'
```

### 5.3 Scroll-Linked Effects

```css
/* GOOD: CSS-based scroll effects */
.parallax {
  background-attachment: fixed;
}

/* Or use CSS scroll-driven animations (modern browsers) */
@keyframes reveal {
  from { opacity: 0; }
  to { opacity: 1; }
}

.reveal {
  animation: reveal linear;
  animation-timeline: view();
}
```

### 5.4 Virtual Scrolling

For lists > 100 items:

| Library | Bundle Size | Features |
|---------|-------------|----------|
| react-window | 6KB | Basic virtualization |
| react-virtualized | 28KB | Full featured |
| @tanstack/virtual | 12KB | Framework agnostic |

---

## 6. Animation Performance

### 6.1 Animation Audit

For EVERY animation:

| Animation | Trigger | Properties | Duration | FPS | Status |
|-----------|---------|------------|----------|-----|--------|
| Menu open | click | transform | 300ms | 60 | OK |
| Fade in | scroll | opacity | 200ms | 60 | OK |
| Slide | hover | left | 200ms | 45 | JANKY |

### 6.2 CSS vs JavaScript Animations

Prefer CSS for simple animations:

```css
/* GOOD: CSS animation */
.fade-in {
  animation: fadeIn 300ms ease-out;
}

@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}
```

Use JavaScript for:
- Complex sequenced animations
- Physics-based animations
- Animations that need to respond to user input

### 6.3 Animation Frame Timing

```javascript
// GOOD: Use requestAnimationFrame
function animate() {
  updatePosition();
  requestAnimationFrame(animate);
}

// BAD: Use setInterval for animation
setInterval(updatePosition, 16); // Inconsistent timing
```

### 6.4 Animation Libraries

| Library | Use Case | Performance |
|---------|----------|-------------|
| CSS animations | Simple transitions | Best |
| Web Animations API | Moderate complexity | Good |
| GSAP | Complex sequences | Good |
| Framer Motion | React animations | Good |
| Lottie | After Effects exports | Varies |

---

## 7. Interaction Performance

### 7.1 Input Latency

| Interaction | Current | Target |
|-------------|---------|--------|
| Click to response | Xms | < 100ms |
| Typing to display | Xms | < 50ms |
| Scroll to paint | Xms | < 16ms |

### 7.2 Interaction to Next Paint (INP)

Measure INP for all interactions:

- [ ] **Click/tap INP** < 200ms?
- [ ] **Keyboard INP** < 200ms?
- [ ] **Hover INP** (if applicable)?

### 7.3 Debouncing & Throttling

| Event Type | Strategy | Delay |
|------------|----------|-------|
| Typing (search) | Debounce | 300ms |
| Scroll | Throttle/rAF | 16ms |
| Resize | Debounce | 200ms |
| Button click | None (but disable after) | - |

---

## 8. Web Workers

### 8.1 Offloadable Tasks

Tasks that should use Web Workers:
- [ ] Large data processing
- [ ] Complex calculations
- [ ] Image manipulation
- [ ] Parsing large JSON
- [ ] Sorting large arrays
- [ ] Encryption/decryption

### 8.2 Worker Implementation

```javascript
// main.js
const worker = new Worker('worker.js');
worker.postMessage({ type: 'SORT', data: largeArray });
worker.onmessage = (e) => {
  const sortedArray = e.data;
};

// worker.js
self.onmessage = (e) => {
  if (e.data.type === 'SORT') {
    const sorted = e.data.data.sort((a, b) => a - b);
    self.postMessage(sorted);
  }
};
```

### 8.3 Transferable Objects

For large data, use transferable objects to avoid copying:

```javascript
const buffer = new ArrayBuffer(1024 * 1024);
worker.postMessage(buffer, [buffer]); // Transfer, don't copy
```

---

## 9. React/Vue/Angular Specific

### 9.1 React Performance

**Re-render Analysis:**
- [ ] **React DevTools Profiler** used?
- [ ] **Unnecessary re-renders** identified?
- [ ] **Component update reasons** analyzed?

**Optimization patterns:**
```jsx
// Memoize expensive components
const MemoizedList = React.memo(List);

// Memoize expensive calculations
const sortedItems = useMemo(() =>
  items.sort((a, b) => a.name.localeCompare(b.name)),
  [items]
);

// Stable callbacks
const handleClick = useCallback((id) => {
  setSelected(id);
}, []);
```

### 9.2 Vue Performance

- [ ] **v-once** for static content?
- [ ] **v-memo** for expensive list items?
- [ ] **Computed properties** instead of methods?
- [ ] **shallowRef/shallowReactive** where appropriate?

### 9.3 Angular Performance

- [ ] **OnPush change detection**?
- [ ] **trackBy** for ngFor?
- [ ] **Pure pipes**?
- [ ] **Lazy loaded modules**?

---

## 10. Profiling Workflow

### 10.1 Performance Recording Checklist

Before recording:
- [ ] **Incognito mode** (no extensions)
- [ ] **Slow CPU** (4x slowdown)
- [ ] **Disable cache**
- [ ] **Clear previous recordings**

During recording:
- [ ] **Record specific interaction**
- [ ] **Keep recording short** (5-10 seconds)
- [ ] **Capture user journey**

### 10.2 What to Look For

In Performance panel:
1. **Red bars** = dropped frames
2. **Long tasks** = yellow/orange bars > 50ms
3. **Layout shifts** = blue "Layout" boxes
4. **Forced reflows** = purple "Recalculate Style" after script
5. **Memory growth** = JS Heap trend line

### 10.3 Flame Chart Analysis

- **Wide bars** = slow operations (optimize)
- **Deep stacks** = many function calls (simplify)
- **Repeated patterns** = loops or re-renders (batch/memoize)

---

## 11. Real User Monitoring (RUM)

### 11.1 Metrics to Collect

```javascript
// Collect INP
new PerformanceObserver((list) => {
  for (const entry of list.getEntries()) {
    console.log('INP candidate:', entry.duration);
  }
}).observe({ type: 'event', buffered: true });

// Collect Long Tasks
new PerformanceObserver((list) => {
  for (const entry of list.getEntries()) {
    console.log('Long Task:', entry.duration);
  }
}).observe({ type: 'longtask', buffered: true });

// Collect Layout Shifts
new PerformanceObserver((list) => {
  for (const entry of list.getEntries()) {
    console.log('Layout Shift:', entry.value);
  }
}).observe({ type: 'layout-shift', buffered: true });
```

### 11.2 Percentile Tracking

Track p75 and p95, not just averages:

| Metric | p50 | p75 | p95 | p99 |
|--------|-----|-----|-----|-----|
| INP | Xms | Xms | Xms | Xms |
| LCP | Xs | Xs | Xs | Xs |
| Long Tasks/page | X | X | X | X |

---

## Quick Wins Checklist

- [ ] Add `{ passive: true }` to scroll/touch listeners
- [ ] Use `transform` instead of `top/left` for animations
- [ ] Add cleanup functions to all useEffect hooks
- [ ] Implement virtual scrolling for lists > 100 items
- [ ] Debounce search/filter inputs (300ms)
- [ ] Throttle scroll handlers with rAF
- [ ] Memoize expensive React components
- [ ] Move heavy computation to Web Workers
- [ ] Add `will-change` sparingly for known animations
- [ ] Use CSS animations over JavaScript where possible
