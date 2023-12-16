-- ハイライトを検索する方法
-- :Telescope highlightsを使う
-- or
-- :highlightsから調べる
--
-- :redir > highlight.txt -> :highlight -> :redir END -> :e highlight.txt

local Shade = require("nightfox.lib.shade")

-- https://github.com/sharkdp/pastel
-- lighten color by 20%
-- s/\v#\zs\x{6}/\=system('pastel color ' .. submatch(0)  .. ' | pastel lighten 0.2 | pastel format hex | cut -c 2-7 | tr -d "\n"')
-- darken color by 20%
-- s/\v#\zs\x{6}/\=system('pastel color ' .. submatch(0)  .. ' | pastel darken 0.2 | pastel format hex | cut -c 2-7 | tr -d "\n"')
-- saturate (brighter) color by 20%
-- s/\v#\zs\x{6}/\=system('pastel color ' .. submatch(0)  .. ' | pastel saturate 0.2 | pastel format hex | cut -c 2-7 | tr -d "\n"')

-- ~/.local/share/nvim/lazy/nightfox.nvim/lua/nightfox/palette/nightfox.lua
-- :lua print(vim.inspect(require("nightfox.palette").load("nightfox")))
-- local orig_nightfox_palette = {
--   nightfox = {
--
--     black = Shade.new("#393b44", 0.15, -0.15),
--     red = Shade.new("#c94f6d", 0.15, -0.15),
--     green = Shade.new("#81b29a", 0.10, -0.15),
--     yellow = Shade.new("#dbc074", 0.15, -0.15),
--     blue = Shade.new("#719cd6", 0.15, -0.15),
--     magenta = Shade.new("#9d79d6", 0.30, -0.15),
--     cyan = Shade.new("#63cdcf", 0.15, -0.15),
--     white = Shade.new("#dfdfe0", 0.15, -0.15),
--     orange = Shade.new("#f4a261", 0.15, -0.15),
--     pink = Shade.new("#d67ad2", 0.15, -0.15),
--
--     comment = "#738091",
--
--     bg0 = "#131a24", -- Dark bg (status line and float)
--     bg1 = "#192330", -- Default bg
--     bg2 = "#212e3f", -- Lighter bg (colorcolm folds)
--     bg3 = "#29394f", -- Lighter bg (cursor line)
--     bg4 = "#39506d", -- Conceal, border fg
--
--     fg0 = "#d6d6d7", -- Lighter fg
--     fg1 = "#cdcecf", -- Default fg
--     fg2 = "#aeafb0", -- Darker fg (status line)
--     fg3 = "#71839b", -- Darker fg (line numbers, fold colums)
--
--     sel0 = "#2b3b51", -- Popup bg, visual selection bg
--     sel1 = "#3c5372", -- Popup sel bg, search bg
--   },
-- }

local lighter_nightfox_palette = {
  nightfox = {
    -- 10% saturate
    black = Shade.new("#33374a", 0.15, -0.15),
    red = Shade.new("#d44468", 0.15, -0.15),
    green = Shade.new("#77bc9b", 0.10, -0.15),
    yellow = Shade.new("#e4c46b", 0.15, -0.15),
    blue = Shade.new("#689bdf", 0.15, -0.15),
    magenta = Shade.new("#9b70df", 0.30, -0.15),
    cyan = Shade.new("#59d7d9", 0.15, -0.15),
    white = Shade.new("#dcdce3", 0.15, -0.15),
    orange = Shade.new("#fca259", 0.15, -0.15),
    pink = Shade.new("#df71d9", 0.15, -0.15),

    -- 3% darken
    bg0 = "#0e131a", -- Dark bg (status line and float)
    bg1 = "#141c26", -- Default bg
    bg2 = "#1c2735", -- Lighter bg (colorcolm folds)
    bg3 = "#243245", -- Lighter bg (cursor line)
    bg4 = "#344963", -- Conceal, border fg

    -- 3% lighten
    sel0 = "#30425b", -- Popup bg, visual selection bg
    sel1 = "#415b7c", -- Popup sel bg, search bg

    -- 5% lighten
    comment = "#818d9c",
    fg0 = "#e3e3e4", -- Lighter fg
    fg1 = "#dadbdc", -- Default fg
    fg2 = "#bbbcbc", -- Darker fg (status line)
    fg3 = "#8090a5", -- Darker fg (line numbers, fold colums)
  },
}

