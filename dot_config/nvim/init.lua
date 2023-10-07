vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.keymap.set("i", "jk", "<Esc>", { noremap = true })
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Set highlight on search
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

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.shiftwidth = '2 smarttab'

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
	'lukas-reineke/indent-blankline.nvim',

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
			'hrsh7th/nvim-cmp',
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-nvim-lsp-signature-help',
			'hrsh7th/cmp-path',
			'hrsh7th/cmp-buffer',
			"L3MON4D3/LuaSnip",
		}
	},

	{
		"ray-x/go.nvim",
		dependencies = {
			"ray-x/guihua.lua",
			"neovim/nvim-lspconfig",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("go").setup()
		end,
		event = { "CmdlineEnter" },
		ft = { "go", 'gomod' },
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
			require("copilot_cmp").setup()
		end
	},

	{
		"j-hui/fidget.nvim",
		tag = "legacy",
		event = "LspAttach",
		config = function()
			require("fidget").setup {
				window = {
					blend = 0,
				},
			}
		end
	},

	{
		'nvim-telescope/telescope.nvim',
		version = 'v0.1.x',
		dependencies = { 'nvim-lua/plenary.nvim' }
	},

	{
		'nvim-treesitter/nvim-treesitter',
		dependencies = {
			'nvim-treesitter/nvim-treesitter-textobjects',
		},
		config = function()
			pcall(require('nvim-treesitter.install').update { with_sync = true })
		end,
	},

	{
		'saecki/crates.nvim',
		dependencies = { 'nvim-lua/plenary.nvim' },
		config = function()
			require('crates').setup()
		end,
	},

	{ 'catppuccin/nvim',         name = "catppuccin", },

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

	{ 'numToStr/Comment.nvim',   opts = {} },
	{ 'lewis6991/gitsigns.nvim', opts = {} },

	{
		'prichrd/netrw.nvim',
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {}
	},

	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {},
	},

	{
		'nvim-lualine/lualine.nvim',
		opts = {
			dependencies = { 'nvim-tree/nvim-web-devicons' }
		},
		config = function()
			require('lualine').setup({
				options = {
					theme = 'catppuccin',
				},
			})
		end
	},
}, {})
