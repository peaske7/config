local status, telescope = pcall(require, 'telescope')
if (not status) then return end
local telescope_builtin = require('telescope.builtin')
local telescope_actions = require('telescope.actions')

local fb_actions = require 'telescope'.extensions.file_browser.actions

telescope.setup {
  defaults = {
    mappings = {
      n = {
        ['q'] = telescope_actions.close
      }
    }
  },
  extensions = {
    file_browser = {
      theme = 'dropdown',
      hijack_netrw = true,
      mappings = {
        ['n'] = {
          ['N'] = fb_actions.create,
          ['R'] = fb_actions.rename,
          ['M'] = fb_actions.move,
          ['D'] = fb_actions.remove
        }
      }
    }
  }
}

telescope.load_extension('file_browser')

vim.keymap.set('n', '<leader>sf',
  function()
    telescope_builtin.find_files({
      path = "%:p:h",
      hidden = true
    })
  end,
  { desc = '[S]earch [F]iles', noremap = true }
)
vim.keymap.set('n', '<leader>sh', telescope_builtin.help_tags, { desc = '[S]earch [H]elp', noremap = true })
vim.keymap.set('n', '<leader>sw', telescope_builtin.grep_string, { desc = '[S]earch current [W]ord', noremap = true })
vim.keymap.set('n', '<leader>sg', telescope_builtin.live_grep, { desc = '[S]earch by [G]rep', noremap = true })
vim.keymap.set('n', '<leader>sd', telescope_builtin.diagnostics, { desc = '[S]earch [D]iagnostics', noremap = true })
vim.keymap.set('n', '<leader>fb', function()
  telescope.extensions.file_browser.file_browser({
    path = "%:p:h",
    hidden = true,
    initial_mode = "normal",
  })
end, { desc = '[F]ile [B]rowser', noremap = true })
