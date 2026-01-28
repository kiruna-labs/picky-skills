# Responsive Design Audit Checklist

## Audit Philosophy

**Test at EVERY pixel, not just breakpoints.** Responsive bugs love to hide at 834px, 1100px, or any width you didn't specifically check. Drag that browser edge continuously. Your job is to find EVERY layout break, overflow, and collapse point.

---

## 1. Breakpoint System Audit

### 1.1 Breakpoint Definition
- [ ] **Breakpoints documented** - Clear breakpoint values defined
- [ ] **Consistent breakpoints** - Same values used throughout
- [ ] **Mobile-first or desktop-first** - One approach, consistently
- [ ] **Common breakpoints present** - sm, md, lg, xl, 2xl or equivalent

Standard breakpoints to verify:
- 320px - Small mobile (iPhone SE)
- 375px - Standard mobile (iPhone)
- 414px - Large mobile (iPhone Plus)
- 768px - Tablet portrait
- 1024px - Tablet landscape / small laptop
- 1280px - Laptop
- 1440px - Desktop
- 1920px - Large desktop
- 2560px+ - Ultra-wide

```bash
# Find breakpoint definitions
grep -rn "@media\|breakpoint\|screen\s*and" --include="*.css" --include="*.scss" --include="*.ts" --include="*.tsx"

# Find Tailwind breakpoint usage
grep -rn "sm:\|md:\|lg:\|xl:\|2xl:" --include="*.tsx" --include="*.jsx"
```

### 1.2 Breakpoint Consistency
- [ ] **No magic numbers** - No random @media (min-width: 847px)
- [ ] **Overlapping queries checked** - No gaps in coverage
- [ ] **Print styles** - @media print considered

---

## 2. Layout Audit

### 2.1 Container Behavior
- [ ] **Max-width set** - Content doesn't stretch infinitely
- [ ] **Centered properly** - Container centers at large screens
- [ ] **Padding scales** - Container padding increases with screen
- [ ] **No horizontal overflow** - At any width, no x-scroll

```bash
# Find container definitions
grep -rn "max-width\|container\|mx-auto" --include="*.css" --include="*.tsx"
```

### 2.2 Grid Behavior
- [ ] **Columns reduce** - 4 → 2 → 1 as screen shrinks
- [ ] **Gap scales** - Grid gaps reduce on mobile
- [ ] **No orphan columns** - Grid doesn't leave single items awkwardly
- [ ] **Grid auto-flow sensible** - Items wrap logically

```bash
# Find grid usage
grep -rn "grid-cols\|grid-template\|display:\s*grid" --include="*.css" --include="*.tsx"
```

### 2.3 Flexbox Behavior
- [ ] **Wrap enabled** - flex-wrap: wrap where needed
- [ ] **Direction changes** - row → column on mobile where needed
- [ ] **Grow/shrink sensible** - Items don't squish or stretch oddly
- [ ] **Alignment consistent** - Items align properly at all sizes

### 2.4 Sidebar Behavior
- [ ] **Sidebar collapses** - Hidden or drawer on mobile
- [ ] **Toggle accessible** - Hamburger menu or equivalent
- [ ] **Width sensible** - Fixed or percentage that works
- [ ] **Overlay behavior** - Sidebar doesn't push content off-screen

### 2.5 Header/Footer Behavior
- [ ] **Header responsive** - Nav items collapse to hamburger
- [ ] **Logo scales** - Doesn't break layout
- [ ] **Footer stacks** - Multi-column → single column
- [ ] **Sticky behavior** - If sticky, still works on small screens

---

## 3. Typography Responsiveness

### 3.1 Font Size Scaling
- [ ] **Body text readable** - 16px+ on mobile
- [ ] **Headings scale** - Smaller on mobile, proportionally
- [ ] **Line length** - 45-75 characters per line
- [ ] **Line height adjusts** - May need tighter on large headings

```bash
# Find responsive typography
grep -rn "clamp\|vw\|vh\|@media.*font" --include="*.css" --include="*.tsx"
```

### 3.2 Text Overflow
- [ ] **Truncation works** - text-overflow: ellipsis functional
- [ ] **No text cutoff** - Text never clips unexpectedly
- [ ] **Word break** - Long words don't cause overflow
- [ ] **Hyphenation** - If used, works cross-browser

### 3.3 Responsive Typography Scale
- [ ] **H1 scales** - Maybe 48px desktop → 32px mobile
- [ ] **H2 scales** - Proportionally smaller
- [ ] **Maintains hierarchy** - H1 > H2 > H3 at all sizes
- [ ] **Spacing scales** - Margins around text scale

---

## 4. Image & Media Responsiveness

### 4.1 Image Sizing
- [ ] **max-width: 100%** - Images don't overflow
- [ ] **Height: auto** - Maintains aspect ratio
- [ ] **object-fit used** - cover/contain where needed
- [ ] **Aspect ratio preserved** - Images don't distort

