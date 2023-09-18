local plugins = {
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
      require("core.utils").load_mappings("dap") -- load keymap
    end
  },
  {
    "rcarriga/nvim-dap-ui",
    event = "VeryLazy",
    dependencies = "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
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
    end
  },
  {
    "jay-babu/mason-nvim-dap.nvim", -- for C++?
    event = "VeryLazy",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
    },
    opts = {
      handlers = {}
    },
  },
  {
    "dreamsofcode-io/nvim-dap-go",
    ft = "go",
    dependencies = "mfussenegger/nvim-dap",
    config = function(_, opts)
      require("dap-go").setup(opts)
      require("core.utils").load_mappings("dap_go")
    end
  },

  {
    "olexsmir/gopher.nvim",
    ft = "go",
    config = function(_, opts)
      require("gopher").setup(opts)
      require("core.utils").load_mappings("gopher")
    end,
    build = function()
      vim.cmd [[silent! GoInstallDeps]]
    end,
  },
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    config = function(_, _)
      require("core.utils").load_mappings("undotree") -- load keymap
    end
  },
  {
    "hrsh7th/nvim-cmp",
    opts = function ()
      -- TODO: where do I put this?
      local cmp = require "cmp"
      cmp_opts = require "plugins.configs.cmp"
      -- Goなどで勝手に補完が選択されるので、されないようにする
      cmp_opts.preselect = cmp.PreselectMode.None
      -- Tabで補完を確定させる
      cmp_opts.mapping["<Tab>"] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Insert,
        select = true,
      }
      return cmp_opts
    end
  },
}

return plugins
