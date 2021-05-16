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
alias sc="socat"

# functions

function randpwd() {
    < /dev/urandom tr -cd "${1:-'[:graph:]'}" | 
        head -c "${2:-32}"; echo
}
