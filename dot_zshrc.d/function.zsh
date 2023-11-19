function zsh_update_completions() {
    /bin/rm -f $HOME/.zcompdump
    /bin/rm -rf $HOME/.local/share/zsh/cmd_completions
    mkdir -p $HOME/.local/share/zsh/cmd_completions

    fish -c 'fish_update_completions'
    zsh-manpage-completion-generator -clean

    # gitでエラー出る対策
    /bin/rm -f $HOME/.local/share/zsh/generated_man_completions/_git
    /bin/rm -f $HOME/.local/share/zsh/generated_man_completions/_git-*

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
    local path=$(z | awk '{print $2}' | fzf --tac)
    [ -n "$path" ] && cd -- "$path"
}

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
    config=$(printf "%s\n" "${items[@]}" | fzf --prompt="Neovim Config > " --height=~50% --layout=reverse --border --exit-0)
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

# vimでプロジェクトを開く
function open-recent-project() {
  local dir=$(z | awk '{print $2}' | perl -pe "s|^${HOME}/|~/|" | fzf --prompt="Open project > " --tac)
  dir="${dir/#\~/$HOME}"
  if [[ -z $dir ]]; then
    zle && { zle accept-line; zle reset-prompt }
    return 0
  fi

  local project_name="$(basename "$dir")"
  if [[ "$project_name" == "nvim" ]]; then
    project_name="${project_name}_config"
  fi

  if [[ -n "$TMUX" ]]; then
    tmux rename-window "$project_name"
    # TODO: tmuxの中だとなぜかtab-idを指定しないと最初のタブが選択されてしまう
    type wezterm &>/dev/null && wezterm cli set-tab-title --pane-id "$(wezterm cli list-clients | awk '{print $NF}' | tail -1)" "$project_name"
  else
    type wezterm &>/dev/null && wezterm cli set-tab-title "$project_name"
  fi

  cd "$dir"
  z --add "$dir"
  vim .
  zle && { zle accept-line; zle reset-prompt }
}


# tmuxの新しいセッションでvimでプロジェクトを開く
# see: https://github.com/ThePrimeagen/.dotfiles/blob/master/bin/.local/scripts/tmux-sessionizer
function open-recent-project-session() {
  local dir=$(z | awk '{print $2}' | perl -pe "s|^${HOME}/|~/|" | fzf --prompt="Open project in session > " --tac)
  dir="${dir/#\~/$HOME}"
  if [[ -z $dir ]]; then
    zle && { zle accept-line; zle reset-prompt }
    return 0
  fi

  local project_name="$(basename "$dir" | tr . _)"

  if ! tmux has-session -t="$project_name" 2> /dev/null; then
    tmux new-session -ds "$project_name" -c "$dir"
    tmux send-keys -t "$project_name" 'vim .' C-m
    z --add "$dir"
  fi
  tmux switch-client -t "$project_name"
  zle && { zle accept-line; zle reset-prompt }
}

# weztermのタブでvimでプロジェクトを開く
function open-recent-project-tab() {
  local dir=$(z | awk '{print $2}' | perl -pe "s|^${HOME}/|~/|" | fzf --prompt="Open project in session > " --tac)
  dir="${dir/#\~/$HOME}"
  if [[ -z $dir ]]; then
    zle && { zle accept-line; zle reset-prompt }
    return 0
  fi

  local project_name="$(basename $dir)"

  if [[ -n "$TMUX" ]]; then
    # TODO: tmuxの中だと--pane-idを指定しないと、新しいウィンドウを開いてしまうことがある
    PANE_ID=$(wezterm cli spawn --cwd "$dir" --pane-id "$(wezterm cli list-clients | awk '{print $NF}' | tail -1)")
  else
    PANE_ID=$(wezterm cli spawn --cwd "$dir")
  fi
  echo "vim ." | wezterm cli send-text --pane-id "$PANE_ID" --no-paste
  wezterm cli set-tab-title --pane-id "$PANE_ID" "$project_name"

  zle && { zle accept-line; zle reset-prompt }
}

zle -N open-recent-project
bindkey '\e/' open-recent-project

zle -N open-recent-project-tab
bindkey '\e?' open-recent-project-tab

