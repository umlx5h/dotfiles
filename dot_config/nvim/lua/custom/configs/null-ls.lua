local null_ls = require "null-ls"
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local opts = {
  sources = {
    -- Lua
    null_ls.builtins.formatting.stylua,
    -- Go
    null_ls.builtins.code_actions.impl,
    null_ls.builtins.code_actions.gomodifytags,
    null_ls.builtins.formatting.goimports,
    -- null_ls.builtins.formatting.gofumpt,
    null_ls.builtins.formatting.gofmt,
    -- null_ls.builtins.formatting.goimports_reviser,
    -- null_ls.builtins.formatting.golines,

    -- C, C++
    null_ls.builtins.formatting.clang_format,

    -- Typescript, Javascript
    null_ls.builtins.diagnostics.eslint,
    null_ls.builtins.formatting.prettier,
  },
  -- setting auto formatter
  on_attach = function(client, bufnr)
    -- only Go autoformat
    local autoFormatLangs = {
      ["go"] = true,
      ["typescript"] = true,
      ["javascript"] = true,
    }

    if client.supports_method "textDocument/formatting" and autoFormatLangs[vim.bo.filetype] then
      vim.api.nvim_clear_autocmds {
        group = augroup,
        buffer = bufnr,
      }
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format { bufnr = bufnr }
        end,
      })
    end
  end,
}
return opts
