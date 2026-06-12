#!/usr/bin/env sh
set -eu

mkdir -p "$HOME/.local/bin"
cd "$HOME/.local/"

cargo install stylua --features luajit
cargo install tree-sitter-cli

if ! test -x "$HOME/.local/bin/taplo"; then
  curl -fsSL https://github.com/tamasfe/taplo/releases/latest/download/taplo-linux-x86_64.gz |
    gzip -d - | install -m 755 /dev/stdin "$HOME/.local/bin/taplo"
fi

if test -x go; then
  go install github.com/google/yamlfmt/cmd/yamlfmt@latest
  go install golang.org/x/tools/gopls@latest
  go install golang.org/x/tools/cmd/goimports@latest
fi

rm -rf nvim-linux-x86_64
curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.tar.gz
tar -xzf nvim-linux-x86_64.tar.gz
ln -srf nvim-linux-x86_64/bin/* bin/

if test -x pipx; then
  pipx install mdformat
  pipx inject mdformat mdformat-gfm mdformat-toc
fi
