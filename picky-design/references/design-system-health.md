# Design System Health Audit

## Audit Philosophy

**A design system is only as good as its adoption.** The best-documented system is worthless if developers bypass it. The most consistent tokens are pointless if components ignore them. Your job is to find EVERY gap between the design system's intent and the codebase's reality.

---

## 1. Token Audit

### 1.1 Color Tokens
- [ ] **Tokens exist** - Colors defined as variables/tokens
- [ ] **Tokens are semantic** - Named by purpose, not value (text-primary not gray-900)
- [ ] **Tokens are used** - Actual code uses tokens, not raw values
- [ ] **Token coverage** - All needed colors have tokens
- [ ] **No orphan tokens** - No defined tokens that are unused
- [ ] **Dark mode tokens** - Tokens have dark mode variants

```bash
# Find color token definitions
grep -rn "colors\s*[=:{]\|--color-\|color-[a-z]*:" --include="*.ts" --include="*.css" --include="*.json"

# Find raw color values that should be tokens
grep -rn "#[0-9a-fA-F]\{3,8\}" --include="*.tsx" --include="*.jsx" | grep -v "var(--\|theme\.\|colors\."

# Count raw vs token usage
echo "Raw colors:"; grep -rc "#[0-9a-fA-F]\{3,8\}" --include="*.tsx" 2>/dev/null | awk -F: '{sum+=$2} END {print sum}'
echo "Token colors:"; grep -rc "var(--\|theme\.\|colors\." --include="*.tsx" 2>/dev/null | awk -F: '{sum+=$2} END {print sum}'
```

### 1.2 Typography Tokens
- [ ] **Font family tokens** - Font families as tokens
- [ ] **Font size scale** - Size scale defined
- [ ] **Font weight tokens** - Weights as semantic tokens
- [ ] **Line height tokens** - Line heights tokenized
- [ ] **Letter spacing tokens** - Tracking values tokenized
- [ ] **Text style compositions** - Combined styles (heading-lg = size + weight + height)

```bash
# Find typography token usage vs raw
grep -rn "font-size:\s*[0-9]" --include="*.css" --include="*.tsx"
grep -rn "fontSize.*['\"]?[0-9]" --include="*.tsx" --include="*.ts"
```

### 1.3 Spacing Tokens
- [ ] **Spacing scale exists** - Defined spacing values
- [ ] **Scale is systematic** - 4px, 8px, 12px... or similar
- [ ] **Tokens are used** - Padding/margin use tokens
- [ ] **Negative spacing** - Negative margins use tokens
- [ ] **Gap tokens** - Flex/grid gaps use tokens

```bash
# Find spacing token definitions
grep -rn "spacing\s*[=:{]\|--space-" --include="*.ts" --include="*.css" --include="*.json"

# Find raw spacing values
grep -rn "margin:\s*[0-9]\|padding:\s*[0-9]\|gap:\s*[0-9]" --include="*.css"
```

### 1.4 Border Tokens
- [ ] **Border width tokens** - 1px, 2px defined
- [ ] **Border radius tokens** - Radius scale defined
- [ ] **Border color tokens** - Colors use semantic tokens

### 1.5 Shadow Tokens
- [ ] **Shadow scale exists** - Elevation levels defined
- [ ] **Shadows are consistent** - Same shadow for same elevation
- [ ] **Shadow tokens used** - No inline box-shadow values

### 1.6 Animation Tokens
- [ ] **Duration tokens** - Timing values defined
- [ ] **Easing tokens** - Easing curves defined
- [ ] **Tokens are used** - Transitions reference tokens

---

## 2. Component Library Audit

### 2.1 Component Inventory
- [ ] **Components catalogued** - List of all components exists
- [ ] **Components documented** - Props, usage documented
- [ ] **Storybook or equivalent** - Visual component catalog
- [ ] **Single source of truth** - One component library, not multiple

```bash
# Find all component definitions
grep -rn "export.*function\|export.*const.*React.FC\|export default" --include="*.tsx" | grep -v "test\|spec\|story\|mock"

# Count component files
find . -name "*.tsx" -path "*/components/*" | wc -l
```

