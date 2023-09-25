require("catppuccin").setup({
  flavour = "frappe",
  term_colors = true,
  integrations = {
    fidget = true,
  }
})

vim.cmd.colorscheme("catppuccin")
