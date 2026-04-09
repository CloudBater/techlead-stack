## Token Usage Report — Week 14 (Mar 31 - Apr 06, 2025)

### Team Overview

| Member   | Tokens Used | Budget | % Used | PRs | Commits | Tokens/PR |
|----------|------------|--------|--------|-----|---------|-----------|
| Alice    | 320,000    | 500K   | 64%    | 7   | 18      | 45,714    |
| Bob      | 180,000    | 500K   | 36%    | 4   | 10      | 45,000    |
| Charlie  | 485,000    | 500K   | 97%    | 3   | 6       | 161,667   |
| Diana    | 92,000     | 500K   | 18%    | 5   | 14      | 18,400    |
| Eve      | 0          | 500K   | 0%     | 2   | 5       | —         |
| Frank    | 410,000    | 500K   | 82%    | 9   | 22      | 45,556    |

**Team Total**: 1,487,000 tokens / 3,000K budget (50%)

### Signals

- **High efficiency**: Diana — lowest tokens/PR ratio (18,400), shipping consistently with minimal AI assist
- **High usage, high output**: Frank — 82% budget but leading in PRs (9) and commits (22). Healthy pattern.
- **High usage, low output**: Charlie — 97% budget for only 3 PRs. Likely deep exploration or prompt iteration. Worth a check-in — could be working on a complex feature or struggling with prompts.
- **Zero usage**: Eve — 2 PRs shipped without AI tools. Ask in 1:1: tooling blockers? preference? doesn't know how to start?
- **Balanced**: Alice, Bob — moderate usage, proportional output

### Weekly Activity

```
Alice    ████████████░░░░░░░░  64%  PRs: 7   feat: billing webhook, fix: rate limiter
Bob      ███████░░░░░░░░░░░░░  36%  PRs: 4   refactor: user service
Charlie  ███████████████████░  97%  PRs: 3   feat: SSO integration (complex)
Diana    ███░░░░░░░░░░░░░░░░░  18%  PRs: 5   fix: 3 bugs, feat: export CSV
Eve      ░░░░░░░░░░░░░░░░░░░░   0%  PRs: 2   docs: API guide, chore: deps
Frank    ████████████████░░░░  82%  PRs: 9   feat: dashboard, test: 4 modules
```

### Trends (4-week rolling)

| Member  | W11    | W12    | W13    | W14    | Trend     |
|---------|--------|--------|--------|--------|-----------|
| Alice   | 280K   | 310K   | 290K   | 320K   | stable    |
| Bob     | 150K   | 200K   | 160K   | 180K   | stable    |
| Charlie | 120K   | 180K   | 350K   | 485K   | rising    |
| Diana   | 80K    | 95K    | 88K    | 92K    | stable    |
| Eve     | 30K    | 10K    | 5K     | 0      | declining |
| Frank   | 300K   | 350K   | 380K   | 410K   | rising    |

### Action Items

- [ ] 1:1 with Charlie — understand the spike. If it's SSO complexity, that's fine. If it's prompt struggles, offer pairing.
- [ ] 1:1 with Eve — check adoption blockers. Share Frank's workflow as example.
- [ ] Celebrate Frank — highest output, healthy token/PR ratio. Ask to share prompts with team.
