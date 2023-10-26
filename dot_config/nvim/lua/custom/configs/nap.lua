local nap = require "nap"
nap.setup {
  next_repeat = "<A-y>",
  prev_repeat = "<A-u>",
  operators = {
    ["o"] = { -- [o (Symbol outline)
      next = { rhs = "<cmd>AerialNext<cr>", opts = { desc = "Next outline symbol" } },
      prev = { rhs = "<cmd>AerialPrev<cr>", opts = { desc = "Prev outline symbol" } },
      mode = { "n", "v", "o" },
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
      next = {
        rhs = function()
          require("nvchad.tabufline").tabuflineNext()
        end,
        opts = { desc = "Next buffer" },
      },
      prev = {
        rhs = function()
          require("nvchad.tabufline").tabuflinePrev()
        end,
        opts = { desc = "Prev buffer" },
      },
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
}

-- disable default mapping
local keys = { "f", "F", "s", "e", "Q", "L", "B", "<M-q>", "<M-l>", "<C-q>", "<C-l>", "<C-t>" }
for _, k in ipairs(keys) do
  nap.map(k, false)
end
