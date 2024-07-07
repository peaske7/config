local bar = require('barbar')
local opts = { noremap = true, silent = true }

-- previous/next buffer
vim.keymap.set('n', '<leader>p', '<Cmd>BufferPrevious<CR>', opts)
vim.keymap.set('n', '<leader>n', '<Cmd>BufferNext<CR>', opts)

-- close buffer
vim.keymap.set('n', '<leader>d', '<Cmd>BufferClose<CR>', opts)

for i = 1, 9, 1
do
  vim.keymap.set('n', '<leader>' .. i, '<Cmd>BufferGoto ' .. i .. '<CR>', opts)
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
