require("which-key").setup({
	triggers_blacklist = {
		n = { "y", "d" },
	},
})

-- prefixに名前を付ける
local wk = require("which-key")
wk.register({
	["<leader>"] = {
		a = { name = "+add" },
		b = { name = "+buffer" },
		c = { name = "+code" },
		d = { name = "+debug" },
		f = { name = "+find" },
		g = { name = "+git" },
		u = { name = "+ui/toggle" },
		t = { name = "+terminal" },
	},
})
