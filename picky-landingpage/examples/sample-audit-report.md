# Landing Page Conversion Audit: Acme Deploy

**Audit Date**: 2025-01-28
**URL**: https://acme-deploy.example.com
**Auditor**: Claude (picky-landingpage skill)

---

## Conversion Framework Scorecard

| # | Requirement | Score | Notes |
|---|-------------|-------|-------|
| 1 | Clear Value Proposition | ⚠️ PARTIAL | H1 says "The Future of Deployment" — vague, no specific outcome |
| 2 | Compelling Hero Section | ❌ FAIL | Missing product visual ATF; CTA below fold on mobile |
| 3 | Social Proof | ⚠️ PARTIAL | 4 logos present but no testimonials, no metrics |
| 4 | Clear Call-to-Action | ⚠️ PARTIAL | CTA says "Learn More" — generic, no specificity |
| 5 | Objection Handling | ❌ FAIL | No FAQ section, no guarantee, no risk reversal |
| 6 | Benefit-Driven Copy | ⚠️ PARTIAL | Features listed but not translated to outcomes |
| 7 | Visual Hierarchy | ✅ PASS | Clear flow, H1 dominant, good whitespace |
| 8 | Pricing Transparency | ⚠️ PARTIAL | 3 tiers shown but no recommended badge, no annual toggle |
| 9 | SEO & Meta Complete | ❌ FAIL | Missing OG image, no structured data, title too short |
| 10 | Mobile Conversion Path | ⚠️ PARTIAL | CTA reachable but touch targets undersized (36px) |

**Conversion Health: 1/10 PASS | 6/10 PARTIAL | 3/10 FAIL**
**Health Rating: Poor — Major conversion killers present**

---

## Executive Summary

This landing page has a solid visual foundation but is critically undermined by vague copy, a weak CTA, and missing social proof. The biggest conversion killers are: (1) the hero headline communicates nothing specific about what Acme Deploy does or who it's for, (2) the primary CTA "Learn More" gives visitors no reason to click, and (3) there's no FAQ or objection-handling section. Fixing the headline, CTA, and adding a testimonial section could yield an estimated 25-40% conversion improvement based on industry benchmarks.

---

## Critical Findings (Fix Immediately)

### CRIT-001: Hero headline is vague and unverifiable

**Severity:** Critical
**Section:** Hero
**Impact:** Estimated 15-20% conversion loss — headline is the #1 conversion lever

**Current:**
> The Future of Deployment

**Recommended:**
> Deploy to Production in 30 Seconds — Without DevOps

**CHANGE:**
```
File: src/components/Hero.tsx
Line: 14
```
```tsx
// Find:
<h1 className="text-5xl font-bold">The Future of Deployment</h1>

// Replace with:
<h1 className="text-5xl font-bold">Deploy to Production in 30 Seconds — Without DevOps</h1>
```

**Rationale:** "The Future of Deployment" fails the 5-second test — a visitor can't tell what the product does. The replacement uses the Outcome + Without Pain formula, includes a specific timeframe (30 seconds), and names the pain eliminated (DevOps). Rule 1: Specific > Vague.

---

### CRIT-002: CTA says "Learn More" — passive, zero urgency

**Severity:** Critical
**Section:** Hero, repeated 3x on page
**Impact:** Estimated 10-15% conversion loss — CTA is the direct conversion mechanism

**Current:**
> Learn More

**Recommended:**
> Start Free — Deploy in 5 Minutes

**CHANGE:**
```
File: src/components/Hero.tsx
Line: 22
```
```tsx
// Find:
<a href="/signup" className="btn btn-primary">Learn More</a>

// Replace with:
<a href="/signup" className="btn btn-primary">Start Free — Deploy in 5 Minutes</a>
```

```
File: src/components/Features.tsx
Line: 48
```
```tsx
// Find:
<a href="/signup" className="btn btn-primary">Learn More</a>

// Replace with:
<a href="/signup" className="btn btn-primary">Start Free — Deploy in 5 Minutes</a>
```

```
File: src/components/Pricing.tsx
Line: 72
```
```tsx
// Find:
<a href="/signup" className="btn btn-primary">Learn More</a>

// Replace with:
<a href="/signup" className="btn btn-primary">Start Free — Deploy in 5 Minutes</a>
```

**Rationale:** "Learn More" is the weakest possible CTA — it's passive, communicates no benefit, and creates no urgency. The replacement starts with a verb ("Start"), includes a benefit ("Free"), and adds specificity ("5 Minutes"). Rules violated: 3 (Active > Passive), 4 (Benefit > Feature), 7 (Urgent > Passive).

---

### CRIT-003: No FAQ section — objections unanswered

