# Component Patterns Audit

## Audit Philosophy

**Every component is a contract.** When a user sees a button, they expect ALL buttons to behave identically. When they see a card, they expect ALL cards to follow the same rules. Your job is to find every breach of these implicit contracts.

---

## 1. Button Audit

### 1.1 Button Variants
- [ ] **Primary button** - Main CTA, consistent across app
- [ ] **Secondary button** - Secondary actions, distinct from primary
- [ ] **Tertiary/ghost button** - Minimal styling, consistent
- [ ] **Destructive button** - Delete/danger actions, red/warning color
- [ ] **Link button** - Text-only button styling

### 1.2 Button Sizes
- [ ] **Size scale defined** - xs, sm, md, lg, xl
- [ ] **Consistent heights** - All buttons of same size have same height
- [ ] **Padding ratios** - Horizontal padding proportional to height
- [ ] **Icon sizing** - Icons scale with button size

### 1.3 Button States
- [ ] **Default** - Resting state styling
- [ ] **Hover** - Consistent hover effect (darken, lighten, shadow)
- [ ] **Focus** - Visible focus ring, accessible
- [ ] **Active/pressed** - Distinct pressed state
- [ ] **Disabled** - Grayed out, cursor: not-allowed
- [ ] **Loading** - Spinner replaces content, button stays same size

### 1.4 Button Content
- [ ] **Text-only** - Proper padding, centered text
- [ ] **Icon-only** - Square aspect ratio, consistent padding
- [ ] **Icon + text** - Consistent gap, alignment
- [ ] **Text + icon** - Right-side icon spacing
- [ ] **Full-width** - Stretch behavior consistent

```bash
# Find all button implementations
grep -rn "Button\|<button" --include="*.tsx" --include="*.jsx" -A 3

# Find button variant usage
grep -rn "variant=\|size=" --include="*.tsx" --include="*.jsx" | grep -i button
```

### 1.5 Button Anti-Patterns to Find
- [ ] Mixed button styles for same action type
- [ ] Inconsistent disabled appearance
- [ ] Focus rings that don't match
- [ ] Different hover effects on same variant
- [ ] Icon buttons without aria-label
- [ ] Buttons with different heights at same "size"

---

## 2. Form Input Audit

### 2.1 Text Inputs
- [ ] **Height consistency** - All text inputs same height
- [ ] **Padding consistency** - Internal padding matches
- [ ] **Border style** - Same border color, width, radius
- [ ] **Placeholder style** - Consistent placeholder color/style
- [ ] **Font consistency** - Same font-size, family

### 2.2 Input States
- [ ] **Default** - Resting appearance
- [ ] **Hover** - Subtle hover indication (optional)
- [ ] **Focus** - Clear focus ring, typically primary color
- [ ] **Disabled** - Grayed background, reduced opacity
- [ ] **Read-only** - Distinct from disabled
- [ ] **Error** - Red border, error color
- [ ] **Success** - Green border (if validation shown)

### 2.3 Input Variants
- [ ] **Text input** - Standard single-line
- [ ] **Textarea** - Multi-line, consistent styling
- [ ] **Select** - Dropdown styling matches inputs
- [ ] **Checkbox** - Custom styled consistently
- [ ] **Radio** - Custom styled consistently
- [ ] **Toggle/switch** - Consistent on/off appearance
- [ ] **File input** - Styled upload control
- [ ] **Date picker** - Matches form styling
- [ ] **Color picker** - Matches form styling

### 2.4 Input Composition
- [ ] **Label positioning** - Above/beside consistently
- [ ] **Label styling** - Same font-size, weight, color
- [ ] **Required indicator** - Asterisk, "(required)" - pick one
- [ ] **Helper text** - Consistent position, styling
- [ ] **Error message** - Same position, color, icon usage
- [ ] **Character count** - If used, consistent position

### 2.5 Input Sizes
- [ ] **Size scale** - sm, md, lg inputs if offered
- [ ] **Consistent with buttons** - md input height = md button height

```bash
# Find all input implementations
grep -rn "<input\|<Input\|<textarea\|<Textarea\|<select\|<Select" --include="*.tsx" --include="*.jsx"

# Find form field wrappers
grep -rn "FormField\|FormControl\|FormItem" --include="*.tsx" --include="*.jsx"
```

