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
  -- functional
  require 'peaske7.plugins.buffers',
  require 'peaske7.plugins.nvim_tree',
  require 'peaske7.plugins.markdown',
  require 'peaske7.plugins.telescope',
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
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    lazy = false,
    config = false,
  },

  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'nvimtools/none-ls.nvim',

      {
        'jay-babu/mason-null-ls.nvim',
        opts = {}
      },

      {
        "j-hui/fidget.nvim",
        config = function()
          require('fidget').setup({
            notification = {
              window = {
                winblend = 0,
              },
            }
          })
        end
      },
    }
  },

  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-buffer',

      {
        "L3MON4D3/LuaSnip",
        dependencies = {
          "rafamadriz/friendly-snippets",
        },
      },

      {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
          require("copilot").setup({})
        end,
      },

      {
        "zbirenbaum/copilot-cmp",
        event = "BufReadPre",
        config = function()
          require("copilot").setup({
            suggestion = { enabled = false },
            panel = { enabled = false },
          })
          require('copilot_cmp').setup()
        end
      },

    },
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      table.insert(opts.sources, {
        name = "lazydev",
        group_index = 0,
      })
    end,
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
    dependencies = "JoosepAlviste/nvim-ts-context-commentstring",
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
    "shellRaining/hlchunk.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("hlchunk").setup({
        indent = {
          enable = true
        },
      })
    end
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
})
