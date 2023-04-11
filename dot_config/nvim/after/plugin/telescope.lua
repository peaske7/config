local status, telescope = pcall(require, 'telescope')
if (not status) then return end
local telescope_builtin = require('telescope.builtin')
local telescope_actions = require('telescope.actions')

telescope.setup {
  defaults = {
    mappings = {
      n = {
        ['q'] = telescope_actions.close
      }
    },
    file_ignore_patterns = {
      ".git/", ".cache"
    }
  },
}

vim.keymap.set('n', '<leader>sf', telescope_builtin.find_files, { desc = '[S]earch [F]iles', noremap = true })
vim.keymap.set('n', '<leader>sh', telescope_builtin.help_tags, { desc = '[S]earch [H]elp', noremap = true })
vim.keymap.set('n', '<leader>sw', telescope_builtin.grep_string, { desc = '[S]earch current [W]ord', noremap = true })
vim.keymap.set('n', '<leader>sg', telescope_builtin.live_grep, { desc = '[S]earch by [G]rep', noremap = true })
vim.keymap.set('n', '<leader>sd', telescope_builtin.diagnostics, { desc = '[S]earch [D]iagnostics', noremap = true })
vim.keymap.set('n', '<leader>sre', telescope_builtin.resume, { desc = '[S]earch [R]esume', noremap = true })
vim.keymap.set('n', '<leader>srr', telescope_builtin.registers, { desc = '[S]earch [R]esume', noremap = true })
vim.keymap.set('n', '<leader>sb', telescope_builtin.buffers, { desc = '[S]earch [B]uffers', noremap = true })
vim.keymap.set('n', '<leader>so', telescope_builtin.oldfiles, { desc = '[S]earch [O]ldfiles', noremap = true })