---

## 3. Card Component Audit

### 3.1 Card Structure
- [ ] **Padding consistency** - All cards same internal padding
- [ ] **Border style** - Same border or shadow
- [ ] **Border radius** - Consistent corner radius
- [ ] **Background** - Same background color

### 3.2 Card Variants
- [ ] **Default card** - Standard content container
- [ ] **Interactive card** - Clickable, has hover state
- [ ] **Selected card** - Selection indication
- [ ] **Highlighted card** - Featured/promoted styling

### 3.3 Card Content Patterns
- [ ] **Header area** - Consistent title styling
- [ ] **Body area** - Content spacing
- [ ] **Footer area** - Action placement
- [ ] **Image placement** - Top, side, background
- [ ] **Dividers** - If used, consistent style

### 3.4 Card in Grids
- [ ] **Grid gaps** - Consistent spacing between cards
- [ ] **Equal heights** - Cards in rows match height
- [ ] **Responsive stacking** - Clean stacking on mobile

```bash
# Find card implementations
grep -rn "Card\|<article\|class.*card" --include="*.tsx" --include="*.jsx" --include="*.css"
```

---

## 4. Modal/Dialog Audit

### 4.1 Modal Structure
- [ ] **Overlay color** - Consistent backdrop
- [ ] **Overlay opacity** - Same darkness level
- [ ] **Modal width** - Defined widths: sm, md, lg, xl, full
- [ ] **Border radius** - Consistent corners
- [ ] **Shadow** - Consistent elevation

### 4.2 Modal Anatomy
- [ ] **Header** - Title placement, close button position
- [ ] **Close button** - Same X icon, same position (top-right)
- [ ] **Body** - Content padding
- [ ] **Footer** - Action buttons alignment (right, spread)
- [ ] **Scrolling** - Body scrolls, header/footer fixed

### 4.3 Modal Behavior
- [ ] **Open animation** - Fade, scale, slide - consistent
- [ ] **Close animation** - Matches open
- [ ] **ESC to close** - Works consistently
- [ ] **Click outside** - Closes or doesn't - pick one
- [ ] **Focus trap** - Focus stays in modal
- [ ] **Return focus** - Focus returns on close

### 4.4 Modal Types
- [ ] **Confirmation dialog** - Consistent for all confirms
- [ ] **Form dialog** - Consistent layout for forms
- [ ] **Alert dialog** - Critical alerts styled consistently
- [ ] **Full-screen modal** - Consistent if used

```bash
# Find modal implementations
grep -rn "Modal\|Dialog\|Sheet" --include="*.tsx" --include="*.jsx"
```

---

## 5. Dropdown/Menu Audit

### 5.1 Dropdown Trigger
- [ ] **Trigger styling** - Consistent button/control appearance
- [ ] **Chevron icon** - Same icon, same position
- [ ] **Open state** - Chevron rotation, background change

### 5.2 Dropdown Panel
- [ ] **Background** - Consistent panel color
- [ ] **Border/shadow** - Consistent elevation
- [ ] **Border radius** - Matches design system
- [ ] **Max height** - Scrollable if too long
- [ ] **Width** - Minimum width, max width rules

### 5.3 Dropdown Items
- [ ] **Item height** - Consistent clickable height
- [ ] **Item padding** - Same padding all dropdowns
- [ ] **Hover state** - Same hover background
- [ ] **Selected state** - Checkmark, highlight - consistent
- [ ] **Disabled items** - Same disabled styling
- [ ] **Dividers** - Consistent separator styling

### 5.4 Dropdown Variants
- [ ] **Select dropdown** - Form input style
- [ ] **Action menu** - Context menu style
- [ ] **Navigation menu** - Site nav dropdowns
- [ ] **Multi-select** - Checkboxes in dropdown

```bash
# Find dropdown implementations
grep -rn "Dropdown\|Menu\|Popover\|Select" --include="*.tsx" --include="*.jsx"
```

---

## 6. Navigation Components Audit

