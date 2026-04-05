#!/bin/bash

# Setup script to install prompts to global workflows directory

set -e

# Determine the home directory
HOME_DIR="${HOME:-$(eval echo ~)}"
TARGET_DIR="$HOME_DIR/.gemini/antigravity/global_workflows"
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/prompts"

echo "Installing prompts to: $TARGET_DIR"

# Create target directory if it doesn't exist
mkdir -p "$TARGET_DIR"

# Copy all prompt files
cp "$SOURCE_DIR"/*.md "$TARGET_DIR/"

echo "✓ Prompts installed successfully"
echo "Copied files:"
ls -1 "$TARGET_DIR"/*.md | xargs -I {} basename {}
