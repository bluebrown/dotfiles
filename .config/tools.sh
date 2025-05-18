#!/usr/bin/env bash
set -Eeuo pipefail

PREFIX="$HOME/.local"
BIN_DIR="$PREFIX/bin"
mkdir -p "$BIN_DIR"

# starship
STARSHIP_URL="https://starship.rs/install.sh"

curl -fsSL "$STARSHIP_URL" | sh -s -- -y -b "$BIN_DIR"

# lsd
LSD_VERSION="1.1.5"
LSD_RELEASE="lsd-v${LSD_VERSION}-x86_64-unknown-linux-gnu"
LSD_URL="https://github.com/lsd-rs/lsd/releases/download/v${LSD_VERSION}/${LSD_RELEASE}.tar.gz"
LSD_BIN="${LSD_RELEASE}/lsd"

curl -fSSL "$LSD_URL" | tar -C "$BIN_DIR" --strip-components 1 -xzf - "$LSD_BIN"

# bat
BAT_VERSION="0.25.0"
BAT_RELEASE="bat-v${BAT_VERSION}-x86_64-unknown-linux-gnu"
BAT_URL="https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/${BAT_RELEASE}.tar.gz"
BAT_BIN="${BAT_RELEASE}/bat"

curl -fsSL "$BAT_URL" | tar -C "$BIN_DIR" --strip-components 1 -xzf - "$BAT_BIN"

# fzf
FZF_VERSION="0.62.0"
FZF_RELEASE="fzf-${FZF_VERSION}-linux_amd64"
FZF_URL="https://github.com/junegunn/fzf/releases/download/v${FZF_VERSION}/${FZF_RELEASE}.tar.gz"
FZF_BIN="fzf"

curl -fsSL "$FZF_URL" | tar -C "$BIN_DIR" -xzf - "$FZF_BIN"

# ripgrep
RIPGREP_VERSION="14.1.1"
RIPGREP_RELEASE="ripgrep-${RIPGREP_VERSION}-x86_64-unknown-linux-gnu"
RIPGREP_URL="https://github.com/BurntSushi/ripgrep/releases/download/${RIPGREP_VERSION}/${RIPGREP_RELEASE}.tar.gz"
RIPGREP_BIN="${RIPGREP_RELEASE}/rg"

curl -fsSL "$RIPGREP_URL" | tar -C "$BIN_DIR" --strip-components 1 -xzf - "$RIPGREP_BIN"

# fd
FD_VERSION="10.2.0"
FD_RELEASE="fd-v${FD_VERSION}-x86_64-unknown-linux-gnu"
FD_URL="https://github.com/sharkdp/fd/releases/download/${FD_VERSION}/${FD_RELEASE}.tar.gz"
FD_BIN="${FD_RELEASE}/fd"

curl -fsSL "$FD_URL" | tar -C "$BIN_DIR" --strip-components 1 -xzf - "$FD_BIN"

# direnv
DIRENV_VERSION="2.36.0"
DIRENV_RELEASE="direnv.linux-amd64"
DIRENV_URL="https://github.com/direnv/direnv/releases/download/v${DIRENV_VERSION}/${DIRENV_RELEASE}"
DIRENV_BIN="${BIN_DIR}/direnv"

curl -fsSL "$DIRENV_URL" -o "$DIRENV_BIN"
chmod +x "$DIRENV_BIN"

# neovim
NEOVIM_URL="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"

curl -fsSL "$NEOVIM_URL" | tar -C "$PREFIX" --strip-components 1 -xzf -
