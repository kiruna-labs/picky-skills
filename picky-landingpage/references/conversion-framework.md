# Conversion Framework — The 10 Requirements

## Audit Philosophy

**A landing page has one job: convert visitors into users.** Every element on the page either moves the visitor toward conversion or pushes them away. There is no neutral. This framework scores the 10 essential requirements that separate high-converting pages (5-10%+) from average ones (1-2%).

---

## Requirement 1: Clear Value Proposition

**The 5-Second Test:** If someone sees your page for 5 seconds and looks away, can they tell you:
1. What the product does
2. Who it's for
3. Why it's better than alternatives

### Checklist

- [ ] Value prop visible above the fold without scrolling
- [ ] Stated in plain language (no jargon, no buzzwords)
- [ ] Specific to a target audience (not "everyone")
- [ ] Differentiates from competitors (not generic)
- [ ] Includes a quantifiable outcome when possible

### Scan Commands

```javascript
// Extract the first visible text elements
const h1 = document.querySelector('h1');
const firstP = document.querySelector('h1 + p, h1 ~ p, [class*="hero"] p, [class*="subtitle"]');
console.log('H1:', h1?.textContent.trim());
console.log('Sub:', firstP?.textContent.trim());
```

```bash
# Check for buzzword-heavy value props in source
grep -rni "seamless\|robust\|leverage\|cutting-edge\|revolutionary\|innovative\|next-gen\|world-class\|best-in-class\|enterprise-grade" --include="*.tsx" --include="*.jsx" --include="*.html"
```

### Scoring

| Score | Criteria |
|-------|----------|
| PASS | All 3 questions answered clearly in < 5 seconds |
| PARTIAL | 1-2 questions answered, or answer requires reading |
| FAIL | Visitor cannot determine what product does in 5 seconds |

### Common Anti-Patterns

| Anti-Pattern | Example | Fix |
|-------------|---------|-----|
| Buzzword soup | "An innovative, cutting-edge solution" | "Deploy code 3x faster" |
| Company-centric | "We are the leading platform" | "You ship features weekly, not monthly" |
| Feature-first | "AI-powered analytics engine" | "Know which users will churn before they do" |
| Too broad | "For all your business needs" | "For SaaS teams shipping 10+ releases/month" |

---

## Requirement 2: Compelling Hero Section

**The hero is where 80% of conversion decisions are made.** It must contain 4 elements above the fold.

### The 4 Essential Hero Elements

1. **Headline** — Specific outcome the visitor wants
2. **Subheadline** — How the product delivers that outcome
3. **Primary CTA** — Clear next step with specific action
4. **Visual proof** — Product screenshot, demo, video, or illustration

### Checklist

