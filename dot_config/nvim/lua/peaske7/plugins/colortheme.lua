return {
  {
    -- A colorscheme thats easy on the eyes
    'sainnhe/gruvbox-material',
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.gruvbox_material_better_performance = 1
      vim.g.gruvbox_material_transparent_background = 1

      -- Apply custom highlights on colorscheme change.
      -- Must be declared before executing ':colorscheme'.
      grpid = vim.api.nvim_create_augroup('custom_highlights_gruvboxmaterial', {})
      vim.api.nvim_create_autocmd('ColorScheme', {
        group = grpid,
        pattern = 'gruvbox-material',
        command = -- floating popups
            'hi NormalFloat guibg=#282828 |' ..
            'hi FloatBorder guibg=#282828'
      })

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
