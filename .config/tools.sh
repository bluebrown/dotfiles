#!/usr/bin/env bash
set -Eeuo pipefail

PREFIX="$HOME/.local"
BIN_DIR="$PREFIX/bin"
mkdir -p "$BIN_DIR"

echo "install starship"
STARSHIP_URL="https://starship.rs/install.sh"

curl -fsSL "$STARSHIP_URL" | sh -s -- -y -b "$BIN_DIR"

echo "install lsd"
LSD_VERSION="1.1.5"
LSD_RELEASE="lsd-v${LSD_VERSION}-x86_64-unknown-linux-gnu"
LSD_URL="https://github.com/lsd-rs/lsd/releases/download/v${LSD_VERSION}/${LSD_RELEASE}.tar.gz"
LSD_BIN="${LSD_RELEASE}/lsd"

curl -fsSL "$LSD_URL" | tar -C "$BIN_DIR" --strip-components 1 -xzf - "$LSD_BIN"

echo "install bat"
BAT_VERSION="0.25.0"
BAT_RELEASE="bat-v${BAT_VERSION}-x86_64-unknown-linux-gnu"
BAT_URL="https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/${BAT_RELEASE}.tar.gz"
BAT_BIN="${BAT_RELEASE}/bat"

curl -fsSL "$BAT_URL" | tar -C "$BIN_DIR" --strip-components 1 -xzf - "$BAT_BIN"

echo "install fzf"
FZF_VERSION="0.62.0"
FZF_RELEASE="fzf-${FZF_VERSION}-linux_amd64"
FZF_URL="https://github.com/junegunn/fzf/releases/download/v${FZF_VERSION}/${FZF_RELEASE}.tar.gz"
FZF_BIN="fzf"

curl -fsSL "$FZF_URL" | tar -C "$BIN_DIR" -xzf - "$FZF_BIN"

echo "install ripgrep"
RIPGREP_VERSION="14.1.1"
RIPGREP_RELEASE="ripgrep-${RIPGREP_VERSION}-x86_64-unknown-linux-musl"
RIPGREP_URL="https://github.com/BurntSushi/ripgrep/releases/download/${RIPGREP_VERSION}/${RIPGREP_RELEASE}.tar.gz"
RIPGREP_BIN="${RIPGREP_RELEASE}/rg"

curl -fsSL "$RIPGREP_URL" | tar -C "$BIN_DIR" --strip-components 1 -xzf - "$RIPGREP_BIN"

echo "install fd"
FD_VERSION="10.2.0"
FD_RELEASE="fd-v${FD_VERSION}-x86_64-unknown-linux-gnu"
FD_URL="https://github.com/sharkdp/fd/releases/download/v${FD_VERSION}/${FD_RELEASE}.tar.gz"
FD_BIN="${FD_RELEASE}/fd"

curl -fsSL "$FD_URL" | tar -C "$BIN_DIR" --strip-components 1 -xzf - "$FD_BIN"

echo "install direnv"
DIRENV_VERSION="2.36.0"
DIRENV_RELEASE="direnv.linux-amd64"
DIRENV_URL="https://github.com/direnv/direnv/releases/download/v${DIRENV_VERSION}/${DIRENV_RELEASE}"
DIRENV_BIN="${BIN_DIR}/direnv"

curl -fsSL "$DIRENV_URL" -o "$DIRENV_BIN"
chmod +x "$DIRENV_BIN"

echo "install neovim"
NEOVIM_URL="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"

curl -fsSL "$NEOVIM_URL" | tar -C "$PREFIX" --strip-components 1 -xzf -

echo "install shellcheck"
SHELLCHECK_VERSION="0.10.0"
SHELLCHECK_RELEASE="shellcheck-v${SHELLCHECK_VERSION}.linux.x86_64.tar.xz"
SHELLCHECK_URL="https://github.com/koalaman/shellcheck/releases/download/v${SHELLCHECK_VERSION}/${SHELLCHECK_RELEASE}"
SHELLCHECK_BIN="shellcheck-v${SHELLCHECK_VERSION}/shellcheck"

curl -fsSL "$SHELLCHECK_URL" | tar -C "$BIN_DIR" --strip-components 1 -xJf - "$SHELLCHECK_BIN"

echo "install shfmt"
SHFMT_VERSION="3.11.0"
SHFMT_RELEASE="shfmt_v${SHFMT_VERSION}_linux_amd64"
SHFMT_URL="https://github.com/mvdan/sh/releases/download/v${SHFMT_VERSION}/${SHFMT_RELEASE}"
SHFMT_BIN="${BIN_DIR}/shfmt"

curl -fsSL "$SHFMT_URL" -o "$SHFMT_BIN"
chmod +x "$SHFMT_BIN"

echo "install exa"
EXA_VERSION="0.10.1"
EXA_RELEASE="exa-linux-x86_64-v${EXA_VERSION}.zip"
EXA_URL="https://github.com/ogham/exa/releases/download/v${EXA_VERSION}/${EXA_RELEASE}"
EXA_BIN="bin/exa"

tmpdir="$(mktemp -d)"
mkdir -p "$tmpdir"
trap 'rm -rf "$tmpdir"' EXIT
curl -fsSL "$EXA_URL" -o "${tmpdir}/${EXA_RELEASE}"
unzip "${tmpdir}/${EXA_RELEASE}" -d "$PREFIX" "${EXA_BIN}"
