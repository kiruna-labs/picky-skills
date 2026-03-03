# Form Testing Checklist

## Testing Philosophy

**Forms are where users give you their data and trust.** Every form field is a potential failure point. Every validation message is a conversation with the user. Every submit button is a promise. Test them like your users depend on it - because they do.

---

## 1. Field-by-Field Testing

### 1.1 Text Input Fields

For EACH text input:

**Basic Functionality:**
- [ ] Can type in the field
- [ ] Can see what was typed
- [ ] Can select and delete text
- [ ] Can paste text
- [ ] Can clear the field

**Boundary Testing:**
- [ ] Empty field - what happens on submit?
- [ ] Single character
- [ ] Exactly at minimum length (if specified)
- [ ] One below minimum length
- [ ] One above maximum length
- [ ] Extremely long input (1000+ characters)

**Special Characters:**
- [ ] Spaces (leading, trailing, multiple)
- [ ] Special chars: !@#$%^&*()_+-=[]{}|;':",.<>?/`~
- [ ] Unicode: é, ñ, ü, ß, 中文, العربية, 🎉
- [ ] HTML entities: &lt; &gt; &amp;
- [ ] Newlines (if should be single line)
- [ ] Tab characters

**Edge Cases:**
- [ ] Very fast typing
- [ ] Copy-paste large text
- [ ] Drag-and-drop text (if applicable)
- [ ] Autocomplete suggestions (if applicable)

### 1.2 Email Fields

- [ ] Valid email: test@example.com ✓
- [ ] Without @ symbol: testexample.com
- [ ] Without domain: test@
- [ ] Without TLD: test@example
- [ ] Multiple @ symbols: test@@example.com
- [ ] Spaces in email: test @example.com
- [ ] Special chars before @: test+tag@example.com
- [ ] Very long email: aaaa...@example.com (100+ chars)
- [ ] Subdomain: test@mail.example.com
- [ ] New TLDs: test@example.photography
- [ ] Internationalized: test@例え.jp

### 1.3 Password Fields

- [ ] Characters are masked (dots/asterisks)
- [ ] Show/hide toggle works (if exists)
- [ ] Can paste into password field
- [ ] Minimum length validation
- [ ] Maximum length (if any)
- [ ] Complexity requirements shown clearly
- [ ] Complexity requirements validated correctly
- [ ] Spaces allowed?
- [ ] Common passwords rejected? (if applicable)
- [ ] Password strength indicator (if exists)
- [ ] Confirm password matches

### 1.4 Number Fields

- [ ] Only accepts numbers
- [ ] Decimal allowed? (if appropriate)
- [ ] Negative numbers allowed? (if appropriate)
- [ ] Leading zeros handled
- [ ] Very large numbers (999999999999)
- [ ] Very small numbers (0.0000001)
- [ ] Scientific notation (1e10)
- [ ] Min/max validation
- [ ] Increment/decrement buttons (if exist)
- [ ] Keyboard up/down arrows

### 1.5 Phone Number Fields

- [ ] Local format: (555) 123-4567
- [ ] International format: +1-555-123-4567
- [ ] With extension: 555-123-4567 x123
- [ ] Spaces vs dashes vs dots
- [ ] Auto-formatting (if exists)
- [ ] Too few digits
- [ ] Too many digits
- [ ] Letters in phone number

### 1.6 Date Fields

**If date picker:**
- [ ] Picker opens on click
- [ ] Picker opens on focus
- [ ] Can select date
- [ ] Can navigate months
- [ ] Can navigate years
- [ ] Today highlighted
- [ ] Selected date highlighted
- [ ] Invalid dates disabled (if applicable)
- [ ] Future dates allowed/blocked appropriately
- [ ] Past dates allowed/blocked appropriately
- [ ] Picker closes after selection
- [ ] Picker closes on outside click
- [ ] Keyboard navigation works

**If text input:**
- [ ] Expected format shown (placeholder or label)
- [ ] Various formats accepted?
- [ ] Invalid date rejected (2/30/2024)
- [ ] Leap year handled (2/29/2024)
- [ ] Two-digit year (24 vs 2024)

### 1.7 Dropdown/Select Fields

- [ ] Click opens dropdown
- [ ] Focus opens dropdown (accessibility)
- [ ] Can scroll through options
- [ ] Can select option by click
- [ ] Can select option by keyboard (Enter)
- [ ] Can type to filter/jump (type-ahead)
- [ ] Arrow keys navigate options
- [ ] Selected option shows after close
- [ ] Can change selection
- [ ] Placeholder/default shown when empty
- [ ] Very long option text handled
- [ ] Many options (100+) performs well

### 1.8 Checkbox Fields

- [ ] Click toggles state
- [ ] Label click toggles state
- [ ] Keyboard Space toggles state
- [ ] Visual state matches actual state
- [ ] Checked by default (if specified)
- [ ] Unchecked by default (if specified)
- [ ] Required validation (if applicable)
- [ ] Indeterminate state (if applicable)

### 1.9 Radio Button Fields

- [ ] Click selects option
- [ ] Label click selects option
- [ ] Keyboard selects (arrow keys)
- [ ] Only one selected at a time
- [ ] Can change selection
- [ ] Pre-selected default (if specified)
- [ ] Required validation
- [ ] Arrow keys cycle through options

### 1.10 File Upload Fields

- [ ] Click opens file dialog
- [ ] Can select file
- [ ] File name shows after selection
- [ ] Can remove/change file
- [ ] File type restrictions work
- [ ] File size limit enforced
- [ ] Multiple files (if allowed)
- [ ] Drag and drop works (if supported)
- [ ] Progress shown during upload (if applicable)
- [ ] Error handling for failed upload

