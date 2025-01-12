return {
  {
    -- A colorscheme thats easy on the eyes
    'sainnhe/gruvbox-material',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd('colorscheme gruvbox-material')
    end,
  },

  -- {
  --   "craftzdog/solarized-osaka.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     vim.cmd('colorscheme solarized-osaka')
  --   end,
  -- },

  -- {
  --   "catppuccin/nvim",
  --   name = "catppuccin",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require("catppuccin").setup({
  --       flavour = "macchiato", -- latte, frappe, macchiato, mocha
  --       background = {
  --         light = "latte",
  --         dark = "macchiato",
  --       },
  --       integrations = {
  --         barbar = true,
  --         which_key = true,
  --         fidget = true,
  --         lsp_trouble = true,
  --         mason = true
  --       },
  --       transparent_background = true
  --     })
  --
  --     vim.cmd.colorscheme "catppuccin"
  --   end
  -- },

}
