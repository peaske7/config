# dotfiles

Managed by [chezmoi](https://www.chezmoi.io/). Source lives at `~/.local/share/chezmoi`; `chezmoi apply` materializes it into `$HOME`.

This README is a flat map of the muscle memory baked into the config — what each keymap and alias does, and where to find it. The configs themselves are the source of truth.

## Philosophy

<!--
TODO: Write 4-8 lines on what this setup is *for*. The README around it is mechanical
(here's what the keymaps do); this section is the part only you can write.

Things worth saying out loud — pick what's true:
  - What workflows are you optimizing for? (Obsidian + nvim, tmux-driven dev,
    Claude/sidekick side-by-side, Japanese text, …)
  - What did you deliberately not adopt, and why? (e.g. you dropped Telescope
    for snacks.picker — what did you gain?)
  - What's the leader-key namespace logic? (b/c/g/t/s/q/x/o — there's a
    grouping intent here, and naming it once helps future-you stay consistent.)
  - One or two opinions you hold strongly: e.g. "jk to exit insert", "centered
    half-page jumps", "wrap-aware j/k by default".

Keep it terse. Voice matters more than completeness.
-->

## Layout

```
dot_aliasrc          shell aliases + functions (sourced from .zshrc)
dot_zshrc            zsh entrypoint
dot_tmux.conf        tmux config
dot_vimrc            minimal vim config (fallback when nvim isn't around)
dot_config/
  nvim/              neovim config (lazy.nvim plugin manager)
  alacritty/         terminal emulator
  starship.toml      shell prompt
  workmux/           tmux session presets
```

## Neovim

### Conventions

- **Leader**: `<Space>` (also localleader)
- **Insert-mode escape**: `jk`
- **Plugin manager**: [lazy.nvim](https://github.com/folke/lazy.nvim)
- **Picker**: [snacks.nvim](https://github.com/folke/snacks.nvim) (replaces Telescope)
- **Completion**: [blink.cmp](https://github.com/Saghen/blink.cmp)
- **Theme**: [kanagawa](https://github.com/rebelot/kanagawa.nvim) (`wave`)

### Leader namespaces

Surfaced in [which-key](https://github.com/folke/which-key.nvim) — hit `<leader>` and wait.

| Prefix | Group |
|--------|-------|
| `<leader>b` | buffers |
| `<leader>c` | code / chat |
| `<leader>g` | git |
| `<leader>t` | trees (nvim-tree) |
| `<leader>s` | search (snacks picker) |
| `<leader>q` | quickfix |
| `<leader>x` | trouble |
| `<leader>o` | obsidian |
| `<leader>e` | sidekick (AI CLIs) |
| `<leader>w` | write date/time |

### Core keymaps (init.lua)

| Keys | Mode | Action |
|------|------|--------|
| `jk` | i | exit insert mode |
| `j` / `k` | n | wrap-aware down/up |
| `J` | n | join line, keep cursor |
| `<C-d>` / `<C-u>` | n | half-page down/up, centered |
| `n` / `N` | n | next/prev search, centered |
| `<Esc>` | t | exit terminal mode |
| `//` | x | search visual selection |
| `<leader>h` | n | toggle search highlight |
| `<leader>wt` | n | write today (`MM/DD (Day)`) |
| `<leader>wd` | n | write date (`MM/DD`) |
| `<leader>ww` | n | write weekday |
| `<leader>wfd` | n | write full date (`YYYY/MM/DD`) |
| `<leader>cs` | x | send selection to last-used tmux pane (cached) |
| `<leader>cS` | x | send selection — force pane re-pick |

`<leader>cs` / `<leader>cS` use tmux `display-panes` to pick a target pane on first use, then cache the pane id at `$XDG_CACHE_HOME/nvim_send_last_pane`. Useful for piping context into Claude/REPL/zsh running in another pane.

### Search & navigation — snacks.picker

| Keys | Action |
|------|--------|
| `<leader>sf` | files |
| `<leader>sg` | live grep (`v` mode: grep visual selection) |
| `<leader>sc` | recent files |
| `<leader>sb` | buffers |
| `<leader>sr` | resume last picker |
| `<leader>sd` | diagnostics |
| `<leader>sq` | quickfix |
| `<leader>se` | registers |
| `<leader>sh` | highlights |
| `<leader>sj` | jumplist |
| `<leader>st` | todo comments |
| `<leader>svc` | git commits |
| `<leader>svb` | git branches |
| `<leader>svss` | git status |

### LSP

| Keys | Action |
|------|--------|
| `gd` | goto definition (snacks) |
| `grr` | references |
| `gri` | implementations |
| `gO` | document symbols |
| `K` | hover (nvim 0.12 default) |
| `<leader>ca` | code action |
| `<leader>rn` | rename (inc-rename, inline preview) |
| `<leader>qf` | apply preferred quickfix |
| `<leader>ff` | format file (conform.nvim) |

Servers installed via Mason. Custom handling for `lua_ls` (vim runtime) and `svelte` (notifies on `.ts`/`.js` writes). Diagnostics run through [nvim-lint](https://github.com/mfussenegger/nvim-lint) on save/read/insert-leave.

### Git

`gitsigns` + `diffview` + `git-conflict`. Hunk navigation auto-focuses the right pane in diffview review mode.

| Keys | Action |
|------|--------|
| `]c` / `[c` | next/prev hunk (or diff line in diffview) |
| `]f` / `[f` | next/prev file in diffview |
| `<leader>gl` | toggle line blame |
| `<leader>gd` | toggle working-tree diff |
| `<leader>gr` | toggle branch review (diff vs `merge-base main HEAD`) |
| `<leader>gh` | file history (current file) |
| `<leader>gH` | file history (repo) |
| `<leader>go` | open file/line on GitHub (snacks gitbrowse) |

### Buffers — barbar

| Keys | Action |
|------|--------|
| `<leader>n` / `<leader>p` | next/prev buffer |
| `<leader>d` | delete buffer |
| `<leader>bd` | pick buffer to delete |
| `<leader>bc` | close all but current/pinned |
| `<leader>1`–`<leader>9` | jump to buffer N |

### File tree — nvim-tree

| Keys | Action |
|------|--------|
| `<leader>tt` | toggle tree |
| `<leader>tf` | reveal current file in tree |
| `<leader>te` | toggle + reveal |
| `<leader>tr` | refresh |

### Trouble & diagnostics

| Keys | Action |
|------|--------|
| `<leader>xx` | open trouble |
| `<leader>xw` | workspace diagnostics |
| `<leader>xd` | document diagnostics |
| `<leader>xq` | quickfix |
| `<leader>xt` | todos |

### Obsidian (`~/Obsidian` vault)

| Keys | Action |
|------|--------|
| `<leader>oo` | open in Obsidian app |
| `<leader>on` | new note |
| `<leader>os` | search vault |
| `<leader>oq` | quick switch |
| `<leader>ot` / `<leader>oy` | today / yesterday |
| `<leader>od` | dailies |
| `<leader>ob` | backlinks |
| `<leader>og` | tags |
| `<leader>ol` | follow link |
| `<leader>om` | template |
| `<leader>op` | paste image |

New notes land in `Inbox/`. Daily notes use `YYYY/MM/DD.md`. Picker integration via `<C-x>` (new) and `<C-l>` (insert link).

### Sidekick (AI CLIs)

| Keys | Action |
|------|--------|
| `<Tab>` | apply next edit suggestion (falls back to `<Tab>`) |
| `<C-.>` | focus sidekick |
| `<leader>ea` | toggle CLI |
| `<leader>ec` | toggle Claude |
| `<leader>es` | select CLI |
| `<leader>ed` | detach session |
| `<leader>et` | send `{this}` (current node) |
| `<leader>ef` | send file |
| `<leader>ev` | send visual selection (x mode) |
| `<leader>ep` | select prompt |

### Movement — flash.nvim

| Keys | Mode | Action |
|------|------|--------|
| `s` | n/x/o | flash jump |
| `S` | n/x/o | treesitter flash |
| `R` | o/x | treesitter search |
| `<C-s>` | c | toggle flash in search |

### Folding — ufo

`zR` open all · `zM` close all · folding via treesitter, indent fallback.

### Terminal

`<C-/>` (or `<C-_>` through tmux) toggles snacks terminal. Terminals open in insert mode automatically.

### Other plugins

- `vim-sandwich` — surround
- `nvim-autopairs` + `nvim-ts-autotag` — bracket/tag pairs (Rust angle brackets are conditional, won't trigger after word chars)
- `nvim-highlight-colors` — inline color preview
- `arrow.nvim` — bookmarks (`<leader>a` global, `m` per-buffer)
- `nvim-bqf` — better quickfix
- `format-ts-errors.nvim` — readable TS errors
- `vim-wakatime` — time tracking

## Aliases & functions (`dot_aliasrc`)

### Workflow functions (the interesting ones)

| Command | What it does |
|---------|--------------|
| `dev` | `nvim .` + tmux split running `claude` (40% width right) |
| `wt <branch> [base]` | git worktree at `../<repo>__worktrees/<branch>`. `wt -l` list, `wt -r` remove |
| `gco` / `gc` | fzf-pick a branch (sorted by commit date) and check it out |
| `obs [path]` | cd into Obsidian vault, open in nvim |
| `obsd` | open today's Obsidian daily note |
| `kp <port>` | kill the process on a port |
| `mkd <dir>` | mkdir + zoxide jump into it |
| `rembga <files>` | bg-remove image(s) via [rembg](https://github.com/danielgatis/rembg) |
| `grename <new>` / `grename <old> <new>` | rename branch locally + on origin |
| `gdnl` | git diff excluding lockfiles |
| `gddnl` | git diff vs default branch, excluding lockfiles |

### Quick aliases

**Shell**: `c` (clear) · `e` (`$EDITOR .`) · `timestamp` (YYYYMMDDHHMMSS)

**chezmoi**: `ch` `che` `cha` (apply) `chu` (update) `chc` (cd) · `chez` (edit zshrc) · `chen` (edit nvim)

**git basics**: `gss` (status short) · `gaa` (add all) · `gcam` (commit -am) · `gbd` (branch -D) · `gm` (merge) · `gl` (pull) · `gp` (push) · `gpsup` (push -u origin current) · `gf` (fetch all) · `gfp` (fetch --prune)

**git checkout**: `gcb` (checkout -b) · `gci` (interactive via fzf) · `gcd` (checkout default) · `gsd` (set origin/HEAD)

**git diff**: `gd` · `gdd` (vs default) · `gdds` (vs default --stat) · `gdi` (interactive)

**git rebase/reset**: `grbi` (interactive --autosquash) · `grbc` (continue) · `gafr` (add-all + fixup HEAD + rebase last 2) · `grh` (reset --hard)

**git stash**: `gsta` (push) · `gstaa` (apply) · `gstc` (clear)

**git log/merge**: `glgg` (log graph) · `gmtl` (mergetool with `nvimdiff2`)

**docker**: `dsa` (stop all) · `dra` (rm all)

**mutagen**: `mto` (point to dir) · `mrs` (restore) · `mst` (status)

**tmux**: `ta` (attach) · `tns` (new session) · `trl` (reload conf) · `wm` (workmux)

**ssh**: `es` (edit `~/.ssh/config`)

**misc**: `ag` (open Antigravity with GPU flags)

## Applying changes

```sh
chezmoi edit ~/.zshrc        # or use `che ~/.zshrc` / `chez`
chezmoi apply -v             # or `cha`
chezmoi update -v            # pull + apply
```
