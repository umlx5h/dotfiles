local wezterm = require 'wezterm'

local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

------------------------------ Config --------------------------------------

-- For debug
-- config.exit_behavior = 'Hold'
config.hide_tab_bar_if_only_one_tab = true
config.color_scheme = 'Snazzy'
config.font_size = 11
-- config.font = wezterm.font 'JetBrainsMonoNL Nerd Font'
config.font = wezterm.font 'Hack Nerd Font'

config.initial_rows = 30
config.initial_cols = 115
-- config.term = 'wezterm'

config.window_close_confirmation = 'NeverPrompt'
config.audible_bell = 'Disabled'

-- config.window_decorations = 'RESIZE'

config.colors = {
  cursor_fg = '#555555', -- カーソルがあたっている文字を見やすく
  compose_cursor = '#111111', -- 日本語入力時に背景色とカーソルが同じになり見づらい問題の対策
}
config.adjust_window_size_when_changing_font_size = false -- 拡大縮小時にウィンドウサイズを維持

-- 現在無効化: 任意の修飾キーを送れるようにする設定
config.allow_win32_input_mode = false
-- config.enable_csi_u_key_encoding = true
-- config.enable_kitty_keyboard = true

-- tmuxっぽい操作
config.leader = { key = 'd', mods = 'ALT' }

