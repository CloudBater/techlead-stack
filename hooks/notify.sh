#!/usr/bin/env bash
# macOS notification when Claude finishes a response.
# Runs as a Stop hook — fires when Claude finishes responding.
#
# Inspired by disler/claude-code-hooks-mastery (notification.py) and
# trailofbits/claude-code-config (osascript desktop notifications).
#
# For Linux, replace the osascript line with:
#   notify-send "Claude Code" "Finished responding" 2>/dev/null || true

set -euo pipefail

INPUT=$(cat)

# Send macOS notification
osascript -e 'display notification "Claude Code has finished its response." with title "Claude Code" sound name "Glass"' 2>/dev/null || true

exit 0
