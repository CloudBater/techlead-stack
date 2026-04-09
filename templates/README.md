# Templates

These are **skeleton skills** that need customization before use. They demonstrate the pattern but contain placeholders you must fill in.

| Template | What It Does | What to Customize |
|----------|-------------|-------------------|
| `pr-metrics.md` | PR cycle time and review coverage analysis | Data source (script path or `gh` CLI), baseline numbers |
| `1on1-prep.md` | 1-on-1 meeting prep from PR/commit data | Team roster, data paths, previous notes location |
| `token-usage.md` | AI token consumption tracking per member | Team member list, token budget, log directory |
| `team-knowledge-base.md` | Shared prompts and plans across the team | Directory paths, contribution workflow |

## How to Use

1. Copy the template to `.claude/commands/`:
   ```bash
   cp templates/token-usage.md .claude/commands/token-usage.md
   ```

2. Edit the file and fill in your team-specific values (look for `# ── Customize ──` blocks).

3. The skill will appear as `/token-usage` in Claude Code.

## Templates vs Skills

**Skills** (in `skills/`) work out of the box with minimal configuration.

**Templates** (here) require you to fill in team-specific data before they're useful. They're designed as starting points that your agent can help you customize — see [`AGENTS.md`](../AGENTS.md).
