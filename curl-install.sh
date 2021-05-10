#!/bin/bash

set ex

git clone --recursive https://github.com/bluebrown/dotfiles ~/.config
cd ~/.config
chmod 755 ./setup.sh
./setup.sh
source ~/.bashrc

