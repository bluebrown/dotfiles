#!/usr/bin/env bash
set -Eeuo pipefail

cache_home="$HOME/.cache/tools"
tool_home="$HOME/.local/tools"
bin_home="$HOME/.local/bin"
go_home="$tool_home/go"

rm -rf "$go_home"
mkdir -p "$cache_home" "$bin_home" "$go_home"

vers="$(curl -sL 'https://go.dev/dl/?mode=json' | jq -r '.[0].version')"

cd "$cache_home"
curl -LO "https://go.dev/dl/$vers.linux-amd64.tar.gz"
tar Cxzf "$HOME/.local/tools" "$vers.linux-amd64.tar.gz"

ln -rsf "$go_home/bin"/* "$bin_home/"
