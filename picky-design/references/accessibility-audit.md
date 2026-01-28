# Accessibility Audit Checklist

## Audit Philosophy

**Accessibility is not optional.** Every barrier you miss excludes real people. Approach this audit as if your most important user relies on a screen reader, uses only a keyboard, has low vision, or experiences seizures from flashing content. Your job is to find EVERY accessibility failure.

---

## 1. Keyboard Navigation Audit

### 1.1 Focus Management
- [ ] **Tab order logical** - Focus moves in reading order
- [ ] **All interactive elements focusable** - Buttons, links, inputs, custom controls
- [ ] **No focus traps** - User can always tab out (except modals)
- [ ] **Modal focus trap** - Focus stays in modal when open
- [ ] **Focus returns** - After modal closes, focus returns to trigger
- [ ] **Skip links** - "Skip to main content" link available
- [ ] **No tabindex > 0** - Only use 0 or -1

```bash
# Find tabindex usage
grep -rn "tabindex\|tabIndex" --include="*.tsx" --include="*.jsx" --include="*.html"

# Find potential keyboard traps
grep -rn "onKeyDown\|onKeyPress\|onKeyUp" --include="*.tsx" --include="*.jsx"
```

### 1.2 Focus Visibility
- [ ] **Focus ring visible** - Clear indicator on all focusable elements
- [ ] **Focus ring high contrast** - Visible against all backgrounds
- [ ] **Focus ring not suppressed** - No outline: none without alternative
- [ ] **Custom focus styles match** - All custom focus indicators consistent
- [ ] **Focus-visible used** - Keyboard focus distinct from mouse click

```bash
# Find outline suppression
grep -rn "outline:\s*none\|outline:\s*0" --include="*.css" --include="*.scss"
grep -rn "focus:outline-none" --include="*.tsx" --include="*.jsx"

# Find focus styling
grep -rn ":focus\|:focus-visible\|:focus-within" --include="*.css" --include="*.scss"
```

### 1.3 Keyboard Operability
- [ ] **All actions keyboard accessible** - Click handlers have keyboard equivalents
- [ ] **Enter activates buttons** - Buttons respond to Enter
- [ ] **Space activates buttons** - Buttons respond to Space
- [ ] **Escape closes overlays** - Modals, dropdowns close with Escape
- [ ] **Arrow keys for menus** - Menus navigable with arrows
- [ ] **Arrow keys for tabs** - Tab panels switchable with arrows
- [ ] **Custom widgets keyboard complete** - Sliders, date pickers, etc.

```bash
# Find click handlers without keyboard support
grep -rn "onClick=" --include="*.tsx" --include="*.jsx" | grep -v "onKeyDown\|onKeyPress\|button\|Button\|<a\s"

# Find div/span with click (likely needs keyboard support)
grep -rn "<div.*onClick\|<span.*onClick" --include="*.tsx" --include="*.jsx"
```

### 1.4 Focus Order Issues
- [ ] **No random tabindex** - Avoid tabindex="5", tabindex="100"
- [ ] **Hidden content not focusable** - Can't tab to hidden elements
- [ ] **Visually hidden still focusable** - sr-only content reachable
- [ ] **Dynamic content focus** - Focus moves to new content when appropriate
- [ ] **Remove from tab order correctly** - Use tabindex="-1" not removal

---

## 2. Screen Reader Audit

### 2.1 Semantic HTML
- [ ] **Headings hierarchy** - h1 → h2 → h3, no skipping levels
- [ ] **Single h1** - Only one h1 per page
- [ ] **Landmarks used** - main, nav, header, footer, aside, section
- [ ] **Lists for lists** - ul/ol for list content
- [ ] **Tables for data** - Actual tables for tabular data
- [ ] **Buttons are buttons** - Not divs or spans with onClick
- [ ] **Links are links** - Not buttons styled as links
- [ ] **Article for articles** - Blog posts, cards in article tags

```bash
# Find heading levels
grep -rn "<h[1-6]\|<Heading" --include="*.tsx" --include="*.jsx" --include="*.html"

# Find landmark elements
grep -rn "<main\|<nav\|<header\|<footer\|<aside\|<section\|role=" --include="*.tsx" --include="*.jsx"

# Find divs/spans acting as buttons
grep -rn "<div.*onClick\|<span.*onClick" --include="*.tsx" --include="*.jsx"
```

