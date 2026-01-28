# 🔍 Picky Skills

**Ultra-thorough Claude Code skills for comprehensive project auditing.**

These skills are designed to be **10x more picky** than standard audits. They don't sample—they check *everything*. They don't say "some issues found"—they give you exact counts and file locations. They don't leave stones unturned (manual edit: Of course they do. They absolutely will leave stones unturned because they are used non-deterministic systems that tend to look for easy ways out. Still, hopefully they'll make your apps better/safer/faster/nicer, just don't trust it yet.)

---

## Skills

| Skill | Purpose | Trigger |
|-------|---------|---------|
| [**picky-design**](#picky-design) | Design, UI & accessibility audit | "design audit", "accessibility audit" |
| [**picky-security**](#picky-security) | Security vulnerability scanning | "security audit", "vulnerability scan" |
| [**picky-tester**](#picky-tester) | Black-box QA testing | "test this app", "QA testing" |
| [**picky-performance**](#picky-performance) | Performance optimization | "performance audit", "Core Web Vitals" |

---

## What Makes These "Picky"?

**Standard audit says:**
> "Some buttons have inconsistent styling"

**Picky audit says:**
> "47 buttons found. 3 variants defined in design system. 12 instances use arbitrary colors not in palette: `src/components/Header.tsx:45`, `src/pages/Dashboard.tsx:123`, ..."

**Standard audit says:**
> "Consider adding rate limiting"

**Picky audit says:**
> "47 API endpoints found. 38 have authentication. 9 unprotected endpoints exposing user data: `GET /api/users` (CVSS 7.5), `GET /api/orders/:id` (CVSS 6.8), ..."

### Core Principles

1. **Exhaustive** — Check EVERY item, not samples
2. **Quantified** — Exact counts, not "some" or "several"
3. **Located** — Every finding includes `file:line` reference
4. **Actionable** — Specific fix with code example for each finding
5. **Prioritized** — Clear severity classification

---

## picky-design

Comprehensive design system and UI audit.

**Covers:**
- Visual consistency (typography, colors, spacing, borders, shadows, icons)
- Component patterns (buttons, forms, cards, modals, states)
- Accessibility (WCAG compliance, contrast, focus, ARIA, keyboard nav)
- Responsive design (breakpoints, touch targets, overflow)
- UX best practices (feedback, hierarchy, anti-patterns)
- Design system health (tokens, theming, documentation)

**Philosophy:** *"A single hardcoded color is a finding. A button without a hover state is a finding. An icon without a label is a finding."*

---

## picky-security

Security vulnerability scanning with OWASP/CWE references.

**Covers:**
- Frontend (XSS, DOM security, CSP, client-side data exposure)
- Backend (SQL/NoSQL injection, command injection, SSRF, XXE)
- Authentication (JWT, OAuth, session management, IDOR, privilege escalation)
- API (CORS, rate limiting, mass assignment, GraphQL)
- Infrastructure (secrets in code, dependency vulnerabilities, security headers)
- Data protection (encryption, PII handling, logging)

**Philosophy:** *"Every user input is an attack vector. Every API endpoint is a potential breach. Every dependency is a supply chain risk."*

**Includes:**
- OWASP Top 10 (2021) mapping
- CWE references for all findings
- Secret scanning script (`scripts/scan-secrets.sh`)

---

## picky-tester

Black-box QA testing that behaves like a real user.

**Covers:**
- Form testing (validation, edge cases, special characters)
- Navigation testing (links, routing, browser history)
- Interactive elements (buttons, modals, dropdowns, tooltips)
- User confusion points (clarity, discoverability, error messages)
- Edge cases & chaos (rapid clicks, interruptions, boundaries)
- Responsive testing (all viewports, touch targets)

**Philosophy:** *"You are a real user, not a developer."*

**Key Features:**
- Uses Chrome DevTools MCP exclusively (no source code access)
- Reports confusion from a novice user perspective
- Documents gaps that couldn't be tested
- Takes screenshots as evidence for every finding

**Requires:** Chrome DevTools MCP installed and running

---

## picky-performance

Performance optimization audit with Core Web Vitals focus.

**Covers:**
- Frontend (bundle size, code splitting, images, fonts, CSS delivery)
- Network & Caching (HTTP/2, compression, CDN, cache headers, resource hints)
- Backend (API response times, N+1 queries, connection pooling, async processing)
- Runtime (JS execution, memory leaks, rendering, animations)
- Infrastructure (load balancing, auto-scaling, serverless cold starts)
- Mobile (touch performance, page weight budgets, offline support)
- Core Web Vitals (LCP, INP, CLS, TTFB, FCP, TTI)

**Philosophy:** *"Every millisecond matters. Every byte counts."*

**Includes:**
- Performance budgets recommendations
- Lighthouse score optimization
- Quick wins checklist

---

## Installation

### Option 1: Symlink to Claude skills directory

```bash
# Clone the repo
git clone https://github.com/kiruna-labs/picky-skills.git ~/picky-skills

# Create skills directory if it doesn't exist
mkdir -p ~/.claude/skills

# Symlink each skill
ln -sf ~/picky-skills/picky-design ~/.claude/skills/
ln -sf ~/picky-skills/picky-security ~/.claude/skills/
ln -sf ~/picky-skills/picky-tester ~/.claude/skills/
ln -sf ~/picky-skills/picky-performance ~/.claude/skills/
```

### Option 2: Add to project directly

Copy the skill folder you need into your project's `.claude/skills/` directory.

---

## Usage

In any Claude Code session, use trigger phrases:

```
# Design
"Run a picky design audit on this project"
"Check accessibility compliance"

# Security
"Perform a security audit"
"Scan for vulnerabilities"

# Testing
"Test this app thoroughly"
"Run QA testing on http://localhost:3000"

# Performance
"Run a performance audit"
"Analyze Core Web Vitals"
"Why is this page slow?"
```

---

## Severity Classifications

### Design & Tester
| Severity | Criteria |
|----------|----------|
| **Critical** | Blocks users, WCAG Level A failures, app crashes |
| **Major/High** | Significant issues, WCAG Level AA failures |
| **Minor/Medium** | Noticeable but not blocking |
| **Low/Note** | Enhancement opportunities |

### Security
| Severity | CVSS | Examples |
|----------|------|----------|
| **Critical** | 9.0-10.0 | RCE, SQL injection, credential exposure |
| **High** | 7.0-8.9 | XSS, IDOR, SSRF |
| **Medium** | 4.0-6.9 | CSRF, information disclosure |
| **Low** | 0.1-3.9 | Missing headers, verbose errors |

### Performance
| Severity | Impact | Examples |
|----------|--------|----------|
| **Critical** | > 1s load time | 500KB blocking bundle, N+1 queries |
| **High** | 200ms - 1s | Unoptimized images, missing code splitting |
| **Medium** | 50ms - 200ms | Missing compression, suboptimal caching |
| **Low** | < 50ms | Missing resource hints |

---

## Structure

```
picky-skills/
├── README.md
├── CLAUDE.md              # Project documentation
│
├── picky-design/
│   ├── SKILL.md           # Main skill instructions
│   ├── references/        # Detailed checklists
│   └── examples/          # Sample reports
│
├── picky-security/
│   ├── SKILL.md
│   ├── references/
│   ├── scripts/           # scan-secrets.sh
│   └── examples/
│
├── picky-tester/
│   ├── SKILL.md
│   ├── references/
│   └── examples/
│
└── picky-performance/
    ├── SKILL.md
    ├── references/
    └── examples/
```

---

## Contributing

To add new checks:

1. Edit the appropriate `references/*.md` file
2. Include grep/scan commands where applicable
3. Update `SKILL.md` if adding new categories
4. Add examples to `examples/` if helpful

---

## License

Private repository. Internal use only.

---

*Built with Claude Code. Audited by Claude Code. 🔍*
