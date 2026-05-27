#!/usr/bin/env bash

# Paste emoji into blog post
# Workflow:
#   - Standard emoji: select/highlight :shortcode: in helix, run script (outputs <Emoji name=":shortcode:" />)
#   - Discord emoji: select alt text in helix, copy emoji URL to clipboard, run script (outputs <Emoji src="..." alt="..." />)
# Usage: ./paste-emoji.sh "alt text"
# Or: select text and run via C-e in Helix

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ALT=""
EMOJI_URL=""

# Parse selected text from argument or stdin (run this first so shortcodes don't need clipboard)
if [ $# -ge 1 ] && [ -n "$1" ]; then
    ALT="$1"
elif [ ! -t 0 ]; then
    ALT=$(cat | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
fi

# If selected text is a shortcode (:word:), emit name-based Emoji (no clipboard needed)
if [[ "$ALT" =~ ^:[a-zA-Z0-9_+-]+:$ ]]; then
    echo "<Emoji name=\"${ALT}\" />"
    exit 0
fi

# Otherwise treat clipboard as Discord emoji URL and selected text as alt
# Detect clipboard tool
if command -v wl-paste &> /dev/null && [ -n "${WAYLAND_DISPLAY:-}" ]; then
    CLIPBOARD_TOOL="wl-clipboard"
elif command -v xclip &> /dev/null && [ -n "${DISPLAY:-}" ]; then
    CLIPBOARD_TOOL="xclip"
else
    echo "Error: No clipboard tool found" >&2
    exit 1
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
