#!/usr/bin/env bash
set -euo pipefail

# artix.sh - Artix installer (Wayland + Hyprland + ml4w dotfiles)
# Only installs packages explicitly requested (Wayland, Hyprland, ml4w) or
# packages that appear in archlinux.sh from this repo.

log() { printf "%s %s\n" "[artix-installer]" "$*"; }

repo_root="$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"

# If running as root we can run pacman directly; otherwise require sudo.
if [ "$(id -u)" -ne 0 ] && ! command -v sudo >/dev/null 2>&1; then
  echo "sudo is required to install packages as non-root; please install sudo or run as root." >&2
  exit 1
fi

log "Starting Artix installer (minimal set)"

# Ensure git is available for cloning dotfiles (git appears in archlinux.sh)
if ! command -v git >/dev/null 2>&1; then
  log "Installing git"
  if [ "$(id -u)" -eq 0 ]; then
    pacman --needed -Syu --noconfirm git || true
  else
    sudo pacman --needed -Syu --noconfirm git || true
  fi
fi

# Packages we will install. Each package here either appears in archlinux.sh
# from this repo or was explicitly requested (hyprland, wayland).
PKGS=(
  # explicitly requested
  wayland
  hyprland

  # from archlinux.sh
  git
  curl
  wget
  fzf
  htop
  neovim
  zsh
  imv
  wl-clipboard
  pavucontrol
  xdg-desktop-portal-wlr
  xorg-xwayland
  brightnessctl
  playerctl
  waybar
  dunst
  rofi
  grim
  slurp
)

install_pkgs() {
  log "Installing packages via pacman: ${#PKGS[@]} packages"
  if [ "$(id -u)" -eq 0 ]; then
    if ! pacman --needed -Syu --noconfirm "${PKGS[@]}"; then
      log "pacman reported errors. Some packages may not be available in your Artix repos."
      log "Consider enabling appropriate repos or using an AUR helper to build missing packages."
    fi
  else
    if ! sudo pacman --needed -Syu --noconfirm "${PKGS[@]}"; then
      log "pacman reported errors. Some packages may not be available in your Artix repos."
      log "Consider enabling appropriate repos or using an AUR helper to build missing packages."
    fi
  fi
}

# Skip package install when running in CI or when NO_INSTALL is set.
if [ "${CI:-}" = "true" ] || [ "${NO_INSTALL:-}" = "1" ]; then
  log "NO_INSTALL or CI detected; skipping package installation"
else
  read -r -p "Install packages with pacman now? (requires sudo/root) [y/N]: " ans
  case "$ans" in
    [Yy]*) install_pkgs ;;
    *) log "Skipping package installation" ;;
  esac
fi

# Bootstrap ml4w dotfiles using the repo-local helper (ml4w.sh)
if [ -x "$repo_root/ml4w.sh" ]; then
  log "Bootstrapping ml4w dotfiles using $repo_root/ml4w.sh"
  (bash "$repo_root/ml4w.sh")
else
  log "ml4w.sh helper not found or not executable in $repo_root"
  log "Run the ml4w installer manually: $repo_root/ml4w.sh"
fi

# Copy base/linux configs if present (these come from this repository)
if [ -d "$repo_root/base" ]; then
  log "Copying base configs into home (~)"
  cp -vr "$repo_root/base/." "$HOME/"
fi

if [ -d "$repo_root/linux" ]; then
  log "Copying linux configs into home (~)"
  cp -vr "$repo_root/linux/." "$HOME/"
fi

log "Artix installer finished"
