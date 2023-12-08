local lsp_zero = require("lsp-zero")

lsp_zero.on_attach(function(client, bufnr)
  local opts = { buffer = bufnr, remap = false }
  lsp_zero.default_keymaps({ buffer = bufnr })

  if client.name == "rust-analyzer" or client.name == "tsserver" then
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentFormattingRangeProvider = false
  end

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

require('mason').setup({})
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
    lsp_zero.default_setup,
    lua_ls = function()
      local lua_opts = lsp_zero.nvim_lua_ls()
      require('lspconfig').lua_ls.setup(lua_opts)
    end,
    rust_analyzer = function()
      local rust_tools = require('rust-tools')
      rust_tools.setup({
        server = {
          on_attach = function(_, bufnr)
            vim.keymap.set('n', '<leader>ca',
              rust_tools.hover_actions.hover_actions,
              { buffer = bufnr }
            )
          end
        }
      })
    end,
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

-- Tab Completion Configuration as recommended in the copilot-cmp README
local has_words_before = function()
  if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
end

-- snippets
local luasnip = require('luasnip')
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  completion = {
    completeopt = 'menu,menuone,noinsert'
  },
  sources = {
    { name = "copilot" },
    { name = 'nvim_lsp' },
    { name = 'nvim_lsp_signature_help' },
    { name = 'path' },
    { name = 'buffer' },
    { name = 'luasnip' }
  },
  mapping = {
    -- Tab completion for copilot
    ["<Tab>"] = vim.schedule_wrap(function(fallback)
      if cmp.visible() and has_words_before() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
      else
        fallback()
      end
    end),

    ['<CR>'] = cmp.mapping.confirm({ select = true }),

    -- Scroll up and down in the completion documentation
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),

    -- Navigate between snippet placeholder
    ['<C-f>'] = cmp_action.luasnip_jump_forward(),
    ['<C-b>'] = cmp_action.luasnip_jump_backward(),
  },
  formatting = lsp_zero.cmp_format(),
})
