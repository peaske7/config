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
