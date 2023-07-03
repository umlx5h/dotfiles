#!/bin/bash

set -eux

if ! command -v cargo &> /dev/null; then
    echo "cargo could not be found"
    exit
fi

cargo install bat exa fd-find ripgrep
