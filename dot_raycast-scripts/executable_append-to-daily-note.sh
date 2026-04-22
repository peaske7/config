#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Append to Today's Note
# @raycast.mode compact

# Optional parameters:
# @raycast.icon ✏️
# @raycast.argument1 { "type": "text", "placeholder": "Note content", "optional": false }

# Documentation:
# @raycast.description Append text to today's daily note
# @raycast.author jay

# Get current date components
year=$(date +%Y)
month=$(date +%m)
day=$(date +%d)
time=$(date +%H:%M)

# Define paths
base_dir=~/Obsidian
note_path="${base_dir}/${year}/${month}/${day}.md"

# Create directory and file if needed
mkdir -p "${base_dir}/${year}/${month}"
touch "$note_path"

# Append with timestamp
echo "" >>"$note_path"
echo "- $1" >>"$note_path"

echo "Added to daily note"
