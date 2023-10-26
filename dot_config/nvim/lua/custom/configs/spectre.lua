local opts = {
  open_cmd = "noswapfile vnew",
  mapping = {
    ["toggle_no_ignore_vsc"] = {
      map = "tg",
      cmd = "<cmd>lua require('spectre').change_options('no-ignore-vcs')<CR>",
      desc = "toggle no-ignore-vcs",
    },
    ["toggle_fixed_strings"] = {
      map = "tf",
      cmd = "<cmd>lua require('spectre').change_options('fixed-strings')<CR>",
      desc = "toggle fixed-strings",
    },
    ["toggle_pcre2"] = {
      map = "tp",
      cmd = "<cmd>lua require('spectre').change_options('pcre2')<CR>",
      desc = "toggle pcre2",
    },
  },
  find_engine = {
    ["rg"] = {
      options = {
        ["hidden"] = {
          icon = "[SH]", -- Change from [H]
        },
        ["no-ignore-vcs"] = {
          value = "--no-ignore-vcs",
          desc = "Do not respect .gitignore",
          icon = "[SGI]",
        },
        ["fixed-strings"] = {
          value = "--fixed-strings",
          desc = "Literal string match",
          icon = "[F]",
        },
        ["pcre2"] = {
          value = "-P",
          desc = "PCRE2 regex engine",
          icon = "[P]",
        },
      },
    },
  },
}

return opts
