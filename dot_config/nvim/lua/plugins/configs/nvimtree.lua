local function nvimtree_on_attach(bufnr)
  local api = require("nvim-tree.api")

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- default mappings
  api.config.mappings.default_on_attach(bufnr)

  -- custom mappings
  -- @see: https://github.com/nvim-tree/nvim-tree.lua/blob/master/doc/nvim-tree-lua.txt
  -- swap trash and delete
  vim.keymap.set("n", "d", api.fs.trash, opts("Trash"))
  vim.keymap.del("n", "D", { buffer = bufnr })

  vim.keymap.set("n", "l", api.node.open.preview_no_picker, opts("Open Preview: No Picker"))
  vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close Directory"))
  vim.keymap.set("n", "<2-LeftMouse>", api.node.open.no_window_picker, opts("Open: No Window Picker"))
end

require("nvim-tree").setup({
  on_attach = nvimtree_on_attach,
  -- respect_buf_cwd = true,

  -- oilを使う
  disable_netrw = false, -- already disabled
  hijack_netrw = false, -- oilを使用, default true
  hijack_directories = {
    enable = false, -- stop replacing netrw
  },

  hijack_cursor = true,
  sync_root_with_cwd = true,
  update_focused_file = {
    enable = true,
  },
  view = {
    preserve_window_proportions = true,
  },

  renderer = {
    root_folder_label = false,
    highlight_git = true,
    -- highlight_diagnostics = true,
    icons = {
      show = {
        git = false, -- アイコン鬱陶しいので消す
        -- diagnostics = false,
      },
    },
  },
  diagnostics = {
    enable = false,
  },
  modified = {
    enable = true,
  },

  git = {
    enable = true,
  },
  filters = {
    git_ignored = false, -- gitのignoreファイルをデフォルトで表示
  },
  trash = {
    cmd = "trash-put",
  },
})
