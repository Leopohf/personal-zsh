#!/bin/bash

# Define paths
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
CONFIG_DEST="$HOME/.zsh_config"

echo "🚀 Starting Zsh configuration setup..."

# 0. OS Detection
echo "🔍 Detecting Operating System..."
case "$(uname -s)" in
    Darwin)
        OS_ICON="" # Apple icon
        ;;
    Linux)
        if grep -q "microsoft" /proc/version 2>/dev/null; then
            OS_ICON="" # Windows icon for WSL
        else
            OS_ICON="" # Generic Linux icon
        fi
        ;;
    *)
        OS_ICON="" # Default terminal icon
        ;;
esac
echo "   Detected icon: $OS_ICON"

# 1. Install Oh My Zsh if not present
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "📦 Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "✅ Oh My Zsh is already installed."
fi

# 2. Install Plugins
echo "🔌 Installing plugins..."
PLUGINS_DIR="$ZSH_CUSTOM/plugins"
mkdir -p "$PLUGINS_DIR"

# zsh-autosuggestions
if [ ! -d "$PLUGINS_DIR/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$PLUGINS_DIR/zsh-autosuggestions"
fi

# zsh-syntax-highlighting
if [ ! -d "$PLUGINS_DIR/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$PLUGINS_DIR/zsh-syntax-highlighting"
fi

# 3. Link Theme
echo "🎨 Linking theme..."
mkdir -p "$ZSH_CUSTOM/themes"
ln -sf "$REPO_DIR/themes/leonardo.zsh-theme" "$ZSH_CUSTOM/themes/leonardo.zsh-theme"

# 4. Link Modular Configs
echo "⚙️  Linking modular configurations..."
mkdir -p "$CONFIG_DEST"
for file in "$REPO_DIR/config/"*.zsh; do
    ln -sf "$file" "$CONFIG_DEST/$(basename "$file")"
done

# 5. Create OS-specific config (dynamic)
echo "💻 Generating OS-specific configuration..."
echo "export OS_ICON='$OS_ICON'" > "$CONFIG_DEST/os_icon.zsh"

# 6. Link .zshrc
echo "📝 Linking .zshrc template..."
if [ -f "$HOME/.zshrc" ]; then
    mv "$HOME/.zshrc" "$HOME/.zshrc.bak"
    echo "   (Backup created at ~/.zshrc.bak)"
fi
ln -sf "$REPO_DIR/zshrc.template" "$HOME/.zshrc"

echo "✨ Setup complete! Please restart your terminal or run 'source ~/.zshrc'."
