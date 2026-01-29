# Picky Agents

Ultra-thorough Claude Code **subagents** for comprehensive project auditing. 10x more thorough than standard audits.

## What Makes Picky Agents Different

### Skills vs Subagents

This project evolved from **skills** (instructions injected into main context) to **subagents** (isolated agents with dedicated context). Here's why:

| Aspect | Skills (Old) | Subagents (New) |
|--------|--------------|-----------------|
| Execution Context | Main conversation (dilutes over time) | **Isolated context window** |
| Reliability | May need multiple starts | **Runs to completion** |
| Tool Access | Inherits everything | **Explicitly restricted** |
| Delegation | Manual keyword matching | **Automatic based on description** |
| Resumability | None | **Can resume with full context** |
| Model Control | Uses current model | **Can specify (Haiku/Sonnet/Opus)** |

### The "Picky" Philosophy

**Standard audit says:**
- "Some buttons have inconsistent styling"
- "Consider adding rate limiting"

**Picky audit says:**
- "47 buttons found. 3 variants defined. 12 instances use arbitrary colors: [file:line for each]"
- "47 API endpoints found. 38 have auth. 9 unprotected: [complete list with CVSS scores]"

**Core principles:**
1. **Exhaustive** - Check EVERY item, not samples
2. **Quantified** - Exact counts, not "some" or "several"
3. **Located** - Every file:line reference
4. **Actionable** - Specific fix for each finding
5. **Prioritized** - Clear severity classification

---

## Available Agents

### picky-security
**Paranoid security auditor** that assumes every line is vulnerable.

**Capabilities:**
- OWASP Top 10 + CWE analysis with CVSS scores
- Injection attacks (SQL, Command, XSS, SSRF, Path Traversal)
- Auth flow completeness (brute force, lockout, reset, enumeration)
- Secret scanning (code AND git history)
- Dependency vulnerability audit
- Security header and CORS analysis

**Tools:** Read, Grep, Glob, Bash (read-only enforced via hook)
**Model:** Sonnet

**Automatic trigger:** Use proactively after code changes, before deployments, or when security is mentioned.

### picky-design
**Obsessive design system auditor** that catches every pixel deviation.

**Capabilities:**
- Color palette analysis (finds every hardcoded hex)
- Typography scale verification
- Spacing consistency audit
- Component variant enforcement
- WCAG accessibility compliance (Level A + AA)
- Responsive pattern verification

**Tools:** Read, Grep, Glob, Bash (read-only enforced via hook)
**Model:** Sonnet

**Automatic trigger:** Use proactively after UI changes or when design review is mentioned.

### picky-tester
**Black-box QA tester** that tests like a real user, not a developer.

**Capabilities:**
- Full navigation testing
- Form validation (valid, invalid, empty, edge cases)
- Interactive element testing (buttons, modals, dropdowns)
- Responsive testing (320px to 1920px)
- Network error simulation
- User confusion documentation

**Tools:** Read, Bash (source code access BLOCKED - browser only)
**Model:** Sonnet
**Requires:** Chrome DevTools MCP server

**Automatic trigger:** Use proactively after features are implemented or when testing is mentioned.

### picky-performance
**Obsessive performance engineer** who treats every wasted byte as a personal insult.

**Capabilities:**
- Core Web Vitals measurement (LCP, INP, CLS, FCP, TTFB, TTI)
- Bundle size analysis
- Image/font optimization detection
- Code splitting verification
- Caching strategy audit
- Mobile throttled testing (Slow 3G, 4x CPU)

**Tools:** Read, Grep, Glob, Bash (read-only enforced via hook)
**Model:** Sonnet
**Requires:** Chrome DevTools MCP server

**Automatic trigger:** Use proactively before deployments or when performance is mentioned.

### picky-orchestrator
**Meta-agent** that coordinates comprehensive audits using all picky agents.

**Capabilities:**
- Project type detection
- Optimal audit sequencing
- Cross-cutting issue identification
- Unified remediation roadmap
- Priority matrix across all domains

**Tools:** Read, Grep, Glob, Bash
**Model:** Sonnet

**Automatic trigger:** Use when "full audit", "comprehensive review", or "audit everything" is mentioned.

---

## Installation

### Option 1: Symlink to User Agents (Recommended)

```bash
# Create user agents directory if it doesn't exist
mkdir -p ~/.claude/agents

# Symlink each agent
ln -s /path/to/picky-skills/picky-security/agent.md ~/.claude/agents/picky-security.md
ln -s /path/to/picky-skills/picky-design/agent.md ~/.claude/agents/picky-design.md
ln -s /path/to/picky-skills/picky-tester/agent.md ~/.claude/agents/picky-tester.md
ln -s /path/to/picky-skills/picky-performance/agent.md ~/.claude/agents/picky-performance.md
ln -s /path/to/picky-skills/picky-orchestrator/agent.md ~/.claude/agents/picky-orchestrator.md
```

This makes agents available in ALL your projects.

### Option 2: Project-Level Installation

```bash
# In your project root
mkdir -p .claude/agents

# Copy or symlink agents
cp /path/to/picky-skills/picky-*/agent.md .claude/agents/
```

This makes agents available only in the current project.

### Option 3: Skills Mode (Legacy)

The original SKILL.md files are still available and can be used as skills:

```bash
# Symlink skills
mkdir -p ~/.claude/skills
ln -s /path/to/picky-skills/picky-security ~/.claude/skills/picky-security
ln -s /path/to/picky-skills/picky-design ~/.claude/skills/picky-design
ln -s /path/to/picky-skills/picky-tester ~/.claude/skills/picky-tester
ln -s /path/to/picky-skills/picky-performance ~/.claude/skills/picky-performance
```

