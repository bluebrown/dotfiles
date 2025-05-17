#!/usr/bin/env bash
exec apt-get install "$@" \
  zstd curl git unzip manpages man-db \
  bash-completion build-essential tmux \
  jq gnuplot \
  groff # groff is required by bat
