-- highlight yanked region, see `:h lua-highlight`
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  group = vim.api.nvim_create_augroup("highlight_yank", {}),
  desc = "highlight after yank",
  callback = function()
    vim.highlight.on_yank({ higroup = "HighlightYank", timeout = 180 })
  end,
})

-- netrwとbufferlineを組み合わせる時にゴミが残るのを対策
-- pluginの中で行うことにした
-- vim.api.nvim_create_autocmd({ "FileType" }, {
--   pattern = "netrw",
--   callback = function()
--     vim.cmd([[
--       if b:netrw_curdir == bufname(bufnr('#')) && buflisted(bufnr('#'))
--         " unsilentを使わないと出ないので注意
--         "" unsilent echo "delete buffer"
--         bd #
--       fi
--     ]])
--   end,
-- }))
