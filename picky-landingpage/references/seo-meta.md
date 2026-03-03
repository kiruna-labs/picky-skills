# SEO & Meta Tags Audit

## Audit Philosophy

**If search engines can't understand your page, you're invisible.** Landing pages need perfect meta tags for search ranking, perfect Open Graph tags for social sharing, and perfect structured data for rich results. Every missing tag is a missed opportunity to appear in front of potential customers.

---

## 1. Essential Meta Tags

### 1.1 Title Tag

**The most important on-page SEO element.**

- [ ] Present in `<head>`
- [ ] 50-60 characters (search engines truncate at ~60)
- [ ] Contains primary keyword near the beginning
- [ ] Contains brand name (usually at end)
- [ ] Unique (not duplicated on other pages)
- [ ] Compelling (would a searcher click this?)
- [ ] Not keyword-stuffed

**Formula:** `[Primary Keyword/Benefit] — [Brand Name]` or `[Brand] — [Benefit/Keyword]`

**Examples:**
- Good: "Deploy Apps Instantly — No DevOps Needed | Acme"
- Bad: "Acme | Home"
- Bad: "Best Cloud Platform | Cloud Deployment | Cloud Hosting | Acme"

### 1.2 Meta Description

**Your ad copy in search results.**

- [ ] Present in `<head>`
- [ ] 150-160 characters
- [ ] Contains primary keyword naturally
- [ ] Includes a call-to-action ("Start free", "Try now")
- [ ] Includes a value proposition
- [ ] Not duplicated on other pages
- [ ] Not just a copy of the first paragraph

**Formula:** `[What it does] + [key benefit] + [CTA]. [Trust signal].`

**Example:** "Deploy any app in seconds with zero config. Join 12,000+ teams shipping faster. Start your free trial today — no credit card required."

### 1.3 Viewport Meta

- [ ] `<meta name="viewport" content="width=device-width, initial-scale=1">` present
- [ ] No `maximum-scale=1` (breaks accessibility zoom)
- [ ] No `user-scalable=no` (breaks accessibility zoom)

### 1.4 Canonical URL

- [ ] `<link rel="canonical" href="...">` present
- [ ] Points to the correct, preferred URL
- [ ] Uses absolute URL (not relative)
- [ ] Matches the actual page URL (no mismatches)
- [ ] Uses HTTPS (not HTTP)

### 1.5 Favicon

- [ ] `<link rel="icon">` present
- [ ] Multiple sizes provided (16x16, 32x32, 180x180 for Apple)
- [ ] Actually loads (not 404)
- [ ] Looks good at small size

### Scan Commands

```javascript
// Complete meta tag audit
const audit = {
  title: {
    value: document.title,
    length: document.title.length,
    ok: document.title.length >= 30 && document.title.length <= 60
  },
  description: (() => {
    const el = document.querySelector('meta[name="description"]');
    const val = el?.content || '';
    return { value: val, length: val.length, ok: val.length >= 120 && val.length <= 160, present: !!el };
  })(),
  viewport: {
    value: document.querySelector('meta[name="viewport"]')?.content,
    present: !!document.querySelector('meta[name="viewport"]'),
    hasNoScale: /user-scalable\s*=\s*no|maximum-scale\s*=\s*1/.test(document.querySelector('meta[name="viewport"]')?.content || '')
  },
  canonical: {
    value: document.querySelector('link[rel="canonical"]')?.href,
    present: !!document.querySelector('link[rel="canonical"]'),
    matchesUrl: document.querySelector('link[rel="canonical"]')?.href === window.location.href
  },
  favicon: {
    present: !!document.querySelector('link[rel="icon"], link[rel="shortcut icon"]'),
    href: document.querySelector('link[rel="icon"], link[rel="shortcut icon"]')?.href
  }
};
console.log(JSON.stringify(audit, null, 2));
```

---

## 2. Open Graph Tags

