-- Set language settings (messages only — leave LC_CTYPE alone so
-- pbcopy receives UTF-8 and Japanese text doesn't get mangled)
vim.cmd("language messages en_US.UTF-8")

-- The second most important remaps
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Set highlight on search
vim.wo.nu = true
vim.wo.signcolumn = 'yes'

vim.o.mouse = 'a'

vim.o.breakindent = true

vim.o.undofile = true
vim.o.termguicolors = true

vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.hlsearch = true

-- Decrease update time
vim.o.updatetime = 150
vim.o.timeoutlen = 250

vim.o.completeopt = 'menuone,noselect'

vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.smartindent = true

-- These can get annoying fast so disable them
vim.o.swapfile = false
vim.o.backup = false

vim.o.colorcolumn = '80'

-- Keymaps for better default experience
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", {
  expr = true, silent = true, desc = "up (wrap-aware)"
})
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", {
  expr = true, silent = true, desc = "down (wrap-aware)"
})

-- The most important remap
vim.keymap.set("i", "jk", "<Esc>", { noremap = true, desc = "exit insert mode" })

-- Join line without moving cursor
vim.keymap.set("n", "J", "mzJ`z", { desc = "join line (keep cursor)" })

-- Keep cursor centered
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "half-page down (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "half-page up (centered)" })

-- Keep search centered
vim.keymap.set("n", "n", "nzzzv", { desc = "next search (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "prev search (centered)" })

-- ufo folding
vim.o.foldcolumn = '0'
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- inherit colorscheme from terminal
-- vim.cmd('hi Normal ctermbg=none guibg=none')

-- netrw
-- vim.cmd("hi! link netrwMarkFile Search")
-- vim.keymap.set("n", "<leader>dd", ":20Lexplore %:p:h<CR>")
-- vim.keymap.set("n", "<leader>da", ":20Lexplore <CR>")

-- relative line numbers
vim.o.relativenumber = true

-- terminal mode
vim.keymap.set("t", "<esc>", "<c-\\><c-n>", { desc = "exit terminal mode" })

-- Always start in insert mode when opening a terminal
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  command = "startinsert"
})

-- write current date
vim.keymap.set("n", "<leader>wt", "a<C-r>=strftime('%m/%d (%a)')<cr>", {
  noremap = true,
  silent = true,
  desc = "write [w]rite [t]oday"
})
vim.keymap.set("n", "<leader>wd", "<cmd>pu=strftime('%m/%d')<cr>", {
  noremap = true,
  silent = true,
  desc = "write [w]rite [d]ate"
})
vim.keymap.set("n", "<leader>ww", "<cmd>pu=strftime('%a')<cr>", {
  noremap = true,
  silent = true,
  desc = "write [w]rite [w]eekday"
})
vim.keymap.set("n", "<leader>wfd", "<cmd>pu=strftime('%Y/%m/%d')<cr>", {
  noremap = true,
  silent = true,
  desc = "write [w]rite [f]ull [d]ate"
})

-- toggle highlight
vim.keymap.set("n", "<leader>h", "<cmd>set hlsearch!<cr>", { noremap = true, silent = true, desc = "toggle [h]ighlight" })

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = vim.api.nvim_create_augroup('YankHighlight', { clear = true }),
  pattern = '*',
})

-- Open files at last seen position
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Fix svelte syntax highlighting issue with treesitter
-- https://github.com/nvim-treesitter/nvim-treesitter/tree/582a92ee120532a603b75239f40cba06b9a5ec07#i-experience-weird-highlighting-issues-similar-to-78
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  pattern = "*.svelte",
  callback = function()
    vim.cmd('write | edit | TSBufEnable highlight')
  end
})

vim.api.nvim_create_autocmd('User', {
  pattern = 'GitConflictDetected',
  callback = function()
    vim.notify('Conflict detected in ' .. vim.fn.expand('<afile>'))
    vim.keymap.set('n', 'cww', function()
      engage.conflict_buster()
      create_buffer_local_mappings()
    end)
  end
})

