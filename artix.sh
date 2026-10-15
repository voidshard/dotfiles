#!/usr/bin/env bash
set -euo pipefail

# artix.sh - Artix Linux installer for Wayland + Hyprland + ml4w dotfiles
# This script is intended to be run on an interactive workstation. It is
# idempotent and safe to inspect: package installation is gated behind a
# confirmation prompt and skipped when CI or NO_INSTALL is set.
#
# Behavior:
# - Optionally installs required packages via pacman
# - Attempts to bootstrap the ml4w dotfiles included in this repo (ml4w.sh)
# - Copies base/ and linux/ configs from the repository into $HOME/

log() { printf "%s %s\n" "[artix-installer]" "$*"; }

repo_root="$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"

if ! command -v sudo >/dev/null 2>&1; then
  echo "sudo is required to install packages; please install sudo and re-run." >&2
  exit 1
fi

log "Starting Artix installer"

# Ensure git is available for cloning dotfiles
if ! command -v git >/dev/null 2>&1; then
  log "Installing git"
  sudo pacman --needed -Syu --noconfirm git || true
fi

# Core packages useful for a modern Wayland desktop
PACKAGES=(
  base-devel
  sudo
  git
  curl
  wget
  fzf
  htop
  neovim
  zsh
  alsa-utils
  wireplumber
  pavucontrol
  wl-clipboard
  wayland
  wayland-protocols
  xorg-xwayland
  xdg-desktop-portal-wlr
  polkit
  dbus
)

# Hyprland and common Wayland utilities. Note: on some Artix setups Hyprland
# may be available via community, chaotic-aur or an AUR helper. This list will
# be passed to pacman; if a package is not found pacman will report an error.
HYPR_PKGS=(
  hyprland
  hyprpaper
  waybar
  foot
  grim
  slurp
  mako
  wlroots
  wlr-randr
  gammastep
  light
  brightnessctl
  playerctl
  rofi
  dunst
  imv
)

install_pkgs() {
  local pkgs=("${PACKAGES[@]}" "${HYPR_PKGS[@]}")
  log "Installing packages via pacman: ${#pkgs[@]} packages"
  # Use --needed so we don't reinstall packages and keep system up-to-date
  if ! sudo pacman --needed -Syu --noconfirm "${pkgs[@]}"; then
    log "pacman reported errors. Some packages (like hyprland) may not be in your Artix repos."
    log "If a package isn't available, consider enabling the appropriate repo or using an AUR helper (e.g. yay) to build it."
  fi
}

# Skip package install when running in CI or when NO_INSTALL is set. This makes
# the script safe for automated environments and tests that only want to
# verify the script contents.
if [ "${CI:-}" = "true" ] || [ "${NO_INSTALL:-}" = "1" ]; then
  log "NO_INSTALL or CI detected; skipping package installation"
else
  read -r -p "Install packages with pacman now? (requires sudo) [y/N]: " ans
  case "$ans" in
    [Yy]*) install_pkgs ;;
    *) log "Skipping package installation" ;;
  esac
fi

# Bootstrap ml4w dotfiles using the repo-local helper ml4w.sh (if present)
if [ -x "$repo_root/ml4w.sh" ]; then
  log "Bootstrapping ml4w dotfiles using $repo_root/ml4w.sh"
  # run in a subshell to avoid polluting environment
  (bash "$repo_root/ml4w.sh")
else
  log "ml4w.sh helper not found or not executable in $repo_root"
  log "You can run the ml4w installer manually: $repo_root/ml4w.sh"
fi

# Copy base and linux configs into home directory if they exist. We preserve
# existing files (cp -v will overwrite — users are expected to manage backups).
if [ -d "$repo_root/base" ]; then
  log "Copying base configs into home (~)"
  cp -vr "$repo_root/base/." "$HOME/"
fi

if [ -d "$repo_root/linux" ]; then
  log "Copying linux configs into home (~)"
  cp -vr "$repo_root/linux/." "$HOME/"
fi

log "Artix installer finished (some actions may have been skipped)"
