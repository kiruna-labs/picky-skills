# Interactive Element Testing Checklist

## Testing Philosophy

**Every interactive element is a promise to the user.** A button that looks clickable must be clickable. A slider that looks draggable must be draggable. And every interaction must provide feedback - users should never wonder "did that work?" Test every interaction like a user with zero patience.

---

## 1. Button Testing

### 1.1 For EVERY Button, Test:

**Basic Functionality:**
- [ ] Click works (does something)
- [ ] Action is correct (does the right thing)
- [ ] Feedback provided (visual change, message, navigation)
- [ ] Loading state (if async operation)
- [ ] Success state (if applicable)
- [ ] Error state (if action can fail)

**States:**
- [ ] Default appearance clear
- [ ] Hover state visible
- [ ] Focus state visible (for keyboard)
- [ ] Active/pressed state visible
- [ ] Disabled state (if applicable) - can't click, looks disabled
- [ ] Loading state (if async) - shows spinner/indicator

**Keyboard:**
- [ ] Focusable with Tab
- [ ] Activated with Enter
- [ ] Activated with Space
- [ ] Focus indicator visible

**Behavior:**
- [ ] Click once produces one action
- [ ] Rapid clicks handled (disabled during action, or debounced)
- [ ] Works on mobile (tap)
- [ ] Touch target large enough (44x44px minimum)

### 1.2 Button Types to Test:

- [ ] Primary action buttons (Submit, Save, Continue)
- [ ] Secondary action buttons (Cancel, Back)
- [ ] Destructive buttons (Delete, Remove)
- [ ] Icon-only buttons (Close, Menu)
- [ ] Toggle buttons (On/Off, Active/Inactive)
- [ ] Dropdown trigger buttons
- [ ] Modal trigger buttons
- [ ] Link-styled buttons

---

## 2. Modal/Dialog Testing

### 2.1 Opening

- [ ] Trigger button opens modal
- [ ] Modal appears centered (or appropriately positioned)
- [ ] Backdrop/overlay appears
- [ ] Page scrolling disabled (if full modal)
- [ ] Focus moves to modal
- [ ] Animation smooth (if present)

### 2.2 Content

- [ ] All content visible
- [ ] Modal scrolls if content is long
- [ ] Forms in modal work correctly
- [ ] Actions in modal work correctly
- [ ] Links in modal work correctly

### 2.3 Closing

- [ ] Close button (X) works
- [ ] Cancel button works
- [ ] Clicking backdrop closes (if designed)
- [ ] Escape key closes
- [ ] Completing action closes (if designed)
- [ ] Animation smooth (if present)

### 2.4 After Closing

- [ ] Focus returns to trigger element
- [ ] Page scrolling re-enabled
- [ ] Modal content reset (if applicable)
- [ ] Backdrop removed
- [ ] State preserved or cleared correctly

### 2.5 Accessibility

