require("dr_poppyseed")

-- previously impatient.nvim
vim.loader.enable()

-- Keymaps and options
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.keymap.set("i", "jk", "<Esc>", { noremap = true })
vim.keymap.set("n", "J", "mzJ`z")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Set highlight on search
vim.o.hlsearch = false
vim.wo.number = true
vim.wo.signcolumn = 'yes'
vim.o.mouse = 'a'
vim.o.clipboard = 'unnamedplus'
vim.o.breakindent = true
vim.o.undofile = true
vim.o.termguicolors = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- Bootstrap Package Manager
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

-- Plugins
require('lazy').setup({
    'tpope/vim-fugitive',
    'tpope/vim-rhubarb',
    'tpope/vim-sleuth',
    'tpope/vim-vinegar',
    'machakann/vim-sandwich',
    'lukas-reineke/indent-blankline.nvim',

    -- LSP
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        dependencies = {
            'neovim/nvim-lspconfig',
            {
                'williamboman/mason.nvim',
                build = ":MasonUpdate"
            },
            'williamboman/mason-lspconfig.nvim',

            -- Autocompletion
            'hrsh7th/nvim-cmp',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-nvim-lsp-signature-help',
            'hrsh7th/cmp-vsnip',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-buffer',
            'L3MON4D3/LuaSnip',

            -- Additional lua configuration, makes nvim stuff amazing!
            'folke/neodev.nvim',

            -- Rust powerups like inlay hints
            'simrat39/rust-tools.nvim'
        }
    },

    -- integration with github copilot
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
            require("copilot_cmp").setup()
        end
    },

    -- LSP progress UI. I've removed it once, missed it, and re-added it.
    {
        "j-hui/fidget.nvim",
        tag = "legacy",
        event = "LspAttach",
        opts = {
            window = {
                blend = 0
            }
        }
    },

    -- Fuzzy Finder (files, lsp, etc)
    {
        'nvim-telescope/telescope.nvim',
        version = 'v0.1.x',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },

    -- Highlight, edit, and navigate code
    {
        'nvim-treesitter/nvim-treesitter',
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
        },
        config = function()
            pcall(require('nvim-treesitter.install').update { with_sync = true })
        end,
    },

    -- shows latest crates.io versions in Cargo.toml
    {
        'saecki/crates.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('crates').setup()
        end,
    },

    -- color theme
    {
        'catppuccin/nvim',
        name = "catppuccin",
        priority = 1000,
        config = function()
            local catp = require("catppuccin")
            vim.g.catppuccin_flavour = "frappe"
            catp.setup({
                term_colors = true,
                compile_path = vim.fn.stdpath "cache" .. "/catppuccin",
                integrations = {
                    cmp = true,
                    gitsigns = true,
                    treesitter = true,
                }
            })

            vim.cmd("colorscheme catppuccin")
        end,
    },

    { 'folke/which-key.nvim',                     opts = {} },
    { "windwp/nvim-autopairs",                    opts = {} },
    { 'windwp/nvim-ts-autotag',                   opts = {} },
    { 'numToStr/Comment.nvim',                    opts = {} },
    { 'lewis6991/gitsigns.nvim',                  opts = {} },
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },

    -- Set lualine as statusline
    {
        'nvim-lualine/lualine.nvim',
        opts = {
            dependencies = { 'nvim-tree/nvim-web-devicons' }
        },
        config = function()
            require('lualine').setup({
                options = {
                    theme = 'catppuccin-frappe',
                },
            })
        end
    },
}, {})
