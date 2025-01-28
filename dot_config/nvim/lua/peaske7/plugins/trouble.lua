return {
  {
    "folke/trouble.nvim",
    version = 'v2.x',
    event = "BufReadPre",
    config = function()
      local t = require("trouble")
      local opts = { noremap = true, silent = true }

      t.setup({
        fold_open = "v",
        fold_closed = ">",
        indent_lines = false,
        signs = {
          error = "error",
          warning = "warn",
          hint = "hint",
          information = "info"
        },
        modes = {
          test = {
            mode = "diagnostics",
            preview = {
              type = "split",
              relative = "win",
              position = "right",
              size = 0.3,
            },
          },
        },
        use_diagnostic_signs = true
      })


      local function quickfix()
        vim.lsp.buf.code_action({
          filter = function(a) return a.isPreferred end,
          apply = true
        })
      end

      vim.keymap.set('n', '<leader>qf', quickfix, opts)

      vim.keymap.set("n", "<leader>xx", function() t.open() end, opts)
      vim.keymap.set("n", "<leader>xw", function() t.open("workspace_diagnostics") end, opts)
      vim.keymap.set("n", "<leader>xd", function() t.open("document_diagnostics") end, opts)
      vim.keymap.set("n", "<leader>xq", function() t.open("quickfix") end, opts)
    end
  },
}
