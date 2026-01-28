# User Confusion Testing Checklist

## Testing Philosophy

**You are someone's grandmother using this app for the first time.** You don't know tech jargon. You don't know what icons mean. You don't know "how apps work." Everything that isn't crystal clear is a potential point of confusion. Every confusion point is a finding.

---

## 1. First Impressions (0-5 seconds)

When landing on any page, ask:

### 1.1 What is This?
- [ ] **Can I tell what this app/page is for?**
  - Is there a clear headline?
  - Is there a description?
  - Would I know what to do here?

- [ ] **Why should I care?**
  - Is the value proposition clear?
  - What problem does this solve?
  - Why would I use this instead of something else?

### 1.2 Where Do I Start?
- [ ] **Is there a clear primary action?**
  - One obvious button/link to click?
  - Or too many competing for attention?
  - Or none at all?

- [ ] **What should I do first?**
  - Is there onboarding/guidance?
  - Are there instructions?
  - Am I left to figure it out?

### 1.3 Visual Confusion
- [ ] **Is the page overwhelming?**
  - Too much text?
  - Too many buttons?
  - Too many colors?
  - Too much movement?

- [ ] **Is the page underwhelming?**
  - Feels empty?
  - Important things hidden?
  - Not sure what to look at?

---

## 2. Label and Text Confusion

### 2.1 Button Labels
For EVERY button, ask:

- [ ] **What will happen if I click this?**
  - "Submit" - Submit what?
  - "Continue" - Continue to where?
  - "OK" - OK what?
  - "Next" - Next what happens?

- [ ] **Could this be more specific?**
  - "Submit" → "Create Account"
  - "Send" → "Send Message"
  - "Save" → "Save Changes"
  - "Delete" → "Delete This Item"

### 2.2 Link Text
For EVERY link, ask:

- [ ] **Where does this go?**
  - "Click here" - Here where?
  - "Read more" - Read more about what?
  - "Learn more" - Learn more about what?

- [ ] **Is the destination obvious from the text?**
  - "Pricing" - goes to pricing page (clear)
  - "Find out" - goes to... ? (unclear)

### 2.3 Form Labels
For EVERY form field:

- [ ] **What goes in here?**
  - Is the label clear?
  - Is there helper text?
  - Is there an example?

- [ ] **Is this required?**
  - Are required fields marked?
  - Are optional fields marked?
  - Will I find out when I submit?

- [ ] **What format should I use?**
  - Date: MM/DD/YYYY or DD/MM/YYYY?
  - Phone: With dashes? With parentheses?
  - Does it show the expected format?

### 2.4 Error Messages
For EVERY error:

- [ ] **What went wrong?**
  - "Invalid input" - What's invalid?
  - "Error" - What error?
  - "Please fix the errors" - Which errors?

- [ ] **How do I fix it?**
  - Does it tell me what to do?
  - Does it point to the problem?
  - Or am I left guessing?

### 2.5 Success Messages
For EVERY success:

- [ ] **Did it work?**
  - Is there confirmation?
  - Is the confirmation visible?
  - Did it disappear too fast?

- [ ] **What happens now?**
  - What's my next step?
  - Where's my thing I just created?
  - Am I done or is there more?

---

## 3. Icon Confusion

### 3.1 Icon Meaning
For EVERY icon:

- [ ] **What does this icon mean?**
  - Is it universally understood? (home, search, close)
  - Or app-specific? (custom icons)
  - Or could mean multiple things?

- [ ] **Is there a label?**
  - Text label visible?
  - Tooltip on hover?
  - Or icon alone?

- [ ] **Would my grandmother know what it does?**
  - Three lines = menu (maybe)
  - Gear = settings (maybe)
  - Abstract shape = who knows

### 3.2 Icon-Only Actions
For buttons/links with only icons:

- [ ] **Would I click this?**
  - Is the meaning clear?
  - Is there hover/tooltip?
  - Is it accessible (aria-label)?

- [ ] **Do similar actions look similar?**
  - All delete buttons use same icon?
  - All edit buttons use same icon?
  - Consistency across the app?

---

## 4. Terminology Confusion

### 4.1 Jargon Check
For EVERY piece of text:

- [ ] **Would a normal person understand this?**
  - Technical terms explained?
  - Industry jargon avoided?
  - Abbreviations spelled out?

Examples of confusing terms:
- "API" → "Connect other apps"
- "OAuth" → "Sign in with..."
- "Webhook" → "Automatic notification"
- "CRUD" → (never show this to users)
- "Modal" → "popup window"

### 4.2 Consistency Check
- [ ] **Is the same thing called the same thing everywhere?**
  - Account vs Profile vs Settings
  - Order vs Purchase vs Transaction
  - Item vs Product vs Thing

- [ ] **Are similar things distinguished clearly?**
  - Save vs Save As vs Publish
  - Delete vs Archive vs Remove
  - Cancel vs Close vs Back

---

## 5. Flow Confusion

### 5.1 Where Am I?

- [ ] **Do I know where I am in the app?**
  - Breadcrumbs?
  - Active nav item?
  - Page title?
  - URL makes sense?

### 5.2 How Did I Get Here?

- [ ] **Do I understand how I got to this page?**
  - Logical from previous action?
  - Unexpected redirect?
  - Lost context?

