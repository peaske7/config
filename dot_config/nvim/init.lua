require("dr_poppyseed")

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
    -- First, plugins that don't require configuration
    'tpope/vim-fugitive',
    'tpope/vim-rhubarb',
    'tpope/vim-sleuth',

    -- vim-surround++
    'machakann/vim-sandwich',

    -- Foundation of all foundations
    'nvim-lua/plenary.nvim',

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

            -- Useful status updates for LSP
            { 'j-hui/fidget.nvim', opts = {} },

            -- Additional lua configuration, makes nvim stuff amazing!
            'folke/neodev.nvim',
        }
    },

    -- file icons
    'kyazdani42/nvim-web-devicons',

    -- highlight same words under cursor
    'RRethy/vim-illuminate',

    {
        -- Fuzzy Finder (files, lsp, etc)
        'nvim-telescope/telescope.nvim',
        version = 'v0.1.x',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },

    {
        -- Fuzzy Finder Algorithm which requires local dependencies to be built.
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
            return vim.fn.executable 'make' == 1
        end,
    },

    {
        -- Highlight, edit, and navigate code
        'nvim-treesitter/nvim-treesitter',
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
        },
        config = function()
            pcall(require('nvim-treesitter.install').update { with_sync = true })
        end,
    },

    -- color theme
    { "catppuccin/nvim",        name = 'catppuccin' },

    -- Useful plugin to show you pending keybinds.
    { 'folke/which-key.nvim',   opts = {} },

    { "windwp/nvim-autopairs",  opts = {} },
    { 'windwp/nvim-ts-autotag', opts = {} },

    -- "gc" to comment visual regions/lines
    { 'numToStr/Comment.nvim',  opts = {} },

    {
        -- Adds git releated signs to the gutter, as well as utilities for managing changes
        'lewis6991/gitsigns.nvim',
        opts = {
            signs = {
                add = { text = '+' },
                change = { text = '~' },
                delete = { text = '-' },
            }
        },
    },

    {
        -- Set lualine as statusline
        'nvim-lualine/lualine.nvim',
        opts = {
            options = {
                theme = "catppuccin",
                icons_enabled = false,
                component_separators = '|',
                section_separators = '',
            },
            dependencies = { 'nvim-tree/nvim-web-devicons' }
        },
    },

    {
        -- Add indentation guides even on blank lines
        'lukas-reineke/indent-blankline.nvim',
        opts = {
            char = '┊',
            show_trailing_blankline_indent = false,
        },
    },
}, {})
