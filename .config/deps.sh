#!/usr/bin/env sh

apt install -y $(awk -F# '/^[a-z]+/ {print $1}' <"$HOME/.config/apt.ini")
