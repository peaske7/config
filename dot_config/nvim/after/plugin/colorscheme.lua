require("catppuccin").setup({
  flavour = "frappe",
  term_colors = true,
  integrations = {
    treesitter = true,
    mason = true,
    fidget = true,
    sandwich = true
  }
})

vim.cmd.colorscheme("catppuccin")
