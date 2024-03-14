local map = vim.keymap.set

-----------------------------------------------------------------------------------------------
-----------------------------------  Vim Core mapping -----------------------------------------
-----------------------------------------------------------------------------------------------

-- -- EscapeをCtrl-Cに割り当てる
-- -- 従来のC-cはInsertLeave autocommandを発火しないので、copilotなどでバグが起きる
-- -- これを設定すると count i foo や visual block modeでキャンセルすることができなくなるが許容する
-- map("i", "<C-c>", "<Esc>", { desc = "Escape insert-mode" })

-- Relative numberで行番号を見やすくする
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll window downwards with centering" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll window upwards with centering" })

-- "0pを打ちやすく
map({ "n", "x" }, "<leader>p", [["0p]], { desc = "paste from yank register" })
map("n", "<leader>P", [["0P]], { desc = "Paste from yank register" })

-- v_p と v_P を入れ替える
-- map("x", "p", "P")
-- map("x", "P", "p")

-- system clipboard
map({ "n", "x" }, "<leader>y", [["+y]], { desc = "yank system clipboard" })
map("x", "<F3>", [["+y]], { desc = "yank system clipboard" }) -- <F3> = CTRL+C or CMD+C
map("n", "<leader>Y", [["+y$]], { desc = "Yank system clipboard" })
map("x", "<leader>d", [["+d]], { desc = "delete with clipboard" })
map("n", "<leader>dd", [["+dd]], { desc = "Delete line with clipboard" })

-- Alternative to VSCode Ctrl+D
map(
	"x",
	"gs",
	[[y:let @/ = '\V\C' . substitute(escape(@0, '/\'), '\n', '\\n', 'g')<CR>:set hls<CR>cgn]],
	{ desc = "Replace word under cursor" }
)
map("n", "gs", [[:let @/ = '\C\<'.expand('<cword>').'\>'<CR>:set hls<CR>cgn]], { desc = "Replace word under cursor" })
-- 検索履歴に入るver (大文字小文字無視)
-- map("x", "gs", "*Ncgn", { remap = true })
-- map("n", "gs", "*Ncgn")
map("x", "g/", [[y:%s/\V<c-r>"//g<left><left>]], { desc = "Replace word under cursor globally" })

-- emacs keybiding in insert mode
map("i", "<C-p>", "<Up>", { desc = "Emacs Up" })
map("i", "<C-n>", "<Down>", { desc = "Emacs Down" })
map("i", "<C-b>", "<Left>", { desc = "Emacs Left" })
map("i", "<C-f>", "<Right>", { desc = "Emacs Right" })
map("i", "<C-a>", "<Home>", { desc = "Emacs Home" })
map("i", "<C-e>", "<End>", { desc = "Emacs End" })
map("i", "<C-d>", "<Delete>", { desc = "Emacs Delete" }) -- Conflict indent delete
map("i", "<C-h>", "<BS>", { desc = "Emacs Backspace" })
-- disable for conflict (enter digraph)
-- map("i", "<C-k>", function()
-- 	return "<C-o>D"
-- end, { desc = "Emacs Cut line", silent = true, expr = true })

-- コマンドモードでCTRL-P,Nの挙動を矢印と入れ替える
map("c", "<C-p>", "<Up>")
map("c", "<C-n>", "<Down>")
map("c", "<Up>", "<C-p>")
map("c", "<Down>", "<C-n>")

-- neovim default :h &-default
map("x", "&", ":&&<CR>", { desc = "Repeat last substitute with same flag" })

-- 連続してインデント可能にする
map("x", "<", "<gv", { desc = "Indent line" })
map("x", ">", ">gv", { desc = "Indent line" })

-- Ctrl+j,kでまとめて上下に移動
map("x", "<C-k>", ":m '<-2<CR>gv=gv", { desc = "chunk moving up" })
map("x", "<C-j>", ":m '>+1<CR>gv=gv", { desc = "chunk moving down" })

map("n", "<A-a>", "ggVG", { desc = "Select all" })

-- 完全一致検索
map(
	"n",
	"<leader>s",
	-- [[<cmd>let search = input('Search literally: ') | redraw | execute '/\V' . escape(search, '/\') <CR>]],
	[[<cmd>let search = input('Search literally: ') | redraw | execute '/\V' . substitute(escape(search, '/\'), '\\n', 'n', 'g') <CR>]], -- 複数行の検索に対応 \nだけ改行文字として認識させる
	{ desc = "Literal Search" }
)

-- コマンドラインモードでCTRL-% (CTRL-])で %:h に展開してくれる、現在開いているファイルを基準にパスを作成可能
-- :h filename-modifiers
map(
	"c",
	"<C-]>",
	"getcmdtype() == ':' ? expand('%:~:.:h').'/' : '%%'",
	{ silent = false, expr = true, desc = "Expand current file dir" }
)

-----------------------------------------------------------------------------------------------
-----------------------------------  General mapping ------------------------------------------
-----------------------------------------------------------------------------------------------

map("n", "<Esc><Esc>", "<cmd> noh <CR>", { desc = "Clear highlights" })

-- switch between windows
map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })

-- save
map({ "n", "i" }, "<C-s>", "<cmd> w <CR>", { desc = "Save file" })
map("n", "<leader>ww", "<cmd> noautocmd w <CR>", { desc = "Save without format" })

-- manpage
map("n", "<leader>K", "<cmd> Man <CR>", { desc = "Search in Manpage" })
map("x", "<leader>K", 'y:Man <c-r>" <CR>', { desc = "Search in Manpage" })

-- terminal mode
map("t", "<C-x>", "<C-\\><C-n>", { desc = "Escape Terminal" })
map("t", "<C-v><C-x>", "<C-\\><C-n>", { desc = "Sent <C-x> in Terminal" })
map("t", "<C-v><C-v>", "<C-v>", { desc = "Sent <C-v> in Terminal" })
-- map("t", "<Esc>", "<C-\\><C-n>", { desc = "Escape Terminal mode" })
-- map("t", "<C-v><Esc>", "<Esc>", { desc = "Enter ESC on terminal mode" })
map("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to left window" })
map("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to lower window" })
map("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to upper window" })
map("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to right window" })
map("t", "<C-v><C-h>", "<C-h>", { desc = "Sent <C-h> in Terminal" })
map("t", "<C-v><C-j>", "<C-j>", { desc = "Sent <C-j> in Terminal" })
map("t", "<C-v><C-k>", "<C-k>", { desc = "Sent <C-k> in Terminal" })
map("t", "<C-v><C-l>", "<C-l>", { desc = "Sent <C-l> in Terminal" })

-- terminal
map("n", "<leader>ts", "<cmd> split | redraw! | terminal <cr>", { desc = "Horizontal terminal" })
map("n", "<leader>tv", "<cmd> vsplit | redraw! | terminal <cr>", { desc = "Vertical terminal" })
map("n", "<leader>tn", "<cmd> tabedit | redraw! | terminal <cr>", { desc = "Terminal in New tab" })
map("n", "<leader>te", "<cmd> terminal <cr>", { desc = "Open terminal in current window" })

-- map("n", "<leader>up", vim.cmd.Ex, { desc = "Go back to parent directory" })
map("n", "<leader>-", "<cmd> Oil <CR>", { desc = "Open Explorer in current file" })
map("n", "<leader>_", "<cmd> Oil . <CR>", { desc = "Open Explorer in cwd" })

-- ALT+<- or -> でジャンプ (マウス操作経由)
map("n", "<A-Left>", "<C-o>", { desc = "Go back (C-O)" })
map("n", "<A-Right>", "<C-i>", { desc = "Go forward (C-I)" })
map("n", "<esc>b", "<C-o>", { desc = "Go back (C-O)" }) -- Alt+<->をワード移動に設定しているのでそれも上書き
map("n", "<esc>f", "<C-i>", { desc = "Go forward (C-I)" })

map("n", "<leader>?", ":execute 'vimgrep /'.@/.'/g %'<CR>:copen<CR>", { desc = "Open quickfix with last search" })

-- レジスタからマクロを張り付けた時にfやtや.の後ろに<80><fd>a という謎シーケンスが混入するのでこれを除去する
-- <fd>: <ý> 253, Hex 00fd, Oct 375, Digr y'
-- <80>: <<80>> 128, Hex 0080, Oct 200, Digr PA
-- https://github.com/neovim/neovim/issues/25865
map("x", "gM", [[:s/\v.%xfda//g<CR>]], { desc = "Format macro text" })
-- map("x", "gM", [[:s/\v([ft].).%xfda/\1/g<CR>]], { desc = "Format macro text" })

-- Resize window using <ctrl> arrow keys (taken from lazyvim)
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- auto insert semicolon (shift+Enter)
map("i", "<S-CR>", function()
	local line = vim.fn.getline(".")
	if not line:match(";$") then
		return vim.api.nvim_replace_termcodes("<C-o>A;", true, true, true)
	else
		return vim.api.nvim_replace_termcodes("<C-o>A", true, true, true)
	end
end, { expr = true, desc = "Insert semicolon at end of line" })

map("n", "<S-CR>", function()
	local line = vim.fn.getline(".")
	if not line:match(";$") then
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("A;<ESC>", true, false, true), "n", true)
	else
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("$", true, false, true), "n", true)
	end
end, { noremap = true, desc = "Insert semicolon at end of line" })

-- projects
map(
	"n",
	"<A-/>",
	"<cmd>silent !tmux neww zsh -ic 'open-recent-project; exec zsh' <CR>",
	{ desc = "Open project in new window" }
)
map(
	"n",
	"<A-?>",
	"<cmd>silent !tmux neww zsh -ic 'open-recent-project-session; exec zsh' <CR>",
	{ desc = "Open project in new session" }
)
map("n", "<leader>at", "<cmd> SetTermTab <CR>", { desc = "Set cwd to terminal tab name" })

----------------------------------------------------------------------------------------------
-----------------------------------  Plugin mapping ------------------------------------------
----------------------------------------------------------------------------------------------

--------------------------------- nvim-tree/nvim-tree.lua -------------------------------------
map("n", "<C-n>", function()
	require("nvim-tree.api").tree.toggle(false, true) -- do not focus
end, { desc = "Toggle nvimtree" })
map("n", "<leader>e", "<cmd> NvimTreeFocus <CR>", { desc = "Focus nvimtree" })

--------------------------------- nvim-telescope/telescope.nvim -------------------------------------

map("n", "<C-p>", "<cmd> Telescope find_files <CR>", { desc = "Find Project files" })
map("n", "<leader>ff", "<cmd> Telescope find_files <CR>", { desc = "Find files" })
map("n", "<leader>fa", "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>", { desc = "Find all" })
map("n", "<leader>fg", "<cmd> Telescope git_files <CR>", { desc = "Find git files" })
map("n", "<leader>fw", "<cmd> Telescope live_grep <CR>", { desc = "Live grep" })
map("n", "<leader>fh", "<cmd> Telescope help_tags <CR>", { desc = "Help page" })
map("n", "<leader>fo", "<cmd> Telescope oldfiles <CR>", { desc = "Find oldfiles" })
map("n", "<leader>f/", "<cmd> Telescope current_buffer_fuzzy_find <CR>", { desc = "Find in current buffer" })
map("n", "<leader><space>", function()
	require("telescope.builtin").buffers({ sort_mru = true })
end, { desc = "Find buffers" })
map("n", "<leader>#", "<cmd> Telescope grep_string <CR>", { desc = "Find all word under cursor" })
map("n", "<leader>*", "<cmd> Telescope grep_string word_match=-w <CR>", { desc = "Find word under cursor" })
map("x", "<leader>*", "<cmd> Telescope grep_string <CR>", { desc = "Find all word under cursor" })
map("n", "<leader>fc", "<cmd> Telescope commands <CR>", { desc = "Find commands" })
map("n", "<leader>fk", "<cmd> Telescope keymaps <CR>", { desc = "Find keymaps" })
map("n", "<leader>fs", "<cmd> Telescope lsp_document_symbols <CR>", { desc = "Find symbol" })
map("n", "<leader>fS", "<cmd> Telescope lsp_dynamic_workspace_symbols <CR>", { desc = "Find workspace Symbol" })
map("n", "<leader>fq", "<cmd> Telescope diagnostics <CR>", { desc = "Find diagnostics" })
map("n", "<leader>fr", "<cmd> Telescope resume <CR>", { desc = "Resume telescope" })

--------------------------------- folke/todo-comments.nvim -------------------------------------

map("n", "<leader>ft", "<cmd> TodoTelescope <CR>", { desc = "Find TODO" })
map("n", "<leader>T", "<cmd> TodoQuickFix <CR>", { desc = "TODO List" })

--------------------------------- akinsho/bufferline.nvim -------------------------------------

map("n", "<leader>n", "<cmd> enew <CR>", { desc = "New buffer" })
map("n", "<leader>x", "<cmd> bd <CR>", { desc = "Delete buffer" })
map("n", "X", "<cmd> bd <CR>", { desc = "Delete buffer" })
map("n", "<leader>bH", "<cmd> BufferLineCloseLeft <CR>", { desc = "Close left buffers" })
map("n", "<leader>bL", "<cmd> BufferLineCloseRight <CR>", { desc = "Close right buffers" })
map("n", "(", "<cmd> BufferLineCyclePrev <CR>", { desc = "Prev Buffer" })
map("n", ")", "<cmd> BufferLineCycleNext <CR>", { desc = "Next Buffer" })
map("n", "<leader>bb", "<cmd> BufferLinePick <CR>", { desc = "Pick Buffer" })
map("n", "<leader>bo", "<cmd> BufferLineCloseOthers <CR>", { desc = "Delete other buffers" })
map("n", "<leader>bp", "<cmd> BufferLineTogglePin <CR>", { desc = "Toggle buffer pin" })
map("n", "<leader>bP", "<cmd> BufferLineGroupClose ungrouped<CR>", { desc = "Delete non-pinned buffers" })
map("n", "<leader>bh", "<cmd> BufferLineMovePrev <CR>", { desc = "Move buffer left" })
map("n", "<leader>bl", "<cmd> BufferLineMoveNext <CR>", { desc = "Move buffer right" })

map("n", "<leader>j", function()
	require("bufferline").go_to(1, true)
end, { desc = "Buffer 1" })
map("n", "<leader>k", function()
	require("bufferline").go_to(2, true)
end, { desc = "Buffer 2" })
map("n", "<leader>l", function()
	require("bufferline").go_to(3, true)
end, { desc = "Buffer 3" })
map("n", "<leader>;", function()
	require("bufferline").go_to(4, true)
end, { desc = "Buffer 4" })
map("n", "<leader>'", function()
	require("bufferline").go_to(5, true)
end, { desc = "Buffer 5" })

--------------------------------- numToStr/Comment.nvim -------------------------------------

map("n", "<leader>/", function()
	require("Comment.api").toggle.linewise.current()
end, { desc = "Toggle comment" })
map(
	"x",
	"<leader>/",
	"<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
	{ desc = "Toggle comment" }
)

--------------------------------- stevearc/conform.nvim -------------------------------------

-- format
map("n", "<leader>fm", function()
	require("conform").format({
		lsp_fallback = true, -- LSPでもformat
	})
end, { desc = "Format code" })

--------------------------------- folke/which-key.nvim -------------------------------------

map("n", "<leader>wk", function()
	vim.cmd("WhichKey")
end, { desc = "Which-key all keymaps" })

--------------------------------- nvim-treesitter -------------------------------------

-- nvim-treesitter/nvim-treesitter-context
map("n", "[x", function()
	require("treesitter-context").go_to_context()
end, { desc = "Jump to treesitter context", silent = true })

--------------------------------- DAP -------------------------------------

-- dap
map("n", "<leader>db", "<cmd> DapToggleBreakpoint <CR>", { desc = "Add breakpoint at line" })
map("n", "<leader>du", function()
	local widgets = require("dap.ui.widgets")
	local sidebar = widgets.sidebar(widgets.scopes)
	sidebar.open()
end, { desc = "Open debugging UI sidebar" })

map("n", "<leader>dr", "<cmd> DapContinue <CR>", { desc = "Start or continue the debugging" })
map("n", "<F5>", "<cmd> DapContinue <CR>", { desc = "Start or continue the debugging" })
map("n", "<F10>", "<cmd> DapStepOver <CR>", { desc = "debug: Step Over" })
map("n", "<F11>", "<cmd> DapStepInto <CR>", { desc = "debug: Step Into" })
map("n", "<F12>", "<cmd> DapStepOver <CR>", { desc = "debug: Step Over" })

-- dap Go
map("n", "<leader>dgt", function()
	require("dap-go").debug_test()
end, { desc = "Debug go test" })

map("n", "<leader>dgl", function()
	require("dap-go").debug_last()
end, { desc = "Debug last go test" })

--------------------------------- git stuffs -------------------------------------

-- lewis6991/gitsigns.nvim
map("n", "<leader>gr", "<cmd> Gitsigns reset_hunk <CR>", { desc = "Reset hunk" })
map("n", "<leader>gp", "<cmd> Gitsigns preview_hunk <CR>", { desc = "Preview hunk" })
map("n", "<leader>gl", "<cmd> Gitsigns blame_line <CR>", { desc = "Blame line" })

-- tpope/vim-fugitive
map("n", "<leader>go", "<cmd> GBrowse <CR>", { desc = "Open in GitHub" })
map("x", "<leader>go", ":'<,'>GBrowse <CR>", { desc = "Open lines in GitHub" })
map("n", "<leader>gd", "<cmd> vertical Gdiffsplit! <CR>", { desc = "Git diff split (three way)" })
map("n", "<leader>gb", "<cmd> G blame <CR>", { desc = "Blame fugitive" })
map("n", "<leader>gh", "<cmd> leftabove vs | 0Gclog <CR>", { desc = "Git history of current file" })

-- rbong/vim-flog
map("n", "<leader>gf", "<cmd> Flog <CR>", { desc = "Open flog" })

--------------------------------- ui stuffs -------------------------------------

map("n", "<leader>un", "<cmd> bufdo set relativenumber! <CR>", { desc = "Toggle relative line number" })
map("n", "<leader>uw", "<cmd> set wrap! <CR>", { desc = "Toggle wrap" })
map("n", "<leader>uW", "<cmd> WrapCursorToggle <CR>", { desc = "Toggle j,k <-> gj,gk" })
map("n", "<leader>uq", "<cmd> QFToggle <CR>", { desc = "Toggle Quickfix window" })
-- Toggle diagnostic (linter)
map("n", "<leader>ud", "<cmd> DiagnosticsToggle <CR>", { desc = "Toggle diagnostics" })

-- mbbill/undotree
map("n", "<leader>ut", "<cmd> UndotreeToggle <CR>", { desc = "Toggle Undotree" })

-- nvim-pack/nvim-spectre
map("n", "<leader>us", function()
	require("spectre").toggle()
end, { desc = "Toggle Spectre" })

-- tpope/vim-fugitive
map("n", "<leader>ug", "<cmd> vertical G <CR>", { desc = "Open Git fugitive" })

-- stevearc/aerial.nvim
map("n", "<leader>uo", "<cmd> AerialToggle <CR>", { desc = "Toggle Aerial (Symbol Outline)" })

-- lazy
map("n", "<leader>ul", "<cmd> Lazy <CR>", { desc = "Open Lazy" })

-- lukas-reineke/indent-blankline.nvim
local indent_blankline_loaded = true
map("n", "<leader>uI", function()
	if not indent_blankline_loaded then
		vim.cmd("IBLEnable")
		indent_blankline_loaded = true
	else
		vim.cmd("IBLToggle")
	end
end, { desc = "Toggle indent-blankline" })

-- echasnovski/mini.indentscope
map("n", "<leader>ui", function()
	vim.g.miniindentscope_disable = not vim.g.miniindentscope_disable
	if vim.g.miniindentscope_disable then
		MiniIndentscope.undraw()
	else
		MiniIndentscope.draw()
	end
end, { desc = "Toggle indentscope" })

-- RRethy/vim-illuminate
map("n", "<leader>uh", "<cmd> IlluminateToggle <CR>", { desc = "Toggle highlight (vim-illuminate)" })

-- nvim-treesitter/nvim-treesitter-context
map("n", "<leader>uc", "<cmd> TSContextToggle <CR>", { desc = "Toggle treesitter context" })

-- copilot
map("n", "<leader>uC", "<cmd> Copilot toggle <CR>", { desc = "Toggle Copilot" })
