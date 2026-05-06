# OS Detection
case "$(uname -s)" in
    Darwin)
        export IS_MACOS=true
        export IS_LINUX=false
        export OS_ICON="" # Apple icon
        ;;
    Linux)
        export IS_MACOS=false
        export IS_LINUX=true
        if grep -q "microsoft" /proc/version 2>/dev/null; then
            export OS_ICON="" # Windows icon for WSL
        elif [ -f /etc/os-release ] && grep -q "Ubuntu" /etc/os-release; then
            export OS_ICON="" # Ubuntu icon
        else
            export OS_ICON="" # Generic Linux icon
        fi
        ;;
    *)
        export IS_MACOS=false
        export IS_LINUX=false
        export OS_ICON="" # Default terminal icon
        ;;
esac
