require("catppuccin").setup({
  flavour = "mocha",
  term_colors = true,
  integrations = {
    fidget = true,
  }
})

vim.cmd.colorscheme("catppuccin")