### 2.2 ARIA Usage
- [ ] **ARIA only when needed** - Native HTML first
- [ ] **ARIA roles correct** - button, link, dialog, etc.
- [ ] **ARIA states updated** - aria-expanded, aria-selected, aria-checked
- [ ] **ARIA labels present** - aria-label for icon buttons
- [ ] **aria-labelledby valid** - References existing IDs
- [ ] **aria-describedby valid** - References existing IDs
- [ ] **aria-hidden used correctly** - Decorative elements only
- [ ] **No redundant ARIA** - Don't add role="button" to button

```bash
# Find all ARIA usage
grep -rn "aria-\|role=" --include="*.tsx" --include="*.jsx" --include="*.html"

# Find potential missing ARIA
grep -rn "Icon\|<svg" --include="*.tsx" --include="*.jsx" | grep -v "aria-\|sr-only\|role=\|alt="
```

### 2.3 Text Alternatives
- [ ] **All images have alt** - Every img has alt attribute
- [ ] **Alt text meaningful** - Describes image content/purpose
- [ ] **Decorative images alt=""** - Empty alt for decorative
- [ ] **Icon buttons labeled** - aria-label for icon-only buttons
- [ ] **SVG accessible** - title/desc or aria-label
- [ ] **Charts accessible** - Described or data table alternative
- [ ] **Videos captioned** - Captions for all video content
- [ ] **Audio transcribed** - Transcripts for audio content

```bash
# Find images without alt
grep -rn "<img" --include="*.tsx" --include="*.jsx" | grep -v "alt="

# Find SVGs without labels
grep -rn "<svg" --include="*.tsx" --include="*.jsx" | grep -v "aria-\|title\|role=\|<title"

# Find Icon components without labels
grep -rn "Icon\s*\/>" --include="*.tsx" --include="*.jsx" | grep -v "aria-label"
```

### 2.4 Form Accessibility
- [ ] **All inputs labeled** - label, aria-label, or aria-labelledby
- [ ] **Labels linked correctly** - htmlFor matches input id
- [ ] **Required fields indicated** - aria-required or required
- [ ] **Error messages announced** - aria-describedby or live region
- [ ] **Error prevention** - Confirmation for destructive actions
- [ ] **Autocomplete attributes** - For personal info fields

```bash
# Find inputs that might lack labels
grep -rn "<input\|<select\|<textarea" --include="*.tsx" --include="*.jsx" -A 2 | grep -v "aria-label\|id=\|name="

# Find form elements
grep -rn "<form\|<Form" --include="*.tsx" --include="*.jsx"
```

### 2.5 Live Regions
- [ ] **Toast announcements** - Toasts use aria-live
- [ ] **Dynamic content announced** - Updates reach screen readers
- [ ] **Loading states announced** - "Loading..." announced
- [ ] **Error alerts** - role="alert" for errors
- [ ] **Status updates** - aria-live="polite" for non-urgent
- [ ] **No excessive announcements** - Don't overwhelm user

```bash
# Find live regions
grep -rn "aria-live\|role=\"alert\"\|role=\"status\"" --include="*.tsx" --include="*.jsx"
```

---

## 3. Color & Contrast Audit

### 3.1 Text Contrast
- [ ] **Normal text 4.5:1** - Body text meets WCAG AA
- [ ] **Large text 3:1** - 18pt+ or 14pt bold
- [ ] **Enhanced contrast 7:1** - For AAA compliance
- [ ] **Placeholder text** - Still readable, sufficient contrast
- [ ] **Disabled text** - Not required but should be visible
- [ ] **Error text** - Red on white often fails - check!

### 3.2 UI Component Contrast
- [ ] **Input borders 3:1** - Against background
- [ ] **Focus indicators 3:1** - Visible focus ring
- [ ] **Button borders** - Ghost buttons visible
- [ ] **Icons 3:1** - Functional icons have contrast
- [ ] **Links distinguishable** - Not just color, underlined too

### 3.3 Color Independence
- [ ] **Not only color** - Info not conveyed by color alone
- [ ] **Error states** - Icon + text, not just red
- [ ] **Success states** - Icon + text, not just green
- [ ] **Required fields** - Asterisk, not just red label
- [ ] **Charts** - Patterns or labels, not just colors
- [ ] **Links** - Underlined, not just colored

