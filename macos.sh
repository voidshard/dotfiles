#!/bin/bash

# macOS setup script
# - installs packages
# - copies in configs
#
# Nb. podman needs `podman machine init && podman machine start` before first use

set -eux

dir="$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
cd $dir

# homebrew (https://brew.sh)
command -v brew >/dev/null 2>&1 || \
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# command line tools, for the C compiler nvim-treesitter needs
xcode-select -p >/dev/null 2>&1 || xcode-select --install

# standard apps
brew install fzf curl wget git htop node rust go zsh podman dive jq nmap tmux pass python

# gui apps (no imv on mac, Preview covers it)
brew install --cask dbeaver-community db-browser-for-sqlite discord thunderbird gimp alacritty

# aerospace, an i3-like tiling wm (https://nikitabobko.github.io/AeroSpace/guide)
# needs Accessibility permission granted on first launch
brew install --cask nikitabobko/tap/aerospace

# move Spotlight off cmd-space onto alt-d, matching the rofi binding in the sway config
# 64 is Spotlight's hotkey id, parameters are (char code, key code, modifier mask):
# 'd' = 100, kVK_ANSI_D = 2, option = 524288
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 64 \
  '<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>100</integer><integer>2</integer><integer>524288</integer></array><key>type</key><string>standard</string></dict></dict>'
# reload the hotkey table so it applies without logging out
/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u

# keep the Dock out of the way, aerospace does its job; it cannot be disabled outright as
# it also runs Mission Control, cmd-tab and Spaces. cmd-opt-d toggles it back
defaults write com.apple.dock autohide -bool true
# 16 is the floor of the System Settings slider
defaults write com.apple.dock tilesize -int 16
# never reveal on hover at the screen edge
defaults write com.apple.dock autohide-delay -float 1000
defaults write com.apple.dock autohide-time-modifier -float 0
# running apps only, no pinned or recent ones
defaults write com.apple.dock static-only -bool true
defaults write com.apple.dock show-recents -bool false
# the Dock only reads its prefs at launch; launchd restarts it. No Dock without a GUI
# session, and set -e must not abort the rest of the script over that
killall Dock || true

# neovim python provider and PyX; --break-system-packages as brew's python is marked externally managed (PEP 668)
python3 -m pip install --user --break-system-packages pynvim pyx

# lazy vim (requirements: https://www.lazyvim.org/#%EF%B8%8F-requirements)
# the starter itself is vendored in base/.config/nvim and copied in below; lazy.nvim
# bootstraps itself on first launch
brew install neovim ripgrep fd lazygit tree-sitter-cli
brew install --cask font-fira-code-nerd-font

# copy in configs
# the trailing /. merges into existing directories; BSD cp would otherwise nest them
cp -vR base/. ~/
cp -vR macos/. ~/
