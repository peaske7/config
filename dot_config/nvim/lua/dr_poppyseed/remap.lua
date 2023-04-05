vim.keymap.set("i", "jk", "<Esc>", {
	desc = 'Escape insert mode',
	noremap = true
})

vim.keymap.set("n", "<leader>o", vim.cmd.Ex, {
	desc = 'Open netrw'
})

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