### 2.2 Component Consistency
- [ ] **Naming conventions** - PascalCase, consistent naming
- [ ] **File structure** - Consistent organization (Component/index.tsx, Component.tsx)
- [ ] **Props naming** - Similar props have same names (variant, size, disabled)
- [ ] **Props API similar** - Components share similar interfaces

### 2.3 Component Variants
- [ ] **Variants documented** - All variants listed
- [ ] **Variants implemented consistently** - Same variant names across components
- [ ] **Variant prop patterns** - Same approach (variant prop vs separate components)

### 2.4 Component Composition
- [ ] **Composable** - Components can be combined
- [ ] **Slots/children** - Flexible content areas
- [ ] **Compound components** - Related components work together

---

## 3. Token Adoption Analysis

### 3.1 Token Usage Rate
Calculate what percentage of styling uses tokens:

```bash
# Tailwind - arbitrary values (bad) vs utilities (good)
echo "Arbitrary values:"; grep -roc "\[#\|\[[\d\.]*px\|\[[\d\.]*rem" --include="*.tsx" 2>/dev/null | awk -F: '{sum+=$2} END {print sum}'

# Inline styles (bad)
echo "Inline styles:"; grep -rc "style={{" --include="*.tsx" 2>/dev/null | awk -F: '{sum+=$2} END {print sum}'
```

### 3.2 Token Violations by Type
Track violations for each token type:

- [ ] **Color violations** - Hardcoded colors
- [ ] **Typography violations** - Hardcoded font values
- [ ] **Spacing violations** - Hardcoded margins/paddings
- [ ] **Border violations** - Hardcoded borders
- [ ] **Shadow violations** - Hardcoded shadows

### 3.3 Token Violations by Area
Track violations by codebase area:

- [ ] **Marketing pages** - Often skip design system
- [ ] **Dashboard** - Should be strict
- [ ] **Forms** - Should be consistent
- [ ] **Legacy code** - May have debt

---

## 4. Documentation Audit

### 4.1 Design Principles
- [ ] **Principles documented** - Guiding principles exist
- [ ] **Principles applied** - Codebase reflects principles
- [ ] **Principles accessible** - Team knows where to find them

### 4.2 Usage Guidelines
- [ ] **When to use what** - Component selection guidance
- [ ] **Composition patterns** - How to combine components
- [ ] **Do's and don'ts** - Clear guidance with examples
- [ ] **Accessibility notes** - A11y requirements per component

### 4.3 Design Specifications
- [ ] **Token values documented** - All values visible
- [ ] **Component specs** - Sizes, spacing, states documented
- [ ] **Figma/design tool sync** - Design matches code
- [ ] **Responsive specs** - Breakpoint behavior documented

### 4.4 Code Documentation
- [ ] **TypeScript types** - Props fully typed
- [ ] **JSDoc comments** - Components have descriptions
- [ ] **Examples** - Code examples in docs
- [ ] **Storybook stories** - Interactive examples

```bash
# Find components without types
grep -rL "interface\|type.*Props" --include="*.tsx" | head -20

# Find components without JSDoc
grep -rL "\/\*\*\|@param\|@returns" --include="*.tsx" | head -20
```

---

## 5. Consistency Audit

### 5.1 Similar Components
Check if similar components have similar APIs:

- [ ] **Button sizes** - Same scale across components
- [ ] **Color props** - Same names (variant, color, colorScheme)
- [ ] **State props** - Same names (disabled, loading, error)
- [ ] **Size props** - Same names (size, sz, dimensions)

### 5.2 Pattern Consistency
- [ ] **Form patterns** - All forms structured similarly
- [ ] **Table patterns** - All tables work similarly
- [ ] **Modal patterns** - All modals behave similarly
- [ ] **Error patterns** - All errors handled similarly

