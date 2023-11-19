local lsp = require("lsp-zero")

lsp.preset("recommended")
lsp.nvim_workspace()
lsp.ensure_installed({
	'rust_analyzer',
	'tsserver',
})
local rust_lsp = lsp.build_options('rust_analyzer', {})

lsp.on_attach(function(_, bufnr)
	local opts = { buffer = bufnr, remap = false }
	lsp.default_keymaps({ buffer = bufnr })

	vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, opts)
	vim.keymap.set("n", "<leader>fr", function() vim.lsp.buf.references() end, opts)
	vim.keymap.set("n", "<leader>ff", function() vim.lsp.buf.format() end, opts)
	vim.keymap.set("n", "<leader>rn", function()
		return ":IncRename " .. vim.fn.expand("<cword>")
	end, { expr = true })
end)

lsp.setup_servers({ 'tsserver', 'rust_analyzer' })
lsp.setup()

vim.diagnostic.config({
	virtual_text = true
})

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
