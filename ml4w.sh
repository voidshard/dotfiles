#!/usr/bin/env bash
set -euo pipefail

repo="https://github.com/yurihikari/ml4w-lightcrimson-dotfiles.git"
dest="${HOME}/.ml4w-lightcrimson-dotfiles"

echo "ml4w installer: cloning $repo into $dest"

if ! command -v git >/dev/null 2>&1; then
  echo "Error: git is required but not installed. Please install git and re-run." >&2
  exit 1
fi

# Clone or update
if [ -d "$dest/.git" ]; then
  echo "Destination already exists. Updating repository..."
  git -C "$dest" fetch --depth=1 || true
  # Try a safe reset to remote HEAD, fall back to pull
  if ! git -C "$dest" reset --hard origin/HEAD >/dev/null 2>&1; then
    git -C "$dest" pull --rebase --autostash || true
  fi
else
  git clone --depth=1 "$repo" "$dest"
fi

# Ensure the install script is executable
if [ -f "$dest/install.sh" ]; then
  if [ ! -x "$dest/install.sh" ]; then
    chmod +x "$dest/install.sh" || true
  fi
  echo "Running install.sh from $dest"
  bash "$dest/install.sh"
else
  echo "Error: install.sh not found in $dest" >&2
  exit 2
fi