### 1.11 Textarea Fields

- [ ] Multi-line input works
- [ ] Enter creates new line
- [ ] Scrolls when content exceeds height
- [ ] Resize handle works (if applicable)
- [ ] Character count shown (if applicable)
- [ ] Limit enforced (if applicable)
- [ ] Preserves line breaks on submit
- [ ] Handles very long single line

---

## 2. Form-Level Testing

### 2.1 Validation Timing

- [ ] **On blur** - Validates when leaving field
- [ ] **On change** - Validates while typing
- [ ] **On submit** - Validates when submitting
- [ ] **Consistent** - Same timing for all fields

### 2.2 Error Display

- [ ] Errors appear in consistent location
- [ ] Errors are visually distinct (color, icon)
- [ ] Error text is specific and helpful
- [ ] Multiple errors per field (if applicable)
- [ ] Errors clear when fixed
- [ ] Focus moves to first error on submit

### 2.3 Submit Behavior

- [ ] Submit button clearly labeled
- [ ] Submit button accessible (Tab + Enter)
- [ ] Loading state during submission
- [ ] Button disabled during submission
- [ ] Double-submit prevented
- [ ] Success message/feedback shown
- [ ] Error message if submission fails
- [ ] Form clears after success (if appropriate)
- [ ] Form retains data after error
- [ ] Redirect after success (if appropriate)

### 2.4 Reset/Cancel Behavior

- [ ] Reset button clears all fields
- [ ] Reset shows confirmation (if destructive)
- [ ] Cancel navigates away appropriately
- [ ] Unsaved changes warning (if applicable)

---

## 3. Form State Testing

### 3.1 Page Refresh

- [ ] Data persists after refresh? (if should)
- [ ] Data clears after refresh? (if should)
- [ ] Validation state persists?
- [ ] Dirty state persists?

### 3.2 Navigation Away

- [ ] Warning if unsaved changes? (if should)
- [ ] Data lost on navigation? (expected?)
- [ ] Can return and data still there? (if should)

### 3.3 Session Timeout

- [ ] Form still submits after long idle?
- [ ] Graceful handling if session expired?
- [ ] Data preserved or lost?

---

## 4. Multi-Step Form Testing

If form has multiple steps/pages:

- [ ] Step indicator shows current position
- [ ] Can navigate to previous step
- [ ] Data preserved going forward
- [ ] Data preserved going backward
- [ ] Validation per step (not just at end)
- [ ] Final review step (if applicable)
- [ ] Can edit from review
- [ ] Progress saved on refresh (if applicable)
- [ ] Clear path to completion
- [ ] Step skipping handled (if allowed/prevented)

---

## 5. Accessibility Testing

- [ ] All fields have visible labels
- [ ] Labels linked to fields (click label focuses field)
- [ ] Required fields indicated visually
- [ ] Required fields indicated to screen readers
- [ ] Error messages linked to fields (aria-describedby)
- [ ] Tab order is logical
- [ ] Focus visible on all fields
- [ ] Instructions available before form
- [ ] Submit accessible via keyboard

---

## 6. Chaos Testing

Do things users "shouldn't" do:

- [ ] Submit immediately without filling anything
- [ ] Fill field, clear it, submit
- [ ] Change value rapidly back and forth
- [ ] Click submit while still typing
- [ ] Click submit multiple times quickly
- [ ] Open form in two tabs, submit both
- [ ] Start typing, paste over, then type more
- [ ] Tab through entire form without entering data
- [ ] Fill form, refresh, check state
- [ ] Fill form, navigate away, come back

---

## 7. Data Quality Checks

After successful submission:

- [ ] Data saved matches what was entered
- [ ] Trimmed whitespace handled correctly
- [ ] Case preserved/transformed correctly
- [ ] Special characters preserved
- [ ] Data visible in success/confirmation
- [ ] Data retrievable/editable

---

## Test Data Templates

### Valid Test Data
```
Name: Jane Doe
Email: jane.doe@example.com
Phone: (555) 123-4567
Password: SecurePass123!
Address: 123 Main Street, Apt 4B
City: Springfield
State: Illinois
Zip: 62701
Country: United States
Date: 01/15/1990
```

### Edge Case Test Data
```
Name: José García-López
Email: test+filter@sub.example.co.uk
Phone: +1-555-123-4567 x9999
Password: 🔐Secret™Pass¥¢€!@#$%
Address: 1/2 Straße mit Ümlauts, 北京市
City: Llanfairpwllgwyngyllgogerychwyrndrobwllllantysiliogogogoch
Zip: SW1A 1AA
Country: Côte d'Ivoire
Date: 02/29/2024
```

### Malicious Test Data (observe handling, don't exploit)
```
Name: <script>alert('XSS')</script>
Email: test@example.com'; DROP TABLE users; --
Password: ' OR '1'='1
Address: {{template}}
City: ${process.env.SECRET}
Notes: <img src=x onerror=alert('XSS')>
```

---

## Common Form Issues to Watch For

1. **Required field not enforced** - Can submit without it
2. **Validation mismatch** - Frontend says OK, server says no
3. **Error message unclear** - "Invalid" without explanation
4. **Error persists after fix** - Fixed field still shows error
5. **Focus not managed** - After error, focus doesn't move
6. **Data loss on error** - Form clears when server rejects
7. **Double submission** - Button not disabled, duplicates created
8. **No loading feedback** - User unsure if submission started
9. **Success without feedback** - Did it work? Who knows
10. **Timeout without warning** - Session expires, data lost
