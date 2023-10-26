#!/bin/bash

set -eux

dir="$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
cd $dir

cp -vr base/* ~/ 
cp -vr base/.* ~/ 

# random stuff
sudo pacman --needed -S fzf curl git htop nodejs cargo go dbeaver sqlitebrowser tiled neovim zsh discord docker docker-compose gpicview dive jq nmap tmux thunderbird python-pyx python-neovim

# alacritty (https://github.com/alacritty/alacritty/blob/master/INSTALL.md#arch-linux)
sudo pacman --needed -S cmake freetype2 fontconfig pkg-config make libxcb libxkbcommon python
cargo install alacritty
mv ~/.cargo/bin/alacritty /usr/local/bin

# librewolf (https://librewolf.net/installation/arch/)
yay -S librewolf-bin

# neovim plugin manager (https://github.com/junegunn/vim-plug)
# -- must run :PlugInstall
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# install neovim copilot plugin
# -- must run :Copilot setup
git clone https://github.com/github/copilot.vim.git ~/.config/nvim/pack/github/start/copilot.vim
