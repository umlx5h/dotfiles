require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    javascript = { "prettierd" },
    go = { "gofmt", "goimports" },
    sh = { "shfmt" },
    c = { "clang_format" },
    cpp = { "clang_format" },
  },
})

-- setup auto-format
vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("format_on_save", { clear = true }),
  desc = "Code format on save",
  pattern = { "*.lua", "*.go", "*.js", "*.ts", "*.tsx", "*.jsx" },
  callback = function(args)
    require("conform").format({ bufnr = args.buf })
  end,
})
