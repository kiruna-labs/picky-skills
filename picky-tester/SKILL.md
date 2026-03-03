---
name: picky-tester
description: Ultra-thorough black-box QA testing that behaves like a real user, not a developer. Tests forms, navigation, interactive elements, error handling, and edge cases via Chrome DevTools MCP. Produces scored friction logs with screenshots. Trigger with "test this app", "QA testing", "test as a real user", "picky tester".
---

# /picky-tester — Friction Log Testing with Simulated Tester Army

Comprehensive QA testing skill that simulates 13 diverse user personas testing your app via Chrome DevTools MCP. Produces a structured friction log with P0-P3 severity findings.

## Invocation

- `/picky-tester` — test the current project's dev server
- `/picky-tester <url>` — test a specific URL

## Arguments

- `$ARGUMENTS` — optional URL to test (defaults to `http://localhost:${PROJECT_PORT}`)

---

## Phase 1: Setup

### Determine Project Port

Determine the target URL:

1. If `$ARGUMENTS` contains a URL, use that directly
2. Read the current project's `CLAUDE.md` for dev server port
3. Check `package.json` scripts for a dev server port
4. Fall back to `http://localhost:3000`

Set `PROJECT_URL` accordingly.

If `$ARGUMENTS` contains a URL, use that instead.

### Ensure Dev Server Running

```bash
lsof -i :${PROJECT_PORT}
```

If NOT running, start it in the background on the assigned port. Leave it running after the skill completes.

### Load Chrome DevTools MCP Tools

```
ToolSearch query: "chrome navigate screenshot"
ToolSearch query: "chrome click snapshot"
ToolSearch query: "chrome emulate evaluate"
ToolSearch query: "chrome network console"
```

All Chrome DevTools MCP tools must be loaded before testing begins.

### Prepare Fresh State

```
mcp__chrome-devtools__navigate_page({ url: PROJECT_URL })
mcp__chrome-devtools__evaluate_script({ expression: "localStorage.clear(); sessionStorage.clear();" })
mcp__chrome-devtools__navigate_page({ url: PROJECT_URL })
```

### Create Output Directory

```bash
mkdir -p friction-log
```

---

## Phase 2: Tester Army

Each tester represents a distinct user persona with different priorities, viewport sizes, and test focus areas.

| # | Name | Persona | Focus Area | Tech Level | Viewport |
|---|------|---------|------------|------------|----------|
| T01 | Marcus | First-time visitor, tech-curious | New user experience, onboarding, value proposition | Medium | 390×844 (iPhone 14) |
| T02 | Priya | Power user, daily visitor | CRUD operations, persistence, workflows, settings | High | 390×844 (iPhone 14) |
| T03 | Dale | Data nerd, API watcher | Network requests, data accuracy, API efficiency | High | 393×851 (Pixel 7) |
| T04 | Ximena | Table/list power user | Data views, sorting, filtering, data presentation | Medium | 390×844 (iPhone 14) |
| T05 | Jordan | Config tweaker, form expert | Settings, configuration, form interactions | High | 375×667 (iPhone SE) |
| T06 | Talia | Visual design critic | Colors, spacing, alignment, light/dark mode, a11y | Medium | 390×844 (iPhone 14) |
| T07 | Roberto | Multi-item manager | Item management, drag-and-drop, reordering, bulk ops | Medium | 393×851 (Pixel 7) |
| T08 | Samantha | Casual user, low-tech | Core features only, simple happy paths | Low | 390×844 (iPhone 14) |
| T09 | Felix | Impatient user | Navigation speed, loading states, time-sensitive tasks | Medium | 375×667 (iPhone SE) |
| T10 | Angela | Shared link recipient | URL-based navigation, deep links, sharing flow | Low | 430×932 (iPhone 15 Pro Max) |
| T11 | Vikram | Performance auditor | Load times, network waterfall, memory, errors | High | 390×844 (iPhone 14) |
| T12 | Chloe | Accessibility + light mode | Light mode rendering, contrast, touch targets | Medium | 390×844 (iPhone 14) |
| T13 | Omar | Stress tester, chaos monkey | Edge cases, rapid clicks, wrong inputs, abuse | High | 375×667 (iPhone SE) |

---

## Phase 3: Execution

### For Each Tester

