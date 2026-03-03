# UX Anti-Patterns Audit

## Audit Philosophy

**Users don't have time for your UI's bad habits.** Every friction point costs engagement. Every confusing interaction erodes trust. Your job is to find EVERY dark pattern, usability trap, and frustrating interaction - whether intentional or accidental.

---

## 1. Navigation Anti-Patterns

### 1.1 Disorientation
- [ ] **No breadcrumbs on deep pages** - Users don't know where they are
- [ ] **Logo doesn't go home** - Expected behavior broken
- [ ] **Back button breaks** - SPA doesn't maintain history properly
- [ ] **Unexpected redirects** - Page changes without user action
- [ ] **No clear current location** - Active nav item not indicated
- [ ] **Mystery meat navigation** - Icons without labels, unclear meaning

### 1.2 Dead Ends
- [ ] **404 without recovery** - Error page has no navigation
- [ ] **Empty states with no action** - "No items" but no way to add
- [ ] **Successful action nowhere to go** - Form submitted, now what?
- [ ] **Logout dumps to blank page** - No direction after signout
- [ ] **Search no results, no help** - Zero results with no suggestions

### 1.3 Navigation Traps
- [ ] **Mega menus that close too easily** - Hover menus that disappear
- [ ] **Dropdowns that cover trigger** - Can't click parent after opening
- [ ] **Infinite scroll without landmark** - Can't find where you were
- [ ] **Modal from modal from modal** - Nested dialogs trap users
- [ ] **Pagination losing context** - Page 2 loses filters/sort

---

## 2. Form Anti-Patterns

### 2.1 Data Entry Friction
- [ ] **No input masking** - Phone, CC, date formats unclear
- [ ] **Case sensitivity not indicated** - Password fails silently
- [ ] **Required not marked until submit** - Surprise required fields
- [ ] **Clearing form on error** - User loses all input
- [ ] **No autofill support** - Blocks password managers
- [ ] **Arbitrary password rules** - 8-12 chars, must have ∆, no spaces

### 2.2 Validation Pain
- [ ] **Validation only on submit** - User fills entire form, then errors
- [ ] **Validation on every keystroke** - Error appears before user finishes
- [ ] **Vague error messages** - "Invalid input" - what's invalid?
- [ ] **No inline errors** - Error at top, user can't find problem field
- [ ] **Errors disappear before read** - Toast vanishes in 2 seconds
- [ ] **Conflicting validation** - Different rules on edit vs create

### 2.3 Submission Issues
- [ ] **No submit confirmation** - Did it work? User unsure
- [ ] **Double-submit possible** - Button not disabled, duplicates
- [ ] **Submit loses scroll position** - Page jumps to top
- [ ] **No loading state** - Button does nothing, user clicks again
- [ ] **Successful submit unclear** - Subtle message missed

### 2.4 Form Length Issues
- [ ] **All fields on one page** - 50 fields overwhelming
- [ ] **Steps without progress** - Multi-step, no indicator of progress
- [ ] **Steps without save** - Can't continue later
- [ ] **Unnecessary fields** - Collecting data never used
- [ ] **No conditional fields** - Asking irrelevant questions

---

## 3. Feedback Anti-Patterns

### 3.1 Missing Feedback
- [ ] **Click with no response** - Button pressed, nothing happens
- [ ] **Loading with no indicator** - Action started but user doesn't know
- [ ] **Success with no confirmation** - Did the save work?
- [ ] **Error with no message** - Something failed but what?
- [ ] **Background processes hidden** - Sync happening, user unaware

### 3.2 Confusing Feedback
- [ ] **Toast too fast** - Gone before readable
- [ ] **Toast too slow** - Stale information
- [ ] **Feedback far from action** - Message at top, action at bottom
- [ ] **Icon-only feedback** - Green check but no text
- [ ] **Jargon in messages** - "Error: ECONNREFUSED"

