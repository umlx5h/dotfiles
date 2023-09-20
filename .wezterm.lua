local wezterm = require 'wezterm'

local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

------------------------------ Config --------------------------------------

config.hide_tab_bar_if_only_one_tab = true
config.color_scheme = 'Snazzy'
config.font_size = 11
-- config.font = wezterm.font 'JetBrainsMonoNL Nerd Font Mono'
config.font = wezterm.font 'DejaVuSansM Nerd Font Mono'
config.enable_scroll_bar = true
config.window_close_confirmation = 'NeverPrompt'

------------------------------ Keybinding ------------------------------------
local act = wezterm.action
config.keys = {
  { key = 'v', mods = 'CTRL|SHIFT', action = act.SendKey { key = 'v', mods = 'CTRL' } },
  { key = 'v', mods = 'CTRL', action = act.PasteFrom 'Clipboard' }, -- Ctrl+v to pase
  { key = 'LeftArrow', mods = 'ALT', action = act.SendString '\x1bb' }, -- word backword
  { key = 'RightArrow', mods = 'ALT', action = act.SendString '\x1bf' }, -- word forward
  -- { key = 'Enter', mods = 'SHIFT', action = act.SendString '\x1bO2P' }, -- <ESC>O2P - F13
  { key = 'Enter', mods = 'SHIFT', action = act.SendKey { key = 'F13' } },

  ----------------- win ------------------
  -- vim likeにタブ移動
  { key = 'j', mods = 'CTRL|SHIFT',  action = wezterm.action({ ActivateTab = 0 }) },
  { key = 'k', mods = 'CTRL|SHIFT',  action = wezterm.action({ ActivateTab = 1 }) },
  { key = 'l', mods = 'CTRL|SHIFT',  action = wezterm.action({ ActivateTab = 2 }) },
  { key = ';', mods = 'CTRL|SHIFT',  action = wezterm.action({ ActivateTab = 3 }) },

  { key = 'j', mods = 'CMD|SHIFT',  action = wezterm.action({ ActivateTab = 0 }) },
  { key = 'k', mods = 'CMD|SHIFT',  action = wezterm.action({ ActivateTab = 1 }) },
  { key = 'l', mods = 'CMD|SHIFT',  action = wezterm.action({ ActivateTab = 2 }) },
  { key = ';', mods = 'CMD|SHIFT',  action = wezterm.action({ ActivateTab = 3 }) },
}

---------------------------------- WSL config --------------------------------------
local wsl_domains = wezterm.default_wsl_domains()
for _, dom in ipairs(wsl_domains) do
    dom.default_cwd = "~"
end
config.wsl_domains = wsl_domains
config.default_prog = { "wsl.exe" }

-- WSL経由の時にタブ閉じるようにする
-- TODO: WSL経由でtmuxを使っている場合は問題ないが、使ってない場合に確認が出ずに終了してしまう
config.skip_close_confirmation_for_processes_named = {
  'bash',
  'sh',
  'zsh',
  'fish',
  'tmux',
  'nu',
  'cmd.exe',
  'pwsh.exe',
  'powershell.exe',
  'wsl.exe',
  'wslhost.exe',
  'conhost.exe'
}

return config
