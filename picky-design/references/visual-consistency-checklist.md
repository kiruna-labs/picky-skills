# Visual Consistency Audit Checklist

## Audit Philosophy

**Leave no stone unturned.** Every pixel matters. Inconsistency is entropy - it accumulates silently and degrades user trust. Your job is to find EVERY deviation from the established patterns, no matter how small.

---

## 1. Typography Audit

### 1.1 Font Family Consistency
- [ ] **Primary font** - Same family used across all body text
- [ ] **Heading font** - Consistent family for all h1-h6 elements
- [ ] **Monospace font** - Code blocks, technical content use same mono font
- [ ] **Fallback stacks** - All font-family declarations have proper fallbacks
- [ ] **Font loading** - No FOUT/FOIT issues, fonts load consistently
- [ ] **Variable fonts** - If used, weight ranges are consistent
- [ ] **No rogue fonts** - Search for ANY font-family declaration that doesn't match system

```bash
# Find ALL font-family declarations
grep -rn "font-family\|fontFamily" --include="*.css" --include="*.scss" --include="*.tsx" --include="*.jsx" --include="*.ts"

# Find inline font styles
grep -rn "style=.*font" --include="*.tsx" --include="*.jsx" --include="*.html"
```

### 1.2 Font Size Scale
- [ ] **Type scale documented** - Is there a defined scale? (e.g., 12, 14, 16, 18, 20, 24, 30, 36, 48, 60, 72)
- [ ] **Scale adherence** - ALL text sizes match the scale, no arbitrary values
- [ ] **Responsive scaling** - Sizes adjust appropriately at breakpoints
- [ ] **Minimum size** - No text smaller than 12px (14px preferred for body)
- [ ] **Line height ratios** - Consistent line-height to font-size ratios
- [ ] **No magic numbers** - Every size traces back to a token/variable

```bash
# Find hardcoded font sizes
grep -rn "font-size:\s*[0-9]" --include="*.css" --include="*.scss"
grep -rn "fontSize:\s*['\"]?[0-9]" --include="*.tsx" --include="*.jsx" --include="*.ts"
grep -rn "text-\[" --include="*.tsx" --include="*.jsx"  # Tailwind arbitrary

# Find all unique font sizes in use
grep -rohn "font-size:\s*[0-9]*px\|fontSize:\s*[0-9]*" --include="*.css" --include="*.tsx" | sort | uniq -c | sort -rn
```

### 1.3 Font Weight Consistency
- [ ] **Weight scale defined** - Clear weights: 400 (regular), 500 (medium), 600 (semibold), 700 (bold)
- [ ] **Semantic usage** - Weights used consistently for emphasis levels
- [ ] **No numeric drift** - Don't mix 600 and 700 for "bold" randomly
- [ ] **Variable font weights** - If using variable fonts, weights snap to defined stops

```bash
# Find all font-weight declarations
grep -rn "font-weight\|fontWeight" --include="*.css" --include="*.scss" --include="*.tsx" --include="*.jsx"
```

### 1.4 Letter Spacing & Text Transform
- [ ] **Letter spacing patterns** - Headings, uppercase text, body have consistent tracking
- [ ] **Uppercase consistency** - All-caps text always has increased letter-spacing
- [ ] **No random tracking** - Every letter-spacing value is intentional

### 1.5 Line Height Consistency
- [ ] **Body text** - Consistent line-height (typically 1.5-1.7)
- [ ] **Headings** - Tighter line-height (typically 1.1-1.3)
- [ ] **UI text** - Single-line elements use line-height: 1 or match height
- [ ] **Unitless values** - Prefer unitless line-heights for scalability

---

## 2. Color System Audit

### 2.1 Color Palette Verification
- [ ] **Primary colors** - Defined and used consistently
- [ ] **Secondary colors** - Supporting palette documented
- [ ] **Neutral scale** - Gray scale with clear steps (50, 100, 200... 900)
- [ ] **Semantic colors** - Success, warning, error, info defined
- [ ] **Brand colors** - Logo colors match usage in UI

