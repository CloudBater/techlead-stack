Run PR metrics and compare against team baselines.

This is a **template** — adapt the script paths and baselines to your project.

## Input

$ARGUMENTS — optional: `--days 30`, `--months 6`, or `--from-file <path>`

## Instructions

1. Gather PR data using your preferred method:

```bash
# Option A: GitHub CLI (works for any GitHub repo)
gh pr list --state merged --limit 100 \
  --json number,author,title,createdAt,mergedAt,additions,deletions,reviews,headRefName \
  > /tmp/pr-data.json

# Option B: Custom script (if you have one)
python3 scripts/pr-metrics.py $ARGUMENTS
```

2. Analyze the data. Key metrics to extract:
   - Total PRs merged (split by team/area if applicable)
   - Per-person PR count
   - Cycle time: `mergedAt - createdAt` (median + p90)
   - Review coverage: `PRs with >= 1 review / total PRs`
   - PRs without reviews (list them)
   - Bug-fix ratio: `PRs with "fix" in title / total PRs`

3. Compare against your baselines:

```
# ── Set your team baselines ──────────────────
BASELINE_PRS_PER_WEEK=15
BASELINE_P90_CYCLE_DAYS=7
BASELINE_ZERO_REVIEW_PCT=25
BASELINE_BUG_FIX_RATIO=20
# ──────────────────────────────────────────────
```

4. Highlight significant deviations (>20% from baseline).

## Output Format

```markdown
## PR Metrics — {period}

| Metric | Current | Baseline | Delta |
|--------|---------|----------|-------|
| PRs/week | N | {baseline} | +/-N% |
| p90 cycle | Nd | {baseline}d | +/-N% |
| Zero-review % | N% | {baseline}% | +/-N% |
| Bug-fix ratio | N% | {baseline}% | +/-N% |

### Per-Person Breakdown

| Author | PRs | Median Cycle | Largest PR |
|--------|-----|-------------|------------|
| name | N | Nd | +N lines |
```

## Related Skills

- `/retro` wraps this data with team analysis and action items
- `/1on1-prep` uses this data for individual member deep-dives
