# Copy Rules — The 7 Laws of Conversion Copy

## Audit Philosophy

**Words are the highest-leverage element on any landing page.** A single headline change can swing conversion rates by 30%+. Every word earns its place or gets cut. There are no "filler" words on a high-converting page — only words that move the visitor toward action.

---

## The 7 Copy Rules

### Rule 1: Specific > Vague

**Every claim must be provable or measurable.**

| Vague (FAIL) | Specific (PASS) |
|-------------|-----------------|
| "Fast deployment" | "Deploy in 30 seconds" |
| "Save time" | "Save 10 hours per week" |
| "Trusted by thousands" | "Trusted by 12,847 teams" |
| "Improve performance" | "2.3x faster page loads" |
| "Scale effortlessly" | "Handles 10M requests/day" |
| "Better collaboration" | "50% fewer Slack messages about code" |

**Test:** Can you put a number on it? If yes, do it. If no, find one.

### Rule 2: "You" > "We"

**The visitor cares about themselves, not the company.**

| "We" (FAIL) | "You" (PASS) |
|-------------|--------------|
| "We built the fastest CI/CD" | "Your deploys finish in seconds" |
| "Our platform enables teams" | "Your team ships weekly" |
| "We offer 24/7 support" | "You get help anytime you need it" |
| "We integrate with 100+ tools" | "Connect your existing tools in one click" |

**Scan Command:**
```bash
# Count "we/our" vs "you/your" ratio
echo "We/Our:" && grep -roni "\bwe\b\|\bour\b\|\bwe're\b\|\bwe've\b" --include="*.tsx" --include="*.jsx" --include="*.html" --include="*.astro" | wc -l
echo "You/Your:" && grep -roni "\byou\b\|\byour\b\|\byou're\b\|\byou'll\b\|\byou've\b" --include="*.tsx" --include="*.jsx" --include="*.html" --include="*.astro" | wc -l
```

**Target ratio:** "You/Your" should outnumber "We/Our" by at least 2:1.

### Rule 3: Active > Passive

**Active voice creates energy and clarity.**

| Passive (FAIL) | Active (PASS) |
|----------------|---------------|
| "Reports can be generated" | "Generate reports instantly" |
| "Your code is deployed automatically" | "Deploy your code automatically" |
| "Data is analyzed in real-time" | "Analyze your data in real-time" |
| "Results are delivered to your inbox" | "Get results in your inbox" |

**Test:** Is there a clear subject performing the action? If not, rewrite.

### Rule 4: Benefit > Feature

**Features are what it does. Benefits are what the visitor gets.**

| Feature (FAIL) | Benefit (PASS) |
|----------------|----------------|
| "AI-powered analytics" | "Predict churn 2 weeks before it happens" |
| "Real-time sync" | "Every team member sees the latest version, always" |
| "Automated testing" | "Catch bugs before your users do" |
| "SSO integration" | "One login for everything — no more password resets" |
| "Custom dashboards" | "See exactly the metrics you care about" |
| "Webhook support" | "Get notified the moment anything changes" |

**Translation formula:** "[Feature]" → "So you can [outcome the visitor wants]"

### Rule 5: Short > Long

**Brevity is clarity. Clarity converts.**

| Long (FAIL) | Short (PASS) |
|-------------|--------------|
| "Our comprehensive suite of tools enables your development team to streamline and optimize their workflow" | "Ship code faster. Period." |
| "With our advanced analytics platform, you'll be able to gain unprecedented insights into user behavior" | "See what your users actually do." |

**Guidelines:**
- Headlines: ≤ 12 words
- Subheadlines: ≤ 25 words
- Body paragraphs: ≤ 3 lines
- Sentences: ≤ 20 words
- Bullet points: ≤ 10 words each
- CTA buttons: 2-6 words

**Scan Command:**
```bash
# Find long paragraphs in source (potential copy bloat)
grep -rn "<p>" --include="*.tsx" --include="*.jsx" --include="*.html" -A5 | grep -E ".{200,}"
```

### Rule 6: Concrete > Abstract

**Tangible outcomes over philosophical statements.**

