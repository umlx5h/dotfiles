-- highlight yanked region, see `:h lua-highlight`
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
	group = vim.api.nvim_create_augroup("highlight_yank", {}),
	desc = "highlight after yank",
	callback = function()
		vim.highlight.on_yank({ higroup = "HighlightYank", timeout = 180 })
	end,
})

local autoInsertTerminal = vim.api.nvim_create_augroup("auto_insert_terminal", {})
-- auto enter to insert mode in Terminal mode
vim.api.nvim_create_autocmd("TermOpen", {
	group = autoInsertTerminal,
	pattern = "*",
	callback = function()
		vim.cmd([[
			setlocal nonumber norelativenumber
			startinsert
		]])
	end,
})
vim.api.nvim_create_autocmd("BufEnter", {
	group = autoInsertTerminal,
	pattern = "term://*",
	-- command = "startinsert",
	callback = function()
		local start_line = vim.fn.line("w0")
		local end_line = vim.fn.line("w$")
		-- insert modeのカーソル位置 = terminal buffferの一番下と仮定
		-- TODO: insert modeのカーソルポジションを取れるAPIに差し替える
		-- https://github.com/neovim/neovim/issues/26600
		local cursor_line = vim.fn.line("$")

		-- insert modeのカーソル位置が現在のウィンドウに入っていた時のみinsertmodeに入る
		if start_line <= cursor_line and cursor_line <= end_line then
			vim.cmd.startinsert()
		end
	end,
})

-- -- netrwとbufferlineを組み合わせる時にゴミが残るのを対策
-- -- pluginの中で行うことにした
-- vim.api.nvim_create_autocmd({ "FileType" }, {
-- 	pattern = "netrw",
-- 	callback = function()
-- 		vim.cmd([[
-- 			if b:netrw_curdir == bufname(bufnr('#')) && buflisted(bufnr('#'))
-- 				" unsilentを使わないと出ないので注意
-- 				"" unsilent echo "delete buffer"
-- 				bd #
-- 			fi
-- 		]])
-- 	end,
-- })