### 5.3 Naming Consistency
- [ ] **Token names** - Consistent naming (color-primary or primary-color)
- [ ] **Component names** - Consistent (Button, Card, Modal)
- [ ] **Prop names** - Consistent (onClick, onPress, handleClick)
- [ ] **File names** - Consistent (Button.tsx, button.tsx, Button/index.tsx)

---

## 6. Design-Code Sync

### 6.1 Token Sync
- [ ] **Color tokens match** - Figma colors = code colors
- [ ] **Typography matches** - Figma type = code type
- [ ] **Spacing matches** - Figma spacing = code spacing
- [ ] **Sync process exists** - Way to sync Figma → code

### 6.2 Component Sync
- [ ] **Components match** - Figma components = code components
- [ ] **Variants match** - Same variants in both
- [ ] **States match** - Same states in both
- [ ] **Names match** - Same naming conventions

### 6.3 Sync Verification
- [ ] **Regular audits** - Periodic sync checks
- [ ] **Automated checks** - Tooling to verify sync
- [ ] **Source of truth clear** - Design or code leads?

---

## 7. Maintenance Health

### 7.1 Change Process
- [ ] **Change process exists** - How to propose changes
- [ ] **Review process** - Changes are reviewed
- [ ] **Versioning** - Changes are versioned
- [ ] **Changelog** - Changes are documented
- [ ] **Migration guides** - Breaking changes have guides

### 7.2 Debt Tracking
- [ ] **Debt identified** - Known issues documented
- [ ] **Debt prioritized** - Importance ranked
- [ ] **Debt addressed** - Active work on debt
- [ ] **Debt doesn't grow** - New code follows system

### 7.3 Adoption Metrics
- [ ] **Usage tracked** - Which components used where
- [ ] **Violations tracked** - Token/pattern violations counted
- [ ] **Trends monitored** - Getting better or worse?

---

## 8. Theming Audit

### 8.1 Theme Structure
- [ ] **Theme exists** - Centralized theme definition
- [ ] **Theme complete** - All tokens in theme
- [ ] **Theme extensible** - Can add custom values
- [ ] **Theme typed** - TypeScript types for theme

```bash
# Find theme definition
grep -rn "createTheme\|ThemeProvider\|theme\s*[=:]" --include="*.ts" --include="*.tsx"
```

### 8.2 Dark Mode
- [ ] **Dark mode exists** - If needed, implemented
- [ ] **Dark mode complete** - All UI works in dark mode
- [ ] **Transition smooth** - No flash when switching
- [ ] **Preference respected** - System preference honored

```bash
# Find dark mode handling
grep -rn "dark:\|dark-mode\|prefers-color-scheme" --include="*.tsx" --include="*.css"
```

### 8.3 Multi-Theme (if applicable)
- [ ] **Theme switching works** - Can change themes
- [ ] **Themes complete** - Each theme fully defined
- [ ] **No hardcoded overrides** - Themes don't need hacks

---

## 9. Accessibility in Design System

### 9.1 A11y Built In
- [ ] **Focus styles defined** - System-level focus rings
- [ ] **Contrast checked** - Color combinations pass WCAG
- [ ] **Semantic HTML** - Components use correct elements
- [ ] **ARIA patterns** - Complex widgets have ARIA

### 9.2 A11y Documentation
- [ ] **A11y requirements** - Per-component a11y notes
- [ ] **Keyboard support** - Documented keyboard interactions
- [ ] **Screen reader behavior** - What gets announced

### 9.3 A11y Testing
- [ ] **A11y tests exist** - Automated a11y testing
- [ ] **Manual testing** - Regular manual audits
- [ ] **Real user testing** - Tested with disabled users

---

## 10. Performance in Design System

### 10.1 Bundle Size
- [ ] **Tree shakeable** - Unused code eliminated
- [ ] **Code split** - Components load on demand
- [ ] **No bloat** - Dependencies minimal
- [ ] **Size tracked** - Bundle size monitored

```bash
# Check package sizes (if using npm packages)
npm ls --all 2>/dev/null | head -50
```

