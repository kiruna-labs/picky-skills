# Section Patterns — Landing Page Architecture

## Audit Philosophy

**Every section must earn its place on the page.** A landing page is a guided journey from "What is this?" to "I need this." Each section moves the visitor one step closer to conversion. Sections that don't advance this journey are dead weight.

---

## Optimal Section Order

The highest-converting landing pages follow this architecture:

```
1. Navigation / Header
2. Hero (value prop + CTA)
3. Social Proof Bar (logos, metrics)
4. How It Works (3 steps)
5. Before/After or Problem/Solution
6. Features / Benefits (with visuals)
7. Detailed Social Proof (testimonials, case studies)
8. Pricing
9. FAQ
10. Final CTA
11. Footer
```

**Not every page needs every section**, but sections MUST appear in a logical progression:

1. **Hook** (Hero) → What is this? Why should I care?
2. **Trust** (Social Proof) → Does this actually work?
3. **Educate** (How It Works, Features) → How does it work?
4. **Prove** (Testimonials, Before/After) → Show me evidence
5. **Convert** (Pricing, CTA) → What do I do next?
6. **Reassure** (FAQ, Guarantees) → What if I have doubts?

---

## 1. Navigation / Header

### Checklist

- [ ] Logo visible, links to homepage
- [ ] Max 5-7 nav items (fewer = less distraction)
- [ ] CTA button in nav (right-aligned, highest contrast)
- [ ] Nav CTA matches page's primary CTA
- [ ] Sticky/fixed nav on scroll (recommended for pages > 3 viewports)
- [ ] Mobile hamburger menu works correctly
- [ ] No dropdown menus on landing pages (distracting)
- [ ] Nav doesn't overshadow hero content

### Scan Commands

```javascript
// Nav audit
const nav = document.querySelector('nav, header');
if (nav) {
  const links = nav.querySelectorAll('a');
  const buttons = nav.querySelectorAll('button, a[class*="btn"], a[class*="cta"]');
  console.log(`Nav links: ${links.length} (target: 5-7)`);
  console.log(`Nav CTAs: ${buttons.length}`);
  links.forEach(a => console.log(`  → "${a.textContent.trim()}" → ${a.href}`));

  // Check if nav is sticky
  const navStyle = getComputedStyle(nav);
  const isSticky = navStyle.position === 'fixed' || navStyle.position === 'sticky';
  console.log(`Sticky nav: ${isSticky ? '✅' : '⚠️ Not sticky'}`);
}
```

### Anti-Patterns

| Anti-Pattern | Problem | Fix |
|-------------|---------|-----|
| 10+ nav items | Decision paralysis, distraction | Reduce to 5-7 essential items |
| No CTA in nav | Missed conversion opportunity | Add primary CTA button |
| Nav CTA differs from hero CTA | Confusing, mixed signals | Align all CTAs |
| Dropdown menus | Distraction from conversion flow | Remove on landing pages |
| Nav covers hero on scroll | Reduces hero impact | Use transparent → solid nav |

---

## 2. How It Works Section

### Purpose

Reduces perceived complexity. Makes the product feel simple and approachable.

### Checklist

- [ ] **3 steps maximum** (more = cognitive overload)
- [ ] Each step starts with a **numbered marker** (1, 2, 3)
- [ ] Each step has an **action verb** heading ("Connect", "Configure", "Deploy")
- [ ] Each step has a **one-sentence description**
- [ ] Optional: visual/icon for each step
- [ ] Section title is compelling (not just "How It Works")
- [ ] CTA after section ("Ready to start? [CTA]")

### Template

```
[Compelling Section Title: "Go from idea to production in 3 steps"]

1. [Action Verb] — [Brief description of step 1]
   [Optional: Icon or small visual]

2. [Action Verb] — [Brief description of step 2]
   [Optional: Icon or small visual]

3. [Action Verb] — [Brief description of step 3]
   [Optional: Icon or small visual]

[CTA: "Start Your First Project"]
```

### Good Examples

```
Step 1: Connect — Link your GitHub repo in one click
Step 2: Configure — Choose your settings or use our smart defaults
Step 3: Deploy — Push to production with zero downtime
```

### Anti-Patterns

