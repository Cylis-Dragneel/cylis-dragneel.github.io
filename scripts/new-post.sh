#!/usr/bin/env bash
set -euo pipefail

# Usage: ./scripts/new-post.sh "My Post Title" [--draft] [--tags "Tag1,Tag2"]
# Creates a new MDX blog post with today's date

if [ $# -lt 1 ]; then
  echo "Usage: $0 \"Post Title\" [--draft] [--tags \"Tag1,Tag2\"] [--summary \"Brief description\"]"
  exit 1
fi

TITLE="$1"
shift

DRAFT="false"
TAGS='["General"]'
SUMMARY=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --draft)
      DRAFT="true"
      shift
      ;;
    --tags)
      # Convert comma-separated tags to JSON array
      IFS=',' read -ra TAG_ARRAY <<< "$2"
      TAGS="["
      for i in "${!TAG_ARRAY[@]}"; do
        TAG=$(echo "${TAG_ARRAY[$i]}" | xargs) # trim whitespace
        if [ "$i" -gt 0 ]; then
          TAGS+=", "
        fi
        TAGS+="\"$TAG\""
      done
      TAGS+="]"
      shift 2
      ;;
    --summary)
      SUMMARY="$2"
      shift 2
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
done

# Generate slug from title
SLUG=$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-//;s/-$//')

# Get today's date
DATE=$(date +%Y-%m-%d)

# Set default summary if not provided
if [ -z "$SUMMARY" ]; then
  SUMMARY="$TITLE"
fi

# File path
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
FILE_PATH="$PROJECT_DIR/src/content/blog/${SLUG}.mdx"

# Check if file already exists
if [ -f "$FILE_PATH" ]; then
  echo "Error: Post already exists at $FILE_PATH"
  exit 1
fi

# Create the post
cat > "$FILE_PATH" << EOF
---
title: "$TITLE"
date: $DATE
author: "Cylis"
summary: "$SUMMARY"
tags: $TAGS
draft: $DRAFT
---

import Spoiler from "../../components/blog/Spoiler.astro";
import Image from "../../components/blog/Image.astro";
import Callout from "../../components/blog/Callout.astro";

# $TITLE

EOF

echo "Created: $FILE_PATH"
echo "  Title: $TITLE"
echo "  Date:  $DATE"
echo "  Tags:  $TAGS"
echo "  Draft: $DRAFT"
