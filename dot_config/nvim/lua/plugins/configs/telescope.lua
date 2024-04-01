local lga_actions = require("telescope-live-grep-args.actions")
local telescope = require("telescope")

telescope.setup({
	defaults = {
		sorting_strategy = "ascending",
		layout_config = {
			horizontal = {
				prompt_position = "top",
				preview_width = 0.55,
			},
			width = 0.87,
			height = 0.80,
		},
		path_display = { "truncate" }, -- find_filesなどで長いファイル名をtruncate

		file_ignore_patterns = {
			"node_modules",
			".git/",
			"package-lock.json",
			"yarn.lock",
		},
	},

	pickers = {
		find_files = {
			hidden = true,
		},
		live_grep = {
			additional_args = function()
				return { "--hidden" }
			end,
		},
		buffers = {
			mappings = {
				i = {
					["<C-d>"] = "delete_buffer", -- バッファ一覧画面でCtrl+Dで消せるようにする
				},
			},
		},
	},

	extensions = {
		-- ref: https://github.com/nvim-telescope/telescope-live-grep-args.nvim?tab=readme-ov-file#configuration
		live_grep_args = {
			auto_quoting = true,
			mappings = {
				i = {
					["<C-k>"] = lga_actions.quote_prompt(),
				},
			},
		},
	},
})

local telescope_extensions = { "fzf", "live_grep_args" }

for _, extension in ipairs(telescope_extensions) do
	telescope.load_extension(extension)
end