### 6.1 Top Navigation
- [ ] **Height** - Consistent nav height
- [ ] **Background** - Same background color
- [ ] **Logo placement** - Consistent position
- [ ] **Nav items** - Same spacing, styling
- [ ] **Active indicator** - Consistent active page indicator

### 6.2 Side Navigation
- [ ] **Width** - Consistent sidebar width
- [ ] **Item height** - Same for all nav items
- [ ] **Item padding** - Consistent indentation
- [ ] **Icons** - Same icon size, alignment
- [ ] **Active state** - Consistent active styling
- [ ] **Hover state** - Consistent hover effect
- [ ] **Nested items** - Consistent indentation

### 6.3 Tab Navigation
- [ ] **Tab height** - All tabs same height
- [ ] **Active indicator** - Border-bottom, background - consistent
- [ ] **Hover state** - Same hover effect
- [ ] **Disabled tabs** - Same disabled styling
- [ ] **Overflow behavior** - Scroll or dropdown - consistent

### 6.4 Breadcrumbs
- [ ] **Separator** - Same separator (/, >, arrow)
- [ ] **Link styling** - Consistent colors
- [ ] **Current page** - Not linked, distinct styling

### 6.5 Pagination
- [ ] **Button style** - Page buttons consistent
- [ ] **Active page** - Clear active indication
- [ ] **Disabled prev/next** - Consistent disabled
- [ ] **Ellipsis** - Consistent truncation

```bash
# Find navigation components
grep -rn "Nav\|Sidebar\|Tab\|Breadcrumb\|Pagination" --include="*.tsx" --include="*.jsx"
```

---

## 7. Feedback Components Audit

### 7.1 Toast/Notification
- [ ] **Position** - Same corner for all toasts
- [ ] **Width** - Consistent toast width
- [ ] **Animation** - Same enter/exit animation
- [ ] **Auto-dismiss** - Consistent timing
- [ ] **Close button** - Same position, same icon
- [ ] **Stacking** - Multiple toasts stack consistently

### 7.2 Toast Variants
- [ ] **Success** - Green styling, check icon
- [ ] **Error** - Red styling, X or alert icon
- [ ] **Warning** - Yellow/amber styling, warning icon
- [ ] **Info** - Blue styling, info icon
- [ ] **Neutral** - No semantic color

### 7.3 Alert/Banner
- [ ] **Full-width alerts** - Same padding, same icons
- [ ] **Dismissible** - Close button consistent
- [ ] **Inline alerts** - Consistent with full-width styling

### 7.4 Progress Indicators
- [ ] **Progress bar** - Same height, colors, animation
- [ ] **Spinner** - Same spinner icon everywhere
- [ ] **Skeleton** - Same skeleton color, animation
- [ ] **Loading overlay** - Consistent overlay styling

### 7.5 Empty States
- [ ] **Illustration style** - Consistent illustration approach
- [ ] **Text hierarchy** - Title, description consistent
- [ ] **Action button** - Consistent CTA styling

### 7.6 Error States
- [ ] **Error boundary** - Consistent error page
- [ ] **404 page** - Consistent with other errors
- [ ] **Form errors** - Consistent inline errors
- [ ] **API errors** - Consistent error messages

```bash
# Find feedback components
grep -rn "Toast\|Notification\|Alert\|Spinner\|Skeleton\|Loading" --include="*.tsx" --include="*.jsx"
```

---

## 8. Data Entry Components Audit

### 8.1 Date Picker
- [ ] **Trigger styling** - Matches other inputs
- [ ] **Calendar styling** - Consistent with design system
- [ ] **Selected date** - Clear selection indication
- [ ] **Today indicator** - Consistent today highlight
- [ ] **Range selection** - If supported, consistent

### 8.2 Time Picker
- [ ] **Format** - 12h or 24h - consistent
- [ ] **Input styling** - Matches date picker
- [ ] **Dropdown styling** - Consistent time list

### 8.3 Color Picker
- [ ] **Trigger** - Shows selected color consistently
- [ ] **Picker interface** - Matches design system

### 8.4 File Upload
- [ ] **Drop zone** - Consistent dashed border, styling
- [ ] **File preview** - Consistent preview cards
- [ ] **Progress** - Consistent upload progress
- [ ] **Error state** - Consistent error display

