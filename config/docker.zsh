# Docker & Docker Compose
alias d="docker"

# Use 'docker compose' (v2) if available, otherwise fallback to 'docker-compose' (v1)
if docker compose version &> /dev/null; then
    alias dc="docker compose"
else
    alias dc="docker-compose"
fi

alias dps="docker ps"
alias dpa="docker ps -a"
alias di="docker images"
alias drm="docker rm"
alias drmi="docker rmi"
alias dl="docker logs -f"

# Stop and remove all containers
function dstopall() {
    docker stop $(docker ps -a -q)
    docker rm $(docker ps -a -q)
}

# Remove unused Docker resources
alias dprune="docker system prune -af"