------------------------------ Keybinding ------------------------------------
local act = wezterm.action
config.keys = {
  { key = 'LeftArrow', mods = 'ALT', action = act.SendString '\x1bb' }, -- word backword
  { key = 'RightArrow', mods = 'ALT', action = act.SendString '\x1bf' }, -- word forward
  { key = 'Backspace', mods = 'CTRL', action = act.SendString '\x1b\x7f' }, -- word delete (= ALT+Backspace)

  -- CSI uコードを送る、 neovimなど対応しているプログラムは Shift+Enterと認識してくれる
  -- ESC           U+000D 13 CR/Ctrl-M     Shift modifier
  -- \x1b      [              13       ;        2u
  -- 13: https://en.wikipedia.org/wiki/List_of_Unicode_characters
  -- 2u: http://www.leonerd.org.uk/hacks/fixterms/
  { key = 'Enter', mods = 'SHIFT', action = wezterm.action { SendString = '\x1b[13;2u' } },

  -- F12+Tabを送りtmuxで\x1b[105;6uを送るように設定し結果的にVim側にCTRL-Iを入力させるようにしている
  -- TABとCTRL+Iの区別がつかないためわざわざこんなことをしている
  -- '\x1b[105;6u' をそのまま書いてもtmuxに送ってくれない
  -- 現在使ってないので無効化
  -- @see: https://github.com/tmux/tmux/issues/2705#issuecomment-1518520942
  -- { key = 'i', mods = 'CTRL', action = wezterm.action { SendString = '\x1b[24~\x09' } },
  -- { key = 'i', mods = 'CTRL', action = wezterm.action { SendString = '\x1b[105;6u' } }, -- not working in tmux

  ----------------- win ------------------
  { key = 'j', mods = 'CTRL|SHIFT', action = wezterm.action { ActivateTab = 0 } },
  { key = 'k', mods = 'CTRL|SHIFT', action = wezterm.action { ActivateTab = 1 } },
  { key = 'l', mods = 'CTRL|SHIFT', action = wezterm.action { ActivateTab = 2 } },
  { key = ':', mods = 'CTRL|SHIFT', action = wezterm.action { ActivateTab = 3 } },
  { key = '{', mods = 'CTRL|SHIFT', action = act.MoveTabRelative(-1) },
  { key = '}', mods = 'CTRL|SHIFT', action = act.MoveTabRelative(1) },
  { key = 'i', mods = 'CTRL|SHIFT', action = act.ActivateLastTab },
  { key = '(', mods = 'CTRL|SHIFT', action = act.ActivateTabRelative(-1) },
  { key = ')', mods = 'CTRL|SHIFT', action = act.ActivateTabRelative(1) }, -- not working in windows!
  { key = '&', mods = 'CTRL|SHIFT', action = act.ActivateTabRelative(-1) }, -- )が動いたら消す
  { key = '*', mods = 'CTRL|SHIFT', action = act.ActivateTabRelative(1) },

  { key = 'j', mods = 'CMD|SHIFT', action = wezterm.action { ActivateTab = 0 } },
  { key = 'k', mods = 'CMD|SHIFT', action = wezterm.action { ActivateTab = 1 } },
  { key = 'l', mods = 'CMD|SHIFT', action = wezterm.action { ActivateTab = 2 } },
  { key = ':', mods = 'CMD|SHIFT', action = wezterm.action { ActivateTab = 3 } },
  { key = '{', mods = 'CMD|SHIFT', action = act.MoveTabRelative(-1) },
  { key = '}', mods = 'CMD|SHIFT', action = act.MoveTabRelative(1) },
  { key = 'i', mods = 'CMD|SHIFT', action = act.ActivateLastTab },
  { key = '(', mods = 'CMD|SHIFT', action = act.ActivateTabRelative(-1) },
  { key = ')', mods = 'CMD|SHIFT', action = act.ActivateTabRelative(1) },
  { key = '&', mods = 'CMD|SHIFT', action = act.ActivateTabRelative(-1) },
  { key = '*', mods = 'CMD|SHIFT', action = act.ActivateTabRelative(1) },

  ------------  tmuxっぽい設定, wezterm sshで使うと役に立つかも --------------------------
  -- { key = 'q', mods = 'LEADER|CTRL', action = wezterm.action { SendString = '\x11' } },
  -- prefix2回でそれ自体を送る
  { key = 'd', mods = 'LEADER|ALT', action = wezterm.action { SendString = '\x1bd' } },
  { key = '-', mods = 'LEADER', action = wezterm.action { SplitVertical = { domain = 'CurrentPaneDomain' } } },
  { key = '/', mods = 'LEADER', action = wezterm.action { SplitHorizontal = { domain = 'CurrentPaneDomain' } } },
  { key = 'z', mods = 'LEADER', action = 'TogglePaneZoomState' },
  { key = 'c', mods = 'LEADER', action = wezterm.action { SpawnTab = 'CurrentPaneDomain' } },

  { key = 'h', mods = 'LEADER', action = wezterm.action { ActivatePaneDirection = 'Left' } },
  { key = 'j', mods = 'LEADER', action = wezterm.action { ActivatePaneDirection = 'Down' } },
  { key = 'k', mods = 'LEADER', action = wezterm.action { ActivatePaneDirection = 'Up' } },
  { key = 'l', mods = 'LEADER', action = wezterm.action { ActivatePaneDirection = 'Right' } },
  -- { key = 'h', mods = 'ALT', action = wezterm.action { ActivatePaneDirection = 'Left' } },
  -- { key = 'j', mods = 'ALT', action = wezterm.action { ActivatePaneDirection = 'Down' } },
  -- { key = 'k', mods = 'ALT', action = wezterm.action { ActivatePaneDirection = 'Up' } },
  -- { key = 'l', mods = 'ALT', action = wezterm.action { ActivatePaneDirection = 'Right' } },
  -- pane resize (LEADERの場合連続して調整できない)
  { key = 'H', mods = 'LEADER|SHIFT', action = wezterm.action { AdjustPaneSize = { 'Left', 5 } } },
  { key = 'J', mods = 'LEADER|SHIFT', action = wezterm.action { AdjustPaneSize = { 'Down', 5 } } },
  { key = 'K', mods = 'LEADER|SHIFT', action = wezterm.action { AdjustPaneSize = { 'Up', 5 } } },
  { key = 'L', mods = 'LEADER|SHIFT', action = wezterm.action { AdjustPaneSize = { 'Right', 5 } } },
  -- 連続可能
  { key = 'LeftArrow', mods = 'CTRL|SHIFT', action = wezterm.action { AdjustPaneSize = { 'Left', 5 } } },
  { key = 'DownArrow', mods = 'CTRL|SHIFT', action = wezterm.action { AdjustPaneSize = { 'Down', 5 } } },
  { key = 'UpArrow', mods = 'CTRL|SHIFT', action = wezterm.action { AdjustPaneSize = { 'Up', 5 } } },
  { key = 'RightArrow', mods = 'CTRL|SHIFT', action = wezterm.action { AdjustPaneSize = { 'Right', 5 } } },

  { key = '1', mods = 'LEADER', action = wezterm.action { ActivateTab = 0 } },
  { key = '2', mods = 'LEADER', action = wezterm.action { ActivateTab = 1 } },
  { key = '3', mods = 'LEADER', action = wezterm.action { ActivateTab = 2 } },
  { key = '4', mods = 'LEADER', action = wezterm.action { ActivateTab = 3 } },
  { key = '5', mods = 'LEADER', action = wezterm.action { ActivateTab = 4 } },
  { key = '6', mods = 'LEADER', action = wezterm.action { ActivateTab = 5 } },
  { key = '7', mods = 'LEADER', action = wezterm.action { ActivateTab = 6 } },
  { key = '8', mods = 'LEADER', action = wezterm.action { ActivateTab = 7 } },
  { key = '9', mods = 'LEADER', action = wezterm.action { ActivateTab = 8 } },
  { key = 'p', mods = 'LEADER', action = act.ActivateTabRelative(-1) },
  { key = 'n', mods = 'LEADER', action = act.ActivateTabRelative(1) },

  { key = 'i', mods = 'LEADER', action = act.ActivateLastTab },
  { key = 'o', mods = 'LEADER', action = act.ActivatePaneDirection 'Next' },

  { key = '[', mods = 'LEADER', action = wezterm.action.ActivateCopyMode },

  -- Rename current focus tab
  {
    key = 'r',
    mods = 'LEADER',
    action = act.PromptInputLine {
      description = wezterm.format {
        { Attribute = { Intensity = 'Bold' } },
        { Foreground = { AnsiColor = 'Fuchsia' } },
        { Text = 'Renaming Tab Title:' },
      },
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          window:active_tab():set_title(line)
        end
      end),
    },
  },

  -- tmuxのセッションっぽい機能 微妙
  { key = 's', mods = 'LEADER', action = act.ShowLauncherArgs { flags = 'FUZZY|WORKSPACES' } },
}

