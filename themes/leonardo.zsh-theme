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
  # Only run inside a git repository
  git rev-parse --is-inside-work-tree &>/dev/null || return

  local porcelain numstat
  porcelain=$(git status --porcelain 2>/dev/null)

  # ── File counts ──
  local files_added=0 files_deleted=0
  if [[ -n "$porcelain" ]]; then
    files_added=$(echo "$porcelain" | grep -c -E "^(A|M|R|C|\?\?)")
    files_deleted=$(echo "$porcelain" | grep -c -E "^(D.|.D)")
  fi

  # ── Line-level diff stats (staged + unstaged, skip binaries) ──
  local lines_added=0 lines_deleted=0

  numstat=$(git diff --numstat 2>/dev/null | grep -v "^-")
  if [[ -n "$numstat" ]]; then
    lines_added=$(echo "$numstat" | awk '{s+=$1} END {print s+0}')
    lines_deleted=$(echo "$numstat" | awk '{s+=$2} END {print s+0}')
  fi

  numstat=$(git diff --cached --numstat 2>/dev/null | grep -v "^-")
  if [[ -n "$numstat" ]]; then
    lines_added=$((lines_added + $(echo "$numstat" | awk '{s+=$1} END {print s+0}')))
    lines_deleted=$((lines_deleted + $(echo "$numstat" | awk '{s+=$2} END {print s+0}')))
  fi

  # ── Build output ──
  local file_part="" line_part=""

  # Document icon: yellow 󰈙
  local doc_icon="%{$fg[yellow]%}󰈙%{$reset_color%} "
  if [[ $files_added -gt 0 || $files_deleted -gt 0 ]]; then
    file_part+="${doc_icon}"
    if [[ $files_added -gt 0 ]]; then
      file_part+="%{$fg[green]%}+${files_added}%{$reset_color%}"
    fi
    if [[ $files_added -gt 0 && $files_deleted -gt 0 ]]; then
      file_part+=" "
    fi
    if [[ $files_deleted -gt 0 ]]; then
      file_part+="%{$fg[red]%}-${files_deleted}%{$reset_color%}"
    fi
  fi

  # Lines icon: yellow ≡
  local line_icon="%{$fg[yellow]%}≡%{$reset_color%} "
  if [[ $lines_added -gt 0 || $lines_deleted -gt 0 ]]; then
    line_part+="${line_icon}"
    if [[ $lines_added -gt 0 ]]; then
      line_part+="%{$fg[green]%}+${lines_added}%{$reset_color%}"
    fi
    if [[ $lines_added -gt 0 && $lines_deleted -gt 0 ]]; then
      line_part+=" "
    fi
    if [[ $lines_deleted -gt 0 ]]; then
      line_part+="%{$fg[red]%}-${lines_deleted}%{$reset_color%}"
    fi
  fi

  local res=""
  if [[ -n "$file_part" && -n "$line_part" ]]; then
    res="${file_part} ${line_part}"
  elif [[ -n "$file_part" ]]; then
    res="$file_part"
  elif [[ -n "$line_part" ]]; then
    res="$line_part"
  fi

  [[ -n "$res" ]] && echo " ($res)"
}

PROMPT="%{$fg[cyan]%}\${OS_ICON:-} %c%{$reset_color%}"
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
