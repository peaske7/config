return {
  -- Golang
  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
    },
    event = { "CmdlineEnter" },
    ft = { "go", 'gomod' },
    opts = {},
    config = function()
      -- Run gofmt + goimports on save
      local format_sync_grp = vim.api.nvim_create_augroup("goimports", {})
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.go",
        callback = function()
          require('go.format').goimports()
        end,
        group = format_sync_grp,
      })
    end
  },

  -- Scala
  "scalameta/nvim-metals",

  -- Haskell
  {
    'mrcjkb/haskell-tools.nvim',
    version = '^4',
    lazy = false,
  }
}
