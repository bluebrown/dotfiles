#!/usr/bin/env bash

set -euo pipefail

echo ""

read -rp "git user.name:  " name
read -rp "git user.email: " email

git config --global user.name "$name"
git config --global user.email "$email"

