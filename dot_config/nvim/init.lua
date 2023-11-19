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
			'simrat39/rust-tools.nvim'
		}
	},

	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({})
			vim.g.copilot_filetypes = { VimspectorPrompt = false }
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
		opts = {}
	},

	{
		'nvim-telescope/telescope.nvim',
		version = 'v0.1.x',
		dependencies = { 'nvim-lua/plenary.nvim' }
	},

	{
		"nvim-telescope/telescope-frecency.nvim",
		config = function()
			require("telescope").load_extension "frecency"
		end,
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

	{
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

	{ 'numToStr/Comment.nvim',   opts = {} },
	{ 'lewis6991/gitsigns.nvim', opts = {} },

	{
		"smjonas/inc-rename.nvim",
		config = function()
			require("inc_rename").setup()
		end,
	},

	{
		"folke/trouble.nvim",
		opts = {
			{
				icons = false,
				fold_open = "v",
				fold_closed = ">",
				indent_lines = false,
				signs = {
					error = "error",
					warning = "warn",
					hint = "hint",
					information = "info"
				},
				use_diagnostic_signs = true
			}
		},
	},

	{
		'nvim-lualine/lualine.nvim',
		opts = {
			options = {
				icons_enabled = false,
				theme = 'gruvbox-material',
				component_separators = '|',
				section_separators = '',
			},
		},
	},

})
