local overrides = require "custom.configs.overrides"

---@type NvPluginSpec[]
local plugins = {
  -------------------------- override plugins -----------------------------------
  {
    "nvim-telescope/telescope.nvim",
    opts = overrides.telescope,
  },
  {
    "nvim-tree/nvim-tree.lua",
    opts = overrides.nvimtree,
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
    opts = overrides.mason,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = overrides.treesitter,
  },
  {
    "NvChad/nvterm",
    opts = overrides.nvterm,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp-signature-help", -- 関数入力時の補完
    },
    opts = function()
      local cmp = require "cmp"
      local conf = require "plugins.configs.cmp"
      -- Goなどで勝手に補完が選択されるので、されないようにする
      -- @see https://github.com/hrsh7th/nvim-cmp/blob/main/doc/cmp.txt
      -- Why does cmp automatically select a particular item? ~
      -- How to disable the preselect feature? ~
      conf.preselect = cmp.PreselectMode.None

      -- Tabで補完を確定させる
      conf.mapping["<Tab>"] = cmp.mapping(function(fallback)
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

      conf.mapping["<PageUp>"] = cmp.mapping.select_prev_item { count = 11 }
      conf.mapping["<PageDown>"] = cmp.mapping.select_next_item { count = 11 }
      conf.mapping["<C-u>"] = cmp.mapping.scroll_docs(-4)
      conf.mapping["<C-d>"] = cmp.mapping.scroll_docs(4)
      conf.mapping["<C-f>"] = nil -- emacsのRight cursorと被るので無効
      conf.mapping["<C-e>"] = nil -- emacsのEnd of cursorと被るのでC-gにremap
      conf.mapping["<C-g>"] = cmp.mapping.close()

      -- 関数入力時の補完を設定 lspデフォルトはカーソルと被る問題があるため変更する
      conf.sources[#conf.sources + 1] = { name = "nvim_lsp_signature_help" }

      return conf
    end,
  },
  {
    "folke/which-key.nvim",
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
          u = { name = "+ui/toggle" },
        },
      }
    end,
  },

  -------------------------- my plugins -----------------------------------
  {
    "nvimtools/none-ls.nvim",
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
    "jay-babu/mason-nvim-dap.nvim", -- for DAP (C++, Bash)
    ft = { "c", "cpp", "sh" },
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
    },
    opts = {
      handlers = {},
    },
  },
  {
    "leoluz/nvim-dap-go",
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
  },
  {
    "ahmedkhalf/project.nvim",
    event = "VeryLazy",
    config = function()
      require("project_nvim").setup {
        manual_mode = true,
        patterns = { ".git", "package.json" },
        datapath = vim.fn.stdpath "config" .. "/lua/custom/data", -- configフォルダ以下に保存する
      }
      require("telescope").load_extension "projects"
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
  {
    "someone-stole-my-name/yaml-companion.nvim", -- YAML LSP
    ft = {
      "yaml",
      "yaml.docker-compose", -- pattern match not supported?
    },
    dependencies = {
      { "neovim/nvim-lspconfig" },
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope.nvim" },
    },
    config = function()
      require("telescope").load_extension "yaml_schema"

      -- MEMO: ここでLSP configを設定することで yamlファイルのみlazy loadするようにしている
      local cfg = require("yaml-companion").setup {
        schemas = {
          {
            name = "Kubernetes 1.25.9",
            uri = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.25.9-standalone-strict/all.json",
          },
        },
      }
      require("lspconfig")["yamlls"].setup(cfg)
    end,
  },
  {
    "b0o/schemastore.nvim", -- YAML/JSON LSP
    lazy = true,
    version = false,
  },
  {
    "anuvyklack/windows.nvim", -- Ctrl+W Z to zoom like tmux
    event = "WinNew",
    dependencies = {
      { "anuvyklack/middleclass" },
    },
    keys = { { "<C-w>z", "<cmd>WindowsMaximize<cr>", desc = "Zoom" } },
    config = function()
      require("windows").setup {
        autowidth = {
          enable = false,
        },
      }
    end,
  },
  {
    "almo7aya/openingh.nvim",
    cmd = { "OpenInGHRepo", "OpenInGHFile", "OpenInGHFileLines" },
  },
}

return plugins