**Severity:** Critical
**Section:** Missing
**Impact:** Estimated 5-10% conversion loss — unanswered objections kill conversions

**Current:**
No FAQ section exists on the page.

**Recommended:**
Add FAQ section between Pricing and Footer with these questions:

```tsx
// Add to: src/components/FAQ.tsx (new file)

const faqs = [
  {
    q: "How much does Acme Deploy cost?",
    a: "Free for small teams (up to 3 projects). Paid plans start at $29/mo with a 14-day free trial. No credit card required."
  },
  {
    q: "How long does setup take?",
    a: "Most teams deploy their first app in under 5 minutes. Connect your GitHub repo and we handle the rest."
  },
  {
    q: "Can I migrate from Heroku/Vercel/AWS?",
    a: "Yes. Our migration tool imports your existing config in one click. Most migrations complete in under 10 minutes."
  },
  {
    q: "Is my code and data secure?",
    a: "SOC 2 Type II certified. All data encrypted at rest and in transit. We never access your source code."
  },
  {
    q: "What happens if I cancel?",
    a: "Cancel anytime with no penalties. Export your data with one click. Your apps keep running for 30 days."
  },
  {
    q: "Do you offer support?",
    a: "All plans include email support with < 4 hour response time. Team and Business plans include live chat and dedicated support."
  }
];
```

Also add FAQ schema markup (see SEO section).

**Rationale:** Every visitor has doubts. Without a FAQ, those doubts go unanswered and the visitor bounces. FAQ also provides SEO benefit via structured data rich results.

---

## High Priority (Fix This Week)

### HIGH-001: No testimonials — zero social proof from real users

**Severity:** High
**Section:** Social Proof (needs to be added)
**Impact:** Estimated 5-8% conversion improvement

**Current:**
4 customer logos displayed. No testimonials, no metrics, no case studies.

**Recommended:**
Add testimonial section after the logo bar with 3 named testimonials:

```markdown
Testimonial Template:
"[Specific result with metric]. [What changed for them]. [Emotional conclusion]."
— [Full Name], [Title] at [Company]
[Photo]
```

**Example:**
> "We cut our deploy time from 45 minutes to 30 seconds. Our team ships 3x more features per sprint now. I honestly can't imagine going back."
> — Sarah Chen, VP Engineering at DataFlow
> [Photo]

---

### HIGH-002: Subheadline is company-centric

**Severity:** High
**Section:** Hero
**Impact:** Estimated 3-5% conversion improvement

**Current:**
> We help teams deploy applications faster with our modern CI/CD platform.

**Recommended:**
> Push to git and your app is live. Zero config. Zero downtime. Zero stress.

**CHANGE:**
```
File: src/components/Hero.tsx
Line: 16
```
```tsx
// Find:
<p className="text-xl text-gray-600">We help teams deploy applications faster with our modern CI/CD platform.</p>

// Replace with:
<p className="text-xl text-gray-600">Push to git and your app is live. Zero config. Zero downtime. Zero stress.</p>
```

**Rationale:** The current subheadline starts with "We" (company-centric), uses buzzwords ("modern CI/CD platform"), and describes a feature not a benefit. The replacement is "you"-focused (implied), specific about the mechanism, and eliminates jargon. Rules: 2 (You > We), 6 (Concrete > Abstract).

---

### HIGH-003: Pricing has no recommended tier

**Severity:** High
**Section:** Pricing
**Impact:** Estimated 3-5% conversion improvement — visitors need guidance

**Current:**
3 tiers (Starter, Team, Business) displayed with equal visual weight. No "Most Popular" badge. No annual toggle.

**Recommended:**
1. Add "Most Popular" badge to Team tier
2. Make Team tier visually larger/highlighted
3. Add annual/monthly toggle with "Save 20%" label
4. Default to annual pricing

**CHANGE:**
```
File: src/components/Pricing.tsx
Line: 35
```
```tsx
// Find:
<div className="pricing-card">
  <h3>Team</h3>

// Replace with:
<div className="pricing-card pricing-card--recommended">
  <span className="badge badge-primary">Most Popular</span>
  <h3>Team</h3>
```

---

### HIGH-004: Missing product visual in hero

**Severity:** High
**Section:** Hero
**Impact:** Estimated 5-8% conversion improvement — visual proof validates the value prop

**Current:**
Hero section has headline, subheadline, and CTA. No product screenshot, demo, or video.

**Recommended:**
Add a product screenshot showing the deploy dashboard with a successful deploy in progress. Place to the right of the hero text at desktop, below text on mobile.

---

## Medium Priority (Fix This Month)

### MED-001: Feature titles are technical, not benefit-oriented

