require("ibl").setup({
  indent = {
    -- char = "▏",
    char = "│",
    highlight = "IblIndent",
    smart_indent_cap = false,
  },
  scope = {
    enabled = false, -- use mini-indentscope
    -- char = "▏",
    -- show_start = false,
    -- show_end = false,
    -- highlight = "IblScope",
  },
})

-- -- theme
-- local hi = vim.api.nvim_set_hl
-- local palette = require("nightfox.palette").load("nightfox")
-- hi(0, "IblIndent", { fg = palette.bg4 })
