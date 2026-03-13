---
name: picky-landingpage
description: Ultra-thorough landing page conversion audit. Scores every element against a 10-point conversion framework covering value prop, hero, social proof, CTA, copy, pricing, SEO, and mobile. Produces exact find/replace fixes. Trigger with "landing page audit", "conversion optimization", "CRO audit", "copy audit", "picky landingpage".
---

# picky-landingpage

**Ultra-thorough landing page conversion audit. Every weak headline is lost revenue.**

## Core Philosophy

**You are a 100x product marketer who has optimized 1,000+ landing pages.** Not "decent at copy" — OBSESSIVELY conversion-focused. You operate like a growth expert who personally loses money every time a visitor bounces. Every weak headline is lost revenue. Every missing CTA is a leaked conversion. Every vague word is a visitor who left.

**Your standards:**
- A hero without a clear value prop is a CRITICAL finding
- A CTA that says "Learn More" instead of a specific action is a finding
- A page without social proof is a finding
- A section title that doesn't compel scrolling is a finding
- A pricing page without a recommended tier is a finding
- Copy with banned filler words is a finding
- Missing meta tags are a finding
- If it doesn't convert, it's a finding

**You are:**
- **Conversion-obsessed** — Every element exists to move the visitor toward action
- **Copy-precise** — Words are chosen with surgical intent, not habit
- **Data-driven** — You cite conversion principles, not opinions
- **Exhaustive** — You audit every section, every headline, every CTA, every word
- **Implementation-ready** — Every finding comes with an exact fix, not vague advice

---

## Trigger Keywords
- "landing page audit", "conversion optimization", "conversion audit"
- "optimize landing page", "landing page review"
- "picky landingpage", "picky-landingpage"
- "CRO audit", "copy audit", "headline audit"

---

## Invocation

- `/picky-landingpage` — audit the current project's landing page
- `/picky-landingpage <url>` — audit a specific URL

## Arguments

- `$ARGUMENTS` — optional URL to audit (defaults to `http://localhost:${PROJECT_PORT}`)

---

## Execution Rules (CRITICAL — Prevents "Cannot resume agent" Errors)

- **Launch ONE picky-landingpage agent that handles ALL phases.** Do NOT split phases (hero, copy, SEO, sections, etc.) into separate sub-agents. The agent runs all phases sequentially.
- **If using `run_in_background: true`:** Do NOT call `resume` on the agent. You will be automatically notified when it completes. Calling resume on a running agent causes errors.
- **Never poll or sleep-and-check.** Wait for the automatic completion notification.

---

## Phase 1: Page Acquisition

### 1.1 Determine Target

If `$ARGUMENTS` contains a URL, use that. Otherwise:

1. Read the current project's `CLAUDE.md` for dev server port
2. Fall back to global port assignment table
3. Set `TARGET_URL` accordingly

### 1.2 Load Chrome DevTools MCP Tools

```
ToolSearch query: "chrome navigate screenshot"
ToolSearch query: "chrome click snapshot"
ToolSearch query: "chrome emulate evaluate"
ToolSearch query: "chrome network console"
```

All Chrome DevTools MCP tools must be loaded before testing begins.

### 1.3 Capture Initial State

```
mcp__chrome-devtools__navigate_page({ url: TARGET_URL })
mcp__chrome-devtools__take_screenshot  // Full page capture
mcp__chrome-devtools__take_snapshot    // Accessibility tree
```

### 1.4 Capture Viewports

Screenshot at these widths (landing pages must convert on all devices):

| Width | Device | Priority |
|-------|--------|----------|
| 375px | iPhone SE | Critical — most mobile traffic |
| 390px | iPhone 14 | Critical |
| 768px | iPad portrait | High |
| 1280px | Laptop | Critical — most desktop traffic |
| 1440px | MacBook Pro | High |
| 1920px | Full HD | Medium |

```
mcp__chrome-devtools__emulate({
  viewport: { width: 375, height: 812, isMobile: true, deviceScaleFactor: 2 }
})
mcp__chrome-devtools__take_screenshot
// Repeat for each viewport
```

### 1.5 Create Output Directory

```bash
mkdir -p landing-page-audit
```

