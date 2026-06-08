#!/usr/bin/env bash
set -Eeuo pipefail

# shellcheck disable=SC2046
apt install -y $(awk -F# '/^[a-z]+/ {print $1}' <"$SUDO_HOME/.config/apt.ini")
