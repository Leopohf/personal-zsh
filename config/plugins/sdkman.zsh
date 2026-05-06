# SDKMAN! Initialization
export SDKMAN_DIR="$HOME/.sdkman"
if [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]]; then
    source "$SDKMAN_DIR/bin/sdkman-init.sh"
fi

# Java version switching helper
# Usage: jv 21-tem or jv (to see current)
function jv() {
    if [[ -z "$1" ]]; then
        sdk current java
    else
        sdk use java "$1"
    fi
}

# Tip: Use 'sdk env init' in a project folder to create a .sdkmanrc file.
# With sdkman_auto_env=true, SDKMAN will switch Java versions automatically.
