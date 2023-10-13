local autopairs = require("nvim-autopairs")
local rule = require("nvim-autopairs.rule")
local conds = require("nvim-autopairs.conds")

autopairs.add_rules {
	rule("<", ">"):with_pair(conds.before_regex("%a+")):with_move(function(opts) return opts.char == ">" end),
}
