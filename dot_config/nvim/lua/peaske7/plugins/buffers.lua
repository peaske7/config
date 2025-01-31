return {
  -- I removed this once, but I came crawling back to it.

  {
    'romgrk/barbar.nvim',
    event = "BufReadPre",
    init = function()
      vim.g.barbar_auto_setup = false
    end,
    config = function()
      local bar = require('barbar')

      -- previous/next buffer
      vim.keymap.set('n', '<leader>p', '<Cmd>BufferPrevious<CR>', {
        noremap = true,
        silent = true,
        desc = '[p]revious buffer'
      })
      vim.keymap.set('n', '<leader>n', '<Cmd>BufferNext<CR>', {
        noremap = true,
        silent = true,
        desc = '[n]ext buffer'
      })

      -- close buffer
      vim.keymap.set('n', '<leader>d', '<Cmd>BufferClose<CR>', {
        noremap = true,
        silent = true,
        desc = '[d]elete buffer'
      })
      vim.keymap.set('n', '<leader>bd', '<cmd>BufferPickDelete<cr>', {
        noremap = true,
        silent = true,
        desc = '[b]uffer pick [d]elete'
      })
      vim.keymap.set('n', '<leader>bw', '<cmd>BufferWipeout<cr>', {
        noremap = true,
        silent = true,
        desc = '[b]uffer [w]ipeout'
      })

      for i = 1, 9, 1
      do
        vim.keymap.set('n', '<leader>' .. i, '<Cmd>BufferGoto ' .. i .. '<CR>', {
          hidden = true
        })
      end

      bar.setup({
        animation = false,
        separator_at_end = false,
        icons = {
          buffer_index = true,
          filetype     = {
            enabled = false
          },
        }
      })
    end
  }
}
