-- Enable fzf native
pcall(require('telescope').load_extension, 'fzf')

-- Enable args plugin
pcall(require('telescope').load_extension, 'live_grep_args')

local telescope_builtin = require('telescope.builtin')

local opts = { noremap = true }
vim.keymap.set('n', '<leader>sf', telescope_builtin.find_files, opts)
vim.keymap.set('n', '<leader>sg', telescope_builtin.live_grep, opts)

-- grep with telescope from visual mode
vim.keymap.set('v', '<leader>sg', 'zy:Telescope grep_string default_text=<C-r>z<CR>', opts)

vim.keymap.set('n', '<leader>sd', telescope_builtin.diagnostics, opts)
vim.keymap.set('n', '<leader>sb', telescope_builtin.buffers, opts)
vim.keymap.set('n', '<leader>sr', telescope_builtin.resume, opts)
vim.keymap.set('n', '<leader>sq', telescope_builtin.quickfix, opts)
vim.keymap.set('n', '<leader>se', telescope_builtin.registers, opts)
vim.keymap.set('n', '<leader>sh', telescope_builtin.highlights, opts)

-- [v] as in version control
vim.keymap.set('n', '<leader>svc', telescope_builtin.git_commits, opts)
vim.keymap.set('n', '<leader>svb', telescope_builtin.git_branches, opts)
vim.keymap.set('n', '<leader>svss', telescope_builtin.git_status, opts)

vim.keymap.set('n', '<leader>st', '<cmd>TodoTelescope<cr>', opts)

require('telescope').setup {
  pickers = {
    find_files = {
      find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
    },
  },
  extensions = {},
}
