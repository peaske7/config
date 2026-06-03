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
        transparent = true,
        overrides = function(colors)
          return {
            -- Brighter Visual so selections stay readable over ghostty's bg
            Visual = { bg = "#2D4F67" },
            -- Clear UI chrome kanagawa leaves solid in transparent mode
            StatusLine = { bg = "NONE" },
            StatusLineNC = { bg = "NONE" },
            WinBar = { bg = "NONE" },
            WinBarNC = { bg = "NONE" },
            TabLine = { bg = "NONE" },
            TabLineFill = { bg = "NONE" },
            TabLineSel = { bg = "NONE" },
            -- nvim-tree has its own statusline/winsep highlights
            NvimTreeNormal = { bg = "NONE" },
            NvimTreeNormalNC = { bg = "NONE" },
            NvimTreeWinSeparator = { bg = "NONE" },
            NvimTreeStatusLine = { bg = "NONE" },
            NvimTreeStatusLineNC = { bg = "NONE" },
            -- Floating windows: dark winterBlue panel (kanagawa palette,
            -- cool-tilted slate). Border fg is sumiInk4 (muted lavender-
            -- gray) — visible hairline without the chromatic punch of
            -- sage/blue. Border bg still matches panel so ascii border
            -- chars don't halo.
            NormalFloat = { bg = "#252535" },
            FloatBorder = { fg = "#54546D", bg = "#252535" },
            FloatTitle = { fg = "#7AA89F", bg = "#252535", bold = true },
            -- Modal backdrop highlights for snacks / lazy: solid black bg
            -- so the backdrop window has something to dim with. Without
            -- this, kanagawa transparent leaves the backdrop invisible
            -- regardless of the plugin's winblend setting.
            SnacksBackdrop = { bg = "#000000" },
            LazyBackdrop = { bg = "#000000" },
            -- Completion menu (blink.cmp falls back to Pmenu) — keep this
            -- opaque so suggestions stay readable over arbitrary code.
            Pmenu = { bg = "#1F1F28" },
            PmenuSel = { bg = "#2D4F67", bold = true },
            PmenuSbar = { bg = "#1F1F28" },
            PmenuThumb = { bg = "#54546D" },
            -- Restore CursorLine so picker selection + current line are visible
            CursorLine = { bg = "#2A2A37" },
            CursorLineNr = { fg = "#C8C093", bold = true },
          }
        end,
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