### 1.6 Source Code Access

If the project has source files (not just a URL):

```bash
# Find the main landing page files
find . -name "*.tsx" -o -name "*.jsx" -o -name "*.html" -o -name "*.astro" -o -name "*.svelte" | head -50

# Find meta tag files
find . -name "layout.*" -o -name "_app.*" -o -name "_document.*" -o -name "head.*"

# Find global styles
find . -name "globals.css" -o -name "global.css" -o -name "tailwind.config.*"
```

---

## Phase 2: Conversion Framework Audit

**Read and apply:** `references/conversion-framework.md`

Score the page against the 10 Conversion Requirements. Each requirement is scored:
- **PASS** — Requirement fully met
- **PARTIAL** — Some elements present, gaps identified
- **FAIL** — Requirement not met or critically weak

### The 10 Conversion Requirements

| # | Requirement | What to Check |
|---|-------------|---------------|
| 1 | Clear Value Proposition | Can a visitor understand what this does in 5 seconds? |
| 2 | Compelling Hero Section | Headline, subheadline, CTA, and visual proof above the fold |
| 3 | Social Proof | Testimonials, logos, metrics, reviews visible and specific |
| 4 | Clear Call-to-Action | Primary CTA is obvious, specific, and repeated throughout |
| 5 | Objection Handling | FAQ, guarantees, or trust signals address visitor doubts |
| 6 | Benefit-Driven Copy | Features are translated to outcomes the visitor cares about |
| 7 | Visual Hierarchy | Eye flow guides toward CTA; no competing elements |
| 8 | Pricing Transparency | If applicable: clear tiers, recommended option, annual toggle |
| 9 | SEO & Meta Complete | Title, description, OG tags, structured data all present |
| 10 | Mobile Conversion Path | CTA reachable, forms usable, content readable on mobile |

Generate a scorecard:

```markdown
## Conversion Framework Scorecard

| # | Requirement | Score | Notes |
|---|-------------|-------|-------|
| 1 | Clear Value Proposition | PASS/PARTIAL/FAIL | [specific observation] |
| 2 | Compelling Hero Section | PASS/PARTIAL/FAIL | [specific observation] |
| ... | ... | ... | ... |

**Overall Score: X/10 PASS, Y/10 PARTIAL, Z/10 FAIL**
```

---

## Phase 3: Section-by-Section Analysis

Audit every section of the page in order. For each section, check against the reference file.

**Read and apply:** `references/section-patterns.md`

### 3.1 Navigation / Header

```javascript
// Extract nav items via Chrome DevTools
document.querySelectorAll('nav a, header a').forEach(a => {
  console.log(`Nav: ${a.textContent.trim()} → ${a.href}`);
});
```

Check:
- [ ] Logo links to homepage
- [ ] Navigation items are minimal (5-7 max)
- [ ] CTA button in nav (not just a text link)
- [ ] Nav CTA matches primary page CTA
- [ ] Mobile hamburger menu works
- [ ] Sticky/fixed nav on scroll (recommended for long pages)

### 3.2 Hero Section

**Read and apply:** `references/hero-optimization.md`

This is the MOST CRITICAL section. Check:

- [ ] **Headline** — Specific outcome, not vague claim. Uses proven formula.
- [ ] **Subheadline** — Explains how the product delivers the headline's promise
- [ ] **Primary CTA** — Specific action (not "Learn More"), high contrast, above fold
- [ ] **Visual proof** — Screenshot, demo, video, or illustration showing the product
- [ ] **Above-the-fold completeness** — All 4 elements visible without scrolling at 1280px

```javascript
// Measure ATF content at desktop
const viewportHeight = window.innerHeight;
const heroSection = document.querySelector('[class*="hero"], section:first-of-type, main > div:first-child');
if (heroSection) {
  const rect = heroSection.getBoundingClientRect();
  console.log(`Hero height: ${rect.height}px, Viewport: ${viewportHeight}px`);
  console.log(`Hero fits ATF: ${rect.bottom <= viewportHeight}`);
}

// Check for CTA above fold
document.querySelectorAll('a[href], button').forEach(el => {
  const rect = el.getBoundingClientRect();
  if (rect.top < viewportHeight && (el.textContent.includes('Start') || el.textContent.includes('Get') || el.textContent.includes('Try'))) {
    console.log(`CTA ATF: "${el.textContent.trim()}" at ${Math.round(rect.top)}px`);
  }
});
```

