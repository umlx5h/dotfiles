---@type ChadrcConfig
local M = {}
M.lazy_nvim = {
  performance = {
    rtp = {
      disabled_plugins = vim.tbl_filter(function(name)
        return not (
          string.sub(name, 1, 5) == "netrw" -- netrwを有効化する
          or name == "matchit" -- matchitを有効化 HTMLなどで%で対応するタグに移動可能になる
        )
      end, require("plugins.configs.lazy_nvim").performance.rtp.disabled_plugins),
    },
  },
}

M.ui = {
  hl_override = {
    -- ハイライトを検索する方法
    -- :Telescope highlightsを使う
    -- or
    -- :highlightsから調べる
    --
    -- :redir @a -> :highlight -> :redir END -> :bnew -> "ap
    --
    -- 色の指定方法: https://nvchad.com/docs/config/theming
    IndentBlanklineSpaceChar = { link = "Comment" }, -- set listのタブ文字を明るく
    SpecialKey = { link = "Comment" }, -- ^Mみたいなやつ
    NonText = { link = "Comment" }, -- set listのタブ文字を明るく
    Visual = { bg = "#30447f" }, -- テキスト選択の背景を少し青くして明るく
  },
  hl_add = {
    -- linkするハイライトはtelescope highlightsが参考になる
    AerialLine = { fg = "cyan" }, -- フォーカスのあたっているシンボルの色
    TreesitterContext = { bg = "one_bg2" },
    IlluminatedWordText = { bg = "one_bg2" },
    IlluminatedWordRead = { bg = "one_bg2" },
    IlluminatedWordWrite = { bg = "one_bg2" },
    CurSearch = { link = "IncSearch" },
    manItalic = { italic = true, fg = "green" },
  },
  theme_toggle = { "catppuccin" },
  -- https://github.com/NvChad/base46/blob/v2.0/lua/base46/themes/catppuccin.lua
  theme = "catppuccin",
  changed_themes = {
    ["catppuccin"] = {
      base_30 = {
        grey_fg = "#8d8ba8", -- comment out color (from: #4e4d5d)
        grey = "#5e5c72", -- line number (from: #474656)
        white = "#e3eaf9", -- focus buffer color, etc (from: #D9E0EE)
        light_grey = "#858399", -- buffer tab backgroud (from: #605f6f)
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
          local devicons_present, devicons = pcall(require, "nvim-web-devicons")

          if devicons_present then
            local ft_icon = devicons.get_icon(filename)
            icon = (ft_icon ~= nil and " " .. ft_icon) or ""
          end

          -- filenameにカレントディレクトリからのパスを付加する (差分)
          -- filename = fn.fnamemodify(fn.expand "%:h", ":p:~:.") .. filename
          filename = fn.expand "%:~:."

          -- ファイルが変更されたら [+] をつける (差分)
          if vim.api.nvim_get_option_value("modified", { scope = "local" }) then
            filename = filename .. " [+]"
          end

          filename = " " .. filename .. " "
        end

        return "%#St_file_info#" .. icon .. filename .. "%#St_file_sep#" .. sep_r
      end)()
      -- Disable .git
      modules[3] = (function()
        return ""
      end)()
    end,
  },

  tabufline = {
    overriden_modules = function(modules)
      -- override M.buttons
      -- https://github.com/NvChad/ui/blob/3c41d007bdcc6dbfe87b66dffa55d9a57fcd0559/lua/nvchad/tabufline/modules.lua#L195
      modules[4] = (function()
        -- disable theme switch toggle
        local CloseAllBufsBtn = "%@TbCloseAllBufs@%#TbLineCloseAllBufsBtn#" .. " 󰅖 " .. "%X"
        return CloseAllBufsBtn
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
