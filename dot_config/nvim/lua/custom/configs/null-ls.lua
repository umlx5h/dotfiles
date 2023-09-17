local null_ls = require("null-ls")
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local opts = {
  sources = {
    -- Go
    -- null_ls.builtins.formatting.goimports,
    -- null_ls.builtins.formatting.gofumpt,
    null_ls.builtins.formatting.gofmt,
    null_ls.builtins.formatting.goimports_reviser,
    null_ls.builtins.formatting.golines,

    -- C, C++
    null_ls.builtins.formatting.clang_format,
  },
  -- setting auto formatter
  on_attach = function(client, bufnr)
    -- only Go autoformat
    if client.supports_method("textDocument/formatting") and vim.bo.filetype == "go" then
      vim.api.nvim_clear_autocmds({
        group = augroup,
        buffer = bufnr,
      })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        -- pattern = { "*.go" },
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr })
        end,
      })
    end
  end,
}
return opts