1. **Emulate viewport:**
   ```
   mcp__chrome-devtools__emulate({
     viewport: { width: VIEWPORT_W, height: VIEWPORT_H, isMobile: true, deviceScaleFactor: 2 }
   })
   ```

2. **Clear state** (for testers T01-T03, T10):
   ```
   mcp__chrome-devtools__evaluate_script({ expression: "localStorage.clear(); sessionStorage.clear();" })
   mcp__chrome-devtools__navigate_page({ url: PROJECT_URL })
   ```

3. **Execute tester's test script** (see individual scripts below)

4. **Capture evidence:**
   - `mcp__chrome-devtools__take_screenshot` after each significant action
   - Save with filename pattern: `t{NN}-{action}.png`

5. **Document findings** as they occur

### Tester Test Scripts

#### T01: Marcus — First-Time Visitor
```
1. Navigate to home URL with cleared localStorage
2. Screenshot initial state — note first impression
3. Try to understand what the app does from visible UI
4. Look for any value proposition, tagline, or onboarding
5. Click every visible button/link in the header
6. Try the primary creation action (e.g., "Add Item", "New Entry", or "+" button)
7. Search for or select an item and confirm the selection
8. Screenshot after adding — check for layout breakage
9. Switch between available view modes (e.g., list, grid, table)
10. Try to create a new resource (find and click + or "Create" button)
11. Check if dynamic data loads and displays correctly
```

#### T02: Priya — Power User
```
1. Navigate to home with cleared localStorage — note what defaults appear
2. Check saved items/resources — create a new one
3. Edit item properties (name, description, settings)
4. Switch between items — verify state saves
5. Delete an item — check for confirmation dialog
6. Duplicate an item — verify copy is correct
7. Reorder items via drag-and-drop (if available)
8. Test edit mode toggle (if applicable)
9. Check that destructive action buttons are properly gated
10. Test all header/toolbar buttons for touch target sizes
```

#### T03: Dale — Data Nerd
```
1. Open Network tab: mcp__chrome-devtools__list_network_requests
2. Navigate to home — count total API calls
3. Check for duplicate or redundant API requests
4. Verify API response data matches displayed content
5. Check for double POST/PUT requests on user actions
6. Trigger a new data-fetching action — count network requests
7. Change filters, views, or options — check API calls triggered
8. Verify data accuracy against what's displayed in the UI
```

#### T04: Ximena — Data View User
```
1. Find and switch to any table/list/grid view
2. Screenshot the data layout
3. Check column or field headers — are units/labels clear?
4. Look for duplicate or confusing labels
5. Check if any columns have misleading indicators
6. Try sorting, filtering, or reordering (if available)
7. Check for empty or meaningless data columns
8. Test adding/removing visible columns or filters
9. Verify content scrolls properly on small viewport
```

#### T05: Jordan — Form & Config Expert
```
1. Navigate to settings, preferences, or any configuration area
2. Try each form control — dropdowns, toggles, text inputs, sliders
3. Test form validation with valid, empty, and boundary inputs
4. Create or modify a complex configuration
5. Check if save/submit button is visible and reachable
6. Test inline editing (if available)
7. Edit an existing entry — verify the edit UI works correctly
8. Check for button-in-button nesting (console errors)
9. Test on 375px viewport (iPhone SE) — check overflow
```

#### T06: Talia — Visual Design Critic
```
1. Check dark mode: colors, contrast, borders
2. Switch to light mode: mcp__chrome-devtools__emulate({ colorScheme: "light" })
3. Screenshot light mode — check visibility of all components
4. Check all buttons — measure touch targets (min 44px)
5. Check spacing/alignment of header controls
6. Look at data displays — alignment and consistency
7. Check labels — abbreviations, consistency, readability
8. Check settings/config panels — visual organization
9. Review font sizes — nothing < 13px
10. Check badge/tag contrast in both modes
```

#### T07: Roberto — Multi-Item Manager
```
1. Add 3+ items/resources
2. Screenshot after each — check layout integrity
3. Try removing an item — is there confirmation?
4. Check delete/remove button visibility and gating
5. Reorder items via drag-and-drop (if available)
6. Switch between items in different views
7. Verify active item indicator in header/nav
8. Check dropdown/picker — does it overflow viewport?
9. Test geolocation or device-specific features (if applicable)
```

