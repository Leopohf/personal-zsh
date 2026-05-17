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
                if brew install $dep; then
                    SUMMARY_SUCCESS+=("Brew: $dep")
                else
                    SUMMARY_FAILED+=("Brew: $dep (installation failed)")
                fi
            else
                log_info "$dep is already installed."
                SUMMARY_SUCCESS+=("Brew: $dep (already installed)")
            fi
        done
    fi
}

install_omz() {
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo "📦 Installing Oh My Zsh..."
        if sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended; then
            SUMMARY_SUCCESS+=("Oh My Zsh")
        else
            SUMMARY_FAILED+=("Oh My Zsh (installation failed)")
        fi
    else
        log_info "Oh My Zsh is already installed."
        SUMMARY_SUCCESS+=("Oh My Zsh (already installed)")
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
            if git clone "${CUSTOM_PLUGINS[$plugin]}" "$PLUGINS_DIR/$plugin"; then
                SUMMARY_SUCCESS+=("Zsh Plugin: $plugin")
            else
                SUMMARY_FAILED+=("Zsh Plugin: $plugin (git clone failed)")
            fi
        else
            log_info "$plugin already exists."
            SUMMARY_SUCCESS+=("Zsh Plugin: $plugin (already exists)")
        fi
    done
}

install_sdkman() {
    if [ "$INSTALL_SDKMAN" = true ] && [ ! -d "$HOME/.sdkman" ]; then
        echo "📦 Installing SDKMAN!..."
        if curl -s "https://get.sdkman.io" | bash; then
            sed -i 's/sdkman_auto_env=false/sdkman_auto_env=true/g' "$HOME/.sdkman/etc/config" 2>/dev/null
            SUMMARY_SUCCESS+=("SDKMAN!")
        else
            SUMMARY_FAILED+=("SDKMAN! (installation failed)")
        fi
    elif [ "$INSTALL_SDKMAN" = true ]; then
        log_info "SDKMAN! is already installed."
        SUMMARY_SUCCESS+=("SDKMAN! (already installed)")
    fi
}

install_bun() {
    if [[ "$ENABLE_BUN" == "true" ]] && ! command -v bun &> /dev/null; then
        echo "📦 Installing Bun..."
        if curl -fsSL https://bun.sh/install | bash; then
            SUMMARY_SUCCESS+=("Bun")
        else
            SUMMARY_FAILED+=("Bun (installation failed)")
        fi
    elif [[ "$ENABLE_BUN" == "true" ]]; then
        log_info "Bun is already installed."
        SUMMARY_SUCCESS+=("Bun (already installed)")
    fi
}

install_angular() {
    if [ "$INSTALL_ANGULAR" = true ]; then
        echo "📦 Installing Angular CLI globally via pnpm..."
        if ! command -v pnpm &> /dev/null; then
            echo "   ❌ pnpm is not available yet, cannot install Angular CLI."
            SUMMARY_FAILED+=("Angular CLI (pnpm not found)")
            return
        fi
        if pnpm add -g @angular/cli; then
            SUMMARY_SUCCESS+=("Angular CLI")
        else
            SUMMARY_FAILED+=("Angular CLI (installation failed)")
        fi
    fi
}
