# Dotfiles

Install or update the dotfiles on macOS with one of these commands:

```sh
curl -fsSL https://raw.githubusercontent.com/ldelarue/.dotfiles/main/scripts/install.sh | sh
wget -qO- https://raw.githubusercontent.com/ldelarue/.dotfiles/main/scripts/install.sh | sh
```

The installer checks that it is running on macOS and that Git is available, then
clones or fast-forwards the repository at `~/.dotfiles` before creating the
symbolic links. Set `DOTFILES_DIR` to use a different installation directory.
