# Dotfiles

## How to install or update

Install or update the dotfiles on macOS with one of these commands:

```sh
curl -fsSL https://raw.githubusercontent.com/ldelarue/.dotfiles/main/scripts/install.sh | sh
wget -qO- https://raw.githubusercontent.com/ldelarue/.dotfiles/main/scripts/install.sh | sh
```

The installer checks that it is running on macOS and that Git is available, then
clones or fast-forwards the repository at `~/.dotfiles`, creates the symbolic
links, and installs the configured Mise tools. Set `DOTFILES_DIR` to use a
different installation directory.

## How to restore agent skills on a new machine

Agent skills (installed via `gh skill install`) are tracked in
[skills/skills.lock.json](skills/skills.lock.json). To reinstall them all:

```sh
mise run restore-skills
```

## How to regenerate the skills lockfile

After installing, updating, or removing an agent skill with `gh skill`, refresh
the lockfile so it stays reproducible:

```sh
mise run skills-lock
```

This Mise task (defined in
[sources/.config/mise/config.toml](sources/.config/mise/config.toml)) writes
the current `gh skill list` output to [skills/skills.lock.json](skills/skills.lock.json).

## Reference: repository layout

| Path | Purpose |
|---|---|
| `scripts/install.sh` | Entry point: clones/updates the repo, syncs dotfiles, then installs dependencies |
| `scripts/install-deps.sh` | Installs oh-my-zsh, the powerlevel10k theme, the zsh-syntax-highlighting plugin, Mise, and all tools declared in the global Mise configuration |
| `scripts/save.sh` | Symlinks every file under `sources/` to the matching path under `$HOME` |
| `sources/` | Mirrors the `$HOME` layout; each file here is symlinked into place by `save.sh` |
| `skills/skills.lock.json` | Reproducible manifest of installed `gh skill` agent skills |

## Explanation: why machine-specific secrets aren't in `sources/.zshrc`

Everything under `sources/` is committed to this repository and symlinked into
`$HOME`, so it must not contain secrets or machine-specific values. Those
instead go in `~/.zshrc.local`, an untracked file outside `sources/` that
`sources/.zshrc` sources conditionally if present.

