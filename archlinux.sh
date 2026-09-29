#!/bin/bash

# Arch Linux setup script
# - copies in configs
# - installs packages
#
# Nb. for printer setup `hp-setup`

set -eux

dir="$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
cd $dir

# standard apps
sudo pacman --needed -S \
  fzf curl wget git htop nodejs cargo go dbeaver sqlitebrowser tiled neovim zsh \
  discord podman imv dive jq nmap tmux thunderbird python-pyx python-neovim pass steam \
  python-pip gimp ffmpeg

# sway desktop, matching the package set of the fedora sway spin
# https://gitlab.com/fedora/sigs/sway/sway-config-fedora
sudo pacman --needed -S \
  sway swaybg swayidle swaylock waybar dunst rofi sway-contrib grim slurp wl-clipboard \
  brightnessctl playerctl libpulse pavucontrol imagemagick lxqt-policykit thunar \
  xdg-desktop-portal-wlr xorg-xwayland power-profiles-daemon

# alacritty (https://github.com/alacritty/alacritty/blob/master/INSTALL.md#arch-linux)
sudo pacman --needed -S cmake freetype2 fontconfig pkg-config make libxcb libxkbcommon python
cargo install alacritty
sudo mv ~/.cargo/bin/alacritty /usr/local/bin

# lazy vim
# the starter itself is vendored in base/.config/nvim and copied in below; lazy.nvim
# bootstraps itself on first launch
sudo pacman --needed -S ripgrep fd lazygit tree-sitter-cli base-devel ttf-firacode-nerd

# copy in configs
cp -vr base/. ~/
cp -vr linux/. ~/

