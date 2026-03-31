-- LSP keymaps (attached per-buffer)
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local buf = ev.buf
    local opts = function(desc) return { buffer = buf, remap = false, desc = desc } end

    -- nvim 0.12 defaults: gd, grr, gri, gO, K are built-in
    -- keep custom ones for code action and rename (format handled by conform.nvim)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts("[c]ode [a]ction"))
    vim.keymap.set("n", "<leader>rn", function()
      return ":IncRename " .. vim.fn.expand("<cword>")
    end, { buffer = buf, expr = true, remap = false, desc = "[r]ename [n]ode" })
  end,
})

-- LSP capabilities for folding (nvim-ufo)
vim.lsp.config('*', {
  capabilities = {
    textDocument = {
      foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      },
    },
  },
})

-- Mason: install LSP servers
require('mason').setup()
require('mason-lspconfig').setup({
  handlers = {
    -- default handler for all servers
    function(server_name)
      require('lspconfig')[server_name].setup({})
    end,
    -- lua_ls: add neovim runtime paths
    lua_ls = function()
      require('lspconfig').lua_ls.setup({
        settings = {
          Lua = {
            runtime = { version = 'LuaJIT' },
            workspace = {
              checkThirdParty = false,
              library = { vim.env.VIMRUNTIME },
            },
          },
        },
      })
    end,
    -- svelte: notify on ts/js file changes
    svelte = function()
      require('lspconfig').svelte.setup({
        on_attach = function(client)
          vim.api.nvim_create_autocmd("BufWritePost", {
            pattern = { "*.js", "*.ts" },
            callback = function(ctx)
              client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
            end,
          })
        end,
      })
    end,
  }
})

vim.diagnostic.config({
  virtual_text = true,
})

-- Completion is handled by blink.cmp (configured in init.lua plugin spec)
