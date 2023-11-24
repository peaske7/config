local trouble = require("trouble")

trouble.setup({
  icons = false,
  fold_open = "v",
  fold_closed = ">",
  indent_lines = false,
  signs = {
    error = "error",
    warning = "warn",
    hint = "hint",
    information = "info"
  },
  use_diagnostic_signs = true
})

local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<leader>xx", function()
  trouble.open()
end, opts)
vim.keymap.set("n", "<leader>xw", function()
  trouble.open("workspace_diagnostics")
end, opts)
vim.keymap.set("n", "<leader>xd", function()
  trouble.open("document_diagnostics")
end, opts)
vim.keymap.set("n", "<leader>xq", function()
  trouble.open("quickfix")
end, opts)
