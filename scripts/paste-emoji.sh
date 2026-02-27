#!/usr/bin/env bash

# Paste Discord emoji into blog post
# Workflow: Select alt text in helix, copy emoji URL to clipboard, run script
# Usage: ./paste-emoji.sh "alt text"
# Or: select text and run via C-e in Helix

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ALT=""
EMOJI_URL=""

# Detect clipboard tool
if command -v wl-paste &> /dev/null && [ -n "${WAYLAND_DISPLAY:-}" ]; then
    CLIPBOARD_TOOL="wl-clipboard"
elif command -v xclip &> /dev/null && [ -n "${DISPLAY:-}" ]; then
    CLIPBOARD_TOOL="xclip"
else
    echo "Error: No clipboard tool found" >&2
    exit 1
fi

# Parse alt from argument or stdin
if [ $# -ge 1 ] && [ -n "$1" ]; then
    ALT="$1"
elif [ ! -t 0 ]; then
    ALT=$(cat | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
fi

# Read URL from clipboard
if [ "$CLIPBOARD_TOOL" = "wl-clipboard" ]; then
    EMOJI_URL=$(wl-paste 2>/dev/null || true)
else
    EMOJI_URL=$(xclip -selection clipboard -o 2>/dev/null || true)
fi

[ -z "$EMOJI_URL" ] && { echo "Error: No URL in clipboard" >&2; exit 1; }
[ -z "$ALT" ] && ALT="emoji"

echo "<Emoji src=\"${EMOJI_URL}\" alt=\"${ALT}\" />"
