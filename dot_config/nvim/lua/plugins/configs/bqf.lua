local fn = vim.fn

-- Quickfix画面を見やすくする
-- nvim-bqfプラグイン関係なしに有効な設定
-- https://github.com/kevinhwang91/nvim-bqf#customize-quickfix-window-easter-egg
-- https://github.com/BenSeefeldt/qf-format.nvim/blob/main/lua/qf-format/init.lua
function _G.qftf(info)
  local items
  local ret = {}
  if info.quickfix == 1 then
    items = fn.getqflist({ id = info.id, items = 0 }).items
  else
    items = fn.getloclist(info.winid, { id = info.id, items = 0 }).items
  end

  -- 全てのリストを走査して必要な横幅を取得する
  local name_max_size = 0
  local item_names = {}
  for i = info.start_idx, info.end_idx do
    local item_name = ""
    local e = items[i]
    if e.valid == 1 then
      if e.bufnr > 0 then
        item_name = fn.bufname(e.bufnr)
        if item_name == "" then
          item_name = "[No Name]"
        else
          item_name = item_name:gsub("^" .. vim.env.HOME, "~")
        end
      end

      if not (e.module == nil or e.module == "") then
        item_name = e.module
      end
    else
      item_name = e.text
    end

    table.insert(item_names, i, item_name)
    name_max_size = math.max(name_max_size, #item_name)
  end

  name_max_size = math.min(name_max_size, 40) -- 40 is max size of name.

  local itemFmt1 = "%-" .. name_max_size .. "s"
  local itemFmt2 = "…%." .. (name_max_size - 1) .. "s"
  for i = info.start_idx, info.end_idx do
    local item_name = item_names[i]
    local e = items[i]
    local file_name = fn.bufname(e.bufnr)
    local lnum = e.lnum > 99999 and -1 or e.lnum
    local col = e.col > 999 and -1 or e.col
    local qtype = e.type == "" and "" or " " .. e.type:sub(1, 1):upper()
    local str
    if string.find(file_name, "^fugitive:///") then -- Special formatting for fugitive logs
      local validFmt = "%s │ %s │%s %s"
      local sha, path = item_name:match("([%a%d]+):(.+)")
      if #path <= name_max_size then
        -- 一番長いパスに合わせ短いパスの場合は空白を挿入してそろえる
        -- name_max_sizeは sha1と:を含んだ8文字分多くなっているため差し引く必要がある
        local itemFmt3 = "%-" .. name_max_size - #sha - 1 .. "s"
        path = itemFmt3:format(path)
      else
        path = itemFmt2:format(path:sub(1 - name_max_size))
      end
      str = validFmt:format(sha, path, qtype, e.text)
    else
      local validFmt = "%s │%5d:%-3d│%s %s"
      if #item_name <= name_max_size then
        item_name = itemFmt1:format(item_name)
      else
        item_name = itemFmt2:format(item_name:sub(1 - name_max_size))
      end
      str = validFmt:format(item_name, lnum, col, qtype, e.text)
    end
    table.insert(ret, str)
  end
  return ret
end

vim.o.qftf = "{info -> v:lua._G.qftf(info)}"

-- plugin config
require("bqf").setup({
  -- auto_resize_height = true,
  preview = {
    win_height = 15,
    win_vheight = 15,
    auto_preview = true,
    winblend = 0,
    -- disable preview in fugitive
    should_preview_cb = function(bufnr, qwinid)
      local ret = true
      local bufname = vim.api.nvim_buf_get_name(bufnr)
      local fsize = vim.fn.getfsize(bufname)
      if fsize > 100 * 1024 then
        -- skip file size greater than 100k
        ret = false
      elseif bufname:match("^fugitive://") then
        -- skip fugitive buffer
        ret = false
      end
      return ret
    end,
  },
  filter = {
    fzf = {
      extra_opts = { "--bind", "ctrl-o:toggle-all", "--delimiter", "│" },
    },
  },
})
