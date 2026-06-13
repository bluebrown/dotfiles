#!/usr/bin/env sh
set -eu

cache="$HOME/.cache/tools"
mkdir -p "$cache" && cd "$cache"

if ! test -f nerdctl-full-2.3.1-linux-amd64.tar.gz; then
  curl -LO https://github.com/containerd/nerdctl/releases/download/v2.3.1/nerdctl-full-2.3.1-linux-amd64.tar.gz
fi

if ! test -x "$HOME/.local/bin/nerdctl"; then
  tar Cxzf "$HOME/.local" nerdctl-full-2.3.1-linux-amd64.tar.gz
fi

export PATH="$HOME/.local/bin:$PATH"

if ! systemctl --user list-unit-files containerd.service >/dev/null; then
  containerd-rootless-setuptool.sh install
fi

systemctl --user disable containerd.service

nerdctl run --rm hello-world