```bash
# Find ALL color declarations
grep -rn "#[0-9a-fA-F]\{3,8\}" --include="*.css" --include="*.scss" --include="*.tsx" --include="*.jsx" --include="*.ts"
grep -rn "rgb\(a\?\)\s*(" --include="*.css" --include="*.scss" --include="*.tsx" --include="*.jsx"
grep -rn "hsl\(a\?\)\s*(" --include="*.css" --include="*.scss" --include="*.tsx" --include="*.jsx"

# Tailwind arbitrary colors
grep -rn "\[#[0-9a-fA-F]" --include="*.tsx" --include="*.jsx"

# Count unique colors
grep -rohn "#[0-9a-fA-F]\{6\}" --include="*.css" --include="*.tsx" --include="*.jsx" | sort | uniq -c | sort -rn | head -30
```

### 2.2 Color Token Usage
- [ ] **No hardcoded colors** - ALL colors reference tokens/variables
- [ ] **Consistent naming** - color-primary vs primary-color - pick one
- [ ] **Dark mode tokens** - If dark mode exists, all colors have dark variants
- [ ] **Opacity consistency** - Same color at different opacities use consistent base

### 2.3 Text Color Hierarchy
- [ ] **Primary text** - Main content color defined and used
- [ ] **Secondary text** - Muted/subtle text has consistent color
- [ ] **Tertiary text** - Disabled/placeholder text consistent
- [ ] **Link colors** - Default, hover, visited, active states defined
- [ ] **Inverse text** - Light text on dark backgrounds uses correct tokens

### 2.4 Background Colors
- [ ] **Page background** - Consistent base background
- [ ] **Card backgrounds** - Elevated surfaces use consistent colors
- [ ] **Interactive backgrounds** - Hover/active states consistent
- [ ] **Selection colors** - Text selection highlighting consistent

### 2.5 Border Colors
- [ ] **Default borders** - Input, card, divider borders use same color
- [ ] **Focus borders** - Focus rings use consistent color (usually primary)
- [ ] **Error borders** - Validation error borders consistent
- [ ] **Subtle vs strong** - Border hierarchy is clear and consistent

---

## 3. Spacing System Audit

### 3.1 Spacing Scale
- [ ] **Scale defined** - Clear spacing scale (4, 8, 12, 16, 24, 32, 48, 64, 96)
- [ ] **Base unit** - Consistent base (4px or 8px grid)
- [ ] **No arbitrary values** - All spacing derives from scale
- [ ] **Negative space** - Margins use the same scale

```bash
# Find hardcoded spacing
grep -rn "margin:\s*[0-9]" --include="*.css" --include="*.scss"
grep -rn "padding:\s*[0-9]" --include="*.css" --include="*.scss"
grep -rn "gap:\s*[0-9]" --include="*.css" --include="*.scss"

# Tailwind arbitrary spacing
grep -rn "p-\[\|m-\[\|gap-\[\|space-\[" --include="*.tsx" --include="*.jsx"

# Find all margin/padding values
grep -rohn "margin:\s*[0-9]*px\|padding:\s*[0-9]*px" --include="*.css" | sort | uniq -c | sort -rn
```

### 3.2 Component Internal Spacing
- [ ] **Button padding** - All buttons use same padding formula
- [ ] **Input padding** - Form inputs have consistent internal spacing
- [ ] **Card padding** - Cards/panels use consistent content padding
- [ ] **List item spacing** - List items have consistent gaps
- [ ] **Icon spacing** - Icons have consistent margins from text

### 3.3 Component External Spacing
- [ ] **Section margins** - Page sections have consistent vertical rhythm
- [ ] **Form field gaps** - Form elements spaced consistently
- [ ] **Grid gaps** - Grid/flex containers use consistent gaps
- [ ] **Stack spacing** - Vertical stacks use consistent space-y values

