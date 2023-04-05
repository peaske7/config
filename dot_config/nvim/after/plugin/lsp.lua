local status, lsp = pcall(require, "lsp-zero")
if (not status) then
  print('lsp-zero not installed')
  return
end

lsp.preset("recommended")

lsp.ensure_installed({
  'rust_analyzer',
  'tsserver',
  'lua_ls'
})

-- Fix Undefined global 'vim'
lsp.configure('lua_ls', {
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' }
      }
    }
  }
})

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
  ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
  ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
  ['<C-y>'] = cmp.mapping.confirm({ select = true }),
  ["<C-Space>"] = cmp.mapping.complete(),
})

cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil

lsp.setup_nvim_cmp({
  mapping = cmp_mappings
})

lsp.set_preferences({
  suggest_lsp_servers = false,
  sign_icons = {
    error = 'E',
    warn = 'W',
    hint = 'H',
    info = 'I'
  }
})

lsp.on_attach(function(_, bufnr)
  lsp.default_keymaps({ buffer = bufnr })

  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, {
    desc = '[G]et [Definition]',
    buffer = bufnr, remap = false
  })
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, {
    desc = 'Hover',
    buffer = bufnr, remap = false
  })
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, {
    desc = 'Next option',
    buffer = bufnr, remap = false
  })
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, {
    desc = 'Previous option',
    buffer = bufnr, remap = false
  })
  vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, {
    desc = '[C]ode [A]ction',
    buffer = bufnr, remap = false
  })
  vim.keymap.set("n", "<leader>fr", function() vim.lsp.buf.references() end, {
    desc = '[F]ind [R]eferences',
    buffer = bufnr, remap = false
  })
  vim.keymap.set("n", "<leader>ff", '<cmd>LspZeroFormat<cr>', {
    desc = '[F]ormat [F]ile',
    buffer = bufnr, remap = false
  })
  vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, {
    desc = '[R]e[N]ame',
    buffer = bufnr, remap = false
  })
end)

lsp.setup()

vim.diagnostic.config({
  virtual_text = true
})