-- searches for visually selected text
vim.keymap.set(
  'x',
  '//',
  [[ y/<C-R>=escape(@", '/\')<CR><CR> ]],
  { noremap = true, desc = "search visual selection" }
)

-- -- replaces all occurrences of the word under the cursor
-- vim.keymap.set(
--   'n',
--   'S',
--   [[:%s/\V\<<C-r><C-w>\>//g<Left><Left>]],
--   { noremap = true }
-- )
--
-- -- same thing but for visual mode
-- vim.keymap.set(
--   'x',
--   'S',
--   [["zy:%s/\V<C-r><C-r>=escape(@z,'/\')<CR>//gce<Left><Left><Left><Left>]],
--   { noremap = true }
-- )

-- Check and create .rgignore if it doesn't exist
local home = os.getenv "HOME"
local rgignore_path = home .. "/.rgignore"
local rgignore_file = io.open(rgignore_path, "r")

if not rgignore_file then
  rgignore_file = io.open(rgignore_path, "w")
  if rgignore_file then
    rgignore_file:write "!.env*\n"
    rgignore_file:close()
  end
else
  rgignore_file:close()
end

-- Disable legacy ts_context_commentstring CursorHold autocmd;
-- Comment.nvim's pre_hook handles this on-demand instead.
vim.g.skip_ts_context_commentstring_module = true

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath
  }
end
vim.opt.rtp:prepend(lazypath)

-- Focus the rightmost diff window in the current tab (for diffview review mode).
-- Used by <leader>gr/<leader>gd open, file-switch keymaps, and []c wrappers so
-- hunk navigation and edits always land on the editable working-tree pane.
local function focus_right_diff()
  local best_win, best_col = nil, -1
  for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.api.nvim_win_is_valid(winid) and vim.wo[winid].diff then
      local col = vim.api.nvim_win_get_position(winid)[2]
      if col > best_col then
        best_col = col
        best_win = winid
      end
    end
  end
  if best_win then pcall(vim.api.nvim_set_current_win, best_win) end
end

require('lazy').setup({
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      -- Picker (replaces telescope)
      picker = {
        sources = {
          files = {
            hidden = true,
            ignored = false,
            exclude = { ".git", "node_modules", ".venv", "target", ".obsidian" },
          },
        },
      },
      -- Notifier (replaces fidget.nvim)
      notifier = { enabled = true },
      -- Indent guides (replaces hlchunk)
      indent = {
        enabled = true,
        animate = { enabled = false },
      },
      -- Scope detection (used by indent)
      scope = {
        treesitter = {
          injections = false, -- workaround: async injection parsing crashes on nvim 0.12
        },
      },
      -- Git browse — open file/line on GitHub
      gitbrowse = { enabled = true },
      -- Toggleable terminal
      terminal = { enabled = true },
      -- Buffer delete without layout shift
      bufdelete = { enabled = true },
    },
    keys = {
      -- File search (was <leader>sf)
      { "<leader>sf",   function() Snacks.picker.files() end,               desc = "[s]earch [f]iles" },
      -- Live grep (was <leader>sg)
      { "<leader>sg",   function() Snacks.picker.grep() end,                desc = "[s]earch [g]rep" },
      -- Grep visual selection
      { "<leader>sg",   function() Snacks.picker.grep_word() end,           mode = "v",                            desc = "[s]earch [g]rep selection" },
      -- Recent files (was <leader>sc frecency)
      { "<leader>sc",   function() Snacks.picker.recent() end,              desc = "[s]earch re[c]ent" },
      -- Buffers (was <leader>sb)
      { "<leader>sb",   function() Snacks.picker.buffers() end,             desc = "[s]earch [b]uffers" },
      -- Resume last picker (was <leader>sr)
      { "<leader>sr",   function() Snacks.picker.resume() end,              desc = "[s]earch [r]esume" },
      -- Diagnostics (was <leader>sd)
      { "<leader>sd",   function() Snacks.picker.diagnostics() end,         desc = "[s]earch [d]iagnostics" },
      -- Quickfix (was <leader>sq)
      { "<leader>sq",   function() Snacks.picker.qflist() end,              desc = "[s]earch [q]uickfix" },
      -- Registers (was <leader>se)
      { "<leader>se",   function() Snacks.picker.registers() end,           desc = "[s]earch r[e]gisters" },
      -- Highlights (was <leader>sh)
      { "<leader>sh",   function() Snacks.picker.highlights() end,          desc = "[s]earch [h]ighlights" },
      -- Jumplist (was <leader>sj)
      { "<leader>sj",   function() Snacks.picker.jumps() end,               desc = "[s]earch [j]umplist" },
      -- Git commits (was <leader>svc)
      { "<leader>svc",  function() Snacks.picker.git_log() end,             desc = "[s]earch [v]ersion [c]ommits" },
      -- Git branches (was <leader>svb)
      { "<leader>svb",  function() Snacks.picker.git_branches() end,        desc = "[s]earch [v]ersion [b]ranches" },
      -- Git status (was <leader>svss)
      { "<leader>svss", function() Snacks.picker.git_status() end,          desc = "[s]earch [v]ersion [s]tatus" },
      -- Todo comments (was <leader>st via TodoTelescope)
      { "<leader>st",   function() Snacks.picker.todo_comments() end,       desc = "[s]earch [t]odo" },
      -- LSP
      { "gd",           function() Snacks.picker.lsp_definitions() end,     desc = "goto definition" },
      { "grr",          function() Snacks.picker.lsp_references() end,      desc = "goto references" },
      { "gri",          function() Snacks.picker.lsp_implementations() end, desc = "goto implementations" },
      { "gO",           function() Snacks.picker.lsp_symbols() end,         desc = "document symbols" },
      -- Git browse
      { "<leader>go",   function() Snacks.gitbrowse() end,                  desc = "[g]it [o]pen in browser",      mode = { "n", "v" } },
      -- Terminal (C-/ may arrive as C-_ through tmux)
      { "<C-/>",        function() Snacks.terminal() end,                   desc = "toggle terminal",              mode = { "n", "t" } },
      { "<C-_>",        function() Snacks.terminal() end,                   desc = "toggle terminal",              mode = { "n", "t" } },
    },
  },

  -- functional
  require 'peaske7.plugins.buffers',
  require 'peaske7.plugins.nvim_tree',
  require 'peaske7.plugins.markdown',
  require 'peaske7.plugins.obsidian',
  require 'peaske7.plugins.trouble',

  -- cosmetic
  require 'peaske7.plugins.colortheme',

  -- plugins
  'machakann/vim-sandwich',
  'nvim-lua/plenary.nvim',
  'wakatime/vim-wakatime',

  {
    "nvim-tree/nvim-web-devicons",
    config = function()
      local devicons = require("nvim-web-devicons")

      devicons.set_icon {
        ['prettier.config.js'] = {
          icon = "",
          color = "#4285F4",
          cterm_color = "33",
          name = "PrettierConfig",
        },
      }
    end,
  },

  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
    }
  },

  {
    'stevearc/conform.nvim',
    event = "BufWritePre",
    cmd = "ConformInfo",
    opts = {
      formatters_by_ft = {
        javascript = { "biome", "prettier", stop_after_first = true },
        typescript = { "biome", "prettier", stop_after_first = true },
        javascriptreact = { "biome", "prettier", stop_after_first = true },
        typescriptreact = { "biome", "prettier", stop_after_first = true },
        json = { "biome", "prettier", stop_after_first = true },
        css = { "prettier" },
        html = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        lua = { "stylua" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        zsh = { "shfmt" },
        go = { "gofumpt", "goimports" },
        rust = { "rustfmt" },
        sql = { "sqlfmt" },
        haskell = { "fourmolu" },
        nix = { "nixpkgs-fmt" },
      },
      format_on_save = function(bufnr)
        -- Disable for files over 500KB
        if vim.api.nvim_buf_line_count(bufnr) > 10000 then return end
        return { timeout_ms = 2000, lsp_format = "fallback" }
      end,
    },
    keys = {
      { "<leader>ff", function() require("conform").format({ async = true, lsp_format = "fallback" }) end, desc = "[f]ormat [f]ile" },
    },
  },

  {
    'mfussenegger/nvim-lint',
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
        sh = { "shellcheck" },
        bash = { "shellcheck" },
        css = { "stylelint" },
        scss = { "stylelint" },
      }

      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },

  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
      })
    end,
  },

  {
    'saghen/blink.cmp',
    version = '1.*',
    dependencies = {
      'rafamadriz/friendly-snippets',
      {
        'giuxtaposition/blink-cmp-copilot',
        dependencies = { "zbirenbaum/copilot.lua" },
      },
    },
    opts = {
      keymap = {
        ['<C-n>'] = { 'select_next', 'fallback' },
        ['<C-p>'] = { 'select_prev', 'fallback' },
        ['<C-y>'] = { 'accept', 'fallback' },
        ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
      },
      completion = {
        documentation = { auto_show = true },
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer', 'copilot' },
        providers = {
          copilot = {
            name = "copilot",
            module = "blink-cmp-copilot",
            async = true,
          },
        },
      },
      signature = { enabled = true },
    },
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    config = function()
      local wk = require("which-key")

      for i = 1, 9, 1
      do
        wk.add {
          { "<leader>" .. i, hidden = true }
        }
      end

      wk.add {
        { "<leader>b", group = 'buffers' },
        { "<leader>c", group = 'code' },
        { "<leader>g", group = 'git' },
        { "<leader>t", group = 'trees' },
        { "<leader>s", group = 'search' },
        { "<leader>q", group = 'quickfix' },
        { "<leader>x", group = 'trouble' },
        { "<leader>o", group = 'obsidian' },
      }

      wk.setup {
        plugins = {
          marks = true,
        },
        -- Suppress the hint popup for lone [ / ] only while a diffview view is
        -- open. Keeps ]c / [c / ]f / [f instant in review mode without touching
        -- the normal which-key behavior in regular buffers.
        delay = function(ctx)
          if ctx.keys == "[" or ctx.keys == "]" then
            local ok, lib = pcall(require, "diffview.lib")
            if ok and lib.get_current_view() then return 9999 end
          end
          return 200
        end,
      }
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.config').setup({
        ensure_installed = { "rust", "lua", "javascript", "typescript" },
        auto_install = true,
        highlight = {
          enable = true,
        },
      })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    lazy = false,
    dependencies = 'nvim-treesitter/nvim-treesitter',
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local npairs = require("nvim-autopairs")
      local Rule = require("nvim-autopairs.rule")
      local cond = require("nvim-autopairs.conds")

      npairs.setup({
        -- Default config
      })

      -- Rust angle bracket support: don't auto-pair after word chars (e.g., Vec<)
      npairs.add_rule(
        Rule("<", ">", "rust")
        :with_pair(cond.not_before_regex("%w"))
        :with_move(cond.move_right())
      )
    end,
  },

  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    opts = {}
  },

  {
    'brenoprata10/nvim-highlight-colors',
    event = "BufReadPre",
    config = function()
      require('nvim-highlight-colors').setup({
        render = 'background',
        virtual_symbol = '■',
        enable_named_colors = true,
        enable_tailwind = false,
      })
    end
  },

  {
    'numToStr/Comment.nvim',
    dependencies = {
      {
        "JoosepAlviste/nvim-ts-context-commentstring",
        opts = { enable_autocmd = false },
      },
    },
    event = "BufReadPre",
    config = function()
      require("Comment").setup {
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      }
    end,
  },

  {
    -- I don't usually use it, but it's super helpful when I do
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
      "anuvyklack/keymap-amend.nvim",
      {
        "anuvyklack/fold-preview.nvim",
        config = true
      },
    },
    config = function()
      require('ufo').setup({
        provider_selector = function(bufnr, filetype, buftype)
          return { 'treesitter', 'indent' }
        end
      })

      vim.keymap.set('n', 'zR', require('ufo').openAllFolds, { desc = "open all folds" })
      vim.keymap.set('n', 'zM', require('ufo').closeAllFolds, { desc = "close all folds" })
    end
  },

  {
    'lewis6991/gitsigns.nvim',
    event = "BufReadPre",
    config = function()
      local gs = require('gitsigns')
      gs.setup()

      vim.keymap.set(
        'n',
        '<leader>gl',
        '<cmd>Gitsigns toggle_current_line_blame<cr>',
        { noremap = true, silent = true, desc = 'toggle [g]it [l]ine [b]lame' }
      )

      -- Hunk navigation — ]c/[c always acts on the right diff pane inside diffview
      -- (auto-focuses it from file panel or left pane), falls through to gitsigns
      -- elsewhere.
      local function in_diffview()
        local ok, lib = pcall(require, 'diffview.lib')
        return ok and lib.get_current_view() ~= nil
      end
      vim.keymap.set('n', ']c', function()
        if in_diffview() then
          focus_right_diff()
          vim.cmd('normal! ]c')
        elseif vim.wo.diff then
          vim.cmd('normal! ]c')
        else
          gs.nav_hunk('next')
        end
      end, { desc = 'next hunk' })
      vim.keymap.set('n', '[c', function()
        if in_diffview() then
          focus_right_diff()
          vim.cmd('normal! [c')
        elseif vim.wo.diff then
          vim.cmd('normal! [c')
        else
          gs.nav_hunk('prev')
        end
      end, { desc = 'prev hunk' })
    end,
  },

  {
    "smjonas/inc-rename.nvim",
    event = "InsertEnter",
    opts = {}
  },


  { 'akinsho/git-conflict.nvim', version = "*", config = true },

  {
    'sindrets/diffview.nvim',
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory", "DiffviewToggleFiles", "DiffviewFocusFiles" },
    keys = {
      -- Toggle working tree diff: same key closes, different mode key switches
      {
        "<leader>gd",
        function()
          local lib = require('diffview.lib')
          local view = lib.get_current_view()
          if view and vim.g.diffview_mode == 'working' then
            vim.cmd('DiffviewClose')
            vim.g.diffview_mode = nil
          else
            if view then vim.cmd('DiffviewClose') end
            vim.cmd('DiffviewOpen')
            vim.g.diffview_mode = 'working'
          end
        end,
        desc = "[g]it [d]iff working tree (toggle)"
      },
      -- Toggle branch review: diff working tree (incl. uncommitted) vs merge-base with main.
      -- Single-ref form keeps the right pane pointed at the working file, so edits land on disk.
      {
        "<leader>gr",
        function()
          local lib = require('diffview.lib')
          local view = lib.get_current_view()
          if view and vim.g.diffview_mode == 'review' then
            vim.cmd('DiffviewClose')
            vim.g.diffview_mode = nil
          else
            if view then vim.cmd('DiffviewClose') end
            local mb = vim.fn.trim(vim.fn.system('git merge-base main HEAD'))
            if vim.v.shell_error ~= 0 or mb == '' then mb = 'main' end
            vim.cmd('DiffviewOpen ' .. mb)
            vim.g.diffview_mode = 'review'
          end
        end,
        desc = "[g]it [r]eview branch vs main (toggle)"
      },
      -- File history for current file
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "[g]it file [h]istory" },
      -- File history for the whole repo
      { "<leader>gH", "<cmd>DiffviewFileHistory<cr>",   desc = "[g]it all [H]istory" },
    },
    opts = {
      enhanced_diff_hl = true,
      view = {
        -- diff2_horizontal = side-by-side (VSCode-like); right pane is the working tree file and is editable
        default = { layout = "diff2_horizontal" },
        merge_tool = { layout = "diff3_mixed", disable_diagnostics = true },
      },
      file_panel = {
        listing_style = "tree",
        win_config = { position = "left", width = 35 },
      },
      keymaps = {
        -- Reclaim <Tab>/<S-Tab> so sidekick's global nes_jump_or_apply works inside diffview.
        -- File switching moves to ]f / [f, pairing with ]c / [c for hunks.
        view = {
          { "n", "<tab>",   false },
          { "n", "<s-tab>", false },
          { "n", "]f", function()
              require("diffview.actions").select_next_entry()
              vim.schedule(focus_right_diff)
            end, { desc = "next file (stay on right pane)" } },
          { "n", "[f", function()
              require("diffview.actions").select_prev_entry()
              vim.schedule(focus_right_diff)
            end, { desc = "prev file (stay on right pane)" } },
        },
        file_panel = {
          { "n", "<tab>",   false },
          { "n", "<s-tab>", false },
          { "n", "]f", function()
              require("diffview.actions").select_next_entry()
              vim.schedule(focus_right_diff)
            end, { desc = "next file (stay on right pane)" } },
          { "n", "[f", function()
              require("diffview.actions").select_prev_entry()
              vim.schedule(focus_right_diff)
            end, { desc = "prev file (stay on right pane)" } },
          { "n", "<cr>", function()
              require("diffview.actions").select_entry()
              vim.schedule(focus_right_diff)
            end, { desc = "open file (focus right pane)" } },
          { "n", "o", function()
              require("diffview.actions").select_entry()
              vim.schedule(focus_right_diff)
            end, { desc = "open file (focus right pane)" } },
        },
      },
      hooks = {
        diff_buf_read = function()
          vim.opt_local.wrap = false
          vim.opt_local.list = false
          vim.opt_local.colorcolumn = ""
        end,
        view_opened = function()
          vim.schedule(focus_right_diff)
        end,
      },
    },
  },

  {
    "otavioschwanck/arrow.nvim",
    opts = {
      show_icons = true,
      leader_key = '<leader>a',
      buffer_leader_key = 'm',
    }
  },

  {
    'kevinhwang91/nvim-bqf',
    ft = 'qf'
  },

  {
    "folke/todo-comments.nvim",
    opts = {}
  },

  {
    "folke/sidekick.nvim",
    opts = {
      cli = {
        mux = {
          backend = "tmux",
          enabled = true,
        },
      },
    },
    keys = {
      {
        "<tab>",
        function()
          if not require("sidekick").nes_jump_or_apply() then
            return "<Tab>" -- fallback to normal tab
          end
        end,
        expr = true,
        desc = "Goto/Apply Next Edit Suggestion",
      },
      { "<c-.>",      function() require("sidekick.cli").focus() end,                                   desc = "Sidekick Focus",        mode = { "n", "t", "i", "x" } },
      { "<leader>ea", function() require("sidekick.cli").toggle() end,                                  desc = "Sidekick Toggle CLI" },
      { "<leader>es", function() require("sidekick.cli").select() end,                                  desc = "Select CLI" },
      { "<leader>ed", function() require("sidekick.cli").close() end,                                   desc = "Detach a CLI Session" },
      { "<leader>et", function() require("sidekick.cli").send({ msg = "{this}" }) end,                  mode = { "x", "n" },            desc = "Send This" },
      { "<leader>ef", function() require("sidekick.cli").send({ msg = "{file}" }) end,                  desc = "Send File" },
      { "<leader>ev", function() require("sidekick.cli").send({ msg = "{selection}" }) end,             mode = { "x" },                 desc = "Send Visual Selection" },
      { "<leader>ep", function() require("sidekick.cli").prompt() end,                                  mode = { "n", "x" },            desc = "Sidekick Select Prompt" },
      { "<leader>ec", function() require("sidekick.cli").toggle({ name = "claude", focus = true }) end, desc = "Sidekick Toggle Claude" },
    },
  },

  {
    "davidosomething/format-ts-errors.nvim",
    config = function()
      require("format-ts-errors").setup({
        start_indent_level = 0, -- initial indent
      })
    end,
  },

  -- trying out movement plugins
  -- started: 2025/02/04
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function() require("flash").jump() end,
        desc = "Flash"
      },
      {
        "S",
        mode = { "n", "x", "o" },
        function() require("flash").treesitter() end,
        desc = "Flash Treesitter"
      },
      {
        "R",
        mode = { "o", "x" },
        function() require("flash").treesitter_search() end,
        desc = "Treesitter Search"
      },
      {
        "<c-s>",
        mode = { "c" },
        function() require("flash").toggle() end,
        desc = "Toggle Flash Search"
      },
    },
  },

  -- {
  --   'nvim-orgmode/orgmode',
  --   event = 'VeryLazy',
  --   config = function()
  --     -- Setup orgmode
  --     require('orgmode').setup({
  --       org_agenda_files = '~/orgfiles/**/*',
  --       org_default_notes_file = '~/orgfiles/refile.org',
  --     })
  --   end,
  -- }
})
