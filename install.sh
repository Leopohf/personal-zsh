#!/bin/bash

# Define paths
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
CONFIG_DEST="$HOME/.zsh_config"

echo "🚀 Starting Zsh configuration setup..."

# 0. OS Detection (Shared logic)
echo "🔍 Detecting Operating System..."
source "$REPO_DIR/config/00-os.zsh"
echo "   Detected icon: $OS_ICON"

# 1. Install Oh My Zsh if not present
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "📦 Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "✅ Oh My Zsh is already installed."
fi

# 2. Install Plugins
echo "🔌 Installing custom plugins..."
PLUGINS_DIR="$ZSH_CUSTOM/plugins"
mkdir -p "$PLUGINS_DIR"

# List of custom plugins to clone
declare -A CUSTOM_PLUGINS=(
    ["zsh-autosuggestions"]="https://github.com/zsh-users/zsh-autosuggestions"
    ["zsh-syntax-highlighting"]="https://github.com/zsh-users/zsh-syntax-highlighting.git"
)

for plugin in "${!CUSTOM_PLUGINS[@]}"; do
    if [ ! -d "$PLUGINS_DIR/$plugin" ]; then
        echo "   📥 Cloning $plugin..."
        git clone "${CUSTOM_PLUGINS[$plugin]}" "$PLUGINS_DIR/$plugin"
    else
        echo "   ✅ $plugin already installed."
    fi
done

# 3. Check for Required Tools (from plugins list)
echo "🛠️  Checking for required tools..."
TOOLS=("gh" "fnm" "docker" "mvn" "aws" "az" "go" "ng" "bun" "pnpm" "unzip" "fzf")
for tool in "${TOOLS[@]}"; do
    if ! command -v "$tool" &> /dev/null; then
        echo "   ⚠️  Warning: '$tool' is not installed. Some plugins or configs may not work correctly."
    else
        echo "   ✅ '$tool' is installed."
    fi
done

# 4. Install SDKMAN! if not present
if [ ! -d "$HOME/.sdkman" ]; then
    echo "📦 Installing SDKMAN!..."
    curl -s "https://get.sdkman.io" | bash
else
    echo "✅ SDKMAN! is already installed."
fi

# Configure SDKMAN!
if [ -d "$HOME/.sdkman" ]; then
    echo "⚙️  Configuring SDKMAN! (auto_env)..."
    # Ensure sdkman_auto_env=true
    if [ -f "$HOME/.sdkman/etc/config" ]; then
        sed -i 's/sdkman_auto_env=false/sdkman_auto_env=true/g' "$HOME/.sdkman/etc/config"
    fi
fi

# 5. Copy Theme
echo "🎨 Copying theme..."
mkdir -p "$ZSH_CUSTOM/themes"
cp "$REPO_DIR/themes/leonardo.zsh-theme" "$ZSH_CUSTOM/themes/leonardo.zsh-theme"

# 6. Copy Modular Configs
echo "⚙️  Copying modular configurations..."
mkdir -p "$CONFIG_DEST"
for file in "$REPO_DIR/config/core/"*.zsh "$REPO_DIR/config/plugins/"*.zsh; do
    [ -f "$file" ] && cp "$file" "$CONFIG_DEST/$(basename "$file")"
done

# 7. Copy .zshrc
echo "📝 Copying .zshrc template..."
if [ -f "$HOME/.zshrc" ]; then
    mv "$HOME/.zshrc" "$HOME/.zshrc.bak"
    echo "   (Backup created at ~/.zshrc.bak)"
fi
cp "$REPO_DIR/zshrc.template" "$HOME/.zshrc"

# 9. Install Nerd Font Symbols
echo "🔡 Installing Nerd Font Symbols..."
FONT_ZIP="$REPO_DIR/icons-font/NerdFontsSymbolsOnly.zip"
TEMP_FONT_DIR=$(mktemp -d)

if [ -f "$FONT_ZIP" ]; then
    unzip -q "$FONT_ZIP" -d "$TEMP_FONT_DIR"
    
    if [ "$IS_MACOS" = true ]; then
        FONT_DEST="$HOME/Library/Fonts"
        mkdir -p "$FONT_DEST"
        cp "$TEMP_FONT_DIR"/*.ttf "$FONT_DEST/"
        echo "   ✅ Fonts installed to $FONT_DEST"
    elif [ "$IS_LINUX" = true ]; then
        FONT_DEST="$HOME/.local/share/fonts"
        mkdir -p "$FONT_DEST"
        cp "$TEMP_FONT_DIR"/*.ttf "$FONT_DEST/"
        fc-cache -f "$FONT_DEST"
        echo "   ✅ Fonts installed to $FONT_DEST and cache updated."
    else
        echo "   ⚠️  Manual font installation required for this OS."
    fi
    rm -rf "$TEMP_FONT_DIR"
else
    echo "   ❌ Font zip file not found at $FONT_ZIP"
fi

echo "✨ Setup complete! Please restart your terminal or run 'source ~/.zshrc'."
