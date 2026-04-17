return {
  -- {
  --   'loctvl842/monokai-pro.nvim',
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require('monokai-pro').setup({
  --       filter = 'pro',
  --       transparent_background = false,
  --     })
  --
  --     vim.cmd('colorscheme monokai-pro')
  --   end,
  -- },

  -- {
  --   'sainnhe/gruvbox-material',
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     vim.g.gruvbox_material_better_performance = 1
  --     vim.g.gruvbox_material_transparent_background = 1
  --
  --     local grpid = vim.api.nvim_create_augroup('custom_highlights_gruvboxmaterial', {})
  --     vim.api.nvim_create_autocmd('ColorScheme', {
  --       group = grpid,
  --       pattern = 'gruvbox-material',
  --       command = 'hi NormalFloat guibg=#282828 |' ..
  --           'hi FloatBorder guibg=#282828',
  --     })
  --
  --     vim.cmd('colorscheme gruvbox-material')
  --   end,
  -- },

  -- {
  --   "craftzdog/solarized-osaka.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require("solarized-osaka").setup({
  --       transparent = true,
  --       terminal_colors = true,
  --     })
  --
  --     vim.cmd('colorscheme solarized-osaka')
  --   end,
  -- },

  -- {
  --   'paulo-granthon/hyper.nvim',
  --   config = function()
  --     require('hyper').load()
  --   end,
  -- },

  -- {
  --   "catppuccin/nvim",
  --   name = "catppuccin",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require("catppuccin").setup({
  --       flavour = "mocha", -- latte, frappe, macchiato, mocha
  --       background = {
  --         light = "latte",
  --         dark = "macchiato",
  --       },
  --       integrations = {
  --         barbar = true,
  --         which_key = true,
  --         fidget = true,
  --         lsp_trouble = true,
  --         mason = true,
  --       },
  --       transparent_background = true,
  --     })
  --
  --     vim.cmd.colorscheme("catppuccin")
  --   end,
  -- },

  -- {
  --   -- Low-contrast calm theme with markdown support
  --   "rhysd/vim-color-spring-night",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     vim.g.spring_night_high_contrast = 1
  --     vim.cmd("colorscheme spring-night")
  --   end,
  -- },

  {
    -- Dark theme with multiple variants: wave, dragon, lotus
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("kanagawa").setup({
        theme = "wave",
        transparent = false,
      })

      vim.cmd("colorscheme kanagawa")
      -- vim.cmd("colorscheme kanagawa-dragon")
      -- vim.cmd("colorscheme kanagawa-lotus")
    end,
  },

  -- {
  --   -- Atom-inspired theme with multiple styles
  --   "navarasu/onedark.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require("onedark").setup({
  --       style = "darker", -- dark, darker, cool, deep, warm, warmer, light
  --       transparent = true,
  --     })
  --
  --     require("onedark").load()
  --   end,
  -- },

  -- {
  --   -- Retro high-contrast theme
  --   "Mitch1000/backpack.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require("backpack").setup({
  --       contrast = "high", -- medium, high, extreme
  --       transparent = false,
  --     })
  --
  --     vim.cmd("colorscheme backpack")
  --   end,
  -- },
}
