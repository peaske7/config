vim.keymap.set("i", "jk", "<Esc>", {
	desc = 'Escape insert mode',
	noremap = true
})

vim.keymap.set("n", "<C-e>", vim.cmd.Ex, {
	desc = 'Open netrw',
	noremap = true
})

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
