#!/bin/bash

# Path

if [ -d "/usr/local/go/bin" ] ; then
    PATH="$PATH:/usr/local/go/bin"
fi

if [ "$(starship -V)" ]; then
    eval "$(starship init bash)"
fi

if [ -d "$HOME/npm/bin" ] ; then
    PATH="$HOME/npm/bin:$PATH"
fi

export PATH

#Bindings

bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# alias

alias docker="sudo docker"
alias dc="sudo docker-compose"
alias ans="ansible"
alias ap="ansible-playbook"
alias tf="terraform"
alias foo="echo 'baz'"

# functions

function pwd() {
    range="$1"
    if [ -z "${range}" ]; then range='[:graph:]'; fi
    < /dev/urandom tr -cd "$range" | head -c 32; echo
}
