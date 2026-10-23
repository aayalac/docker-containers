#!/usr/bin/env bash
set -Eeuo pipefail

# ============================================================
# DOCKER DEVELOPMENT ENVIRONMENT
# Ubuntu 26.04.1 LTS (and compatible Ubuntu releases)
#
# Installs:
#   - Docker Engine, CLI and containerd
#   - Docker Buildx and Docker Compose V2
#   - Portainer CE (HTTPS on port 9443)
#   - Development and server administration utilities
#
# Not installed:
#   - Kubernetes
#   - Prometheus / Grafana
#
# Safety:
#   - Does not uninstall existing container runtimes.
#   - Preserves an existing /etc/docker/daemon.json.
#   - Preserves an existing Portainer compose.yaml/container.
#   - Does not enable or modify UFW.
#   - Does not add users to the privileged "docker" group.
# ============================================================

DOCKER_PROJECTS_DIR="/mnt/data/docker-containers"
PORTAINER_DIR="${DOCKER_PROJECTS_DIR}/docker-portainer"
PORTAINER_IMAGE="portainer/portainer-ce:sts"
PORTAINER_HTTPS_PORT="9443"

log()  { printf '\n[INFO] %s\n' "$1"; }
warn() { printf '\n[WARNING] %s\n' "$1" >&2; }
die()  { printf '\n[ERROR] %s\n' "$1" >&2; exit 1; }

trap 'die "Installation failed near line ${LINENO}. Review the output above."' ERR

# Require root.
if [[ "${EUID}" -ne 0 ]]; then
    die "Run this script with sudo: sudo bash install-docker.sh"
fi

# Verify Ubuntu and detect its codename.
[[ -r /etc/os-release ]] || die "Cannot identify the operating system."
# shellcheck disable=SC1091
source /etc/os-release

[[ "${ID:-}" == "ubuntu" ]] || die "This script supports Ubuntu only."

CODENAME="${UBUNTU_CODENAME:-${VERSION_CODENAME:-}}"
ARCH="$(dpkg --print-architecture)"
[[ -n "${CODENAME}" ]] || die "Cannot determine the Ubuntu release codename."

log "Preparing installation for ${PRETTY_NAME:-Ubuntu} (${CODENAME}, ${ARCH})."

# Check for conflicting packages. Do not remove them automatically.
CONFLICTS=(
    docker.io
    docker-doc
    docker-compose
    docker-compose-v2
    docker-buildx
    podman-docker
)

for package in "${CONFLICTS[@]}"; do
    status="$(dpkg-query -W -f='${db:Status-Status}' "${package}" 2>/dev/null || true)"
    if [[ "${status}" == "installed" ]]; then
        die "Conflicting package '${package}' is installed. Review it before proceeding; nothing was removed."
    fi
done

export DEBIAN_FRONTEND=noninteractive

log "Updating Ubuntu package indexes."
apt-get update

log "Installing administration and development utilities."
apt-get install -y \
    ca-certificates \
    curl \
    wget \
    gnupg \
    git \
    jq \
    unzip \
    zip \
    tar \
    xz-utils \
    htop \
    ncdu \
    tree \
    vim \
    nano \
    tmux \
    rsync \
    lsof \
    dnsutils \
    iproute2 \
    iputils-ping \
    net-tools \
    traceroute \
    tcpdump \
    ufw \
    unattended-upgrades

log "Configuring the official Docker repository."
install -m 0755 -d /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
    -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

cat > /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: ${CODENAME}
Components: stable
Architectures: ${ARCH}
Signed-By: /etc/apt/keyrings/docker.asc
EOF

log "Refreshing package indexes."
apt-get update

log "Installing Docker Engine, Buildx and Compose V2."
apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

log "Enabling Docker services."
systemctl enable --now containerd
systemctl enable --now docker

# Set bounded container logs only if no daemon configuration exists.
install -d -m 0755 /etc/docker
if [[ ! -e /etc/docker/daemon.json ]]; then
    cat > /etc/docker/daemon.json <<'EOF'
{
  "log-driver": "local",
  "log-opts": {
    "max-size": "20m",
    "max-file": "3"
  }
}
EOF
    systemctl restart docker
else
    warn "Existing /etc/docker/daemon.json found; it was preserved unchanged."
fi

log "Verifying Docker installation."
docker --version
docker compose version
docker buildx version
systemctl is-active --quiet docker || die "Docker service is not active."
systemctl is-active --quiet containerd || die "containerd service is not active."

log "Running Docker hello-world test."
docker run --rm hello-world

# Prepare Portainer configuration without overwriting an existing one.
log "Preparing Portainer CE."
install -d -m 0755 "${PORTAINER_DIR}"

COMPOSE_FILE="${PORTAINER_DIR}/compose.yaml"

if [[ ! -e "${COMPOSE_FILE}" ]]; then
    cat > "${COMPOSE_FILE}" <<EOF
services:
  portainer:
    image: ${PORTAINER_IMAGE}
    container_name: portainer
    restart: always
    ports:
      - "${PORTAINER_HTTPS_PORT}:9443"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - portainer_data:/data

volumes:
  portainer_data:
    name: portainer_data
EOF
else
    warn "Existing ${COMPOSE_FILE} found; it was not overwritten."
fi

# Do not replace an existing container with the same name.
if docker container inspect portainer >/dev/null 2>&1; then
    warn "A container named 'portainer' already exists; deployment was skipped."
else
    log "Deploying Portainer CE."
    docker compose -f "${COMPOSE_FILE}" up -d
fi

log "Final verification."
docker ps -a
printf '\nDocker: '; docker --version
printf 'Compose: '; docker compose version
printf 'Buildx: '; docker buildx version
printf 'Docker service: '; systemctl is-active docker
printf 'containerd service: '; systemctl is-active containerd

if docker container inspect portainer >/dev/null 2>&1; then
    printf 'Portainer container: '
    docker inspect --format '{{.State.Status}}' portainer
else
    warn "Portainer container was not found. Check the Compose output."
fi

SERVER_IP="$(hostname -I | awk '{print $1}')"

cat <<EOF

============================================================
 INSTALLATION FINISHED
============================================================

Docker:
  Engine, CLI, containerd, Buildx and Compose V2 installed.

Portainer CE:
  URL:       https://${SERVER_IP:-SERVER_IP}:${PORTAINER_HTTPS_PORT}
  Compose:   ${COMPOSE_FILE}
  Volume:    portainer_data

Useful commands:
  docker ps
  docker images
  docker compose ls
  docker system df
  docker volume ls
  docker network ls

Portainer:
  cd "${PORTAINER_DIR}"
  docker compose ps
  docker compose logs -f
  docker compose restart

Not installed:
  Kubernetes
  Prometheus
  Grafana

Security notes:
  - Portainer is exposed on HTTPS port ${PORTAINER_HTTPS_PORT}.
  - HTTP port 9000 is not published.
  - UFW was not enabled or modified.
  - No user was added to the privileged docker group.
  - Docker socket access gives Portainer administrative control
    over the Docker host. Protect its administrator credentials.
  - Docker-published ports may bypass ordinary UFW filtering;
    review host/network firewall rules before exposing services.

============================================================
EOF
