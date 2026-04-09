# techlead-stack

Claude Code hooks and slash commands for engineering leads. A battle-tested collection of safety guardrails, debugging workflows, team analytics, and multi-agent delegation patterns.

Built from daily use managing a 6-person team shipping a full-stack product (Django + React). No frameworks, no npm packages — just markdown files and shell scripts you copy into `.claude/`.

> **AI agent?** Read [`AGENTS.md`](AGENTS.md) — it tells your agent how to customize this repo for your team.

## Why This Exists

In 2024, AI coding tools were individual productivity boosters. In 2025, they're team infrastructure. The tech lead's job changed: you now manage **token budgets**, **prompt quality**, and **AI tool adoption** alongside the usual PRs, sprints, and architecture.

This repo gives you the skills to do that with Claude Code.

> **The maturity path**: `ad-hoc prompt → shared prompt → team skill → CLAUDE.md convention`

## The 3 Ideas

### 1. Token Usage is a KPI

Your team's AI token consumption should be tracked alongside PRs, commits, and cycle time. High tokens without output is the new "lines of code" joke. Low tokens means your team isn't adopting the tool. Track the ratio — that's the signal.

See: [`templates/token-usage.md`](templates/token-usage.md) | [`examples/token-usage-report.md`](examples/token-usage-report.md)

### 2. 1-on-1 Should Be Data, Not Vibes

Replace gut feelings with weekly activity charts, cycle time comparisons, and token/PR ratios. The goal isn't surveillance — it's giving you objective talking points so 1-on-1s focus on coaching, not guessing.

See: [`templates/1on1-prep.md`](templates/1on1-prep.md) | [`examples/1on1-prep-output.md`](examples/1on1-prep-output.md)

### 3. Shared Prompts are Team Knowledge

When one developer discovers a reliable prompt, the whole team should benefit. Prompts, plans, and skills are domain knowledge — collect them, iterate together, and watch the maturity path unfold: ad-hoc prompt → shared template → team skill → project convention.

See: [`templates/team-knowledge-base.md`](templates/team-knowledge-base.md)

## What's Inside

### Hooks (`.claude/hooks/`)

Safety and observability layers that run automatically:

| Hook | Event | What It Does |
|------|-------|-------------|
| [`guard.sh`](hooks/guard.sh) | PreToolUse | Blocks destructive commands (force push, `rm -rf`, `DROP TABLE`, `kubectl delete`) |
| [`audit-log.sh`](hooks/audit-log.sh) | PostToolUse | Logs every Bash command to a local audit trail |
| [`notify.sh`](hooks/notify.sh) | Stop | macOS desktop notification when Claude finishes |

### Skills (`.claude/commands/`)

Slash commands for daily tech lead workflows:

| Skill | What It Does |
|-------|-------------|
| [`/investigate`](skills/investigate.md) | Structured debugging with 3-attempt limit and escalation protocol |
| [`/dead-code`](skills/dead-code.md) | Multi-strategy unused code scanner (ruff, vulture, ts-prune) |
| [`/health-check`](skills/health-check.md) | Repo health dashboard — deps, lint, tests, CI, secrets |
| [`/delegate`](skills/delegate.md) | Dispatch subtasks to multiple AI agents in parallel |
| [`/retro`](skills/retro.md) | Data-driven sprint retrospective from git and PR metrics |

### Templates (need customization)

Skeletons with placeholders — copy to `.claude/commands/` and fill in your team's values:

| Template | What It Does |
|----------|-------------|
| [`pr-metrics`](templates/pr-metrics.md) | PR cycle time, review coverage, per-person breakdown |
| [`1on1-prep`](templates/1on1-prep.md) | 1-on-1 meeting material from PR/commit activity |
| [`token-usage`](templates/token-usage.md) | AI token consumption tracking and efficiency ratios |
| [`team-knowledge-base`](templates/team-knowledge-base.md) | Shared prompts, plans, and playbooks across the team |

### Examples (dummy data)

Sample outputs showing what each skill produces — no real company data:

| Example | Shows |
|---------|-------|
| [`token-usage-report`](examples/token-usage-report.md) | Weekly token/PR ratio per member, signals, trends |
| [`pr-metrics-output`](examples/pr-metrics-output.md) | 6-month PR analysis with per-person breakdown |
| [`1on1-prep-output`](examples/1on1-prep-output.md) | Full 1-on-1 prep doc with activity chart and talking points |
| [`retro-output`](examples/retro-output.md) | Sprint retro with scoreboard, trends, and action items |
| [`health-check-output`](examples/health-check-output.md) | Repo health dashboard with dependency and CI status |

### Scripts

| Script | What It Does |
|--------|-------------|
| [`token-usage.sh`](scripts/token-usage.sh) | Collect Claude Code token usage from local session files |

### Config

| File | What It Does |
|------|-------------|
| [`settings.json`](config/settings.json) | Hooks wiring + credential deny rules |

## Quick Start

```bash
# 1. Clone
git clone https://github.com/CloudBater/techlead-stack.git

# 2. Copy hooks and skills into your project
mkdir -p .claude/hooks .claude/commands
cp techlead-stack/hooks/*.sh .claude/hooks/
cp techlead-stack/skills/*.md .claude/commands/
chmod +x .claude/hooks/*.sh

# 3. Merge settings into your .claude/settings.json
# (see config/settings.json for the full example)

# 4. Customize templates
cp techlead-stack/templates/token-usage.md .claude/commands/
cp techlead-stack/templates/1on1-prep.md .claude/commands/
# Edit the "Customize for your team" blocks in each file

# 5. Set up data directories
mkdir -p raw-data/git-logs raw-data/retros raw-data/token-logs .local/stakeholder
echo ".local/" >> .gitignore
```

Or let your AI agent do it: paste [`AGENTS.md`](AGENTS.md) into your conversation and say "set up techlead-stack for my project".

## Design Philosophy

- **Data over opinions** — every observation cites a specific metric or commit
- **Read-only by default** — scanners don't modify, investigations revert failed attempts
- **Fail gracefully** — missing tools are noted, not crashed on
- **Human in the loop** — delegation asks before dispatching, dead-code asks before deleting
- **Deterministic safety** — hooks enforce rules regardless of LLM context pressure

## How Skills Cross-Reference Each Other

```
              ┌──────────────┐
              │  /delegate   │  ← orchestrator, dispatches work
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

 Templates:
 /pr-metrics ──→ feeds into /retro and /1on1-prep
 /token-usage ──→ feeds into /1on1-prep and /retro
 /team-knowledge-base ──→ collects prompts from all skills

 Hooks: guard.sh ──→ audit-log.sh ──→ notify.sh
        (before)      (after)          (done)
```

## Credits & Inspiration

| Project | Author | What We Learned |
|---------|--------|----------------|
| [gstack](https://github.com/garrytan/gstack) | Garry Tan | Sprint workflow, safety guardrails (`/careful`), structured debugging, retrospectives |
| [claude-code-config](https://github.com/trailofbits/claude-code-config) | Trail of Bits | Credential deny rules, bash audit logging, hook architecture |
| [claude-hooks](https://github.com/decider/claude-hooks) | decider | Code quality validation patterns |
| [Claude-Command-Suite](https://github.com/qdhenry/Claude-Command-Suite) | qdhenry | Health check and dead-code scanning concepts |
| [claude-code-hooks-mastery](https://github.com/disler/claude-code-hooks-mastery) | disler | Notification hook, comprehensive hook event catalog |

## License

MIT
