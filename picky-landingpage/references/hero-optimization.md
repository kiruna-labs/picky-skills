# Hero Section Optimization

## Audit Philosophy

**The hero is your 8-second window.** 80% of visitors who don't engage with the hero never scroll. The hero must immediately communicate: what this is, who it's for, why they should care, and what to do next. Every pixel of the hero earns or loses attention.

---

## 1. Headline Formulas

### What Makes a Great Headline

A high-converting headline is:
- **Specific** — Names an outcome, not a category
- **Quantified** — Includes a number or timeframe
- **Audience-aware** — The visitor sees themselves in it
- **Outcome-focused** — Describes the result, not the tool

### Proven Headline Formulas

| Formula | Template | Example |
|---------|----------|---------|
| **Outcome + Timeframe** | "[Achieve X] in [timeframe]" | "Deploy to Production in 30 Seconds" |
| **Outcome + Without Pain** | "[Achieve X] without [pain]" | "Ship Features 3x Faster — Without Hiring" |
| **Who + Outcome** | "For [audience] who want [outcome]" | "For Dev Teams Who Ship Weekly, Not Monthly" |
| **Metric + Proof** | "[N] [users] [outcome]" | "10,000+ Teams Deploy Faster with Acme" |
| **Before → After** | "Stop [pain]. Start [outcome]." | "Stop Debugging Deploys. Start Shipping Features." |
| **Question** | "What if [desired outcome]?" | "What If Your CI/CD Pipeline Just... Worked?" |
| **Direct Command** | "[Verb] [thing] [qualifier]" | "Build APIs That Scale to Millions" |

### Headlines to NEVER Use

| Anti-Pattern | Why It Fails | Alternative |
|-------------|--------------|-------------|
| "Welcome to [Product]" | Zero information about value | "[Outcome] with [Product]" |
| "The Future of [Category]" | Vague, unverifiable claim | "[Specific outcome] starting today" |
| "Innovative [Category] Solution" | Buzzword, no specificity | "[Metric] improvement in [timeframe]" |
| "[Product]: [Tagline]" | Brand-centric, not visitor-centric | "[Visitor outcome] — powered by [Product]" |
| "Everything You Need For [X]" | Vague, non-specific | "[Specific thing] + [specific thing] in one place" |

### Headline Audit Checklist

- [ ] Contains a specific, measurable outcome
- [ ] Target audience would recognize themselves
- [ ] No buzzwords (innovative, seamless, revolutionary, etc.)
- [ ] Under 12 words
- [ ] Uses active voice
- [ ] Would make sense as a standalone statement (without context)
- [ ] Could NOT be used by a competitor without changes

---

## 2. Subheadline Rules

### Purpose

The subheadline answers: **"How does this product deliver the headline's promise?"**

### Rules

