#!/usr/bin/env bash
#
# SQL Server 2025 Developer - Ubuntu 26.04.1 LTS
# Instalación mediante Docker
#

set -Eeuo pipefail

CONTAINER_NAME="sqlserver"
IMAGE="mcr.microsoft.com/mssql/server:2025-latest"
VOLUME_NAME="sqlserver_data"
SA_USER="sa"
PORT="1433"

# Colores
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[AVISO]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
    exit 1
}

# Comprobar ejecución como root
if [[ $EUID -ne 0 ]]; then
    error "Ejecuta el script con sudo."
fi

# Comprobar arquitectura
ARCH=$(dpkg --print-architecture)

if [[ "$ARCH" != "amd64" ]]; then
    error "SQL Server requiere arquitectura x86_64 (amd64)."
fi

# Comprobar Docker
if ! command -v docker >/dev/null 2>&1; then
    error "Docker no está instalado. Instala Docker primero."
fi

if ! docker info >/dev/null 2>&1; then
    error "Docker no está funcionando. Comprueba el servicio."
fi

# Evitar sobrescribir instalaciones existentes
if docker container inspect "$CONTAINER_NAME" >/dev/null 2>&1; then
    error "Ya existe un contenedor llamado $CONTAINER_NAME."
fi

# Solicitar contraseña
echo
echo "=========================================="
echo " INSTALACION SQL SERVER 2025 DEVELOPER"
echo "=========================================="
echo

while true; do
    read -rsp "Contraseña para SQL Server (sa): " SA_PASSWORD
    echo

    read -rsp "Confirma la contraseña: " SA_PASSWORD_CONFIRM
    echo

    if [[ "$SA_PASSWORD" != "$SA_PASSWORD_CONFIRM" ]]; then
        warn "Las contraseñas no coinciden."
        continue
    fi

    # Política de contraseña de SQL Server
    if [[ ${#SA_PASSWORD} -lt 8 ]] ||
       ! [[ "$SA_PASSWORD" =~ [A-Z] ]] ||
       ! [[ "$SA_PASSWORD" =~ [a-z] ]] ||
       ! [[ "$SA_PASSWORD" =~ [0-9] ]] ||
       ! [[ "$SA_PASSWORD" =~ [^a-zA-Z0-9] ]]; then
        warn "Usa al menos 8 caracteres, incluyendo mayúsculas, minúsculas, números y símbolos."
        continue
    fi

    break
done

# Actualizar imágenes
log "Descargando imagen de SQL Server 2025..."
docker pull "$IMAGE"

# Crear volumen persistente
log "Creando volumen de almacenamiento..."
docker volume create "$VOLUME_NAME" >/dev/null

# Instalar contenedor
log "Creando contenedor SQL Server..."

docker run -d \
    --name "$CONTAINER_NAME" \
    --hostname "$CONTAINER_NAME" \
    --restart unless-stopped \
    -e ACCEPT_EULA=Y \
    -e MSSQL_PID=Developer \
    -e MSSQL_SA_PASSWORD="$SA_PASSWORD" \
    -p "${PORT}:1433" \
    -v "${VOLUME_NAME}:/var/opt/mssql" \
    "$IMAGE" >/dev/null

unset SA_PASSWORD SA_PASSWORD_CONFIRM

# Esperar disponibilidad
log "Esperando que SQL Server inicie..."

READY=0

for i in $(seq 1 60); do

    if docker exec "$CONTAINER_NAME" \
        /opt/mssql-tools18/bin/sqlcmd \
        -S localhost \
        -U "$SA_USER" \
        -P "$SA_PASSWORD" \
        -C \
        -Q "SELECT 1" >/dev/null 2>&1; then

        READY=1
        break
    fi

    sleep 5
done

if [[ "$READY" -ne 1 ]]; then
    warn "SQL Server no respondió dentro del tiempo esperado."
    docker logs --tail 50 "$CONTAINER_NAME"
    exit 1
fi

# Estado final
echo
echo "=========================================="
echo " INSTALACION COMPLETADA"
echo "=========================================="

docker ps --filter "name=$CONTAINER_NAME"

echo
log "SQL Server está funcionando correctamente."
echo
echo "Servidor:       localhost"
echo "Puerto:         1433"
echo "Usuario:        sa"
echo "Base de datos:  SQL Server 2025 Developer"
echo "Contenedor:     $CONTAINER_NAME"
echo "Volumen:        $VOLUME_NAME"
echo

echo "Comandos de administración:"
echo
echo "Ver estado:"
echo "  docker ps"
echo
echo "Ver registros:"
echo "  docker logs -f $CONTAINER_NAME"
echo
echo "Detener SQL Server:"
echo "  docker stop $CONTAINER_NAME"
echo
echo "Iniciar SQL Server:"
echo "  docker start $CONTAINER_NAME"
echo
echo "Reiniciar SQL Server:"
echo "  docker restart $CONTAINER_NAME"
echo
echo "Conectar desde terminal:"
echo "  docker exec -it $CONTAINER_NAME /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -C"
echo
echo "=========================================="