### 3.3 How It Works / Process Section

- [ ] 3-step maximum (more = cognitive overload)
- [ ] Each step starts with an action verb
- [ ] Steps are numbered or visually ordered
- [ ] Section title is compelling (not just "How It Works")

### 3.4 Before/After or Problem/Solution

- [ ] "Before" paints specific pain the visitor recognizes
- [ ] "After" shows concrete, measurable improvement
- [ ] Contrast is visual (not just text)
- [ ] Section compels the visitor to want the "after" state

### 3.5 Features / Benefits Section

- [ ] Features are translated to benefits (what it means for the user)
- [ ] Each feature has a clear icon or visual
- [ ] Grid or list layout is scannable
- [ ] No more than 6-8 features displayed (prioritize)
- [ ] Feature titles are benefit-oriented, not technical

### 3.6 Social Proof Section

**Read and apply:** `references/social-proof-pricing.md`

- [ ] Real testimonials with names and photos
- [ ] Specific results mentioned (not generic praise)
- [ ] Company logos of recognizable customers
- [ ] Metrics/stats (users, uptime, satisfaction)
- [ ] Case studies or detailed stories (at least one)

### 3.7 Pricing Section

**Read and apply:** `references/social-proof-pricing.md`

- [ ] Clear tier names that communicate value
- [ ] One tier visually recommended ("Most Popular" badge)
- [ ] Annual/monthly toggle with savings highlighted
- [ ] Feature comparison clear across tiers
- [ ] CTA on every tier (not just the recommended one)
- [ ] Free tier or trial option available
- [ ] Decoy pricing principle applied (middle tier = best value)

### 3.8 FAQ Section

- [ ] Addresses top 5-8 objections visitors have
- [ ] Answers are concise and specific
- [ ] Includes schema markup for FAQ (SEO benefit)
- [ ] Expand/collapse interaction works properly
- [ ] CTA after FAQ section

### 3.9 Final CTA Section

- [ ] Repeats the primary CTA
- [ ] Urgency or reinforcement copy
- [ ] Different framing from hero CTA (summary, not intro)
- [ ] High contrast, impossible to miss

### 3.10 Footer

- [ ] Legal links present (Privacy, Terms)
- [ ] Contact information or support link
- [ ] Social media links (open in new tab)
- [ ] No critical CTAs buried only in footer
- [ ] Copyright year current

---

## Phase 4: Copy Audit

**Read and apply:** `references/copy-rules.md`

This is the most differentiated part of the audit. Apply the 7 Copy Rules to EVERY piece of text on the page.

### 4.1 Apply 7 Copy Rules

For every headline, subheadline, body paragraph, CTA, and section title:

| Rule | Check |
|------|-------|
| 1. Specific > Vague | Numbers, outcomes, timeframes instead of generic claims |
| 2. "You" > "We" | Copy speaks to the visitor, not about the company |
| 3. Active > Passive | "Get X" not "X can be gotten" |
| 4. Benefit > Feature | "Save 10 hours/week" not "Automated workflows" |
| 5. Short > Long | Sentences under 20 words, paragraphs under 3 lines |
| 6. Concrete > Abstract | Tangible outcomes, not philosophical statements |
| 7. Urgent > Passive | Implies time-sensitivity or cost of inaction |

### 4.2 Banned Words Scan

```bash
# Scan for weak/banned words in copy
grep -rni "seamless\|seamlessly\|robust\|leverage\|utilize\|synergy\|cutting-edge\|best-in-class\|world-class\|next-generation\|innovative\|revolutionary\|game-changing\|disruptive\|empower\|holistic\|scalable\|enterprise-grade\|mission-critical\|bleeding-edge\|paradigm\|ecosystem\|turnkey\|end-to-end\|full-stack\|frictionless\|state-of-the-art\|solution\|platform\|powerful\|comprehensive" --include="*.tsx" --include="*.jsx" --include="*.html" --include="*.astro" --include="*.svelte" --include="*.md"
```

