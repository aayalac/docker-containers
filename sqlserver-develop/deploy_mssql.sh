#!/bin/bash

# Configuración
CONTAINER_NAME="sqlserver-dev"
SA_PASSWORD="Contraseña"
DATA_DIR="/mnt/data/var/lib/docker/volumes"
DOCKER_IMAGE="mcr.microsoft.com/mssql/server:2022-latest"

# Detener y eliminar contenedor existente (si aplica)
docker rm -f $CONTAINER_NAME 2>/dev/null

# Crear directorios con permisos
sudo mkdir -p ${DATA_DIR}/sqlserver_{data,system,log}
sudo chown -R 10001:0 ${DATA_DIR}/sqlserver_*
sudo chmod -R 777 ${DATA_DIR}/sqlserver_*

# Desplegar nuevo contenedor
docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=$SA_PASSWORD" \
   -p 1433:1433 --name $CONTAINER_NAME \
   -v ${DATA_DIR}/sqlserver_data:/var/opt/mssql \
   -v ${DATA_DIR}/sqlserver_system:/var/opt/mssql/.system \
   -v ${DATA_DIR}/sqlserver_log:/log \
   --memory="2g" --cpus="2" \
   --restart unless-stopped \
   -d $DOCKER_IMAGE

# Verificar estado
echo -e "\n✅ Contenedor desplegado. Verificando estado..."
sleep 5
docker ps -f "name=$CONTAINER_NAME" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# Test de conexión (opcional)
echo -e "\n🧪 Probando conexión..."
if ! command -v sqlcmd &>/dev/null; then
    echo "Instalando sqlcmd..."
    sudo apt-get update && sudo apt-get install -y mssql-tools unixodbc-dev
fi

sqlcmd -S localhost -U sa -P "$SA_PASSWORD" -Q "SELECT @@VERSION AS 'SQL Server Version'" -t 10