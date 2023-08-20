local telescope_builtin = require('telescope.builtin')

-- keybindings for telescope
vim.keymap.set('n', '<leader>sf', telescope_builtin.find_files, {
  desc = '[S]earch [F]iles', noremap = true
})
vim.keymap.set('n', '<leader>sg', telescope_builtin.live_grep, {
  desc = '[S]earch by [G]rep', noremap = true
})
vim.keymap.set('n', '<leader>sd', telescope_builtin.diagnostics, {
  desc = '[S]earch [D]iagnostics', noremap = true
})
vim.keymap.set('n', '<leader>sb', telescope_builtin.buffers, {
  desc = '[S]earch [B]uffers', noremap = true
})
