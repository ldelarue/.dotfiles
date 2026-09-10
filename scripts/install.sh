#!/bin/sh

set -eu

repository_url="https://github.com/ldelarue/.dotfiles.git"
repository_dir="${DOTFILES_DIR:-$HOME/.dotfiles}"

if [ "$(uname -s)" != "Darwin" ]; then
  printf '%s\n' 'This installer only supports macOS.' >&2
  exit 1
fi

if ! command -v git >/dev/null 2>&1; then
  printf '%s\n' 'Git is required. Install Xcode Command Line Tools with: xcode-select --install' >&2
  exit 1
fi

if [ -e "$repository_dir" ] && [ ! -d "$repository_dir/.git" ]; then
  printf 'The destination exists and is not a Git repository: %s\n' "$repository_dir" >&2
  exit 1
fi

if [ -d "$repository_dir/.git" ]; then
  git -C "$repository_dir" pull --ff-only
else
  git clone "$repository_url" "$repository_dir"
fi

"$repository_dir/scripts/install-deps.sh"
exec "$repository_dir/scripts/save.sh"