# Go
export GOROOT=/usr/local/go
export GOPATH=$HOME/go

# Node
export VOLTA_HOME="$HOME/.volta"

# Set PATH
typeset -U path PATH
path=(
    $HOME/.cargo/bin
    $GOPATH/bin
    $GOROOT/bin
    $VOLTA_HOME/bin
    ${KREW_ROOT:-$HOME/.krew}/bin
    $HOME/.local/bin
    $HOME/bin
    $path
)
export PATH
