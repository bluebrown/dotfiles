#!/usr/bin/env bash

set euo -pipefail

# install go
if test -z $(which go); then
    go_release=$(curl -fsSL https://go.dev/VERSION?m=text)
    curl -fSSLO "https://go.dev/dl/${go_release}.linux-amd64.tar.gz"
    sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf "${go_release}.linux-amd64.tar.gz"
    rm "${go_release}.linux-amd64.tar.gz"
fi