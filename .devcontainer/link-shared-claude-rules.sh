#!/usr/bin/env bash
# Runs in the container (postCreateCommand). Links the read-only shared rules
# into Claude's config folder. Never replaces a real file the user made there.
set -euo pipefail

shared_folder="$HOME/.claude-shared"
config_folder="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"

link_unless_real_file() {
  local name="$1"
  if [ -e "$config_folder/$name" ] && [ ! -L "$config_folder/$name" ]; then
    echo "Keeping existing $config_folder/$name; not linking the shared one."
    return
  fi
  ln -sfn "$shared_folder/$name" "$config_folder/$name"
}

link_unless_real_file CLAUDE.md
