#!/bin/sh

set -eu

repository_url="https://github.com/ldelarue/.dotfiles.git"
repository_dir="${DOTFILES_DIR:-$HOME/.dotfiles}"
source_dir="$repository_dir/sources"
zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
mise_bin="$HOME/.local/bin/mise"

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

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

if [ ! -d "$zsh_custom/themes/powerlevel10k" ]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$zsh_custom/themes/powerlevel10k"
fi

if [ ! -d "$zsh_custom/plugins/zsh-syntax-highlighting" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$zsh_custom/plugins/zsh-syntax-highlighting"
fi

if [ ! -x "$mise_bin" ]; then
  curl -fsSL https://mise.run | sh
fi

"$mise_bin" install