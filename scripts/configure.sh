#!/usr/bin/env bash

set -euo pipefail

ts="${EPOCHSECONDS}"

syncfs() {
  rsync --backup --backup-dir="$PWD/.backup/$ts/$1" --archive "fs/$1" "$2"
}

sudo_syncfs() {
  sudo rsync --backup --backup-dir="$PWD/.backup/$ts/$1" --archive "fs/$1" "$2"
}

syncfs home/user/ ~/
sudo_syncfs etc/ /etc/
