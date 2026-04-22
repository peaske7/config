#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Today's Note
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 📝

# Documentation:
# @raycast.description Open or create today's daily note in Obsidian
# @raycast.author jay

# Get current date components
year=$(date +%Y)
month=$(date +%m)
day=$(date +%d)

# Define paths
base_dir=~/Obsidian
vault_name=Obsidian

# Create directory structure if needed
mkdir -p "${base_dir}/${year}/${month}"

# Create daily note if it doesn't exist
touch "${base_dir}/${year}/${month}/${day}.md"

# Open in Obsidian
open "obsidian://open?vault=${vault_name}&file=${year}%2F${month}%2F${day}"
