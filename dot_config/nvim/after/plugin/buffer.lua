local bar = require('barbar')
local opts = { noremap = true, silent = true }

-- previous/next buffer
vim.keymap.set('n', '<leader>p', '<Cmd>BufferPrevious<CR>', opts)
vim.keymap.set('n', '<leader>n', '<Cmd>BufferNext<CR>', opts)

-- close buffer
vim.keymap.set('n', '<leader>d', '<Cmd>BufferClose<CR>', opts)

vim.keymap.set('n', '<leader>1', "<Cmd>BufferGoto 1<CR>", opts)
vim.keymap.set('n', '<leader>2', "<Cmd>BufferGoto 2<CR>", opts)
vim.keymap.set('n', '<leader>3', "<Cmd>BufferGoto 3<CR>", opts)
vim.keymap.set('n', '<leader>4', "<Cmd>BufferGoto 4<CR>", opts)
vim.keymap.set('n', '<leader>5', "<Cmd>BufferGoto 5<CR>", opts)
vim.keymap.set('n', '<leader>6', "<Cmd>BufferGoto 6<CR>", opts)
vim.keymap.set('n', '<leader>7', "<Cmd>BufferGoto 7<CR>", opts)
vim.keymap.set('n', '<leader>8', "<Cmd>BufferGoto 8<CR>", opts)
vim.keymap.set('n', '<leader>9', "<Cmd>BufferGoto 9<CR>", opts)


bar.setup({
  animation = false,
  separator_at_end = false,
  icons = {
    button       = 'x',
    buffer_index = true,
    filetype     = {
      enabled = false
    },
  }
})
