-- The second most important remaps
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set highlight on search
vim.wo.nu = true
vim.wo.rnu = true
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
vim.o.swapfile = false
vim.o.backup = false

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
      "jay-babu/mason-nvim-dap.nvim",
      'nvimtools/none-ls.nvim',

      {
        'jay-babu/mason-null-ls.nvim',
        event = { "BufReadPre", "BufNewFile" },
      },

      {
        "j-hui/fidget.nvim",
        event = "BufReadPre",
        opts = {}
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
      -- 'simrat39/rust-tools.nvim',

      {
        "L3MON4D3/LuaSnip",
        dependencies = {
          "rafamadriz/friendly-snippets",
        },
      },

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
    config = function()
      require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
      })
      require('copilot_cmp').setup()
    end
  },

  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {},
  },

  {
    -- highlight words under the cursor
    'RRethy/vim-illuminate',
    config = function()
      require('illuminate').configure({})
    end
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
    'nvim-treesitter/nvim-treesitter',
    event = "InsertEnter",
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = { "rust", "lua", "javascript", "typescript" },
        auto_install = true,
        highlight = {
          enable = true,
        },
        autotag = {
          enable = true
        },

        -- disable slow treesitter highlight for large files
        disable = function(_, buf)
          local max_filesize = 3000 * 1024 -- 3000 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
      }
    end,
    build = ':TSUpdate',
  },

  {
    'saecki/crates.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('crates').setup()
    end,
  },

  {
    "mrcjkb/rustaceanvim",
    version = "^3",
    ft = { "rust" },
    opts = {
      settings = {
        -- rust-analyzer language server configuration
        ["rust-analyzer"] = {
          cargo = {
            allFeatures = true,
            loadOutDirsFromCheck = true,
            runBuildScripts = true,
          },
          -- Add clippy lints for Rust.
          checkOnSave = {
            allFeatures = true,
            command = "clippy",
            extraArgs = { "--no-deps" },
          },
          procMacro = {
            enable = true,
            ignored = {
              ["async-trait"] = { "async_trait" },
            },
          },
        },
      },
    },
    config = function(_, opts)
      vim.g.rustaceanvim = vim.tbl_deep_extend("force",
        {},
        opts or {})
    end
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
    event = "BufReadPre",
    opts = {}
  },

  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
    }
  },

  {
    'lewis6991/gitsigns.nvim',
    event = "BufReadPre",
    opts = {}
  },

  {
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
    "rcarriga/nvim-dap-ui",
    lazy = true,
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      require("dapui").setup()
    end
  },

  {
    'nvim-lualine/lualine.nvim',
    opts = {
      options = {
        theme = 'gruvbox_dark',
        icons_enabled = false,
        section_separators = '',
        component_separators = ''
      }
    },
  },

  {
    'romgrk/barbar.nvim',
    event = "BufReadPre",
    init = function()
      vim.g.barbar_auto_setup = false
    end,
  },

  {
    -- Review PRs
    "ldelossa/gh.nvim",
    event = "BufReadPre",
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