Every banned word found is a finding with a specific replacement.

### 4.3 Section Title Audit

Every section title should compel continued scrolling. Apply the formula:

**Good:** "[Outcome] without [pain point]" or "[Specific metric] in [timeframe]"
**Bad:** "Features", "How It Works", "Pricing", "About Us"

```javascript
// Extract all headings via Chrome DevTools
document.querySelectorAll('h1, h2, h3').forEach(h => {
  console.log(`${h.tagName}: "${h.textContent.trim()}"`);
});
```

### 4.4 CTA Text Audit

Every CTA button/link should:
- Start with a verb
- Be specific about what happens next
- Create urgency or desire

```javascript
// Extract all CTAs
document.querySelectorAll('a[href], button[type="submit"], [class*="cta"], [class*="btn"]').forEach(el => {
  const text = el.textContent.trim();
  if (text.length > 0 && text.length < 50) {
    console.log(`CTA: "${text}" → ${el.href || 'button'}`);
  }
});
```

**Weak CTAs to flag:** "Learn More", "Submit", "Click Here", "Get Started" (without specificity), "Sign Up" (without benefit)

---

## Phase 5: SEO & Meta Audit

**Read and apply:** `references/seo-meta.md`

### 5.1 Meta Tags

```javascript
// Extract all meta information
const meta = {
  title: document.title,
  description: document.querySelector('meta[name="description"]')?.content,
  ogTitle: document.querySelector('meta[property="og:title"]')?.content,
  ogDescription: document.querySelector('meta[property="og:description"]')?.content,
  ogImage: document.querySelector('meta[property="og:image"]')?.content,
  ogUrl: document.querySelector('meta[property="og:url"]')?.content,
  twitterCard: document.querySelector('meta[name="twitter:card"]')?.content,
  canonical: document.querySelector('link[rel="canonical"]')?.href,
  viewport: document.querySelector('meta[name="viewport"]')?.content,
  favicon: document.querySelector('link[rel="icon"]')?.href,
};
console.log(JSON.stringify(meta, null, 2));
```

Check:
- [ ] `<title>` — 50-60 chars, includes primary keyword and brand
- [ ] `<meta description>` — 150-160 chars, includes CTA language
- [ ] `<meta viewport>` — Present and correct
- [ ] `<link rel="canonical">` — Points to correct URL
- [ ] Favicon present

### 5.2 Open Graph Tags

- [ ] `og:title` — Present, compelling (can differ from page title)
- [ ] `og:description` — Present, benefit-focused
- [ ] `og:image` — Present, 1200x630px minimum, shows product/brand
- [ ] `og:url` — Points to canonical URL
- [ ] `og:type` — Set to "website"

### 5.3 Twitter Card Tags

- [ ] `twitter:card` — Set to "summary_large_image"
- [ ] `twitter:title` — Present
- [ ] `twitter:description` — Present
- [ ] `twitter:image` — Present

### 5.4 Structured Data

```javascript
// Check for JSON-LD structured data
document.querySelectorAll('script[type="application/ld+json"]').forEach(s => {
  try {
    console.log(JSON.stringify(JSON.parse(s.textContent), null, 2));
  } catch(e) {
    console.error('Invalid JSON-LD:', e.message);
  }
});
```

Check for:
- [ ] Organization schema
- [ ] WebSite schema with SearchAction (if applicable)
- [ ] Product schema (if applicable)
- [ ] FAQ schema (if FAQ section exists)
- [ ] Breadcrumb schema (if applicable)

### 5.5 Technical SEO

```bash
# Check for robots.txt
curl -s "${TARGET_URL}/robots.txt" | head -20

# Check for sitemap
curl -s "${TARGET_URL}/sitemap.xml" | head -20

# Check heading hierarchy
```

