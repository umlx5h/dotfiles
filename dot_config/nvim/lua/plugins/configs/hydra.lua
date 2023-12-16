local Hydra = require("hydra")
local dap = require("dap")

local hint = [[
 _n_: step over   _C_: Continue/Start  _B_: Breakpoint
 _s_: step into   _X_: Exit            _R_: Repl
 _O_: step out    _K_: Hover           _T_: to cursor
 ^
 ^ ^              _Q_: Quit Hydra
]]

local dap_hydra = Hydra({
  hint = hint,
  config = {
    color = "pink",
    invoke_on_body = true,
    hint = {
      position = "bottom-right",
      border = "rounded",
    },
  },
  name = "dap",
  mode = { "n" },
  body = "<leader>dh",
  heads = {
    { "n", dap.step_over, { silent = true } },
    { "s", dap.step_into, { silent = true } },
    { "O", dap.step_out, { silent = true } },
    { "T", dap.run_to_cursor, { silent = true } },
    { "C", dap.continue, { silent = true } },
    { "R", dap.repl.open, { silent = true } },
    {
      "X",
      ":lua require'dap'.disconnect({ terminateDebuggee = false })<CR>",
      {
        exit = true,
        silent = true,
      },
    },
    { "B", dap.toggle_breakpoint, { silent = true } },
    { "K", ":lua require('dap.ui.widgets').hover()<CR>", { silent = true } },
    {
      "Q",
      nil,
      {
        exit = true,
        nowait = true,
      },
    },
  },
})
Hydra.spawn = function(head)
  if head == "dap-hydra" then
    dap_hydra:activate()
  end
end
