require("nap").setup({
  next_repeat = "<A-y>",
  prev_repeat = "<A-u>",
  -- disable default mapping
  exclude_default_operators = { "f", "F", "e", "L", "B", "<M-q>", "<M-l>", "<C-q>", "<C-l>", "<C-t>" },
  operators = {
    ["a"] = {
      next = { rhs = "<cmd>next<cr>", opts = { desc = "Next arglist" } },
      prev = { rhs = "<cmd>prev<cr>", opts = { desc = "Prev arglist" } },
    },
    ["A"] = {
      next = { rhs = "<cmd>last<cr>", opts = { desc = "Last arglist" } },
      prev = { rhs = "<cmd>first<cr>", opts = { desc = "First arglist" } },
    },
    ["d"] = {
      next = { rhs = vim.diagnostic.goto_next, opts = { desc = "Next diagnostic" } },
      prev = { rhs = vim.diagnostic.goto_prev, opts = { desc = "Prev diagnostic" } },
    },
    ["o"] = { -- [o (Symbol outline)
      next = { rhs = "<cmd>AerialNext<cr>", opts = { desc = "Next outline symbol" } },
      prev = { rhs = "<cmd>AerialPrev<cr>", opts = { desc = "Prev outline symbol" } },
      mode = { "n", "v", "o" },
    },
    ["Q"] = { -- remap <C-p> to Q
      next = { rhs = "<cmd>cnfile<cr>", opts = { desc = "Next quickfix item in different file" } },
      prev = { rhs = "<cmd>cpfile<cr>", opts = { desc = "Prev quickfix item in different file" } },
    },
    ["g"] = { -- [g (git hunk)
      next = {
        rhs = function()
          if vim.wo.diff then
            return "]g"
          end
          vim.schedule(function()
            require("gitsigns").next_hunk()
          end)
          return "<Ignore>"
        end,
        opts = { desc = "Next git hunk", expr = true },
      },
      prev = {
        rhs = function()
          if vim.wo.diff then
            return "[g"
          end
          vim.schedule(function()
            require("gitsigns").prev_hunk()
          end)
          return "<Ignore>"
        end,
        opts = { desc = "Prev git hunk", expr = true },
      },
    },
    ["b"] = { -- [b
      next = { rhs = "<cmd>BufferLineCycleNext<cr>", opts = { desc = "Next buffer" } },
      prev = { rhs = "<cmd>BufferLineCyclePrev<cr>", opts = { desc = "Prev buffer" } },
    },
    ["T"] = { -- [T (TODO item)
      next = {
        rhs = function()
          require("todo-comments").jump_next()
        end,
        opts = { desc = "Next TODO" },
      },
      prev = {
        rhs = function()
          require("todo-comments").jump_prev()
        end,
        opts = { desc = "Prev TODO" },
      },
    },
  },
})
