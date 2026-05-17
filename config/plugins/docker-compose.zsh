# Docker Compose
# Use 'docker compose' (v2) if available, otherwise fallback to 'docker-compose' (v1)
if docker compose version &> /dev/null; then
    alias dc="docker compose"
    alias docker-compose="docker compose"
else
    alias dc="docker-compose"
fi
