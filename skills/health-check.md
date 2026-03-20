Run a project health check across the repo, dependencies, code quality, tests, and CI. Outputs a dashboard for the tech lead.

Inspired by [Claude-Command-Suite](https://github.com/qdhenry/Claude-Command-Suite) (qdhenry) `/project:project-health-check`.

## Input

$ARGUMENTS — optional: specific module name, or "all" (default: all)

## Configuration

Customize these for your project before first use:

```
# Directories to scan (space-separated)
MODULES="backend frontend"

# Package managers
BE_PKG_MGR="poetry"      # poetry | pip | uv
FE_PKG_MGR="pnpm"        # pnpm | npm | yarn | bun

# CI system
CI_SYSTEM="github"       # github | cloud-build | gitlab | circleci

# GitHub org/repo (for CI status checks)
GH_REPO="your-org/your-repo"
```

## Step 1: Repository Health

```bash
# Submodule status (if applicable)
git submodule status 2>/dev/null

# Uncommitted changes
git status --short

# Stale branches (merged but not deleted)
git branch --merged main | grep -v 'main\|master\|develop' | wc -l
```

## Step 2: Dependency Health

### Python (Poetry/pip/uv)

```bash
# Outdated packages
poetry show --outdated 2>/dev/null | head -20
# or: pip list --outdated 2>/dev/null | head -20

# Known vulnerabilities
pip-audit --desc 2>/dev/null | tail -20 || echo "pip-audit not installed"
```

### JavaScript/TypeScript (pnpm/npm/yarn)

```bash
# Outdated packages
pnpm outdated 2>/dev/null | head -20

# Audit
pnpm audit --audit-level=moderate 2>/dev/null | tail -20
```

## Step 3: Code Quality Signals

```bash
# Python — ruff
ruff check src/ --statistics 2>/dev/null | tail -10

# TypeScript — ESLint + type checking
pnpm lint 2>/dev/null | tail -5
pnpm type-check 2>/dev/null | tail -5
# or: npx tsc --noEmit 2>/dev/null | tail -5
```

## Step 4: Test Health

```bash
# Count test files
find . -path "*/tests/test_*.py" -o -path "*/tests/*_test.py" | wc -l
find . -name "*.test.*" -o -name "*.spec.*" | wc -l
```

If a test coverage summary file exists in the project, read it for module-level coverage.

## Step 5: CI/CD Status

```bash
# GitHub Actions
gh run list --limit=5 --json conclusion,name,headBranch \
  --jq '.[] | "\(.conclusion)\t\(.name)\t\(.headBranch)"' 2>/dev/null

# Google Cloud Build (add --region if needed)
gcloud builds list --limit=5 \
  --format="table(id,status,createTime,source.repoSource.branchName)" 2>/dev/null

# GitLab CI
# glab ci list --per-page=5 2>/dev/null
```

Use whichever CI system the project uses. If the tool isn't available, note "not available" and continue.

## Step 6: Git Activity (last 7 days)

```bash
git log --oneline --no-merges --since="7 days ago" --format="%an" | sort | uniq -c | sort -rn
```

## Step 7: Security Quick Scan

```bash
# Check for committed secrets patterns
git ls-files | xargs grep -rlE '(AKIA[0-9A-Z]{16}|sk-[a-zA-Z0-9]{48}|-----BEGIN (RSA |EC )?PRIVATE KEY)' 2>/dev/null | head -5

# Check tracked .env files
git ls-files | grep -iE '\.env$|\.env\.' | grep -v '.env.example' 2>/dev/null
```

## Step 8: Output Dashboard

```markdown
# Project Health Check — {date}

## Summary

| Area | Status | Details |
|------|--------|---------|
| Repository | OK/WARN | N stale branches, N uncommitted files |
| Dependencies (BE) | OK/WARN | N outdated, N vulnerabilities |
| Dependencies (FE) | OK/WARN | N outdated, N audit issues |
| Lint (BE) | PASS/FAIL | N issues |
| Lint (FE) | PASS/FAIL | N issues |
| Type Check | PASS/FAIL | N errors |
| Tests (BE) | N files | coverage: X% |
| Tests (FE) | N files | coverage: X% |
| CI/CD | PASS/FAIL | last 5 builds |
| Secrets | CLEAN/ALERT | N findings |

## Action Items (auto-generated)

- [ ] {specific action based on findings}
- [ ] {specific action based on findings}

## 7-Day Activity

| Contributor | Commits |
|-------------|---------|
| name | N |
```

## Related Skills

| If you need... | Use instead |
|----------------|-------------|
| Unused code specifically | `/dead-code` (deeper than the lint check in Step 3) |
| Sprint-level team analysis | `/retro` (team metrics + trends, not repo health) |
| Fix issues found here | `/investigate` for bugs, `/delegate` for bulk cleanup |

## Rules

1. **Never run fixes** — this is read-only diagnostics, no code changes
2. **Fail gracefully** — if a tool isn't installed, note "not available" and continue
3. **Flag, don't block** — WARN status means attention needed, not a crisis
