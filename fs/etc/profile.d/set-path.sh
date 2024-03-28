#!/usr/bin/env sh

PATH="$PATH:$HOME/dotfiles/bin"
PATH="$PATH:/usr/local/go/bin:$HOME/go/bin"
PATH="$PATH:$HOME/.local/bin"

PATH="$(printf %s "$PATH" | awk -vRS=: '!a[$0]++' | paste -s -d:)"
export PATH
