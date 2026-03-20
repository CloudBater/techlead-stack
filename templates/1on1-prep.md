Prepare 1-on-1 meeting material for a team member using PR and commit activity data.

This is a **template** — adapt the data sources and paths to your project.

## Input

$ARGUMENTS — team member name or identifier (e.g., "alice", "bob")

## Instructions

1. **Find the member's GitHub username** from your team roster.

2. **Gather their PR data** for the last 6 months:

```bash
gh pr list --state merged --author <github-username> --limit 100 \
  --json number,title,createdAt,mergedAt,additions,deletions,reviews,headRefName
```

3. **Gather commit activity**:

```bash
git log --author="<name>" --oneline --no-merges --since="6 months ago" --format="%as" | sort | uniq -c
```

4. **Analyze**:
   - Total PRs, median cycle time, lines changed
   - Weekly activity breakdown (which weeks active/inactive)
   - PR categories (feat/fix/refactor counts from branch names or titles)
   - Zero-review rate vs team average
   - Largest PRs (by lines changed)
   - Slowest PRs (by cycle time) — what caused delays?
   - Key themes/projects worked on

5. **Read previous 1-on-1 notes** (if stored) to carry forward open topics.

6. **Write the prep document** with:

### Weekly Activity Chart

Use a visual bar chart showing activity per week:

```
W05 (Jan 26), PRs: 5  ██████████░░░░░░░░░░  Feature billing
W06 (Feb 02), PRs: 0  ░░░░░░░░░░░░░░░░░░░░  — inactive —
W07 (Feb 09), PRs: 3  ██████░░░░░░░░░░░░░░  Bug fixes
```

### Output Structure

```markdown
# 1-on-1 Prep — {name} — {date}

## 6-Month Summary

| Metric | Member | Team Avg |
|--------|--------|----------|
| PRs merged | N | N |
| Median cycle | Nd | Nd |
| Zero-review % | N% | N% |

## Weekly Activity

{visual chart}

## Key Contributions

- {grouped by theme/project}

## Talking Points

### Strengths to Recognize
- {specific data-backed strengths}

### Areas to Discuss
- {concerns backed by data, framed constructively}

### Growth Questions
- {open-ended questions for career development}

## Follow-ups from Last Session
- {carry forward from previous notes}
```

## Rules

1. **Data-backed** — every observation cites a specific metric
2. **Constructive tone** — this is meeting prep, not a performance review
3. **Concise** — keep it to one page of content the tech lead can scan in 5 minutes
