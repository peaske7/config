# Neovim 0.12 Config Refactor Plan

## Context

Modernize `dot_config/nvim/` to align with Neovim 0.12 built-in capabilities.
Sources: justinhj's 0.12 refresh article, neovim/neovim#33972 (inline completion),
`:help :Undotree` (built-in undotree plugin).

Current file layout:

```
dot_config/nvim/
  init.lua                              -- main config + lazy.nvim plugin specs
  after/plugin/lsp.lua                  -- LSP keymaps, config, mason setup
  lua/peaske7/plugins/buffers.lua       -- barbar
  lua/peaske7/plugins/colortheme.lua    -- gruvbox-material
  lua/peaske7/plugins/markdown.lua      -- markdown-preview, femaco, mdlink
  lua/peaske7/plugins/nvim_tree.lua     -- nvim-tree + lsp-file-operations
  lua/peaske7/plugins/trouble.lua       -- trouble v2
```

---

## Phase 1 — Drop-in built-in replacements (low risk)

### 1.1 Replace `mbbill/undotree` with built-in `nvim.undotree`

**Files:** `init.lua:608-615`

**Remove:**
```lua
{
  "mbbill/undotree",
  config = function()
    vim.keymap.set('n', '<leader>tu', vim.cmd.UndotreeToggle, {
      desc = "open [t]ree [u]ndo"
    })
  end
},
```

**Add** (anywhere after lazy.setup, e.g. at the end of init.lua or in after/plugin/):
```lua
-- Built-in undotree (nvim 0.12+)
vim.keymap.set('n', '<leader>tu', function()
  vim.cmd.packadd('nvim.undotree')
  vim.cmd.Undotree()
end, { desc = "open [t]ree [u]ndo" })
```

**Verify:** open a file, make several edits, press `<leader>tu`, confirm the
undo tree window opens and cursor movement changes undo state.

---

### 1.2 Remove the `vim.treesitter.get_node_text` monkey patch

**File:** `init.lua:140-147`

**Remove:**
```lua
do
  local orig_get_node_text = vim.treesitter.get_node_text
  vim.treesitter.get_node_text = function(node, source, opts)
    if node == nil then return "" end
    return orig_get_node_text(node, source, opts)
  end
end
```

**Verify:** open files in lua, typescript, markdown; confirm no
`nil node` errors in `:messages`. If errors reappear, restore and
file an upstream issue.

---

### 1.3 Test whether the manual Tree-sitter FileType autocmd is still needed

**File:** `init.lua:149-180`

On 0.12, native Tree-sitter highlighting is activated automatically for
parsers shipped with Neovim and for any parser installed via `:TSInstall`.
The manual `vim.treesitter.start()` call may now be redundant.

**Test:** comment out the entire `FileType` autocmd block (lines 149-180),
restart, open files in each listed filetype, confirm highlighting works.

- If highlighting works without it: **delete the block**.
- If some filetypes lose highlighting: keep the block but trim the
  `pattern` list to only the filetypes that actually need it.

---

### 1.4 Audit Snacks Tree-sitter workarounds

**File:** `init.lua:267-279`

```lua
image = { enabled = false },
scope = {
  treesitter = {
    injections = false,
  },
},
```

**Test:** re-enable each one individually and check for crashes.
Remove the workaround if the underlying issue is fixed in your current
Snacks + Neovim version.

---

## Phase 2 — Modernize LSP architecture (medium risk)

### 2.1 Refactor LSP server setup to use `vim.lsp.config()` + `vim.lsp.enable()`

**File:** `after/plugin/lsp.lua:29-64`

**Current approach:** mason-lspconfig `handlers` table calls
`require('lspconfig')[server].setup({})` for each server.

**Target approach:**

1. Keep `mason.setup()` for binary installation only.
2. Remove `mason-lspconfig` handlers entirely.
3. Define server configs using the native convention.
4. Enable servers explicitly.

**Step 2.1a — Create `lsp/` directory files for custom servers:**

Create `dot_config/nvim/lsp/lua_ls.lua`:
```lua
return {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = { { '.luarc.json', '.luarc.jsonc' }, '.git' },
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      workspace = {
        checkThirdParty = false,
        library = { vim.env.VIMRUNTIME },
      },
    },
  },
}
```

