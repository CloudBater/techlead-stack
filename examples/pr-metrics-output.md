## PR Metrics — Last 6 Months (Oct 2024 - Mar 2025)

### Summary

| Metric             | Current  | Baseline | Delta  |
|--------------------|----------|----------|--------|
| Total PRs merged   | 312      | —        | —      |
| PRs/week (avg)     | 12.0     | 15       | -20%   |
| Cycle time (median)| 1.8d     | —        | —      |
| Cycle time (p90)   | 5.2d     | 6.5d     | -20%   |
| Review coverage    | 87%      | 80%      | +9%    |
| Zero-review rate   | 13%      | 20%      | -35%   |
| Bug-fix ratio      | 28%      | 25%      | +12%   |

### Per-Person Breakdown

| Author  | PRs | % of Total | Median Cycle | p90 Cycle | Reviews Given | Largest PR    |
|---------|-----|-----------|-------------|-----------|---------------|---------------|
| Frank   | 82  | 26%       | 1.2d        | 3.8d      | 45            | +1,200 lines  |
| Alice   | 68  | 22%       | 1.5d        | 4.5d      | 52            | +800 lines    |
| Bob     | 55  | 18%       | 2.1d        | 6.0d      | 38            | +950 lines    |
| Diana   | 48  | 15%       | 2.0d        | 5.5d      | 22            | +600 lines    |
| Charlie | 35  | 11%       | 3.2d        | 8.1d      | 15            | +1,500 lines  |
| Eve     | 24  | 8%        | 2.8d        | 7.2d      | 30            | +400 lines    |

### Observations

#### Strengths
- Review coverage at 87% — above baseline, team is reviewing each other's work
- p90 cycle improved to 5.2d (was 6.5d baseline) — faster turnaround on slow PRs
- Alice leads in reviews given (52) — team's quality anchor

#### Concerns
- PRs/week at 12 vs 15 baseline (-20%) — velocity dip. Correlates with Q1 planning overhead.
- Charlie's p90 at 8.1d — longest on team. 3 PRs sat in review >5 days (SSO feature, complex changes)
- Frank carries 26% of total PRs — bus factor risk if he's unavailable
- Eve at 8% of PRs — recently onboarded (started Nov), trajectory improving (2→4→6 PRs/month)

### Slowest PRs

| PR    | Author  | Cycle  | Root Cause                          |
|-------|---------|--------|-------------------------------------|
| #287  | Charlie | 12.3d  | Blocked on security review          |
| #301  | Bob     | 9.8d   | Waiting for API spec from partner   |
| #245  | Charlie | 8.5d   | Large refactor, 3 review rounds     |
| #312  | Diana   | 7.1d   | Holiday week, reviewer unavailable  |
| #198  | Alice   | 6.9d   | Cross-team dependency (FE blocked)  |

### PRs Without Review (zero-review)

| PR    | Author | Lines Changed | Risk Assessment              |
|-------|--------|--------------|------------------------------|
| #278  | Frank  | +45          | Low — config change          |
| #290  | Frank  | +120         | Medium — new API endpoint    |
| #305  | Alice  | +30          | Low — typo fix               |
| #310  | Bob    | +200         | High — auth middleware change |

**Note**: #310 merged without review despite touching auth. Flag in retro.
