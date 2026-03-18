# Go
export GOROOT=/usr/local/go
export GOPATH=$HOME/go

# Set PATH
typeset -U path PATH
path=(
	$HOME/.dotnet/tools
	$HOME/.cargo/bin
	$GOPATH/bin
	$GOROOT/bin
	${KREW_ROOT:-$HOME/.krew}/bin
	${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH
	$HOME/.local/bin
	$HOME/bin
	$path
)
export PATH
