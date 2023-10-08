function zsh_update_completions() {
    /bin/rm -f $HOME/.zcompdump
    /bin/rm -rf $HOME/.local/share/zsh/cmd_completions
    mkdir -p $HOME/.local/share/zsh/cmd_completions

    fish -c 'fish_update_completions'
    zsh-manpage-completion-generator -clean
    generate_cmd_completions_common
    type generate_cmd_completions_work &>/dev/null && generate_cmd_completions_work

    exec zsh
}

function generate_cmd_completions_common() {
    chezmoi completion zsh > $HOME/.local/share/zsh/cmd_completions/_chezmoi
    kubectl completion zsh > $HOME/.local/share/zsh/cmd_completions/_kubectl
    helm completion zsh > $HOME/.local/share/zsh/cmd_completions/_helm
    alp completion zsh > $HOME/.local/share/zsh/cmd_completions/_alp
    register-python-argcomplete my-python-app > $HOME/.local/share/zsh/cmd_completions/_ansible
}

function fif() {
  if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi
  rg --files-with-matches --no-messages "$1" | fzf --preview "highlight -O ansi -l {} 2> /dev/null | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$1' || rg --ignore-case --pretty --context 10 '$1' {}"
}

function generatePassword() {
    read -s password && printf "%s" $password | openssl sha512 | tr -d "\n" | openssl md5
}

# ファイルの中身を表示
function show() {
  [ "$#" -ne 1 ] && { echo "Usage: show <command name>"; return 1; }
  vim -R $(which $1)
}

# z のパスをfzfで選択
function zz() {
    local path=$(z -t | tac | awk '{print $2}' | fzf)
    [ -n "$path" ] && cd -- "$path"
}

function jmp-project() {
    local path=$(find ~/projects/* -mindepth 1 -maxdepth 1 -type d | fzf)
    [ -n "$path" ] && cd -- "$path"
    zle accept-line
    zle reset-prompt
}

zle -N jmp-project

bindkey '\ep' jmp-project


# パイプからfzfを使い選択
function f() {
    local output=$(cat -)
    local select=$(echo "$output" | fzf)
    [ -n "$select" ] && print -z -- "$select"
}

# 全ての実行コマンドからfzfを使い選択
function c() {
    autoload -Uz bashcompinit && bashcompinit
    local cmd=$(compgen -c | grep -v '^_' | sort | uniq | fzf)
    [ -n "$cmd" ] && print -z -- "$cmd"
}

alias vim-astro="NVIM_APPNAME=nvim_astro nvim"
alias vim-lazy="NVIM_APPNAME=nvim_lazy nvim"
alias vim-chad="NVIM_APPNAME=nvim_nvchad nvim"
alias vim-kickstart="NVIM_APPNAME=nvim_kickstart nvim"
alias vim-tiny="NVIM_APPNAME=nvim_tiny nvim"
alias vim-default="NVIM_APPNAME=nvim_default nvim"

function vims() {
    items=("my" "default" "nvim_astro" "nvim_lazy" "nvim_kickstart" "nvim_nvchad" "nvim_tiny")
    config=$(printf "%s\n" "${items[@]}" | fzf --prompt=" Neovim Config  " --height=~50% --layout=reverse --border --exit-0)
    if [[ -z $config ]]; then
        echo "Nothing selected"
        return 0
    elif [[ $config == "my" ]]; then
        config=""
    fi
    NVIM_APPNAME=$config nvim $@
}

# vimでファイルを開く
function v() {
    local file=$(fd --type f --exclude .git -X grep -Il . | cut -c 3- | fzf)
    [ -n "$file" ] && print -z -- "vim $file"
}
