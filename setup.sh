#!/bin/bash

mkdir -p  ~/.backup

sed -i '/.config/d' ~/.bashrc
echo "source ~/.config/.profile" >> ~/.bashrc

if [ -d "$HOME/.vim" ] ; then
    mv ~/.vim ~/.backup/.vim."$(date +"%FT%TZ")"
fi

cp -r vim-alpine ~/.vim