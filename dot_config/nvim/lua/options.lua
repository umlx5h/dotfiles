------------------------ Option -----------------------------
local opt = vim.opt

opt.mouse = "a"
opt.termguicolors = true
opt.laststatus = 3 -- global statusline
opt.showmode = false
opt.showcmd = false

-- Indenting
-- set tab   :set ts=4 sw=0 noet
-- set space :set sw=4
opt.autoindent = true -- default
opt.smartindent = true
opt.smarttab = true -- default
opt.tabstop = 8 -- default
opt.softtabstop = -1 -- same as 'shiftwidth'
opt.shiftwidth = 2 -- default: indent is 2
opt.expandtab = true -- default: tab is not used
opt.breakindent = true -- indent when text wraps

opt.fillchars = { eob = " " } -- disable ~ after EOF
opt.ignorecase = true
opt.smartcase = true
opt.inccommand = "split" -- interactive substitution

opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.cursorlineopt = "number" -- only highlight line number of the current line
opt.ruler = false

opt.signcolumn = "yes"
opt.splitbelow = true
opt.splitright = true
opt.timeoutlen = 400
opt.undofile = true

opt.timeoutlen = 400
opt.updatetime = 250

opt.scrolloff = 5
opt.sidescroll = 1
opt.sidescrolloff = 3

-- go to previous/next line with left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append("<>[]")

opt.grepprg = "rg --vimgrep" -- make :grep using ripgrep
opt.grepformat = "%f:%l:%c:%m" -- rg format
opt.spelllang:append("cjk") -- exclude Japanese word from spellcheck
opt.virtualedit = "block"
opt.pumheight = 12 -- set completion max rows

-- treesitter fold
opt.foldmethod = "expr"
-- :h vim.treesitter.foldexpr()
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- treesitterで自動的に折り畳みを作成
-- ref: https://github.com/neovim/neovim/pull/20750
opt.foldtext = "" -- 折り畳みを見やすくする
opt.foldlevelstart = 99 -- デフォルトで全て開く
-- TODO: 最初に全て開く時にzR か foldopenを使わないとzmが動かない問題がある
-- vim.cmd [[autocmd BufWinEnter * silent! :%foldopen!]]
-- vim.api.nvim_create_autocmd({ "BufReadPost", "FileReadPost" }, { command = "normal zR" })

-- diffモードではtreesitterのfoldtextを使わずデフォルトに戻す
vim.api.nvim_create_autocmd({ "OptionSet" }, {
	group = vim.api.nvim_create_augroup("reset_foldtext_when_diffmode", { clear = true }),
	desc = "Reset 'foldtext' to default when diff mode",
	pattern = "diff",
	callback = function()
		vim.cmd([[
			if v:option_new
				setlocal foldtext&
			else
				setlocal foldtext=v:lua.vim.treesitter.foldtext()
			endif
		]])
	end,
})

------------------------ Variable -----------------------------

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.man_hardwrap = 0 -- manpageでコピペしやすく

-- disable netrw early
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- netrw
-- vim.g.netrw_preview = 1 -- 縦分割
-- vim.g.netrw_alto = 0

-- add binaries installed by mason.nvim to path
vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin:" .. vim.env.PATH