### 3.3 Alarming Feedback
- [ ] **Red for non-errors** - Scaring users unnecessarily
- [ ] **Warning fatigue** - Everything is a warning
- [ ] **Confirmation for everything** - "Are you sure?" on every action
- [ ] **Excessive toasts** - Every action spawns notification

---

## 4. Information Architecture Anti-Patterns

### 4.1 Hierarchy Problems
- [ ] **Important buried** - Key action below the fold
- [ ] **Too many CTAs** - Everything is "important"
- [ ] **Visual hierarchy flat** - Can't scan for what matters
- [ ] **Inconsistent placement** - Same action in different places
- [ ] **Orphan content** - Info disconnected from context

### 4.2 Content Overload
- [ ] **Wall of text** - Unbroken paragraphs
- [ ] **No scannable structure** - Missing headers, bullets
- [ ] **Too many choices** - Decision paralysis
- [ ] **Information without context** - Number without meaning
- [ ] **Jargon without explanation** - Assumes expert knowledge

### 4.3 Content Drought
- [ ] **Insufficient guidance** - User left to figure it out
- [ ] **No examples** - Format required but not shown
- [ ] **Missing help text** - Complex field, no explanation
- [ ] **No empty state guidance** - "No data" and nothing else

---

## 5. Interaction Anti-Patterns

### 5.1 Unexpected Behavior
- [ ] **Hover triggers on touch** - Shows on hover, touch can't dismiss
- [ ] **Auto-advance carousel** - Changes while reading
- [ ] **Scroll hijacking** - Custom scroll behavior confuses
- [ ] **Zoom hijacking** - Pinch zoom disabled or broken
- [ ] **Right-click disabled** - Blocks expected behavior
- [ ] **Selection disabled** - Can't copy text

### 5.2 Forced Actions
- [ ] **Must scroll to continue** - Hidden "I agree" at bottom
- [ ] **Artificial delays** - Waiting for no technical reason
- [ ] **Unskippable tutorials** - Can't dismiss intro
- [ ] **Forced account creation** - Guest checkout blocked
- [ ] **Mandatory fields for optional features** - Over-collection

### 5.3 Deceptive Interactions
- [ ] **Opt-out by default** - Newsletter pre-checked
- [ ] **Confirmshaming** - "No thanks, I don't like saving money"
- [ ] **Misdirection** - Big button does wrong thing
- [ ] **Hidden costs** - Price appears at checkout
- [ ] **Roach motel** - Easy to sign up, hard to cancel
- [ ] **Privacy zuckering** - Confusing privacy settings

### 5.4 Broken Expectations
- [ ] **Links that aren't links** - Blue underlined text does nothing
- [ ] **Buttons that look like text** - Clickable but unstyled
- [ ] **Disabled looks enabled** - Can't tell it's inactive
- [ ] **Input looks disabled** - Read-only looks like disabled
- [ ] **Different click targets** - Visual doesn't match clickable

---

## 6. Mobile-Specific Anti-Patterns

### 6.1 Touch Problems
- [ ] **Tiny touch targets** - Buttons too small to tap
- [ ] **Targets too close** - Wrong button tapped easily
- [ ] **Edge targets** - Important buttons at screen edges
- [ ] **Thumb zone ignored** - Key actions require two hands

### 6.2 Mobile Navigation Issues
- [ ] **Hamburger hides everything** - Nothing visible by default
- [ ] **No bottom navigation** - Everything in hamburger
- [ ] **No swipe navigation** - Back gesture not supported
- [ ] **Tabs scroll but unclear** - More tabs hidden

### 6.3 Input Problems
- [ ] **Desktop keyboard on mobile** - No numeric pad for numbers
- [ ] **Keyboard covers input** - Can't see what you're typing
- [ ] **Date picker pain** - No native mobile date picker
- [ ] **Select with many options** - Long dropdown on mobile

