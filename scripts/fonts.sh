#!/usr/bin/env bash

set -euo pipefail

sudo apt-get -y install fonts-firacode fontconfig
fc-cache -fv