**Controls how your page appears when shared on social media.**

### Required OG Tags

- [ ] `og:title` — Present, compelling (can differ from page title)
- [ ] `og:description` — Present, benefit-focused
- [ ] `og:image` — Present, high quality
- [ ] `og:url` — Points to canonical URL
- [ ] `og:type` — Set to "website" (for landing pages)
- [ ] `og:site_name` — Brand name

### OG Image Requirements

- [ ] Minimum 1200x630 pixels
- [ ] Shows product/brand clearly
- [ ] Readable text (if any) at thumbnail size
- [ ] Not generic stock photo
- [ ] File size < 1MB
- [ ] Accessible URL (not behind auth)

**OG Image Spec:**
```
Dimensions: 1200 x 630 pixels (1.91:1 ratio)
Format: PNG or JPG
File size: < 1 MB
Content: Product screenshot, brand visual, or compelling graphic
Text: Minimal — legible at small sizes
Safe zone: Keep important content within center 80%
```

### Scan Commands

```javascript
// Open Graph audit
const ogTags = {};
document.querySelectorAll('meta[property^="og:"]').forEach(meta => {
  ogTags[meta.getAttribute('property')] = meta.content;
});
console.log('Open Graph tags:', JSON.stringify(ogTags, null, 2));

// Check OG image dimensions
const ogImage = document.querySelector('meta[property="og:image"]')?.content;
if (ogImage) {
  const img = new Image();
  img.onload = () => console.log(`OG Image: ${img.width}x${img.height} ${img.width >= 1200 ? '✅' : '❌ too small'}`);
  img.onerror = () => console.error('OG Image failed to load:', ogImage);
  img.src = ogImage;
} else {
  console.error('❌ No og:image found');
}
```

---

## 3. Twitter Card Tags

### Required Twitter Tags

- [ ] `twitter:card` — "summary_large_image" (for landing pages)
- [ ] `twitter:title` — Present
- [ ] `twitter:description` — Present
- [ ] `twitter:image` — Present (can be same as OG image)

### Optional but Recommended

- [ ] `twitter:site` — @handle of the product/company
- [ ] `twitter:creator` — @handle of the content author (if applicable)

### Scan Commands

```javascript
// Twitter Card audit
const twitterTags = {};
document.querySelectorAll('meta[name^="twitter:"]').forEach(meta => {
  twitterTags[meta.name] = meta.content;
});
console.log('Twitter Cards:', JSON.stringify(twitterTags, null, 2));
```

---

## 4. Structured Data (JSON-LD)

**Enables rich results in search engines.**

### 4.1 Required Schemas for Landing Pages

#### Organization Schema

```json
{
  "@context": "https://schema.org",
  "@type": "Organization",
  "name": "Product Name",
  "url": "https://example.com",
  "logo": "https://example.com/logo.png",
  "sameAs": [
    "https://twitter.com/product",
    "https://github.com/product",
    "https://linkedin.com/company/product"
  ],
  "contactPoint": {
    "@type": "ContactPoint",
    "contactType": "customer support",
    "url": "https://example.com/support"
  }
}
```

#### WebSite Schema (with SearchAction if applicable)

```json
{
  "@context": "https://schema.org",
  "@type": "WebSite",
  "name": "Product Name",
  "url": "https://example.com",
  "potentialAction": {
    "@type": "SearchAction",
    "target": "https://example.com/search?q={search_term_string}",
    "query-input": "required name=search_term_string"
  }
}
```

#### FAQ Schema (if FAQ section exists)

```json
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {
      "@type": "Question",
      "name": "Question text here?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Answer text here."
      }
    }
  ]
}
```

#### SoftwareApplication Schema (for SaaS products)

