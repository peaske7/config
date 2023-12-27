local dap, dapui = require("dap"), require("dapui")
local opts = { remap = false }

vim.keymap.set("n", "<leader>dt", function()
  dap.toggle_breakpoint()
end, opts)
vim.keymap.set("n", "<leader>dp", function()
  dap.continue()
end, opts)
vim.keymap.set("n", "<leader>do", function()
  dap.step_over()
end, opts)
vim.keymap.set("n", "<leader>di", function()
  dap.step_into()
end, opts)
vim.keymap.set("n", "<leader>dr", function()
  dap.repl.open()
end, opts)

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end
