#!/usr/bin/env bash
set -Eeo pipefail

git clone --bare https://github.com/bluebrown/dotfiles.git ~/.config/dotfiles.git
git --git-dir="$HOME/.config/dotfiles.git/" --work-tree="$HOME" checkout
sudo bash ~/.config/apt_deps.sh
bash ~/.config/tools.sh
