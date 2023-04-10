#!/usr/bin/env bash
set -o nounset -o errexit -o errtrace -o pipefail

: "${KUBE_VERSION:=1.24.6}"

helm_version=3.10.2
kpt_version=1.0.0-beta.22
kind_version=0.17.0

# kubectl
sudo curl -fsSL "https://dl.k8s.io/release/v${KUBE_VERSION}/bin/linux/amd64/kubectl" -o /usr/local/bin/kubectl
sudo chmod +x /usr/local/bin/kubectl
kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl >/dev/null
sudo cp fs/etc/bash_completion.d/k /etc/bash_completion.d/k

# kustomize
curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash >/dev/null
sudo mv kustomize /usr/local/bin/
kustomize completion bash | sudo tee /etc/bash_completion.d/kustomize >/dev/null
sudo cp fs/etc/bash_completion.d/kz /etc/bash_completion.d/kz

# helm
curl -fsSL "https://get.helm.sh/helm-v${helm_version}-linux-amd64.tar.gz" | sudo tar --exclude README.md --exclude LICENSE --strip-components 1 -C /usr/local/bin/ -xzf -
helm completion bash | sudo tee /etc/bash_completion.d/helm >/dev/null

# kpt
sudo curl -fsSL "https://github.com/GoogleContainerTools/kpt/releases/download/v${kpt_version}/kpt_linux_amd64" -o /usr/local/bin/kpt
sudo chmod +x /usr/local/bin/kpt
kpt completion bash | sudo tee /etc/bash_completion.d/kpt >/dev/null

# kind
sudo curl -fsSL "https://kind.sigs.k8s.io/dl/v${kind_version}/kind-linux-amd64" -o /usr/local/bin/kind
sudo chmod +x /usr/local/bin/kind
kind completion bash | sudo tee /etc/bash_completion.d/kind >/dev/null
