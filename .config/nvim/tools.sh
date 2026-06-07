#!/usr/bin/env bash
set -Eeuo pipefail

mkdir -p .local/bin
cd .local/

cargo install stylua --features luajit
cargo install tree-sitter-cli

curl -fsSL https://github.com/tamasfe/taplo/releases/latest/download/taplo-linux-x86_64.gz |
  gzip -d - | install -m 755 /dev/stdin ~/.local/bin/taplo

rm -rf go
vers="$(curl -sL 'https://go.dev/dl/?mode=json' | jq -r '.[0].version')"
curl -LO "https://go.dev/dl/$vers.linux-amd64.tar.gz"
tar -xzf "$vers.linux-amd64.tar.gz"
ln -sr go/bin/* bin/ || true

~/.local/bin/go install github.com/google/yamlfmt/cmd/yamlfmt@latest
~/.local/bin/go install golang.org/x/tools/gopls@latest
~/.local/bin/go install golang.org/x/tools/cmd/goimports@latest

rm -rf nvim-linux-x86_64
curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.tar.gz
tar -xzf nvim-linux-x86_64.tar.gz
ln -sr nvim-linux-x86_64/bin/* bin/ || true
