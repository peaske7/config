local status, _ = pcall(require, 'nvim-treesitter')
if (not status) then return end
local ts_configs = require('nvim-treesitter.configs')

ts_configs.setup {
  ensure_installed = { "help", "tsx", "html", "toml", "json", "css", "c", "rust", "lua", "javascript",
    "typescript", "vim" },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  autotag = {
    enable = true
  }
}

local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.tsx.filetype_to_parsername = {
  "javascript", "typescript.tsx"
}
