Generate a sprint retrospective by synthesizing PR metrics, git activity, and team patterns into actionable insights.

Inspired by [gstack](https://github.com/garrytan/gstack) (Garry Tan) `/retro` concept.

## Input

$ARGUMENTS — optional: time range (e.g., "last 2 weeks", "sprint 14"), or team member name for individual retro

Defaults to the last 2 weeks if no range specified.

## Configuration

Set your team baselines before first use. These are used to flag deviations:

```
# ── Customize for your team ──────────────────
BASELINE_PRS_PER_WEEK=15          # total PRs merged per week
BASELINE_P90_CYCLE_DAYS=6.5       # p90 PR cycle time in days
BASELINE_REVIEW_COVERAGE_PCT=80   # % of PRs that get at least one review

# Compliance & security (set to "true" if your team is in audit scope)
COMPLIANCE_ENABLED=false           # ISO 27001, SOC 2, etc.
SAST_TOOL="bandit"                 # bandit | semgrep | sonarqube
SECRETS_TOOL="gitleaks"            # gitleaks | trufflehog | git-secrets
SECURITY_SENSITIVE_PATHS="auth|crypto|permission|secret|token|middleware|security"
# ──────────────────────────────────────────────
```

## Step 1: Gather Data

### 1a. PR Metrics

If your project has a PR metrics script, run it:

```bash
python3 scripts/pr-metrics.py --days 14
# or use GitHub CLI directly:
gh pr list --state merged --limit 50 --json number,author,createdAt,mergedAt,reviews,additions,deletions
```

Extract:
- Total PRs merged
- Per-person PR count
- Cycle time (median + p90)
- Review coverage %
- PRs without reviews

### 1b. Git Activity

```bash
git log --oneline --no-merges --since="2 weeks ago" --format="%an" | sort | uniq -c | sort -rn
```

### 1c. Shipping Streaks

Check consecutive days with merged PRs per person:

```bash
git log --no-merges --since="2 weeks ago" --format="%an|%as" | sort | uniq | awk -F'|' '{print $1, $2}'
```

### 1d. Test Health

```bash
# New test files this sprint
git log --no-merges --since="2 weeks ago" --diff-filter=A --name-only --format="" -- "*/tests/*" "*/test_*" "**/*.test.*" "**/*.spec.*" | sort -u
```

### 1e. Release Activity

```bash
git tag --sort=-creatordate | head -5
```

## Step 2: Security & Compliance Signals (if applicable)

If your team is in scope for ISO 27001, SOC 2, or similar audits, gather these signals each sprint. Skip this step if compliance is not a concern.

### 2a. Static Analysis / Code Quality Gate

```bash
# SAST — run your static analysis tool
bandit -r src/ -f json 2>/dev/null | python3 -c "import sys,json; d=json.load(sys.stdin); print(f'Issues: {len(d.get(\"results\",[]))}, Severity: high={sum(1 for r in d[\"results\"] if r[\"issue_severity\"]==\"HIGH\")}')" || echo "bandit not installed"

# or Semgrep
semgrep --config=auto src/ --json 2>/dev/null | python3 -c "import sys,json; d=json.load(sys.stdin); print(f'Findings: {len(d.get(\"results\",[]))}')" || echo "semgrep not installed"

# or SonarQube (if integrated)
# Check quality gate status from CI artifacts
```

### 2b. Dependency Vulnerability Scan

```bash
# Python
pip-audit --desc 2>/dev/null | tail -10 || safety check 2>/dev/null | tail -10

# JavaScript/TypeScript
pnpm audit --audit-level=moderate 2>/dev/null | tail -10

# Container images (if applicable)
trivy image your-app:latest --severity HIGH,CRITICAL 2>/dev/null | tail -15
```

### 2c. Secrets Detection

```bash
# Check for committed secrets this sprint
git log --no-merges --since="2 weeks ago" --diff-filter=A --name-only --format="" | \
  xargs grep -rlE '(AKIA[0-9A-Z]{16}|sk-[a-zA-Z0-9]{48}|-----BEGIN (RSA |EC )?PRIVATE KEY)' 2>/dev/null

# or use gitleaks / trufflehog
gitleaks detect --source . --since="2 weeks ago" 2>/dev/null | tail -10
```

### 2d. Threat Model Changes

Check if PRs this sprint touched security-sensitive areas:

```bash
# PRs touching auth, crypto, permissions, secrets, tokens
gh pr list --state merged --limit 50 --json number,title,files \
  --jq '.[] | select(.files[]?.path | test("auth|crypto|permission|secret|token|middleware|security")) | "\(.number) \(.title)"' 2>/dev/null
```

Flag these PRs for:
- Were they reviewed by someone with security context?
- Do they need threat model updates?
- Are there new attack surfaces (new endpoints, new auth flows)?

### 2e. Access & Infrastructure Changes

```bash
# IAM / permission changes this sprint
git log --no-merges --since="2 weeks ago" --name-only --format="" -- \
  "**/iam/**" "**/rbac/**" "**/permissions/**" "**/*policy*" \
  "*.tf" "**/terraform/**" "**/k8s/**" "**/*deploy*" 2>/dev/null | sort -u
```

## Step 3: Analyze Patterns

Compare against your configured baseline. Flag anything that deviates >20%:

| Metric | Baseline | This Sprint | Delta | Signal |
|--------|----------|-------------|-------|--------|
| PRs/week | {BASELINE} | ? | ? | on-track / slow / hot |
| p90 cycle | {BASELINE} | ? | ? | healthy / sluggish |
| Review coverage | {BASELINE} | ? | ? | healthy / slipping |

### Identify patterns

Look for:
- **Bottlenecks**: who has long cycle times? Are reviews piling up?
- **Imbalance**: is one person doing most of the work? Is one side blocked?
- **Silent periods**: gaps with no commits — vacation, blocked, or context-switching?
- **Big PRs**: any PRs with >500 lines changed? These slow reviews down
- **Unreviewed merges**: PRs merged without review — risk or urgency?

## Step 4: Generate Retro Report

Output format:

```markdown
# Sprint Retro — {date range}

## Scoreboard

| Metric | This Sprint | Baseline | Trend |
|--------|-------------|----------|-------|
| PRs merged | N | ~{BASELINE}/sprint | arrow |
| Cycle time (p90) | Nd | {BASELINE}d | arrow |
| Review coverage | N% | {BASELINE}% | arrow |
| Test files added | N | — | — |

## Per-Person Breakdown

| Name | PRs | Commits | Streak | Avg Cycle | Notes |
|------|-----|---------|--------|-----------|-------|
| <member> | N | N | Nd | Nd | ... |

## Security & Compliance (if applicable)

| Check | Status | Details |
|-------|--------|---------|
| SAST scan | PASS/WARN | N new findings (N high) |
| Dependency vulns | PASS/WARN | N vulnerabilities |
| Secrets detection | CLEAN/ALERT | N findings |
| Security-sensitive PRs | N PRs | reviewed: Y/N |
| Threat model updates needed | yes/no | <areas> |
| IAM/infra changes | N files | reviewed: Y/N |

## What Went Well
- <data-backed observation>

## What Needs Attention
- <data-backed concern with specific numbers>

## Action Items
- [ ] <specific, assignable action>
```

## Step 5: Compare to Previous Retro (if available)

Check for previous retro files:

```bash
ls -t raw-data/retros/ 2>/dev/null | head -3
```

If previous retros exist, add a **Trends** section comparing this sprint to the last 2-3:
- Are action items from last retro addressed?
- Are recurring patterns emerging?

## Step 6: Save

Save the retro to `raw-data/retros/{date}.md` (create the directory if needed).

## Related Skills

| If you need... | Use instead |
|----------------|-------------|
| Raw PR data only | `/pr-metrics` or `gh pr list` (this skill wraps them with analysis) |
| Individual member deep-dive | `/1on1-prep` (for 1-on-1 meeting prep) |
| Repo health (deps, lint, CI) | `/health-check` (infra-focused, not people-focused) |

## Rules

1. **Data over opinions** — every observation must cite a specific metric or commit
2. **Name names carefully** — per-person breakdowns are for the tech lead, not for public shaming. Keep tone constructive
3. **Action items must be specific** — "improve test coverage" is useless; "add integration tests for billing module (currently 0%)" is actionable
4. **Compare to baseline** — raw numbers without context are meaningless
5. **Don't over-interpret small samples** — 2 weeks of data can be noisy; flag uncertainty
6. **Security findings are action items, not FYIs** — every vulnerability or unreviewed auth PR gets a specific owner and deadline
7. **Threat model is living** — if the sprint shipped new auth flows, API endpoints, or infra changes, the threat model needs updating
