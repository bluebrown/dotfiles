#!/usr/bin/env sh

# must install nvim and go first

sudo apt install cargo shfmt shellcheck python3-neovim

cargo install stylua --features luajit

go install github.com/google/yamlfmt/cmd/yamlfmt@latest
go install golang.org/x/tools/gopls@latest
go install golang.org/x/tools/cmd/goimports@latest

curl -fsSL https://github.com/tamasfe/taplo/releases/latest/download/taplo-linux-x86_64.gz | gzip -d - | install -m 755 /dev/stdin ~/.local/bin/taplo

cargo install tree-sitter-cli
