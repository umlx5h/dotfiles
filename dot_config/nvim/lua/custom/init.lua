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

-------------------------------------- remaps ------------------------------------------

vim.keymap.set("n", "<leader>up", vim.cmd.Ex, { desc = "Go back to parent directory" })
-- きもいがtmuxと合わせる
vim.keymap.set("n", "<leader>i", "<C-^>", { desc = "Toggle last buffer" })
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "yank system clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank system clipboard" })

-- TODO: これなんだっけ？
-- vim.keymap.set({"n", "v"}, "<leader>dd", [["_d]])
vim.keymap.set("v", "<leader>d", [["+d]], { desc = "Delete with clipboard" })

-- ALT+<- or -> でジャンプ
vim.keymap.set({ "n", "v", "i" }, "<A-Left>", "<C-o>", { desc = "Go back (C-O)" })
vim.keymap.set({ "n", "v", "i" }, "<A-Right>", "<C-i>", { desc = "Go forward (C-I)" })
vim.keymap.set({ "n", "v", "i" }, "<esc>b", "<C-o>", { desc = "Go back (C-O)" }) -- Alt+<->をワード移動に設定しているのでそれも上書き
vim.keymap.set({ "n", "v", "i" }, "<esc>f", "<C-i>", { desc = "Go forward (C-I)" })

-- https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text#Alternative_mapping_for_paste
-- vim.keymap.set("x", "p", [[p:let @"=@0<CR>]], { desc = "Paste without yank", silent = true })
-- vim.keymap.set("x", "p", [[p:let @+=@0<CR>:let @"=@0<CR>]], { desc = "Paste without yank", silent = true})
vim.keymap.set("n", "<leader>p", [["0p]], { desc = "Paste from yank register" })

-- JとKでまとめて上下に移動
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "chunk moving up" })
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "chunk moving down" })

-- window split remap (tmux like)
vim.keymap.set("n", "<C-w>/", "<C-w>v", { desc = "Split window vertically", noremap = true })
vim.keymap.set("n", "<C-w>-", "<C-w>s", { desc = "Split window horizontally", noremap = true })
vim.keymap.set("n", "<C-w>x", "<C-w>q", { desc = "Quit a window", noremap = true })
vim.keymap.set("n", "<C-w>s", "<C-w>x", { desc = "Swap window", noremap = true })
-- could not delete
-- vim.keymap.set('n', '<C-w>v', '<Nop>')
-- vim.keymap.set('n', '<C-w>s', '<Nop>')

-- Alternative to VSCode Ctrl+D
vim.keymap.set("x", "sr", [["sy:let @/=@s<CR>cgn]], { desc = "Replace word under cursor" })
vim.keymap.set("n", "sr", [[:let @/='\<'.expand('<cword>').'\>'<CR>cgn]], { desc = "Replace word under cursor" })
vim.keymap.set("x", "sg", [[y:%s/\<<c-r>"\>//g<left><left>]], { desc = "Replace word under cursor globally" })

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
vim.keymap.set("i", "<C-k>", function()
  return "<C-o>D"
end, { desc = "Emacs Cut line", silent = true, expr = true })

-- vim.keymap.set('i', '<C-k>', '<C-r>=<SID>kill()<CR>')

-- vim.keymap.set({"n", "t", "i"}, "<C-u>", "<Nop>", { desc = "Go forward (C-I)"})

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
vim.keymap.set("c", "<F13>", "<CR>")

-- auto insert semicolon (shift+Enter)
vim.keymap.set("i", "<F13>", function()
  local line = vim.fn.getline "."
  if not line:match ";$" then
    return vim.api.nvim_replace_termcodes("<C-o>A;", true, true, true)
  else
    return vim.api.nvim_replace_termcodes("<C-o>A", true, true, true)
  end
end, { noremap = true, expr = true })
vim.keymap.set("n", "<F13>", function()
  local line = vim.fn.getline "."
  if not line:match ";$" then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("A;<ESC>", true, false, true), "n", true)
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("$", true, false, true), "n", true)
  end
end, { noremap = true })
