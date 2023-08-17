require("dr_poppyseed")

-- previously impatient.nvim
vim.loader.enable()

-------------------------------------------------------------------------------
-- Global mapleader
-------------------------------------------------------------------------------
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-------------------------------------------------------------------------------
-- Bootstrap Package Manager
-------------------------------------------------------------------------------
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

-------------------------------------------------------------------------------
-- Plugins
-------------------------------------------------------------------------------
require('lazy').setup({
    -- Git extension
    'tpope/vim-fugitive',

    -- GitHub extension for fugitive.vim
    'tpope/vim-rhubarb',

    -- Heuristically sets buffer options
    'tpope/vim-sleuth',

    -- netrw enchancer
    'tpope/vim-vinegar',

    -- vim-surround++
    'machakann/vim-sandwich',

    -- Foundation of all foundations
    'nvim-lua/plenary.nvim',

    -- File icons
    "nvim-tree/nvim-web-devicons",

    -- LSP
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        dependencies = {
            -- LSP Support
            'neovim/nvim-lspconfig',
            {
                'williamboman/mason.nvim',
                build = ":MasonUpdate"
            },
            'williamboman/mason-lspconfig.nvim',
            'jose-elias-alvarez/null-ls.nvim',

            -- Autocompletion
            'hrsh7th/nvim-cmp',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-nvim-lsp-signature-help',
            'hrsh7th/cmp-vsnip',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-buffer',
            'hrsh7th/vim-vsnip',
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',

            -- Additional lua configuration, makes nvim stuff amazing!
            'folke/neodev.nvim',

            -- Rust powerups like inlay hints
            'simrat39/rust-tools.nvim'
        }
    },

    -- LSP progress UI. I've removed it once, missed it, and re-added it.
    {
        "j-hui/fidget.nvim",
        tag = "legacy",
        event = "LspAttach",
        opts = {}
    },

    -- TODO comments
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
    },

    -- Fuzzy Finder (files, lsp, etc)
    {
        'nvim-telescope/telescope.nvim',
        version = 'v0.1.x',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },

    -- Fuzzy Finder Algorithm which requires local dependencies to be built.
    {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
            return vim.fn.executable 'make' == 1
        end,
    },

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

    -- color theme
    {
        'projekt0n/github-nvim-theme',
        lazy = false,    -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            require('github-theme').setup()
            vim.cmd('colorscheme github_dark')
        end,
    },

    -- Useful plugin to show you pending keybinds.
    { 'folke/which-key.nvim',   opts = {} },

    { "windwp/nvim-autopairs",  opts = {} },
    { 'windwp/nvim-ts-autotag', opts = {} },

    -- "gc" to comment visual regions/lines
    { 'numToStr/Comment.nvim',  opts = {} },

    -- Adds git releated signs to the gutter, as well as utilities for managing changes
    { 'lewis6991/gitsigns.nvim' },

    -- diagnostics
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },

    -- Set lualine as statusline
    {
        'nvim-lualine/lualine.nvim',
        opts = {
            options = {
                theme = "github_dark",
                icons_enabled = false,
                component_separators = '|',
                section_separators = '',
            },
            dependencies = { 'nvim-tree/nvim-web-devicons' }
        },
    },

    -- Add indentation guides even on blank lines
    {
        'lukas-reineke/indent-blankline.nvim',
        opts = {
            char = '┊',
            show_trailing_blankline_indent = false,
        },
    },
}, {})
