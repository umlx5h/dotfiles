#
# Function
#

function set_http_proxy() {
    export HTTP_PROXY="undefined"
    export http_proxy=$HTTP_PROXY
    export HTTPS_PROXY=$HTTP_PROXY
    export https_proxy=$HTTP_PROXY
    export NO_PROXY="undefined"
    export no_proxy=$NO_PROXY
}

function unset_http_proxy() {
    unset HTTP_PROXY
    unset http_proxy
    unset HTTPS_PROXY
    unset https_proxy
    unset NO_PROXY
    unset no_proxy
}

set_http_proxy
