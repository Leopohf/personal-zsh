#!/bin/bash

# Define paths
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
CONFIG_DEST="$HOME/.zsh_config"
PLUGINS_CONF="$REPO_DIR/.zsh_plugins.env"

echo "🚀 Starting Zsh configuration setup..."

# 0. OS Detection
source "$REPO_DIR/config/core/00-os.zsh"
echo "🔍 Detected OS: $OS_ICON"

# 1. Load or Ask for Preferences
if [ -f "$PLUGINS_CONF" ]; then
    echo "📄 Loading preferences from $PLUGINS_CONF"
    source "$PLUGINS_CONF"
else
    echo "interactive" > "$PLUGINS_CONF.tmp"
fi

confirm_feature() {
    local var_name="ENABLE_$1"
    local description="$2"
    
    if [[ "${!var_name}" == "true" ]]; then
        return 0
    elif [[ "${!var_name}" == "false" ]]; then
        return 1
    fi

    # If not defined, ask interactively
    read -p "❓ Install $description? [Y/n]: " choice
    case "$choice" in 
      [nN][oO]|[nN])
        echo "$var_name=false" >> "$PLUGINS_CONF"
        export "$var_name=false"
        return 1
        ;;
      *)
        echo "$var_name=true" >> "$PLUGINS_CONF"
        export "$var_name=true"
        return 0
        ;;
    esac
}

# 2. Define Features and Ask
SELECTED_OMZ_PLUGINS="history"
SELECTED_CONFIG_FILES="00-os.zsh brew.zsh aliases.zsh exports.zsh history.zsh zsh-plugins.zsh"
BREW_DEPS=""
[ "$IS_LINUX" = true ] && BREW_DEPS="unzip"

check_brew() {
    if ! command -v brew &> /dev/null; then
        echo "🍺 Homebrew not found. Attempting to install..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        # Add brew to path for the current session
        if [ "$IS_MACOS" = true ]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        else
            eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        fi
    fi
}

# Core OMZ Plugins (Optional but recommended)
if confirm_feature "AUTOSUGGEST" "Zsh Autosuggestions"; then
    SELECTED_OMZ_PLUGINS="$SELECTED_OMZ_PLUGINS zsh-autosuggestions"
fi

if confirm_feature "HIGHLIGHT" "Zsh Syntax Highlighting"; then
    SELECTED_OMZ_PLUGINS="$SELECTED_OMZ_PLUGINS zsh-syntax-highlighting"
fi

# Tools
if confirm_feature "GIT" "Git"; then
    SELECTED_OMZ_PLUGINS="$SELECTED_OMZ_PLUGINS git"
    SELECTED_CONFIG_FILES="$SELECTED_CONFIG_FILES git.zsh"
fi

if confirm_feature "GH" "GitHub CLI (gh)"; then
    SELECTED_OMZ_PLUGINS="$SELECTED_OMZ_PLUGINS gh"
    BREW_DEPS="$BREW_DEPS gh"
fi

if confirm_feature "FNM" "Node Manager (fnm)"; then
    SELECTED_OMZ_PLUGINS="$SELECTED_OMZ_PLUGINS fnm"
    SELECTED_CONFIG_FILES="$SELECTED_CONFIG_FILES fnm.zsh"
    BREW_DEPS="$BREW_DEPS fnm"
fi

if confirm_feature "PNPM" "Package Manager (pnpm)"; then
    SELECTED_CONFIG_FILES="$SELECTED_CONFIG_FILES pnpm.zsh"
    BREW_DEPS="$BREW_DEPS pnpm"
fi

if confirm_feature "BUN" "Bun Runtime"; then
    SELECTED_CONFIG_FILES="$SELECTED_CONFIG_FILES bun.zsh"
    BREW_DEPS="$BREW_DEPS bun"
fi

if confirm_feature "DOCKER" "Docker"; then
    SELECTED_OMZ_PLUGINS="$SELECTED_OMZ_PLUGINS docker"
    SELECTED_CONFIG_FILES="$SELECTED_CONFIG_FILES docker.zsh"
    BREW_DEPS="$BREW_DEPS docker"
fi

if confirm_feature "SDKMAN" "Java Manager (SDKMAN!)"; then
    SELECTED_OMZ_PLUGINS="$SELECTED_OMZ_PLUGINS sdk"
    SELECTED_CONFIG_FILES="$SELECTED_CONFIG_FILES sdkman.zsh"
    INSTALL_SDKMAN=true
fi

if confirm_feature "MAVEN" "Maven (mvn)"; then
    SELECTED_OMZ_PLUGINS="$SELECTED_OMZ_PLUGINS mvn"
fi

if confirm_feature "AWS" "AWS CLI"; then
    SELECTED_OMZ_PLUGINS="$SELECTED_OMZ_PLUGINS aws"
    SELECTED_CONFIG_FILES="$SELECTED_CONFIG_FILES aws.zsh"
    BREW_DEPS="$BREW_DEPS awscli"
fi

if confirm_feature "AZURE" "Azure CLI"; then
    SELECTED_OMZ_PLUGINS="$SELECTED_OMZ_PLUGINS azure"
    SELECTED_CONFIG_FILES="$SELECTED_CONFIG_FILES azure.zsh"
    BREW_DEPS="$BREW_DEPS azure-cli"