### 8.5 Rich Text Editor
- [ ] **Toolbar** - Consistent icon buttons
- [ ] **Editor area** - Consistent with text inputs
- [ ] **Formatting** - Applied styles match content display

### 8.6 Search Input
- [ ] **Search icon** - Consistent position (left usually)
- [ ] **Clear button** - Consistent X button when filled
- [ ] **Results dropdown** - Matches other dropdowns

---

## 9. Data Display Components Audit

### 9.1 Badge/Chip
- [ ] **Size** - Consistent badge heights
- [ ] **Padding** - Same horizontal padding
- [ ] **Border radius** - Full rounded or specific radius
- [ ] **Colors** - Semantic colors consistent
- [ ] **Removable** - X button consistent if dismissible

### 9.2 Avatar
- [ ] **Sizes** - xs, sm, md, lg, xl defined
- [ ] **Shape** - Circle or rounded - consistent
- [ ] **Fallback** - Initials or icon - consistent style
- [ ] **Status dot** - Position, size, colors consistent

### 9.3 Tooltip
- [ ] **Delay** - Same delay before showing
- [ ] **Position** - Default position consistent
- [ ] **Arrow** - Has arrow or not - consistent
- [ ] **Styling** - Same background, text color

### 9.4 Popover
- [ ] **Trigger** - Consistent trigger behavior
- [ ] **Styling** - Matches dropdowns
- [ ] **Close behavior** - Click outside, ESC consistent

### 9.5 Accordion
- [ ] **Header styling** - Consistent expandable headers
- [ ] **Icon** - Chevron/plus - consistent
- [ ] **Animation** - Same expand/collapse animation
- [ ] **Multiple open** - Can have multiple or not - consistent

### 9.6 Tags/Labels
- [ ] **Styling** - Consistent with badges or distinct
- [ ] **Colors** - Semantic meaning consistent
- [ ] **Sizing** - Matches badge scale

---

## 10. Component Composition Patterns

### 10.1 Icon + Text Patterns
- [ ] **Gap spacing** - Consistent gap between icon and text
- [ ] **Alignment** - Vertical alignment consistent
- [ ] **Order** - Icon first or text first - patterns consistent

### 10.2 Form Layout Patterns
- [ ] **Label + Input** - Consistent spacing
- [ ] **Error placement** - Below input, consistent
- [ ] **Horizontal forms** - Label beside input - consistent alignment
- [ ] **Form sections** - Consistent section dividers

### 10.3 List Patterns
- [ ] **List item structure** - Avatar/icon + content + action
- [ ] **Spacing** - Consistent item gaps
- [ ] **Dividers** - Between items or not - consistent
- [ ] **Selection** - Checkbox, highlight - consistent

### 10.4 Header Patterns
- [ ] **Page headers** - Title + description + actions
- [ ] **Section headers** - Consistent hierarchy
- [ ] **Card headers** - Consistent title placement

### 10.5 Action Patterns
- [ ] **Primary action placement** - Right side typically
- [ ] **Destructive actions** - Position, confirmation patterns
- [ ] **Action groups** - Button spacing in groups

---

## Component Scan Commands

```bash
# Find all component definitions
grep -rn "export.*function\|export.*const.*=.*\(" --include="*.tsx" | grep -v "test\|spec\|story" | head -100

# Find component variants
grep -rn "variant.*=\|size.*=\|color.*=" --include="*.tsx" --include="*.jsx"

# Find direct style application (potential inconsistency)
grep -rn "style={{" --include="*.tsx" --include="*.jsx"

# Find className string concatenation (error-prone)
grep -rn "className={\`\|className={.*\+" --include="*.tsx" --include="*.jsx"

# Find conditional styling patterns
grep -rn "clsx\|classnames\|cn\(" --include="*.tsx" --include="*.jsx"
```

---

## Visual Verification Tasks

For EACH component type:

1. **List all instances** - Find every place component is used
2. **Screenshot variations** - Capture each variant/size
3. **Compare side-by-side** - Put screenshots in grid
4. **Check state transitions** - Hover, focus, active on each
5. **Test edge cases** - Long text, no text, many items
6. **Cross-page comparison** - Same component on different pages
7. **Responsive check** - Component at each breakpoint
