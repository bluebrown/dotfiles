#!/bin/bash

if [ -d "/usr/local/go/bin" ] ; then
    PATH="$PATH:/usr/local/go/bin"
fi

if [ "$(starship -V)" ]; then
    eval "$(starship init bash)"
fi

bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

export PATH

alias docker="sudo docker"
alias dc="sudo docker-compose"
alias ans="ansible"
alias ap="ansible-playbook"
alias tf="terraform"