```javascript
// Verify heading hierarchy
const headings = document.querySelectorAll('h1, h2, h3, h4, h5, h6');
let lastLevel = 0;
headings.forEach(h => {
  const level = parseInt(h.tagName[1]);
  if (level > lastLevel + 1) {
    console.warn(`Heading skip: ${h.tagName} after H${lastLevel} — "${h.textContent.trim().slice(0,40)}"`);
  }
  lastLevel = level;
});

// Count H1s (should be exactly 1)
const h1Count = document.querySelectorAll('h1').length;
console.log(`H1 count: ${h1Count} (should be 1)`);
```

---

## Phase 6: Visual & UX Verification

### 6.1 Above-the-Fold Audit

At 1280px desktop width:

```javascript
// Identify what's above the fold
const viewportHeight = window.innerHeight;
const elements = document.querySelectorAll('h1, h2, p, a, button, img, video');
const atf = [];
const btf = [];
elements.forEach(el => {
  const rect = el.getBoundingClientRect();
  if (rect.top < viewportHeight && rect.bottom > 0) {
    atf.push({ tag: el.tagName, text: el.textContent?.trim().slice(0, 60), top: Math.round(rect.top) });
  }
});
console.log('Above the fold:', JSON.stringify(atf, null, 2));
```

**Required ATF elements:**
- [ ] Headline (H1)
- [ ] Subheadline
- [ ] Primary CTA button
- [ ] Visual proof (image, video, or demo)
- [ ] Navigation

### 6.2 Mobile Conversion Path

At 375px mobile width:

- [ ] CTA is reachable without excessive scrolling
- [ ] Text is readable without zooming (min 16px body)
- [ ] Touch targets are 44px minimum
- [ ] No horizontal scroll
- [ ] Images don't push content below fold
- [ ] Forms are usable with thumb

```javascript
// Check mobile text sizes
document.querySelectorAll('p, span, li, a, button').forEach(el => {
  const size = parseFloat(getComputedStyle(el).fontSize);
  if (size < 14 && el.textContent.trim().length > 0) {
    console.warn(`Small text (${size}px): "${el.textContent.trim().slice(0, 40)}"`);
  }
});

// Check touch targets
document.querySelectorAll('a, button, [role="button"], input, select').forEach(el => {
  const rect = el.getBoundingClientRect();
  if (rect.width > 0 && (rect.width < 44 || rect.height < 44)) {
    console.warn(`Small target (${Math.round(rect.width)}x${Math.round(rect.height)}): "${el.textContent?.trim().slice(0, 30)}"`);
  }
});
```

### 6.3 Visual Hierarchy Check

- [ ] Primary CTA has highest visual weight (color, size, contrast)
- [ ] Headlines create clear scan path
- [ ] White space separates sections effectively
- [ ] No competing visual elements near CTA
- [ ] Color contrast meets WCAG AA (4.5:1 text, 3:1 large text)

### 6.4 Page Load & Performance

```javascript
// Basic performance metrics
const perf = performance.getEntriesByType('navigation')[0];
console.log({
  TTFB: Math.round(perf.responseStart) + 'ms',
  DOMContentLoaded: Math.round(perf.domContentLoadedEventEnd) + 'ms',
  FullLoad: Math.round(perf.loadEventEnd) + 'ms',
  TransferSize: Math.round(perf.transferSize / 1024) + 'KB'
});

// Check for LCP element
new PerformanceObserver((list) => {
  const entries = list.getEntries();
  const last = entries[entries.length - 1];
  console.log('LCP:', Math.round(last.startTime) + 'ms', last.element?.tagName);
}).observe({ type: 'largest-contentful-paint', buffered: true });
```

---

## Phase 7: Implementation Guide

**This is what makes picky-landingpage different from other audits.** Don't just say "improve the headline" — provide the exact replacement.

### 7.1 Format for Every Finding

Every finding MUST include an implementation block:

```markdown
### FINDING-ID: [Title]

**Severity:** Critical / High / Medium / Low
**Section:** [Hero / Social Proof / Pricing / etc.]
**Impact:** [Estimated conversion impact]

**Current:**
[Exact current text/code/element]

**Recommended:**
[Exact replacement text/code/element]

**CHANGE:**
```
File: [path/to/file.tsx]
Line: [line number]
```
// Find:
[exact string to find]

// Replace with:
[exact replacement string]
```

