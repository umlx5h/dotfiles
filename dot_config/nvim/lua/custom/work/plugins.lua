local plugins = {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = "<C-l>",
          accept_line = "<C-_>",
        },
      },
      panel = {
        keymap = {
          open = "<A-c>",
        },
      },
    },
  },
}

return plugins
