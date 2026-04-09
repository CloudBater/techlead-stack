#!/usr/bin/env bash
# Collect Claude Code token usage per user from session files.
#
# Claude Code stores session data in ~/.claude/projects/*/sessions/
# Each session has a JSON file with token counts.
#
# Usage:
#   ./scripts/token-usage.sh                    # this week, all users
#   ./scripts/token-usage.sh --since "7 days ago"
#   ./scripts/token-usage.sh --user alice
#
# Output: TSV to stdout (pipe to file or use in skills)
#
# Note: This only works for users who run Claude Code on the same machine.
# For team-wide tracking across machines, you need one of:
#   - API proxy with usage logging (recommended for teams)
#   - Each user runs this script and pushes to shared repo
#   - Anthropic Console usage export (manual, org-level)

set -euo pipefail

SINCE="${SINCE:-7 days ago}"
USER_FILTER=""

while [[ $# -gt 0 ]]; do
  case $1 in
    --since) SINCE="$2"; shift 2 ;;
    --user) USER_FILTER="$2"; shift 2 ;;
    *) echo "Unknown arg: $1" >&2; exit 1 ;;
  esac
done

SINCE_TS=$(date -j -f "%Y-%m-%d" "$(date -v-7d '+%Y-%m-%d')" "+%s" 2>/dev/null || date -d "$SINCE" "+%s" 2>/dev/null || echo "0")

CLAUDE_DIR="${HOME}/.claude"

if [ ! -d "$CLAUDE_DIR" ]; then
  echo "Claude Code directory not found at $CLAUDE_DIR" >&2
  exit 1
fi

echo -e "user\tdate\tsession_id\tinput_tokens\toutput_tokens\ttotal_tokens"

# Find session files modified since the cutoff
find "$CLAUDE_DIR/projects" -name "*.json" -newer /tmp/.token_usage_marker 2>/dev/null | while read -r session_file; do
  # Extract token usage from session JSON
  python3 -c "
import json, sys, os
from datetime import datetime

try:
    with open('$session_file') as f:
        data = json.load(f)

    # Session files vary in format — try common structures
    input_tokens = data.get('inputTokens', data.get('input_tokens', 0))
    output_tokens = data.get('outputTokens', data.get('output_tokens', 0))
    total = input_tokens + output_tokens

    if total == 0:
        sys.exit(0)

    # Get modification time as date
    mtime = os.path.getmtime('$session_file')
    date_str = datetime.fromtimestamp(mtime).strftime('%Y-%m-%d')

    # Session ID from filename
    session_id = os.path.basename('$session_file').replace('.json', '')

    # User from parent directory structure or system user
    user = os.environ.get('USER', 'unknown')

    print(f'{user}\t{date_str}\t{session_id}\t{input_tokens}\t{output_tokens}\t{total}')
except (json.JSONDecodeError, KeyError, TypeError):
    pass
" 2>/dev/null
done

# If no session files found, print a helpful message
if [ ! -f /tmp/.token_usage_marker ]; then
  touch -t "$(date -v-7d '+%Y%m%d%H%M')" /tmp/.token_usage_marker 2>/dev/null || \
  touch -d "$SINCE" /tmp/.token_usage_marker 2>/dev/null
fi
