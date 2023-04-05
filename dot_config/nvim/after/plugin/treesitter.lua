local status, _ = pcall(require, 'nvim-treesitter')
if (not status) then return end
local ts_configs = require('nvim-treesitter.configs')

ts_configs.setup {
  ensure_installed = { "help", "c", "rust", "lua", "javascript", "typescript", "vim" },

  sync_install = false,
  auto_install = true,

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
    disable = {}
  },
  indent = {
    enable = true,
    disable = {}
  },
  autotag = {
    enable = true
  }
}
