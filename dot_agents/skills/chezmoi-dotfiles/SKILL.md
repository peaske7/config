---
name: chezmoi-dotfiles
description: Edit, apply, and add files in Jay's chezmoi-managed dotfiles. Use when user wants to change shell config, zshrc, aliases, nvim config, tmux, or any file under ~/.config that's tracked by chezmoi.
---

# Chezmoi Dotfiles

## Source location

`~/.local/share/chezmoi/` — `chezmoi apply` materializes it into `$HOME`.

Read `~/.local/share/chezmoi/README.md` first for the keymap/alias map.

## Layout

```
dot_aliasrc          → ~/.aliasrc       (sourced from .zshrc)
dot_zshrc            → ~/.zshrc
dot_tmux.conf        → ~/.tmux.conf
dot_vimrc            → ~/.vimrc
dot_config/          → ~/.config/
  nvim/              → ~/.config/nvim/
  alacritty/         → ~/.config/alacritty/
  starship.toml      → ~/.config/starship.toml
  workmux/           → ~/.config/workmux/
private_Library/     → ~/Library/       (private_ = chmod 600 / not world-readable)
```

## Naming conventions

- `dot_X` → `~/.X`
- `private_X` → `~/X` with restricted perms
- No prefix for non-dot files
- Combine: `private_dot_ssh/` → `~/.ssh/` private

## Aliases (already on PATH)

| Alias | Command |
|-------|---------|
| `ch` | `chezmoi` |
| `che` | `chezmoi edit` |
| `cha` | `chezmoi apply -v` |
| `chu` | `chezmoi update -v` (pull + apply) |
| `chc` | `chezmoi cd` |
| `chez` | `chezmoi edit ~/.zshrc` |
| `chen` | `chezmoi edit ~/.config/nvim` |

Use the destination path with `chezmoi edit`, not the `dot_` source name. Chezmoi resolves it.

## Workflows

### Edit a tracked file

```bash
chezmoi edit ~/.zshrc        # opens source file in $EDITOR
chezmoi apply -v             # write changes to $HOME
```

When editing programmatically (no $EDITOR), edit the source file directly:

```bash
# resolve source path
chezmoi source-path ~/.zshrc
# edit that path with the Edit tool, then:
chezmoi apply -v
```

### Add a new file to chezmoi

```bash
chezmoi add ~/.config/some-tool/config.toml
```

Chezmoi copies it into the source dir with the right `dot_` / `private_` prefix.

### Check what would change

```bash
chezmoi diff                 # diff target vs destination
chezmoi status               # short status
chezmoi verify               # exit 0 if in sync
```

### Pull upstream changes

```bash
chezmoi update -v            # git pull + apply
# or:
chezmoi cd && git pull && exit && chezmoi apply -v
```

### Stop tracking a file

```bash
chezmoi forget ~/.some-file  # removes from source, leaves destination
```

## Machine-local pattern

For machine-specific config that shouldn't be tracked:

- `~/.aliasrc` (tracked) sources `~/.aliasrc.local` (untracked) at the bottom
- Put per-machine functions/aliases/secrets in `~/.aliasrc.local`
- Don't add `~/.aliasrc.local` to chezmoi

Same pattern works for any `*rc` file — source a `.local` sibling.

## Gotchas

- `chezmoi edit` opens the **source** file. Editing `~/.zshrc` directly gets overwritten on next `chezmoi apply`.
- After `chezmoi apply`, run `source ~/.zshrc` (or `exec zsh`) to reload the running shell.
- The repo has its own `.git`. Use `chezmoi cd` then `git ...` to commit dotfile changes — they don't show up in unrelated repo `git status`.
- `chezmoi apply` is idempotent; safe to run any time.
