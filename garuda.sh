#!/bin/bash

# Garuda Linux setup script
# - installs packages via pacman/paru
# - copies in configs
#
# Nb. assumes the Sway spin (https://garudalinux.org/editions?edition=sway), which already
# ships sway, waybar, dunst, rofi, grimshot, lxqt-policykit and brightnessctl

set -eux

dir="$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
cd $dir

# standard apps (AUR helpers like paru also work for official repo packages)
paru --needed -S \
  fzf curl wget git htop nodejs cargo go dbeaver sqlitebrowser tiled neovim zsh \
  discord podman imv dive jq nmap tmux thunderbird python-pyx python-neovim pass steam \
  python-pip gimp ffmpeg

# the sway spin already covers waybar, dunst, rofi, grimshot, brightnessctl, playerctl,
# wl-clipboard, imv and pavucontrol

# alacritty (https://github.com/alacritty/alacritty/blob/master/INSTALL.md#arch-linux)
paru --needed -S cmake freetype2 fontconfig pkg-config make libxcb libxkbcommon python
cargo install alacritty
sudo mv ~/.cargo/bin/alacritty /usr/local/bin

# lazy vim
# the starter itself is vendored in base/.config/nvim and copied in below; lazy.nvim
# bootstraps itself on first launch
paru --needed -S ripgrep fd lazygit tree-sitter-cli base-devel ttf-firacode-nerd

# copy in configs
cp -vr base/. ~/
cp -vr linux/. ~/