### 6.4 Content Problems
- [ ] **Desktop content on mobile** - Not optimized, hard to read
- [ ] **PDF links without warning** - Opens file unexpectedly
- [ ] **Phone numbers not linked** - Can't tap to call
- [ ] **Addresses not linked** - Can't tap to navigate

---

## 7. Performance Anti-Patterns

### 7.1 Loading Issues
- [ ] **No skeleton/placeholder** - Blank while loading
- [ ] **Cumulative layout shift** - Content jumps as it loads
- [ ] **FOUC** - Flash of unstyled content
- [ ] **Slow first paint** - Blank page too long
- [ ] **Spinner of doom** - Endless loading, no timeout

### 7.2 Interaction Lag
- [ ] **Button press delay** - Noticeable wait before response
- [ ] **Scroll jank** - Stuttering while scrolling
- [ ] **Animation drops frames** - Choppy animations
- [ ] **Typing lag** - Input can't keep up with typing

### 7.3 Resource Waste
- [ ] **Autoplaying video** - Bandwidth used without consent
- [ ] **Large images on mobile** - Full desktop images downloaded
- [ ] **Unnecessary requests** - Fetching unused data
- [ ] **Memory leaks** - Page slows over time

---

## 8. Cognitive Load Anti-Patterns

### 8.1 Too Much to Remember
- [ ] **Multi-step without save** - Lose progress if you leave
- [ ] **Reference codes** - "Enter code from step 3"
- [ ] **Information in different tabs** - Need to switch to compare
- [ ] **Instructions disappear** - Shown once, can't review

### 8.2 Too Much to Decide
- [ ] **Choice overload** - Too many options
- [ ] **No defaults** - User must choose everything
- [ ] **Similar options unclear** - Which plan is right?
- [ ] **Comparison tables missing** - Can't compare options

### 8.3 Too Much to Learn
- [ ] **Unique patterns** - Non-standard interactions
- [ ] **Inconsistent terminology** - Same thing, different names
- [ ] **Hidden features** - Useful function hard to discover
- [ ] **Feature creep UI** - Too many features, too prominent

---

## 9. Trust Anti-Patterns

### 9.1 Credibility Issues
- [ ] **No contact information** - Who is behind this?
- [ ] **No privacy policy link** - What happens to my data?
- [ ] **Fake urgency** - "Only 3 left!" (always)
- [ ] **Fake reviews** - Obviously fabricated testimonials
- [ ] **Stock photo people** - Generic "team" photos

### 9.2 Security Perception
- [ ] **Password shown plain text** - No masking option
- [ ] **No HTTPS indicator** - User can't verify security
- [ ] **Asking for too much** - Why do you need my SSN?
- [ ] **Third-party distrust** - Unknown payment processor

### 9.3 Data Handling
- [ ] **Unclear what's saved** - Is draft auto-saved?
- [ ] **No data export** - Can't get your data out
- [ ] **Account deletion hidden** - GDPR violation likely
- [ ] **Data sync unclear** - Did changes save to server?

---

## 10. Error Handling Anti-Patterns

### 10.1 Unhelpful Errors
- [ ] **Technical jargon** - "Error 500: Internal Server Error"
- [ ] **Generic messages** - "Something went wrong"
- [ ] **No next steps** - Error but no recovery path
- [ ] **Blame the user** - "You entered invalid data"

### 10.2 Error Prevention Failures
- [ ] **No confirmation for destructive actions** - Delete with one click
- [ ] **No undo** - Can't recover from mistakes
- [ ] **Ambiguous destructive actions** - "Are you sure?" without details
- [ ] **No draft saving** - Long form loses data on accident

### 10.3 Error Recovery Failures
- [ ] **Back button doesn't work** - Can't undo navigation
- [ ] **Refresh clears state** - Form data lost
- [ ] **Session expires silently** - Discover only when action fails
- [ ] **No retry option** - Must restart entire flow

---

## 11. Accessibility as UX

