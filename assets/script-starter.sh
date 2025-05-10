#!/usr/bin/env bash
set -o nounset -o errexit -o errtrace -o pipefail

script_dir="$(dirname "$(readlink -f "$0")")"

usage="$(basename "$0") [-x] [-v VALUE]
"
description="Short description of the script
"
options="
  -x      enable xtrace
  -v      Some value (default: ${val:=42})
"

function help_text() {
  printf "\nUsage: %s\n%s\nOptions:%s" \
    "$usage" "$description" "$options" >&2
}

while getopts 'xv:' opt; do
  case "$opt" in
  x) set -o xtrace ;;
  v) val="$OPTARG" ;;
  ?) help_text && exit 127 ;;
  esac
done
shift "$((OPTIND - 1))"

echo "The value is $val"
