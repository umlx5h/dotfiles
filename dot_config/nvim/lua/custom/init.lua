-------------------------------------- options ------------------------------------------

local opt = vim.opt
opt.clipboard = "" -- disable yank to clipboard by default
opt.pumheight = 12 -- set completion max rows
opt.relativenumber = true
opt.grepprg = "rg --vimgrep" -- make :grep using ripgrep
opt.grepformat = "%f:%l:%c:%m"
opt.scrolloff = 3
opt.whichwrap = "b,s,<,>,[,]" -- h, lはデフォルト挙動に
opt.spelllang:append "cjk" -- 日本語をスペルチェックから除外

-- Indenting
-- タブにしたい場合           :set ts=4 noet
-- スペース幅を調整したい場合 :set ts=N (sw=N (filetype pluginで0以外に設定されていたらswも指定)
-- opt.autoindent = true -- default
opt.smartindent = true
-- opt.smarttab = true -- default
opt.tabstop = 2
opt.softtabstop = 0 -- off
opt.shiftwidth = 0 -- same as tabstop
opt.expandtab = true

-- treesitter fold
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- treesitterで自動的に折り畳みを作成
opt.foldtext = "v:lua.vim.treesitter.foldtext()" -- 折り畳みを見やすくする
opt.foldlevelstart = 99 -- デフォルトで全て開く
-- TODO: 最初に全て開く時にzR か foldopenを使わないとzmが動かない問題がある
-- vim.cmd [[autocmd BufWinEnter * silent! :%foldopen!]]
-- vim.api.nvim_create_autocmd({ "BufReadPost", "FileReadPost" }, { command = "normal zR" })

-- diffモードではtreesitterのfoldtextを使わない
vim.api.nvim_create_autocmd({ "OptionSet" }, {
  desc = "Reset 'foldtext' to default when diff mode",
  pattern = "diff",
  callback = function()
    if vim.v.option_new then
      vim.opt_local.foldtext = vim.api.nvim_get_option_info2("foldtext", {}).default
    else
      vim.opt_local.foldtext = "v:lua.vim.treesitter.foldtext()"
    end
  end,
})

vim.g.man_hardwrap = 0 -- manpageでコピペしやすく

-- netrw
vim.g.netrw_preview = 1 -- 縦分割
vim.g.netrw_alto = 0

-------------------------------------- filetypes ------------------------------------------

vim.filetype.add {
  pattern = {
    ["docker.compose.*%.ya?ml"] = "yaml.docker-compose",
  },
}

-------------------------------------- snippets ------------------------------------------

-- TODO: vscodeと共有したい
vim.g.vscode_snippets_path = "./lua/custom/my-snippets"

-------------------------------------- nvim stuff ------------------------------------------

-- highlight yanked region, see `:h lua-highlight`
local yank_group = vim.api.nvim_create_augroup("highlight_yank", { clear = true })
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  desc = "highlight after yank",
  group = yank_group,
  callback = function()
    vim.highlight.on_yank { higroup = "@label", timeout = 230 }
  end,
})

---------------------------------------- custom functions ----------------------------------------

local toggle_enabled = true
-- diagnostics をトグルするカスタム関数
function Toggle_diagnostics()
  toggle_enabled = not toggle_enabled
  if toggle_enabled then
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
end

-- MacかWSL2の場合はローカルと判定、それ以外はリモート扱い
function Is_local()
  local uname = vim.loop.os_uname()
  local isLocal = uname.sysname == "Darwin" or uname.sysname == "Linux" and uname.release:find "microsoft"
  return isLocal
end

---------------------------------------- user commands ----------------------------------------

vim.api.nvim_create_user_command("DiffClip", function()
  vim.cmd [[
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
  ]]
end, { desc = "Compare Active File with Clipboard" })

vim.api.nvim_create_user_command("DiffOrig", function()
  vim.cmd [[
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
  ]]
end, { desc = "Compare Active File with Saved" })

-------------------------------------- local options ------------------------------------------

if not Is_local() then
  -- ローカル以外はOSC52でクリップボードを扱う
  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy "+",
      ["*"] = require("vim.ui.clipboard.osc52").copy "*",
    },
    paste = {
      ["+"] = require("vim.ui.clipboard.osc52").paste "+",
      ["*"] = require("vim.ui.clipboard.osc52").paste "*",
    },
  }
end

-------------------------------------- remaps ------------------------------------------

vim.keymap.set("n", "<leader>up", vim.cmd.Ex, { desc = "Go back to parent directory" })

-- 全選択
vim.keymap.set("n", "<A-a>", "ggVG", { desc = "Select all" })

