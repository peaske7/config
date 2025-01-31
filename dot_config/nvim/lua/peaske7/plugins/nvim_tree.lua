return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      'nvim-tree/nvim-web-devicons'
    },
    config = function()
      local nvim_tree = require("nvim-tree")
      local nvim_tree_api = require("nvim-tree.api")

      vim.opt.splitright = true

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

      nvim_tree.setup({
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
        update_focused_file = {
          enable = true,
        },
      })

      vim.keymap.set('n', '<leader>tt', '<cmd>NvimTreeToggle<cr>', {
        noremap = true,
        silent = true,
        desc = '[t]ree [t]oggle'
      })
      vim.keymap.set('n', '<leader>tf', function()
        nvim_tree_api.tree.find_file({ focus = false })
      end, {
        noremap = true,
        silent = true,
        desc = '[t]ree [f]ind'
      })
      vim.keymap.set('n', '<leader>tr', "<cmd>NvimTreeRefresh<cr>", {
        noremap = true,
        silent = true,
        desc = '[t]ree [r]efresh'
      })
      vim.keymap.set('n', '<leader>te', '<cmd>NvimTreeFindFileToggle<cr>', {
        noremap = true,
        silent = true,
        desc = '[t]ree [e]xplore'
      })
    end
  }
}
