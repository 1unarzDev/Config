#!/usr/bin/env bash
# Usage: ./apply_pywal_template.sh in_file out_file

set -e

if [ $# -lt 2 ]; then
  echo "Usage: $0 in_file out_file"
  exit 1
fi

TEMPLATE="$1"
OUT="$2"
PYWAL_DIR="$HOME/.cache/wal"
COLORS_FILE="$PYWAL_DIR/colors"

if [ ! -f "$COLORS_FILE" ]; then
  echo "Pywal colors file not found at $COLORS_FILE"
  exit 1
fi

# Load pywal colors
mapfile -t COLORS < "$COLORS_FILE"

NORMAL="${COLORS[7]}"
CANDIDATE="${COLORS[0]}"
HIGHLIGHT="${COLORS[4]}"
HIGHLIGHT_BACKGROUND="${COLORS[1]}"
HIGHLIGHT_ALT="${COLORS[5]}"

# Substitute placeholders in template
sed \
  -e "s/{NORMAL}/$NORMAL/g" \
  -e "s/{CANDIDATE}/$CANDIDATE/g" \
  -e "s/{HIGHLIGHT}/$HIGHLIGHT/g" \
  -e "s/{HIGHLIGHT_BACKGROUND}/$HIGHLIGHT_BACKGROUND/g" \
  -e "s/{HIGHLIGHT_ALT}/$HIGHLIGHT_ALT/g" \
  "$TEMPLATE" > "$OUT"

fcitx5 -r &
