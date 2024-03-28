#!/usr/bin/env bash
set -o nounset -o errexit -o errtrace -o pipefail

# add the wsl config file
sudo cp extra/wsl/{wsl.conf,fstab} /etc/
sudo chown root:root /etc/{wsl.conf,fstab}

# since the systemd is enabled via wsl.conf
# dbus seems to be required to make it work properly
sudo apt-get -y install dbus
sudo apt-get install -y dbus-user-session
