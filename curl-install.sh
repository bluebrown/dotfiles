#!/bin/bash

set ex

check_config=0

if [ -d "$HOME/.config" ] 
then
    echo "Directory .config dir exists."
    check_config=1
    mv ~/.config ~/.config.bak
fi

git clone --recursive https://github.com/bluebrown/dotfiles ~/.config
cd ~/.config || exit
chmod 755 ./setup.sh
./setup.sh


if (( check_config != 0 )); then
    printf "\n\n.config folder has been backed up. Please check ~/.config.bak.\n"
fi

echo "Install completed."