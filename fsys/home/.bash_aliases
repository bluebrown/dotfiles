#!/usr/bin/env bash

alias d="docker"
alias dc="docker compose"

alias k="kubectl"
alias ksn="k config set-context --current --namespace"
alias kz="kustomize"
alias kb="kustomize build"

alias tf="terraform"

# find files in current dir an open in tmux if any selected
alias ff='fd --type f --hidden --exclude .git --print0 | fzf-tmux -p -- --read0 --print0 --exit-0 | xargs -r -0 -o ${EDITOR:-vim}'

# update go to latest
alias goupdate='sudo rm -rf /usr/local/go && curl -fsSL "https://go.dev/dl/$(curl -fsSL https://go.dev/VERSION?m=text).linux-amd64.tar.gz" | sudo tar -C /usr/local -xzf -'
