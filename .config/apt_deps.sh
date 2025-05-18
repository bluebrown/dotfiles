#!/usr/bin/env bash

exec apt-get install -y --no-install-recommends \
	zstd curl git unzip manpages man-db \
	bash-completion build-essential tmux \
	jq groff # groff is required by bat ?!

# gnuplot
