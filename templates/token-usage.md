Track AI token consumption per team member and compare against output metrics (PRs, commits).

## Input

$ARGUMENTS — optional: `--week 15`, `--member alice`, or `--all` (default: current week, all members)

## Configuration

```
# ── Customize for your team ──────────────────
TEAM_MEMBERS="alice bob charlie diana"
TOKEN_LOG_DIR="raw-data/token-logs"
TOKEN_BUDGET_WEEKLY=500000           # tokens per person per week (adjust for your plan)
# ──────────────────────────────────────────────
```

## Instructions

### 1. Gather Token Data

```bash
# Option A: Use the included script (local Claude Code sessions)
bash scripts/token-usage.sh --since "7 days ago"

# Option B: API proxy logs (recommended for teams — each user's usage in one place)
# Most teams route API calls through a proxy (LiteLLM, Helicone, etc.)
# Export usage CSV from your proxy dashboard

# Option C: Anthropic Console (org-level, manual export)
# console.anthropic.com → Usage → Export

# Option D: Claude Code session files (per-machine)
# ~/.claude/projects/*/sessions/ contains per-session token counts
```

**For team-wide tracking**, Option B (API proxy) is the most reliable. The included `scripts/token-usage.sh` works for single-machine usage but won't aggregate across your team's laptops.

### 2. Gather Output Metrics (same period)

```bash
# PRs merged this week
gh pr list --state merged --limit 50 \
  --json author,mergedAt \
  --jq '[.[] | select(.mergedAt > "2025-01-06")] | group_by(.author.login) | map({user: .[0].author.login, prs: length})'

# Commits this week
git log --no-merges --since="1 week ago" --format="%an" | sort | uniq -c | sort -rn
```

### 3. Calculate Efficiency Ratio

For each member:
- **Tokens used**: from token logs or billing
- **PRs merged**: from GitHub
- **Commits**: from git log
- **Tokens per PR**: `tokens / PRs` (lower is more efficient)

### 4. Output Report

```markdown
## Token Usage Report — Week {N} ({date range})

### Team Overview

| Member | Tokens Used | Budget | % Used | PRs | Commits | Tokens/PR |
|--------|------------|--------|--------|-----|---------|-----------|
| alice  | 120,000    | 500K   | 24%    | 5   | 12      | 24,000    |
| bob    | 380,000    | 500K   | 76%    | 8   | 20      | 47,500    |
| charlie| 45,000     | 500K   | 9%     | 2   | 4       | 22,500    |
| diana  | 0          | 500K   | 0%     | 3   | 8       | —         |

### Signals

- **High efficiency**: alice, charlie — low tokens per PR
- **High usage, high output**: bob — heavy user but shipping proportionally
- **Zero usage**: diana — not using AI tools (worth discussing in 1:1)
- **High usage, low output**: (none this week)

### Trends (vs last week)

| Member | Tokens Delta | PR Delta | Notes |
|--------|-------------|----------|-------|
| alice  | +15%        | +2       | ramping up on new feature |
| bob    | -10%        | +1       | stabilizing after exploration |
```

### 5. Save

Save to `{TOKEN_LOG_DIR}/week-{N}-report.md`.

## Interpreting the Data

### Healthy Patterns
- **Steady usage + steady PRs** — AI is integrated into workflow
- **Usage spikes during exploration, drops during shipping** — natural rhythm
- **Team-wide adoption** — everyone using tokens, nobody at zero

### Warning Patterns
- **High tokens, zero PRs** — prompt thrashing, restarting conversations, not landing code
- **Zero tokens, many PRs** — not adopting AI tools (missing productivity gains)
- **One person using 80% of team budget** — investigate if it's a skills gap or tooling issue

### What This Is NOT
- This is **not** a productivity surveillance tool
- Token counts measure **tool engagement**, not developer value
- A developer who ships 3 high-quality PRs with zero tokens is doing great
- Use this data to **coach** (help struggling users get better at prompting) not to **judge**

## Related Skills

- `/pr-metrics` — raw PR data this report depends on
- `/1on1-prep` — uses token data as one signal in meeting prep
- `/retro` — sprint-level view of team output

## Rules

1. **Never rank or shame** — this is for the tech lead's private use
2. **Context matters** — a week of high tokens with no PRs might be research, onboarding, or learning
3. **Compare trends, not absolutes** — one week is noisy; look at 4-week rolling averages
4. **Budget is a guideline** — going over budget while shipping is fine; staying under budget while stuck is not