| Abstract (FAIL) | Concrete (PASS) |
|-----------------|-----------------|
| "Transform your digital experience" | "Your checkout loads in 0.8 seconds" |
| "Empower your workforce" | "New hires are productive on day 1" |
| "Unlock your potential" | "Build your first app in 15 minutes" |
| "Drive meaningful outcomes" | "Reduce support tickets by 60%" |
| "Enable digital transformation" | "Replace 5 tools with 1 dashboard" |

**Test:** Can the visitor picture this happening? If not, make it more tangible.

### Rule 7: Urgent > Passive

**Give the visitor a reason to act now, not later.**

| Passive (FAIL) | Urgent (PASS) |
|----------------|---------------|
| "Try our product" | "Start free — your first project in 5 minutes" |
| "Sign up today" | "Every day without monitoring costs you $X in downtime" |
| "Check it out" | "Your competitors are already shipping faster" |
| "Available now" | "Free during beta — pricing starts in March" |

**Urgency types:**
- **Time-based:** Limited offer, beta pricing, upcoming deadline
- **Loss aversion:** Cost of inaction, competitor advantage
- **Ease-based:** "Only takes 2 minutes", "No setup required"
- **Social:** "Join 10,000+ teams already using..."

---

## Banned Words List

These words are filler. They communicate nothing. Replace every instance.

### Tier 1: Always Replace (Zero Information)

| Banned Word | What to Use Instead |
|-------------|-------------------|
| seamless | Describe the actual experience |
| robust | Quantify the capability |
| leverage | "use" or specific action |
| utilize | "use" |
| synergy | Describe the actual benefit |
| cutting-edge | What specifically is novel? |
| best-in-class | Prove it with a metric |
| world-class | Prove it with a metric |
| next-generation | What specifically is new? |
| innovative | What specifically is innovative? |
| revolutionary | What specifically changed? |
| game-changing | What specific outcome changed? |
| disruptive | How does it disrupt? Be specific |
| empower | What can they DO now? |
| holistic | Which specific parts are included? |
| scalable | "Handles [X] to [Y]" with real numbers |
| enterprise-grade | Which specific enterprise features? |
| mission-critical | Why specifically does it matter? |
| bleeding-edge | What's new about it? |
| paradigm | Never use this word |
| ecosystem | "tools" or name the specific integrations |
| turnkey | "ready to use" or "zero setup" |
| end-to-end | "from [start] to [finish]" specifically |
| frictionless | Describe the actual experience |
| state-of-the-art | What's specifically modern about it? |

### Tier 2: Usually Replace (Vague When Used Alone)

| Word | OK When... | Replace When... |
|------|-----------|----------------|
| solution | Paired with specific problem | Used alone ("our solution") |
| platform | Describing architecture | Used as a marketing word |
| powerful | Followed by proof | Used as empty adjective |
| comprehensive | Listing what's included | Used alone |
| streamline | Saying what's simplified | Used without specifics |
| optimize | With metrics | Without metrics |
| transform | Describing before/after | Used abstractly |
| intuitive | With user testing data | Used as opinion |

### Scan Command for Banned Words

```bash
# Full banned words scan — find every instance
grep -rni \
  "seamless\|seamlessly\|robust\|leverage\b\|leveraging\|utilize\b\|utilizing\|synergy\|cutting.edge\|best.in.class\|world.class\|next.gen\|innovative\|revolutionary\|game.changing\|disruptive\|empower\|empowering\|holistic\|scalable\|enterprise.grade\|mission.critical\|bleeding.edge\|paradigm\|ecosystem\|turnkey\|end.to.end\|frictionless\|state.of.the.art" \
  --include="*.tsx" --include="*.jsx" --include="*.html" --include="*.astro" --include="*.svelte" --include="*.md" --include="*.mdx"
```

---

## Section Title Formulas

Section titles should compel continued scrolling. Generic titles are wasted real estate.

### Bad Section Titles (Generic)

| Title | Problem |
|-------|---------|
| "Features" | Doesn't compel reading |
| "How It Works" | Generic, expected |
| "Pricing" | Functional but not compelling |
| "About Us" | Visitor doesn't care about you yet |
| "Testimonials" | Reads like a website template |
| "FAQ" | Functional but not inviting |
| "Contact" | Purely functional |

