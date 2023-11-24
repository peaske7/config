require('nvim-treesitter.configs').setup {
  ensure_installed = { "rust", "lua", "javascript", "vim", "typescript" },
  auto_install = true,
  autotag = {
    enable = true
  }
}
