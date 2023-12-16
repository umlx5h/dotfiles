require("oil").setup({
  default_file_explorer = true, -- replace netrw

  -- TODO: trash_commandを復活させたい
  delete_to_trash = true,
  keymaps = {
    ["<2-LeftMouse>"] = "actions.select",
    -- change
    ["<C-c>"] = false,
    ["X"] = "actions.close",
    ["<C-p>"] = false,
    ["P"] = "actions.preview",
    ["<C-h>"] = false,
    ["<C-x>"] = "actions.select_split",
    ["<C-l>"] = false,
    ["R"] = "actions.refresh",
    ["gs"] = false,
    ["gS"] = "actions.change_sort",
    ["O"] = "actions.select",
    ["H"] = "actions.parent",
    ["L"] = {
      callback = function()
        local actions = require("oil.actions")
        local entry = require("oil").get_cursor_entry()
        local preview_win = require("oil.util").get_preview_win()

        if entry == nil then
          return
        end

        if entry.type == "directory" or entry.type == "link" then
          actions.select.callback()
          return
        end

        if preview_win == nil then
          actions.preview.callback()
        else
          if entry.id ~= vim.w[preview_win].oil_entry_id then
            actions.preview.callback()
            -- else
            -- actions.select.callback()
          end
        end
      end,
      desc = "select or preview",
    },
    -- ["J"] = ":normal j<CR>",
    ["J"] = {
      callback = function()
        vim.cmd.normal("j")
      end,
    },
    ["K"] = {
      callback = function()
        vim.cmd.normal("k")
      end,
    },
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
  preview = {
    update_on_cursor_moved = false,
  },
})
