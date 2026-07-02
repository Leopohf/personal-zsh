#!/usr/bin/env bats

setup() {
    load 'helpers/load'
    load 'helpers/mocks'
    setup_mocks

    export REPO_DIR="$BATS_TEST_DIRNAME/.."

    # Pre-process the theme file: replace zsh associative array syntax
    # ($fg[color], ${fg[color]}, $fg_bold[color]) with plain bracket strings
    # so the file is fully compatible with bash (including bash 3 on macOS).
    # Also strip \r to handle CRLF line endings on Windows/WSL.
    local tmp_theme="${BATS_TMPDIR}/leonardo.zsh-theme.bash"
    sed -E \
        -e $'s/\\r$//' \
        -e 's/\$fg\[([a-zA-Z0-9_]+)\]/[\1]/g' \
        -e 's/\$\{fg\[([a-zA-Z0-9_]+)\]\}/[\1]/g' \
        -e 's/\$reset_color/[reset]/g' \
        -e 's/\$\{reset_color\}/[reset]/g' \
        -e 's/\$fg_bold\[([a-zA-Z0-9_]+)\]/[bold_\1]/g' \
        -e 's/\$\{fg_bold\[([a-zA-Z0-9_]+)\]\}/[bold_\1]/g' \
        -e 's/typeset -gA/typeset -A/g' \
        "$REPO_DIR/themes/leonardo.zsh-theme" > "$tmp_theme"

    # Stub typeset to prevent errors in bash 3 (no associative arrays)
    typeset() {
        return 0
    }

    source "$tmp_theme"
}

teardown() {
    rm -rf "$MOCK_BIN_DIR"
}

# ── Helper to mock git behavior ──

mock_git_output() {
    local is_inside_work_tree=$1
    local status_porcelain=$2
    local diff_numstat=$3
    local diff_cached_numstat=$4

    cat <<EOF > "$MOCK_BIN_DIR/git"
#!/bin/bash
cmd="\$*"
if [[ "\$cmd" == "rev-parse --is-inside-work-tree" ]]; then
    exit $is_inside_work_tree
elif [[ "\$cmd" == "status --porcelain" ]]; then
    cat <<'INNER_EOF'
$status_porcelain
INNER_EOF
    exit 0
elif [[ "\$cmd" == "diff --numstat" ]]; then
    cat <<'INNER_EOF'
$diff_numstat
INNER_EOF
    exit 0
elif [[ "\$cmd" == "diff --cached --numstat" ]]; then
    cat <<'INNER_EOF'
$diff_cached_numstat
INNER_EOF
    exit 0
fi
EOF
    chmod +x "$MOCK_BIN_DIR/git"
}

# ═══════════════════════════════════════════════════════
# git_status_counts tests
# ═══════════════════════════════════════════════════════

@test "git_status_counts returns nothing outside a git repo" {
    mock_git_output 1 "" "" ""
    run git_status_counts
    assert_output ""
}

@test "git_status_counts returns nothing when repo is clean" {
    mock_git_output 0 "" "" ""
    run git_status_counts
    assert_output ""
}

@test "git_status_counts shows only added files" {
    local porcelain="?? newfile.txt
?? another.txt"
    mock_git_output 0 "$porcelain" "" ""
    run git_status_counts

    # Should contain document icon with +2 in green
    assert_output --partial "󰈙"
    assert_output --partial "+2"
}

@test "git_status_counts shows only deleted files" {
    local porcelain="D  removed.txt"
    mock_git_output 0 "$porcelain" "" ""
    run git_status_counts

    assert_output --partial "󰈙"
    assert_output --partial "-1"
}

@test "git_status_counts shows both added and deleted files" {
    local porcelain="?? newfile.txt
D  removed.txt"
    mock_git_output 0 "$porcelain" "" ""
    run git_status_counts

    assert_output --partial "󰈙"
    assert_output --partial "+1"
    assert_output --partial "-1"
}

@test "git_status_counts shows only line additions (unstaged)" {
    mock_git_output 0 "" "10	0	file.txt" ""
    run git_status_counts

    # Should contain line icon (≡) with +10
    assert_output --partial "≡"
    assert_output --partial "+10"
}

@test "git_status_counts shows only line deletions (unstaged)" {
    mock_git_output 0 "" "0	5	file.txt" ""
    run git_status_counts

    assert_output --partial "≡"
    assert_output --partial "-5"
}

