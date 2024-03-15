vim.api.nvim_create_user_command("DiffClip", function()
	vim.cmd([[
		let ft=&ft
		leftabove vnew [Clipboard]
		setlocal bufhidden=wipe buftype=nofile noswapfile
		put +
		0d_
		" remove CR for Windows
		silent %s/\r$//e
		execute "set ft=" . ft
		diffthis
		" setlocal nomodifiable
		wincmd p
		diffthis
	]])
end, { desc = "Compare Active File with Clipboard" })

vim.api.nvim_create_user_command("DiffOrig", function()
	vim.cmd([[
		let ft=&ft
		leftabove vnew [Original]
		setlocal bufhidden=wipe buftype=nofile noswapfile
		read ++edit #
		0d_
		execute "set ft=" . ft
		diffthis
		setlocal nomodifiable
		wincmd p
		diffthis
	]])
end, { desc = "Compare Active File with Saved" })

-- j, kとgj, gkを入れ替えるコマンド
vim.api.nvim_create_user_command("WrapCursorToggle", function()
	if vim.fn.mapcheck("j", "n") ~= "" then
		vim.api.nvim_del_keymap("n", "j")
		vim.api.nvim_del_keymap("n", "k")
	else
		-- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
		-- http://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
		-- empty mode is same as using <cmd> :map
		-- also don't use g[j|k] when in operator pending mode, so it doesn't alter d, y or c behaviour
		local map = vim.keymap.set
		map("n", "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { desc = "Move down", expr = true })
		map("n", "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { desc = "Move up", expr = true })
	end
end, { desc = "Toggle cursor movement mode when text wraps" })

vim.api.nvim_create_user_command("QFToggle", function()
	local function qf_exist()
		for _, w in ipairs(vim.fn.getwininfo()) do
			if w.quickfix == 1 then
				return true
			end
		end
		return false
	end

	if qf_exist() then
		vim.notify("cclose")
		vim.cmd.cclose()
	else
		vim.notify("copen")
		vim.cmd.copen()
	end
end, { desc = "Toggle quickfix window" })

vim.api.nvim_create_user_command("SetTermTab", function()
	local dir_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")

	local Job = require("plenary.job")
	Job:new({
		command = "sh",
		args = {
			"-c",
			string.format(
				"wezterm cli set-tab-title --pane-id $(wezterm cli list-clients | awk '{print $NF}' | tail -1) '%s'",
				dir_name
			),
		},
		on_exit = function(j, return_val)
			if return_val ~= 0 then
				print(j:result())
			end
		end,
	}):start()
end, { desc = "Set current project name to wezterm tab name" })

vim.api.nvim_create_user_command("ShowIndentOpt", function()
	vim.cmd([[
		verbose setlocal ts? sts? sw? et?
	]])
end, { desc = "Show current indent options" })

local toggle_diagnostics_enabled = true
vim.api.nvim_create_user_command("DiagnosticsToggle", function()
	toggle_diagnostics_enabled = not toggle_diagnostics_enabled
	if toggle_diagnostics_enabled then
		vim.api.nvim_echo({ { "Enabled diagnostics" } }, false, {})
		vim.schedule(function()
			vim.diagnostic.enable()
		end)
	else
		vim.api.nvim_echo({ { "Disabled diagnostic" } }, false, {})
		vim.schedule(function()
			vim.diagnostic.disable()
		end)
	end
end, { desc = "Toggle diagnostics" })

-- Open URL in browser
-- :Browse http://example.com
-- Makes it possible for `:GBrowse` to work with netrw plugin disabled
-- The idea was taken from https://github.com/kyazdani42/nvim-tree.lua/issues/559#issuecomment-962593611
vim.api.nvim_create_user_command("Browse", function(opts)
	-- required: created symlink 'open' to 'xdg-open' in Linux
	vim.cmd("silent !open " .. vim.fn.shellescape(opts.args, true))
end, {
	nargs = 1,
})

-- Oil (replacing netrw)
vim.api.nvim_create_user_command("Explore", "Oil <args>", { nargs = "?", complete = "dir" })
vim.api.nvim_create_user_command("E", "Explore <args>", { nargs = "?", complete = "dir" })
vim.api.nvim_create_user_command("Sexplore", "belowright split | Oil <args>", { nargs = "?", complete = "dir" })
-- vim.api.nvim_create_user_command("Vexplore", "leftabove vsplit | Oil <args>", { nargs = "?", complete = "dir" })
vim.api.nvim_create_user_command("Vexplore", "rightbelow vsplit | Oil <args>", { nargs = "?", complete = "dir" })
vim.api.nvim_create_user_command("Texplore", "tabedit % | Oil <args>", { nargs = "?", complete = "dir" })
