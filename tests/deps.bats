#!/usr/bin/env bats

load 'helpers/load'
load 'helpers/mocks'

export REPO_DIR="$BATS_TEST_DIRNAME/.."
source "$REPO_DIR/scripts/install/common.sh"
source "$REPO_DIR/scripts/install/deps.sh"

setup() {
    setup_mocks
    
    # Global state reset
    SUMMARY_SUCCESS=()
    SUMMARY_FAILED=()
}

@test "install_omz should skip if already installed" {
    mkdir -p "$HOME/.oh-my-zsh"
    
    run install_omz
    assert_success
    assert_output --partial "Oh My Zsh is already installed"
}

@test "install_custom_plugins should clone plugins" {
    export ZSH_CUSTOM="$BATS_TMPDIR/zsh_custom"
    mkdir -p "$ZSH_CUSTOM/plugins"
    
    mock_command "git" "mock git clone"
    
    run install_custom_plugins
    assert_success
    assert_output --partial "Cloning custom plugins"
}

@test "install_brew_deps should install specified dependencies" {
    export BREW_DEPS="git fzf"
    
    # Mock brew to fail first then succeed
    mock_command "brew" "mock brew"
    
    run install_brew_deps
    assert_success
    assert_output --partial "Checking/Installing dependencies with Homebrew"
}
