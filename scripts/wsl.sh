#!/usr/bin/env bash

set -euo pipefail

sudo cp extra/wsl/* /etc/
sudo chown root:root /etc/fstab /etc/wsl.conf
sudo chmod 0644 /etc/fstab


