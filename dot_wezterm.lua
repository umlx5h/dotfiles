local wezterm = require("wezterm")

local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

------------------------------ Config --------------------------------------

config.hide_tab_bar_if_only_one_tab = true
config.color_scheme = "Snazzy"
config.font_size = 11
--config.font = wezterm.font 'JetBrainsMonoNL Nerd Font'
config.font = wezterm.font("Hack Nerd Font")

config.initial_rows = 30
config.initial_cols = 115
config.term = "wezterm"

config.window_close_confirmation = "NeverPrompt"
config.audible_bell = "Disabled"
-- config.window_decorations = "RESIZE"

config.colors = {
  compose_cursor = "#111111", -- 日本語入力時に背景色とカーソルが同じになり見づらい問題の対策
}
config.adjust_window_size_when_changing_font_size = false -- 拡大縮小時にウィンドウサイズを維持

-- 現在無効化: 任意の修飾キーを送れるようにする設定
config.allow_win32_input_mode = false
--config.enable_csi_u_key_encoding = true
--config.enable_kitty_keyboard = true

------------------------------ Keybinding ------------------------------------
local act = wezterm.action
config.keys = {
  { key = "v", mods = "CTRL|SHIFT", action = act.SendKey({ key = "v", mods = "CTRL" }) },
  { key = "v", mods = "CTRL", action = act.PasteFrom("Clipboard") }, -- Ctrl+v to pase
  { key = "LeftArrow", mods = "ALT", action = act.SendString("\x1bb") }, -- word backword
  { key = "RightArrow", mods = "ALT", action = act.SendString("\x1bf") }, -- word forward

  -- CSI uコードを送る、 neovimなど対応しているプログラムは Shift+Enterと認識してくれる
  -- ESC           U+000D 13 CR/Ctrl-M     Shift modifier
  -- \x1b      [              13       ;        2u
  -- 13: https://en.wikipedia.org/wiki/List_of_Unicode_characters
  -- 2u: http://www.leonerd.org.uk/hacks/fixterms/
  { key = "Enter", mods = "SHIFT", action = wezterm.action({ SendString = "\x1b[13;2u" }) },

  -- F12+Tabを送りtmuxで\x1b[105;6uを送るように設定し結果的にVim側にCTRL-Iを入力させるようにしている
  -- TABとCTRL+Iの区別がつかないためわざわざこんなことをしている
  -- '\x1b[105;6u' をそのまま書いてもtmuxに送ってくれない
  -- 現在使ってないので無効化
  -- @see: https://github.com/tmux/tmux/issues/2705#issuecomment-1518520942
  --{ key = 'i', mods = 'CTRL', action = wezterm.action { SendString = '\x1b[24~\x09' } },
  --{ key = 'i', mods = 'CTRL', action = wezterm.action { SendString = '\x1b[105;6u' } }, -- not working in tmux

  ----------------- win ------------------
  { key = "j", mods = "CTRL|SHIFT", action = wezterm.action({ ActivateTab = 0 }) },
  { key = "k", mods = "CTRL|SHIFT", action = wezterm.action({ ActivateTab = 1 }) },
  { key = "l", mods = "CTRL|SHIFT", action = wezterm.action({ ActivateTab = 2 }) },
  { key = ":", mods = "CTRL|SHIFT", action = wezterm.action({ ActivateTab = 3 }) },
  { key = "{", mods = "CTRL|SHIFT", action = act.MoveTabRelative(-1) },
  { key = "}", mods = "CTRL|SHIFT", action = act.MoveTabRelative(1) },
  { key = "o", mods = "CTRL|SHIFT", action = act.ActivateLastTab },

  { key = "j", mods = "CMD|SHIFT", action = wezterm.action({ ActivateTab = 0 }) },
  { key = "k", mods = "CMD|SHIFT", action = wezterm.action({ ActivateTab = 1 }) },
  { key = "l", mods = "CMD|SHIFT", action = wezterm.action({ ActivateTab = 2 }) },
  { key = ":", mods = "CMD|SHIFT", action = wezterm.action({ ActivateTab = 3 }) },
  { key = "{", mods = "CMD|SHIFT", action = act.MoveTabRelative(-1) },
  { key = "}", mods = "CMD|SHIFT", action = act.MoveTabRelative(1) },
  { key = "o", mods = "CMD|SHIFT", action = act.ActivateLastTab },
}

---------------------------------- WSL config --------------------------------------
config.default_prog = { "wsl.exe", "--cd", "~" }

-- WSL経由の時にタブ閉じるようにする
-- TODO: WSL経由でtmuxを使っている場合は問題ないが、使ってない場合に確認が出ずに終了してしまう
config.skip_close_confirmation_for_processes_named = {
  "bash",
  "sh",
  "zsh",
  "fish",
  "tmux",
  "nu",
  "cmd.exe",
  "pwsh.exe",
  "powershell.exe",
  "wsl.exe",
  "wslhost.exe",
  "conhost.exe",
}

return config