Create `dot_config/nvim/lsp/svelte.lua`:
```lua
return {
  cmd = { 'svelteserver', '--stdio' },
  filetypes = { 'svelte' },
  root_markers = { 'svelte.config.js', 'svelte.config.cjs', '.git' },
}
```

**Step 2.1b — Replace after/plugin/lsp.lua server setup section:**

Replace lines 28-64 of `after/plugin/lsp.lua` with:
```lua
-- Mason: install LSP server binaries (installation only, not config)
require('mason').setup()

-- Enable servers (configs come from lsp/*.lua or vim.lsp.config())
vim.lsp.enable({
  'lua_ls',
  'svelte',
  -- add other servers you use here
  -- 'ts_ls', 'rust_analyzer', 'gopls', etc.
})
```

**Step 2.1c — Handle svelte's BufWritePost notification:**

Move the svelte `on_attach` logic into the LspAttach autocmd
(already in `after/plugin/lsp.lua:2-14`):
```lua
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local buf = ev.buf
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local opts = function(desc) return { buffer = buf, remap = false, desc = desc } end

    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts("[c]ode [a]ction"))
    vim.keymap.set("n", "<leader>rn", function()
      return ":IncRename " .. vim.fn.expand("<cword>")
    end, { buffer = buf, expr = true, remap = false, desc = "[r]ename [n]ode" })

    -- Svelte: notify on ts/js changes
    if client and client.name == 'svelte' then
      vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = { "*.js", "*.ts" },
        callback = function(ctx)
          client:notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
        end,
      })
    end
  end,
})
```

**Step 2.1d — Evaluate removing `mason-lspconfig` dependency:**

After the above works, remove `'williamboman/mason-lspconfig.nvim'` from
`init.lua:365` and its `require` from `after/plugin/lsp.lua`.

If you want Mason to still auto-install servers for you, keep
`mason-lspconfig` but only use its `ensure_installed` list, not `handlers`.

**Verify:** `:checkhealth vim.lsp` shows "Enabled Configurations" for each
server. Open files of each type and confirm LSP attaches.

---

### 2.2 Decide on LSP navigation keymaps

**Files:** `init.lua:319-322`, `after/plugin/lsp.lua:7`

You currently override built-in `gd`, `grr`, `gri`, `gO` with Snacks pickers.
Neovim 0.12 maps these natively.

**Option A (simplify):** Remove lines 319-322 from init.lua. Use native
keymaps. This is the "accept defaults" path.

**Option B (keep pickers):** Keep lines 319-322 intentionally. Update the
comment in `after/plugin/lsp.lua:7` to say:

```lua
-- nvim 0.12 provides gd, grr, gri, gO defaults;
-- we override them with Snacks pickers in init.lua for list-oriented UX
```

**Recommendation:** Option A unless you've found Snacks picker navigation
meaningfully better than the native LSP jumplist behavior.

---

## Phase 3 — Completion stack simplification (higher risk, experimental)

### 3.1 Try native `vim.lsp.inline_completion` for Copilot AI suggestions

**Precondition:** your Copilot backend must support `textDocument/inlineCompletion`.
If using `copilot-language-server` from npm, it does.

**Add to LspAttach autocmd** (in `after/plugin/lsp.lua`):
```lua
-- Enable native inline completion for servers that support it
if client and client:supports_method('textDocument/inlineCompletion') then
  vim.lsp.inline_completion.enable(true, ev.buf)
end
```

**Add an accept keymap** (in init.lua or after/plugin/):
```lua
vim.keymap.set("i", "<C-CR>", function()
  if vim.lsp.inline_completion.get() then
    return
  end
  return "<C-CR>"
end, { expr = true, replace_keycodes = true, desc = "Accept inline completion" })
```

**If this works well, consider:**
- Removing `zbirenbaum/copilot.lua` (`init.lua:426-436`)
- Removing `giuxtaposition/blink-cmp-copilot` (`init.lua:443-446`)
- Removing the `copilot` source from blink (`init.lua:460-467`)

