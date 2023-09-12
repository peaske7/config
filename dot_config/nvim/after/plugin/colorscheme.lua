require("catppuccin").setup({
  flavour = "frappe",
  term_colors = true,
  transparent_background = true,
  integrations = {
    treesitter = true,
    mason = true,
    fidget = true,
    lsp_trouble = true,
    which_key = true,
    sandwich = true
  }
})

vim.cmd.colorscheme("catppuccin")
