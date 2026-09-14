#!/bin/sh

set -eu

zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
mise_bin="$HOME/.local/bin/mise"

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
