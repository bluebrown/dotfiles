#!/bin/bash

set -ex

mkdir -p  ~/.backup

yes y | source <(curl -fsSL https://starship.rs/install.sh)

sed -i '/.config/d' ~/.bashrc
echo "source ~/.config/.profile" >> ~/.bashrc

if [ -d "$HOME/.vim" ] ; then
    mv ~/.vim ~/.backup/.vim."$(date +"%FT%TZ")"
fi

cp -r vim-alpine ~/.vim