local M = {}

-- In order to disable a default keymap, use
M.disabled = {
  t = {
      -- Toggle horizontal term 
      ["<A-h>"] = "",
  },
  n = {
      -- telescope
      ["<leader>fz"] = "",
      ["<leader>pt"] = "",

      -- nvterm
      ["<A-h>"] = "",
      ["<leader>h"] = "",
      ["<leader>v"] = "",
      -- ["<leader>pt"] = "",

      -- LSP
      ["gi"] = "",
      ["<leader>ls"] = ""
  }
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
        local widgets = require('dap.ui.widgets');
        local sidebar = widgets.sidebar(widgets.scopes);
        sidebar.open();
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
  n = {
    ["<leader>u"] = { "<cmd> UndotreeToggle <CR>", "Toggle Undotree" },
  }
}

M.nvimtree = {
  n = {
    -- トグル時にツリーにフォーカスが移らないようにする
    ["<C-n>"] = { function()
      require("nvim-tree.api").tree.toggle(false, true)
    end, "Toggle nvimtree" },
  },
}

M.telescope = {
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
  }
}

M.lspconfig = {
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
  }
}


return M
