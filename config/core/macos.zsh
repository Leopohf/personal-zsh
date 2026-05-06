# macOS Specific Configurations
if [ "$IS_MACOS" = true ]; then
  # Aliases
  alias pfd='printf "%s\n" "$(posix-file-dirname)"'
  alias pfs='printf "%s\n" "$(posix-file-source)"'
  alias cdf='cd "$(posix-file-source)"'
  
  # Functions for interacting with Finder
  function posix-file-source() {
    osascript -e 'tell application "Finder" to if (count of selection) > 0 then get POSIX path of (selection as alias) else get POSIX path of (insertion location as alias)'
  }

  function posix-file-dirname() {
    local item_path
    item_path=$(posix-file-source)
    if [[ -d "$item_path" ]]; then
      echo "$item_path"
    else
      dirname "$item_path"
    fi
  }

  # Open with Quick Look
  alias ql='qlmanage -p "$@" >& /dev/null'

  # Open man page in Preview
  function manp() {
    man -t "$@" | open -f -a Preview
  }
fi