### 3.4 Layout Spacing
- [ ] **Container padding** - Page containers have consistent horizontal padding
- [ ] **Responsive padding** - Container padding scales at breakpoints
- [ ] **Max-width consistency** - Content max-widths are consistent
- [ ] **Sidebar widths** - Navigation/sidebar widths consistent

---

## 4. Border & Radius Audit

### 4.1 Border Width
- [ ] **Scale defined** - Border widths: 1px, 2px (maybe 4px for emphasis)
- [ ] **Consistent defaults** - Default borders use same width
- [ ] **Focus rings** - Focus outlines use consistent width

### 4.2 Border Radius
- [ ] **Radius scale** - Defined scale: 0, 2, 4, 6, 8, 12, 16, full
- [ ] **Component consistency** - Similar components use same radius
- [ ] **Button radius** - All buttons share border-radius
- [ ] **Input radius** - All inputs share border-radius
- [ ] **Card radius** - All cards share border-radius
- [ ] **Nested radius** - Inner elements account for parent radius

```bash
# Find all border-radius values
grep -rn "border-radius\|borderRadius" --include="*.css" --include="*.scss" --include="*.tsx" --include="*.jsx"
grep -rn "rounded-\[" --include="*.tsx" --include="*.jsx"
```

### 4.3 Border Styles
- [ ] **Solid default** - Most borders use solid (not dashed/dotted randomly)
- [ ] **Dashed usage** - Dashed borders used consistently (e.g., drop zones)
- [ ] **Dividers** - Horizontal/vertical dividers consistent

---

## 5. Shadow System Audit

### 5.1 Shadow Scale
- [ ] **Elevation levels** - Clear shadow scale for elevation (sm, md, lg, xl)
- [ ] **Consistent direction** - Shadows cast in same direction
- [ ] **Color consistency** - Shadow colors use consistent base

```bash
# Find all shadow declarations
grep -rn "box-shadow\|boxShadow" --include="*.css" --include="*.scss" --include="*.tsx" --include="*.jsx"
grep -rn "shadow-\[" --include="*.tsx" --include="*.jsx"
```

### 5.2 Shadow Usage
- [ ] **Cards** - All cards at same elevation share shadow
- [ ] **Modals** - Modals use consistent (larger) shadow
- [ ] **Dropdowns** - Dropdown menus use consistent shadow
- [ ] **Buttons** - If buttons have shadows, they're consistent
- [ ] **Focus shadows** - Focus ring shadows consistent (if used)

---

## 6. Icon System Audit

### 6.1 Icon Library Consistency
- [ ] **Single library** - Using one icon set (Lucide, Heroicons, etc.)
- [ ] **No mixed libraries** - Don't mix Lucide with FontAwesome randomly
- [ ] **Custom icons match** - Custom icons follow library's style

```bash
# Find icon imports
grep -rn "from.*icon\|Icon\|SVG" --include="*.tsx" --include="*.jsx"
grep -rn "lucide\|heroicon\|fontawesome\|feather" --include="*.tsx" --include="*.jsx" --include="*.ts"
```

### 6.2 Icon Sizing
- [ ] **Size scale** - Icons use consistent sizes: 16, 20, 24, 32, 40, 48
- [ ] **Contextual sizing** - Icons in buttons match text size appropriately
- [ ] **Stroke width** - If using stroke icons, weight is consistent

### 6.3 Icon-Text Alignment
- [ ] **Vertical alignment** - Icons align with text baseline/center consistently
- [ ] **Spacing from text** - Consistent gap between icon and label
- [ ] **Icon-only buttons** - Consistent sizing and padding

---

## 7. Animation & Transition Audit

### 7.1 Timing Functions
- [ ] **Easing defined** - Standard easings: ease-out for enter, ease-in for exit
- [ ] **Consistent curves** - Same easing used for similar animations
- [ ] **No linear** - Linear timing avoided for UI (except progress bars)

