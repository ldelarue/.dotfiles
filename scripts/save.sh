#!/bin/sh

cd sources || exit
find . -type f -print0 | while IFS= read -r -d '' f; do
  src="$PWD/$f"
  dst="$HOME/${f#./}"
  mkdir -p "$(dirname "$dst")"
  ln -sf "$src" "$dst"
done
