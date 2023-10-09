---@type MappingsTable
local M = {}

-- In order to disable a default keymap, use
M.disabled = {
  t = {
    -- Toggle horizontal term
    ["<A-h>"] = "",
  },
  n = {
    --------------------- General -----------------------
    -- disable
    ["<C-c>"] = "", -- for ESC (Copy all)
    ["<leader>b"] = "", -- to <leader>n (New buffer)
    ["<leader>n"] = "", -- to <leader>un (line numbers)
    ["<leader>rn"] = "", -- disable

    --------------------- tabufline -----------------------
    ["<tab>"] = "", -- TODO: Ctrl+Iと被ってしまう問題があるため一旦]bにremap
    ["<S-tab>"] = "",

    --------------------- telescope -----------------------
    ["<leader>fz"] = "",
    ["<leader>ma"] = "",
    ["<leader>pt"] = "",

    --------------------- nvterm -----------------------
    ["<A-h>"] = "",
    ["<leader>h"] = "",
    ["<leader>v"] = "",

    --------------------- gitsigns -----------------------
    ["<leader>td"] = "", -- disable (Toggle deleted)
    ["]c"] = "", -- to <leader>]g (Jump to next hunk)
    ["[c"] = "", -- to <leader>[g (Jump to prev hunk)
    ["<leader>rh"] = "", -- to <leader>gr (Reset hunk)
    ["<leader>ph"] = "", -- to <leader>gp (Preview hunk)

    --------------------- LSP -----------------------
    ["gi"] = "",
    ["<leader>ls"] = "", -- remap to gK (LSP signature help)
    ["<leader>ra"] = "", -- remap to <leader>cr (LSP rename)
    ["<leader>f"] = "", -- remap to <leader>fd (Floating diagnostic)
  },
  i = {
    -- /* Disable .general */
    -- go to  beginning and end
    ["<C-b>"] = "",
    ["<C-e>"] = "",
    -- navigate within insert mode
    ["<C-h>"] = "",
    ["<C-l>"] = "",
    ["<C-j>"] = "",
    ["<C-k>"] = "",
  },
}

--------------------- Override -----------------------
M.general = {
  i = {
    ["<C-s>"] = { "<cmd> w <CR>", "Save file" },
  },
  n = {
    ["<leader>n"] = { "<cmd> enew <CR>", "New buffer" },
  },
}

M.nvterm = {
  plugin = true,

  t = {
    -- toggle in terminal mode
    ["<A-m>"] = { -- From <A-h>
      function()
        require("nvterm.terminal").toggle "horizontal"
      end,
      "Toggle bottom term",
    },
  },

  n = {
    -- toggle in normal mode
    ["<A-m>"] = { -- From <A-h>
      function()
        require("nvterm.terminal").toggle "horizontal"
      end,
      "Toggle bottom term",
    },
    ["<leader>gg"] = {
      function()
        local nvterm = require "nvterm.terminal"
        nvterm.send("tig && exit", "float")
        -- フォーカスを合わせるために無理やり2回トグル
        -- https://github.com/NvChad/nvterm/issues/43
        nvterm.toggle "float"
        nvterm.toggle "float"
      end,
      "Open tig",
    },
  },
}

M.nvimtree = {
  plugin = true,
  n = {
    -- トグル時にツリーにフォーカスが移らないようにする
    ["<C-n>"] = {
      function()
        require("nvim-tree.api").tree.toggle(false, true)
      end,
      "Toggle nvimtree",
    },
  },
}

M.telescope = {
  plugin = true,
  n = {
    -- find
    ["<C-p>"] = { "<cmd> Telescope find_files <CR>", "Find Project files" },
    ["<leader><space>"] = { "<cmd> Telescope buffers <CR>", "Find buffers" },
    ["<leader>f/"] = { "<cmd> Telescope current_buffer_fuzzy_find <CR>", "Find in current buffer" }, -- from <leader>fz
    ["<leader>fc"] = { "<cmd> Telescope commands <CR>", "Find commands" }, -- copy from astronvim
    ["<leader>fk"] = { "<cmd> Telescope keymaps <CR>", "Find keymaps" }, -- copy from astronvim
    ["<leader>fs"] = { "<cmd> Telescope lsp_document_symbols <CR>", "Find symbol" },
    ["<leader>fS"] = { "<cmd> Telescope lsp_dynamic_workspace_symbols <CR>", "Find workspace Symbol" },
    ["<leader>fH"] = { "<cmd> Telescope terms <CR>", "Find Hidden term" },
    ["<leader>ft"] = { "<cmd> TodoTelescope <CR>", "Find TODO" },
    ["<leader>Q"] = { "<cmd> TodoLocList <CR>", "TODO List" },
    ["<leader>fy"] = { "<cmd> Telescope yaml_schema <CR>", "Find json schema" }, -- someone-stole-my-name/yaml-companion.nvim
    ["<leader>fq"] = { "<cmd> Telescope diagnostics <CR>", "Find diagnostics" },
  },
}

M.lspconfig = {
  plugin = true,
  n = {
    ["gI"] = {
      function()
        vim.lsp.buf.implementation()
      end,
      "LSP implementation",
    },
    ["gK"] = {
      function()
        vim.lsp.buf.signature_help()
      end,
      "LSP signature help",
    },
    ["<leader>cr"] = {
      function()
        require("nvchad.renamer").open()
      end,
      "LSP rename",
    },
    ["<leader>fd"] = { -- remap from <leader>f
      function()
        vim.diagnostic.open_float { border = "rounded" }
      end,
      "Floating diagnostic",
    },
  },
}