-- system clipboard (リモートはOSC52版プラグインで上書きしている)
vim.keymap.set({ "n", "x" }, "<leader>y", [["+y]], { desc = "yank system clipboard" })
vim.keymap.set("x", "<leader>c", [["+y]], { desc = "yank system clipboard" }) -- 片手でコピペしやすく
vim.keymap.set({ "n", "x" }, "<leader>Y", [["+y$]], { desc = "Yank system clipboard" })
vim.keymap.set("x", "<leader>d", [["+d]], { desc = "delete with clipboard" }) -- normalに割り当てるとdebugと被るのでやめる
vim.keymap.set("n", "<leader>dd", [["+dd]], { desc = "Delete line with clipboard" })
vim.keymap.set({ "n", "x" }, "<leader>D", [["+D]], { desc = "Delete with clipboard" })

-- ALT+<- or -> でジャンプ (マウス操作経由)
vim.keymap.set("n", "<A-Left>", "<C-o>", { desc = "Go back (C-O)" })
vim.keymap.set("n", "<A-Right>", "<C-i>", { desc = "Go forward (C-I)" })
vim.keymap.set("n", "<esc>b", "<C-o>", { desc = "Go back (C-O)" }) -- Alt+<->をワード移動に設定しているのでそれも上書き
vim.keymap.set("n", "<esc>f", "<C-i>", { desc = "Go forward (C-I)" })

-- "0pを打ちやすく
vim.keymap.set({ "n", "x" }, "<leader>p", [["0p]], { desc = "paste from yank register" })
vim.keymap.set({ "n", "x" }, "<leader>P", [["0P]], { desc = "Paste from yank register" })

-- Ctrl+j,kでまとめて上下に移動
vim.keymap.set("x", "<C-k>", ":m '<-2<CR>gv=gv", { desc = "chunk moving up" })
vim.keymap.set("x", "<C-j>", ":m '>+1<CR>gv=gv", { desc = "chunk moving down" })

-- Relative numberで行番号を見やすくする
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll window downwards with centering" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll window upwords with centering" })

-- Alternative to VSCode Ctrl+D
vim.keymap.set(
  "x",
  "gs",
  [["sy:let @/ = '\V' . substitute(escape(@s, '/\'), '\n', '\\n', 'g')<CR>:set hls<CR>cgn]],
  { desc = "Replace word under cursor" }
)
vim.keymap.set(
  "n",
  "gs",
  [[:let @/='\<'.expand('<cword>').'\>'<CR>:set hls<CR>cgn]],
  { desc = "Replace word under cursor" }
)
vim.keymap.set("x", "gS", [[y:%s/\V<c-r>"//g<left><left>]], { desc = "Replace word under cursor globally" })

vim.keymap.set(
  "n",
  "<leader>?",
  ":execute 'vimgrep /'.@/.'/g %'<CR>:copen<CR>",
  { desc = "Open quickfix with last search" }
)

-- レジスタからマクロを張り付けた時にfやtや.の後ろに<80><fd>a という謎シーケンスが混入するのでこれを除去する
-- <fd>: <ý> 253, Hex 00fd, Oct 375, Digr y'
-- <80>: <<80>> 128, Hex 0080, Oct 200, Digr PA
-- https://github.com/neovim/neovim/issues/25865
vim.keymap.set("x", "gM", [[:s/\v.%xfda//g<CR>]], { desc = "Format macro text" })
-- vim.keymap.set("x", "gM", [[:s/\v([ft].).%xfda/\1/g<CR>]], { desc = "Format macro text " })

-- Resize window using <ctrl> arrow keys (copy from lazyvim)
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- emacs keybiding in insert mode
vim.keymap.set("i", "<C-p>", "<Up>", { desc = "Emacs Up" })
vim.keymap.set("i", "<C-n>", "<Down>", { desc = "Emacs Down" })
vim.keymap.set("i", "<C-b>", "<Left>", { desc = "Emacs Left" })
vim.keymap.set("i", "<C-f>", "<Right>", { desc = "Emacs Right" })
vim.keymap.set("i", "<C-a>", "<Home>", { desc = "Emacs Home" })
vim.keymap.set("i", "<C-e>", "<End>", { desc = "Emacs End" })
vim.keymap.set("i", "<C-d>", "<Delete>", { desc = "Emacs Delete" })
vim.keymap.set("i", "<C-h>", "<BS>", { desc = "Emacs Backspace" })
-- disable for conflict (enter digraph)
-- vim.keymap.set("i", "<C-k>", function()
--   return "<C-o>D"
-- end, { desc = "Emacs Cut line", silent = true, expr = true })

-- コマンドモードでCTRL-P,Nの挙動を矢印と入れ替える
vim.keymap.set("c", "<C-p>", "<Up>")
vim.keymap.set("c", "<C-n>", "<Down>")
vim.keymap.set("c", "<Up>", "<C-p>")
vim.keymap.set("c", "<Down>", "<C-n>")

vim.keymap.set("x", "&", ":&&<CR>", { desc = "Repeat last substitute" })

-- 完全一致検索
vim.keymap.set(
  "n",
  "<leader>s",
  -- [[<cmd>let search = input('Search literally: ') | redraw | execute '/\V' . escape(search, '/\') <CR>]],
  [[<cmd>let search = input('Search literally: ') | redraw | execute '/\V' . substitute(escape(search, '/\'), '\\n', 'n', 'g') <CR>]], -- 複数行の検索に対応 \nだけ改行文字として認識させる
  { desc = "Literal Search" }
)

-- コマンドラインモードでCTRL-% (CTRL-])で %:h に展開してくれる、現在開いているファイルを基準にパスを作成可能
-- :h filename-modifiers
vim.keymap.set(
  "c",
  "<C-]>",
  "getcmdtype() == ':' ? expand('%:~:.:h').'/' : '%%'",
  { silent = false, expr = true, desc = "Expand current file dir" }
)

-- auto insert semicolon (shift+Enter)
vim.keymap.set("i", "<S-CR>", function()
  local line = vim.fn.getline "."
  if not line:match ";$" then
    return vim.api.nvim_replace_termcodes("<C-o>A;", true, true, true)
  else
    return vim.api.nvim_replace_termcodes("<C-o>A", true, true, true)
  end
end, { expr = true, desc = "Insert semicolon at end of line" })

vim.keymap.set("n", "<S-CR>", function()
  local line = vim.fn.getline "."
  if not line:match ";$" then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("A;<ESC>", true, false, true), "n", true)
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("$", true, false, true), "n", true)
  end
end, { noremap = true, desc = "Insert semicolon at end of line" })
