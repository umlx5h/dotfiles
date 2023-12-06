require("oil").setup({
  -- TODO: trash_commandを復活させたい
  delete_to_trash = true,
  keymaps = {
    -- change
    ["<C-c>"] = false,
    ["X"] = "actions.close",
    ["<C-p>"] = false,
    ["P"] = "actions.preview",
    ["<C-h>"] = false,
    ["<C-x>"] = "actions.select_split",
    ["gs"] = false,
    ["gS"] = "actions.change_sort",

    -- add
    ["gd"] = {
      desc = "Toggle detail view",
      callback = function()
        local oil = require("oil")
        local config = require("oil.config")
        if #config.columns == 1 then
          oil.set_columns({ "icon", "permissions", "size", "mtime" })
        else
          oil.set_columns({ "icon" })
        end
      end,
    },
  },
  view_options = {
    show_hidden = true,
  },
})
