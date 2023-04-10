#!/usr/bin/env bash
set -o nounset -o errexit -o errtrace -o pipefail

sudo apt-get -y install fonts-firacode fontconfig
fc-cache -fv