#### T08: Samantha — Casual User
```
1. Navigate to main screen — identify core features
2. Try the most obvious action — does it work intuitively?
3. Explore any mode/view toggles
4. Select different options in the primary interface
5. Check if results/output makes sense for selections
6. Verify the app is usable without reading documentation
```

#### T09: Felix — Impatient User
```
1. Find time-sensitive or filter controls
2. Try clicking each one — does it respond instantly?
3. If dropdown/picker opens: test all options rapidly
4. Check that labels update correctly after selection
5. Switch between different modes/views quickly
6. Switch back — verify the app doesn't get confused
7. Test any range selectors or sliders
8. Verify labels are clear and unambiguous
```

#### T10: Angela — Shared Link Recipient
```
1. Navigate to a non-existent or malformed URL path
2. Screenshot the error/404 screen
3. Evaluate: is it clear what the app does? Can user recover?
4. Navigate to home — check if app loads correctly
5. Test deep link / shareable URL format (if applicable)
6. Check any share/copy/fork functionality
```

#### T11: Vikram — Performance Auditor
```
1. Navigate to home — time the load
2. Check console for errors: mcp__chrome-devtools__list_console_messages
3. Look for hydration warnings, rendering errors
4. Check network waterfall for request timing
5. Verify no unhandled errors in console
6. Check API responses — any stale or unexpected data?
7. Monitor for duplicate or unnecessary network requests
8. Check total page weight (transferred bytes)
```

#### T12: Chloe — Accessibility + Light Mode
```
1. Enable light mode: emulate colorScheme: "light"
2. Change any unit/locale settings available
3. Screenshot full page in light mode
4. Check contrast of all text elements
5. Measure every button's touch target
6. Check chart/graph fill visibility (if applicable)
7. Check badge/label readability
8. Check data visualization colors in light mode
9. Test table/list view headers
10. Verify footer text readability
```

#### T13: Omar — Chaos Monkey
```
1. Rapidly click buttons — check for double-submissions
2. Add and immediately remove items
3. Try to create entries with empty/invalid data
4. Test search with very long strings
5. Test with emoji in search inputs
6. Rapidly switch between List/Table view
7. Open multiple dropdowns simultaneously
8. Try to break the app with unexpected interactions
```

---

## Phase 4: Compilation

### Aggregate Findings

Collect all findings from all testers and organize into a single `FRICTION-LOG.md`:

```markdown
# [App Name] — Comprehensive Friction Log
**Date:** YYYY-MM-DD
**App URL:** [URL tested]
**Viewport:** [Primary viewport] primary, also tested at [others]
**[N] Simulated Testers — Consolidated Findings**

---

## Executive Summary
[Top 5-7 most critical findings as numbered list]

---

## P0 — Critical ([N] findings)
[Findings that break core functionality or layout]

## P1 — High ([N] findings)
[Usability blockers, a11y failures, data presentation bugs]

## P2 — Medium ([N] findings)
[Visual bugs, API inefficiency, confusing labels]

## P3 — Low / Cosmetic ([N] findings)
[Minor issues, nice-to-haves, edge cases]

---

## Coverage Summary
| Feature Area | Items Tested | Findings | Testers |
|---|---|---|---|

---

## Priority Breakdown
| Severity | Count | Description |
|---|---|---|

---

## Top 5 Recommended Fixes
[Highest impact/effort ratio fixes]

---

## Screenshots Index
| File | Description |
|---|---|
```

### Finding Format

Each finding should include:
- **ID:** F{NN}
- **Title:** Brief description
- **Testers:** Which tester(s) found it
- **Repro:** Steps to reproduce
- **Details:** What happened, including DOM coordinates/measurements
- **Root cause:** If apparent from behavior
- **Impact:** User impact assessment
- **Screenshot:** Reference to saved screenshot

### Severity Guidelines

| Severity | Criteria |
|----------|----------|
| **P0 Critical** | Layout breakage, inaccessible features, dead-end errors, data loss |
| **P1 High** | Usability blockers, a11y failures (44px touch targets), data presentation bugs, hydration errors |
| **P2 Medium** | Visual bugs, API inefficiency, confusing labels, inconsistent behavior |
| **P3 Low** | Cosmetic issues, minor UX improvements, edge cases, nice-to-haves |

