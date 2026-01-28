# Picky Skills Project

Ultra-thorough Claude Code skills for comprehensive project auditing.

## Overview

This project contains four sophisticated audit skills designed to be 10x more thorough than standard audits:

### picky-design
Comprehensive design audit skill covering:
- Visual consistency (typography, colors, spacing, borders, shadows, icons)
- Component patterns (buttons, forms, cards, modals, states)
- Accessibility (contrast, focus, ARIA, keyboard navigation)
- Responsive design (breakpoints, touch targets, overflow)
- UX best practices (feedback, hierarchy, anti-patterns)
- Design system health (tokens, theming, documentation)

**Trigger words**: "design audit", "UI audit", "accessibility audit", "picky design"

### picky-security
Comprehensive security audit skill covering:
- Frontend (XSS, DOM security, CSP, client-side data exposure)
- Backend (SQL/NoSQL injection, command injection, SSRF, XXE)
- Auth (JWT, OAuth, session management, IDOR, privilege escalation)
- API (CORS, rate limiting, mass assignment, GraphQL)
- Infrastructure (secrets, dependencies, security headers)
- Data protection (encryption, PII, logging)

**Trigger words**: "security audit", "vulnerability scan", "OWASP audit", "picky security"

### picky-tester
Black-box QA testing skill that behaves like a real user:
- Tests every feature, button, and UI mode exhaustively
- Uses Chrome DevTools MCP exclusively (no source code access)
- Reports confusion points (novice user perspective)
- Edge case and chaos testing (rapid clicks, special chars, boundaries)
- Responsive testing across all viewports
- Documents gaps that couldn't be tested

**Trigger words**: "test this app", "QA testing", "user testing", "picky test"

**Core Philosophy**: "You are a real user, not a developer." Never reads source code, only interacts through the browser like an actual user would.

### picky-performance
Ultra-thorough performance audit skill covering:
- Frontend (bundle size, code splitting, images, fonts, CSS delivery)
- Network & Caching (HTTP/2, compression, CDN, cache headers, resource hints)
- Backend (API response times, database queries, N+1 detection, connection pooling)
- Runtime (JavaScript execution, memory leaks, rendering, animations)
- Infrastructure (load balancing, auto-scaling, CDN, serverless cold starts)
- Mobile (touch performance, page weight budgets, offline support)
- Core Web Vitals (LCP, INP, CLS, TTFB, FCP, TTI)

**Trigger words**: "performance audit", "speed optimization", "Core Web Vitals", "picky performance"

**Core Philosophy**: "Every millisecond matters. Every byte counts." Treats every wasted byte as a personal insult.

## Directory Structure

```
/Users/user/picky-skills/
├── CLAUDE.md                    # This file
├── picky-design/
│   ├── SKILL.md                 # Main skill instructions
│   ├── references/
│   │   ├── visual-consistency-checklist.md
│   │   ├── component-patterns.md
│   │   ├── accessibility-audit.md
│   │   ├── responsive-checklist.md
│   │   ├── ux-antipatterns.md
│   │   └── design-system-health.md
│   └── examples/
│       └── sample-audit-report.md
│
├── picky-security/
│   ├── SKILL.md                 # Main skill instructions
│   ├── references/
│   │   ├── frontend-security.md
│   │   ├── backend-security.md
│   │   ├── auth-security.md
│   │   ├── api-security.md
│   │   ├── infrastructure-security.md
│   │   ├── data-protection.md
│   │   └── owasp-cwe-mapping.md
│   ├── scripts/
│   │   └── scan-secrets.sh      # Comprehensive secret scanner
│   └── examples/
│       └── sample-report.md
│
├── picky-tester/
│   ├── SKILL.md                 # Main skill instructions
│   ├── references/
│   │   ├── form-testing.md
│   │   ├── navigation-testing.md
│   │   ├── interaction-testing.md
│   │   ├── user-confusion-testing.md
│   │   ├── edge-case-testing.md
│   │   └── responsive-testing.md
│   └── examples/
│       └── sample-test-report.md
│
└── picky-performance/
    ├── SKILL.md                 # Main skill instructions
    ├── references/
    │   ├── frontend-performance.md
    │   ├── network-caching.md
    │   ├── backend-performance.md
    │   ├── infrastructure-performance.md
    │   ├── runtime-performance.md
    │   ├── mobile-performance.md
    │   └── core-web-vitals.md
    └── examples/
        └── sample-report.md
```

## Installation