| Anti-Pattern | Problem | Fix |
|-------------|---------|-----|
| 5+ steps | Feels complex | Condense to 3 |
| No numbers/order | Steps feel unstructured | Add clear numbering |
| Passive language | "Your repo is connected" | Active: "Connect your repo" |
| Too much detail | Overwhelms visitor | One sentence per step |
| No CTA after section | Missed conversion point | Add "Get Started" CTA |

### Scan Commands

```javascript
// Find How It Works section
const sections = document.querySelectorAll('section, [class*="section"]');
sections.forEach(section => {
  const heading = section.querySelector('h2');
  if (heading && /how|step|process|works|start/i.test(heading.textContent)) {
    const steps = section.querySelectorAll('li, [class*="step"], [class*="card"]');
    console.log(`How It Works section: "${heading.textContent.trim()}"`);
    console.log(`Steps found: ${steps.length} ${steps.length <= 3 ? '✅' : '⚠️ Too many'}`);
    steps.forEach((step, i) => {
      const title = step.querySelector('h3, h4, strong')?.textContent.trim();
      console.log(`  Step ${i + 1}: ${title || step.textContent.trim().slice(0, 60)}`);
    });
  }
});
```

---

## 3. Before/After (Problem/Solution) Section

### Purpose

Creates emotional contrast. The visitor must feel the pain of "before" and desire the relief of "after."

### Checklist

- [ ] **"Before" is specific** — names exact pains the visitor recognizes
- [ ] **"After" is measurable** — concrete improvements, not vague promises
- [ ] **Visual contrast** — design differentiates before/after clearly
- [ ] **Relatable** — visitor sees themselves in the "before" state
- [ ] **Product is the bridge** — clear that the product causes the transformation

### Template Options

**Option A: Two-Column**
```
[WITHOUT Product]          |  [WITH Product]
❌ Manual deploys          |  ✅ Automated CI/CD
❌ 2-hour deploy process   |  ✅ 30-second deploys
❌ Weekend firefighting     |  ✅ Zero-downtime releases
❌ "It works on my machine" |  ✅ Identical environments
```

**Option B: Story Arc**
```
BEFORE: [Pain description — make it visceral and specific]
"Every Friday, your team dreads the deploy. Manual steps, crossed fingers, rollback scripts ready..."

AFTER: [Outcome description — make it desirable and concrete]
"Push to main. It's live in 30 seconds. Go home early."
```

**Option C: Metric Comparison**
```
| Metric | Before | After |
|--------|--------|-------|
| Deploy time | 2 hours | 30 seconds |
| Deploy frequency | Monthly | Daily |
| Incidents per deploy | 3 | 0 |
```

### Anti-Patterns

| Anti-Pattern | Fix |
|-------------|-----|
| "Before" too generic ("old way") | Name specific pain points |
| "After" too vague ("better way") | Use specific metrics |
| No visual contrast | Use colors, columns, or icons |
| Both sides equally wordy | "Before" slightly longer (empathy), "After" punchy |

---

## 4. Features / Benefits Section

### Checklist

- [ ] **Benefit-first headlines** — lead with outcome, not technical feature
- [ ] **6-8 features max** — more creates overwhelm
- [ ] **Visual for each** — icon, screenshot, or illustration
- [ ] **Scannable layout** — grid or alternating layout
- [ ] **Consistent card/item format** — same structure for each feature
- [ ] **No jargon** — plain language a non-technical visitor understands

### Layout Options

**Grid (3-column)** — Best for 6+ features
```
[Icon] Feature 1    [Icon] Feature 2    [Icon] Feature 3
[Description]       [Description]       [Description]

[Icon] Feature 4    [Icon] Feature 5    [Icon] Feature 6
[Description]       [Description]       [Description]
```

**Alternating (zigzag)** — Best for 3-4 features with screenshots
```
[Text + CTA]  |  [Screenshot]
[Screenshot]  |  [Text + CTA]
[Text + CTA]  |  [Screenshot]
```

**List with icons** — Best for simple feature enumeration
```
✅ [Feature 1 — benefit description]
✅ [Feature 2 — benefit description]
✅ [Feature 3 — benefit description]
```

### Feature → Benefit Translation Check