- [ ] Modal traps focus (can't Tab out)
- [ ] Tab cycles through modal elements
- [ ] Shift+Tab cycles backward
- [ ] Screen reader announces modal
- [ ] Close button accessible

### 2.6 Nested Modals (if present)

- [ ] Second modal opens on top
- [ ] Z-index correct
- [ ] Closing returns to first modal
- [ ] Both close correctly

---

## 3. Dropdown/Menu Testing

### 3.1 Opening

- [ ] Click opens dropdown
- [ ] Focus opens dropdown (if designed)
- [ ] Hover opens dropdown (if designed)
- [ ] Arrow indicator changes (rotates)
- [ ] Dropdown positioned correctly
- [ ] Doesn't go off screen

### 3.2 Content

- [ ] All items visible (or scrollable)
- [ ] Items are clearly clickable
- [ ] Hover state on items
- [ ] Active/selected state visible
- [ ] Disabled items look disabled
- [ ] Dividers/sections clear

### 3.3 Selection

- [ ] Click selects item
- [ ] Keyboard Enter selects item
- [ ] Selection triggers correct action
- [ ] For select-type: value shows after selection
- [ ] Multi-select works (if applicable)

### 3.4 Keyboard Navigation

- [ ] Arrow down moves to next item
- [ ] Arrow up moves to previous item
- [ ] Arrow keys wrap (or don't, consistently)
- [ ] Home jumps to first item
- [ ] End jumps to last item
- [ ] Type-ahead works (type "A" jumps to "Apple")
- [ ] Escape closes dropdown

### 3.5 Closing

- [ ] Clicking item closes dropdown
- [ ] Clicking outside closes dropdown
- [ ] Escape key closes dropdown
- [ ] Focus moves appropriately after close

### 3.6 Positioning

- [ ] Doesn't clip at screen edges
- [ ] Repositions if near edge
- [ ] Works near bottom of page
- [ ] Works in scrollable containers

---

## 4. Tooltip Testing

### 4.1 Trigger

- [ ] Hover shows tooltip (desktop)
- [ ] Focus shows tooltip (keyboard)
- [ ] Touch shows tooltip (mobile)
- [ ] Delay before appearing appropriate
- [ ] Position correct (above/below/side)

### 4.2 Content

- [ ] Text is readable
- [ ] Content is helpful
- [ ] Links work (if clickable tooltip)
- [ ] Truncation handled (long text)

### 4.3 Behavior

- [ ] Stays visible while hovering tooltip
- [ ] Disappears when moving away
- [ ] Doesn't cover important elements
- [ ] Multiple tooltips don't stack weird

---

## 5. Toast/Notification Testing

### 5.1 Appearance

- [ ] Appears in consistent position
- [ ] Animation smooth
- [ ] Doesn't cover critical UI
- [ ] Visual distinction by type (success/error/warning/info)
- [ ] Icon matches type

### 5.2 Content

- [ ] Message is readable
- [ ] Message is helpful
- [ ] Action buttons work (if present)
- [ ] Link works (if present)

### 5.3 Dismissal

- [ ] Auto-dismiss after appropriate time
- [ ] Close button works (if present)
- [ ] Swipe to dismiss (if designed)
- [ ] Hovering pauses auto-dismiss (if designed)

### 5.4 Stacking

- [ ] Multiple toasts stack correctly
- [ ] Newer toasts positioned correctly
- [ ] Dismiss one doesn't affect others
- [ ] No overlap

---

## 6. Accordion/Expandable Testing

### 6.1 Expand

- [ ] Click header expands section
- [ ] Click icon expands section
- [ ] Enter/Space expands (keyboard)
- [ ] Icon rotates/changes
- [ ] Content animates smoothly
- [ ] aria-expanded updates

### 6.2 Collapse

- [ ] Click again collapses
- [ ] Content animates smoothly
- [ ] Icon returns to original
- [ ] Keyboard works

### 6.3 Behavior

- [ ] Only one open (if exclusive)
- [ ] Multiple open (if allowed)
- [ ] All open possible (if designed)
- [ ] All closed possible
- [ ] State persists on refresh (if designed)

### 6.4 Content

- [ ] All content visible when expanded
- [ ] No content cut off
- [ ] Interactive elements work inside
- [ ] Links work inside

---

## 7. Tabs Testing

### 7.1 Selection

- [ ] Click tab selects it
- [ ] Active tab clearly visible
- [ ] Inactive tabs less prominent
- [ ] Content changes on selection

### 7.2 Content

- [ ] Correct content for each tab
- [ ] Content fully visible
- [ ] No leftover content from other tabs
- [ ] Interactive elements work

### 7.3 Keyboard

- [ ] Tab reaches tab list
- [ ] Arrow keys switch tabs
- [ ] Enter activates current tab
- [ ] Focus on tab vs tab content clear

### 7.4 URL State

- [ ] Tab selection in URL (if deep-linkable)
- [ ] Direct URL opens correct tab
- [ ] Back button behavior appropriate

### 7.5 Overflow (many tabs)

- [ ] Scroll indicator present
- [ ] Can scroll to more tabs
- [ ] Or: overflow menu works
- [ ] Active tab scrolls into view

---

## 8. Carousel/Slider Testing

### 8.1 Navigation

- [ ] Previous button works
- [ ] Next button works
- [ ] Dots/indicators work
- [ ] Swipe works (touch devices)
- [ ] Keyboard arrows work (if focused)

### 8.2 Behavior

- [ ] Loops at end (if designed)
- [ ] Stops at end (if designed)
- [ ] Auto-play works (if present)
- [ ] Auto-play pauses on hover
- [ ] Auto-play pauses on focus
- [ ] Resume after pause

### 8.3 Content

- [ ] All slides accessible
- [ ] Content fully visible per slide
- [ ] Images load correctly
- [ ] No slide cut off

### 8.4 Responsive

- [ ] Works on mobile
- [ ] Swipe gesture works
- [ ] Correct items per view

---

## 9. Toggle/Switch Testing

### 9.1 Interaction

- [ ] Click toggles state
- [ ] Keyboard Space toggles
- [ ] Visual state matches actual state
- [ ] Animation smooth

### 9.2 States

- [ ] On state clear
- [ ] Off state clear
- [ ] Disabled state (if applicable)
- [ ] Loading state (if async)

### 9.3 Effect

- [ ] Toggle triggers correct action
- [ ] Immediate effect (or with feedback)
- [ ] Can toggle back
- [ ] State persists correctly

---

## 10. Range Slider Testing

### 10.1 Interaction

- [ ] Drag thumb to change value
- [ ] Click track moves thumb
- [ ] Arrow keys increment/decrement
- [ ] Fine control possible

### 10.2 Visual

- [ ] Current value visible
- [ ] Min/max labels (if present)
- [ ] Track fill shows progress
- [ ] Thumb position accurate

### 10.3 Behavior

- [ ] Respects min value
- [ ] Respects max value
- [ ] Step values enforced (if defined)
- [ ] Dual thumbs work (if range)

---

## 11. Drag and Drop Testing

### 11.1 Dragging

- [ ] Element is draggable
- [ ] Visual feedback during drag
- [ ] Cursor changes appropriately
- [ ] Element follows cursor
- [ ] Original position clear

### 11.2 Dropping

- [ ] Valid drop zones highlighted
- [ ] Invalid drop zones rejected
- [ ] Drop places element correctly
- [ ] Order updates correctly

### 11.3 Keyboard Alternative

- [ ] Can reorder with keyboard
- [ ] Or: accessible alternative exists
- [ ] Focus management correct

### 11.4 Cancel

- [ ] Escape cancels drag
- [ ] Drop outside valid zone cancels
- [ ] Element returns to original position

---

## 12. Autocomplete/Combobox Testing

### 12.1 Input

- [ ] Typing shows suggestions
- [ ] Debounce appropriate (not on every keystroke)
- [ ] Loading state visible
- [ ] Results relevant to input

### 12.2 Selection

- [ ] Click selects option
- [ ] Enter selects highlighted option
- [ ] Arrow keys navigate options
- [ ] Selection populates input
- [ ] Dropdown closes after selection

### 12.3 Clearing

- [ ] Can clear selection
- [ ] Clear shows suggestions again (or doesn't)
- [ ] Backspace behavior appropriate

### 12.4 Edge Cases

- [ ] No results message
- [ ] Error fetching results
- [ ] Very long result list (scrollable)
- [ ] Very long option text (truncated/wrapped)

---

## Common Interaction Issues

1. **No feedback** - Clicked but nothing visible happened
2. **Delayed feedback** - Had to wait, didn't know if it worked
3. **Wrong feedback** - Success message but action failed
4. **No loading state** - Async action with no indicator
5. **Focus lost** - Interaction moved focus unexpectedly
6. **Keyboard inaccessible** - Can only use with mouse
7. **Touch target too small** - Hard to tap on mobile
8. **State mismatch** - Visual state doesn't match actual state
9. **Double action** - Click triggered twice
10. **Zombie element** - Removed but still interactive

---

## Interaction Testing Template

For each interactive element:

```markdown
## [Element Name] - [Page/Section]

**Location**: [Where on page]
**Purpose**: [What it should do]

### Tests:
| Test | Result | Notes |
|------|--------|-------|
| Click works | ✓/✗ | |
| Keyboard works | ✓/✗ | |
| Hover state | ✓/✗ | |
| Focus state | ✓/✗ | |
| Disabled state | ✓/✗/N/A | |
| Loading state | ✓/✗/N/A | |
| Mobile works | ✓/✗ | |

### Issues:
- [Any issues found]
```
