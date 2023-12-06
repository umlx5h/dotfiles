require("bufferline").setup({
  options = {
    themable = true,
    offsets = {
      { filetype = "NvimTree", highlight = "NvimTreeNormal" },
    },
  },
})

-- -- theme
-- local palette = require("nightfox.palette").load("nightfox")
-- local hi = vim.api.nvim_set_hl
--
-- hi(0, "BufferLineTabSelected", { fg = palette.cyan.base, bg = palette.bg3 })
-- hi(0, "BufferLineTabSeparatorSelected", { fg = "#0d131a", bg = palette.bg3 }) -- change bg
