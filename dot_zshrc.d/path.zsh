# Set PATH
typeset -U path PATH
path=(
	${KREW_ROOT:-$HOME/.krew}/bin
	$HOME/.local/share/mise/shims
	$HOME/.local/bin
	$HOME/bin
	$path
)
export PATH
