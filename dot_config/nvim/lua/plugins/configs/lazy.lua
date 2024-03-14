return {
	defaults = { lazy = true },
	install = { colorscheme = { "nightfox" } },
	performance = {
		rtp = {
			-- r !ls /usr/share/nvim/runtime/plugin/
			-- :Lazy profile
			disabled_plugins = {
				-- "editorconfig",
				-- "gzip",
				-- "man",
				"matchit",
				"matchparen",
				"netrwPlugin",
				-- "nvim",
				-- "osc52",
				"rplugin",
				-- "shada",
				-- "spellfile",
				-- "tarPlugin",
				"tohtml",
				"tutor",
				-- "zipPlugin",
			},
		},
	},
}
