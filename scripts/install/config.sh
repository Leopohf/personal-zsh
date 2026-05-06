#!/bin/bash

copy_theme() {
    echo "🎨 Copying theme..."
    mkdir -p "$ZSH_CUSTOM/themes"
    cp "$REPO_DIR/themes/leonardo.zsh-theme" "$ZSH_CUSTOM/themes/leonardo.zsh-theme"
}

copy_modular_configs() {
    echo "⚙️  Copying selected configurations..."
    rm -rf "$CONFIG_DEST"
    mkdir -p "$CONFIG_DEST"
    for file_name in $SELECTED_CONFIG_FILES; do
        if [ -f "$REPO_DIR/config/core/$file_name" ]; then
            cp "$REPO_DIR/config/core/$file_name" "$CONFIG_DEST/"
        elif [ -f "$REPO_DIR/config/plugins/$file_name" ]; then
            cp "$REPO_DIR/config/plugins/$file_name" "$CONFIG_DEST/"
        fi
    done
}

generate_zshrc() {
    echo "📝 Generating .zshrc..."
    if [ -f "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ]; then
        mv "$HOME/.zshrc" "$HOME/.zshrc.bak"
    fi
    cp "$REPO_DIR/zshrc.template" "$HOME/.zshrc"

    local PLUGIN_LIST=$(echo $SELECTED_OMZ_PLUGINS | xargs)
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "s/_DYNAMIC_PLUGINS_/$PLUGIN_LIST/g" "$HOME/.zshrc"
    else
        sed -i "s/_DYNAMIC_PLUGINS_/$PLUGIN_LIST/g" "$HOME/.zshrc"
    fi
}

install_fonts() {
    echo "🔡 Installing fonts..."
    local FONT_ZIP="$REPO_DIR/icons-font/NerdFontsSymbolsOnly.zip"
    if [ -f "$FONT_ZIP" ]; then
        local TEMP_FONT_DIR=$(mktemp -d)
        unzip -q "$FONT_ZIP" -d "$TEMP_FONT_DIR"
        if [ "$IS_MACOS" = true ]; then
            mkdir -p "$HOME/Library/Fonts"
            cp "$TEMP_FONT_DIR"/*.ttf "$HOME/Library/Fonts/"
        else
            mkdir -p "$HOME/.local/share/fonts"
            cp "$TEMP_FONT_DIR"/*.ttf "$HOME/.local/share/fonts/"
            fc-cache -f "$HOME/.local/share/fonts"
        fi
        rm -rf "$TEMP_FONT_DIR"
    fi
}
