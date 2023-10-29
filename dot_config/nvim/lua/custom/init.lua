-------------------------------------- options ------------------------------------------
local opt = vim.opt
opt.clipboard = "" -- disable yank to clipboard by default
opt.pumheight = 12 -- set completion max rows
opt.relativenumber = true

-------------------------------------- filetypes ------------------------------------------

vim.filetype.add {
  pattern = {
    ["docker.compose.*%.ya?ml"] = "yaml.docker-compose",
  },
}

-------------------------------------- snippets ------------------------------------------

-- TODO: vscodeと共有したい
vim.g.vscode_snippets_path = "./lua/custom/my-snippets"

-------------------------------------- custom functions ------------------------------------------

local toggle_enabled = true
-- diagnostics をトグルするカスタム関数
function toggle_diagnostics()
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
function is_local()
  local uname = vim.loop.os_uname()
  local isLocal = uname.sysname == "Darwin" or uname.sysname == "Linux" and uname.release:find "microsoft"
  return isLocal
end

-------------------------------------- remaps ------------------------------------------

vim.keymap.set("n", "<leader>up", vim.cmd.Ex, { desc = "Go back to parent directory" })

vim.keymap.set("n", "<A-a>", "ggVG", { desc = "Select all" })

-- system clipboard (リモートはOSC52版プラグインで上書きしている)
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "yank system clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>Y", [["+y$]], { desc = "Yank system clipboard" })
vim.keymap.set("v", "<leader>d", [["+d]], { desc = "delete with clipboard" }) -- normalに割り当てるとdebugと被るのでやめる
vim.keymap.set("n", "<leader>dd", [["+dd]], { desc = "Delete line with clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>D", [["+D]], { desc = "Delete with clipboard" })

-- ALT+<- or -> でジャンプ (マウス操作経由)
vim.keymap.set("n", "<A-Left>", "<C-o>", { desc = "Go back (C-O)" })
vim.keymap.set("n", "<A-Right>", "<C-i>", { desc = "Go forward (C-I)" })
vim.keymap.set("n", "<esc>b", "<C-o>", { desc = "Go back (C-O)" }) -- Alt+<->をワード移動に設定しているのでそれも上書き
vim.keymap.set("n", "<esc>f", "<C-i>", { desc = "Go forward (C-I)" })

-- "0pを打ちやすく
vim.keymap.set({ "n", "v" }, "<leader>p", [["0p]], { desc = "paste from yank register" })
vim.keymap.set({ "n", "v" }, "<leader>P", [["0P]], { desc = "Paste from yank register" })

-- Ctrl+j,kでまとめて上下に移動
vim.keymap.set("v", "<C-k>", ":m '<-2<CR>gv=gv", { desc = "chunk moving up" })
vim.keymap.set("v", "<C-j>", ":m '>+1<CR>gv=gv", { desc = "chunk moving down" })

-- Relative numberで行番号を見やすくする
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll window downwards with centering" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll window upwords with centering" })

-- Alternative to VSCode Ctrl+D
vim.keymap.set("x", "gs", [["sy:let @/=@s<CR>cgn]], { desc = "Replace word under cursor" })
vim.keymap.set("n", "gs", [[:let @/='\<'.expand('<cword>').'\>'<CR>cgn]], { desc = "Replace word under cursor" })
vim.keymap.set("x", "g/", [[y:%s/\V<c-r>"//g<left><left>]], { desc = "Replace word under cursor globally" })

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

-- 完全一致検索
vim.keymap.set(
  "n",
  "<leader>s",
  -- [[<cmd>let search = input('Search literally: ') | redraw | execute '/\V' . escape(search, '/\') <CR>]],
  [[<cmd>let search = input('Search literally: ') | redraw | execute '/\V' . substitute(escape(search, '/\'), '\\n', 'n', 'g') <CR>]], -- 複数行の検索に対応 \nだけ改行文字として認識させる
  { desc = "Literal Search" }
)

-- コマンドラインモードでCTRL-% (CTRL-])で %:h に展開してくれる、現在開いているファイルを基準にパスを作成可能
vim.keymap.set(
  "c",
  "<C-]>",
  "getcmdtype() == ':' ? expand('%:h').'/' : '%%'",
  { silent = false, expr = true, desc = "Expand current file dir" }
)

-- -- F13-F20 custom map
-- local mode = { 'n', 'v', 'x', 's', 'o', 'i', 'l', 'c', 't' }
-- local opts = { silent = true, nowait = true, noremap = false, remap = true }

-- -- https://unix.stackexchange.com/questions/154501/can-i-get-my-iterm-key-combos-working-in-tmux
-- -- https://aperiodic.net/phil/archives/Geekery/term-function-keys/

-- if vim.fn.expand('$TERM'):match("^screen|tmux") then
--   vim.keymap.set(mode, "<esc>[1;2P", '<F13>', opts)
-- elseif vim.fn.expand('$TERM'):match("^xterm") then
--   vim.keymap.set(mode, '<esc>O2P', '<F13>', opts)
-- end

-- if vim.fn.expand('$TERM'):match("^screen") then
--   vim.keymap.set(mode, "<S-F1>", '<F13>', opts) -- Shift
-- end

-- コマンドモードでShift+Enter押したときにEnterを押すようにする
-- vim.keymap.set({ "c", "v", "s", "t" }, "<F13>", "<CR>")

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
