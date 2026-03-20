#!/usr/bin/env bash
# Bash command audit logger — logs every Bash command Claude executes.
# Runs as a PostToolUse hook on Bash calls.
# Log file: .local/claude-audit.log (gitignored, local only)
#
# Inspired by trailofbits/claude-code-config (bash command logging).

set -euo pipefail

INPUT=$(cat)

TOOL_NAME=$(echo "$INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('tool_name',''))" 2>/dev/null)

# Only log Bash calls
if [ "$TOOL_NAME" != "Bash" ]; then
  exit 0
fi

COMMAND=$(echo "$INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('tool_input',{}).get('command',''))" 2>/dev/null)

# Skip noisy read-only commands
case "$COMMAND" in
  ls*|cat*|head*|tail*|echo*|pwd) exit 0 ;;
esac

LOG_DIR="$(git rev-parse --show-toplevel 2>/dev/null || echo ".")/.local"
mkdir -p "$LOG_DIR"

TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
echo "[$TIMESTAMP] $COMMAND" >> "$LOG_DIR/claude-audit.log"

exit 0
