#!/bin/bash

set -ex

mkdir -p  ~/.backup

curl -fsSL https://starship.rs/install.sh  | bash

sed -i '/.config/d' ~/.bashrc
echo "source ~/.config/.profile" >> ~/.bashrc

if [ -d "$HOME/.vim" ] ; then
    mv ~/.vim ~/.backup/.vim."$(date +"%FT%TZ")"
fi

cp -r vim-alpine ~/.vim

git config --global user.email "nico-braun@live.de"
git config --global user.name "Nico Braun"

echo "Setup completed."