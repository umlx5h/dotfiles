#
# History
#

# WARNING: do not export this
HISTFILE="$HOME/.my_zsh_history"
HISTSIZE=500000
SAVEHIST=500000

# Remove older command from the history if a duplicate is to be added.
setopt HIST_IGNORE_ALL_DUPS
# Save with unixtimestamp
setopt EXTENDED_HISTORY

### Copy from zim
# Don't display duplicates when searching the history.
setopt HIST_FIND_NO_DUPS
# Don't enter immediate duplicates into the history.
setopt HIST_IGNORE_DUPS
# Remove commands from the history that begin with a space.
setopt HIST_IGNORE_SPACE
# Don't execute the command directly upon history expansion.
setopt HIST_VERIFY
# Cause all terminals to share the same history 'session'.
setopt SHARE_HISTORY



#
# Terminal
#

# Locale
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

# ctrl + s & q # # instant prompt と競合するので削除
# #stty stop undef
# #stty start undef

# Turn off all beeps
unsetopt BEEP

# sudoでPATHに入った実行コマンドを補完対象とする
zstyle ':completion:*:sudo:*' command-path $path

#
# Env
#

export EDITOR=vim
export VISUAL=vim
# manを色付きにする
# #export GROFF_NO_SGR=1

TIMEFMT=$'%J\n%U user\n%S system\n%P cpu\n%*E total'

#
# Command
#

# Color less
export LESS=-R

#
# Third party
#

# fzf
[ -f ~/.fzf.zsh  ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS='--height 80% --reverse'
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:4:hidden:wrap --bind 'ctrl-space:toggle-preview'"
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
