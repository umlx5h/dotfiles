local palette = require("nightfox.palette").load("nightfox")

require("lualine").setup({
	theme = "codedark",
	sections = {
		lualine_a = {
			{
				"mode",
				fmt = function(str)
					return str:sub(1, 1)
				end,
			},
		},
		lualine_b = {
			"branch",
		},
		lualine_c = {
			{
				"filename",
				color = { fg = palette.fg1 }, -- text color brighter
				path = 1,
			},
		},
		lualine_x = { "diagnostics", "filetype" },
		lualine_y = { { "%{fnamemodify(getcwd(), ':t')}", icon = "" } },
		lualine_z = { "progress" },
	},
})
