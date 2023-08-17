local telescope_status, telescope = pcall(require, 'telescope')
if (not telescope_status) then return end
local telescope_builtin = require('telescope.builtin')
local telescope_actions = require('telescope.actions')
local telescope_config = require('telescope.config')

local trouble_status, trouble = pcall(require, 'trouble')
if (not trouble_status) then return end

-- Clone the default Telescope configuration
local vimgrep_arguments = { unpack(telescope_config.values.vimgrep_arguments) }

-- search in hidden/dot files.
table.insert(vimgrep_arguments, "--hidden")
-- don't search in the `.git` directory.
table.insert(vimgrep_arguments, "--glob")
table.insert(vimgrep_arguments, "!**/.git/*")

telescope.setup {
  defaults = {
    mappings = {
      i = { ["<c-t>"] = trouble.open_with_trouble },
      n = {
        ['q'] = telescope_actions.close,
        ["<c-t>"] = trouble.open_with_trouble
      }
    },
    file_ignore_patterns = {
      ".git/"
    },
    -- `hidden = true` is not supported in text grep commands.
    vimgrep_arguments = vimgrep_arguments
  },
  pickers = {
    find_files = {
      -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
      find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
    },
  },
}

-- keybindings for telescope
vim.keymap.set('n', '<leader>sf', telescope_builtin.find_files, {
  desc = '[S]earch [F]iles', noremap = true
})
vim.keymap.set('n', '<leader>sh', telescope_builtin.help_tags, {
  desc = '[S]earch [H]elp', noremap = true
})
vim.keymap.set('n', '<leader>sw', telescope_builtin.grep_string, {
  desc = '[S]earch current [W]ord', noremap = true
})
vim.keymap.set('n', '<leader>sg', telescope_builtin.live_grep, {
  desc = '[S]earch by [G]rep', noremap = true
})
vim.keymap.set('n', '<leader>sd', telescope_builtin.diagnostics, {
  desc = '[S]earch [D]iagnostics', noremap = true
})
vim.keymap.set('n', '<leader>sre', telescope_builtin.resume, {
  desc = '[S]earch [R]esume', noremap = true
})
vim.keymap.set('n', '<leader>srr', telescope_builtin.registers, {
  desc = '[S]earch [R]egisters', noremap = true
})
vim.keymap.set('n', '<leader>sb', telescope_builtin.buffers, {
  desc = '[S]earch [B]uffers', noremap = true
})

-- keybindings for trouble (diagnostics viewer)
vim.keymap.set("n", "<leader>xx", function() require("trouble").open() end, {
  desc = 'Open diagnostics', noremap = true
})
vim.keymap.set("n", "<leader>xw", function() require("trouble").open("workspace_diagnostics") end, {
  desc = 'Open workspace diagnostics', noremap = true
})
vim.keymap.set("n", "<leader>xd", function() require("trouble").open("document_diagnostics") end, {
  desc = 'Open document diagnostics', noremap = true
})
vim.keymap.set("n", "<leader>xq", function() require("trouble").open("quickfix") end, {
  desc = 'Open quickfix', noremap = true
})
vim.keymap.set("n", "<leader>xl", function() require("trouble").open("loclist") end, {
  desc = 'Open loclist', noremap = true
})
