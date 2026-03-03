# 🔍 Picky Skills

**Exhaustive code audits that count everything, locate everything, and fix everything.**

Most audits sample a few files and say "some issues found." Picky skills check *every* component, *every* endpoint, *every* pixel — and give you exact counts, exact `file:line` locations, and exact fixes.

```bash
npx skills add kiruna-labs/picky-skills
```

Then in Claude Code:

```
> Run a picky design audit on this project
```

---

## 30-Second Demo

Here's what a picky audit actually produces (abbreviated):

```
📊 DESIGN AUDIT — acme-dashboard
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Design Health Score: 61/100

COLORS
  Found: 47 unique color values across 23 files
  In design tokens: 12
  Hardcoded/arbitrary: 35 ❌
    src/components/Header.tsx:45 → #3b82f6 (not in palette)
    src/pages/Dashboard.tsx:123 → rgba(0,0,0,0.5) (use shadow token)
    src/components/Card.tsx:18 → #ef4444 (use --color-error)

BUTTONS
  Found: 34 instances across 14 files
  Using design system variants: 22 ✅
  Missing focus-visible: 19 ❌
  Missing aria-label (icon-only): 4 ❌

[147 findings | 12 critical | 34 high | 58 medium | 43 low]

TOP 3 QUICK WINS
  1. Add focus-visible globally → fixes 19 findings
  2. Replace 8 hardcoded #3b82f6 → fixes 8 findings
  3. Add aria-label to icon buttons → fixes 4 critical findings
```

---

## Skills

| Skill | What it audits | Trigger phrases |
|-------|---------------|-----------------|
| **[picky-design](./picky-design/)** | UI consistency, design tokens, accessibility (WCAG 2.2), responsive | "design audit", "accessibility audit" |
| **[picky-security](./picky-security/)** | Vulnerabilities, auth, API security, secrets, deps (OWASP/CWE) | "security audit", "vulnerability scan" |
| **[picky-tester](./picky-tester/)** | Black-box QA from a real user's perspective | "test this app", "QA testing" |
| **[picky-performance](./picky-performance/)** | Bundle size, Core Web Vitals, caching, runtime, backend | "performance audit", "why is this slow" |
| **[picky-landingpage](./picky-landingpage/)** | Conversion optimization, copy, social proof, SEO, pricing | "landing page audit", "CRO audit" |
| **[picky-orchestrator](./picky-orchestrator/)** | Coordinates all audits into unified report | "full audit", "audit everything" |

Every skill produces a **scored report** with exact counts, `file:line` references, severity classifications, and copy-paste fixes.

---

## What Makes These "Picky"

Every finding follows five rules:

1. **Exhaustive** — scans every file, not a sample
2. **Quantified** — "35 hardcoded colors" not "some inconsistencies"
3. **Located** — every finding includes `file:line`
4. **Actionable** — specific fix with code for each finding
5. **Scored** — category scores and overall health score out of 100

---

## Installation

### Option 1: Skills CLI (recommended)

```bash
# All skills
npx skills add kiruna-labs/picky-skills

# Individual skill
npx skills add kiruna-labs/picky-skills --skill picky-security

# Global (all projects)
npx skills add kiruna-labs/picky-skills -g

# Specific agent
npx skills add kiruna-labs/picky-skills -a claude-code
```

### Option 2: Install script

```bash
git clone https://github.com/kiruna-labs/picky-skills.git ~/picky-skills
cd ~/picky-skills && ./install.sh
```

Auto-detects your agent (Claude Code, Cursor, Kiro, OpenCode) and installs to the right location.

### Option 3: As subagents (manual)

Subagents run in an isolated context window with read-only enforcement — recommended for thorough audits.

```bash
mkdir -p ~/.claude/agents
ln -s ~/picky-skills/picky-security/agent.md ~/.claude/agents/picky-security.md
ln -s ~/picky-skills/picky-design/agent.md ~/.claude/agents/picky-design.md
ln -s ~/picky-skills/picky-tester/agent.md ~/.claude/agents/picky-tester.md
ln -s ~/picky-skills/picky-performance/agent.md ~/.claude/agents/picky-performance.md
ln -s ~/picky-skills/picky-orchestrator/agent.md ~/.claude/agents/picky-orchestrator.md
```

### Option 4: As skills (manual)

Skills inject into the main conversation context — good for quick checks.

```bash
mkdir -p ~/.claude/skills
ln -s ~/picky-skills/picky-design ~/.claude/skills/
ln -s ~/picky-skills/picky-security ~/.claude/skills/
ln -s ~/picky-skills/picky-tester ~/.claude/skills/
ln -s ~/picky-skills/picky-performance ~/.claude/skills/
ln -s ~/picky-skills/picky-landingpage ~/.claude/skills/
```

---

## Usage

### Automatic (Claude detects intent)

```
"Review this PR for security issues"          → picky-security
"Check the design consistency"                 → picky-design
"Test the login flow"                          → picky-tester
"Is this page fast enough?"                    → picky-performance
"Optimize this landing page for conversions"   → picky-landingpage
"Audit everything before we launch"            → picky-orchestrator
```

### Explicit

```
"Run a picky security audit on src/api/"
"Have picky-design check button consistency"
"Use picky-tester on http://localhost:3000"
"Run picky-landingpage on https://myproduct.com"
```

### Parallel & background

```
"Run picky-security and picky-performance in parallel"
"Run picky-design in the background"
```

---

## Architecture: Skills vs Subagents

Each picky audit is available in two modes:

| | Skills (`SKILL.md`) | Subagents (`agent.md`) |
|--|---------------------|------------------------|
| Context | Shared with conversation | **Isolated context window** |
| Reliability | May drift in long chats | **Runs to completion** |
| Tool access | Inherits everything | **Read-only via hooks** |
| Model | Current model | **Configurable (Sonnet default)** |

Subagents are recommended. Skills work for quick checks.

---

## Severity Classifications

**Security** — CVSS 9–10: Critical, 7–8.9: High, 4–6.9: Medium, 0.1–3.9: Low

**Design** — Critical: blocks users / WCAG A failures · Major: WCAG AA / significant inconsistency · Minor: noticeable deviation · Suggestion: enhancement

**Performance** — Critical: >1s · High: 200ms–1s · Medium: 50–200ms · Low: <50ms

**Landing Page** — Critical: no value prop / no CTA above fold · High: vague headline / no social proof · Medium: weak copy / missing meta · Low: polish

**Cross-domain (Orchestrator)** — P0: any Critical security or multi-domain Critical · P1: High across domains · P2: single-domain Medium · P3: Low/suggestions

---

## Requirements

- **All skills:** Claude Code (or compatible agent)
- **picky-tester, picky-performance, picky-landingpage:** [Chrome DevTools MCP](https://github.com/anthropics/anthropic-quickstarts/tree/main/mcp-server-chrome-devtools)

---

## Limitations

These skills run inside non-deterministic AI agents. While the instructions push for exhaustive coverage, very large codebases (>1000 files) may need scoped passes, complex multi-file patterns may be missed, and security findings are not a substitute for professional pen testing. Agent results vary between runs — re-run for higher confidence.

Found a gap? [Open an issue.](https://github.com/kiruna-labs/picky-skills/issues)

---

## Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md). The short version: every check needs a grep command, a severity, and a specific fix.

---

## License

Apache 2.0 — see [LICENSE](./LICENSE).

---

Built by [Kiruna Labs](https://kiruna.ai) 🔍