```bash
# Find potential color-only indicators
grep -rn "red\|green\|color.*error\|color.*success" --include="*.css" --include="*.tsx"
```

### 3.4 Visual Testing
- [ ] **Check with Sim Daltonism** - Protanopia, deuteranopia, tritanopia
- [ ] **Check grayscale** - Information survives without color
- [ ] **Check high contrast mode** - Windows high contrast works

---

## 4. Content Accessibility Audit

### 4.1 Reading Level
- [ ] **Plain language** - Avoid jargon where possible
- [ ] **Short sentences** - Clear, concise text
- [ ] **Abbreviations explained** - First use spelled out
- [ ] **Error messages helpful** - Clear what went wrong, how to fix

### 4.2 Link Text
- [ ] **Links make sense out of context** - No "click here"
- [ ] **Link purpose clear** - Describes destination
- [ ] **Download links indicate file type** - "Download PDF"
- [ ] **External links indicated** - Icon or text "(opens in new tab)"

```bash
# Find vague link text
grep -rn ">click here<\|>read more<\|>learn more<\|>here<" --include="*.tsx" --include="*.jsx" --include="*.html"

# Find links opening new tabs without indication
grep -rn "target=\"_blank\"" --include="*.tsx" --include="*.jsx" | grep -v "external\|new tab\|new window"
```

### 4.3 Language
- [ ] **lang attribute set** - html lang="en" or appropriate
- [ ] **Language changes marked** - lang attribute for foreign phrases
- [ ] **Direction set** - dir="rtl" if needed

```bash
# Check html lang
grep -rn "<html" --include="*.html" --include="*.tsx"
```

---

## 5. Motion & Animation Audit

### 5.1 Reduced Motion
- [ ] **prefers-reduced-motion respected** - Query implemented
- [ ] **Animations can be disabled** - User preference honored
- [ ] **Essential motion preserved** - Only decorative reduced

```bash
# Find motion preference handling
grep -rn "prefers-reduced-motion\|reduce.*motion" --include="*.css" --include="*.tsx" --include="*.ts"
```

### 5.2 Motion Safety
- [ ] **No flashing content** - Nothing flashes >3x/second
- [ ] **Auto-playing controlled** - Video/animation can be stopped
- [ ] **Parallax optional** - Not essential, can be disabled
- [ ] **Carousels pausable** - Auto-advance can be paused

### 5.3 Animation Duration
- [ ] **Transitions not too fast** - >100ms for visibility
- [ ] **Transitions not too slow** - <500ms for responsiveness
- [ ] **Loading not distracting** - Spinners don't flash

---

## 6. Responsive Accessibility Audit

### 6.1 Zoom Support
- [ ] **200% zoom works** - Content reflows, nothing breaks
- [ ] **400% zoom works** - Still usable at high zoom
- [ ] **No horizontal scroll** - At normal zoom, standard widths
- [ ] **Text resizable** - User font size respected

### 6.2 Touch Accessibility
- [ ] **Touch targets 44x44px** - Minimum target size
- [ ] **Targets have spacing** - Not too close together
- [ ] **Gestures have alternatives** - Swipe has button alternative
- [ ] **No hover-only content** - Info accessible without hover

```bash
# Find potentially small touch targets
grep -rn "w-[1-6]\s\|h-[1-6]\s\|width:\s*[0-9]px\|height:\s*[0-9]px" --include="*.tsx" --include="*.css" | head -50
```

### 6.3 Viewport
- [ ] **Viewport meta set** - But allows zoom
- [ ] **No user-scalable=no** - Zoom not disabled
- [ ] **No maximum-scale=1** - Zoom not restricted

```bash
# Check viewport meta
grep -rn "viewport" --include="*.html" --include="*.tsx"
grep -rn "user-scalable=no\|maximum-scale=1" --include="*.html" --include="*.tsx"
```

---

## 7. Forms Deep Dive

### 7.1 Form Structure
- [ ] **Fieldset for groups** - Related fields grouped
- [ ] **Legend for fieldsets** - Groups have titles
- [ ] **Form has accessible name** - aria-label or heading

### 7.2 Input Types
- [ ] **Correct input types** - email, tel, url used
- [ ] **inputmode set** - numeric, decimal for numbers
- [ ] **autocomplete set** - name, email, address fields