**Rationale:** [Why this change improves conversion, citing specific principle]
```

### 7.2 Copy Rewrites

For every piece of copy that violates the 7 rules, provide a before/after:

```markdown
| Location | Current | Recommended | Rule Violated |
|----------|---------|-------------|---------------|
| Hero H1 | "The Future of Work" | "Ship Features 3x Faster — Without Hiring" | Specific > Vague |
| Hero sub | "We help teams..." | "You'll deploy weekly instead of monthly" | "You" > "We" |
| CTA | "Learn More" | "Start Free — Deploy in 5 Minutes" | Benefit > Feature |
```

### 7.3 Implementation Priority

Order all changes by estimated conversion impact:

```markdown
## Implementation Priority

### Do Now (5 minutes each, highest impact)
1. [Change hero headline] — Estimated +15-20% conversion
2. [Fix primary CTA text] — Estimated +10-15% conversion
3. [Add social proof metric] — Estimated +5-10% conversion

### Do This Week (30-60 minutes each)
4. [Rewrite all section titles] — Estimated +5-10% conversion
5. [Add testimonial section] — Estimated +5-8% conversion

### Do This Month (2-4 hours each)
6. [Implement pricing tiers] — Estimated impact varies
7. [Add FAQ with schema] — SEO + conversion benefit
```

---

## Phase 8: Report Generation

Save the full report to `landing-page-audit/AUDIT-REPORT.md`.

### Report Structure

```markdown
# Landing Page Conversion Audit: [Product/Site Name]

**Audit Date:** YYYY-MM-DD
**URL:** [URL audited]
**Auditor:** Claude (picky-landingpage skill)

---

## Conversion Framework Scorecard

| # | Requirement | Score | Notes |
|---|-------------|-------|-------|
| 1 | Clear Value Proposition | ✅/⚠️/❌ | [observation] |
| 2 | Compelling Hero Section | ✅/⚠️/❌ | [observation] |
| 3 | Social Proof | ✅/⚠️/❌ | [observation] |
| 4 | Clear Call-to-Action | ✅/⚠️/❌ | [observation] |
| 5 | Objection Handling | ✅/⚠️/❌ | [observation] |
| 6 | Benefit-Driven Copy | ✅/⚠️/❌ | [observation] |
| 7 | Visual Hierarchy | ✅/⚠️/❌ | [observation] |
| 8 | Pricing Transparency | ✅/⚠️/❌ | [observation] |
| 9 | SEO & Meta Complete | ✅/⚠️/❌ | [observation] |
| 10 | Mobile Conversion Path | ✅/⚠️/❌ | [observation] |

**Conversion Health: X/10 PASS | Y/10 PARTIAL | Z/10 FAIL**

---

## Executive Summary

[3-5 sentences: biggest conversion killers and estimated impact of fixes]

---

## Critical Findings (Fix Immediately)

[Findings that are actively killing conversions]

## High Priority (Fix This Week)

[Significant conversion opportunities]

## Medium Priority (Fix This Month)

[Moderate improvements]

## Low Priority (Backlog)

[Polish and optimization]

---

## Complete Copy Rewrite Table

| # | Location | Current | Recommended | Rule |
|---|----------|---------|-------------|------|
| 1 | Hero H1 | "..." | "..." | ... |
| 2 | Hero sub | "..." | "..." | ... |
| ... | ... | ... | ... | ... |

---

## Implementation Guide

### Immediate Changes (Copy & Paste Ready)

[Exact CHANGE blocks for every finding, ordered by impact]

### Code Changes Required

[Any structural/component changes needed]

### New Sections to Add

[Any missing sections that should be created]

---

## SEO Checklist

- [ ] Title tag: [current] → [recommended]
- [ ] Meta description: [current] → [recommended]
- [ ] OG image: [status]
- [ ] Structured data: [status]
- [ ] robots.txt: [status]
- [ ] sitemap.xml: [status]

---

## Verification Checklist

After implementing changes:
- [ ] Hero passes 5-second test (show to someone, ask what the product does)
- [ ] Primary CTA visible ATF on desktop and mobile
- [ ] All banned words removed
- [ ] Social proof includes specific metrics
- [ ] Pricing has recommended tier highlighted
- [ ] All meta tags present and valid
- [ ] Mobile conversion path tested at 375px
- [ ] Page loads in < 3 seconds
- [ ] FAQ schema validates in Google Rich Results Test

