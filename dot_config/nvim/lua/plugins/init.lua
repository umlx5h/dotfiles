local plugins = {
  { "nvim-lua/plenary.nvim" },

  -- theme
  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("plugins.configs.nightfox")
    end,
  },

  -- file tree
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    config = function()
      require("plugins.configs.nvimtree")
    end,
  },

  -- file explorer replacing netrrw
  {
    "stevearc/oil.nvim",
    event = "VeryLazy",
    cmd = { "Oil" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("plugins.configs.oil")
    end,
  },

  -- icons, for UI related plugins
  {
    "nvim-tree/nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup()
    end,
  },

  -- syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    cmd = { "TSUpdate", "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-context",
      opts = {
        multiline_threshold = 1, -- Maximum number of lines to show for a single context
      },
      {
        -- replaceing matchit, matchparen
        "andymass/vim-matchup",
      },
    },
    config = function()
      require("plugins.configs.treesitter")
      require("nvim-treesitter.configs").setup({
        matchup = {
          enable = true, -- mandatory, false will disable the whole extension
          disable = {}, -- optional, list of language that will be disabled
          disable_virtual_text = true,
        },
      })
    end,
  },

  -- buffer + tab line
  {
    "akinsho/bufferline.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("plugins.configs.bufferline")
    end,
  },

  -- statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    config = function()
      require("plugins.configs.lualine")
      -- -- netrwを使うとbufferlineで表示がおかしくなる対策
      -- -- VeryLazyのプラグインならどこでもいい
      -- if vim.bo.filetype == "netrw" then
      --   vim.schedule(function()
      --     vim.cmd([[ bwipeout % ]])
      --   end)
      -- end
    end,
  },

  -- completions, snippets
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter", -- only load when insert mode
    dependencies = {
      -- snippets
      {
        -- engine
        "L3MON4D3/LuaSnip",
        -- list of default snippets
        dependencies = "rafamadriz/friendly-snippets",
        config = function()
          -- load from friendly-snippets
          require("luasnip.loaders.from_vscode").lazy_load()
          -- TODO: vscodeと共有する
          -- load from my-snippets
          require("luasnip.loaders.from_vscode").lazy_load({ paths = "./my-snippets" })
        end,
      },

      -- autopairs , autocompletes ()[] etc
      {
        "windwp/nvim-autopairs",
        config = function()
          require("nvim-autopairs").setup()
          --  cmp integration
          local cmp_autopairs = require("nvim-autopairs.completion.cmp")
          local cmp = require("cmp")
          cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
      },

      -- cmp sources
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lua",
      "saadparwaiz1/cmp_luasnip",

      "hrsh7th/cmp-nvim-lsp-signature-help", -- 引数入力時の補完
    },
    config = function()
      require("plugins.configs.cmp")
    end,
  },

  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
    config = function()
      require("plugins.configs.mason")
    end,
  },

  -- lsp
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("plugins.configs.lspconfig")
    end,
  },

  -- neovim lua lsp
  {
    "folke/neodev.nvim",
  },

  -- formatter
  {
    "stevearc/conform.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("plugins.configs.conform")
    end,
  },

  -- linter, code actions
  {
    "nvimtools/none-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "gbprod/none-ls-shellcheck.nvim",
    },
    opts = function()
      return require("plugins.configs.null-ls")
    end,
  },

  -- indent lines
  {
    "lukas-reineke/indent-blankline.nvim",
    -- cmd = { "IBLToggle", "IBLEnable" }, -- disable for high cpu usage
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("plugins.configs.indent-blankline")
    end,
  },

  -- scope indent lines, text object
  {
    "echasnovski/mini.indentscope",
    version = false,
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("mini.indentscope").setup({
        -- symbol = "▏",
        symbol = "│",
        draw = {
          -- animation = require("mini.indentscope").gen_animation.none(),
          animation = function()
            return 20
          end,
        },
      })
    end,
  },

  -- files finder etc
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", { "nvim-telescope/telescope-fzf-native.nvim", build = "make" } },
    cmd = "Telescope",
    config = function()
      require("plugins.configs.telescope")
    end,
  },

  -- git status on signcolumn etc
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("gitsigns").setup({
        signs = {
          -- add = { text = "▏" },
          add = { text = "│" },
          change = { text = "│" },
          delete = { text = "󰍵" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
          untracked = { text = "│" },
        },
      })
    end,
  },
  {
    "tpope/vim-fugitive",
    cmd = { "G", "Git", "GBrowse", "Gclog", "GDelete", "Ggrep", "Gread", "Gwrite", "Gdiffsplit", "Gvdiffsplit" },
    config = function()
      -- Gclogでquicfixに送る時にauthorと日時を表示する
      vim.g.fugitive_summary_format = "%cs || %<(14,trunc)%an || %s"
    end,
    dependencies = {
      "tpope/vim-rhubarb",
    },
  },
  {
    "rbong/vim-flog",
    cmd = { "Flog", "Flogsplit", "Floggit" },
    dependencies = {
      "tpope/vim-fugitive",
    },
    config = function()
      vim.g.flog_default_opts = {
        -- format = "%ad [%h] {%an}%d %s" -- default
        date = "format:%Y-%m-%d %H:%M",
      }
    end,
  },
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    config = function(_, _)
      local actions = require("diffview.config").actions
      require("diffview").setup({
        keymaps = {
          file_history_panel = { ["O"] = actions.open_in_diffview },
        },
      })
    end,
  },
  -- comment plugin
  {
    "numToStr/Comment.nvim",
    keys = {
      { "gcc", mode = "n", desc = "Comment toggle current line" },
      { "gc", mode = { "n", "o" }, desc = "Comment toggle linewise" },
      { "gc", mode = "x", desc = "Comment toggle linewise (visual)" },
      { "gbc", mode = "n", desc = "Comment toggle current block" },
      { "gb", mode = { "n", "o" }, desc = "Comment toggle blockwise" },
      { "gb", mode = "x", desc = "Comment toggle blockwise (visual)" },
    },
    config = function()
      require("Comment").setup()
    end,
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("plugins.configs.which-key")
    end,
  },
  {
    "NvChad/nvim-colorizer.lua",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("colorizer").setup({})
    end,
  },
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTelescope", "TodoQuickFix" },
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("todo-comments").setup({
        keywords = {
          MEMO = { icon = " ", color = "hint", alt = { "INFO" } }, -- same as NOTE
        },
      })
    end,
  },
  {
    -- "nmac427/guess-indent.nvim",
    "umlx5h/guess-indent.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("guess-indent").setup({
        -- auto_cmd = false,
        on_tab_options = {
          ["expandtab"] = false,
          ["softtabstop"] = 0,
          ["shiftwidth"] = 0,
        },
        on_space_options = {
          ["expandtab"] = true,
          ["shiftwidth"] = "detected",
          ["softtabstop"] = -1,
        },
      })
    end,
  },
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
  },
  {
    "nvim-pack/nvim-spectre",
    cmd = "Spectre",
    config = function()
      require("plugins.configs.spectre")
    end,
  },
  {
    "anuvyklack/windows.nvim", -- <leader>Z to zoom like tmux
    dependencies = {
      { "anuvyklack/middleclass" },
    },
    keys = { { "<leader>z", "<cmd>WindowsMaximize<cr>", desc = "Zoom" } },
    config = function()
      require("windows").setup({
        autowidth = {
          enable = false,
        },
      })
    end,
  },
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    event = "QuickFixCmdPost",
    dependencies = "junegunn/fzf",
    config = function()
      require("plugins.configs.bqf")
    end,
  },
  {
    "stevearc/aerial.nvim", -- Symbol outline
    cmd = { "AerialToggle", "AerialNext", "AerialPrev" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("aerial").setup({
        keymaps = {
          ["o"] = "actions.scroll",
          ["O"] = "actions.jump",
        },
        -- on_attach = function(bufnr)
        --   -- Jump forwards/backwards with '{' and '}'
        --   vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr, desc = "Prev symbol" })
        --   vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr, desc = "Next symbol" })
        -- end,
      })
    end,
  },
  {
    "RRethy/vim-illuminate", -- カーソル下の単語をハイライト, ALT+P, Nで移動可
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("illuminate").configure({
        delay = 200,
        large_file_cutoff = 2000,
        large_file_overrides = {
          providers = { "lsp" },
        },
      })
    end,
  },
  {
    "liangxianzhe/nap.nvim", -- [q などの後にA-yで繰り返せるようになる
    event = "VeryLazy",
    config = function()
      require("plugins.configs.nap")
    end,
  },
  {
    "kylechui/nvim-surround",
    event = { "BufReadPost", "BufNewFile" },
    version = "*",
    config = function()
      require("nvim-surround").setup({
        keymaps = {
          insert = false, -- nvim-cmp uses <C-g>
          insert_line = false,
          visual_line = false, -- mini.splitjoin gS
        },
      })
    end,
  },
  {
    "b0o/SchemaStore.nvim", -- YAML/JSON LSP
    lazy = true,
    version = false, -- last release is way too old
  },
  {
    "someone-stole-my-name/yaml-companion.nvim", -- YAML LSP + Kubernetes yaml support
    ft = {
      "yaml",
      "yaml.docker-compose",
    },
    dependencies = {
      { "neovim/nvim-lspconfig" },
      { "nvim-lua/plenary.nvim" },
      -- { "nvim-telescope/telescope.nvim" },
    },
    config = function()
      require("plugins.configs.yaml-companion")
    end,
  },

  -- dap debug
  {
    "mfussenegger/nvim-dap",
    cmd = { "DapToggleBreakpoint", "DapContinue" },
    dependencies = {
      {
        "rcarriga/nvim-dap-ui",
        config = function()
          local dap = require("dap")
          local dapui = require("dapui")
          dapui.setup()
          dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
            require("hydra").spawn("dap-hydra")
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
        -- ft = { "c", "cpp", "sh" },
        dependencies = {
          "williamboman/mason.nvim",
        },
        config = function()
          require("mason-nvim-dap").setup({
            handlers = {},
          })
        end,
      },
      {
        "theHamsta/nvim-dap-virtual-text",
        config = function()
          require("nvim-dap-virtual-text").setup()
        end,
      },
      {
        "leoluz/nvim-dap-go",
        -- ft = "go",
        config = function()
          require("dap-go").setup()
        end,
      },
      {
        "anuvyklack/hydra.nvim",
        dependencies = "anuvyklack/keymap-layer.nvim",
        keys = {
          { "<leader>dh", "", { desc = "Dap Hydra" } },
        },
        config = function()
          require("plugins.configs.hydra")
        end,
      },
    },
    config = function()
      require("plugins.configs.dap")
    end,
  },

  {
    "olexsmir/gopher.nvim",
    ft = "go",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("gopher").setup()
    end,
  },
  {
    "rafaelsq/nvim-goc.lua",
    ft = "go",
    config = function()
      local goc = require("nvim-goc")
      goc.setup({
        verticalSplit = false,
      })
      vim.api.nvim_create_user_command("GoCov", function()
        require("nvim-goc").Coverage()
      end, {})
      vim.api.nvim_create_user_command("GoCovClear", function()
        require("nvim-goc").ClearCoverage()
      end, {})
    end,
  },

  {
    "echasnovski/mini.splitjoin",
    -- keys = { "gS" },
    keys = {
      { "gS", mode = "n" },
      { "gS", mode = "x" },
    },
    version = false,
    config = function()
      require("mini.splitjoin").setup()
    end,
  },
}

local ok, work_plugins = pcall(require, "work.plugins")
if ok then
  plugins = vim.tbl_deep_extend("force", plugins, work_plugins)
end

require("lazy").setup(plugins, require("plugins.configs.lazy"))
