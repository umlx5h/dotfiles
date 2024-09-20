require("which-key").setup({
	defer = function(ctx)
		if vim.list_contains({ "d", "y" }, ctx.operator) then
			return true
		end
	end,

	-- prefixに名前を付ける
	spec = {
		{ "<leader>a", group = "add" },
		{ "<leader>b", group = "buffer" },
		{ "<leader>c", group = "code" },
		{ "<leader>f", group = "find" },
		{ "<leader>g", group = "git" },
		{ "<leader>t", group = "terminal" },
		{ "<leader>u", group = "ui/toggle" },
	},
})
