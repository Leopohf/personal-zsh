#!/bin/bash

check_brew() {
    if ! command -v brew &> /dev/null; then
        echo "🍺 Homebrew not found. Attempting to install..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        if [ "$IS_MACOS" = true ]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        else
            eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        fi
    fi
}

install_brew_deps() {
    if [ -n "$BREW_DEPS" ]; then
        echo "🍺 Checking/Installing dependencies with Homebrew..."
        check_brew
        for dep in $BREW_DEPS; do
            if ! brew list $dep &>/dev/null; then
                echo "   📥 Installing $dep..."
                brew install $dep
            else
                log_info "$dep is already installed."
            fi
        done
    fi
}

install_omz() {
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo "📦 Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    else
        log_info "Oh My Zsh is already installed."
    fi
}

install_custom_plugins() {
    echo "🔌 Cloning custom plugins..."
    local PLUGINS_DIR="$ZSH_CUSTOM/plugins"
    mkdir -p "$PLUGINS_DIR"
    declare -A CUSTOM_PLUGINS=(
        ["zsh-autosuggestions"]="https://github.com/zsh-users/zsh-autosuggestions"
        ["zsh-syntax-highlighting"]="https://github.com/zsh-users/zsh-syntax-highlighting.git"
    )
    for plugin in "${!CUSTOM_PLUGINS[@]}"; do
        if [ ! -d "$PLUGINS_DIR/$plugin" ]; then
            git clone "${CUSTOM_PLUGINS[$plugin]}" "$PLUGINS_DIR/$plugin"
        else
            log_info "$plugin already exists."
        fi
    done
}

install_sdkman() {
    if [ "$INSTALL_SDKMAN" = true ] && [ ! -d "$HOME/.sdkman" ]; then
        echo "📦 Installing SDKMAN!..."
        curl -s "https://get.sdkman.io" | bash
        sed -i 's/sdkman_auto_env=false/sdkman_auto_env=true/g' "$HOME/.sdkman/etc/config" 2>/dev/null
    elif [ "$INSTALL_SDKMAN" = true ]; then
        log_info "SDKMAN! is already installed."
    fi
}
