#!/usr/bin/env bash
set -o nounset -o errexit -o errtrace -o pipefail

# az cli
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# kubelogin
sudo apt-get -y install unzip
mkdir -p tmp && cd tmp
curl -fsSLO https://github.com/Azure/kubelogin/releases/latest/download/kubelogin-linux-amd64.zip
unzip kubelogin-linux-amd64.zip && chmod +x bin/linux_amd64/kubelogin
sudo mv bin/linux_amd64/kubelogin /usr/local/bin
cd -
rm -rf tmp
