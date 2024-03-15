# aliasが使えるようにする
alias watch="watch "
alias la="ll"
# sudoでもaliasを使う
alias sudo='sudo '
# OSのデフォルトシェルがbashでも、zshからtmuxを起動したらzshを起動する
alias tmux='SHELL=$(which zsh) tmux'

#
# Third party
#

alias cz="chezmoi"
alias k="kubectl"
alias kc="kubectx"
alias kn="kubens"
alias vim="nvim"
alias wssh="wezterm ssh"
alias G="nvim -c 'vert Git' ."

#
# Neovim
#
if [ -n "$NVIM" ]; then
	# Open file in curent neovim
	if type nvr &>/dev/null; then
		alias nvim='nvr -l'
		alias vim='nvr -l'
	else
		alias nvim='echo "No nesting!"'
		alias vim='echo "No nesting!"'
	fi
fi
