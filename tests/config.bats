#!/usr/bin/env bats

setup() {
    load 'helpers/load'
    load 'helpers/mocks'
    setup_mocks
    
    # Use a mock REPO_DIR so tests never touch real repo files
    export REPO_DIR="$BATS_TMPDIR/mock_repo"
    mkdir -p "$REPO_DIR/themes"
    mkdir -p "$REPO_DIR/scripts/install"
    
    # Copy only the files needed by the scripts under test
    local REAL_REPO="$BATS_TEST_DIRNAME/.."
    cp "$REAL_REPO/scripts/install/common.sh" "$REPO_DIR/scripts/install/"
    cp "$REAL_REPO/scripts/install/config.sh" "$REPO_DIR/scripts/install/"
    mkdir -p "$REPO_DIR/config/core"
    cp "$REAL_REPO/config/core/00-os.zsh" "$REPO_DIR/config/core/"
    
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

teardown() {
    rm -rf "$BATS_TMPDIR/mock_repo"
}

@test "copy_theme should copy the theme file" {
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
