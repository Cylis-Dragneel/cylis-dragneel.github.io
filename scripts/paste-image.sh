#!/usr/bin/env bash

# Paste image from clipboard into blog post
# Saves image to public/blog/img/ and outputs markdown syntax

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
IMG_DIR="$PROJECT_ROOT/public/blog/img"

# Parse arguments - read from stdin if no arg provided and stdin is not a tty
CUSTOM_FILENAME=""
DESCRIPTION=""

if [ $# -ge 1 ] && [ -n "$1" ]; then
    CUSTOM_FILENAME="$1"
elif [ ! -t 0 ]; then
    INPUT=$(cat)
    # Parse filename|Description format from stdin
    if [[ "$INPUT" == *"|"* ]]; then
        # Filename: lowercase + spaces to hyphens + trim
        CUSTOM_FILENAME=$(echo "$INPUT" | cut -d'|' -f1 | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | sed 's/^-+//;s/-$//' | tr -d '[:space:]')
        # Description: keep spaces, trim only leading/trailing
        DESCRIPTION=$(echo "$INPUT" | cut -d'|' -f2- | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    else
        CUSTOM_FILENAME=$(echo "$INPUT" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | sed 's/^-+//;s/-$//' | tr -d '[:space:]')
    fi
fi

if [ $# -ge 2 ] && [ -n "$2" ]; then
    DESCRIPTION="$2"
fi

mkdir -p "$IMG_DIR"

# Detect clipboard tool
if command -v wl-paste &> /dev/null && [ -n "${WAYLAND_DISPLAY:-}" ]; then
    CLIPBOARD_TOOL="wl-clipboard"
elif command -v xclip &> /dev/null && [ -n "${DISPLAY:-}" ]; then
    CLIPBOARD_TOOL="xclip"
else
    echo "Error: No clipboard tool found" >&2
    exit 1
fi

# Check if clipboard contains image
if [ "$CLIPBOARD_TOOL" = "wl-clipboard" ]; then
    wl-paste --list-types 2>/dev/null | grep -q "image/" || { echo "Error: No image in clipboard" >&2; exit 1; }
else
    xclip -selection clipboard -t TARGETS -o 2>/dev/null | grep -q "image/" || { echo "Error: No image in clipboard" >&2; exit 1; }
fi

# Generate filename
if [ -n "$CUSTOM_FILENAME" ]; then
    if [[ "$CUSTOM_FILENAME" == *.* ]]; then
        FILENAME="$CUSTOM_FILENAME"
    else
        FILENAME="${CUSTOM_FILENAME}.png"
    fi
else
    TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    FILENAME="paste_${TIMESTAMP}.png"
fi

[ -z "$DESCRIPTION" ] && DESCRIPTION="Description"

OUTPUT_PATH="$IMG_DIR/$FILENAME"

MD_SYNTAX="![${DESCRIPTION}](/blog/img/$FILENAME)"

# Save image from clipboard
if [ "$CLIPBOARD_TOOL" = "wl-clipboard" ]; then
    wl-paste --type image/png > "$OUTPUT_PATH"
    # echo "$MD_SYNTAX" | wl-copy
else
    xclip -selection clipboard -t image/png -o > "$OUTPUT_PATH"
    # echo "$MD_SYNTAX" | xclip -selection clipboard
fi

[ -f "$OUTPUT_PATH" ] || { echo "Error: Failed to save image" >&2; exit 1; }

echo "$MD_SYNTAX"