@test "git_status_counts shows line additions and deletions" {
    mock_git_output 0 "" "10	3	file.txt" ""
    run git_status_counts

    assert_output --partial "≡"
    assert_output --partial "+10"
    assert_output --partial "-3"
}

@test "git_status_counts aggregates staged and unstaged line changes" {
    # 10 added, 2 deleted unstaged + 5 added, 1 deleted staged
    mock_git_output 0 "" "10	2	file.txt" "5	1	other.txt"
    run git_status_counts

    assert_output --partial "≡"
    assert_output --partial "+15"
    assert_output --partial "-3"
}

@test "git_status_counts shows both file and line changes together" {
    local porcelain="M  changed.txt
?? newfile.txt"
    mock_git_output 0 "$porcelain" "8	2	changed.txt" ""
    run git_status_counts

    # Both document icon and line icon should appear
    assert_output --partial "󰈙"
    assert_output --partial "≡"
    assert_output --partial "+8"
    assert_output --partial "-2"
}

@test "git_status_counts handles modified files (M status)" {
    local porcelain="M  modified.txt"
    mock_git_output 0 "$porcelain" "3	1	modified.txt" ""
    run git_status_counts

    assert_output --partial "󰈙"
    assert_output --partial "+1"  # files_added matches M status
    assert_output --partial "≡"
    assert_output --partial "+3"  # lines added
}

@test "git_status_counts skips binary files in diff (lines with -)" {
    # Binary files show as "- - filename" in --numstat; the theme filters these
    mock_git_output 0 "" "-	-	image.png
5	2	text.txt" ""
    run git_status_counts

    assert_output --partial "+5"
    assert_output --partial "-2"
}

@test "git_status_counts handles multiple files in numstat" {
    mock_git_output 0 "" "10	3	file1.txt
20	7	file2.txt" ""
    run git_status_counts

    assert_output --partial "+30"
    assert_output --partial "-10"
}

# ═══════════════════════════════════════════════════════
# node_prompt_info tests
# ═══════════════════════════════════════════════════════

@test "node_prompt_info shows version when package.json exists" {
    # Create a temp directory with package.json and cd into it
    local project_dir="${BATS_TMPDIR}/node_project"
    mkdir -p "$project_dir"
    echo '{}' > "$project_dir/package.json"

    mock_command "node" "v22.1.0"

    cd "$project_dir"
    run node_prompt_info
    assert_output --partial "22.1.0"
    assert_output --partial "󰎙"
}

@test "node_prompt_info returns nothing without node markers" {
    local empty_dir="${BATS_TMPDIR}/empty_project"
    mkdir -p "$empty_dir"

    cd "$empty_dir"
    run node_prompt_info
    assert_output ""
}

@test "node_prompt_info returns nothing when node is not installed" {
    local project_dir="${BATS_TMPDIR}/node_project2"
    mkdir -p "$project_dir"
    echo '{}' > "$project_dir/package.json"

    # Mock node to fail (not found)
    mock_command "node" "" 1

    cd "$project_dir"
    run node_prompt_info
    assert_output ""
}

# ═══════════════════════════════════════════════════════
# PROMPT and ZSH_THEME variable tests
# ═══════════════════════════════════════════════════════

@test "PROMPT variable is defined" {
    [[ -n "$PROMPT" ]]
}

@test "PROMPT includes OS_ICON reference" {
    [[ "$PROMPT" == *"OS_ICON"* ]]
}

@test "PROMPT includes arrow indicator" {
    [[ "$PROMPT" == *"➜"* ]]
}

@test "ZSH_THEME_GIT_PROMPT_PREFIX is defined" {
    [[ -n "$ZSH_THEME_GIT_PROMPT_PREFIX" ]]
}

@test "ZSH_THEME_GIT_PROMPT_DIRTY includes dirty marker" {
    [[ "$ZSH_THEME_GIT_PROMPT_DIRTY" == *"✗"* ]]
}

@test "ZSH_THEME_GIT_PROMPT_SUFFIX is defined" {
    [[ -n "$ZSH_THEME_GIT_PROMPT_SUFFIX" ]]
}

@test "ZSH_THEME_GIT_PROMPT_CLEAN is defined" {
    [[ -n "$ZSH_THEME_GIT_PROMPT_CLEAN" ]]
}
