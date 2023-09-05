local lsp = require("lsp-zero")

lsp.preset("recommended")

-- Fix Undefined global 'vim'
lsp.nvim_workspace()
lsp.ensure_installed({
  'rust_analyzer',
  'terraformls',
  'tsserver',
  'clangd',
  'eslint'
})
local rust_lsp = lsp.build_options('rust_analyzer', {})

lsp.on_attach(function(_, bufnr)
  local opts = { buffer = bufnr, remap = false }
  lsp.default_keymaps({ buffer = bufnr })

  vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set("n", "<leader>fr", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "<leader>ff", function() vim.lsp.buf.format() end, opts)
  vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
end)

lsp.setup_servers({ 'tsserver', 'eslint', 'rust_analyzer', 'terraformls' })

-- Fix terraform support
require('lspconfig').terraformls.setup({})
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*.tf", "*.tfvars" },
  callback = function()
    vim.lsp.buf.format()
  end,
})

lsp.setup()

vim.diagnostic.config({
  virtual_text = true
})

-- Initialize rust_analyzer with rust-tools
require('rust-tools').setup({ server = rust_lsp })

local cmp = require('cmp')

-- insert `(` after select function or method item
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)

cmp.setup({
  sources = {
    { name = "copilot",                 group_index = 2 },
    { name = 'nvim_lsp',                group_index = 2 },
    { name = "nvim_lsp_signature_help", group_index = 2 },
    { name = "vsnip",                   group_index = 2 },
    { name = 'buffer',                  group_index = 2 },
    { name = 'path',                    group_index = 2 },
    { name = 'crates',                  group_index = 2 },
    { name = 'luasnip',                 group_index = 2 },
  },
  mapping = {
    ['<CR>'] = cmp.mapping.confirm({ select = true })
  }
})