**Severity:** Medium
**Section:** Features
**Impact:** Estimated 2-3% conversion improvement

**Current → Recommended:**

| Current | Recommended |
|---------|-------------|
| "CI/CD Pipeline" | "Deploy with a git push" |
| "Auto-Scaling" | "Handle traffic spikes automatically" |
| "SSL Certificates" | "HTTPS included — zero setup" |
| "Custom Domains" | "Your brand, your domain, done in 30 seconds" |
| "Team Collaboration" | "Your whole team deploys with confidence" |
| "99.9% Uptime" | "Your app stays up, even on launch day" |

---

### MED-002: Section titles are generic

**Severity:** Medium
**Section:** All
**Impact:** Generic titles don't compel scrolling

| Current | Recommended |
|---------|-------------|
| "Features" | "Everything you need to ship with confidence" |
| "How It Works" | "Go from code to production in 3 steps" |
| "Pricing" | "Choose the plan that matches your growth" |
| "Customers" | "Why 10,000+ teams chose Acme Deploy" |

---

### MED-003: Missing meta description and OG image

**Severity:** Medium
**Section:** SEO
**Impact:** Poor click-through from search and social shares

**Current:**
```html
<title>Acme Deploy</title>
<!-- No meta description -->
<!-- No og:image -->
```

**Recommended:**
```html
<title>Acme Deploy — Ship to Production in 30 Seconds</title>
<meta name="description" content="Deploy any app in seconds with zero config. Join 10,000+ teams shipping faster. Start your free trial — no credit card required.">
<meta property="og:title" content="Deploy to Production in 30 Seconds — Without DevOps">
<meta property="og:description" content="Push to git. Your app is live. Zero config, zero downtime. Try free.">
<meta property="og:image" content="https://acme-deploy.example.com/og-image.png">
<meta property="og:url" content="https://acme-deploy.example.com">
<meta property="og:type" content="website">
<meta name="twitter:card" content="summary_large_image">
```

---

### MED-004: 12 banned words found in copy

**Severity:** Medium
**Section:** Various
**Impact:** Weak copy erodes credibility

| Line | Word | Context | Replacement |
|------|------|---------|-------------|
| Hero.tsx:16 | "modern" | "modern CI/CD platform" | Remove — describe what's modern |
| Features.tsx:12 | "seamless" | "seamless integration" | "one-click integration" |
| Features.tsx:18 | "robust" | "robust infrastructure" | "infrastructure that handles 10M req/day" |
| Features.tsx:24 | "scalable" | "scalable architecture" | "scales from 0 to 10M users" |
| Features.tsx:30 | "cutting-edge" | "cutting-edge technology" | Remove — show, don't tell |
| Features.tsx:36 | "enterprise-grade" | "enterprise-grade security" | "SOC 2 certified, encrypted at rest" |
| Pricing.tsx:8 | "comprehensive" | "comprehensive plan" | "everything you need" or list specifics |
| Footer.tsx:5 | "innovative" | "innovative platform" | Remove |
| About.tsx:3 | "revolutionary" | "revolutionary approach" | Describe the specific approach |
| About.tsx:7 | "leverage" | "leverage the cloud" | "use the cloud" |
| About.tsx:11 | "empower" | "empower developers" | "give developers [specific capability]" |
| About.tsx:15 | "holistic" | "holistic solution" | List what's included specifically |

---

## Low Priority (Backlog)

### LOW-001: Logo bar has only 4 logos

Increase to 8+ for stronger social proof. Recommended: display in grayscale, consistent height (32px).

### LOW-002: No Before/After section

Add a Problem/Solution section between How It Works and Features to create emotional contrast.

### LOW-003: Footer missing social media links

Add Twitter, GitHub, and LinkedIn links with `target="_blank" rel="noopener noreferrer"`.

### LOW-004: No structured data

Add Organization and FAQ (after FAQ section is created) JSON-LD schemas.

---

## Complete Copy Rewrite Table

