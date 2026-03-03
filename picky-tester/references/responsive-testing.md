# Responsive Testing Checklist

## Testing Philosophy

**Users access apps on every device imaginable.** From tiny phones to massive monitors. In portrait and landscape. At various zoom levels. Your job is to test at every reasonable size and make sure nothing breaks, overflows, or becomes unusable.

---

## 1. Test Devices/Sizes

### 1.1 Mobile Sizes (Must Test)

```javascript
// Use: mcp__chrome-devtools__resize_page({ width: X, height: Y })

// Small phones
{ width: 320, height: 568 }  // iPhone SE / Small Android

// Standard phones
{ width: 375, height: 667 }  // iPhone 6/7/8
{ width: 375, height: 812 }  // iPhone X/11/12/13
{ width: 390, height: 844 }  // iPhone 14

// Large phones
{ width: 414, height: 896 }  // iPhone 8 Plus
{ width: 428, height: 926 }  // iPhone 14 Pro Max
```

### 1.2 Tablet Sizes (Must Test)

```javascript
// Portrait
{ width: 768, height: 1024 }  // iPad standard
{ width: 810, height: 1080 }  // iPad 10th gen
{ width: 834, height: 1194 }  // iPad Pro 11"

// Landscape
{ width: 1024, height: 768 }  // iPad standard landscape
{ width: 1194, height: 834 }  // iPad Pro 11" landscape
```

### 1.3 Desktop Sizes (Must Test)

```javascript
{ width: 1280, height: 800 }   // MacBook Air / Small laptop
{ width: 1366, height: 768 }   // Common laptop
{ width: 1440, height: 900 }   // MacBook Pro 15"
{ width: 1536, height: 864 }   // Surface Laptop
{ width: 1920, height: 1080 }  // Full HD monitor
{ width: 2560, height: 1440 }  // QHD monitor
```

### 1.4 Edge Cases

```javascript
{ width: 320, height: 480 }    // Minimum mobile
{ width: 480, height: 320 }    // Phone landscape
{ width: 3840, height: 2160 }  // 4K (if supported)
{ width: 500, height: 2000 }   // Very tall
{ width: 2000, height: 500 }   // Very wide
```

---

## 2. What to Check at Each Size

### 2.1 Layout Integrity

- [ ] **Content visible** - Nothing cut off
- [ ] **No horizontal scroll** - Page fits width
- [ ] **No overlapping** - Elements don't stack on each other
- [ ] **No orphans** - Elements not floating alone awkwardly
- [ ] **Proper stacking** - Columns become rows correctly
- [ ] **Padding consistent** - No cramped edges

### 2.2 Navigation

- [ ] **Nav accessible** - Can reach all navigation
- [ ] **Mobile menu works** - Hamburger menu functions
- [ ] **Desktop nav visible** - Not hamburger on desktop
- [ ] **Transition smooth** - Between mobile and desktop nav
- [ ] **Active states clear** - Know where you are

### 2.3 Typography

- [ ] **Text readable** - Not too small (14px+ on mobile)
- [ ] **Line length good** - Not too wide (45-75 chars ideal)
- [ ] **Headings scale** - Not too big/small for viewport
- [ ] **No text cutoff** - All text visible
- [ ] **No text overlap** - Text doesn't cover other text

### 2.4 Images

- [ ] **Images visible** - Not cut off
- [ ] **Aspect ratio correct** - Not distorted
- [ ] **Size appropriate** - Not too big/small
- [ ] **Load on viewport** - Lazy loading works

### 2.5 Interactive Elements

- [ ] **Buttons touchable** - Min 44x44px on mobile
- [ ] **Buttons not too close** - Can tap correct one
- [ ] **Forms usable** - Fields large enough
- [ ] **Dropdowns work** - Open in correct direction
- [ ] **Modals fit** - Not larger than screen

### 2.6 Content Priority

- [ ] **Important content first** - On mobile, key info visible
- [ ] **Nothing hidden unexpectedly** - Content still accessible
- [ ] **CTAs visible** - Key actions not buried

---

## 3. Continuous Resize Testing

The most thorough test:

### 3.1 Drag Test Process

1. Start at **320px** width
2. Slowly drag browser wider
3. Watch for:
   - Sudden layout jumps
   - Content appearing/disappearing
   - Elements moving unexpectedly
   - Gaps or overlaps
4. Continue to **1920px**
5. Reverse direction back to **320px**

### 3.2 What Breaks Between Breakpoints

Common breakpoint bugs:
- [ ] **Just above 768px** - Mobile nav still showing
- [ ] **Just below 1024px** - Desktop layout cramped
- [ ] **Random widths** - Like 647px, 1100px
- [ ] **At exactly breakpoint** - Off-by-one errors

---

## 4. Orientation Testing

### 4.1 Portrait to Landscape

On mobile sizes:
1. Set portrait dimensions (375x667)
2. Screenshot
3. Set landscape dimensions (667x375)
4. Screenshot
5. Compare:
   - [ ] Layout adapts appropriately
   - [ ] Content still accessible
   - [ ] No broken layout
   - [ ] Navigation works

### 4.2 Orientation-Specific Issues

- [ ] **Video players** - Fit correctly in landscape?
- [ ] **Modals** - Don't break on orientation change?
- [ ] **Forms** - Usable in both orientations?
- [ ] **Keyboards** - Room for content when keyboard open?

---

## 5. Touch Target Testing

### 5.1 Size Requirements

- **Minimum**: 44x44px (Apple HIG)
- **Better**: 48x48px (Material Design)
- **Spacing**: At least 8px between targets

### 5.2 Check All Touch Targets