```json
{
  "@context": "https://schema.org",
  "@type": "SoftwareApplication",
  "name": "Product Name",
  "applicationCategory": "DeveloperApplication",
  "operatingSystem": "Web",
  "offers": {
    "@type": "Offer",
    "price": "0",
    "priceCurrency": "USD",
    "description": "Free tier"
  },
  "aggregateRating": {
    "@type": "AggregateRating",
    "ratingValue": "4.8",
    "reviewCount": "2847"
  }
}
```

### 4.2 Structured Data Checklist

- [ ] At least one JSON-LD block present
- [ ] JSON is valid (no syntax errors)
- [ ] Organization schema present
- [ ] FAQ schema present (if FAQ section exists)
- [ ] No errors in Google Rich Results Test
- [ ] URLs in schema are absolute and accessible
- [ ] Image URLs in schema are accessible

### 4.3 Scan Commands

```javascript
// Structured data audit
const schemas = document.querySelectorAll('script[type="application/ld+json"]');
console.log(`JSON-LD blocks found: ${schemas.length}`);
schemas.forEach((schema, i) => {
  try {
    const data = JSON.parse(schema.textContent);
    console.log(`Schema ${i + 1}: @type=${data['@type'] || 'unknown'}`);
    console.log(JSON.stringify(data, null, 2));
  } catch(e) {
    console.error(`Schema ${i + 1}: INVALID JSON — ${e.message}`);
  }
});

// Check for FAQ section without FAQ schema
const faqSection = document.querySelector('[class*="faq"], [id*="faq"]');
const hasFaqSchema = [...schemas].some(s => s.textContent.includes('FAQPage'));
if (faqSection && !hasFaqSchema) {
  console.warn('⚠️ FAQ section exists but no FAQPage schema found');
}
```

```bash
# Check for JSON-LD in source files
grep -rn "application/ld+json" --include="*.tsx" --include="*.jsx" --include="*.html" --include="*.astro"

# Check for schema in head/layout files
grep -rn "schema\|jsonLd\|json-ld\|structuredData" --include="*.tsx" --include="*.jsx" --include="*.ts"
```

---

## 5. Technical SEO

### 5.1 Robots & Crawlability

- [ ] `robots.txt` exists and allows crawling of landing page
- [ ] No `<meta name="robots" content="noindex">` on landing page
- [ ] `sitemap.xml` exists and includes landing page URL
- [ ] No `X-Robots-Tag: noindex` in HTTP headers

```bash
# Check robots.txt
curl -s "${TARGET_URL}/robots.txt"

# Check sitemap
curl -s "${TARGET_URL}/sitemap.xml" | head -30

# Check HTTP headers for robots directives
curl -sI "${TARGET_URL}" | grep -i "x-robots\|noindex"
```

```javascript
// Check for meta robots
const robotsMeta = document.querySelector('meta[name="robots"]');
if (robotsMeta) {
  console.log(`Robots meta: ${robotsMeta.content}`);
  if (robotsMeta.content.includes('noindex')) {
    console.error('❌ Page is set to noindex!');
  }
} else {
  console.log('✅ No restrictive robots meta (page is indexable)');
}
```

### 5.2 Heading Hierarchy

- [ ] Exactly one `<h1>` on the page
- [ ] No heading level skips (h1 → h3 without h2)
- [ ] Headings follow logical document outline
- [ ] H1 contains primary keyword

```javascript
// Heading hierarchy audit
const headings = document.querySelectorAll('h1, h2, h3, h4, h5, h6');
let lastLevel = 0;
let h1Count = 0;
headings.forEach(h => {
  const level = parseInt(h.tagName[1]);
  if (level === 1) h1Count++;
  const skip = level > lastLevel + 1;
  console.log(`${skip ? '⚠️ SKIP' : '✅'} ${h.tagName}: "${h.textContent.trim().slice(0, 60)}"`);
  lastLevel = level;
});
console.log(`\nH1 count: ${h1Count} ${h1Count === 1 ? '✅' : '❌ (should be exactly 1)'}`);
```

### 5.3 Image SEO

