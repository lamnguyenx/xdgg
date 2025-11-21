#!/bin/bash
set -Eeuo pipefail

# Archive existing config directory with timestamp

CONFIG_DIR="${1:?Config directory required}"
ARCHIVE_DIR="$HOME/.config/__archives__"

# Skip if path doesn't exist
if [ ! -e "$CONFIG_DIR" ]; then
    DISPLAY_DIR="${CONFIG_DIR//$HOME/~}"
    echo "Warning: $DISPLAY_DIR does not exist, skipping archive"
    exit 0
fi

# Skip if it's already a symlink
if [ -L "$CONFIG_DIR" ]; then
    DISPLAY_DIR="${CONFIG_DIR//$HOME/~}"
    echo "Info: $DISPLAY_DIR is already a symlink, skipping archive"
    exit 0
fi

# Create archive directory and archive with timestamp
mkdir -p "$ARCHIVE_DIR"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
mv "$CONFIG_DIR" "$ARCHIVE_DIR/$(basename "$CONFIG_DIR")--$TIMESTAMP.bk"
