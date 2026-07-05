# PowerShell profile — Windows counterpart to ~/.aliasrc (managed by chezmoi).
# Aliases can't take arguments in PowerShell, so the zsh aliases are ported as
# functions with @args passthrough. Mac/tmux-only shortcuts (ag, mutagen, tmux,
# workmux, rembga) are intentionally omitted.

# ----------------------------
# shadowed built-in aliases
# ----------------------------
# PowerShell ships aliases that outrank functions during command resolution.
# Remove the ones whose names we reuse for git shortcuts so our functions win.
foreach ($a in 'gp', 'gc', 'gl', 'gm', 'gci') {
  if (Test-Path "Alias:$a") { Remove-Item "Alias:$a" -Force -ErrorAction SilentlyContinue }
}

# ----------------------------
# editor
# ----------------------------
$env:EDITOR = if (Get-Command nvim -ErrorAction SilentlyContinue) { 'nvim' } else { 'notepad' }

# ----------------------------
# interactive UX (zsh-like)
# ----------------------------
# PSReadLine auto-loads only in interactive sessions, so this block is skipped
# in `pwsh -Command`/piped runs — exactly when we don't want key handlers.
if (Get-Module PSReadLine) {
  Set-PSReadLineOption -PredictionSource History        # zsh-autosuggestions feel
  Set-PSReadLineOption -PredictionViewStyle InlineView  # grey ghost text inline
  Set-PSReadLineOption -HistorySearchCursorMovesToEnd
  # type a prefix, then Up/Down walks matching history (zsh substring search)
  Set-PSReadLineKeyHandler -Key UpArrow   -Function HistorySearchBackward
  Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
  Set-PSReadLineKeyHandler -Key Tab       -Function MenuComplete  # auto_menu feel
}

# starship prompt (scoop install starship)
if (Get-Command starship -ErrorAction SilentlyContinue) {
  Invoke-Expression (&starship init powershell)
}

# zoxide — provides `z` / `zi` (scoop install zoxide)
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
  Invoke-Expression (& { (zoxide init powershell | Out-String) })
}

# ----------------------------
# git helpers
# ----------------------------
function git_current_branch { (git rev-parse --abbrev-ref HEAD 2>$null) }
function git_default_branch { (git rev-parse --abbrev-ref origin/HEAD 2>$null) -replace '^origin/', '' }
function git_set_default_branch { git remote set-head origin -a }

# ----------------------------
# functions
# ----------------------------
# [K]ill [P]ort — kill whatever is listening on a TCP port
function kp {
  param([int]$Port)
  Get-NetTCPConnection -LocalPort $Port -ErrorAction SilentlyContinue |
    Select-Object -ExpandProperty OwningProcess -Unique |
    ForEach-Object { Stop-Process -Id $_ -Force -ErrorAction SilentlyContinue }
}

# [M]a[K]e [D]ir and cd into it
function mkd {
  param([string]$Path)
  New-Item -ItemType Directory -Path $Path -Force | Out-Null
  Set-Location $Path
}

# [T]ime[S]tamp
function timestamp { Get-Date -Format 'yyyyMMddHHmmss' }

function e  { & $env:EDITOR . }                          # [E]dit cwd
function es { & $env:EDITOR "$HOME/.ssh/config" }        # [E]dit [S]sh config
Set-Alias c Clear-Host

# [OBS]idian
function obs {
  Set-Location "$HOME/Obsidian"
  if ($args) { & $env:EDITOR @args } else { & $env:EDITOR . }
}
function obsd { Set-Location "$HOME/Obsidian"; & $env:EDITOR '+Obsidian today' }

