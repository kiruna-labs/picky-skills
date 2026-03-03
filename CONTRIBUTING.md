# Contributing to Picky Skills

Thanks for wanting to make audits pickier.

## Types of Contributions

### Adding a Check to an Existing Skill

The most common contribution. Example: adding "orphaned CSS classes" to `picky-design`.

1. **Add the check** to the relevant `references/*.md` file with:
   - What to scan for (include grep/find patterns)
   - What constitutes a finding
   - Severity classification
   - Example fix with code

2. **Add a script** in `scripts/` if the check is deterministic. If you can grep for it, script it. Scripts are more reliable than agent instructions and don't consume context tokens.

3. **Update the example report** in `examples/` to show the new check's output.

4. Don't update `SKILL.md` or `agent.md` unless adding an entirely new category.

### Adding a New Skill

Want `picky-i18n` or `picky-deps`? Create:

```
picky-{name}/
├── SKILL.md           # YAML frontmatter required (see below)
├── agent.md           # Subagent definition with hooks
├── references/        # Detailed checklists
├── scripts/           # Optional automation
└── examples/
    └── sample-report.md
```

SKILL.md needs frontmatter:
```yaml
---
name: picky-{name}
description: One sentence. Include trigger phrases.
---
```

Keep SKILL.md under 500 lines. Put detailed checklists in `references/`.

### Fixing False Positives

Open an issue with: the file that triggered it, the exact finding, why it's wrong, and a suggested fix.

## Writing Good Checks

**Bad:** `Check if buttons have consistent styling`

**Good:**
```
SCAN: Find all <button>, <Button>, role="button" in .tsx/.jsx files.
COMMAND: grep -rn '<button\|<Button\|role="button"' --include="*.tsx" --include="*.jsx" src/
COUNT: Total instances, unique variants, instances not using a defined variant.
FINDING: Button not using a design system variant.
SEVERITY: Medium
FIX: Replace `<button className="bg-blue-500 text-white px-4 py-2">` with `<Button variant="primary">`.
```

## Script Guidelines

Scripts in `scripts/` should: accept project root as `$1` (default `.`), output JSON to stdout, write progress to stderr, handle missing tools gracefully, work on macOS and Linux, use `set -e` and cleanup traps.

## Pull Requests

1. Fork → branch → changes → PR
2. Include: what you added, why, example output
3. Test against a real project if possible

Questions? Open an issue.
