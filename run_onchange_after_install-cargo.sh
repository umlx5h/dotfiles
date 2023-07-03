#!/bin/bash

set -eux

if ! command -v cargo &> /dev/null; then
    echo "cargo could not be found" && exit
    # echo "install cargo"
    # curl https://sh.rustup.rs -sSf | sh -s -- -y --no-modify-path
    # source "$HOME/.cargo/env"
fi

cargo install bat exa fd-find ripgrep
