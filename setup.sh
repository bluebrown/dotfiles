#!/bin/bash

set -ex

mkdir -p  ~/.backup

my_link="$HOME/.tmux.conf"
[ -L ${my_link} ] && unlink "$my_link"
ln -s $PWD/tmux/tmux.conf "$my_link"

curl -fsSL https://starship.rs/install.sh  | bash

sed -i '/.config/d' "$HOME/.bashrc"
echo "source $PWD/.profile" >> "$HOME/.bashrc"

if [ -d "$HOME/.vim" ] ; then
    mv "$HOME/.vim" "$HOME/.backup/.vim.$(date +'%FT%TZ')"
fi

cp -r vim-alpine ~/.vim

git config --global user.email "nico-braun@live.de"
git config --global user.name "Nico Braun"

echo "Setup completed."
