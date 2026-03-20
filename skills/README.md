# Skills (Slash Commands)

Claude Code skills are markdown files that define structured workflows invoked via `/command-name`. They give Claude a clear process to follow instead of improvising.

## Available Skills

| Skill | What It Does | Complexity |
|-------|-------------|------------|
| `/investigate` | Structured debugging with 3-attempt limit | Low — works anywhere |
| `/dead-code` | Multi-strategy unused code scanner | Low — works anywhere |
| `/health-check` | Repo health dashboard (deps, lint, tests, CI, secrets) | Medium — needs customization |
| `/delegate` | Dispatch subtasks to multiple AI agents in parallel | Medium — agent setup needed |
| `/retro` | Data-driven sprint retrospective from git/PR metrics | Medium — needs baselines |

## Setup

1. Copy skills to your project:
   ```bash
   mkdir -p .claude/commands
   cp skills/*.md .claude/commands/
   ```

2. They'll appear as `/investigate`, `/dead-code`, etc. in Claude Code.

## Customization

### health-check.md

Edit the Configuration section at the top to match your project's package managers, CI system, and module layout.

### retro.md

Set your team's baseline metrics in the Configuration block. These are used to flag deviations:
- `BASELINE_PRS_PER_WEEK` — total PRs merged per week
- `BASELINE_P90_CYCLE_DAYS` — p90 PR cycle time
- `BASELINE_REVIEW_COVERAGE_PCT` — % of PRs with at least one review

### delegate.md

Update the agent table in Step 3 to match your available CLI tools and their flags.

## How Skills Cross-Reference Each Other

```
              ┌──────────────┐
              │  /delegate   │  ← orchestrator
              └──────┬───────┘
                     │
        ┌────────────┼────────────┐
        ▼            ▼            ▼
 ┌────────────┐ ┌──────────┐ ┌──────────┐
 │/investigate│ │/dead-code│ │  (your   │
 │  (debug)   │ │ (unused) │ │  skills) │
 └────────────┘ └──────────┘ └──────────┘

 ┌──────────────┐    ┌──────────────┐
 │ /health-check│    │    /retro    │
 │ (repo infra) │    │ (team perf)  │
 └──────────────┘    └──────────────┘
```

Each skill has a "Related Skills" table at the bottom to help Claude pick the right tool.
