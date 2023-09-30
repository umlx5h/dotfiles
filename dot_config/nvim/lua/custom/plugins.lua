-- TODO: move override
local plugins = {
  {
    "nvim-telescope/telescope.nvim", -- override
    opts = {
      pickers = {
        buffers = {
          mappings = {
            i = {
              ["<C-d>"] = "delete_buffer", -- バッファ一覧画面でCtrl+Dで消せるようにする
            },
          },
        },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- lua stuff
        "lua-language-server",
        "stylua",

        -- web dev stuff
        "css-lsp",
        "html-lsp",

        -- javascript
        "eslint-lsp",
        "js-debug-adapter",
        "typescript-language-server",
        "prettier",

        -- go
        "gopls",
        "goimports",
        "goimports-reviser",
        "golangci-lint",
        "golines",
        "gotests",
        "gofumpt",
        "gomodifytags",
        "impl",

        -- C, C++
        "clangd",
        "clang-format",
        "codelldb",
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
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

        "make",
        "gitignore",
        "bash",
        "go",
        "gomod",
        "gosum",
        "gowork",
      },
      indent = { enable = false }, -- Cでswitchのcaseの部分などで勝手にインデントを変えられてしまうため無効にする
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<c-space>",
          node_incremental = "<c-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    },
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    -- ft = "go",
    event = "VeryLazy",
    opts = function()
      return require "custom.configs.null-ls"
    end,
  },
  {
    "mfussenegger/nvim-dap",
    config = function(_, _)
      require "custom.configs.dap" -- load setting
      require("core.utils").load_mappings "dap" -- load keymap
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    event = "VeryLazy",
    dependencies = "mfussenegger/nvim-dap",
    config = function()
      local dap = require "dap"
      local dapui = require "dapui"
      dapui.setup()
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim", -- for C++?
    event = "VeryLazy",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
    },
    opts = {
      handlers = {},
    },
  },
  {
    "dreamsofcode-io/nvim-dap-go",
    ft = "go",
    dependencies = "mfussenegger/nvim-dap",
    config = function(_, opts)
      require("dap-go").setup(opts)
      require("core.utils").load_mappings "dap_go"
    end,
  },

  {
    "olexsmir/gopher.nvim",
    ft = "go",
    config = function(_, opts)
      require("gopher").setup(opts)
      require("core.utils").load_mappings "gopher"
    end,
    build = function()
      vim.cmd [[silent! GoInstallDeps]]
    end,
  },
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    config = function(_, _)
      require("core.utils").load_mappings "undotree" -- load keymap
    end,
  },
  {
    "hrsh7th/nvim-cmp", -- override
    dependencies = {
      "hrsh7th/cmp-nvim-lsp-signature-help",
    },
    opts = function()
      -- TODO: where do I put this?
      local cmp = require "cmp"
      cmp_opts = require "plugins.configs.cmp"
      -- Goなどで勝手に補完が選択されるので、されないようにする
      -- @see https://github.com/hrsh7th/nvim-cmp/blob/main/doc/cmp.txt
      -- Why does cmp automatically select a particular item? ~
      -- How to disable the preselect feature? ~
      cmp_opts.preselect = cmp.PreselectMode.None
      -- -- Tabで補完を確定させる
      cmp_opts.mapping["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.confirm { select = false }
        elseif require("luasnip").expand_or_jumpable() then
          vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
        else
          fallback()
        end
      end, {
        "i",
        "s",
      })

      cmp_opts.mapping["<C-u>"] = cmp.mapping.scroll_docs(-4)
      cmp_opts.mapping["<C-d>"] = cmp.mapping.scroll_docs(4)
      cmp_opts.mapping["<C-f>"] = nil -- emacsのRight cursorと被るので無効
      cmp_opts.sources[#cmp_opts.sources + 1] = { name = "nvim_lsp_signature_help" } -- lspデフォルトはカーソルと被る問題があるため変更する
      return cmp_opts
    end,
  },
  {
    "NvChad/nvterm", -- override
    opts = {
      terminals = {
        type_opts = {
          float = {
            relative = "editor",
            row = 0.07,
            col = 0.05,
            width = 0.9,
            height = 0.8,
            border = "single",
          },
        },
      },
    },
  },
  {
    "ahmedkhalf/project.nvim",
    init = function()
      require("telescope").load_extension "projects"
    end,
    config = function()
      require("project_nvim").setup {
        manual_mode = true,
        patterns = { ".git", "package.json" },
        datapath = vim.fn.stdpath "config" .. "/lua/custom/data", -- configフォルダ以下に保存する
      }
    end,
  },

  {
    "folke/which-key.nvim", -- override
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "whichkey")
      require("which-key").setup(opts)

      -- prefixに名前を付ける
      local wk = require "which-key"
      wk.register {
        ["<leader>"] = {
          c = { name = "+code" },
          d = { name = "+debug" },
          f = { name = "+find" },
          g = { name = "+git" },
          u = { name = "+ui" },
        },
      }
    end,
  },
  {
    "nvim-pack/nvim-spectre",
    cmd = "Spectre",
    opts = { open_cmd = "noswapfile vnew" },
  },
  {
    "folke/todo-comments.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      keywords = {
        MEMO = { icon = " ", color = "hint", alt = { "INFO" } }, -- same as NOTE
      },
    },
  },

}

return plugins
