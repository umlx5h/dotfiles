---@type ChadrcConfig 
local M = {}
-- netrwを有効化する
M.lazy_nvim = {
  performance = {
    rtp = {
      disabled_plugins = vim.tbl_filter(function(name)
        return string.sub(name, 1, 5) ~= "netrw"
      end, require("plugins.configs.lazy_nvim").performance.rtp.disabled_plugins),
    },
  },
}
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
