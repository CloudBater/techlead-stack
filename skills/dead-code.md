Find and report unused code across the codebase. Does NOT auto-delete — presents findings for human review.

Inspired by [Claude-Command-Suite](https://github.com/qdhenry/Claude-Command-Suite) (qdhenry) `/dev:remove-dead-code` multi-agent scanning concept.

## Input

$ARGUMENTS — target: "backend", "frontend", or specific module path (e.g., "src/billing")

Default: scan the full project.

## Step 1: Determine Scope

Parse $ARGUMENTS to decide what to scan. If a specific module is given, scope to that directory. Otherwise scan the entire project.

## Step 2: Scan for Dead Code

### Python Projects

Use multiple detection strategies:

#### 2a. Unused imports

```bash
# ruff can detect unused imports (F401)
ruff check src/ --select F401 --output-format concise 2>/dev/null
```

#### 2b. Unused variables and functions

```bash
# ruff F841 (unused variables), F811 (redefined unused)
ruff check src/ --select F841,F811 --output-format concise 2>/dev/null
```

#### 2c. Unreachable code

```bash
# vulture for dead code detection (if installed)
vulture src/ --min-confidence 80 2>/dev/null | head -30 || echo "vulture not installed — using ruff only"
```

#### 2d. Unused views/routes (Django/Flask/FastAPI)

Cross-reference:
- URL patterns / route definitions
- View functions / handler classes
- Any handler not referenced in any route is potentially dead

### TypeScript/JavaScript Projects

#### 2e. Unused exports

```bash
# ts-prune detects unused exports
npx ts-prune 2>/dev/null | head -30 || echo "ts-prune not available"
```

#### 2f. Unused components (React)

Search for components that are defined but never imported elsewhere:

```bash
# Find all exported components
grep -rn "export.*function\|export.*const.*=.*=>" src/ --include="*.tsx" --include="*.ts" -l
```

Then for each exported name, check if it's imported anywhere else. Flag components with zero imports outside their own file.

#### 2g. ESLint unused detection

```bash
pnpm lint 2>/dev/null | grep -i "unused\|no-unused" | head -20
# or: npx eslint src/ --rule '{"no-unused-vars":"warn"}' 2>/dev/null
```

## Step 3: Cross-Reference with Tests

For each finding, check if the "dead" code is only used in tests:

```bash
grep -rn "<function_name>" tests/ __tests__/ spec/ 2>/dev/null
```

Code used only in tests might still be needed (test helpers, fixtures).

## Step 4: Classify Findings

| Category | Risk | Action |
|----------|------|--------|
| Unused imports | Low | Safe to remove |
| Unused variables | Low | Safe to remove |
| Unreachable code | Low | Safe to remove |
| Unused private functions | Medium | Verify no dynamic calls |
| Unused exported functions | Medium | Check for external consumers |
| Unused views/endpoints | High | May be called by frontend or external services |
| Unused components | Medium | Check for lazy/dynamic imports |

## Step 5: Output Report

```markdown
# Dead Code Report — {date}

**Scope**: {what was scanned}
**Tools used**: {ruff, vulture, ts-prune, eslint — whichever were available}

## Summary

| Category | Count | Risk | Side |
|----------|-------|------|------|
| Unused imports | N | Low | BE |
| Unused variables | N | Low | BE |
| Unused functions | N | Medium | BE |
| Unused components | N | Medium | FE |
| Unused exports | N | Medium | FE |

## Findings

### Low Risk (safe to remove)

| File | Line | Type | Name |
|------|------|------|------|
| src/billing/views.py | 42 | unused import | `json` |

### Medium Risk (verify before removing)

| File | Line | Type | Name | Used in Tests? |
|------|------|------|------|----------------|
| src/billing/utils.py | 88 | unused function | `calc_old` | No |

### High Risk (may have external consumers)

| File | Line | Type | Name | Notes |
|------|------|------|------|-------|
| src/billing/views.py | 120 | unused view | `LegacyView` | Check frontend routes |
```

## Step 6: Suggest Next Steps

If the user wants to proceed with removal:

```
I found N items to clean up.
- Low risk items: can remove directly (safe)
- Medium/High risk: recommend a separate branch for review
```

## Related Skills

| If you need... | Use instead |
|----------------|-------------|
| Broader lint/quality check | `/health-check` (general repo health, not dead-code specific) |
| Bulk cleanup | `/delegate` (dispatch removal tasks to subagents) |
| Verify removal didn't break anything | `/investigate` if tests fail after cleanup |

## Rules

1. **Read-only by default** — never delete code without explicit user approval
2. **False positives are expected** — dynamic dispatch, reflection, lazy imports can fool static analysis
3. **Cross-module awareness** — a function unused in its own module may be imported elsewhere
4. **Don't flag test utilities** — helpers in `conftest.py` or `test_utils` are used by test discovery
5. **Don't flag __init__.py re-exports** — these are public API surface
6. **Prioritize by risk** — present low-risk items first to build confidence
