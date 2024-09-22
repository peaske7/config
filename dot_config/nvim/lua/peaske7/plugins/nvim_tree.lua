return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      'nvim-tree/nvim-web-devicons'
    },
    config = function()
      local nvimtree = require("nvim-tree")

      -- Close nvim-tree when last window is closed
      vim.api.nvim_create_autocmd("QuitPre", {
        callback = function()
          local tree_wins = {}
          local floating_wins = {}
          local wins = vim.api.nvim_list_wins()
          for _, w in ipairs(wins) do
            local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
            if bufname:match("NvimTree_") ~= nil then
              table.insert(tree_wins, w)
            end
            if vim.api.nvim_win_get_config(w).relative ~= '' then
              table.insert(floating_wins, w)
            end
          end
          if 1 == #wins - #floating_wins - #tree_wins then
            -- Should quit, so we close all invalid windows.
            for _, w in ipairs(tree_wins) do
              vim.api.nvim_win_close(w, true)
            end
          end
        end
      })

      nvimtree.setup({
        renderer = {
          indent_width = -2,
          icons = {
            web_devicons = {
              file = {
                enable = true,
                color = true,
              },
              folder = {
                enable = true,
                color = true,
              },
            },
          }
        },
        git = {
          enable = true,
          ignore = false,
          timeout = 500,
        },
      })

      local opts = { noremap = true, silent = true }
      vim.keymap.set('n', '<leader>tt', "<cmd>NvimTreeToggle<cr>", opts)
      vim.keymap.set('n', '<leader>tf', '<cmd>NvimTreeFindFile<cr>', opts)
    end
  }
}