fi

if confirm_feature "NG" "Angular CLI (ng)"; then
    SELECTED_OMZ_PLUGINS="$SELECTED_OMZ_PLUGINS ng"
    SELECTED_CONFIG_FILES="$SELECTED_CONFIG_FILES ng.zsh"
fi

if confirm_feature "GOLANG" "Go Language"; then
    SELECTED_OMZ_PLUGINS="$SELECTED_OMZ_PLUGINS golang"
    BREW_DEPS="$BREW_DEPS go"
fi

if confirm_feature "FZF" "Fzf (Fuzzy Finder)"; then
    BREW_DEPS="$BREW_DEPS fzf"
fi

if confirm_feature "EXTRACT" "Extract Utility"; then
    SELECTED_OMZ_PLUGINS="$SELECTED_OMZ_PLUGINS extract"
    SELECTED_CONFIG_FILES="$SELECTED_CONFIG_FILES extract.zsh"
fi

if confirm_feature "WD" "Warp Directory (wd)"; then
    SELECTED_OMZ_PLUGINS="$SELECTED_OMZ_PLUGINS wd"
    SELECTED_CONFIG_FILES="$SELECTED_CONFIG_FILES wd.zsh"
fi

# Clean up tmp file
[ -f "$PLUGINS_CONF.tmp" ] && rm "$PLUGINS_CONF.tmp"

# 3. Brew Installation
if [ -n "$BREW_DEPS" ]; then
    echo "🍺 Checking/Installing dependencies with Homebrew..."
    check_brew
    for dep in $BREW_DEPS; do
        if ! brew list $dep &>/dev/null; then
            echo "   📥 Installing $dep..."
            brew install $dep
        else
            echo "   ✅ $dep is already installed."
        fi
    done
fi

# 4. Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "📦 Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# 5. Custom Plugins Cloning
echo "🔌 Cloning custom plugins..."
PLUGINS_DIR="$ZSH_CUSTOM/plugins"
mkdir -p "$PLUGINS_DIR"
declare -A CUSTOM_PLUGINS=(
    ["zsh-autosuggestions"]="https://github.com/zsh-users/zsh-autosuggestions"
    ["zsh-syntax-highlighting"]="https://github.com/zsh-users/zsh-syntax-highlighting.git"
)
for plugin in "${!CUSTOM_PLUGINS[@]}"; do
    if [ ! -d "$PLUGINS_DIR/$plugin" ]; then
        git clone "${CUSTOM_PLUGINS[$plugin]}" "$PLUGINS_DIR/$plugin"
    fi
done

# 6. SDKMAN! Installation
if [ "$INSTALL_SDKMAN" = true ] && [ ! -d "$HOME/.sdkman" ]; then
    echo "📦 Installing SDKMAN!..."
    curl -s "https://get.sdkman.io" | bash
    # Configure auto_env
    sed -i 's/sdkman_auto_env=false/sdkman_auto_env=true/g' "$HOME/.sdkman/etc/config" 2>/dev/null
fi

# 7. Copy Theme
echo "🎨 Copying theme..."
mkdir -p "$ZSH_CUSTOM/themes"
cp "$REPO_DIR/themes/leonardo.zsh-theme" "$ZSH_CUSTOM/themes/leonardo.zsh-theme"

# 8. Copy Modular Configs (Selective)
echo "⚙️  Copying selected configurations..."
rm -rf "$CONFIG_DEST"
mkdir -p "$CONFIG_DEST"
for file_name in $SELECTED_CONFIG_FILES; do
    # Search in core or plugins
    if [ -f "$REPO_DIR/config/core/$file_name" ]; then
        cp "$REPO_DIR/config/core/$file_name" "$CONFIG_DEST/"
    elif [ -f "$REPO_DIR/config/plugins/$file_name" ]; then
        cp "$REPO_DIR/config/plugins/$file_name" "$CONFIG_DEST/"
    fi
done

# 9. Generate .zshrc
echo "📝 Generating .zshrc..."
if [ -f "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ]; then
    mv "$HOME/.zshrc" "$HOME/.zshrc.bak"
fi
cp "$REPO_DIR/zshrc.template" "$HOME/.zshrc"

# Inject plugins into .zshrc
PLUGIN_LIST=$(echo $SELECTED_OMZ_PLUGINS | xargs)
if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' "s/_DYNAMIC_PLUGINS_/$PLUGIN_LIST/g" "$HOME/.zshrc"
else
    sed -i "s/_DYNAMIC_PLUGINS_/$PLUGIN_LIST/g" "$HOME/.zshrc"
fi

# 10. Install Fonts
echo "🔡 Installing fonts..."
FONT_ZIP="$REPO_DIR/icons-font/NerdFontsSymbolsOnly.zip"
if [ -f "$FONT_ZIP" ]; then
    TEMP_FONT_DIR=$(mktemp -d)
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

echo "✨ Setup complete! Prefereces saved in $PLUGINS_CONF"
echo "🔄 Run 'source ~/.zshrc' to apply changes."
