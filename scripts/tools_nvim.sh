#!/usr/bin/env bash

set -euo pipefail

# install latest nvim
find /usr/local -type d -name nvim -print0 | xargs -r -0 sudo rm -rf
curl -fsSL https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz |
  sudo tar --strip-components 1 -C /usr/local -xzf-

# install tree-sitter cli
curl -fsSL https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-linux-x64.gz | gzip -d >tree-sitter
chmod +x tree-sitter
sudo mv tree-sitter /usr/local/bin/
