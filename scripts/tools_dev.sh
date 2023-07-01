#!/usr/bin/env bash
set -o nounset -o errexit -o errtrace -o pipefail

# install go
if test -z "$(which go)"; then
  go_release=$(curl -fsSL https://go.dev/VERSION?m=text)
  curl -fsSLO "https://go.dev/dl/${go_release}.linux-amd64.tar.gz"
  sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf "${go_release}.linux-amd64.tar.gz"
  rm "${go_release}.linux-amd64.tar.gz"
fi

# install nodejs
if test -z "$(which node)"; then
  curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
  sudo apt-get install -y nodejs
  sudo npm -g set prefix ~/.local
fi