### 7.2 Duration Scale
- [ ] **Duration scale** - Defined: 75ms, 100ms, 150ms, 200ms, 300ms, 500ms
- [ ] **Micro-interactions** - Small changes: 100-150ms
- [ ] **Page transitions** - Larger changes: 200-300ms
- [ ] **No jarring** - Nothing too fast (<50ms) or too slow (>500ms)

```bash
# Find all transitions/animations
grep -rn "transition\|animation" --include="*.css" --include="*.scss" --include="*.tsx" --include="*.jsx"
```

### 7.3 Motion Consistency
- [ ] **Hover transitions** - All hover states animate consistently
- [ ] **Focus transitions** - Focus states animate or snap consistently
- [ ] **Modal animations** - Modals open/close with consistent animation
- [ ] **Reduced motion** - Respects prefers-reduced-motion

---

## 8. Image & Media Audit

### 8.1 Aspect Ratios
- [ ] **Consistent ratios** - Similar content uses same aspect ratios
- [ ] **Thumbnails** - Thumbnail images are consistent sizes
- [ ] **Avatars** - User avatars are consistent (circle, same size)

### 8.2 Image Treatment
- [ ] **Placeholder style** - Loading placeholders are consistent
- [ ] **Error states** - Broken image fallbacks are consistent
- [ ] **Border radius** - Image corners match container radius

### 8.3 Avatar System
- [ ] **Size scale** - Avatar sizes: xs (24), sm (32), md (40), lg (48), xl (64)
- [ ] **Fallback style** - Initials/default avatar consistent
- [ ] **Status indicators** - Online/offline dots positioned consistently

---

## 9. Data Display Consistency

### 9.1 Tables
- [ ] **Header styling** - Table headers use consistent weight/color
- [ ] **Row height** - Consistent row padding/height
- [ ] **Zebra striping** - If used, consistent across all tables
- [ ] **Border style** - Table borders consistent
- [ ] **Alignment** - Text left, numbers right - consistently

### 9.2 Lists
- [ ] **Bullet style** - Unordered list bullets consistent
- [ ] **Number style** - Ordered list numbers consistent
- [ ] **Nesting** - Nested list indentation consistent
- [ ] **Spacing** - Item spacing consistent

### 9.3 Data Formatting
- [ ] **Number format** - Thousands separators used consistently
- [ ] **Date format** - Dates formatted consistently throughout
- [ ] **Currency format** - Money displays consistently
- [ ] **Empty states** - "No data" displays consistently

---

## 10. Z-Index Architecture

### 10.1 Z-Index Scale
- [ ] **Scale defined** - Clear z-index levels: 10, 20, 30, 40, 50, 100, 999, 9999
- [ ] **Semantic naming** - z-dropdown, z-modal, z-tooltip named
- [ ] **No random values** - No arbitrary z-index: 12345

```bash
# Find all z-index values
grep -rn "z-index\|zIndex" --include="*.css" --include="*.scss" --include="*.tsx" --include="*.jsx"
```

### 10.2 Stacking Contexts
- [ ] **Modals on top** - Modals above everything except toasts
- [ ] **Dropdowns** - Dropdowns above page content
- [ ] **Tooltips** - Tooltips above most UI
- [ ] **Toasts** - Notifications at highest level

---

## Visual Inspection Tasks (Chrome DevTools MCP)

1. **Open every unique page/route** - Screenshot each one
2. **Toggle all interactive states** - Hover, focus, active, disabled
3. **Open all modals/dialogs** - Check for consistency
4. **Expand all dropdowns** - Compare styling
5. **Fill all form states** - Valid, invalid, disabled
6. **Check loading states** - Skeleton screens, spinners
7. **Check empty states** - "No results" displays
8. **Check error states** - Error messages, boundaries
9. **Resize at every breakpoint** - Not just 3, but continuous resize
10. **Test with long content** - Overflow, truncation handling
11. **Test with minimal content** - Layout doesn't break
12. **Check with browser zoom** - 90%, 110%, 125%, 150%
