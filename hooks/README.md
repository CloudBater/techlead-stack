# Hooks

Claude Code hooks are shell scripts that run automatically at specific lifecycle events. They enforce rules **deterministically** — unlike system prompt instructions, hooks can't be forgotten or overridden by context pressure.

## Available Hooks

| Hook | Event | What It Does |
|------|-------|-------------|
| `guard.sh` | PreToolUse (Bash) | Blocks destructive commands before execution |
| `audit-log.sh` | PostToolUse (Bash) | Logs all Bash commands to `.local/claude-audit.log` |
| `notify.sh` | Stop | macOS desktop notification when Claude finishes |

## How Hooks Work

- **PreToolUse**: Runs before tool execution. Exit code `2` = block the action. Exit code `0` = allow.
- **PostToolUse**: Runs after tool completion. Cannot block (already executed). Use for logging/observation.
- **Stop**: Runs when Claude finishes responding. Exit code `2` = force Claude to continue.

## Setup

1. Copy hooks to your project:
   ```bash
   mkdir -p .claude/hooks
   cp hooks/*.sh .claude/hooks/
   chmod +x .claude/hooks/*.sh
   ```

2. Register in `.claude/settings.json` (see `config/settings.json` for the full example).

## Customization

### guard.sh

Edit the `SUBMODULE_DIRS` variable at the top to match your project structure:

```bash
SUBMODULE_DIRS="backend frontend services"
```

Commands like `cd backend && git clean -fd` will be allowed while bare `git clean -fd` at the root will be blocked.

### audit-log.sh

The `case` statement near the top skips noisy read-only commands. Add or remove patterns to control what gets logged.

### notify.sh

For Linux, replace the `osascript` line with:
```bash
notify-send "Claude Code" "Finished responding" 2>/dev/null || true
```
