# AGENTS.md — Handover for Your AI Agent

You are an AI coding agent. Your user is a tech lead who cloned this repo to set up Claude Code as a team management tool. This file tells you how to use this repo to generate a customized setup for their project.

## What This Repo Is

A cookbook of Claude Code hooks, skills (slash commands), and templates for engineering leads. Everything here is a **starting point** — you need to adapt it to the user's team, stack, and workflow.

## How to Use This Repo

### Step 1: Understand the User's Context

Before generating anything, ask the user for:

| Info Needed | Why | Example |
|-------------|-----|---------|
| Team size & names | Skills reference team members | 6 engineers (3 BE, 2 FE, 1 fullstack) |
| GitHub org/repo | PR metrics, CI checks | `acme-corp/api-server` |
| Stack | Health check, dead-code tools differ by stack | Django + React, Go + Vue, Rails + Next.js |
| Package managers | Health check deps scan | poetry, pnpm, npm, pip |
| CI system | Health check CI status | GitHub Actions, Cloud Build, GitLab CI |
| Sprint cadence | Retro date range defaults | 2 weeks, 1 week |
| Branching model | Guard hook protected branches | main+develop, trunk-based |
| Submodules? | Guard hook allows scoped git clean | yes: backend, frontend |
| Compliance scope? | Retro security section, SAST/secrets tools | ISO 27001, SOC 2, none |
| SAST tool | Retro compliance scan | bandit, semgrep, sonarqube, none |

### Step 2: Copy and Customize

#### Required (do these first)

1. **Hooks** — copy `hooks/*.sh` to the user's `.claude/hooks/` and make executable:
   ```bash
   mkdir -p .claude/hooks .claude/commands
   cp techlead-stack/hooks/*.sh .claude/hooks/
   chmod +x .claude/hooks/*.sh
   ```

2. **Settings** — merge `config/settings.json` into the user's `.claude/settings.json`. Keep existing permissions, add the hooks and deny rules.

3. **Guard hook** — edit `.claude/hooks/guard.sh` line 16:
   ```bash
   SUBMODULE_DIRS="backend frontend"  # ← change to user's directories
   ```

#### Choose Your Skills

Not every team needs every skill. Here's how to decide:

| Skill | Install if... | Skip if... |
|-------|--------------|------------|
| `/investigate` | Team debugs production issues | Team only does greenfield |
| `/dead-code` | Codebase is >1 year old | Brand new project |
| `/health-check` | Multiple modules, CI pipelines | Single-file projects |
| `/delegate` | Using multiple AI agents | Only using Claude Code |
| `/retro` | Running sprint retros | No regular retrospectives |

Copy chosen skills:
```bash
cp techlead-stack/skills/investigate.md .claude/commands/
cp techlead-stack/skills/health-check.md .claude/commands/
# ... etc
```

#### Templates Need Customization

Templates in `templates/` are **skeletons with placeholders**. They won't work until customized:

| Template | What to Fill In |
|----------|----------------|
| `pr-metrics.md` | Baseline numbers (PRs/week, cycle time, review coverage) |
| `1on1-prep.md` | Team roster, GitHub usernames, data paths |
| `token-usage.md` | Token budget, tracking file location, team member list |
| `team-knowledge-base.md` | Shared prompts directory, contribution workflow |

To customize a template:
1. Copy it to `.claude/commands/`
2. Read the `# ── Customize ──` blocks
3. Replace placeholders with the user's actual values
4. Optionally rename (e.g., `1on1-prep.md` → `1on1.md`)

### Step 3: Set Up Data Collection

The metrics skills need data. Set up these directories:

```bash
mkdir -p raw-data/git-logs raw-data/retros raw-data/token-logs .local/stakeholder
```

- `raw-data/git-logs/` — PR metrics output (JSON/TSV)
- `raw-data/retros/` — sprint retro reports
- `raw-data/token-logs/` — AI token usage per person per week
- `.local/stakeholder/` — per-member profiles and 1on1 prep docs (gitignored)

Add to `.gitignore`:
```
.local/
```

### Step 4: Generate Team Profiles (for 1on1-prep)

For each team member, create `.local/stakeholder/<name>/README.md`:

```markdown
---
name: Alice Chen
role: Backend Engineer
github: alicechen
joined: 2024-06
---

## Baseline (6-month)
- PRs merged: ~40
- Median cycle: 2.5d
- Primary areas: billing, auth

## Notes
- Interested in system design
- Prefers async code review
```

The `/1on1-prep` skill reads these profiles to personalize prep docs.

## Key Concepts to Explain to Your User

### 1. Token Usage as a KPI

AI token consumption should be tracked alongside traditional metrics (PRs, commits, cycle time). High token usage without corresponding output is like high "lines of code" without value — the old joke. The `token-usage` template helps track this ratio.

**Healthy signal**: token usage correlates with PR throughput
**Warning signal**: high tokens, low PRs (prompt thrashing, not shipping)

### 2. 1-on-1 = Data-Driven Coaching

The `/1on1-prep` template replaces gut feelings with data:
- Weekly activity charts show effort distribution
- Cycle time comparisons surface bottlenecks
- Zero-review rates flag quality risks
- Token/PR ratio shows AI tool effectiveness

The goal is **not surveillance** — it's giving the tech lead objective talking points so 1-on-1s focus on growth, not guesswork.

### 3. Shared Knowledge Compounds

Prompts, plans, and skills are **team domain knowledge**. When one person discovers a great debugging prompt or a reliable deployment checklist, the whole team should benefit. The `team-knowledge-base` template sets up a shared directory where the team contributes and iterates on prompts together.

## File Map

```
techlead-stack/
├── AGENTS.md              ← you are here
├── README.md              ← human-readable overview
├── config/
│   └── settings.json      ← hooks + deny rules
├── hooks/
│   ├── guard.sh           ← blocks destructive commands
│   ├── audit-log.sh       ← logs all bash commands
│   └── notify.sh          ← desktop notification on finish
├── skills/
│   ├── investigate.md     ← structured debugging (3-attempt limit)
│   ├── dead-code.md       ← unused code scanner
│   ├── health-check.md    ← repo health dashboard
│   ├── delegate.md        ← multi-agent task dispatch
│   └── retro.md           ← sprint retrospective
├── templates/
│   ├── pr-metrics.md      ← PR cycle time analysis
│   ├── 1on1-prep.md       ← 1-on-1 meeting prep
│   ├── token-usage.md     ← AI token tracking
│   └── team-knowledge-base.md ← shared prompts/plans
└── examples/
    ├── token-usage-report.md      ← sample output
    ├── pr-metrics-output.md       ← sample output
    ├── 1on1-prep-output.md        ← sample output
    ├── retro-output.md            ← sample output
    └── health-check-output.md     ← sample output
```

## Rules for You (the Agent)

1. **Never copy company-specific data** — examples in `examples/` use dummy data
2. **Always ask before overwriting** — the user may have existing `.claude/` config
3. **Merge, don't replace** — settings.json should be merged, not overwritten
4. **Customize baselines** — every team is different, don't use the defaults blindly
5. **Start small** — install hooks + 2-3 skills first, add more as the team matures
