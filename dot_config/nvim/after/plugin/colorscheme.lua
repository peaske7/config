require("catppuccin").setup({
	flavour = "mocha",
	term_colors = true,
	integrations = {
		gitsigns = true,
		nvimtree = true,
		treesitter = true,
		fidget = true,
		cmp = true,
		mason = true,
		lsp_trouble = true,
		sandwich = true
	}
})

vim.cmd.colorscheme("catppuccin")
