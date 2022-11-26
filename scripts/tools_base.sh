#!/usr/bin/env bash

set -euo pipefail

latest_tag() {
  curl -s "https://api.github.com/repos/$1/releases/latest" | jq -r '.tag_name'
}

# base packages
sudo apt-get -y install gcc g++ build-essential

# starship prompt
sudo sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- --yes --bin-dir /usr/local/bin

# tmux
sudo apt-get -y install tmux

# jq
curl -fsSL https://github.com/stedolan/jq/releases/latest/download/jq-linux64 |
  sudo install -m 755 /dev/stdin /usr/local/bin/jq

# direnv
sudo curl -fsSL https://github.com/direnv/direnv/releases/latest/download/direnv.linux-amd64 -o /usr/local/bin/direnv
sudo chmod +x /usr/local/bin/direnv

# rg
tag="$(latest_tag BurntSushi/ripgrep)"
curl -L "https://github.com/BurntSushi/ripgrep/releases/download/$tag/ripgrep-$tag-x86_64-unknown-linux-musl.tar.gz" |
  sudo tar -C /usr/local/bin/ --strip-components 1 -xzf- "ripgrep-$tag-x86_64-unknown-linux-musl/rg"

# fd
tag="$(latest_tag sharkdp/fd)"
curl -L "https://github.com/sharkdp/fd/releases/download/$tag/fd-$tag-x86_64-unknown-linux-musl.tar.gz" |
  sudo tar -C /usr/local/bin/ --strip-components 1 -xzf- "fd-$tag-x86_64-unknown-linux-musl/fd"

# fzf
tag="$(latest_tag junegunn/fzf)"
curl -fsSL "https://github.com/junegunn/fzf/releases/download/$tag/fzf-$tag-linux_amd64.tar.gz" | sudo tar -C /usr/local/bin/ -xzf - fzf
sudo curl -fsSL "https://raw.githubusercontent.com/junegunn/fzf/$tag/bin/fzf-tmux" -o /usr/local/bin/fzf-tmux
sudo chmod +x /usr/local/bin/fzf-tmux
