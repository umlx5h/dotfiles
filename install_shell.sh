#!/bin/bash

set -eu

cd "$HOME"

### pwndbg ###
# https://github.com/pwndbg/pwndbg
pushd pwndbg
./setup.sh
popd