### 5.3 Where Can I Go?

- [ ] **Do I know what my options are?**
  - Clear navigation?
  - Obvious next steps?
  - Way to go back?

### 5.4 How Do I Leave?

- [ ] **Can I get out of this?**
  - Cancel button?
  - Back navigation?
  - Close button?
  - Escape key?

---

## 6. Process Confusion

### 6.1 Multi-Step Processes

- [ ] **How many steps are there?**
  - Step indicator?
  - Progress bar?
  - "Step 2 of 5"?

- [ ] **What step am I on?**
  - Current step highlighted?
  - Previous steps shown as complete?
  - Future steps shown?

- [ ] **Can I go back?**
  - Previous step button?
  - Will I lose data?
  - Confirmation before losing work?

- [ ] **What information do I need?**
  - Requirements stated upfront?
  - Surprise requirements later?
  - Can I gather what I need?

### 6.2 Timing Confusion

- [ ] **How long will this take?**
  - Estimated time shown?
  - Number of steps shown?
  - Length of form indicated?

- [ ] **Is something happening?**
  - Loading indicators?
  - Progress feedback?
  - Or just waiting?

- [ ] **When is it done?**
  - Clear completion message?
  - What happens next?
  - Where is my result?

---

## 7. State Confusion

### 7.1 Current State

- [ ] **What is the current state of things?**
  - Is this draft or published?
  - Is this enabled or disabled?
  - Is this public or private?
  - Is this saved or unsaved?

### 7.2 Changes

- [ ] **Have I made changes?**
  - Dirty indicator?
  - Unsaved changes warning?
  - Comparison to original?

- [ ] **Are my changes saved?**
  - Auto-save indicator?
  - Last saved timestamp?
  - Need to click save?

### 7.3 Syncing

- [ ] **Is my data up to date?**
  - Sync status indicator?
  - Last updated timestamp?
  - Offline indicator?

---

## 8. Permission Confusion

### 8.1 What Can I Do?

- [ ] **What actions are available to me?**
  - Buttons visible but disabled - why?
  - Features hidden - are they there?
  - Error when trying - why not allowed?

### 8.2 Why Can't I?

- [ ] **If an action is blocked, is it clear why?**
  - Missing permissions explained?
  - Upgrade path shown?
  - Contact admin option?

---

## 9. Cost Confusion

### 9.1 Free vs Paid

- [ ] **What's free and what costs money?**
  - Clear pricing page?
  - Free features marked?
  - Premium features marked?
  - No surprise paywalls?

### 9.2 Before Purchase

- [ ] **What am I paying for?**
  - Features listed?
  - Limitations clear?
  - Trial available?

### 9.3 Pricing Clarity

- [ ] **How much does it cost?**
  - Price visible?
  - One-time vs recurring?
  - Per user vs per team?
  - Monthly vs annual?
  - Currency shown?

---

## 10. Empty State Confusion

### 10.1 First-Time Empty

- [ ] **Why is this empty?**
  - New user, no data yet
  - Is that explained?

- [ ] **How do I fill it?**
  - Call to action to add first item?
  - Getting started guide?
  - Example content?

### 10.2 Filtered Empty

- [ ] **Why are there no results?**
  - Search yielded nothing
  - Filters too restrictive
  - Is that explained?

- [ ] **How do I fix it?**
  - Clear filters suggestion?
  - Try different search?
  - Contact support?

### 10.3 Deleted Empty

- [ ] **Where did everything go?**
  - All items deleted
  - Is that explained?
  - Way to restore?

---

## 11. Help Confusion

### 11.1 Finding Help

- [ ] **How do I get help?**
  - Help link visible?
  - Help icon present?
  - FAQ available?
  - Contact option?

### 11.2 Contextual Help

- [ ] **Is help available where I need it?**
  - Tooltips on complex fields?
  - Help text near confusing elements?
  - Learn more links?

### 11.3 Help Quality

- [ ] **Is the help actually helpful?**
  - Answers my question?
  - Uses language I understand?
  - Shows examples?
  - Up to date?

---

## Confusion Documentation Template

For each point of confusion:

```markdown
## Confusion Point: [Brief Description]

**Location**: [Page/Section]
**Severity**: Critical / Major / Minor

**The User Sees**:
[What is displayed]

**The User Thinks**:
[What they might assume/expect]

**The Reality Is**:
[What actually happens/means]

**Suggested Fix**:
[How to clarify]

**Screenshot**: [If applicable]
```

---

## Confusion Severity

| Severity | Definition | Example |
|----------|------------|---------|
| **Critical** | User cannot complete their goal | No clear way to submit form |
| **Major** | User must guess or experiment | Icon-only buttons with no labels |
| **Minor** | User might pause or wonder | Slightly unclear wording |
| **Note** | User might not notice | Best practice improvement |

---

## Questions to Keep Asking

As you test, constantly ask:

1. **What is this?** - Do I understand what I'm looking at?
2. **Why is this?** - Do I understand why it's here?
3. **What now?** - Do I know what to do?
4. **Did it work?** - Do I know if my action succeeded?
5. **What next?** - Do I know where to go from here?

If the answer to any of these is "I'm not sure" - **that's a finding.**