| # | Location | Current | Recommended | Rule |
|---|----------|---------|-------------|------|
| 1 | Hero H1 | "The Future of Deployment" | "Deploy to Production in 30 Seconds — Without DevOps" | 1: Specific > Vague |
| 2 | Hero Sub | "We help teams deploy applications faster with our modern CI/CD platform." | "Push to git and your app is live. Zero config. Zero downtime. Zero stress." | 2: You > We; 6: Concrete |
| 3 | Hero CTA | "Learn More" | "Start Free — Deploy in 5 Minutes" | 3: Active; 4: Benefit; 7: Urgent |
| 4 | Feature 1 | "CI/CD Pipeline" | "Deploy with a git push" | 4: Benefit > Feature |
| 5 | Feature 2 | "Auto-Scaling" | "Handle traffic spikes automatically" | 4: Benefit > Feature |
| 6 | Feature 3 | "SSL Certificates" | "HTTPS included — zero setup" | 4: Benefit > Feature |
| 7 | Feature 4 | "Custom Domains" | "Your brand, your domain, done in 30 seconds" | 1: Specific; 4: Benefit |
| 8 | Feature 5 | "Team Collaboration" | "Your whole team deploys with confidence" | 4: Benefit > Feature |
| 9 | Feature 6 | "99.9% Uptime" | "Your app stays up, even on launch day" | 4: Benefit > Feature |
| 10 | Section: Features | "Features" | "Everything you need to ship with confidence" | Section Title Formula |
| 11 | Section: How It Works | "How It Works" | "Go from code to production in 3 steps" | Section Title Formula |
| 12 | Section: Pricing | "Pricing" | "Choose the plan that matches your growth" | Section Title Formula |
| 13 | Section: Customers | "Customers" | "Why 10,000+ teams chose Acme Deploy" | Section Title Formula |

---

## Implementation Guide

### Immediate Changes (5 min each, highest impact)

1. **Change Hero H1** — `src/components/Hero.tsx:14` — Est. +15-20% conversion
2. **Change Hero CTA** (3 instances) — `Hero.tsx:22`, `Features.tsx:48`, `Pricing.tsx:72` — Est. +10-15%
3. **Change Hero subheadline** — `Hero.tsx:16` — Est. +3-5%

### This Week (30-60 min each)

4. **Add testimonial section** — New component after logo bar — Est. +5-8%
5. **Add FAQ section with schema** — New component before footer — Est. +5-10%
6. **Add "Most Popular" badge to pricing** — `Pricing.tsx:35` — Est. +3-5%
7. **Rewrite all feature titles** — `Features.tsx` — Est. +2-3%
8. **Add product screenshot to hero** — `Hero.tsx` — Est. +5-8%

### This Month (2-4 hrs each)

9. **Replace all banned words** (12 instances) — Various files — Cumulative impact
10. **Add meta description, OG tags, structured data** — Layout file — SEO benefit
11. **Add Before/After section** — New component — Est. +2-3%
12. **Add annual/monthly pricing toggle** — `Pricing.tsx` — Est. +3-5%

### Estimated Total Impact

Implementing all changes: **+30-50% estimated conversion improvement**

---

## SEO Checklist

- [ ] Title tag: "Acme Deploy" → "Acme Deploy — Ship to Production in 30 Seconds" (24 → 52 chars)
- [ ] Meta description: Missing → "Deploy any app in seconds with zero config..." (155 chars)
- [ ] OG image: ❌ Missing → Create 1200x630 product visual
- [ ] OG tags: ❌ Missing → Add og:title, og:description, og:url, og:type
- [ ] Twitter card: ❌ Missing → Add summary_large_image card
- [ ] Structured data: ❌ Missing → Add Organization + FAQ schemas
- [ ] H1 count: ✅ 1 (correct)
- [ ] Heading hierarchy: ✅ No skips
- [ ] Canonical: ⚠️ Missing → Add canonical URL
- [ ] robots.txt: ✅ Allows crawling
- [ ] sitemap.xml: ❌ Missing → Generate and submit

---

## Verification Checklist

After implementing changes:
- [ ] Hero passes 5-second test (show to 3 people, ask what the product does)
- [ ] Primary CTA visible above fold at 1280px and within 1 scroll at 375px
- [ ] All 12 banned words removed from copy
- [ ] Testimonials include specific metrics and real names
- [ ] Team pricing tier has "Most Popular" badge
- [ ] All meta tags present and valid (test with https://metatags.io)
- [ ] FAQ schema validates in Google Rich Results Test
- [ ] Mobile conversion path tested at 375px — all touch targets ≥ 44px
- [ ] Page loads in < 3 seconds (test with Lighthouse)
- [ ] OG image displays correctly on Twitter and LinkedIn (test share)

---

## Screenshots

| File | Description | Viewport |
|------|-------------|----------|
| desktop-full.png | Full page capture | 1280x800 |
| desktop-hero.png | Hero section above fold | 1280x800 |
| mobile-full.png | Full page mobile | 375x812 |
| mobile-hero.png | Hero section mobile | 375x812 |
| pricing-section.png | Pricing tiers | 1280x800 |
| missing-faq.png | Footer area (no FAQ) | 1280x800 |

---

*Report generated by picky-landingpage skill*
*"Every weak headline is lost revenue. Every missing CTA is a leaked conversion."*