Skills are symlinked to `~/.claude/skills/` for global availability:
- `~/.claude/skills/picky-design` -> `/Users/user/picky-skills/picky-design`
- `~/.claude/skills/picky-security` -> `/Users/user/picky-skills/picky-security`
- `~/.claude/skills/picky-tester` -> `/Users/user/picky-skills/picky-tester`
- `~/.claude/skills/picky-performance` -> `/Users/user/picky-skills/picky-performance`

## Key Philosophy

### What makes these "10x more picky":

**Standard audit says:**
- "Some buttons have inconsistent styling"
- "Consider adding rate limiting"

**Picky audit says:**
- "47 buttons found. 3 variants defined. 12 instances use arbitrary colors: [file:line for each]"
- "47 API endpoints found. 38 have auth. 9 unprotected: [complete list with CVSS scores]"

### Core principles:
1. **Exhaustive** - Check EVERY item, not samples
2. **Quantified** - Exact counts, not "some" or "several"
3. **Located** - Every file:line reference
4. **Actionable** - Specific fix for each finding
5. **Prioritized** - Clear severity classification

## Usage

In any project, invoke with trigger keywords:

```
# Design Audit
"Run a picky design audit on this project"
"Do an accessibility audit"

# Security Audit
"Perform a security audit using picky-security"
"Scan for vulnerabilities"

# QA Testing
"Test this app thoroughly"
"Run picky-tester on http://localhost:3000"
"Do user testing on this feature"

# Performance Audit
"Run a performance audit on this project"
"Analyze Core Web Vitals"
"Optimize page load time"
"Check for performance issues"
```

### picky-tester Requirements
- **Chrome DevTools MCP must be installed and running**
- The skill will check for availability and prompt installation if missing
- Works with any localhost or accessible URL
- Generates comprehensive test reports with screenshots

## Severity Classifications

### Design Findings
| Severity | Criteria |
|----------|----------|
| Critical | Blocks users, WCAG Level A failures |
| Major | Significant inconsistency, WCAG Level AA failures |
| Minor | Noticeable deviation from patterns |
| Suggestion | Enhancement opportunities |

### Security Findings
| Severity | CVSS | Criteria |
|----------|------|----------|
| Critical | 9.0-10.0 | RCE, SQLi, credential exposure |
| High | 7.0-8.9 | XSS, IDOR, SSRF |
| Medium | 4.0-6.9 | CSRF, info disclosure |
| Low | 0.1-3.9 | Missing headers, verbose errors |

### Tester Findings
| Severity | Criteria |
|----------|----------|
| Critical | Blocks core functionality, app crashes, data loss |
| High | Significant UX issues, major features broken |
| Medium | Minor bugs, usability friction |
| Low | Polish issues, enhancement suggestions |

### Confusion Points (picky-tester specific)
| Severity | Criteria |
|----------|----------|
| Critical | User cannot accomplish goal |
| Major | User must experiment or guess |
| Minor | User might pause or wonder |
| Note | Best practice improvement |

### Performance Findings
| Severity | Impact | Criteria |
|----------|--------|----------|
| Critical | > 1s added load time | Render-blocking 500KB bundle, N+1 queries, no caching |
| High | 200ms - 1s impact | Unoptimized images, missing code splitting, API waterfalls |
| Medium | 50ms - 200ms impact | Missing compression, suboptimal cache headers |
| Low | < 50ms impact | Missing resource hints, minor optimizations |

## Maintenance

### Adding new checks:
1. Add items to appropriate reference file
2. Include scan commands where applicable
3. Update SKILL.md if adding new categories

### Updating OWASP/CWE references:
- Edit `picky-security/references/owasp-cwe-mapping.md`

### Secret scanner patterns:
- Edit `picky-security/scripts/scan-secrets.sh`

### Adding new test cases:
- Edit appropriate file in `picky-tester/references/`
- Form inputs: `form-testing.md`
- Navigation flows: `navigation-testing.md`
- UI components: `interaction-testing.md`
- UX clarity: `user-confusion-testing.md`
- Edge cases: `edge-case-testing.md`
- Viewport sizes: `responsive-testing.md`

### Adding new performance checks:
- Edit appropriate file in `picky-performance/references/`
- Frontend: `frontend-performance.md`
- Network/Caching: `network-caching.md`
- Backend: `backend-performance.md`
- Infrastructure: `infrastructure-performance.md`
- Runtime: `runtime-performance.md`
- Mobile: `mobile-performance.md`
- Core Web Vitals: `core-web-vitals.md`

## Created
2025-01-27

## Last Updated
2025-01-27