```bash
# Find image styling
grep -rn "<img\|object-fit\|aspect-ratio" --include="*.tsx" --include="*.jsx" --include="*.css"
```

### 4.2 Responsive Images
- [ ] **srcset provided** - Multiple resolutions
- [ ] **sizes attribute** - Correct sizes for breakpoints
- [ ] **Art direction** - picture element for different crops
- [ ] **Lazy loading** - loading="lazy" for below-fold

### 4.3 Video Responsiveness
- [ ] **Aspect ratio container** - 16:9 or appropriate
- [ ] **Max-width constraint** - Doesn't overflow
- [ ] **Controls accessible** - Touch-friendly on mobile

### 4.4 Background Images
- [ ] **Multiple resolutions** - Different images for different screens
- [ ] **Position sensible** - Focal point visible at all sizes
- [ ] **Size appropriate** - cover/contain used correctly

---

## 5. Navigation Responsiveness

### 5.1 Desktop Navigation
- [ ] **All items visible** - No overflow
- [ ] **Dropdowns work** - Hover/focus triggers
- [ ] **Active states clear** - Current page indicated

### 5.2 Mobile Navigation
- [ ] **Hamburger trigger** - Clear, accessible button
- [ ] **Menu slides/fades** - Smooth animation
- [ ] **Full items visible** - No scroll needed if possible
- [ ] **Close button clear** - Easy to dismiss
- [ ] **Overlay/backdrop** - Clear visual separation
- [ ] **Nested menus work** - Submenus accessible

### 5.3 Navigation Transition
- [ ] **Breakpoint appropriate** - Nav changes at right size
- [ ] **No FOUC** - Flash of unstyled content
- [ ] **No double nav** - Both desktop and mobile visible

### 5.4 Tab Navigation
- [ ] **Tabs scroll or wrap** - Handle many tabs
- [ ] **Active tab visible** - Scrolls into view
- [ ] **Touch-friendly** - Large enough targets

---

## 6. Form Responsiveness

### 6.1 Form Layout
- [ ] **Full-width on mobile** - Inputs stretch to edges
- [ ] **Stacked on mobile** - Horizontal forms stack
- [ ] **Labels visible** - Not cut off
- [ ] **Submit button accessible** - Not hidden below fold

### 6.2 Input Sizing
- [ ] **Minimum 16px font** - Prevents iOS zoom
- [ ] **Touch targets 44px** - Large enough to tap
- [ ] **Adequate spacing** - Don't tap wrong field

### 6.3 Input Types
- [ ] **Correct keyboards** - type="email" shows @ keyboard
- [ ] **inputmode set** - Numeric keyboard for numbers
- [ ] **Autocomplete works** - Fill from saved data

### 6.4 Multi-column Forms
- [ ] **Stack on mobile** - Side-by-side → stacked
- [ ] **Logical order** - Tab order makes sense
- [ ] **Error messages fit** - Don't overflow

---

## 7. Table Responsiveness

### 7.1 Responsive Strategies
Check which strategy is used and if it works:

- [ ] **Horizontal scroll** - Container scrolls, indicator visible
- [ ] **Collapse to cards** - Rows become cards on mobile
- [ ] **Hide columns** - Less important columns hidden
- [ ] **Reorder columns** - Most important first

```bash
# Find table responsive handling
grep -rn "overflow-x\|table-responsive\|@media.*table" --include="*.css" --include="*.tsx"
```

### 7.2 Table Usability
- [ ] **Headers stay visible** - Sticky headers if scrolling
- [ ] **Data readable** - Font size adequate
- [ ] **Actions accessible** - Buttons/links tappable
- [ ] **Pagination works** - Works on mobile

---

## 8. Modal/Dialog Responsiveness

### 8.1 Modal Sizing
- [ ] **Max-width at desktop** - Doesn't stretch too wide
- [ ] **Near full-screen mobile** - Uses available space
- [ ] **Margins present** - Not edge-to-edge
- [ ] **Max-height with scroll** - Content scrolls if needed

### 8.2 Modal Interaction
- [ ] **Close button reachable** - Not off-screen
- [ ] **Content readable** - All content accessible
- [ ] **Actions tappable** - Buttons large enough
- [ ] **Keyboard still works** - Not just touch

### 8.3 Bottom Sheet Pattern
- [ ] **Sheet works on mobile** - If used, functions properly
- [ ] **Drag to dismiss** - If implemented, works
- [ ] **Transitions smooth** - No janky animations

---

## 9. Card Responsiveness

### 9.1 Card Sizing
- [ ] **Flexible width** - Cards adapt to container
- [ ] **Min/max width** - Constraints prevent extremes
- [ ] **Content overflow** - Long content handled

