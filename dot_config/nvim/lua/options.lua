------------------------ Option -----------------------------
local o = vim.o

o.mouse = "a"
o.termguicolors = true
o.laststatus = 3 -- global statusline
o.showmode = false
o.showcmd = false

-- Indenting
-- set tab   :set ts=X (sw=0 sts=0 noet)
-- set space :set ts=8 sw=X sts=-1 et
o.autoindent = true -- default
o.smartindent = true
o.smarttab = true -- default
o.tabstop = 4 -- default
o.softtabstop = 0 -- off
o.shiftwidth = 0 -- same as tabstop
o.expandtab = false -- tab used
-- o.breakindent = true -- indent when text wraps

vim.opt.fillchars = { eob = " " } -- disable ~ after EOF
o.ignorecase = true
o.smartcase = true
o.inccommand = "split" -- interactive substitution

o.number = true
o.relativenumber = true
o.cursorline = true
o.cursorlineopt = "number" -- only highlight line number of the current line
o.ruler = false

o.signcolumn = "yes"
o.splitbelow = true
o.splitright = true
o.timeoutlen = 400
o.updatetime = 250
o.undofile = true

o.scrolloff = 5
o.sidescroll = 1
o.sidescrolloff = 3

-- go to previous/next line with left arrow and right arrow
-- when cursor reaches end/beginning of line
vim.opt.whichwrap:append("<>[]")

o.grepprg = "rg --vimgrep" -- make :grep using ripgrep
o.grepformat = "%f:%l:%c:%m" -- rg format
vim.opt.spelllang:append("cjk") -- exclude Japanese word from spellcheck
o.virtualedit = "block"
o.pumheight = 12 -- set completion max rows

-- treesitter fold
o.foldmethod = "expr"
-- :h vim.treesitter.foldexpr()
o.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- treesitterで自動的に折り畳みを作成
-- ref: https://github.com/neovim/neovim/pull/20750
o.foldtext = "" -- 折り畳みを見やすくする
o.foldlevelstart = 99 -- デフォルトで全て開く
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
