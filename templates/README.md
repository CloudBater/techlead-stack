# Templates

These are **skeleton skills** that need customization before use. They demonstrate the pattern but contain placeholders you must fill in.

| Template | What It Does | What to Customize |
|----------|-------------|-------------------|
| `pr-metrics.md` | PR cycle time and review coverage analysis | Data source (script path or `gh` CLI), baseline numbers |
| `1on1-prep.md` | 1-on-1 meeting prep from PR/commit data | Team roster, data paths, previous notes location |

## How to Use

1. Copy the template to `.claude/commands/`:
   ```bash
   cp templates/pr-metrics.md .claude/commands/pr-metrics.md
   ```

2. Edit the file and fill in your team-specific values (baselines, paths, team member names).

3. The skill will appear as `/pr-metrics` in Claude Code.
