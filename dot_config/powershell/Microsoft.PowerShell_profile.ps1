# To use this config, you must install modules by below command
# Install-Module PSReadLine, PSFzf, ZLocation, git-completion -Scope CurrentUser -Force

# ----- PSReadLine -----

# To use Emacs key bindings
Set-PSReadLineOption -EditMode Emacs

# for a better history experience
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineKeyhandler -Chord "Ctrl+p" -Function HistorySearchBackward
Set-PSReadLineKeyhandler -Chord "Ctrl+n" -Function HistorySearchForward

# when cursor up and down, move cursor to end
Set-PSReadLineOption -HistorySearchCursorMovesToEnd

# Set command history to max
Set-PSReadLineOption -MaximumHistoryCount 32767

# Set prediction color darker
Set-PSReadLineOption -Colors @{ InlinePrediction = '#808080' }

# ----- PSFzf -----

Remove-PSReadlineKeyHandler 'Ctrl+r'
Remove-PSReadlineKeyHandler 'Ctrl+t'
Remove-PSReadlineKeyHandler 'Alt+c'
# reverse direction
$env:FZF_DEFAULT_OPTS='--height 80% --reverse'
# ctrl+space to preview
$env:FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:4:hidden:wrap --bind 'ctrl-space:toggle-preview'"

# ----- Alias -----

Set-Alias open Invoke-Item
Set-Alias pbcopy gocopy
Set-Alias pbpaste gopaste

if ($IsWindows) {
    Set-Alias tm trash
} else {
    Set-Alias tm gtrash
}

# ----- Modules before -----

Import-Module PSFzf
Import-Module git-completion

# ----- Prompt Framework -----

oh-my-posh init pwsh --config ~/.config/oh-my-posh/themes/probua.minimal.omp.json | Invoke-Expression

# ----- Modules after -----

Import-Module ZLocation
