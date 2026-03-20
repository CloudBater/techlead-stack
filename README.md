# techlead-stack

Claude Code hooks and slash commands for engineering leads. A battle-tested collection of safety guardrails, debugging workflows, team analytics, and multi-agent delegation patterns.

Built from daily use managing a team shipping a full-stack product (Django + React). No frameworks, no npm packages — just markdown files and shell scripts you copy into `.claude/`.

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

### Templates

Skeletons to customize for your team:

| Template | What It Does |
|----------|-------------|
| [`pr-metrics`](templates/pr-metrics.md) | PR cycle time, review coverage, per-person breakdown |
| [`1on1-prep`](templates/1on1-prep.md) | 1-on-1 meeting material from PR/commit activity |

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

# 4. Customize
# - Edit guard.sh: set SUBMODULE_DIRS for your project
# - Edit health-check.md: set your package managers and CI system
# - Edit retro.md: set your team baseline metrics
```

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

 Hooks: guard.sh ──→ audit-log.sh ──→ notify.sh
        (before)      (after)          (done)
```

Each skill has a "Related Skills" table to help Claude pick the right tool for the job.

## Credits & Inspiration

This stack wouldn't exist without ideas from these open-source projects:

| Project | Author | What We Learned |
|---------|--------|----------------|
| [gstack](https://github.com/garrytan/gstack) | Garry Tan | Sprint workflow, safety guardrails (`/careful`), structured debugging, retrospectives |
| [claude-code-config](https://github.com/trailofbits/claude-code-config) | Trail of Bits | Credential deny rules, bash audit logging, hook architecture |
| [claude-hooks](https://github.com/decider/claude-hooks) | decider | Code quality validation patterns |
| [Claude-Command-Suite](https://github.com/qdhenry/Claude-Command-Suite) | qdhenry | Health check and dead-code scanning concepts |
| [claude-code-hooks-mastery](https://github.com/disler/claude-code-hooks-mastery) | disler | Notification hook, comprehensive hook event catalog |

## License

MIT
