require('nvim-treesitter.configs').setup {
	ensure_installed = { "tsx", "json", "c", "rust", "lua", "javascript", "vim", "typescript", "terraform", "hcl" },
	auto_install = true,
	autotag = {
		enable = true
	}
}

local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.tsx.filetype_to_parsername = {
	"javascript", "typescript.tsx"
}