### 7.3 Validation
- [ ] **Native validation used** - required, pattern, etc.
- [ ] **Errors prevent submission** - Can't submit invalid
- [ ] **Error summary** - List of errors at top
- [ ] **Focus on first error** - Focus moves to help fix
- [ ] **Inline errors persist** - Don't disappear before fixed

### 7.4 Submission
- [ ] **Submit button labeled** - Clear what it does
- [ ] **Loading state announced** - "Submitting..." to screen reader
- [ ] **Success announced** - Confirmation reaches assistive tech
- [ ] **Failure announced** - Error reaches assistive tech

---

## 8. Navigation Accessibility

### 8.1 Main Navigation
- [ ] **nav landmark** - Navigation in nav element
- [ ] **aria-label for multiple navs** - Distinguish if multiple
- [ ] **Current page indicated** - aria-current="page"
- [ ] **Keyboard navigable** - Full keyboard access

### 8.2 Breadcrumbs
- [ ] **nav with aria-label** - "Breadcrumb" label
- [ ] **ol for structure** - Ordered list semantics
- [ ] **Current page not linked** - Or aria-current="page"

### 8.3 Skip Links
- [ ] **Skip link exists** - "Skip to main content"
- [ ] **Skip link visible on focus** - Shows when tabbed to
- [ ] **Target has tabindex=-1** - Receives focus on activation

### 8.4 Search
- [ ] **search landmark** - role="search" or search element
- [ ] **Input labeled** - "Search" label
- [ ] **Results announced** - "5 results found"

---

## 9. Tables Accessibility

### 9.1 Table Structure
- [ ] **caption for table** - Table title
- [ ] **th for headers** - Not styled td
- [ ] **scope attribute** - col or row scope on th
- [ ] **Complex tables** - headers/id for complex

### 9.2 Table Features
- [ ] **Sortable columns accessible** - Button in th, state announced
- [ ] **Expandable rows** - aria-expanded, keyboard operable
- [ ] **Pagination accessible** - See pagination checklist

```bash
# Find table implementations
grep -rn "<table\|<Table" --include="*.tsx" --include="*.jsx"
grep -rn "<th\|<thead" --include="*.tsx" --include="*.jsx"
```

---

## 10. Error Handling Accessibility

### 10.1 Error Messages
- [ ] **Clear and specific** - Not "An error occurred"
- [ ] **Suggest fix** - How to resolve the error
- [ ] **Announced to screen reader** - role="alert" or aria-live
- [ ] **Visual indicator** - Icon + text + color

### 10.2 Error Boundaries
- [ ] **Accessible error page** - Full error page accessible
- [ ] **Recovery path** - Clear next steps
- [ ] **Focus management** - Focus moves to error

### 10.3 Loading States
- [ ] **Announced** - "Loading" to screen reader
- [ ] **Not just visual** - aria-busy or live region
- [ ] **Timeout handling** - Long loads explained

---

## Automated Testing Commands

```bash
# Run axe-core if available
npx @axe-core/cli http://localhost:3000

# Run pa11y
npx pa11y http://localhost:3000

# Check all pages with Lighthouse
npx lighthouse http://localhost:3000 --only-categories=accessibility --output=html

# HTML validation
npx html-validator-cli --url http://localhost:3000
```

---

## Manual Testing Protocol

### With Keyboard Only
1. Unplug mouse (literally)
2. Tab through entire page
3. Verify all functions work
4. Check focus is always visible
5. Test all form submissions
6. Test all modals/dialogs
7. Test all dropdowns/menus

### With Screen Reader
1. **VoiceOver (Mac)**: Cmd+F5 to toggle
2. **NVDA (Windows)**: Free download
3. Navigate by headings (H key)
4. Navigate by landmarks (D key)
5. Navigate by forms (F key)
6. Read entire page
7. Complete key tasks eyes closed

### With Browser Tools
1. **Chrome DevTools** > Accessibility panel
2. **Firefox** > Accessibility Inspector
3. **WAVE extension** - Run on all pages
4. **axe DevTools extension** - Run audits

### Visual Tests
1. Remove images - still usable?
2. Grayscale mode - still distinguishable?
3. 200% zoom - content reflows?
4. 400% zoom - still usable?
5. Reduced motion - animations respect?
