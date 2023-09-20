#!/bin/bash

set -ux

export WINUSER=$(/mnt/c/Windows/System32/cmd.exe /c echo %username% 2>/dev/null | tr -d '\r\n')
WINHOME="/mnt/c/Users/$WINUSER"

diff -u "${WINHOME}/.wezterm.lua" ~/.local/share/chezmoi/.wezterm.lua || echo
