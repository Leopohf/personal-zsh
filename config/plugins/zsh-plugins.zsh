# Zsh Plugin Configurations

# zsh-autosuggestions
# Set suggestion color (244 is a grey)
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'
# Strategy: history first, then completion
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# sudo (Press ESC ESC to prepend sudo)
sudo-command-line() {
    [[ -z $BUFFER ]] && LBUFFER+="$(fc -ln -1)"
    if [[ $BUFFER == sudo\ * ]]; then
        LBUFFER="${LBUFFER#sudo }"
    else
        LBUFFER="sudo $LBUFFER"
    fi
}
zle -N sudo-command-line
bindkey -M vicmd ' ' sudo-command-line
bindkey -M viins ' ' sudo-command-line
bindkey '\e\e' sudo-command-line

# fzf integration (if installed)
if command -v fzf &> /dev/null; then
  # Source fzf keybindings and completion if they exist in standard locations
  [ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh
  [ -f /usr/share/doc/fzf/examples/completion.zsh ] && source /usr/share/doc/fzf/examples/completion.zsh
  # macOS (Homebrew)
  if [ "$IS_MACOS" = true ]; then
    [ -f "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh" ] && source "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh"
    [ -f "$(brew --prefix)/opt/fzf/shell/completion.zsh" ] && source "$(brew --prefix)/opt/fzf/shell/completion.zsh"
  fi
fi

# zsh-syntax-highlighting
# ...
