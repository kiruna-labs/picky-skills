# Edge Case & Chaos Testing Checklist

## Testing Philosophy

**Users will do things you never imagined.** They'll click buttons 47 times. They'll submit forms with 10,000 character names. They'll open your app in 2007 Internet Explorer (okay, maybe not). Your job is to do all the weird things so you find the bugs before they do.

---

## 1. Speed Chaos

### 1.1 Rapid Clicking

- [ ] **Click button 5 times quickly**
  - Does it trigger 5 times? Should it?
  - Is the button disabled after first click?
  - Any duplicate submissions?

- [ ] **Double-click everything**
  - Submit buttons
  - Links
  - Toggles
  - Accordions

- [ ] **Click during loading**
  - While page is loading
  - While form is submitting
  - While data is fetching

### 1.2 Rapid Typing

- [ ] **Type very fast**
  - Does the input keep up?
  - Any lag or dropped characters?

- [ ] **Paste large amounts of text**
  - 1,000 characters
  - 10,000 characters
  - 100,000 characters

- [ ] **Type while submitting**
  - Does it affect the submission?
  - Does the form lock?

### 1.3 Rapid Navigation

- [ ] **Click link, immediately click another**
  - Any race conditions?
  - Pages fighting each other?

- [ ] **Rapidly hit back/forward**
  - State corruption?
  - Errors?

---

## 2. Boundary Values

### 2.1 Text Length

For every text input:

| Value | Test |
|-------|------|
| Empty | No characters at all |
| Single | 1 character: "a" |
| Min | Exactly at minimum length |
| Min-1 | One below minimum |
| Max | Exactly at maximum length |
| Max+1 | One above maximum |
| Huge | 10,000+ characters |

- [ ] **How does the UI handle overflow?**
  - Truncation?
  - Scrolling?
  - Line wrapping?
  - Breaks layout?

### 2.2 Numeric Values

For every number input:

| Value | Test |
|-------|------|
| 0 | Zero |
| -1 | Negative one |
| -999999 | Large negative |
| 0.5 | Decimal |
| 0.001 | Tiny decimal |
| 999999999 | Very large |
| NaN | Not a number |
| Infinity | Mathematical infinity |

- [ ] **How does the UI handle extremes?**
  - Overflow display?
  - Scientific notation?
  - Error messages?

### 2.3 Date/Time Values

| Value | Test |
|-------|------|
| Today | Current date |
| Yesterday | One day ago |
| Tomorrow | One day ahead |
| Far past | 01/01/1900 |
| Far future | 12/31/2099 |
| Leap day | 02/29/2024 |
| Invalid | 02/30/2024 |
| Timezone edge | 00:00, 23:59 |

### 2.4 Quantity Values

| Value | Test |
|-------|------|
| 0 items | Empty list |
| 1 item | Single item |
| 2 items | Few items |
| 10 items | Several items |
| 100 items | Many items |
| 1000 items | Lots of items |
| 10000 items | Stress test |

---

## 3. Special Characters

### 3.1 Character Categories to Test

