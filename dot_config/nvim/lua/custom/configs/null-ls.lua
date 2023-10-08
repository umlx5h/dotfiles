local null_ls = require "null-ls"
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local opts = {
  -- https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTINS.md
  sources = {
    -- Lua
    null_ls.builtins.formatting.stylua,

    -- Shell
    null_ls.builtins.formatting.shfmt,
    null_ls.builtins.code_actions.shellcheck,

    -- Go
    null_ls.builtins.code_actions.impl,
    null_ls.builtins.code_actions.gomodifytags,
    null_ls.builtins.formatting.goimports,
    -- null_ls.builtins.formatting.gofumpt,
    null_ls.builtins.formatting.gofmt,
    null_ls.builtins.diagnostics.golangci_lint,
    -- null_ls.builtins.formatting.goimports_reviser,
    -- null_ls.builtins.formatting.golines,

    -- C, C++
    null_ls.builtins.formatting.clang_format,

    -- Typescript, Javascript
    null_ls.builtins.diagnostics.eslint,
    -- { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "css", "scss", "less", "html", "json", "jsonc", "yaml", "markdown", "markdown.mdx", "graphql", "handlebars" }
    null_ls.builtins.formatting.prettierd,
  },
  -- setting auto formatter
  on_attach = function(client, bufnr)
    local autoFormatLangs = {
      -- set auto format for specific filetype
      ["go"] = true,
      ["typescript"] = true,
      ["javascript"] = true,
      ["lua"] = true,
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
