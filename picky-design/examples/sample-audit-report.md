# Design Audit Report: [Project Name]

**Audit Date**: YYYY-MM-DD
**Auditor**: Claude (picky-design skill)
**Project Version**: [version/commit]
**Framework**: [React/Vue/Angular/etc.]
**Design System**: [Tailwind/MUI/Custom/etc.]

---

## Executive Summary

### Overall Design Health Score: X/100

| Category | Score | Status |
|----------|-------|--------|
| Visual Consistency | /100 | 🔴/🟡/🟢 |
| Component Patterns | /100 | 🔴/🟡/🟢 |
| Accessibility | /100 | 🔴/🟡/🟢 |
| Responsive Design | /100 | 🔴/🟡/🟢 |
| UX Quality | /100 | 🔴/🟡/🟢 |
| Design System Health | /100 | 🔴/🟡/🟢 |

### Findings Summary

| Severity | Count |
|----------|-------|
| 🔴 Critical | X |
| 🟠 Major | X |
| 🟡 Minor | X |
| 🔵 Suggestions | X |
| **Total** | **X** |

### Top 3 Priority Issues
1. [Brief description of highest priority issue]
2. [Brief description of second priority issue]
3. [Brief description of third priority issue]

---

## Critical Issues (🔴)

### [CRT-001] Issue Title

**Category**: [Visual Consistency / Accessibility / etc.]
**Location**: `path/to/file.tsx:L45-L67`

**Description**:
[Clear description of what's wrong]

**Evidence**:
```tsx
// Code snippet showing the issue
<div onClick={handleClick} className="card">
  {/* Missing keyboard support, not a button */}
</div>
```

**Screenshot** (if applicable):
[Screenshot reference or inline image]

**Impact**:
[Why this matters - user impact, business impact]

**Remediation**:
```tsx
// Corrected code
<button onClick={handleClick} className="card">
  {/* Now keyboard accessible */}
</button>
```

**Effort**: [Low/Medium/High]
**References**:
- WCAG 2.1 Success Criterion 2.1.1
- [Link to relevant documentation]

---

### [CRT-002] Issue Title

[Same structure as above...]

---

## Major Issues (🟠)

### [MAJ-001] Issue Title

**Category**: [Category]
**Location**: `path/to/file.tsx:L12`

**Description**:
[Description]

**Evidence**:
[Code or screenshot]

**Impact**:
[Impact description]

**Remediation**:
[How to fix]

**Effort**: [Low/Medium/High]

---

## Minor Issues (🟡)

### [MIN-001] Issue Title

**Category**: [Category]
**Location**: `path/to/file.tsx:L89`
**Description**: [Brief description]
**Remediation**: [Brief fix]

---

### [MIN-002] Issue Title

[Continue pattern...]

---

## Suggestions (🔵)

### [SUG-001] Suggestion Title

**Category**: [Category]
**Description**: [What could be improved]
**Benefit**: [Why this would help]
**Implementation**: [How to implement]

---

## Detailed Findings by Category

### Visual Consistency

#### Typography
| Issue | Severity | Location | Status |
|-------|----------|----------|--------|
| Mixed font sizes | Major | Multiple | 🔴 Open |
| Hardcoded colors | Minor | src/pages | 🟡 Open |

#### Colors
[Findings table...]

#### Spacing
[Findings table...]

---

### Component Patterns

#### Buttons
[Findings...]

#### Forms
[Findings...]

#### Modals
[Findings...]

---

### Accessibility

#### Keyboard Navigation
[Findings...]

#### Screen Reader
[Findings...]

#### Color Contrast
[Findings...]

---

### Responsive Design

#### Mobile (< 768px)
[Findings...]

#### Tablet (768px - 1024px)
[Findings...]

#### Desktop (> 1024px)
[Findings...]

---

### UX Quality

#### User Flows
[Findings...]

#### Error Handling
[Findings...]

#### Feedback
[Findings...]

---

### Design System Health

#### Token Adoption
[Findings...]

#### Component Library
[Findings...]

#### Documentation
[Findings...]

---

## Screenshots & Visual Evidence

### Desktop View (1920px)
[Screenshot]

### Tablet View (768px)
[Screenshot]

### Mobile View (375px)
[Screenshot]

### Component State Screenshots
- Button states: [Screenshot]
- Form validation: [Screenshot]
- Error states: [Screenshot]

---

## Remediation Roadmap

### Phase 1: Critical (Immediate)
| ID | Issue | Effort | Owner | Due Date |
|----|-------|--------|-------|----------|
| CRT-001 | [Issue] | Low | | |
| CRT-002 | [Issue] | Medium | | |

### Phase 2: Major (1-2 weeks)
| ID | Issue | Effort | Owner | Due Date |
|----|-------|--------|-------|----------|
| MAJ-001 | [Issue] | Medium | | |
| MAJ-002 | [Issue] | High | | |

### Phase 3: Minor (1 month)
[Table...]

### Phase 4: Suggestions (Backlog)
[Table...]

---

## Appendix

### A. Audit Methodology
- Automated scanning using grep patterns for code analysis
- Manual visual inspection using Chrome DevTools MCP
- Keyboard navigation testing
- Screen reader testing (simulated)
- Responsive testing across 10+ viewport sizes

### B. Tools Used
- Chrome DevTools Accessibility panel
- Color contrast analyzers
- Responsive design mode
- Lighthouse audits

### C. Files Analyzed
- Total files scanned: X
- Component files: X
- Style files: X
- Page files: X

### D. Breakpoints Tested
- 320px, 375px, 414px, 768px, 1024px, 1280px, 1440px, 1920px

### E. Color Tokens Found
[List of color tokens and their usage counts]

### F. Spacing Values Found
[List of spacing values found in codebase]

---

## Changelog

| Date | Version | Changes |
|------|---------|---------|
| YYYY-MM-DD | 1.0 | Initial audit |

---

*Generated by picky-design skill*