-- TODO: 検索を使いやすくする
--
-- local copy_mode = nil
-- local search_mode = nil
-- if wezterm.gui then
--   copy_mode = wezterm.gui.default_key_tables().copy_mode
--   local my_copy_mode = {
--     { key = '/', mods = 'NONE', action = act.Search { CaseSensitiveString = '' } },
--     { key = 'n', mods = 'NONE', action = act.CopyMode 'NextMatch' },
--     { key = 'N', mods = 'NONE', action = act.CopyMode 'PriorMatch' },
--     {
--       key = 'Enter',
--       mods = 'NONE',
--       action = act.Multiple {
--         { CopyTo = 'ClipboardAndPrimarySelection' },
--         { CopyMode = 'Close' },
--       },
--     },
--   }
--   for _, val in ipairs(my_copy_mode) do
--     table.insert(copy_mode, val)
--   end
--
--   search_mode = wezterm.gui.default_key_tables().search_mode
--   local my_search_mode = {
--     { key = 'Enter', mods = 'NONE', action = 'ActivateCopyMode' },
--   }
--   for _, val in ipairs(my_search_mode) do
--     table.insert(search_mode, val)
--   end
-- end

-- local search_mode = nil
-- if wezterm.gui then
--   search_mode = wezterm.gui.default_key_tables().search_mode
--   -- TODO: スクロールしたかったが勝手に選択されてしまったため断念
--   -- table.insert(search_mode, { key = "u", mods = "CTRL", action = act.CopyMode({ MoveByPage = -0.5 }) })
--   -- table.insert(search_mode, { key = "d", mods = "CTRL", action = act.CopyMode({ MoveByPage = 0.5 }) })
-- end

-- config.key_tables = {
--   copy_mode = copy_mode,
--   search_mode = search_mode,
-- }

---------------------------------- WSL config --------------------------------------

-- MEMO: not working
-- local wsl_domains = wezterm.default_wsl_domains()
-- for idx, dom in ipairs(wsl_domains) do
--   dom.default_cwd = '~'
-- end

-- これを指定しないとWSLのシェル統合がうまくいかない (CWDを維持する機能がうまくいかない)
-- default_cwd は設定していないが、効果がなかったため設定しない (シェル統合を有効にしたら問題なくなった)
-- TODO: tmuxを経由すると今度はカレントディレクトリがmntになったので、tmuxでcwdを指定した
config.default_domain = 'WSL:Ubuntu-22.04'

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
  'conhost.exe',
}

return config