- [ ] Expands on the headline (doesn't repeat it)
- [ ] Explains the mechanism ("by doing X, so you get Y")
- [ ] Under 25 words
- [ ] Uses "you/your" (not "we/our")
- [ ] Contains a keyword relevant for SEO
- [ ] No buzzwords or jargon

### Formula

```
[How it works] so you can [benefit].
```

**Examples:**
- Headline: "Deploy to Production in 30 Seconds"
- Subheadline: "Push to git and your app is live. Zero config, zero downtime, zero stress."

- Headline: "Ship Features 3x Faster"
- Subheadline: "Automated testing, staging, and deploys — so you focus on code, not operations."

### Common Subheadline Mistakes

| Mistake | Example | Fix |
|---------|---------|-----|
| Repeating the headline | "Ship faster with fast shipping" | Add the mechanism/how |
| Too long | (40+ word paragraph) | Cut to 2 short sentences max |
| Company-centric | "We built the best platform..." | "You get [benefit]..." |
| Abstract | "Empowering digital transformation" | "Your team deploys daily instead of monthly" |

---

## 3. CTA Button Rules

### Primary CTA Requirements

- [ ] **Verb-first text**: Starts with an action word (Start, Get, Try, Create, Build)
- [ ] **Specific about outcome**: "Start Free Trial" not just "Start"
- [ ] **Risk reducer**: Includes friction-reducing qualifier ("No credit card", "Free forever", "Cancel anytime")
- [ ] **High contrast**: Background color stands out from everything else on the page
- [ ] **Large enough**: Minimum 48px height, 160px width on desktop; 48px height full-width on mobile
- [ ] **Above the fold**: Fully visible without scrolling at 1280px
- [ ] **Whitespace**: Adequate padding and breathing room around the button

### CTA Text Formulas

| Formula | Example |
|---------|---------|
| "[Verb] [thing] — [reducer]" | "Start Free Trial — No Credit Card Required" |
| "[Verb] for Free" | "Try It Free" |
| "[Verb] in [timeframe]" | "Get Started in 2 Minutes" |
| "[Verb] [outcome]" | "Start Shipping Faster" |

### CTA Anti-Patterns

| Bad CTA | Why | Better CTA |
|---------|-----|-----------|
| "Learn More" | Passive, no commitment | "See How It Works" |
| "Submit" | Generic, no context | "Create My Account" |
| "Click Here" | Meaningless | "Start Free Trial" |
| "Get Started" | Vague about what happens | "Start Free — Deploy in 5 Min" |
| "Sign Up" | No benefit communicated | "Start Building for Free" |
| "Contact Us" | Adds friction, delays | "Start Free Trial" (then contact) |
| "Download" | What am I downloading? | "Download Free Guide (PDF)" |

### Secondary CTA

A secondary CTA is for visitors who aren't ready to commit:

- [ ] Present alongside primary CTA
- [ ] Lower visual weight (outline/ghost button, text link)
- [ ] Clear about what it offers ("Watch 2-Min Demo", "See Pricing")
- [ ] Does NOT compete with primary CTA visually

---

## 4. Visual Proof Rules

### What Counts as Visual Proof

| Type | Impact | When to Use |
|------|--------|-------------|
| **Product screenshot** | High | Software, SaaS, apps |
| **Live demo embed** | Very High | Interactive tools |
| **Video walkthrough** | High | Complex products |
| **Animated GIF/video** | Medium-High | Showing workflow |
| **Illustration** | Medium | Abstract/conceptual products |
| **Data visualization** | Medium | Analytics/data products |

### Visual Proof Checklist

- [ ] Shows the ACTUAL product (not generic stock imagery)
- [ ] Visible above the fold
- [ ] High quality (not blurry, not obviously placeholder)
- [ ] Complements the headline (visual proof of the claim)
- [ ] Has appropriate alt text for accessibility
- [ ] Loads quickly (< 500KB, WebP/AVIF format)
- [ ] Works at mobile widths (doesn't get tiny or overflow)
- [ ] Dark/light mode appropriate if app supports themes

### Visual Proof Anti-Patterns

| Anti-Pattern | Fix |
|-------------|-----|
| Generic stock photo of people | Replace with product screenshot |
| Abstract geometric art | Replace with product in action |
| Tiny screenshot that requires squinting | Full-width product shot with key UI highlighted |
| Video that auto-plays with sound | Muted autoplay or click-to-play |
| Carousel of features | Single, strongest visual (carousels kill conversion) |

---

## 5. Above-the-Fold Composition

### Desktop (1280px) ATF Requirements

The visitor should see ALL of these without scrolling:

```
┌─────────────────────────────────────────────┐
│ [Logo]          [Nav Items]     [CTA Button] │  ← Navigation
├─────────────────────────────────────────────┤
│                                              │
│  [HEADLINE — Large, Bold]                    │
│  [Subheadline — Medium, Lighter]             │
│                                              │
│  [████ Primary CTA ████]  [Secondary CTA]    │
│                                              │
│  ┌──────────────────────────────────┐        │
│  │                                  │        │
│  │     [Product Visual / Demo]      │        │
│  │                                  │        │
│  └──────────────────────────────────┘        │
│                                              │
│  [Trust badge] [Trust badge] [Trust badge]   │  ← Optional but powerful
│                                              │
└─────────────────────────────────────────────┘
```

### Mobile (375px) ATF Requirements

```
┌───────────────────────┐
│ [Logo]     [☰ Menu]   │
├───────────────────────┤
│                       │
│ [HEADLINE]            │
│ [Subheadline]         │
│                       │
│ [████ CTA (full) ████]│
│                       │
│ [Product Visual]      │
│                       │
└───────────────────────┘
```

- CTA MUST be visible within first scroll on mobile
- Product visual can be below fold on mobile (CTA takes priority)

### Measurement Script

```javascript
// Check ATF completeness at current viewport
const vp = window.innerHeight;
const checks = {
  h1: document.querySelector('h1'),
  sub: document.querySelector('h1 + p, h1 ~ p:first-of-type, [class*="sub"]'),
  cta: document.querySelector('[class*="cta"], [class*="btn-primary"], a[class*="button"]:not(nav a)'),
  visual: document.querySelector('[class*="hero"] img, [class*="hero"] video, [class*="demo"]'),
  nav: document.querySelector('nav, header'),
};

Object.entries(checks).forEach(([name, el]) => {
  if (!el) {
    console.error(`ATF MISSING: ${name}`);
    return;
  }
  const rect = el.getBoundingClientRect();
  const atf = rect.top < vp && rect.bottom > 0;
  console.log(`${name}: ${atf ? '✅ ATF' : '❌ BTF'} (top: ${Math.round(rect.top)}px)`);
});
```

---

## 6. Hero Layout Patterns

### Pattern A: Split (Text Left, Visual Right) — Most Common

Best for: SaaS, tools, dashboards
```
[Text + CTA]  |  [Product Screenshot]
```

### Pattern B: Centered (Text Above, Visual Below)

Best for: Simple products, mobile-first
```
     [Centered Text + CTA]
     [Wide Product Visual]
```

### Pattern C: Full-Width Visual with Overlay

Best for: Visual products, photography, design tools
```
[Background: Product Visual]
[Overlay: Text + CTA]
```

### Pattern D: Video Background

Best for: Lifestyle brands, events
```
[Background: Looping Video]
[Overlay: Text + CTA]
```
⚠️ Warning: Video backgrounds often hurt performance. Only use if fast-loading and adds genuine value.

---

## 7. Hero Scoring

| Element | Weight | PASS | PARTIAL | FAIL |
|---------|--------|------|---------|------|
| Headline | 30% | Specific outcome, no buzzwords | Has outcome but vague | Generic, buzzword-heavy |
| Subheadline | 20% | Explains mechanism, "you"-focused | Present but generic | Missing or repeats headline |
| CTA | 25% | Verb-first, specific, high-contrast, ATF | Present but generic/low-contrast | Missing, "Learn More", or below fold |
| Visual | 15% | Shows real product, loads fast | Generic or slow-loading | Stock photo, missing, or broken |
| Composition | 10% | Clean layout, clear hierarchy | Minor spacing/hierarchy issues | Cluttered, no clear flow |

**Hero Health Score:**
- 90-100%: Excellent — hero is converting
- 70-89%: Good — targeted fixes needed
- 50-69%: Needs Work — significant improvements required
- Below 50%: Critical — hero is losing visitors
