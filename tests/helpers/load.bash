# Load bats libraries
load_lib() {
    local name=$1
    # Try the direct node_modules path (standard layout)
    local path="${BATS_TEST_DIRNAME}/../node_modules/${name}/load.bash"
    if [ -f "$path" ]; then
        load "$path"
        return
    fi
    
    # Try searching for it (pnpm nested layout)
    local found_path=$(find "${BATS_TEST_DIRNAME}/../node_modules/.pnpm" -name "load.bash" | grep "/${name}/load.bash" | head -n 1)
    if [ -n "$found_path" ]; then
        load "$found_path"
        return
    fi

    echo "Error: Could not find bats library ${name}" >&2
    return 1
}

load_lib "bats-support"
load_lib "bats-assert"
load_lib "bats-file"
