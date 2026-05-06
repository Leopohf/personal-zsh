# Customization of robbyrussell theme with Git and Node icons
# Based on the original robbyrussell theme

function node_prompt_info() {
  # Show node version if in a node project
  if [[ -f package.json || -d node_modules || -f .nvmrc || -f .node-version ]]; then
    local node_ver=$(node -v 2>/dev/null)
    if [[ -n "$node_ver" ]]; then
      echo " %{$fg[green]%}󰎙 ${node_ver#v}%{$reset_color%}"
    fi
  fi
}

function git_status_counts() {
  local counts
  counts=$(git status --porcelain 2> /dev/null)
  if [[ -n "$counts" ]]; then
    local added=$(echo "$counts" | grep -c -E "^(A|M|R|C|\?\?)")
    local deleted=$(echo "$counts" | grep -c "D")
    
    local res=""
    [[ $added -gt 0 ]] && res+="%{$fg[green]%}+$added%{$reset_color%}"
    [[ $added -gt 0 && $deleted -gt 0 ]] && res+=" "
    [[ $deleted -gt 0 ]] && res+="%{$fg[red]%}-$deleted%{$reset_color%}"
    
    [[ -n "$res" ]] && echo " ($res)"
  fi
}

PROMPT="%{$fg[cyan]%}${OS_ICON:-} %c%{$reset_color%}"
PROMPT+=' $(git_prompt_info)$(git_status_counts)'
PROMPT+='$(node_prompt_info)'
PROMPT+=$'\n'
PROMPT+="%(?:%{$fg[green]%}%1{➜%} :%{$fg[red]%}%1{➜%} )"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:( %{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}%1{✗%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"

# zsh-syntax-highlighting colors:
# - default typed text in soft white
# - valid command in soft green
# - invalid command in soft red
# - All states use 'none' attribute to ensure uniform font thickness
typeset -gA ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[default]='none,fg=252'
ZSH_HIGHLIGHT_STYLES[command]='none,fg=114'
ZSH_HIGHLIGHT_STYLES[path]='none,fg=114'
ZSH_HIGHLIGHT_STYLES[path_prefix]='none,fg=252'
ZSH_HIGHLIGHT_STYLES[path_pathseparator]='none,fg=252'
ZSH_HIGHLIGHT_STYLES[alias]='none,fg=114'
ZSH_HIGHLIGHT_STYLES[builtin]='none,fg=114'
ZSH_HIGHLIGHT_STYLES[function]='none,fg=114'
ZSH_HIGHLIGHT_STYLES[hashed-command]='none,fg=114'
ZSH_HIGHLIGHT_STYLES[precommand]='none,fg=114'
ZSH_HIGHLIGHT_STYLES[commandseparator]='none,fg=252'
ZSH_HIGHLIGHT_STYLES[unknown-token]='none,fg=210'
