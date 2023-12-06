require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "vim",
    "vimdoc",
    "lua",
    "html",
    "css",
    "javascript",
    "typescript",
    "tsx",
    "c",
    "cpp",
    "markdown",
    "markdown_inline",
    "dockerfile",

    "make",
    "gitignore",
    "bash",
    "go",
    "gomod",
    "gosum",
    "gowork",

    "yaml",
    "json",
    "json5",
    "jsonc",

    "python",

    "php",
    "phpdoc",

    "toml",
    "tsv",
    "csv",
    "hcl",
    "ruby",
  },
  highlight = { enable = true },
  indent = {
    enable = true,
    disable = {
      "c", -- Cでswitchのcaseの部分などで勝手にインデントを変えられてしまうため無効にする
      "cpp",
    },
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<c-space>",
      node_incremental = "<c-space>",
      scope_incremental = false,
      node_decremental = "<bs>",
    },
  },
})