### Deduplication

When multiple testers find the same issue:
- Create ONE finding entry
- List ALL testers who found it
- Use the most detailed reproduction steps
- Severity = highest assessment from any tester

---

## Phase 5: Reporting

Present a summary to the user:

```
Testing complete. [N] findings across [M] testers.

| Severity | Count |
|----------|-------|
| P0 Critical | X |
| P1 High | X |
| P2 Medium | X |
| P3 Low | X |

Top 5 recommended fixes:
1. [Brief description] — [estimated effort]
2. ...

Full report: friction-log/FRICTION-LOG.md
Screenshots: friction-log/t*.png
```

---

## Key Testing Patterns

### Touch Target Audit
```javascript
// Evaluate in Chrome DevTools to measure all buttons
document.querySelectorAll('button, [role="button"], a').forEach(el => {
  const rect = el.getBoundingClientRect();
  if (rect.width < 44 || rect.height < 44) {
    console.warn(`Small target: ${el.textContent?.trim().slice(0,20)} — ${Math.round(rect.width)}×${Math.round(rect.height)}px`);
  }
});
```

### Button Nesting Detection
```javascript
// Detect <button> inside <button> (HTML spec violation)
document.querySelectorAll('button button').forEach(el => {
  console.error(`Nested button: ${el.textContent?.trim().slice(0,30)}`);
});
```

### Layout Overflow Detection
```javascript
// Check if page content exceeds viewport width
const excess = document.documentElement.scrollWidth - window.innerWidth;
if (excess > 0) console.error(`Layout overflow: ${excess}px wider than viewport`);
```

### Duplicate API Call Detection
```javascript
// Check network requests for duplicate URLs (via Chrome DevTools list_network_requests)
// Group by URL, flag any URL called 2+ times
```

### Light/Dark Mode Toggle
```
// Test both themes
mcp__chrome-devtools__emulate({ colorScheme: "light" })
mcp__chrome-devtools__take_screenshot
mcp__chrome-devtools__emulate({ colorScheme: "dark" })
mcp__chrome-devtools__take_screenshot
```

### Click Fallback Pattern
When Chrome DevTools `click` tool times out on a button:
```
mcp__chrome-devtools__evaluate_script({
  expression: "document.querySelector('SELECTOR').click()"
})
```
This indicates the button may have a pointer-events issue or overlay.

---

## Chrome DevTools MCP Quick Reference

```javascript
// Navigation
mcp__chrome-devtools__navigate_page({ url: "...", type: "url" })
mcp__chrome-devtools__navigate_page({ type: "back" })

// Visual capture
mcp__chrome-devtools__take_screenshot
mcp__chrome-devtools__take_snapshot  // accessibility tree

// Interaction
mcp__chrome-devtools__click({ uid: "element-uid" })
mcp__chrome-devtools__fill({ uid: "input-uid", value: "text" })
mcp__chrome-devtools__press_key({ key: "Enter" })
mcp__chrome-devtools__press_key({ key: "Escape" })

// Viewport & emulation
mcp__chrome-devtools__emulate({
  viewport: { width: 390, height: 844, isMobile: true, deviceScaleFactor: 2 }
})
mcp__chrome-devtools__emulate({ colorScheme: "light" })
mcp__chrome-devtools__emulate({ colorScheme: "dark" })
mcp__chrome-devtools__resize_page({ width: 390, height: 844 })

// JavaScript evaluation
mcp__chrome-devtools__evaluate_script({ expression: "..." })

// Inspection
mcp__chrome-devtools__list_console_messages
mcp__chrome-devtools__list_network_requests
mcp__chrome-devtools__get_network_request({ id: "..." })
mcp__chrome-devtools__get_console_message({ id: "..." })
```

---

## Rules

- **Use Chrome DevTools MCP exclusively** — never Playwright, never read source code
- **Screenshot everything** — findings without evidence are worthless
- **Be a user, not a developer** — don't rationalize bugs, document confusion
- **Deduplicate across testers** — one finding per issue, list all testers who found it
- **Leave dev server running** — never kill it
- **Save all screenshots** to `friction-log/` directory
- **Measure, don't guess** — use evaluate_script for exact pixel measurements
