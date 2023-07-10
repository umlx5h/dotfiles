#!/bin/bash

set -eux

cd "$HOME"

### tpm/tmux-current-pane-hostname ###

# truncate hostname to two dot
hostname_plugin_shared_sh="$HOME/.tmux/plugins/tmux-current-pane-hostname/scripts/shared.sh"
if [ -f "$hostname_plugin_shared_sh" ]; then
    if ! grep -q "# inserted1" "$hostname_plugin_shared_sh"; then
        perl -pe '$_ .= qq(  host=\$(echo "\$host" | cut -f1-3 -d.) # inserted1\n) if /local host=/' -i "$hostname_plugin_shared_sh"
    fi
fi
