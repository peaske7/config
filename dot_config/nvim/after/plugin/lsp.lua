local lsp = require("lsp-zero")

lsp.on_attach(function(client, bufnr)
	local opts = { buffer = bufnr, remap = false }
	lsp.default_keymaps({ buffer = bufnr })

	vim.keymap.set("n", "<leader>ca", function()
		vim.lsp.buf.code_action()
	end, opts)
	vim.keymap.set("n", "<leader>fr", function()
		vim.lsp.buf.references()
	end, opts)
	vim.keymap.set("n", "<leader>ff",
		function()
			vim.lsp.buf.format()
		end, opts)
	vim.keymap.set("n", "<leader>rn", function()
		return ":IncRename " .. vim.fn.expand("<cword>")
	end, { expr = true })

	if client.server_capabilities.documentSymbolProvider then
		require('nvim-navic').attach(client, bufnr)
	end
end)

require('mason').setup({})
require('mason-lspconfig').setup({
	ensure_installed = { 'rust_analyzer' },
	handlers = {
		lsp.default_setup,
		lua_ls = function()
			local lua_opts = lsp.nvim_lua_ls()
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

local null_ls = require 'null-ls'
null_ls.setup()
require('mason-null-ls').setup({
	handlers = {},
})


vim.diagnostic.config({
	virtual_text = true
})

local cmp = require('cmp')

-- insert `(` after select function or method item
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on(
	'confirm_done',
	cmp_autopairs.on_confirm_done()
)

cmp.setup({
	formatting = lsp.cmp_format(),
	sources = {
		{ name = "copilot" },
		{ name = 'nvim_lsp' },
		{ name = "nvim_lsp_signature_help" },
		{ name = 'buffer' },
		{ name = 'path' },
		{ name = 'crates' },
		{ name = 'luasnip' }
	},
	mapping = {
		['<CR>'] = cmp.mapping.confirm({ select = true })
	}
})