- [ ] All 4 elements present
- [ ] All 4 elements visible above fold at 1280px
- [ ] Headline is the largest text on the page
- [ ] CTA has highest visual contrast on the page
- [ ] Visual shows the actual product (not generic stock art)
- [ ] No competing elements (navigation doesn't overshadow hero)

### Scoring

| Score | Criteria |
|-------|----------|
| PASS | All 4 elements present, visible ATF, compelling |
| PARTIAL | 2-3 elements present, or some below fold |
| FAIL | Missing 2+ elements, or hero is below fold |

---

## Requirement 3: Social Proof

**People don't trust companies. They trust other people.** Social proof reduces perceived risk and validates the decision to convert.

### Types of Social Proof (in order of impact)

1. **Specific testimonials** — Named person, photo, specific result
2. **Customer logos** — Recognizable brand logos (6+ preferred)
3. **Metrics** — "10,000+ teams", "99.9% uptime", "4.8/5 rating"
4. **Case studies** — Detailed success stories with numbers
5. **Media mentions** — "As seen in TechCrunch, Forbes..."
6. **Trust badges** — Security certifications, awards, ratings

### Checklist

- [ ] At least 2 types of social proof present
- [ ] Testimonials include real names (not "Customer A")
- [ ] Testimonials include photos or company names
- [ ] Testimonials mention specific results (numbers preferred)
- [ ] Logo bar has 6+ recognizable logos
- [ ] Metrics are specific and credible (not rounded to "millions")
- [ ] Social proof appears before the pricing section

### Scoring

| Score | Criteria |
|-------|----------|
| PASS | 3+ types of social proof, specific and credible |
| PARTIAL | 1-2 types present, or generic/non-specific |
| FAIL | No social proof, or only vague testimonials |

---

## Requirement 4: Clear Call-to-Action

**If the visitor doesn't know what to do next, they leave.** The CTA must be obvious, specific, and repeated.

### Checklist

- [ ] One primary CTA that appears 3+ times on the page
- [ ] CTA text is a specific action (not "Learn More" or "Submit")
- [ ] CTA button has highest contrast on the page
- [ ] CTA is above the fold
- [ ] CTA appears after every major section
- [ ] Secondary CTA exists for visitors not ready (e.g., "Watch Demo")
- [ ] CTA communicates what happens next ("Start Free Trial — No Credit Card")

### CTA Placement Map

```
[Nav] ................................. [CTA Button]
[Hero] ............................... [Primary CTA]
[Social Proof / How It Works] ....... [Optional CTA]
[Features / Benefits] ............... [Secondary CTA]
[Pricing] ........................... [CTA per tier]
[FAQ] ............................... [Primary CTA]
[Footer CTA Section] ............... [Primary CTA]
```

### Scoring

| Score | Criteria |
|-------|----------|
| PASS | CTA clear, specific, high-contrast, appears 3+ times |
| PARTIAL | CTA exists but generic text, low contrast, or appears once |
| FAIL | No clear CTA, or CTA buried/hidden |

---

## Requirement 5: Objection Handling

**Every visitor has doubts.** The page must proactively address them.

### Top 5 Universal Objections

1. "Does this actually work?" → Social proof, case studies
2. "Is it worth the price?" → ROI calculator, comparison
3. "What if I don't like it?" → Free trial, money-back guarantee
4. "Is my data safe?" → Security badges, compliance mentions
5. "How long will this take?" → Quick start guide, time-to-value

### Checklist

- [ ] FAQ section addresses top objections
- [ ] Guarantee or risk reversal offered (free trial, money-back)
- [ ] Security/privacy assurances visible
- [ ] Pricing is transparent (no "Contact Sales" for basic plans)
- [ ] Migration/onboarding difficulty addressed

### Scoring

| Score | Criteria |
|-------|----------|
| PASS | 4+ objections addressed proactively |
| PARTIAL | 1-3 objections addressed |
| FAIL | No objection handling, FAQ missing or irrelevant |

---

## Requirement 6: Benefit-Driven Copy

**Features tell. Benefits sell.** Every feature must be translated to an outcome.

### Feature → Benefit Translation

| Feature | Benefit |
|---------|---------|
| "AI-powered analytics" | "Know which users will churn 2 weeks before they do" |
| "Real-time collaboration" | "Your whole team edits the same doc — no merge conflicts" |
| "99.9% uptime SLA" | "Your app stays up even during Black Friday traffic" |
| "One-click deployment" | "Deploy to production in 30 seconds, not 30 minutes" |

### Checklist

- [ ] Every feature section leads with the benefit
- [ ] Benefits are specific and measurable
- [ ] Benefits speak to the visitor's pain, not the company's pride
- [ ] Technical jargon is translated to plain outcomes
- [ ] Copy uses "you/your" more than "we/our"

### Scan Command

```bash
# Count "we/our" vs "you/your" usage
echo "=== We/Our count ==="
grep -roni "\bwe\b\|\bour\b" --include="*.tsx" --include="*.jsx" --include="*.html" | wc -l
echo "=== You/Your count ==="
grep -roni "\byou\b\|\byour\b" --include="*.tsx" --include="*.jsx" --include="*.html" | wc -l
```

### Scoring

| Score | Criteria |
|-------|----------|
| PASS | All features translated to benefits, "you" > "we" ratio |
| PARTIAL | Some benefit-driven copy, but features still dominate |
| FAIL | Copy is entirely feature-focused or company-centric |

---

## Requirement 7: Visual Hierarchy

**The eye should flow naturally from headline → subheadline → CTA → proof.**

### Checklist

- [ ] H1 is the most visually dominant element
- [ ] CTA button is the highest-contrast interactive element
- [ ] Clear section separation with whitespace
- [ ] No more than one primary action per viewport
- [ ] Supporting elements (logos, badges) don't compete with CTA
- [ ] F-pattern or Z-pattern layout flow

### Scan Commands

```javascript
// Check visual hierarchy - element sizes
const h1 = document.querySelector('h1');
const cta = document.querySelector('[class*="cta"], [class*="btn-primary"], a[class*="button"]');
if (h1) {
  const h1Style = getComputedStyle(h1);
  console.log(`H1: ${h1Style.fontSize} / ${h1Style.fontWeight} / ${h1Style.color}`);
}
if (cta) {
  const ctaStyle = getComputedStyle(cta);
  console.log(`CTA: ${ctaStyle.fontSize} / bg:${ctaStyle.backgroundColor} / color:${ctaStyle.color}`);
  const rect = cta.getBoundingClientRect();
  console.log(`CTA size: ${Math.round(rect.width)}x${Math.round(rect.height)}px`);
}
```

### Scoring

| Score | Criteria |
|-------|----------|
| PASS | Clear visual flow, H1 dominates, CTA highest contrast |
| PARTIAL | Hierarchy exists but competing elements distract |
| FAIL | No clear hierarchy, CTA buried, or visual clutter |

---

## Requirement 8: Pricing Transparency

**If visitors can't understand pricing in 10 seconds, they leave.**

### Checklist

- [ ] Pricing visible on the page (not hidden behind "Contact Sales")
- [ ] Clear tier names that communicate value (not "Plan A, B, C")
- [ ] One tier visually highlighted as "Recommended" or "Most Popular"
- [ ] Monthly/Annual toggle with savings percentage shown
- [ ] Feature comparison is scannable (checkmarks, not paragraphs)
- [ ] Free tier or free trial clearly available
- [ ] Enterprise/custom option available for larger customers
- [ ] Decoy principle: middle tier = best value perception

### Scoring

| Score | Criteria |
|-------|----------|
| PASS | Clear tiers, recommended highlighted, toggle, free option |
| PARTIAL | Pricing visible but confusing, no recommended tier, or no toggle |
| FAIL | No pricing, "Contact Sales" only, or deliberately obscured |
| N/A | Product doesn't have pricing (open source, free tool, etc.) |

---

## Requirement 9: SEO & Meta Complete

**If search engines can't understand your page, you're invisible.**

### Checklist

- [ ] `<title>` tag — 50-60 chars, keyword + brand
- [ ] `<meta description>` — 150-160 chars, includes CTA language
- [ ] `og:title`, `og:description`, `og:image` — All present
- [ ] `twitter:card` — Set to "summary_large_image"
- [ ] `<link rel="canonical">` — Points to correct URL
- [ ] JSON-LD structured data (Organization, FAQ, Product)
- [ ] Single `<h1>`, logical heading hierarchy
- [ ] `robots.txt` allows crawling
- [ ] `sitemap.xml` exists and is valid

### Scoring

| Score | Criteria |
|-------|----------|
| PASS | All essential meta tags present, structured data valid |
| PARTIAL | Some tags present, some missing |
| FAIL | Missing title, description, or critical OG tags |

---

## Requirement 10: Mobile Conversion Path

**60%+ of traffic is mobile. If mobile doesn't convert, nothing does.**

### Checklist

- [ ] CTA visible and tappable within first 2 scrolls on mobile
- [ ] Touch targets ≥ 44px
- [ ] Body text ≥ 16px
- [ ] No horizontal scroll at 375px
- [ ] Forms are single-column and usable with thumb
- [ ] Images don't push CTA below 3 scrolls
- [ ] Sticky CTA on mobile (recommended for long pages)
- [ ] Page loads in < 3 seconds on mobile

### Scan Commands

```javascript
// Mobile viewport check
const viewportWidth = window.innerWidth;
const scrollWidth = document.documentElement.scrollWidth;
if (scrollWidth > viewportWidth) {
  console.error(`Horizontal overflow: page is ${scrollWidth}px wide, viewport is ${viewportWidth}px`);
}

// Find first CTA on mobile
const cta = document.querySelector('a[href*="sign"], a[href*="start"], a[href*="try"], button[class*="cta"]');
if (cta) {
  const rect = cta.getBoundingClientRect();
  const scrollsNeeded = Math.ceil(rect.top / window.innerHeight);
  console.log(`First CTA at ${Math.round(rect.top)}px = ${scrollsNeeded} scroll(s)`);
}
```

### Scoring

| Score | Criteria |
|-------|----------|
| PASS | Full conversion path works smoothly on 375px |
| PARTIAL | Usable but friction points (small targets, late CTA) |
| FAIL | CTA hidden, horizontal scroll, unreadable text, broken layout |

---

## Conversion Health Score

After scoring all 10 requirements:

| Health | Score | Description |
|--------|-------|-------------|
| **Excellent** | 9-10 PASS | Page is well-optimized for conversion |
| **Good** | 7-8 PASS | Strong foundation, targeted improvements needed |
| **Needs Work** | 5-6 PASS | Significant gaps hurting conversion |
| **Poor** | 3-4 PASS | Major conversion killers present |
| **Critical** | 0-2 PASS | Page is not functioning as a landing page |
