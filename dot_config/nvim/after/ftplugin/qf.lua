-- option
vim.opt_local.buflisted = false

-- TODO: 有効にする
-- vim.opt_local.winfixbuf = true
vim.opt_local.relativenumber = false

-- keymap
local map = vim.keymap.set
local opt = { buffer = true }

map("n", "<TAB>", "<CR>zz<C-w>p", opt)
map("n", "o", "<CR>zz<C-w>p", opt)
map("n", "<C-o>", "<CR><Cmd>cclose<CR>", opt)
-- map("n", "J", "j<CR><C-w>p", opt)
-- 履歴に残さないためkeepjumpsを使う
map("n", "J", [[j<Cmd>exec "keepjumps cc " . line(".")<CR>zz<C-w>p]], opt)
map("n", "K", [[k<Cmd>exec "keepjumps cc " . line(".")<CR>zz<C-w>p]], opt)

map("n", "<", ":colder<CR>", { buffer = true, nowait = true })
map("n", ">", ":cnewer<CR>", { buffer = true, nowait = true })

map("n", "<C-v>", "<C-w><CR><C-w>L<C-w>p<C-w>J<C-w>p", opt)
map("n", "<C-x>", "<C-w><CR><C-w>K", opt)
map("n", "<C-t>", "<C-w><CR><C-w>T", opt)

-- replace
map("n", "R", ":cdo s///g<Left><Left><Left>", opt)
map("n", "U", ":cdo update", opt)

-- help message
map("n", "gh", function()
	local help = {
		["<TAB>"] = "Preview entry (TAB or o)",
		["o"] = "Preview entry (TAB or o)",
		["<C-o>"] = "Open entry and close",
		["J"] = "Select next entry",
		["K"] = "Select prev entry",
		["<"] = "Go to older quickfix",
		[">"] = "Go to newer quickfix",
		["<C-v>"] = "Open entry with vertical split",
		["<C-x>"] = "Open entry with horizontal split",
		["<C-t>"] = "Open entry with tab",
		["R"] = "Replace with cdo",
		["U"] = "Update with cdo",
	}
	vim.api.nvim_echo({ { vim.inspect(help) } }, false, {})
end)