```javascript
// Extract feature section content
const featureSection = document.querySelector('[class*="feature"], [id*="feature"]');
if (featureSection) {
  const items = featureSection.querySelectorAll('h3, h4, [class*="title"]');
  items.forEach(item => {
    const text = item.textContent.trim();
    // Check if it sounds like a feature (technical) vs benefit (outcome)
    const featureWords = /api|integration|dashboard|engine|pipeline|module|system|tool|framework|architecture/i;
    const benefitWords = /save|reduce|increase|improve|faster|easier|never|always|without|stop|start/i;
    const isFeature = featureWords.test(text) && !benefitWords.test(text);
    console.log(`${isFeature ? '⚠️ Feature-heavy' : '✅ Benefit-oriented'}: "${text}"`);
  });
}
```

---

## 5. FAQ Section

### Checklist

- [ ] **5-8 questions** (fewer = not addressing enough objections; more = overwhelming)
- [ ] **Top objections addressed** (price, difficulty, security, migration, comparison)
- [ ] **Answers are concise** (2-4 sentences max per answer)
- [ ] **Expand/collapse works** (accordion pattern)
- [ ] **FAQ schema markup** (JSON-LD for rich results)
- [ ] **CTA after FAQ** ("Still have questions? [Contact] or [Start Free Trial]")
- [ ] **Section title is inviting** (not just "FAQ")

### Must-Answer Questions for SaaS

1. "How much does it cost?" / "Is there a free plan?"
2. "How long does setup take?"
3. "Can I migrate from [competitor]?"
4. "Is my data secure?"
5. "What happens if I cancel?"
6. "Do you offer support?"
7. "Does it integrate with [tool]?"
8. "What makes you different from [competitor]?"

### FAQ Schema Template

```json
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {
      "@type": "Question",
      "name": "How much does [Product] cost?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Answer text here with link if needed."
      }
    }
  ]
}
```

### Scan Commands

```javascript
// FAQ section audit
const faqSection = document.querySelector('[class*="faq"], [id*="faq"]');
if (faqSection) {
  const questions = faqSection.querySelectorAll('h3, h4, button, summary, [class*="question"]');
  console.log(`FAQ questions: ${questions.length} ${questions.length >= 5 && questions.length <= 8 ? '✅' : '⚠️'}`);
  questions.forEach(q => console.log(`  Q: "${q.textContent.trim().slice(0, 80)}"`));

  // Check for accordion functionality
  const details = faqSection.querySelectorAll('details');
  const buttons = faqSection.querySelectorAll('button[aria-expanded]');
  console.log(`Accordion type: ${details.length > 0 ? '<details>' : buttons.length > 0 ? 'aria-expanded buttons' : '⚠️ Not collapsible'}`);
} else {
  console.warn('❌ No FAQ section found');
}

// Check for FAQ schema
const schemas = document.querySelectorAll('script[type="application/ld+json"]');
const hasFaqSchema = [...schemas].some(s => s.textContent.includes('FAQPage'));
console.log(`FAQ Schema: ${hasFaqSchema ? '✅ Present' : '❌ Missing'}`);
```

---

## 6. Final CTA Section

### Purpose

Last chance to convert before the footer. Visitor has read everything — give them the final push.

### Checklist

- [ ] **Different framing from hero CTA** — summary tone, not introduction
- [ ] **Reinforcement copy** — 1-2 sentences restating core value
- [ ] **High visual contrast** — background color change, large CTA
- [ ] **Trust reinforcer** — "Join 10,000+ teams" or "No credit card required"
- [ ] **Primary CTA** — same action as hero, possibly with added urgency

### Template

```
[Full-width colored background]

[Heading: "Ready to [outcome]?"]
[Subtext: "Join [N]+ [audience] who already [benefit]. [Risk reducer]"]

[████ Large Primary CTA ████]
```

### Example

```
Ready to ship faster?
Join 10,000+ engineering teams deploying with confidence. Free forever for small teams.

[Start Building for Free →]
```

---

## 7. Footer

### Checklist

- [ ] **Legal links** — Privacy Policy, Terms of Service
- [ ] **Contact info** — Email, support link, or chat
- [ ] **Social media links** — Open in new tab (`target="_blank" rel="noopener"`)
- [ ] **Copyright year** — Current year (not hardcoded to past year)
- [ ] **Product links** — Pricing, Docs, Changelog, Status page
- [ ] **Company links** — About, Blog, Careers (if applicable)
- [ ] **NOT the primary CTA location** — CTA should be above footer

