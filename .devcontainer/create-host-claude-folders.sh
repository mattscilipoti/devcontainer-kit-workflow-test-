#!/usr/bin/env bash
# Runs on the HOST (devcontainer.json initializeCommand), before the container
# starts. A bind mount fails when its source folder is missing, so create them.
set -euo pipefail

root="$HOME/.claude-devcontainers"
project_folder="$root/workflow-test"
shared_folder="$root/shared"

mkdir -p "$project_folder" "$shared_folder"

[ -f "$project_folder/README.md" ] ||
  cp .devcontainer/claude-config-README.md "$project_folder/README.md"

[ -f "$shared_folder/CLAUDE.md" ] ||
  cp .devcontainer/shared-claude-rules-starter.md "$shared_folder/CLAUDE.md"