```
Basic punctuation: . , ! ? ; : ' " - _
Math symbols: + = * / < > % ^ & |
Brackets: ( ) [ ] { } < >
Currency: $ € £ ¥ ₹
Special: @ # ~ ` \ | /
Quotes: ' ' " " „ « »
Emoji: 😀 🎉 ❤️ 🔥 👍 💯
Unicode: é ñ ü ß ø å 中文 العربية
Zero-width: ​ (zero-width space)
Newlines: \n \r \r\n
Tabs: \t
```

### 3.2 Where to Test

- [ ] All text inputs
- [ ] Search fields
- [ ] Usernames
- [ ] Passwords
- [ ] Comments/descriptions
- [ ] File names (upload)
- [ ] URL parameters

### 3.3 What to Watch For

- [ ] Characters display correctly?
- [ ] Characters save correctly?
- [ ] Characters show correctly after save?
- [ ] No XSS vulnerability? (script tags rendered as text?)
- [ ] No SQL errors? (quotes handled?)
- [ ] Layout doesn't break?

---

## 4. Empty States

### 4.1 Empty Input Scenarios

- [ ] **Submit form with all fields empty**
  - Proper validation?
  - Clear error messages?

- [ ] **Clear a filled field before submit**
  - Validation triggers?
  - Field marked as touched?

- [ ] **Submit with only whitespace**
  - Treated as empty?
  - Trimmed?

### 4.2 Empty Data Scenarios

- [ ] **New account with no data**
  - Empty state messaging?
  - Getting started guidance?

- [ ] **Delete all items**
  - Returns to empty state?
  - Can add new items?

- [ ] **Search with no results**
  - Clear "no results" message?
  - Suggestions?

- [ ] **Filter to zero results**
  - Clear messaging?
  - Easy to clear filters?

---

## 5. Interruption Testing

### 5.1 Browser Interruptions

- [ ] **Refresh during form fill**
  - Data lost?
  - Warning shown?
  - Data preserved? (auto-save)

- [ ] **Close tab during action**
  - Confirmation dialog?
  - Data lost gracefully?

- [ ] **Navigate away during submit**
  - Submission completes?
  - Partial state corruption?

### 5.2 Network Interruptions

```
Use mcp__chrome-devtools__emulate with networkConditions: "Offline"
```

- [ ] **Go offline during page load**
  - Graceful error?
  - Retry available?

- [ ] **Go offline during form submit**
  - Clear error message?
  - Data preserved?
  - Retry option?

- [ ] **Go offline, do actions, go back online**
  - Actions sync?
  - Conflicts resolved?

### 5.3 Session Interruptions

- [ ] **Session expires during use**
  - Graceful redirect?
  - Current work preserved?
  - Clear message?

- [ ] **Open in two tabs, logout in one**
  - Other tab handles it?
  - No confusing errors?

---

## 6. Concurrent User Testing

### 6.1 Multi-Tab Testing

- [ ] **Open same page in two tabs**
  - Both work correctly?
  - Data syncs between them?

- [ ] **Edit same item in two tabs**
  - Last save wins?
  - Conflict resolution?
  - Clear messaging?

- [ ] **Login in two tabs**
  - Same session?
  - No conflicts?

- [ ] **Logout in one tab, act in other**
  - Other tab realizes?
  - No errors?

### 6.2 State Conflicts

- [ ] **Action in tab A, stale data in tab B**
  - Tab B updates?
  - Or shows stale?

- [ ] **Delete item in tab A, view in tab B**
  - Tab B handles missing item?
  - Clear error?

---

## 7. Browser Variations

### 7.1 Viewport Extremes

```
Use mcp__chrome-devtools__resize_page
```

| Size | Test |
|------|------|
| 320x480 | Very small mobile |
| 375x667 | Standard mobile |
| 768x1024 | Tablet |
| 1024x768 | Small landscape |
| 1920x1080 | Standard desktop |
| 2560x1440 | Large desktop |
| 3840x2160 | 4K |
| 400x2000 | Very tall |
| 2000x400 | Very wide |

### 7.2 Zoom Levels

- [ ] **90% zoom**
- [ ] **100% zoom (baseline)**
- [ ] **110% zoom**
- [ ] **125% zoom**
- [ ] **150% zoom**
- [ ] **200% zoom**

Things to check:
- Text readable?
- Buttons clickable?
- No overlap?
- No clipping?
- Scroll works?

### 7.3 Text Scaling

- [ ] **Large system font size**
  - Text scales appropriately?
  - Layout survives?

---

## 8. Performance Stress

### 8.1 Slow Everything

```
Use mcp__chrome-devtools__emulate with:
- networkConditions: "Slow 3G"
- cpuThrottlingRate: 4
```

- [ ] **All actions still work**
- [ ] **Loading indicators appear**
- [ ] **Timeouts handled gracefully**
- [ ] **No race conditions exposed**

### 8.2 Rapid Actions Under Stress

- [ ] **Rapid clicks while throttled**
- [ ] **Form submit while throttled**
- [ ] **Navigation while throttled**

### 8.3 Memory/Resource Stress

- [ ] **Leave page open for extended period**
  - Memory leaks?
  - Performance degrades?

- [ ] **Repeated actions many times**
  - Page slows down?
  - Memory grows?

---

## 9. Input Method Chaos

### 9.1 Keyboard Chaos

- [ ] **Mash random keys**
  - Any crashes?
  - Any unexpected actions?

- [ ] **Hold keys down**
  - Repeating input handled?
  - Any stuck states?

- [ ] **Key combos (Ctrl+everything)**
  - Any unexpected shortcuts?
  - Browser defaults respected?

### 9.2 Mouse Chaos

- [ ] **Click everywhere rapidly**
- [ ] **Right-click everywhere**
- [ ] **Middle-click links**
- [ ] **Scroll aggressively**
- [ ] **Click-drag everywhere**

### 9.3 Touch Chaos (Mobile)

- [ ] **Tap rapidly**
- [ ] **Two-finger tap**
- [ ] **Pinch zoom**
- [ ] **Swipe in all directions**
- [ ] **Long press**

---

## 10. Security Edge Cases

**Note: Observe behavior only, don't actually exploit**

### 10.1 Input Injection Strings

Test how these render/save:

```html
<script>alert('test')</script>
<img src=x onerror=alert('test')>
javascript:alert('test')
'; DROP TABLE users; --
${7*7}
{{constructor.constructor('return this')()}}
```

### 10.2 URL Manipulation

- [ ] **Add unexpected query params**
  - ?admin=true
  - ?debug=true
  - ?secret=exposed

- [ ] **Modify IDs in URLs**
  - /user/1 → /user/2
  - /order/123 → /order/124

### 10.3 Direct API Access

- [ ] **Try to access without login**
  - Protected pages redirect?
  - API calls fail properly?

---

## 11. Error Recovery

### 11.1 From User Errors

- [ ] **Fill form wrong, can correct**
- [ ] **Navigate wrong, can go back**
- [ ] **Delete wrong item, can undo**
- [ ] **Submit twice, handled gracefully**

### 11.2 From System Errors

- [ ] **Server error - clear message**
- [ ] **Network error - retry option**
- [ ] **Timeout - recovery path**
- [ ] **Crash - state preserved**

---

## 12. Unexpected Scenarios

### 12.1 User Behavior

- [ ] **Start process, leave for 30 min, return**
- [ ] **Start process, close laptop, reopen**
- [ ] **Start on mobile, continue on desktop**
- [ ] **Share URL with friend**
- [ ] **Bookmark mid-process**

### 12.2 Data Scenarios

- [ ] **User with special name** (O'Brien, 田中)
- [ ] **User with very long name**
- [ ] **User with single character name**
- [ ] **User changes timezone**
- [ ] **User in non-English locale**

---

## Edge Case Documentation Template

```markdown
## Edge Case: [Scenario]

**Test**:
[What you did]

**Expected**:
[What should happen]

**Actual**:
[What actually happened]

**Severity**: [Crash / Broken / Degraded / Cosmetic]

**Steps to Reproduce**:
1. [Step 1]
2. [Step 2]

**Screenshot/Evidence**: [If applicable]
```

---

## Remember

The goal of chaos testing is to find bugs before users do. Users will:
- Press buttons at the wrong time
- Enter data you didn't expect
- Use devices you didn't test on
- Have network conditions you didn't simulate
- Do things in orders you didn't anticipate

**If it can break, break it yourself first.**
