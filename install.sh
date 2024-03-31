#!/usr/bin/env sh

# this script is desgined to be used via curl:
# curl -sSL https://github.com/bluebrown/dotfiles/raw/main/install.sh | sh -s -- [options]

set -e

git clone https://github.com/bluebrown/dotfiles.git ~/.dotfiles

cd ~/.dotfiles

make -j$(nproc) install

