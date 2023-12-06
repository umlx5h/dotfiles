vim.api.nvim_create_user_command("DiffClip", function()
  vim.cmd([[
    let ft=&ft
    leftabove vnew [Clipboard]
    setlocal bufhidden=wipe buftype=nofile noswapfile
    put +
    0d_
    " remove CR for Windows
    silent %s/\r$//e
    execute "set ft=" . ft
    diffthis
    " setlocal nomodifiable
    wincmd p
    diffthis
  ]])
end, { desc = "Compare Active File with Clipboard" })

vim.api.nvim_create_user_command("DiffOrig", function()
  vim.cmd([[
    let ft=&ft
    leftabove vnew [Original]
    setlocal bufhidden=wipe buftype=nofile noswapfile
    read ++edit #
    0d_
    execute "set ft=" . ft
		diffthis
    setlocal nomodifiable
    wincmd p
    diffthis
  ]])
end, { desc = "Compare Active File with Saved" })

vim.api.nvim_create_user_command("QFToggle", function()
  local function qf_exist()
    for _, w in ipairs(vim.fn.getwininfo()) do
      if w.quickfix == 1 then
        return true
      end
    end
    return false
  end

  if qf_exist() then
    vim.notify("cclose")
    vim.cmd.cclose()
  else
    vim.notify("copen")
    vim.cmd.copen()
  end
end, { desc = "Toggle quickfix window" })

vim.api.nvim_create_user_command("SetTermTab", function()
  local dir_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")

  local Job = require("plenary.job")
  Job:new({
    command = "sh",
    args = {
      "-c",
      string.format(
        "wezterm cli set-tab-title --pane-id $(wezterm cli list-clients | awk '{print $NF}' | tail -1) '%s'",
        dir_name
      ),
    },
    on_exit = function(j, return_val)
      if return_val ~= 0 then
        print(j:result())
      end
    end,
  }):start()
end, { desc = "Set current project name to wezterm tab name" })

vim.api.nvim_create_user_command("ShowIndentOpt", function()
  vim.cmd([[
    verbose setlocal ts? sts? sw? et?
  ]])
end, { desc = "Show current indent options" })

local toggle_diagnostics_enabled = true
vim.api.nvim_create_user_command("DiagnosticsToggle", function()
  toggle_diagnostics_enabled = not toggle_diagnostics_enabled
  if toggle_diagnostics_enabled then
    vim.api.nvim_echo({ { "Enabled diagnostics" } }, false, {})
    vim.schedule(function()
      vim.diagnostic.enable()
    end)
  else
    vim.api.nvim_echo({ { "Disabled diagnostic" } }, false, {})
    vim.schedule(function()
      vim.diagnostic.disable()
    end)
  end
end, { desc = "Toggle diagnostics" })
