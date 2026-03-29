# aliasが使えるようにする
alias watch="watch "
alias la="ll"
# sudoでもalias展開する
alias sudo='\sudo '
# PATH維持 & alias展開
alias sudop='\sudo --preserve-env=PATH env '
# 環境変数維持 & alias展開
alias sudoe='\sudo -E --preserve-env=PATH env '
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
alias g="git"

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
