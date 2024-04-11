#!/usr/bin/env bash
set -eu
rsync -rv "$HOME/.config/nvim/" "$HOME/dotfiles/fsys/home/.config/nvim"
