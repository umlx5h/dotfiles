# Go
export GOROOT=/usr/local/go
export GOPATH=$HOME/go

# Set PATH
typeset -U path PATH
path=(
    $HOME/.cargo/bin
    $GOPATH/bin
    $GOROOT/bin
    ${KREW_ROOT:-$HOME/.krew}/bin
    $HOME/.local/bin
    $HOME/bin
    $path
)
export PATH
