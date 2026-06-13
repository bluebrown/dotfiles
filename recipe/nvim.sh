#!/usr/bin/env sh
set -eu

cache_home="$HOME/.cache/tools"
tool_home="$HOME/.local/tools"
bin_home="$HOME/.local/bin"
nvim_home="$tool_home/nvim-linux-x86_64"

mkdir -p "$cache_home" "$bin_home" "$nvim_home"

cargo install stylua --features luajit
cargo install tree-sitter-cli

if ! test -x "$bin_home/taplo"; then
  curl -fsSL https://github.com/tamasfe/taplo/releases/latest/download/taplo-linux-x86_64.gz |
    gzip -d - | install -m 755 /dev/stdin "$bin_home/taplo"
fi

if test -x go; then
  go install github.com/google/yamlfmt/cmd/yamlfmt@latest
  go install golang.org/x/tools/gopls@latest
  go install golang.org/x/tools/cmd/goimports@latest
fi

cd "$cache_home"
curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.tar.gz

rm -rf "$nvim_home" && mkdir -p "$nvim_home"
tar Cxzf "$tool_home" "$cache_home/nvim-linux-x86_64.tar.gz"

ln -srf "$nvim_home/bin/nvim" "$bin_home/nvim"

if test -x pipx; then
  pipx install mdformat
  pipx inject mdformat mdformat-gfm mdformat-toc
fi
