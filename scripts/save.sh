#!/bin/sh

set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
source_dir="$script_dir/../sources"

find "$source_dir" -type f -exec sh -c '
  source_root=$1
  shift

  for source_path do
    relative_path=${source_path#"$source_root"/}
    destination_path=$HOME/$relative_path
    mkdir -p "$(dirname "$destination_path")"
    ln -sfn "$source_path" "$destination_path"
  done
' sh "$source_dir" {} +
