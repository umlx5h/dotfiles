local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"
local util = require "lspconfig/util"

-- Go

lspconfig.gopls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_dir = util.root_pattern("go.work", "go.mod", ".git"),
  settings = {
    gopls = {
      completeUnimported = true,
      -- usePlaceholders = true,
      -- staticcheck = false,
      analyses = {
        unusedparams = true,
      },
    },
  },
}

-- C, C++

lspconfig.clangd.setup {
  on_attach = function(client, bufnr)
    -- client.server_capabilities.signatureHelpProvider = false
    on_attach(client, bufnr)
  end,
  capabilities = vim.tbl_deep_extend("force", capabilities, {
    offsetEncoding = { "utf-16" }, -- FIX: warning: multiple different client offset_encodings detected for buffer, this is not supported yet
  }),
}

-- YAML (ansible)
lspconfig.ansiblels.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  root_dir = util.root_pattern("ansible.cfg", "roles"), -- ansibleのプロジェクトを検知した場合のみ有効にする
  filetypes = { "yaml", "yaml.ansible" },
  single_file_support = false,
}

-- JSON
lspconfig.jsonls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  -- lazy-load schemastore when needed
  on_new_config = function(new_config)
    new_config.settings.json.schemas = new_config.settings.json.schemas or {}
    vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
  end,
  settings = {
    json = {
      -- schemas = require("schemastore").json.schemas(),
      validate = { enable = true },
    },
  },
}

-- Other

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
local servers = {
  "html",
  "cssls",
  "tsserver",
  "dockerls",
  "docker_compose_language_service",
  "bashls",
  "pyright",
  "intelephense",
  "rust_analyzer",
}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

-- LSP other config

-- adjust popup menu width and height
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or "single"
  -- 画面の大きさに対して%指定でサイズを調整
  opts.max_height = opts.max_height or math.floor(vim.api.nvim_win_get_height(0) * 0.5)
  opts.max_width = opts.max_width or math.floor(vim.api.nvim_win_get_width(0) * 0.7)

  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end