**If it conflicts with blink popup completion or doesn't feel right:**
Revert and keep the current stack. This is explicitly experimental.

---

### 3.2 Consider native `vim.lsp.completion.enable()` (long term)

This is not recommended for this refactor cycle. Blink provides richer UX
(multi-source, snippets, Copilot integration, custom keymaps). The native
completion is good but not a full replacement yet.

**Action:** no change now. Revisit in a future cycle.

---

## Phase 4 — Config hygiene (low risk)

### 4.1 Move `.rgignore` creation out of init.lua

**File:** `init.lua:217-230`

This block creates `~/.rgignore` as a side effect during editor startup.

**Option A (preferred):** Manage `~/.rgignore` through chezmoi as a dotfile
(e.g. `dot_rgignore` in the chezmoi root). Delete lines 217-230 from init.lua.

**Option B:** Move it to a one-time setup script or command, not run on
every startup.

---

### 4.2 Update `completeopt`

**File:** `init.lua:31`

```lua
vim.o.completeopt = 'menuone,noselect'
```

The article and 0.12 docs recommend `popup` for native completion:
```lua
vim.o.completeopt = 'menuone,noselect,popup'
```

This is a minor improvement but aligns with the 0.12 recommendation.
Note: blink may override this; verify it doesn't conflict.

---

### 4.3 Replace deprecated `vim.loop` with `vim.uv`

**File:** `init.lua:237`

```lua
if not vim.loop.fs_stat(lazypath) then
```

`vim.loop` was soft-deprecated in favor of `vim.uv` since 0.10.

Replace with:
```lua
if not vim.uv.fs_stat(lazypath) then
```

---

### 4.4 Clean up dead/commented code

**Files:**
- `init.lua:78-81` — commented netrw keymaps (netrw is disabled, these are dead)
- `init.lua:201-215` — commented replace-all keymaps
- `lua/peaske7/plugins/colortheme.lua:26-71` — three commented colorscheme blocks

**Action:** delete all commented blocks. They are in git history if needed.

---

## Phase 5 — Optional further simplification (evaluate case-by-case)

### 5.1 Evaluate removing `nvim-ufo`

**File:** `init.lua:563-584`, `after/plugin/lsp.lua:16-26`

Neovim 0.12 provides `vim.lsp.foldexpr()` and `vim.treesitter.foldexpr()`.
If you rarely use advanced fold features (preview, provider priority),
the built-in fold system may suffice.

**Test:** disable ufo, set:
```lua
vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'v:lua.vim.lsp.foldexpr()'
```

Check fold behavior. If acceptable, remove ufo and its dependencies
(`promise-async`, `keymap-amend`, `fold-preview`).

If ufo is still better for your workflow, keep it.

---

### 5.2 Evaluate removing `nvim-lspconfig` entirely

After Phase 2, `nvim-lspconfig` may only be needed for the `lsp/*.lua`
configs it ships (which serve as a community-maintained config registry).

If you've defined all your server configs yourself in `lsp/*.lua`, you
could drop `nvim-lspconfig` from `init.lua:362-367`.

**Recommendation:** keep it for now unless you want to maintain all server
configs yourself. The merge behavior means `after/lsp/*.lua` overrides
lspconfig's defaults cleanly.

---

## Execution order

| Step | Phase | Risk  | Dependencies     |
|------|-------|-------|------------------|
| 1.1  | 1     | Low   | None             |
| 1.2  | 1     | Low   | None             |
| 1.3  | 1     | Low   | None             |
| 1.4  | 1     | Low   | None             |
| 4.3  | 4     | Low   | None             |
| 4.4  | 4     | Low   | None             |
| 4.1  | 4     | Low   | None             |
| 4.2  | 4     | Low   | None             |
| 2.1  | 2     | Med   | 1.x done first   |
| 2.2  | 2     | Med   | 2.1 done first   |
| 3.1  | 3     | High  | 2.1 done first   |
| 5.1  | 5     | Med   | 2.1 done first   |
| 5.2  | 5     | Med   | 2.1 done first   |

**Between each step:** restart Neovim, open a few files, run `:checkhealth vim.lsp`,
and verify no regressions before moving to the next step.
