#!/usr/bin/env bash
set -Eeuo pipefail

version=3.31.0
file=kata-static-$version-amd64.tar.zst
kata_url=https://github.com/kata-containers/kata-containers/releases/download/$version/$file
containerd_confd=/etc/containerd.d/

apt install curl zstd

cd /tmp

if ! [ -f kata.tar.zst ]; then
  curl -o kata.tar.zst -L $kata_url
fi

if ! [ -f kata.tar ]; then
  zstd -d kata.tar.zst
fi

if ! [ -d /opt/kata/bin ]; then
  mkdir -p /opt/kata
  tar -C /opt/kata --strip-components 3 -xf kata.tar
fi

for bin in kata-runtime containerd-shim-kata-v2 kata-collect-data.sh; do
  src=/opt/kata/bin/$bin
  dst=/usr/local/bin/$bin
  if ! [ -L $dst ]; then
    ln -s $src $dst
  fi
done

mkdir -p "$containerd_confd"

cat >"$containerd_confd/kata.toml" <<'EOF'
[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.kata]
runtime_type = "io.containerd.kata.v2"
privileged_without_host_devices = true
pod_annotations = ["io.katacontainers.*"]
container_annotations = ["io.katacontainers.*"]
[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.kata.options]
ConfigPath = "/opt/kata/share/defaults/kata-containers/configuration.toml"
EOF
