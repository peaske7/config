local lsp_zero = require("lsp-zero") -- TODO: remove lsp_zero

lsp_zero.on_attach(function(_, bufnr)
  local opts = { buffer = bufnr, remap = false }
  lsp_zero.default_keymaps({
    buffer = bufnr,
    preserve_mappings = false,
  })

  vim.keymap.set("n", "<leader>ca", function()
    vim.lsp.buf.code_action()
  end, opts)
  vim.keymap.set("n", "<leader>fr", function()
    require('telescope.builtin').lsp_references()
  end, opts)
  vim.keymap.set("n", "<leader>ff", function()
    vim.lsp.buf.format()
  end, opts)
  vim.keymap.set("n", "<leader>rn", function()
    return ":IncRename " .. vim.fn.expand("<cword>")
  end, { expr = true })
end)

lsp_zero.set_server_config({
  capabilities = {
    textDocument = {
      foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true
      }
    }
  }
})

vim.g.rustaceanvim = {
  server = {
    capabilities = lsp_zero.get_capabilities()
  },
}

-- scala metals configuration
local metals_config = require('metals').bare_config()
metals_config.capabilities = lsp_zero.get_capabilities()

local metals_augroup = vim.api.nvim_create_augroup('nvim-metals', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  group = metals_augroup,
  pattern = { 'scala', 'sbt', 'java' },
  callback = function()
    require('metals').initialize_or_attach(metals_config)
  end
})

require('mason').setup()
require('mason-null-ls').setup({
  ensure_installed = nil,
  automatic_installation = false,
  handlers = {},
})

local null_opts = lsp_zero.build_options('null-ls', {})
require('null-ls').setup({
  on_attach = function(client, bufnr)
    null_opts.on_attach(client, bufnr)
  end,
})

require('mason-lspconfig').setup({
  handlers = {
    function(server_name)
      require('lspconfig')[server_name].setup({})
    end,
    lua_ls = function()
      local lua_opts = lsp_zero.nvim_lua_ls()
      require('lspconfig').lua_ls.setup(lua_opts)
    end,
    gopls = function()
      -- go ray-x/go.nvim
      require('go').setup {
        lsp_cfg = false
      }
      local cfg = require('go.lsp').config()
      require('lspconfig').gopls.setup(cfg)
    end,
    rust_analyzer = lsp_zero.noop,
    svelte = function()
      require('lspconfig').svelte.setup({
        on_attach = function(client, bufnr)
          vim.api.nvim_create_autocmd("BufWritePost", {
            pattern = { "*.js", "*.ts" },
            callback = function(ctx)
              -- Here use ctx.match instead of ctx.file
              client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
            end,
          })
        end,
      })
    end
  }
})

vim.diagnostic.config({
  virtual_text = true
})

local cmp = require('cmp')
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
local cmp_action = lsp_zero.cmp_action()

-- insert `(` after select function or method item
cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done({
    sh = false,
  })
)

-- snippets
local luasnip = require('luasnip')
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup({
  preselect = 'item',
  completion = {
    completeopt = 'menu,menuone,noinsert'
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'nvim_lsp_signature_help' },
    { name = "copilot" },
    { name = "luasnip",                keyword_length = 2 },
    { name = 'path',                   keyword_length = 3 },
    { name = 'buffer',                 keyword_length = 3 },
  },
  mapping = {

    ['<C-n>'] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
    ['<C-p>'] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
    ['<C-y>'] = cmp.mapping(
      cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Insert,
        select = true
      },
      { "i", "c" }
    ),

    -- Scroll up and down in the completion documentation
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
  },

  -- Enable luasnip to handle snippet expansion for nvim-cmp
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  formatting = lsp_zero.cmp_format({ details = false }),
})
