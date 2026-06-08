#!/usr/bin/env bash
set -Eeuo pipefail

mkdir -p .local/bin
cd .local/
rm -rf go

vers="$(curl -sL 'https://go.dev/dl/?mode=json' | jq -r '.[0].version')"

curl -LO "https://go.dev/dl/$vers.linux-amd64.tar.gz"
tar -xzf "$vers.linux-amd64.tar.gz"

ln -sr go/bin/* bin/ || true