```javascript
// Footer audit
const footer = document.querySelector('footer');
if (footer) {
  const links = footer.querySelectorAll('a');
  console.log(`Footer links: ${links.length}`);
  links.forEach(a => {
    const external = a.target === '_blank';
    const noopener = a.rel?.includes('noopener');
    if (external && !noopener) {
      console.warn(`⚠️ External link missing rel="noopener": ${a.href}`);
    }
    console.log(`  ${external ? '↗' : '→'} "${a.textContent.trim()}" → ${a.href.slice(0, 60)}`);
  });

  // Check copyright year
  const yearMatch = footer.textContent.match(/©\s*(\d{4})/);
  if (yearMatch) {
    const year = parseInt(yearMatch[1]);
    const currentYear = new Date().getFullYear();
    console.log(`Copyright year: ${year} ${year === currentYear ? '✅' : '❌ Outdated'}`);
  }
} else {
  console.warn('❌ No <footer> element found');
}
```

---

## 8. CTA Placement Map

CTAs should be placed strategically throughout the page:

```
Section              | CTA Type    | Purpose
---------------------|-------------|---------------------------
Nav (top-right)      | Primary     | Always accessible
Hero                 | Primary     | First conversion point
After How It Works   | Primary     | "Ready to start?"
After Features       | Secondary   | "See all features" / "Try free"
Each Pricing Tier    | Per-tier    | "Start free" / "Start trial"
After FAQ            | Primary     | "Still have questions?" + CTA
Final CTA Section    | Primary     | Last push before footer
```

### CTA Count Check

```javascript
// Count CTAs per section
const sections = document.querySelectorAll('section, [class*="section"], header, footer, [class*="hero"]');
let totalCTAs = 0;
sections.forEach((section, i) => {
  const ctas = section.querySelectorAll('a[class*="btn"], a[class*="cta"], button[class*="btn"], button[class*="cta"]');
  const heading = section.querySelector('h1, h2');
  const name = heading?.textContent.trim().slice(0, 30) || section.className.split(' ')[0] || `Section ${i}`;
  if (ctas.length > 0) {
    console.log(`${name}: ${ctas.length} CTA(s)`);
    ctas.forEach(c => console.log(`  → "${c.textContent.trim()}"`));
  } else {
    console.log(`${name}: ⚠️ No CTA`);
  }
  totalCTAs += ctas.length;
});
console.log(`\nTotal CTAs on page: ${totalCTAs}`);
```

---

## Section Completeness Audit

```javascript
// Check which standard sections exist
const sectionPatterns = {
  'Navigation': 'nav, header',
  'Hero': '[class*="hero"], main > section:first-child, main > div:first-child',
  'Logo Bar': '[class*="logo"], [class*="customer"], [class*="trusted"]',
  'How It Works': null, // Check by heading text
  'Features': '[class*="feature"], [id*="feature"]',
  'Testimonials': '[class*="testimonial"], [class*="review"], [class*="quote"]',
  'Pricing': '[class*="pricing"], [id*="pricing"]',
  'FAQ': '[class*="faq"], [id*="faq"]',
  'Final CTA': null, // Check by heading text
  'Footer': 'footer'
};

Object.entries(sectionPatterns).forEach(([name, selector]) => {
  if (selector) {
    const found = document.querySelector(selector);
    console.log(`${found ? '✅' : '❌'} ${name}`);
  }
});

// Check by heading content for sections without obvious class names
const headings = document.querySelectorAll('h2');
const headingTexts = [...headings].map(h => h.textContent.trim().toLowerCase());

const sectionKeywords = {
  'How It Works': ['how', 'step', 'process', 'works', 'start', 'get started'],
  'Before/After': ['before', 'after', 'without', 'with', 'problem', 'solution', 'transform'],
  'Final CTA': ['ready', 'get started', 'start today', 'try', 'join']
};

Object.entries(sectionKeywords).forEach(([name, keywords]) => {
  const found = headingTexts.some(text => keywords.some(kw => text.includes(kw)));
  console.log(`${found ? '✅' : '⚠️'} ${name} (by heading keywords)`);
});
```
