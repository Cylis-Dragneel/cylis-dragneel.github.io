#!/usr/bin/env bash

# Paste Discord emoji into blog post
# Usage: echo "alt|https://..." | ./paste-emoji.sh
# Or:   ./paste-emoji.sh "alt" "https://..."

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ALT=""
EMOJI_URL=""

# Parse arguments or stdin
if [ $# -ge 2 ] && [ -n "$1" ] && [ -n "$2" ]; then
    ALT="$1"
    EMOJI_URL="$2"
elif [ $# -ge 1 ] && [ -n "$1" ]; then
    # Single argument - treat as alt, prompt for URL
    ALT="$1"
    echo -n "Emoji URL: " >&2
    read -r EMOJI_URL
elif [ ! -t 0 ]; then
    INPUT=$(cat)
    if [[ "$INPUT" == *"|"* ]]; then
        ALT=$(echo "$INPUT" | cut -d'|' -f1 | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
        EMOJI_URL=$(echo "$INPUT" | cut -d'|' -f2- | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    else
        ALT=$(echo "$INPUT" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
        echo -n "Emoji URL: " >&2
        read -r EMOJI_URL
    fi
else
    echo "Usage: alt|https://emoji.url or pass alt and url as arguments" >&2
    exit 1
fi

[ -z "$ALT" ] && ALT="emoji"
[ -z "$EMOJI_URL" ] && { echo "Error: Emoji URL is required" >&2; exit 1; }

echo "<Emoji src=\"${EMOJI_URL}\" alt=\"${ALT}\" />"
