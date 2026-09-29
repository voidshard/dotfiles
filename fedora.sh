#!/bin/bash

# Fedora setup script
# - installs packages
# - copies in configs
#
# Nb. assumes the Fedora Sway spin (https://fedoraproject.org/spins/sway/), which already
# ships sway, waybar, dunst, swayidle/swaylock, grimshot, lxqt-policykit and rofi-wayland

set -eux

dir="$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
cd $dir

# rpm fusion, for steam/discord (https://rpmfusion.org/Configuration)
sudo dnf install -y \
  https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
  https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# standard apps
sudo dnf install -y \
  alacritty fzf curl git htop nodejs cargo golang sqlitebrowser tiled zsh discord \
  podman jq nmap tmux thunderbird python3-neovim pass steam python3-pip gimp unzip \
  dnf-plugins-core

# fedora ships the patent-stripped ffmpeg-free; swap in rpm fusion's full build
# https://rpmfusion.org/Howto/Multimedia
sudo dnf swap -y ffmpeg-free ffmpeg --allowerasing

# the spin's swaywm/swaywm-extended groups already cover waybar, dunst, rofi-wayland,
# grimshot, brightnessctl, playerctl, pavucontrol, wl-clipboard, imv and Thunar
# https://forge.fedoraproject.org/releng/kiwi-descriptions/src/branch/rawhide/components/desktops/sway.xml
sudo dnf install -y ImageMagick power-profiles-daemon

# dbeaver ships its own rpm (https://dbeaver.io/download/)
sudo dnf install -y https://dbeaver.io/files/dbeaver-ce-latest-stable.x86_64.rpm

# dive ships rpms on its releases page (https://github.com/wagoodman/dive#installation)
sudo dnf install -y \
  https://github.com/wagoodman/dive/releases/download/v0.13.1/dive_0.13.1_linux_amd64.rpm

# lazy vim (requirements: https://www.lazyvim.org/#%EF%B8%8F-requirements)
# lazygit is not in the fedora repos, upstream points at this copr (https://github.com/jesseduffield/lazygit#fedora)
# the starter itself is vendored in base/.config/nvim and copied in below; lazy.nvim
# bootstraps itself on first launch
sudo dnf copr enable -y atim/lazygit
sudo dnf install -y neovim ripgrep fd-find lazygit tree-sitter-cli gcc make

# nerd fonts are not packaged for fedora (https://github.com/ryanoasis/nerd-fonts#option-3-unpatched-font-download)
mkdir -p ~/.local/share/fonts/FiraCodeNerdFont
curl -fLo /tmp/FiraCode.zip \
  https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip
unzip -o /tmp/FiraCode.zip -d ~/.local/share/fonts/FiraCodeNerdFont
fc-cache -f

# copy in configs
cp -vr base/. ~/
cp -vr linux/. ~/
