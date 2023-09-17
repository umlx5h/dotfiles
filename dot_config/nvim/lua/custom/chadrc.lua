-------------------------------------- options ------------------------------------------
local opt = vim.opt
opt.clipboard = ""

-------------------------------------- remaps ------------------------------------------
-- TODO: where should I put these?
-- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Go back to [pr]evious directory"})
vim.keymap.set('n', '<leader>l', '<C-^>', { desc = "Toggle [l]ast buffer"})
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]], { desc = "[y]ank system clipboard"})
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "[Y]ank system clipboard"})

-- ALT+<- or -> でジャンプ
vim.keymap.set({"n", "v", "i"}, "<A-Left>", "<C-o>", { desc = "Go back (C-O)"})
vim.keymap.set({"n", "v", "i"}, "<A-Right>", "<C-i>", { desc = "Go forward (C-I)"})

vim.keymap.set("x", "<leader>pp", [["_dP]], { desc = "Paste without yank"})
vim.keymap.set("n", "<leader>p", [["0p]], { desc = "Paste from yank register"})

-- JとKでまとめて上下に移動
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")

-- window split remap (tmux like)
vim.keymap.set('n', '<C-w>/', '<C-w>v', { desc = "Split window vertically", noremap = true})
vim.keymap.set('n', '<C-w>-', '<C-w>s', { desc = "Split window horizontally", noremap = true})
vim.keymap.set('n', '<C-w>x', '<C-w>q', { desc = "Quit a window", noremap = true })
vim.keymap.set('n', '<C-w>s', '<C-w>x', { desc = "Swap window", noremap = true })
-- could not delete
-- vim.keymap.set('n', '<C-w>v', '<Nop>')
-- vim.keymap.set('n', '<C-w>s', '<Nop>')

-------------------------------------- chad sane ------------------------------------------

---@type ChadrcConfig 
local M = {}
M.ui = {
  -- https://github.com/NvChad/base46/blob/v2.0/lua/base46/themes/catppuccin.lua
  theme = 'catppuccin',
  changed_themes = {
    catppuccin = {
       base_30 = {
        grey_fg = "#817e99", -- comment out color (from: #4e4d5d)
        -- grey_fg2 = "#555464",
        -- light_grey = "#605f6f"
        line = "#504e66", -- for lines like vertsplit (from: #383747)
       },
    },
  },
}
M.plugins = "custom.plugins"
M.mappings = require "custom.mappings"

return M
