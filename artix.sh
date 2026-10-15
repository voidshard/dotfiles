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

# Desktop tools (from the dotfiles) — these power the Hyprland + Quickshell setup
DESKTOP_PKGS=(
  hyprland
  hyprpaper
  hyprpicker
  hyprlock
  hypridle
  hyprsunset
  hyprmod
  nwg-dock-hyprland
  matugen
  wayland
  wayland-protocols
  wl-clipboard
  xdg-desktop-portal-hyprland
  xorg-xwayland
  wlroots

  # helper/utilities used by the dotfiles
  jq
  socat
  rsync
  zoxide
  cava
  awww
  gammastep
  brightnessctl
  playerctl
  rofi
  dunst
  mako
  grim
  slurp
)

# User applications (install unless already provided by DESKTOP_PKGS)
USER_APPS=(
  neovim
  fzf
  curl
  git
  htop
  nodejs
  golang
  sqlitebrowser
  tiled
  zsh
  discord
  podman
  nmap
  tmux
  thunderbird
  python3-neovim
  pass
  steam
  python3-pip
  gimp
  unzip
  obsidian
)

# Filter USER_APPS to remove packages already in DESKTOP_PKGS
_filtered_user_apps=()
for u in "${USER_APPS[@]}"; do
  skip=false
  for d in "${DESKTOP_PKGS[@]}"; do
    if [ "$u" = "$d" ]; then
      skip=true
      break
    fi
  done
  $skip || _filtered_user_apps+=("$u")
done

install_group() {
  local name="$1"
  shift
  local pkgs=("$@")

  log "Installing ${name} packages via pacman: ${#pkgs[@]} packages"

  # Update DB first (best-effort)
  if [ "$(id -u)" -eq 0 ]; then
    if ! pacman -Sy --noconfirm >/dev/null 2>&1; then
      log "Warning: pacman -Sy failed or could not update DB; continuing anyway"
    fi
  else
    if ! sudo pacman -Sy --noconfirm >/dev/null 2>&1; then
      log "Warning: sudo pacman -Sy failed or could not update DB; continuing anyway"
    fi
  fi

  if [ "$(id -u)" -eq 0 ]; then
    if ! pacman --needed -Syu --noconfirm "${pkgs[@]}" >/dev/null 2>&1; then
      log "Warning: some ${name} packages failed to install (they may be missing from repos). Continuing."
    fi
  else
    if ! sudo pacman --needed -Syu --noconfirm "${pkgs[@]}" >/dev/null 2>&1; then
      log "Warning: some ${name} packages failed to install (they may be missing from repos). Continuing."
    fi
  fi
}

install_pkgs() {
  install_group "desktop" "${DESKTOP_PKGS[@]}"
  # install filtered user apps only if any
  if [ "${#_filtered_user_apps[@]}" -gt 0 ]; then
    install_group "user" "${_filtered_user_apps[@]}"
  else
    log "No user apps to install (all covered by desktop packages)"
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

# Bootstrap ml4w dotfiles (inlined from ml4w.sh)
repo_ml4w_url="https://github.com/yurihikari/ml4w-lightcrimson-dotfiles.git"
repo_ml4w_dest="${HOME}/.ml4w-lightcrimson-dotfiles"

log "Bootstrapping ml4w dotfiles: cloning $repo_ml4w_url into $repo_ml4w_dest"

if ! command -v git >/dev/null 2>&1; then
  log "Error: git is required to clone ml4w dotfiles but is not installed. Skipping ml4w bootstrap."
else
  # Clone or update
  if [ -d "$repo_ml4w_dest/.git" ]; then
    log "Destination already exists. Updating repository..."
    git -C "$repo_ml4w_dest" fetch --depth=1 || true
    if ! git -C "$repo_ml4w_dest" reset --hard origin/HEAD >/dev/null 2>&1; then
      git -C "$repo_ml4w_dest" pull --rebase --autostash || true
    fi
  else
    git clone --depth=1 "$repo_ml4w_url" "$repo_ml4w_dest" || log "Warning: git clone of ml4w repo failed"
  fi

  # Ensure the install script is executable and run it
  if [ -f "$repo_ml4w_dest/install.sh" ]; then
    if [ ! -x "$repo_ml4w_dest/install.sh" ]; then
      chmod +x "$repo_ml4w_dest/install.sh" || true
    fi
    log "Running install.sh from $repo_ml4w_dest"
    bash "$repo_ml4w_dest/install.sh" || log "Warning: ml4w install.sh failed"
  else
    log "Error: install.sh not found in $repo_ml4w_dest"
  fi
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
