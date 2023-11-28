-- The second most important remaps
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set highlight on search
vim.wo.nu = true
vim.wo.signcolumn = 'yes'

vim.o.mouse = 'a'

vim.o.breakindent = true

vim.o.undofile = true
vim.o.termguicolors = true

vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.hlsearch = false

-- Decrease update time
vim.o.updatetime = 150
vim.o.timeoutlen = 250

vim.o.completeopt = 'menuone,noselect'

vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.smartindent = true

-- These can get annoying fast so disable them
vim.opt.swapfile = false
vim.opt.backup = false

vim.o.colorcolumn = '80'

-- Keymaps for better default experience
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

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

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

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
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',
  'tpope/vim-vinegar',
  'machakann/vim-sandwich',

  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    lazy = true,
    config = false,
  },

  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      {
        "j-hui/fidget.nvim",
        event = "BufReadPre",
        opts = {}
      },
    }
  },

  {
    'hrsh7th/nvim-cmp',
    event = "InsertEnter",
    dependencies = {
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-buffer',
      'simrat39/rust-tools.nvim',
    },
  },

  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    lazy = true,
    config = function()
      require("copilot").setup({})
    end,
  },

  {
    "zbirenbaum/copilot-cmp",
    lazy = true,
    config = function()
      require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
      })
    end
  },

  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {},
  },

  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    event = "InsertEnter",
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
    },
  },

  {
    -- Adds latest used file search for telescope
    "nvim-telescope/telescope-frecency.nvim",
    event = "InsertEnter",
    config = function()
      require("telescope").load_extension "frecency"
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter',
    event = "InsertEnter",
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },

  {
    -- Shows outdated crates in a cargo.toml. Maybe not necessary
    'saecki/crates.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    lazy = true,
    config = function()
      require('crates').setup()
    end,
  },

  {
    -- A colorscheme thats easy on the eyes
    'sainnhe/gruvbox-material',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd('colorscheme gruvbox-material')
    end,
  },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {}
  },

  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    opts = {}
  },

  {
    'numToStr/Comment.nvim',
    opts = {}
  },

  {
    'lewis6991/gitsigns.nvim',
    event = "BufReadPre",
    opts = {}
  },

  {
    -- Adds pretty animation when renaming variables
    "smjonas/inc-rename.nvim",
    event = "InsertEnter",
    config = function()
      require("inc_rename").setup()
    end,
  },

  {
    -- A single interface to handle diagnostics across multiple files
    "folke/trouble.nvim",
    lazy = true,
    opts = {}
  },

  {
    -- Review PRs
    "ldelossa/gh.nvim",
    dependencies = {
      {
        "ldelossa/litee.nvim",
        config = function()
          require("litee.lib").setup()
        end,
      },
    },
    config = function()
      require("litee.gh").setup()
    end,
  }
})
