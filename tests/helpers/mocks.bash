#!/bin/bash

setup_mocks() {
    export MOCK_BIN_DIR="${BATS_TMPDIR}/bin"
    mkdir -p "$MOCK_BIN_DIR"
    export PATH="$MOCK_BIN_DIR:$PATH"
}

mock_command() {
    local command_name=$1
    local output=$2
    local exit_code=${3:-0}

    cat <<EOF > "$MOCK_BIN_DIR/$command_name"
#!/bin/bash
echo "$output"
exit $exit_code
EOF
    chmod +x "$MOCK_BIN_DIR/$command_name"
}

# Helper to mock common commands used in the scripts
mock_system_commands() {
    mock_command "brew" "mock brew"
    mock_command "curl" "mock curl"
    mock_command "git" "mock git"
    mock_command "pnpm" "mock pnpm"
    mock_command "unzip" "mock unzip"
    mock_command "fc-cache" "mock fc-cache"
}