require("nightfox").setup({
  palettes = lighter_nightfox_palette,
  options = {
    -- optin modules
    module_default = false,
    -- :h nightfox-modules
    -- ~/.local/share/nvim/lazy/nightfox.nvim/lua/nightfox/config.lua
    modules = {
      -- ["alpha"] = true,
      ["aerial"] = true,
      -- ["barbar"] = true,
      ["cmp"] = true,
      -- ["coc"] = true,
      ["dap_ui"] = true,
      -- ["dashboard"] = true,
      ["diagnostic"] = true,
      -- ["fern"] = true,
      -- ["fidget"] = true,
      -- ["gitgutter"] = true,
      ["gitsigns"] = true,
      -- ["glyph_palette"] = true,
      -- ["hop"] = true,
      ["illuminate"] = true,
      ["indent_blankline"] = true,
      ["lazy"] = true,
      -- ["leap"] = true,
      -- ["lightspeed"] = true,
      -- ["lsp_saga"] = true,
      ["lsp_semantic_tokens"] = true,
      -- ["lsp_trouble"] = true,
      ["mini"] = true,
      -- ["modes"] = true,
      ["native_lsp"] = true,
      -- ["navic"] = true,
      -- ["neogit"] = true,
      -- ["neotest"] = true,
      -- ["neotree"] = true,
      -- ["notify"] = true,
      ["nvimtree"] = true,
      -- ["pounce"] = true,
      -- ["signify"] = true,
      -- ["sneak"] = true,
      -- ["symbol_outline"] = true,
      ["telescope"] = true,
      ["treesitter"] = true,
      -- ["tsrainbow"] = true,
      -- ["tsrainbow2"] = true,
      ["whichkey"] = true,
    },
  },
  specs = {
    all = {
      diff = {
        add = "#315343",
        delete = "#653f4b",
        change = "#1c3960",
        text = "#2d5d9d",
      },
    },
  },
  -- TODO: diagnosticsの下線
  groups = {
    -- https://github.com/EdenEast/nightfox.nvim/blob/main/lua/nightfox/palette/nightfox.lua
    all = {
      WinSeparator = { fg = "bg4" }, -- 分割時の区切り線
      CursorLineNr = { fg = "fg1" }, -- カーソル行の行番号
      Visual = { bg = "#244a7c" }, -- 選択テキスト vim-illuminateとかぶる対策、 少し色を変える
      HighlightYank = { fg = "palette.yellow.bright", style = "bold" }, -- 自作ハイライト、yankした時の文字色
      manItalic = { fg = "palette.green", style = "italic" }, -- manpageの斜体に色つける
      Whitespace = { fg = "palette.comment" }, -- :set listのタブ文字に色をつける
      SpecialKey = { fg = "palette.comment" }, -- ^Mのようなやつ
      LspReferenceText = { bg = "palette.black" }, -- 選択テキストと被るので黒系の色にする
      TermCursorNC = { bg = "palette.orange" }, -- ターミナルのカーソル位置, ノーマルモードにいるときに見やすく

      ------------ plugin ------------
      -- lukas-reineke/indent-blankline.nvim
      IblIndent = { fg = "bg4" }, -- indent-blanklineの色
      -- akinsho/bufferline.nvim
      BufferLineTabSelected = { fg = "palette.cyan", bg = "bg3" }, -- 選択されているタブを見やすく
      BufferLineTabSeparatorSelected = { fg = "#0d131a", bg = "bg3" }, -- only change bg
      -- nvim-telescope/telescope.nvim
      TelescopeTitle = { fg = "fg3" }, -- 文字色を明るく
      -- nvim-treesitter/nvim-treesitter-context
      TreesitterContext = { fg = "fg1", bg = "sel0" }, -- only change bg
      -- stevearc/aerial.nvim
      AerialLine = { fg = "palette.cyan.bright" },
      -- echasnovski/mini.indentscope
      MiniIndentscopeSymbol = { fg = "palette.comment" },
      -- andymass/vim-matchup
      MatchWord = { fg = "palette.pink.bright" },
    },
  },
})
vim.cmd.colorscheme("nightfox")
