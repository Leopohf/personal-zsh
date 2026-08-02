# Auto PATH migration check on zshrc load
# Ensures explicit PATH additions to ~/.zshrc are automatically moved to ~/.zshenv

_auto_migrate_path() {
  local mig_script=""

  if [[ -f "$HOME/.zsh_config/scripts/migrate_path.sh" ]]; then
    mig_script="$HOME/.zsh_config/scripts/migrate_path.sh"
  elif [[ -f "$REPO_DIR/scripts/migrate_path.sh" ]]; then
    mig_script="$REPO_DIR/scripts/migrate_path.sh"
  fi

  if [[ -n "$mig_script" && -x "$mig_script" ]]; then
    local output
    output=$(bash "$mig_script" --apply --quiet 2>/dev/null)
    if [[ -n "$output" ]]; then
      echo "$output"
      # Re-source ~/.zshenv so current shell gets updated PATH
      [[ -f "$HOME/.zshenv" ]] && source "$HOME/.zshenv"
    fi
  fi
}

_auto_migrate_path
unset -f _auto_migrate_path
