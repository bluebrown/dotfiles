#!/usr/bin/env bash
set -Eeo pipefail

if ! [[ -d "$HOME/.config/dotfiles.git" ]]; then
	git clone --bare https://github.com/bluebrown/dotfiles.git ~/.config/dotfiles.git
	git --git-dir="$HOME/.config/dotfiles.git/" --work-tree="$HOME" checkout
fi

sudo bash ~/.config/apt_deps.sh
bash ~/.config/tools.sh