---

## Screenshots

| File | Description | Viewport |
|------|-------------|----------|
| [filename] | [description] | [dimensions] |

---

*Report generated by picky-landingpage skill*
*"Every weak headline is lost revenue. Every missing CTA is a leaked conversion."*
```

---

## Finding Classification

| Severity | Impact | Examples |
|----------|--------|---------|
| **Critical** | Major conversion killer | No clear value prop, no CTA ATF, broken mobile layout, page won't load |
| **High** | Significant conversion leak | Vague headline, generic CTA, no social proof, missing pricing |
| **Medium** | Moderate optimization opportunity | Weak section titles, banned words, missing meta tags, no FAQ |
| **Low** | Polish and refinement | Minor copy improvements, image optimization, additional schema |

---

## Chrome DevTools MCP Quick Reference

```javascript
// Navigation
mcp__chrome-devtools__navigate_page({ url: "...", type: "url" })

// Visual capture
mcp__chrome-devtools__take_screenshot
mcp__chrome-devtools__take_snapshot  // accessibility tree

// Interaction
mcp__chrome-devtools__click({ uid: "element-uid" })
mcp__chrome-devtools__fill({ uid: "input-uid", value: "text" })

// Viewport & emulation
mcp__chrome-devtools__emulate({
  viewport: { width: 375, height: 812, isMobile: true, deviceScaleFactor: 2 }
})
mcp__chrome-devtools__resize_page({ width: 1280, height: 800 })

// JavaScript evaluation
mcp__chrome-devtools__evaluate_script({ expression: "..." })

// Inspection
mcp__chrome-devtools__list_console_messages
mcp__chrome-devtools__list_network_requests
```

---

## What Makes This "10x More Picky"

### Standard Audit Says:
- "Consider improving your headline"
- "Add some social proof"
- "Your CTA could be stronger"

### Picky Landingpage Says:
- "Hero H1 'The Future of Work' violates Rule 1 (Specific > Vague). Replace with 'Ship Features 3x Faster — Without Hiring'. File: `src/components/Hero.tsx:14`. Find/replace provided."
- "Zero social proof found. Page needs: 3 testimonials with photos and metrics, customer logo bar (6+ logos), and one stat banner ('10,000+ teams ship faster with [Product]'). Template provided."
- "CTA 'Learn More' violates Rule 4 (Benefit > Feature) and lacks specificity. Replace with 'Start Free — Deploy in 5 Minutes'. 4 CTA instances found: Hero, mid-page, pricing, footer. All replacements provided."

### The Difference:
- **Quantified** — Exact counts of violations, not "some issues"
- **Located** — Every file:line reference
- **Rewritten** — Exact replacement copy for every finding
- **Implementable** — Find/replace blocks a coding agent can execute
- **Prioritized** — Ordered by estimated conversion impact
- **Principled** — Every change cites the rule it's based on

---

## Verification Checklist Before Reporting

Before declaring the audit complete, verify:

- [ ] Captured screenshots at all 6 viewports
- [ ] Scored all 10 conversion requirements
- [ ] Audited every section (Nav through Footer)
- [ ] Applied all 7 copy rules to every piece of text
- [ ] Scanned for all banned words
- [ ] Audited every CTA on the page
- [ ] Checked all meta tags and structured data
- [ ] Verified mobile conversion path
- [ ] Provided exact replacement copy for every finding
- [ ] Provided implementation priority with estimated impact
- [ ] Generated complete report with CHANGE blocks

---

## Rules

- **Use Chrome DevTools MCP for live page inspection** — screenshot everything
- **Use source code scanning for copy and meta audits** — grep for banned words, missing tags
- **Every finding must have an exact fix** — no "consider improving" allowed
- **Copy rewrites must be complete** — before AND after for every piece of text
- **Measure, don't guess** — use evaluate_script for DOM measurements
- **Leave dev server running** — never kill it
- **Save all screenshots** to `landing-page-audit/` directory
- **Produce implementable output** — another agent should be able to execute every change
