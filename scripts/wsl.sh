#!/usr/bin/env bash

set -euo pipefail

sudo cp extra/wsl/* /etc/
sudo chown root:root /etc/fstab /etc/wsl.conf
sudo chmod 0644 /etc/fstab

sudo apt-get -y install dbus
sudo apt-get install -y dbus-user-session
