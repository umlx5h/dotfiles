#!/bin/bash

set -eux

cd "$HOME"

### fzf ###
if [[ ! -e ".fzf.zsh" ]]; then
	./.fzf/install --all --no-update-rc
fi
