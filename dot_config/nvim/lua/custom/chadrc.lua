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


-------------------------------------- chad sane ------------------------------------------

---@type ChadrcConfig 
local M = {}
M.ui = {
  theme = 'catppuccin',
  changed_themes = {
    catppuccin = {
       base_30 = {
        grey_fg = "#817e99", -- comment out color
        -- grey_fg2 = "#555464",
        -- light_grey = "#605f6f"
       },
    },
  },
}
M.plugins = "custom.plugins"
M.mappings = require "custom.mappings"

return M
