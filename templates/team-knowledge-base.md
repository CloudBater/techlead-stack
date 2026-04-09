Set up and maintain a shared knowledge base of prompts, plans, and skills across the team.

## Input

$ARGUMENTS — action: `init`, `add <topic>`, `list`, `review`

## Configuration

```
# ── Customize for your team ──────────────────
KNOWLEDGE_DIR="shared-prompts"           # directory for shared prompts
PLANS_DIR="shared-prompts/plans"         # architecture decisions, design docs
SKILLS_DIR=".claude/commands"            # team-wide skills
CHANGELOG="shared-prompts/CHANGELOG.md"  # track contributions
# ──────────────────────────────────────────────
```

## Action: init

Create the shared knowledge directory structure:

```bash
mkdir -p shared-prompts/{prompts,plans,playbooks,snippets}
```

```
shared-prompts/
├── CHANGELOG.md          # who contributed what, when
├── prompts/              # reusable prompt templates
│   ├── code-review.md    # "review this PR for X, Y, Z"
│   ├── test-gen.md       # "write tests for this module"
│   └── migration.md      # "create a DB migration for..."
├── plans/                # architecture decisions
│   ├── api-redesign.md   # design doc for API v2
│   └── auth-flow.md      # SSO implementation plan
├── playbooks/            # step-by-step runbooks
│   ├── deploy.md         # production deployment checklist
│   ├── incident.md       # incident response steps
│   └── onboarding.md     # new developer setup
└── snippets/             # copy-paste code patterns
    ├── django-viewset.md # standard ViewSet template
    └── react-form.md     # form with validation pattern
```

## Action: add <topic>

When a team member discovers a useful prompt or pattern:

### 1. Capture the prompt

```markdown
---
title: {descriptive name}
author: {who discovered/wrote it}
date: {today}
tags: [debugging, django, performance]  # for searchability
---

## When to Use

{1-2 sentences: what situation triggers this prompt}

## The Prompt

```
{the actual prompt text, ready to copy-paste or use as a skill}
```

## Example

**Input**: {what the user provides}
**Output**: {what Claude produces}

## Notes

- {gotchas, edge cases, or tips}
- {what doesn't work and why}
```

### 2. Log the contribution

Append to `CHANGELOG.md`:

```markdown
- 2025-07-15 — alice added `prompts/perf-query.md` (Django ORM N+1 detection prompt)
```

### 3. Announce to team

Tell the user to share in the team channel. Visibility drives adoption.

## Action: list

Show all shared knowledge, grouped by category:

```bash
find shared-prompts -name "*.md" -not -name "CHANGELOG.md" | sort
```

Output as a table:

```markdown
| Category | File | Author | Tags |
|----------|------|--------|------|
| prompts | code-review.md | bob | review, quality |
| prompts | test-gen.md | alice | testing, pytest |
| plans | api-redesign.md | charlie | architecture |
| playbooks | deploy.md | diana | ops, production |
```

## Action: review

Audit the knowledge base for quality and freshness:

1. **Stale entries**: any file not updated in >3 months? Flag for review.
2. **Gaps**: which categories are empty? Suggest contributions.
3. **Duplicates**: similar prompts that should be merged.
4. **Adoption**: are people actually using these? Check git blame on skills.

## Why This Matters

### The Prompt is the New Skill

When a developer discovers that a specific prompt reliably produces good test code, that knowledge is as valuable as knowing a testing framework. Without sharing:
- 6 developers independently discover the same patterns
- Good prompts live in one person's head (bus factor = 1)
- New team members start from zero

With sharing:
- One discovery benefits everyone
- The team iterates and improves prompts together
- Onboarding includes "here are our best prompts for X"

### From Individual to Team Intelligence

```
Individual prompt → shared prompt → team skill → CLAUDE.md convention
```

The maturity path:
1. **Ad-hoc**: everyone writes their own prompts
2. **Shared**: best prompts collected in `shared-prompts/`
3. **Standardized**: proven prompts become `/skills` (slash commands)
4. **Embedded**: patterns baked into `CLAUDE.md` as project conventions

### Measuring Knowledge Sharing

Track in retros and 1-on-1s:
- How many shared prompts were added this sprint?
- Who contributed? (celebrate contributors)
- Which prompts are most used? (iterate on those)
- What gaps exist? (assign someone to fill them)

## Rules

1. **Low barrier to contribute** — a 3-line prompt with a title is better than nothing
2. **No gatekeeping** — anyone can add, the team reviews together
3. **Iterate, don't perfect** — v1 of a prompt is fine; improve it after use
4. **Credit the author** — recognition drives contribution
5. **Delete stale entries** — a prompt that no longer works is worse than no prompt
