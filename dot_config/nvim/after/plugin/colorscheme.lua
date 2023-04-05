local status, theme = pcall(require, 'catppuccin')
if (not status) then return end

theme.setup {
  flavour = 'frappe',
  integrations = {
    treesitter = true,
    telescope = true,
    gitsigns = true,
    which_key = true,
    mason = true,
    cmp = true,
    fidget = true,
    dap = true
  }
}

vim.cmd.colorscheme 'catppuccin'