### Good Section Title Formulas

| Formula | Example |
|---------|---------|
| "[Outcome] in [N] steps" | "Go from idea to deployed app in 3 steps" |
| "[What] without [pain]" | "Scale to millions without DevOps" |
| "Everything you need to [outcome]" | "Everything you need to ship with confidence" |
| "[N] reasons [audience] choose [product]" | "Why 10,000+ teams chose Acme" |
| "Stop [pain]. Start [outcome]." | "Stop firefighting deploys. Start shipping features." |
| "What [audience] are saying" | "What engineering leaders are saying" |
| "[Audience]? Here's what you get." | "Growing SaaS team? Here's what you get." |
| "Common questions about [specific thing]" | "Common questions about our free tier" |
| "Choose the plan that [outcome]" | "Choose the plan that matches your growth" |

### Section Title Audit Command

```javascript
// Extract all section titles
document.querySelectorAll('h2, h3').forEach(h => {
  const generic = ['features', 'how it works', 'pricing', 'about', 'about us', 'testimonials', 'faq', 'contact', 'contact us', 'our team', 'our story', 'get started', 'learn more'];
  const text = h.textContent.trim().toLowerCase();
  const isGeneric = generic.some(g => text === g || text === g + 's');
  console.log(`${h.tagName} ${isGeneric ? '⚠️ GENERIC' : '✅'}: "${h.textContent.trim()}"`);
});
```

---

## CTA Copy Audit

### Every CTA on the Page

Extract and audit every CTA:

```javascript
// Find and evaluate every CTA
const ctaSelectors = 'a[class*="btn"], a[class*="cta"], a[class*="button"], button:not(nav button):not([aria-label="Close"])';
document.querySelectorAll(ctaSelectors).forEach(el => {
  const text = el.textContent.trim();
  if (text.length < 2 || text.length > 50) return;

  const weakCTAs = ['learn more', 'read more', 'click here', 'submit', 'send', 'go', 'enter', 'continue', 'next', 'get started'];
  const isWeak = weakCTAs.some(w => text.toLowerCase() === w);
  const startsWithVerb = /^(start|get|try|create|build|deploy|launch|discover|explore|see|watch|download|join|claim|activate|unlock|begin|request|schedule|book)/i.test(text);

  console.log(`${isWeak ? '❌ WEAK' : startsWithVerb ? '✅ GOOD' : '⚠️ CHECK'}: "${text}"`);
});
```

### CTA Placement Check

CTAs should appear after every major section:

```javascript
// Check CTA distribution across page sections
const sections = document.querySelectorAll('section, [class*="section"]');
sections.forEach((section, i) => {
  const ctas = section.querySelectorAll('a[class*="btn"], a[class*="cta"], button[class*="cta"]');
  const heading = section.querySelector('h2, h3');
  const title = heading?.textContent.trim().slice(0, 40) || `Section ${i + 1}`;
  console.log(`${ctas.length > 0 ? '✅' : '⚠️'} "${title}": ${ctas.length} CTA(s)`);
});
```

---

## Copy Audit Report Format

For each piece of copy that violates any rule:

```markdown
### COPY-[NN]: [Brief description]

**Location:** [Section] → [Element type (H1, paragraph, CTA, etc.)]
**Rule Violated:** Rule [N]: [Rule Name]

**Current:**
> [exact current text]

**Recommended:**
> [exact replacement text]

**Rationale:** [Why this change improves conversion]
```

### Summary Table

```markdown
| # | Location | Current | Recommended | Rule |
|---|----------|---------|-------------|------|
| 1 | Hero H1 | "The Future of Work" | "Ship Features 3x Faster — Without Hiring" | Rule 1 |
| 2 | Hero Sub | "We help teams collaborate better" | "Your team ships weekly instead of monthly" | Rule 2, 4 |
| 3 | CTA | "Learn More" | "Start Free — Deploy in 5 Minutes" | Rule 4, 7 |
| ... | ... | ... | ... | ... |
```
