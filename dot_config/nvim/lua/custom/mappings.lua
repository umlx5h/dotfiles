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
    
    --------------------- telescope -----------------------
    ["<leader>fz"] = "",
    ["<leader>ma"] = "",
    ["<leader>pt"] = "",
    ["<leader>th"] = "", -- to <leader>ut (Nvchad themes)

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
  }
}

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

--------------------- My -----------------------

M.dap = {
  plugin = true,
  n = {
    ["<leader>db"] = {
      "<cmd> DapToggleBreakpoint <CR>",
      "Add breakpoint at line"
    },
    ["<leader>dr"] = {
      "<cmd> DapContinue <CR>",
      "Start or continue the debugging"
    },
    ["<leader>dus"] = {
      function ()
        local widgets = require('dap.ui.widgets')
        local sidebar = widgets.sidebar(widgets.scopes)
        sidebar.open()
      end,
      "Open debugging UI sidebar"
    }
  }
}

M.dap_go = {
  plugin = true,
  n = {
    ["<leader>dgt"] = {
      function()
        require('dap-go').debug_test()
      end,
      "Debug go test"
    },
    ["<leader>dgl"] = {
      function()
        require('dap-go').debug_last()
      end,
      "Debug last go test"
    }
  }
}

M.gopher = {
  plugin = true,
  n = {
    ["<leader>gsj"] = {
      "<cmd> GoTagAdd json <CR>",
      "Add json struct tags"
    },
    ["<leader>gsy"] = {
      "<cmd> GoTagAdd yaml <CR>",
      "Add yaml struct tags"
    }
  }
}

M.undotree = { 
  plugin = true,
  n = {
    ["<leader>u"] = { "<cmd> UndotreeToggle <CR>", "Toggle Undotree" },
  }
}

M.nvimtree = {
  plugin = true,
  n = {
    -- トグル時にツリーにフォーカスが移らないようにする
    ["<C-n>"] = { function()
      require("nvim-tree.api").tree.toggle(false, true)
    end, "Toggle nvimtree" },
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
    ["<leader>ft"] = { "<cmd> Telescope terms <CR>", "Find hidden term" },
    ["<leader>fp"] = { "<cmd> Telescope projects <CR>", "Find projects" }, -- ahmedkhalf/project.nvim
  }
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
  }
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

    ["<leader>td"] = {
      function()
        require("gitsigns").toggle_deleted()
      end,
      "Toggle deleted",
    },
  },
}

M.ui = {
  n = {
    -- line numbers
    ["<leader>ul"] = { "<cmd> set nu! <CR>", "Toggle line number" },
    ["<leader>ut"] = { "<cmd> Telescope themes <CR>", "Nvchad themes" },
  },
}

return M