M.gitsigns = {
  plugin = true,

  n = {
    ["]g"] = {
      function()
        if vim.wo.diff then
          return "]g"
        end
        vim.schedule(function()
          require("gitsigns").next_hunk()
        end)
        return "<Ignore>"
      end,
      "Jump to next hunk",
      opts = { expr = true },
    },

    ["[g"] = {
      function()
        if vim.wo.diff then
          return "[g"
        end
        vim.schedule(function()
          require("gitsigns").prev_hunk()
        end)
        return "<Ignore>"
      end,
      "Jump to prev hunk",
      opts = { expr = true },
    },

    -- Actions
    ["<leader>gr"] = {
      function()
        require("gitsigns").reset_hunk()
      end,
      "Reset hunk",
    },
    ["<leader>gp"] = {
      function()
        require("gitsigns").preview_hunk()
      end,
      "Preview hunk",
    },
  },
}

M.tabufline = {
  plugin = true,

  n = {
    ---------------- Remap ----------
    ["]b"] = {
      function()
        require("nvchad.tabufline").tabuflineNext()
      end,
      "Goto next buffer",
    },

    ["[b"] = {
      function()
        require("nvchad.tabufline").tabuflinePrev()
      end,
      "Goto prev buffer",
    },

    ------------------ My -------------
    ["<leader>j"] = {
      function()
        if #vim.t.bufs >= 1 then
          vim.api.nvim_set_current_buf(vim.t.bufs[1])
        end
      end,
      "Buffer 1",
    },
    ["<leader>k"] = {
      function()
        if #vim.t.bufs >= 2 then
          vim.api.nvim_set_current_buf(vim.t.bufs[2])
        end
      end,
      "Buffer 2",
    },
    ["<leader>l"] = {
      function()
        if #vim.t.bufs >= 3 then
          vim.api.nvim_set_current_buf(vim.t.bufs[3])
        end
      end,
      "Buffer 3",
    },
    ["<leader>;"] = {
      function()
        if #vim.t.bufs >= 4 then
          vim.api.nvim_set_current_buf(vim.t.bufs[4])
        end
      end,
      "Buffer 4",
    },
    ["<leader>X"] = {
      function()
        require("nvchad.tabufline").closeOtherBufs()
      end,
      "Close other buffers",
    },

    [">b"] = {
      function()
        require("nvchad.tabufline").move_buf(1)
      end,
      "Move buffer right",
    },

    ["<b"] = {
      function()
        require("nvchad.tabufline").move_buf(-1)
      end,
      "Move buffer left",
    },
  },
}

--------------------- My -----------------------

M.ui = {
  n = {
    -- undotree
    ["<leader>ut"] = { "<cmd> UndotreeToggle <CR>", "Toggle Undotree" },
    -- spectre
    ["<leader>us"] = {
      function()
        require("spectre").open()
      end,
      "Toggle spectre (replace tool)",
    },
    -- line numbers
    ["<leader>un"] = { "<cmd> set nonumber! norelativenumber! <CR>", "Toggle line number" },
    ["<leader>ul"] = { "<cmd> Lazy <CR>", "Open Lazy" },

    -- Toggle diagnostic (linter)
    ["<leader>ud"] = {
      ":lua toggle_diagnostics() <CR>",
      "Toggle diagnostic (linter)",
    },
  },
}

M.dap = {
  plugin = true,
  n = {
    ["<leader>db"] = {
      "<cmd> DapToggleBreakpoint <CR>",
      "Add breakpoint at line",
    },
    ["<leader>dr"] = {
      "<cmd> DapContinue <CR>",
      "Start or continue the debugging",
    },
    ["<leader>dus"] = {
      function()
        local widgets = require "dap.ui.widgets"
        local sidebar = widgets.sidebar(widgets.scopes)
        sidebar.open()
      end,
      "Open debugging UI sidebar",
    },
  },
}

M.dap_go = {
  plugin = true,
  n = {
    ["<leader>dgt"] = {
      function()
        require("dap-go").debug_test()
      end,
      "Debug go test",
    },
    ["<leader>dgl"] = {
      function()
        require("dap-go").debug_last()
      end,
      "Debug last go test",
    },
  },
}

M.gopher = {
  plugin = true,
  n = {
    ["<leader>gsj"] = {
      "<cmd> GoTagAdd json <CR>",
      "Add json struct tags",
    },
    ["<leader>gsy"] = {
      "<cmd> GoTagAdd yaml <CR>",
      "Add yaml struct tags",
    },
  },
}

M.projects = {
  n = {
    -- ahmedkhalf/project.nvim
    ["<leader>fp"] = { "<cmd> Telescope projects <CR>", "Find projects" },
    ["<leader>ap"] = { "<cmd> ProjectRoot <CR>", "Add cwd to project" },
    -- my
    -- open project in tmux window
    ["<A-p>"] = { "<cmd>silent !tmux neww zsh -ic 'open-recent-project; exec zsh' <CR>", "Open project in tmux window" },
    ["<A-P>"] = {
      "<cmd>silent !tmux neww zsh -ic 'open-recent-project-session; exec zsh' <CR>",
      "Open project in tmux session",
    },
    ["<leader>at"] = {
      function()
        local dir_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")

        local Job = require "plenary.job"
        Job
          :new({
            command = "sh",
            args = {
              "-c",
              string.format(
                "wezterm cli set-tab-title --tab-id $(wezterm cli list-clients | awk '{print $NF}' | tail -1) '%s'",
                dir_name
              ),
            },
            on_exit = function(j, return_val)
              if return_val ~= 0 then
                print(j:result())
              end
            end,
          })
          :start()
      end,
      "Set cwd to terminal tab name",
    },
  },
}

-- "almo7aya/openingh.nvim"
M.openingh = {
  n = {
    ["<leader>go"] = { "<cmd> OpenInGHFileLines <CR>", "Open file in GitHub" },
  },
}

return M