### 11.1 Inclusivity Issues
- [ ] **Color-only information** - Red means error but colorblind
- [ ] **Small text** - Hard to read for many
- [ ] **Low contrast** - Stylish but unreadable
- [ ] **Complex language** - Excludes non-native speakers

### 11.2 Disability-Hostile
- [ ] **Time limits without extension** - Not everyone is fast
- [ ] **CAPTCHA only visual** - Blind users blocked
- [ ] **Audio only** - Deaf users excluded
- [ ] **Animation required** - Vestibular issues triggered

---

## 12. Dark Patterns Checklist

### 12.1 Deceptive Patterns
- [ ] **Trick questions** - Double negatives, confusing wording
- [ ] **Sneak into basket** - Items added without consent
- [ ] **Hidden costs** - Fees revealed late in process
- [ ] **Bait and switch** - Different product than advertised
- [ ] **Forced continuity** - Trial becomes paid without warning

### 12.2 Manipulative Patterns
- [ ] **Confirmshaming** - Guilt trip for opting out
- [ ] **Urgency/scarcity** - Fake limited time/quantity
- [ ] **Social proof manipulation** - "5 people viewing" (fake)
- [ ] **Emotion exploitation** - Fear-based messaging

### 12.3 Obstruction Patterns
- [ ] **Roach motel** - Easy in, hard out
- [ ] **Price comparison prevention** - Hard to compare
- [ ] **Misdirection** - Attention drawn from important info
- [ ] **Privacy maze** - Settings hidden and complex

---

## Scanning Commands

```bash
# Find potential dark patterns
grep -rn "limited time\|only [0-9]* left\|act now\|don't miss" --include="*.tsx" --include="*.jsx" --include="*.html"

# Find confirmshaming language
grep -rn "No thanks\|I don't want\|I'll pass" --include="*.tsx" --include="*.jsx"

# Find pre-checked options
grep -rn "defaultChecked\|checked={true}\|defaultValue.*true" --include="*.tsx" --include="*.jsx"

# Find forced scrolling
grep -rn "overflow.*hidden\|scrollTo\|scrollIntoView" --include="*.tsx" --include="*.jsx" --include="*.ts"

# Find disabled user actions
grep -rn "preventDefault\|user-select.*none\|pointer-events.*none" --include="*.tsx" --include="*.jsx" --include="*.css"

# Find unclear error messages
grep -rn "error\|Error\|wrong\|invalid\|failed" --include="*.tsx" --include="*.jsx" | grep -i "message\|text\|content"
```

---

## User Journey Audit

For EACH critical user journey:

1. **Identify the journey** - What is the user trying to accomplish?
2. **Map every step** - Document each screen/interaction
3. **Time the journey** - How long does it take?
4. **Count the clicks** - How many interactions required?
5. **Find the friction** - Where does user pause, backtrack, or fail?
6. **Test on mobile** - Is it equally smooth?
7. **Test first-time user** - Pretend you've never seen this

### Key Journeys to Audit

- [ ] Sign up / registration
- [ ] Sign in / authentication
- [ ] Password reset
- [ ] Complete primary task (whatever the app does)
- [ ] Find help / support
- [ ] Update profile / settings
- [ ] Delete account / data
- [ ] Recover from error
- [ ] Complete a purchase (if applicable)
- [ ] Share content (if applicable)

---

## Heuristic Evaluation Quick Check

For each screen, rate 1-5 on Nielsen's heuristics:

1. **Visibility of system status** - User knows what's happening?
2. **Match with real world** - Language and concepts familiar?
3. **User control and freedom** - Easy to undo/escape?
4. **Consistency and standards** - Follows conventions?
5. **Error prevention** - Design prevents mistakes?
6. **Recognition over recall** - Minimizes memory load?
7. **Flexibility and efficiency** - Works for novice and expert?
8. **Aesthetic and minimal design** - No irrelevant info?
9. **Help users with errors** - Errors explained, solutions given?
10. **Help and documentation** - Available when needed?
