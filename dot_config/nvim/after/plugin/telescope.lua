-- Enable fzf native
pcall(require('telescope').load_extension, 'fzf')
local telescope_builtin = require('telescope.builtin')

local opts = { noremap = true }
vim.keymap.set('n', '<leader>sf', telescope_builtin.find_files, opts)
vim.keymap.set('n', '<leader>sg', telescope_builtin.live_grep, opts)

-- grep with telescope from visual mode
vim.keymap.set('v', '<leader>sg', 'zy:Telescope grep_string default_text=<C-r>z<CR>', opts)

vim.keymap.set('n', '<leader>sd', telescope_builtin.diagnostics, opts)
vim.keymap.set('n', '<leader>sb', telescope_builtin.buffers, opts)
vim.keymap.set('n', '<leader>sr', telescope_builtin.resume, opts)

vim.keymap.set('n', '<leader>st', '<cmd>TodoTelescope<cr>', opts)

vim.keymap.set('n', '<leader><leader>', '<cmd>Telescope cmdline<cr>', opts)

require('telescope').setup {
  pickers = {
    find_files = {
      find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
    },
  },
  extensions = {
    frecency = {
      show_scores = true,
      show_unindexed = true,
      ignore_patterns = { "*.git/*", "*/tmp/*" },
      disable_devicons = true,
      db_safe_mode = false,
      auto_validate = true,
      workspaces = {
        ["conf"]      = "~/.config",
        ["data"]      = "~/.local/share",
        ["developer"] = "~/Developer",
      }
    }
  },
}