Note: Skills inject instructions into the main context. Agents run in isolated context.

---

## Usage

### Automatic Delegation

Claude automatically delegates based on context:

```
"Review this PR for security issues"
→ Automatically invokes picky-security

"Check the design consistency"
→ Automatically invokes picky-design

"Test the login flow"
→ Automatically invokes picky-tester

"Is this page fast enough?"
→ Automatically invokes picky-performance

"Audit everything before we launch"
→ Automatically invokes picky-orchestrator
```

### Explicit Invocation

You can also invoke agents directly:

```
"Use picky-security to audit authentication"
"Have picky-design check the button consistency"
"Run picky-tester on http://localhost:3000"
"Use picky-performance to analyze bundle size"
```

### Parallel Execution

For speed, run independent audits in parallel:

```
"Run picky-security and picky-performance in parallel"
```

### Background Execution

Run audits in background while you continue working:

```
"Run picky-security in the background"
```

---

## Directory Structure

```
picky-skills/
├── CLAUDE.md                    # This file
├── picky-security/
│   ├── agent.md                 # Subagent definition (NEW)
│   ├── SKILL.md                 # Legacy skill instructions
│   ├── references/
│   │   ├── frontend-security.md
│   │   ├── backend-security.md
│   │   ├── auth-security.md
│   │   ├── api-security.md
│   │   ├── infrastructure-security.md
│   │   ├── data-protection.md
│   │   └── owasp-cwe-mapping.md
│   ├── scripts/
│   │   └── scan-secrets.sh
│   └── examples/
│       └── sample-report.md
│
├── picky-design/
│   ├── agent.md                 # Subagent definition (NEW)
│   ├── SKILL.md                 # Legacy skill instructions
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
├── picky-tester/
│   ├── agent.md                 # Subagent definition (NEW)
│   ├── SKILL.md                 # Legacy skill instructions
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
├── picky-performance/
│   ├── agent.md                 # Subagent definition (NEW)
│   ├── SKILL.md                 # Legacy skill instructions
│   ├── references/
│   │   ├── frontend-performance.md
│   │   ├── network-caching.md
│   │   ├── backend-performance.md
│   │   ├── infrastructure-performance.md
│   │   ├── runtime-performance.md
│   │   ├── mobile-performance.md
│   │   └── core-web-vitals.md
│   └── examples/
│       └── sample-report.md
│
└── picky-orchestrator/
    └── agent.md                 # Meta-agent for coordinated audits (NEW)
```

---

## Severity Classifications

### Security Findings
| Severity | CVSS | Criteria |
|----------|------|----------|
| Critical | 9.0-10.0 | RCE, SQLi, credential exposure |
| High | 7.0-8.9 | XSS, IDOR, SSRF |
| Medium | 4.0-6.9 | CSRF, info disclosure |
| Low | 0.1-3.9 | Missing headers, verbose errors |

### Design Findings
| Severity | Criteria |
|----------|----------|
| Critical | Blocks users, WCAG Level A failures |
| Major | Significant inconsistency, WCAG Level AA failures |
| Minor | Noticeable deviation from patterns |
| Suggestion | Enhancement opportunities |

### Tester Findings
| Severity | Criteria |
|----------|----------|
| Blocker | Feature completely broken, app crashes |
| Critical | Major feature broken, data loss |
| Major | Feature partially broken, workaround exists |
| Minor | Visual issue, slow but works |
| UX Issue | Works but confusing |

### Performance Findings
| Severity | Impact |
|----------|--------|
| Critical | > 1s added load time |
| High | 200ms - 1s impact |
| Medium | 50ms - 200ms impact |
| Low | < 50ms impact |

---

## Dependencies

### Required for all agents:
- Claude Code CLI

### Required for picky-tester and picky-performance:
- [Chrome DevTools MCP](https://github.com/anthropics/anthropic-quickstarts/tree/main/mcp-server-chrome-devtools)

---

## Comparison with Other Subagents

| Feature | Picky Agents | VoltAgent/awesome-claude-code-subagents |
|---------|--------------|----------------------------------------|
| **Methodology Depth** | 600+ lines per domain, detailed checklists | Generic role descriptions |
| **Scan Commands** | 100+ specific grep/find patterns | None provided |
| **Reference Docs** | OWASP/CWE mapping, WCAG checklists | None |
| **Tool Restrictions** | Read-only enforced via hooks | Basic tool lists |
| **Proactive Usage** | Built into descriptions | Must add manually |
| **Skills Integration** | Loads detailed skill content | N/A |
| **Cross-Domain** | Orchestrator for unified audits | No coordination |

---

## Maintenance

### Adding new checks:
1. Add items to appropriate reference file
2. Update scan commands in agent.md
3. Update SKILL.md if adding new categories

### Updating OWASP/CWE references:
- Edit `picky-security/references/owasp-cwe-mapping.md`

### Secret scanner patterns:
- Edit `picky-security/scripts/scan-secrets.sh`

---

## Changelog

### 2025-01-29
- **MAJOR**: Converted all skills to subagents for improved reliability
- Added agent.md files with YAML frontmatter
- Added PreToolUse hooks for read-only enforcement
- Added picky-orchestrator meta-agent
- Added proactive usage in descriptions
- Improved tool restrictions
- Added skills injection for methodology content

### 2025-01-27
- Initial release with skill-based architecture
