#!/usr/bin/env bash

set -euo pipefail

echo "Running setup script, this may take a moment..."

bash scripts/fonts.sh
bash scripts/tools_base.sh
bash scripts/configure.sh
bash scripts/tools_kube.sh
bash scripts/tools_azure.sh
bash scripts/tools_dev.sh

if test ! -z "$(uname -a | grep -o WSL2)"; then
  bash scripts/wsl.sh
fi

bash scripts/git.sh

echo ""
echo "All set! Happy coding :)"