### 9.2 Card Grids
- [ ] **Columns reduce** - 4 → 3 → 2 → 1
- [ ] **Equal heights** - Cards in row match (or don't need to)
- [ ] **Gap consistency** - Gaps scale appropriately
- [ ] **Last row handling** - Orphan cards handled

### 9.3 Card Content
- [ ] **Image ratio consistent** - Thumbnails same ratio
- [ ] **Text truncation** - Long titles truncate
- [ ] **Actions fit** - Buttons don't overflow

---

## 10. Touch-Specific Issues

### 10.1 Touch Targets
- [ ] **44x44px minimum** - Apple HIG recommendation
- [ ] **48x48px preferred** - Material Design recommendation
- [ ] **Spacing between targets** - At least 8px gap
- [ ] **No tiny close buttons** - Modal X buttons large enough

### 10.2 Touch Interactions
- [ ] **No hover-only content** - All info accessible without hover
- [ ] **Touch feedback** - Active states for touch
- [ ] **No double-tap zoom** - Viewport properly configured
- [ ] **Swipe where expected** - Carousels, dismissals

### 10.3 Touch Scroll
- [ ] **Scrollable areas obvious** - Visual scroll indicators
- [ ] **Nested scroll works** - Modal scroll doesn't fight page
- [ ] **Pull-to-refresh** - If used, doesn't fight content
- [ ] **Scroll snap smooth** - If used, feels natural

---

## 11. Performance at Different Sizes

### 11.1 Image Loading
- [ ] **Mobile gets smaller images** - Not downloading 4K on phone
- [ ] **Lazy loading works** - Images load on scroll
- [ ] **Placeholder loading** - Blur-up or skeleton

### 11.2 Code Splitting
- [ ] **Mobile-specific code** - Not loading desktop components
- [ ] **Conditional features** - Heavy features loaded conditionally

### 11.3 Animation Performance
- [ ] **60fps on mobile** - Animations smooth
- [ ] **No jank on scroll** - Smooth scrolling
- [ ] **Transform-based** - Not animating layout properties

---

## 12. Testing Protocol

### Required Test Widths
Test at EACH of these widths by dragging browser continuously:

| Width | Device Approximation |
|-------|---------------------|
| 320px | iPhone SE, small Android |
| 360px | Common Android |
| 375px | iPhone X/11/12/13/14 |
| 390px | iPhone 14 Pro |
| 414px | iPhone Plus models |
| 428px | iPhone 14 Pro Max |
| 768px | iPad portrait |
| 810px | iPad 10th gen portrait |
| 834px | iPad Pro 11" portrait |
| 1024px | iPad landscape |
| 1112px | iPad Pro 11" landscape |
| 1280px | Laptop |
| 1366px | Common laptop |
| 1440px | MacBook Pro 15" |
| 1536px | Surface Laptop |
| 1920px | Full HD desktop |
| 2560px | QHD/WQHD |

### Continuous Resize Test
1. Start at 320px
2. Slowly drag to 2560px
3. Note EVERY layout shift, break, overflow
4. Repeat process going back down

### Device Testing (Chrome DevTools)
- [ ] iPhone SE
- [ ] iPhone 14 Pro
- [ ] iPhone 14 Pro Max
- [ ] Pixel 7
- [ ] Samsung Galaxy S21
- [ ] iPad Mini
- [ ] iPad
- [ ] iPad Pro

### Orientation Testing
- [ ] Portrait → Landscape transition
- [ ] Content reflows correctly
- [ ] No content lost on rotation

### Real Device Testing
- [ ] Actual iPhone
- [ ] Actual Android
- [ ] Actual iPad/tablet
- [ ] Check with thumb reachability

---

## Common Responsive Bugs to Hunt

1. **Overflow-x on body** - Hidden somewhere causing scroll
2. **Fixed-width elements** - Something with width: 500px
3. **Absolute positioning** - Element positioned off-screen
4. **Unscaled images** - Image without max-width
5. **Hidden content** - Overflow: hidden cutting content
6. **Z-index on mobile** - Stacking context issues
7. **Viewport units** - 100vh issues on mobile (browser chrome)
8. **Position: sticky** - Not working on iOS Safari
9. **Flexbox bugs** - min-width: 0 needed for truncation
10. **Grid overflow** - fr units causing overflow

```bash
# Find fixed widths
grep -rn "width:\s*[0-9]*px\|w-\[[0-9]" --include="*.css" --include="*.tsx"

# Find overflow hidden (potential content hiding)
grep -rn "overflow:\s*hidden\|overflow-hidden" --include="*.css" --include="*.tsx"

# Find absolute/fixed positioning
grep -rn "position:\s*absolute\|position:\s*fixed\|absolute\|fixed" --include="*.css" --include="*.tsx"

# Find 100vh usage (problematic on mobile)
grep -rn "100vh\|h-screen" --include="*.css" --include="*.tsx"
```

---

## Screenshot Checklist

Take screenshots at these sizes for documentation:

1. **375px** - Mobile baseline
2. **768px** - Tablet baseline
3. **1280px** - Desktop baseline
4. **1920px** - Large desktop

For each page/component:
- Default state
- With content variations (short, long, empty)
- Interactive states where visible
- Error states
- Loading states
