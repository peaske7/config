vim.keymap.set("n", "<leader>xx", function() require("trouble").open() end, {
	noremap = true
})
vim.keymap.set("n", "<leader>xw", function() require("trouble").open("workspace_diagnostics") end, {
	noremap = true
})
vim.keymap.set("n", "<leader>xd", function() require("trouble").open("document_diagnostics") end, {
	noremap = true
})
vim.keymap.set("n", "<leader>xq", function() require("trouble").open("quickfix") end, {
	noremap = true
})
