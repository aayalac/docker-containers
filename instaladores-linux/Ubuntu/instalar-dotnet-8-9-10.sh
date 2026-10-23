#!/usr/bin/env bash
set -Eeuo pipefail

# Instala .NET SDK 8, 9 y 10 en Ubuntu 26.04 LTS.
# Uso: chmod +x instalar-dotnet-8-9-10.sh && ./instalar-dotnet-8-9-10.sh

readonly REQUIRED_CODENAME="resolute"
readonly PACKAGES=(
  dotnet-sdk-8.0
  dotnet-sdk-9.0
  dotnet-sdk-10.0
)

log() {
  printf '\n[%s] %s\n' "$(date '+%H:%M:%S')" "$*"
}

fail() {
  printf '\nERROR: %s\n' "$*" >&2
  exit 1
}

trap 'fail "El script falló en la línea ${LINENO}. Revisa el mensaje anterior."' ERR

if [[ "${EUID}" -eq 0 ]]; then
  SUDO=()
else
  command -v sudo >/dev/null 2>&1 || fail "No se encontró sudo. Ejecuta como root o instala sudo."
  SUDO=(sudo)
fi

command -v lsb_release >/dev/null 2>&1 || {
  "${SUDO[@]}" apt-get update
  "${SUDO[@]}" apt-get install -y lsb-release
}

OS_ID="$(. /etc/os-release && printf '%s' "${ID:-}")"
OS_CODENAME="$(. /etc/os-release && printf '%s' "${VERSION_CODENAME:-}")"

[[ "$OS_ID" == "ubuntu" ]] || fail "Este script está preparado para Ubuntu; sistema detectado: ${OS_ID:-desconocido}."
[[ "$OS_CODENAME" == "$REQUIRED_CODENAME" ]] || fail "Se esperaba Ubuntu 26.04 (codename resolute), pero se detectó '${OS_CODENAME:-desconocido}'. No se harán cambios."

log "Sistema detectado: Ubuntu ${VERSION_ID:-26.04} (${OS_CODENAME}), arquitectura $(dpkg --print-architecture)."

log "Actualizando índices de paquetes e instalando dependencias..."
"${SUDO[@]}" apt-get update
"${SUDO[@]}" apt-get install -y ca-certificates software-properties-common

log "Agregando el repositorio oficial de .NET Backports de Ubuntu si aún no existe..."
if ! grep -RhsE '^[[:space:]]*deb .*ppa\.launchpadcontent\.net/dotnet/backports|^[[:space:]]*URIs:.*ppa\.launchpadcontent\.net/dotnet/backports' \
    /etc/apt/sources.list /etc/apt/sources.list.d 2>/dev/null | grep -q .; then
  "${SUDO[@]}" add-apt-repository -y ppa:dotnet/backports
else
  log "El repositorio de .NET Backports ya parece estar configurado."
fi

log "Actualizando índices después de configurar el repositorio..."
"${SUDO[@]}" apt-get update

log "Instalando .NET SDK 8, 9 y 10..."
"${SUDO[@]}" apt-get install -y "${PACKAGES[@]}"

log "SDK instalados:"
dotnet --list-sdks

log "Runtimes instalados:"
dotnet --list-runtimes

log "Versión de SDK seleccionada en el directorio actual:"
dotnet --version

printf '\nInstalación finalizada. Los SDK .NET 8, 9 y 10 están instalados (si APT terminó sin errores).\n'
printf 'Documentación oficial: https://learn.microsoft.com/es-es/dotnet/core/install/linux-ubuntu-install\n'
