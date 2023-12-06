-- ハイライトを検索する方法
-- :Telescope highlightsを使う
-- or
-- :highlightsから調べる
--
-- :redir > highlight.txt -> :highlight -> :redir END -> :e highlight.txt

require("nightfox").setup({
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
      VertSplit = { fg = "bg4" }, -- 分割時の区切り線
      CursorLineNr = { fg = "fg1" }, -- カーソル行の行番号
      Visual = { bg = "#244a7c" }, -- 選択テキスト vim-illuminateとかぶる対策、 少し色を変える
      HighlightYank = { fg = "palette.yellow.bright", style = "bold" }, -- 自作ハイライト、yankした時の文字色
      manItalic = { fg = "palette.green", style = "italic" }, -- manpageの斜体に色つける
      Whitespace = { fg = "palette.comment" }, -- :set listのタブ文字に色をつける
      SpecialKey = { fg = "palette.comment" }, -- ^Mのようなやつ

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
    },
  },
})
vim.cmd.colorscheme("nightfox")