# git worktree — mirrors the zsh `wt`:
#   wt feat/x            new branch from origin/<default>
#   wt fix/y origin/main new branch from a specific base
#   wt fix/y existing    worktree from an existing branch
#   wt -l                list worktrees
#   wt -r <path|branch>  remove a worktree
function wt {
  param([Parameter(ValueFromRemainingArguments)]$a)
  if (-not $a) {
    Write-Host "Usage: wt <branch> [base]"
    Write-Host "       wt -l              # list worktrees"
    Write-Host "       wt -r <path>       # remove worktree"
    return
  }
  $repo = git rev-parse --show-toplevel 2>$null
  if (-not $repo) { Write-Host "Not in a git repo"; return }

  if ($a[0] -eq '-l') { git worktree list; return }
  if ($a[0] -eq '-r') {
    if (-not $a[1]) { Write-Host "Usage: wt -r <path|branch>"; return }
    git worktree remove $a[1]; git worktree prune; return
  }

  $repoName = Split-Path $repo -Leaf
  $wtDir    = Join-Path (Split-Path $repo -Parent) "${repoName}__worktrees"
  $branch   = $a[0]
  $base     = if ($a[1]) { $a[1] } else { "origin/$(git_default_branch)" }
  $folder   = $branch -replace '/', '-'

  git fetch --prune --quiet
  New-Item -ItemType Directory -Path $wtDir -Force | Out-Null

  git show-ref --verify --quiet "refs/heads/$branch"; $localExists = $?
  git show-ref --verify --quiet "refs/remotes/origin/$branch"; $remoteExists = $?
  if ($localExists -or $remoteExists) {
    git worktree add (Join-Path $wtDir $folder) $branch
  } else {
    git worktree add (Join-Path $wtDir $folder) -b $branch $base
  }
}

# ----------------------------
# chezmoi
# ----------------------------
function ch   { chezmoi @args }
function che  { chezmoi edit @args }
function cha  { chezmoi apply -v @args }
function chu  { chezmoi update -v @args }
function chc  { chezmoi cd }
function chen { chezmoi edit "$HOME/.config/nvim" }        # [CH]ezmoi [E]dit [N]vim
function chep { chezmoi edit $PROFILE.CurrentUserAllHosts } # [CH]ezmoi [E]dit [P]rofile

# ----------------------------
# docker
# ----------------------------
function dsa { $ids = docker ps -aq; if ($ids) { docker stop $ids } }  # [D]ocker [S]top [A]ll
function dra { $ids = docker ps -aq; if ($ids) { docker rm   $ids } }  # [D]ocker [R]emove [A]ll

# ----------------------------
# git
# ----------------------------
function gm    { git merge @args }
function gss   { git status --short @args }
function gaa   { git add --all @args }
function gcam  { git commit -a -m @args }
function gbd   { git branch -D @args }
function gsd   { git_set_default_branch }

function gcb   { git checkout -b @args }                       # create branch
function gcd   { git checkout (git_default_branch) }           # checkout default
function gfp   { git fetch --prune @args }

function gd    { git diff @args }
function gdd   { git diff (git_default_branch) @args }         # diff vs default
function gdds  { git diff (git_default_branch) --stat @args }  # diff vs default, stat

function gl    { git pull @args }
function gp    { git push @args }
function gpsup { git push -u origin (git_current_branch) }
function glgg  { git log --graph --decorate --all @args }
function grbi  { git rebase -i --autosquash @args }
function grbc  { git rebase --continue @args }
function gafr  { git add --all && git commit --fixup HEAD && git rebase -i --autosquash HEAD~2 }
function grh   { git reset --hard @args }
function gsta  { git stash push @args }
function gstc  { git stash clear @args }
function gstaa { git stash apply @args }
function gf    { git fetch --all @args }
function gmtl  { git mergetool --no-prompt --tool=nvimdiff2 @args }

# fzf-driven checkout (requires fzf). `gc <ref>` checks out directly.
function gc {
  param([Parameter(ValueFromRemainingArguments)]$rest)
  if ($rest) { git checkout @rest; return }
  $branch = git branch -a --sort=-committerdate |
    Where-Object { $_ -notmatch 'HEAD' } |
    ForEach-Object { ($_ -replace 'remotes/origin/', '' -replace '^[\*\+ ]+', '').Trim() } |
    Select-Object -Unique |
    fzf --height=40% --reverse --preview 'git log --oneline --decorate --color -10 {}' --preview-window 'right:50%:wrap'
  if ($branch) { git checkout $branch.Trim() }
}
function gco { gc @args }
function gci { $b = git branch -a | fzf; if ($b) { git checkout $b.Trim() } }  # [G]it [C]heckout [I]nteractive
function gdi { $b = git branch -a | fzf; if ($b) { git diff     $b.Trim() } }  # [G]it [D]iff [I]nteractive

# ----------------------------
# machine-local additions (untracked by chezmoi)
# ----------------------------
$local = Join-Path (Split-Path $PROFILE.CurrentUserAllHosts) 'profile.local.ps1'
if (Test-Path $local) { . $local }
