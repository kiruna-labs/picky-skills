# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased] - 2026-03-02

### Security
- Added jq dependency check to all PreToolUse hooks (fail-closed instead of fail-open)
- Added PreToolUse hooks to picky-tester and picky-orchestrator (previously had none)
- Normalized hook blocklists across all 6 agents (added tee, sed -i, chmod, chown, sudo)
- Changed picky-landingpage permissionMode from bypassPermissions to dontAsk
- Added source code Read blocking hook to picky-tester

### Updated
- Updated OWASP Top 10 references from 2021 to 2025 edition
- Replaced phantom agent references with actual picky agent names
- Fixed grep -rohn to grep -ron in picky-design (preserves filenames)

### Fixed
- Removed project-specific content from picky-tester SKILL.md
- Fixed README inaccuracies (OpenCode reference, npx command)
- Fixed CONTRIBUTING.md contradictions (line limits, contribution workflow)
- Fixed stale CLAUDE.md documentation (landingpage agent.md existence, install snippets)

### Added
- CHANGELOG.md (moved from CLAUDE.md)
- Read-only enforcement limitations documented in README.md
- jq listed as requirement in README.md

## 2026-03-01

- Added picky-landingpage skill for landing page conversion auditing
- 10-point conversion framework, 7 copy rules, banned words scanner
- Hero optimization, social proof/pricing, SEO/meta audit
- Section-by-section analysis with implementation guide output

## 2025-01-29

- **MAJOR**: Converted all skills to subagents for improved reliability
- Added agent.md files with YAML frontmatter
- Added PreToolUse hooks for read-only enforcement
- Added picky-orchestrator meta-agent
- Added proactive usage in descriptions
- Improved tool restrictions
- Added skills injection for methodology content

## 2025-01-27

- Initial release with skill-based architecture
