#!/usr/bin/env bash
# Safety guardrail hook — intercepts destructive commands before execution.
# Runs as a PreToolUse hook on Bash tool calls.
# Exit 2 = block with message, Exit 0 = allow
#
# Inspired by gstack (Garry Tan) `/careful` concept and
# trailofbits/claude-code-config deny patterns.

set -euo pipefail

# ── Configure for your project ──────────────────────────────────────
# Add your submodule or subdirectory names here.
# Commands like `cd backend && git clean -fd` will be allowed
# while bare `git clean -fd` at the root will be blocked.
SUBMODULE_DIRS="backend frontend"
# ────────────────────────────────────────────────────────────────────

INPUT=$(cat)

TOOL_NAME=$(echo "$INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('tool_name',''))" 2>/dev/null)

# Only check Bash calls
if [ "$TOOL_NAME" != "Bash" ]; then
  exit 0
fi

COMMAND=$(echo "$INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('tool_input',{}).get('command',''))" 2>/dev/null)

# Build submodule regex pattern: (backend|frontend|...)
SUBMODULE_PATTERN=$(echo "$SUBMODULE_DIRS" | tr ' ' '|')

BLOCKED=""

# Force push (any branch)
if echo "$COMMAND" | grep -qE 'git\s+push\s+.*--force|git\s+push\s+-f\b'; then
  BLOCKED="git push --force detected. This can overwrite remote history."
fi

# Push to protected branches
if echo "$COMMAND" | grep -qE 'git\s+push\s+.*(main|master|develop)\b'; then
  BLOCKED="Pushing directly to protected branch (main/master/develop)."
fi

# git reset --hard
if echo "$COMMAND" | grep -qE 'git\s+reset\s+--hard'; then
  BLOCKED="git reset --hard discards all uncommitted changes irreversibly."
fi

# git clean -f (without dry-run) — allow in submodule context
if echo "$COMMAND" | grep -qE 'git\s+clean\s+-[a-zA-Z]*f' && ! echo "$COMMAND" | grep -qE 'git\s+clean\s+-[a-zA-Z]*n'; then
  if ! echo "$COMMAND" | grep -qE "cd\s+($SUBMODULE_PATTERN)\s+&&\s+.*git\s+clean"; then
    BLOCKED="git clean -f deletes untracked files permanently."
  fi
fi

# rm -rf on broad paths
if echo "$COMMAND" | grep -qE 'rm\s+-[a-zA-Z]*r[a-zA-Z]*f?\s+(/|~|\.\.|\./)' || echo "$COMMAND" | grep -qE 'rm\s+-[a-zA-Z]*f[a-zA-Z]*r?\s+(/|~|\.\.|\./)'; then
  BLOCKED="rm -rf on broad path detected. Verify the target path is correct."
fi

# DROP TABLE / DROP DATABASE — skip git commands (commit messages may mention SQL keywords)
if echo "$COMMAND" | grep -qiE 'DROP\s+(TABLE|DATABASE|SCHEMA)'; then
  if ! echo "$COMMAND" | grep -qE '^git\s'; then
    BLOCKED="SQL DROP statement detected. This is irreversible in production."
  fi
fi

# kubectl delete without dry-run
if echo "$COMMAND" | grep -qE 'kubectl\s+delete\s+(namespace|deployment|service|pod)' && ! echo "$COMMAND" | grep -qE -- '--dry-run'; then
  BLOCKED="kubectl delete without --dry-run. Verify this targets the correct cluster/namespace."
fi

# docker system prune
if echo "$COMMAND" | grep -qE 'docker\s+system\s+prune'; then
  BLOCKED="docker system prune removes all unused data. Use targeted cleanup instead."
fi

# gcloud destructive operations
if echo "$COMMAND" | grep -qE 'gcloud\s+.*(delete|destroy|remove)\b' && ! echo "$COMMAND" | grep -qE -- '--dry-run'; then
  BLOCKED="gcloud destructive operation detected. Verify project and resource."
fi

# git checkout -- . (discard all changes) — allow in submodule context
if echo "$COMMAND" | grep -qE 'git\s+checkout\s+--\s+\.'; then
  if ! echo "$COMMAND" | grep -qE "cd\s+($SUBMODULE_PATTERN)\s+&&\s+.*git\s+checkout\s+--\s+\."; then
    BLOCKED="git checkout -- . discards all uncommitted changes in the working directory."
  fi
fi

# git branch -D (force delete)
if echo "$COMMAND" | grep -qE 'git\s+branch\s+-D'; then
  BLOCKED="git branch -D force-deletes a branch even if unmerged."
fi

if [ -n "$BLOCKED" ]; then
  echo "BLOCKED by safety guard: $BLOCKED" >&2
  exit 2
fi

exit 0