- [ ] All images have descriptive `alt` text
- [ ] Alt text includes relevant keywords naturally
- [ ] Images use modern formats (WebP, AVIF with fallbacks)
- [ ] Images are properly sized (not 3000px rendered at 300px)
- [ ] Images have `width` and `height` attributes (prevents CLS)
- [ ] Hero/LCP image has `fetchpriority="high"` or preload

```javascript
// Image SEO audit
document.querySelectorAll('img').forEach(img => {
  const issues = [];
  if (!img.alt) issues.push('missing alt');
  if (!img.width && !img.style.width) issues.push('no width');
  if (!img.height && !img.style.height) issues.push('no height');
  if (img.naturalWidth > img.clientWidth * 2) issues.push(`oversized: ${img.naturalWidth}px rendered at ${img.clientWidth}px`);

  const src = img.src || img.currentSrc;
  const isModern = /\.webp|\.avif/i.test(src);
  if (!isModern) issues.push('not WebP/AVIF');

  if (issues.length > 0) {
    console.warn(`❌ ${src.split('/').pop()}: ${issues.join(', ')}`);
  }
});
```

### 5.4 Page Speed (SEO Impact)

Core Web Vitals affect search rankings. Quick check:

```javascript
// Quick performance check
const nav = performance.getEntriesByType('navigation')[0];
const metrics = {
  TTFB: Math.round(nav.responseStart) + 'ms',
  DOMLoaded: Math.round(nav.domContentLoadedEventEnd) + 'ms',
  FullLoad: Math.round(nav.loadEventEnd) + 'ms',
  TransferSize: Math.round(nav.transferSize / 1024) + 'KB'
};
console.log('Performance:', JSON.stringify(metrics, null, 2));

// Check total resources
const resources = performance.getEntriesByType('resource');
const totalSize = resources.reduce((sum, r) => sum + (r.transferSize || 0), 0);
console.log(`Total resources: ${resources.length}, Total size: ${Math.round(totalSize / 1024)}KB`);
```

### 5.5 Internal Links

- [ ] All internal links use correct relative/absolute paths
- [ ] No broken internal links (404s)
- [ ] Anchor links (#section) work correctly
- [ ] Navigation links point to correct pages

```javascript
// Check for broken links
const links = document.querySelectorAll('a[href]');
links.forEach(a => {
  const href = a.href;
  if (href.startsWith('javascript:') || href === '#') {
    console.warn(`⚠️ Non-standard link: "${a.textContent.trim().slice(0, 30)}" → ${href}`);
  }
});
console.log(`Total links: ${links.length}`);
```

---

## SEO Audit Summary Format

```markdown
## SEO & Meta Audit Results

### Meta Tags
| Tag | Status | Current | Recommended |
|-----|--------|---------|-------------|
| Title | ✅/❌ | "[current]" (X chars) | "[recommended]" (X chars) |
| Description | ✅/❌ | "[current]" (X chars) | "[recommended]" (X chars) |
| Canonical | ✅/❌ | [URL] | [URL] |
| Viewport | ✅/❌ | [value] | [value] |

### Open Graph
| Tag | Status | Value |
|-----|--------|-------|
| og:title | ✅/❌ | [value] |
| og:description | ✅/❌ | [value] |
| og:image | ✅/❌ | [URL] ([WxH]) |
| og:url | ✅/❌ | [value] |

### Structured Data
| Schema | Status | Notes |
|--------|--------|-------|
| Organization | ✅/❌ | [notes] |
| FAQ | ✅/❌ | [notes] |
| Product/Software | ✅/❌ | [notes] |

### Technical
| Item | Status | Notes |
|------|--------|-------|
| H1 count | ✅/❌ | [count] |
| Heading hierarchy | ✅/❌ | [issues] |
| robots.txt | ✅/❌ | [status] |
| sitemap.xml | ✅/❌ | [status] |
| Image alt text | ✅/❌ | [X of Y have alt] |
```
