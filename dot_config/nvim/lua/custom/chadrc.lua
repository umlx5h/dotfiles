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
  theme_toggle = { "catppuccin" },
  -- https://github.com/NvChad/base46/blob/v2.0/lua/base46/themes/catppuccin.lua
  theme = "catppuccin",
  changed_themes = {
    ["catppuccin"] = {
      base_30 = {
        -- grey_fg = "#8d8ba8", -- comment out color (from: #4e4d5d)
        grey_fg = "#8d8ba8", -- comment out color (from: #4e4d5d)
        -- grey_fg2 = "#555464",
        -- light_grey = "#605f6f"
        line = "#504e66", -- for lines like vertsplit (from: #383747)
      },
    },
  },

  statusline = {
    overriden_modules = function(modules)
      -- NvChad/uiで定義されている M.fileInfo を修正して、ファイル名をCWDからのパス名にする
      -- オーバーライド先コード: https://github.com/NvChad/ui/blob/v2.0/lua/nvchad/statusline/default.lua#L71
      -- 参考: https://nvchad.com/docs/config/nvchad_ui#override_statusline_modules
      modules[2] = (function()
        local fn = vim.fn
        local sep_r = " "

        local icon = " 󰈚 "
        local filename = (fn.expand "%" == "" and "Empty ") or fn.expand "%:t"
      
        if filename ~= "Empty " then
          -- filenameにカレントディレクトリからのパスを付加する (差分)
          filename = fn.fnamemodify(fn.expand('%:h'), ':p:~:.') .. filename
          local devicons_present, devicons = pcall(require, "nvim-web-devicons")
      
          if devicons_present then
            local ft_icon = devicons.get_icon(filename)
            icon = (ft_icon ~= nil and " " .. ft_icon) or ""
          end
      
          filename = " " .. filename .. " "
        end
      
        return "%#St_file_info#" .. icon .. filename .. "%#St_file_sep#" .. sep_r
      end)()
    end,
  },

  lsp = {
    signature = {
      disabled = true, -- 関数の引数入力時の補完を無効化、カーソルと被るため cmp-nvim-lsp-signature-help に変更
    },
  },
}
M.plugins = "custom.plugins"
M.mappings = require "custom.mappings"

return M
