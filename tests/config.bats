#!/usr/bin/env bats

setup() {
    load 'helpers/load'
    load 'helpers/mocks'
    setup_mocks
    
    export REPO_DIR="$BATS_TEST_DIRNAME/.."
    
    # Set up temp directories for isolation
    export HOME="$BATS_TMPDIR/home"
    mkdir -p "$HOME"
    export ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
    mkdir -p "$ZSH_CUSTOM/themes"
    export CONFIG_DEST="$HOME/.zsh_config"
    
    # Source dependent scripts
    source "$REPO_DIR/scripts/install/common.sh"
    source "$REPO_DIR/scripts/install/config.sh"
    
    # Mock fc-cache for install_fonts
    mock_command "fc-cache" "mock fc-cache"
    mock_command "unzip" "mock unzip"
}

@test "copy_theme should copy the theme file" {
    # Create a dummy theme file in the repo
    mkdir -p "$REPO_DIR/themes"
    echo "test theme" > "$REPO_DIR/themes/leonardo.zsh-theme"
    
    run copy_theme
    assert_success
    assert_file_exists "$ZSH_CUSTOM/themes/leonardo.zsh-theme"
}

@test "setup_local_config should create .zshrc.local" {
    run setup_local_config
    assert_success
    assert_file_exists "$HOME/.zshrc.local"
    assert_file_permission 600 "$HOME/.zshrc.local"
}

@test "generate_zshrc should create .zshrc from template" {
    echo "plugins=(_DYNAMIC_PLUGINS_)" > "$REPO_DIR/zshrc.template"
    
    run generate_zshrc
    assert_success
    assert_file_exists "$HOME/.zshrc"
    assert_file_contains "$HOME/.zshrc" "plugins=(history git)"
}
