#!/usr/bin/env sh

# shellcheck disable=SC2046
sudo apt install -y $(awk -F# '/^[a-z]+/ {print $1}' <"$HOME/.config/apt.ini")
