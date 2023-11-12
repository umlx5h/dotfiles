local M = {}

M.treesitter = {
  ensure_installed = {
    "vim",
    "lua",
    "html",
    "css",
    "javascript",
    "typescript",
    "tsx",
    "c",
    "cpp",
    "markdown",
    "markdown_inline",
    "dockerfile",

    "make",
    "gitignore",
    "bash",
    "go",
    "gomod",
    "gosum",
    "gowork",

    "yaml",
    "json",
    "json5",
    "jsonc",

    "python",

    "php",
    "phpdoc",

    "toml",
    "tsv",
    "csv",
    "hcl",
    "ruby",
  },
  indent = {
    enable = true,
    disable = {
      "c", -- Cでswitchのcaseの部分などで勝手にインデントを変えられてしまうため無効にする
      "cpp",
    },
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<c-space>",
      node_incremental = "<c-space>",
      scope_incremental = false,
      node_decremental = "<bs>",
    },
  },
}

M.mason = {
  ensure_installed = {
    -- lua stuff
    "lua-language-server",
    "stylua",

    -- shell
    "shfmt",
    "shellcheck",
    "bash-language-server",
    "bash-debug-adapter",

    -- web dev stuff
    "css-lsp",
    "html-lsp",

    -- javascript
    "eslint-lsp",
    "js-debug-adapter",
    "typescript-language-server",
    "prettierd",

    -- go
    "gopls",
    "goimports",
    "golangci-lint",
    "golines",
    "gotests", -- not null-ls, for olexsmir/gopher.nvim
    "iferr", -- not null-ls, for olexsmir/gopher.nvim
    "gomodifytags",
    "impl",

    -- C, C++
    "clangd",
    "clang-format",
    "codelldb",

    -- YAML
    "yaml-language-server",
    "ansible-language-server",

    -- JSON
    "json-lsp",

    -- Docker
    "dockerfile-language-server",
    "docker-compose-language-service",

    -- Python
    "pyright",

    -- PHP
    "intelephense",

    -- Rust
    "rust-analyzer",
  },
}

M.telescope = {
  defaults = {
    file_ignore_patterns = {
      "node_modules",
      ".git/",
      ".github/",
      "package-lock.json",
      "yarn.lock",
    },
  },
  pickers = {
    find_files = {
      hidden = true,
    },
    live_grep = {
      additional_args = function()
        return { "--hidden" }
      end,
    },
    buffers = {
      mappings = {
        i = {
          ["<C-d>"] = "delete_buffer", -- バッファ一覧画面でCtrl+Dで消せるようにする
        },
      },
    },
  },
}

local function nvimtree_on_attach(bufnr)
  local api = require "nvim-tree.api"

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- default mappings
  api.config.mappings.default_on_attach(bufnr)

  -- custom mappings
  -- @see: https://github.com/nvim-tree/nvim-tree.lua/blob/master/doc/nvim-tree-lua.txt
  vim.keymap.set("n", "l", api.node.open.preview_no_picker, opts "Open Preview: No Picker")
  vim.keymap.set("n", "h", api.node.navigate.parent_close, opts "Close Directory")
end

M.nvimtree = {
  on_attach = nvimtree_on_attach,

  respect_buf_cwd = true,

  -- Enable Netrw to make the 'gx' shortcut work
  disable_netrw = false,
  -- netrwとnvtreeを共存されるのに必要な設定
  hijack_netrw = false, -- vim . で開いた時にnetrwを開いた状態でnvimtreeを開ける

  diagnostics = {
    enable = false,
  },
  modified = {
    enable = true,
  },
  git = {
    enable = true,
  },
  filters = {
    git_ignored = false, -- gitのignoreファイルをデフォルトで表示
  },
  renderer = {
    highlight_git = true,
    -- highlight_diagnostics = true,
    icons = {
      show = {
        git = false, -- アイコン鬱陶しいので消す
        -- diagnostics = false,
      },
    },
  },
}

M.nvterm = {
  terminals = {
    type_opts = {
      float = { -- 大きくする
        relative = "editor",
        row = 0.07,
        col = 0.05,
        width = 0.9,
        height = 0.8,
        border = "single",
      },
    },
  },
}

return M
