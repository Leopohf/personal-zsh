# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# LS
if [ "$IS_MACOS" = true ]; then
  alias ls="ls -G"
else
  alias ls="ls --color=auto"
  alias open="xdg-open"
fi
alias ll="ls -lah"
alias la="ls -A"
alias l="ls -CF"

# Git
alias gst="git status"
alias ga="git add"
alias gc="git commit -m"
alias gp="git push"
alias gl="git pull"

# Misc
alias zshconfig="nvim ~/.zshrc"
alias reload="source ~/.zshrc"