### 10.2 Runtime Performance
- [ ] **Efficient rendering** - Components don't over-render
- [ ] **Memoization used** - Where beneficial
- [ ] **No layout thrashing** - No forced reflows
- [ ] **Animations performant** - Use transform/opacity

### 10.3 CSS Performance
- [ ] **No unused CSS** - All styles are used
- [ ] **CSS scoped** - No global style leaks
- [ ] **Specificity controlled** - No !important battles

---

## 11. Scalability Assessment

### 11.1 Current Scale
- [ ] **Component count** - How many components?
- [ ] **Token count** - How many tokens?
- [ ] **Usage breadth** - How many projects use it?
- [ ] **Contributor count** - How many people contribute?

### 11.2 Growth Readiness
- [ ] **Adding components** - Process is clear and efficient
- [ ] **Adding tokens** - Token extension is easy
- [ ] **Deprecation process** - How to retire old things
- [ ] **Breaking changes** - Managed carefully

### 11.3 Technical Scalability
- [ ] **Monorepo ready** - Works in multi-package setup
- [ ] **Multi-framework** - Works with different frameworks
- [ ] **Cross-platform** - Web, native, etc.

---

## 12. Team Adoption Audit

### 12.1 Awareness
- [ ] **Team knows it exists** - Design system is known
- [ ] **Team knows where** - Documentation is findable
- [ ] **Team knows how** - Usage is understood

### 12.2 Actual Usage
- [ ] **New code uses system** - New features follow system
- [ ] **Old code being migrated** - Legacy code updated
- [ ] **Exceptions documented** - When/why bypasses happen

### 12.3 Contribution
- [ ] **Team can contribute** - Process is open
- [ ] **Team wants to contribute** - Motivated to improve
- [ ] **Feedback incorporated** - Team input valued

---

## Health Score Calculation

Score each area 0-100:

| Area | Weight | Score | Weighted |
|------|--------|-------|----------|
| Token Definition | 10% | /100 | |
| Token Adoption | 15% | /100 | |
| Component Library | 15% | /100 | |
| Documentation | 15% | /100 | |
| Consistency | 15% | /100 | |
| Design-Code Sync | 10% | /100 | |
| Accessibility | 10% | /100 | |
| Maintenance | 10% | /100 | |
| **Total** | 100% | | /100 |

### Scoring Guidelines

- **90-100**: Exemplary design system
- **70-89**: Healthy system with minor gaps
- **50-69**: Functional but needs work
- **30-49**: Significant issues, adoption problems
- **0-29**: Design system in name only

---

## Automated Audit Commands

```bash
# Overall design system health check script
echo "=== Design System Health Check ==="

echo "\n--- Token Usage ---"
echo "CSS custom properties defined:"
grep -rc "^--" --include="*.css" 2>/dev/null | awk -F: '{sum+=$2} END {print sum}'

echo "\nColor tokens used:"
grep -rc "var(--color\|theme\.colors\|colors\." --include="*.tsx" 2>/dev/null | awk -F: '{sum+=$2} END {print sum}'

echo "\nHardcoded colors (violations):"
grep -rc "#[0-9a-fA-F]\{6\}" --include="*.tsx" 2>/dev/null | awk -F: '{sum+=$2} END {print sum}'

echo "\n--- Component Analysis ---"
echo "Component files:"
find . -name "*.tsx" -path "*/components/*" 2>/dev/null | wc -l

echo "\nComponents with TypeScript types:"
grep -rl "interface.*Props\|type.*Props" --include="*.tsx" 2>/dev/null | wc -l

echo "\nInline styles (violations):"
grep -rc "style={{" --include="*.tsx" 2>/dev/null | awk -F: '{sum+=$2} END {print sum}'

echo "\n--- Documentation ---"
echo "Components with JSDoc:"
grep -rl "\/\*\*" --include="*.tsx" 2>/dev/null | wc -l

echo "\n--- Consistency ---"
echo "Different button variants in use:"
grep -roh "variant=['\"][^'\"]*['\"]" --include="*.tsx" 2>/dev/null | sort | uniq -c
```
