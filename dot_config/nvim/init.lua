-- Set language settings
vim.cmd("language en_US")

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
  expr = true, silent = true
})
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", {
  expr = true, silent = true
})

-- The most important remap
vim.keymap.set("i", "jk", "<Esc>", { noremap = true })

-- Don't know, don't care
vim.keymap.set("n", "J", "mzJ`z")

-- Keep cursor centered
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Keep search centered
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

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
vim.keymap.set("t", "<esc>", "<c-\\><c-n>")

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
  { noremap = true }
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
            exclude = { ".git", "node_modules", ".venv", "target" },
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
      }

      wk.setup {
        plugins = {
          marks = true,
        },
      }
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',

      {
        "windwp/nvim-autopairs",
        config = true
      }
    },
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = { "rust", "lua", "javascript", "typescript" },
        auto_install = true,
        highlight = {
          enable = true,
        },
      })

      local npairs = require("nvim-autopairs")
      local rule = require("nvim-autopairs.rule")
      local conds = require("nvim-autopairs.conds")

      -- Angle brackets are handled as pairs too
      npairs.add_rules {
        rule("<", ">")
            :with_pair(conds.before_regex("%a+"))
            :with_move(function(opts)
              return opts.char == ">"
            end),
      }
    end,
    build = ':TSUpdate',
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

      vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
      vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
    end
  },

  {
    'lewis6991/gitsigns.nvim',
    event = "BufReadPre",
    config = function()
      require('gitsigns').setup()

      vim.keymap.set(
        'n',
        '<leader>gl',
        '<cmd>Gitsigns toggle_current_line_blame<cr>',
        { noremap = true, silent = true, desc = 'toggle [g]it [l]ine [b]lame' }
      )
    end,
  },

  {
    "smjonas/inc-rename.nvim",
    event = "InsertEnter",
    opts = {}
  },


  {
    "mbbill/undotree",
    config = function()
      vim.keymap.set('n', '<leader>tu', vim.cmd.UndotreeToggle, {
        desc = "open [t]ree [u]ndo"
      })
    end
  },

  { 'akinsho/git-conflict.nvim', version = "*", config = true },

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
      { "<c-.>",       function() require("sidekick.cli").focus() end,                             desc = "Sidekick Focus",          mode = { "n", "t", "i", "x" } },
      { "<leader>ea",  function() require("sidekick.cli").toggle() end,                            desc = "Sidekick Toggle CLI" },
      { "<leader>es",  function() require("sidekick.cli").select() end,                            desc = "Select CLI" },
      { "<leader>ed",  function() require("sidekick.cli").close() end,                             desc = "Detach a CLI Session" },
      { "<leader>et",  function() require("sidekick.cli").send({ msg = "{this}" }) end,            mode = { "x", "n" },              desc = "Send This" },
      { "<leader>ef",  function() require("sidekick.cli").send({ msg = "{file}" }) end,            desc = "Send File" },
      { "<leader>ev",  function() require("sidekick.cli").send({ msg = "{selection}" }) end,       mode = { "x" },                   desc = "Send Visual Selection" },
      { "<leader>ep",  function() require("sidekick.cli").prompt() end,                            mode = { "n", "x" },              desc = "Sidekick Select Prompt" },
      { "<leader>ec",  function() require("sidekick.cli").toggle({ name = "claude", focus = true }) end, desc = "Sidekick Toggle Claude" },
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

  {
    'nvim-orgmode/orgmode',
    event = 'VeryLazy',
    config = function()
      -- Setup orgmode
      require('orgmode').setup({
        org_agenda_files = '~/orgfiles/**/*',
        org_default_notes_file = '~/orgfiles/refile.org',
      })
    end,
  }
})