- [ ] Buttons
- [ ] Links
- [ ] Navigation items
- [ ] Icons
- [ ] Checkboxes
- [ ] Radio buttons
- [ ] Form fields
- [ ] Close buttons (X)
- [ ] Menu items
- [ ] Tabs

### 5.3 Touch Target Audit

For each interactive element on mobile:
1. Take snapshot
2. Check element's bounding box
3. Is it at least 44x44?
4. Is there spacing from neighbors?

---

## 6. Content Overflow Testing

### 6.1 Horizontal Overflow

On mobile widths:
- [ ] **Full page** - No side scroll
- [ ] **Tables** - Scroll within container or responsive
- [ ] **Code blocks** - Scroll or wrap
- [ ] **Images** - Fit or scroll
- [ ] **Long URLs** - Break or truncate

### 6.2 Vertical Overflow

- [ ] **Fixed headers** - Content scrolls under
- [ ] **Fixed footers** - Content scrolls above
- [ ] **Modals** - Scroll if needed
- [ ] **Dropdowns** - Don't go off screen

### 6.3 Text Overflow

- [ ] **Long words** - Break or hyphenate
- [ ] **Long names** - Truncate with ellipsis
- [ ] **Long titles** - Handle gracefully
- [ ] **No layout break** - From unexpected length

---

## 7. Specific Component Testing

### 7.1 Navigation

At each size:
- [ ] All nav items accessible
- [ ] Dropdown menus work
- [ ] Breadcrumbs don't break
- [ ] Mobile menu transitions smoothly

### 7.2 Forms

At mobile sizes:
- [ ] Fields full width
- [ ] Labels visible
- [ ] Error messages visible
- [ ] Submit button reachable
- [ ] Keyboard doesn't obscure

### 7.3 Tables

At mobile sizes:
- [ ] Horizontal scroll works (if chosen)
- [ ] Or: responsive table layout works
- [ ] Or: hidden columns make sense
- [ ] Data still readable

### 7.4 Cards/Grids

At each size:
- [ ] Card grid adjusts (4 → 2 → 1 columns)
- [ ] Card content fits
- [ ] Cards equal height (if designed)
- [ ] Spacing consistent

### 7.5 Modals

At mobile sizes:
- [ ] Modal fits screen
- [ ] Close button accessible
- [ ] Content scrollable if needed
- [ ] Can dismiss modal

### 7.6 Images/Media

At each size:
- [ ] Images resize
- [ ] Aspect ratios preserved
- [ ] Art direction applied (if designed)
- [ ] Videos are responsive

---

## 8. Testing Checklist Per Page

For EVERY page, test at:
- [ ] 375px (mobile)
- [ ] 768px (tablet)
- [ ] 1280px (desktop)
- [ ] 1920px (wide)

At each size, verify:
- [ ] Page loads completely
- [ ] All content visible
- [ ] Navigation works
- [ ] Interactions work
- [ ] No horizontal scroll
- [ ] Touch targets adequate (mobile)

---

## 9. Common Responsive Bugs

### 9.1 Layout Bugs

| Bug | Symptoms | Common Cause |
|-----|----------|--------------|
| Horizontal scroll | Side-to-side scrollbar | Element with fixed width |
| Overlap | Elements on top of each other | Missing responsive rules |
| Gap | Empty space where content should be | Hidden element still has margin |
| Squish | Content cramped | Not enough breakpoints |
| Stretch | Content too wide | No max-width |

### 9.2 Content Bugs

| Bug | Symptoms | Common Cause |
|-----|----------|--------------|
| Text cutoff | Words clipped | Overflow hidden |
| Image stretch | Distorted images | Width without height auto |
| Menu hidden | Can't find nav | Hamburger broken |
| Form unusable | Can't see fields | Input not full width |

### 9.3 Interaction Bugs

| Bug | Symptoms | Common Cause |
|-----|----------|--------------|
| Can't tap | Touch target too small | Button not sized for mobile |
| Wrong tap | Hit wrong element | Targets too close |
| Hover stuck | Element stays hovered | Touch triggers hover |
| Modal trapped | Can't close modal | Close button off screen |

---

## 10. Documentation Template

### Responsive Testing Report

```markdown
## Page: [Page Name]

### Mobile (375px)
**Screenshot**: [screenshot]
- [ ] Layout: Pass/Fail
- [ ] Navigation: Pass/Fail
- [ ] Typography: Pass/Fail
- [ ] Touch targets: Pass/Fail
- [ ] Issues: [list any]

### Tablet (768px)
**Screenshot**: [screenshot]
- [ ] Layout: Pass/Fail
- [ ] Navigation: Pass/Fail
- [ ] Typography: Pass/Fail
- [ ] Issues: [list any]

### Desktop (1280px)
**Screenshot**: [screenshot]
- [ ] Layout: Pass/Fail
- [ ] Navigation: Pass/Fail
- [ ] Typography: Pass/Fail
- [ ] Issues: [list any]

### Wide (1920px)
**Screenshot**: [screenshot]
- [ ] Layout: Pass/Fail
- [ ] Max-width respected: Pass/Fail
- [ ] Issues: [list any]
```

---

## 11. Quick Responsive Audit

Fast check for each page:

1. **Mobile (375px)**
   - Screenshot
   - Check for horizontal scroll
   - Check hamburger menu works
   - Check one form (if exists)
   - Check one CTA

2. **Tablet (768px)**
   - Screenshot
   - Check navigation style
   - Check grid layout

3. **Desktop (1280px)**
   - Screenshot
   - Check full navigation
   - Check content width

4. **Wide (1920px)**
   - Screenshot
   - Check max-width
   - Check content doesn't stretch weirdly

Total time per page: ~5 minutes
