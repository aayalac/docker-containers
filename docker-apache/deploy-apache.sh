#!/bin/bash

# Ruta base del proyecto
BASE_DIR="/mnt/data/docker-containers/docker-apache"

echo "🚀 Iniciando despliegue de Apache en Docker..."

# Detener contenedor previo si existe
if [ "$(docker ps -aq -f name=apache-server)" ]; then
    echo "🛑 Deteniendo y eliminando contenedor anterior..."
    docker stop apache-server && docker rm apache-server
fi

# Crear estructura de carpetas
echo "📂 Creando estructura de carpetas..."
mkdir -p $BASE_DIR/apache/conf
mkdir -p $BASE_DIR/apache/html
mkdir -p $BASE_DIR/apache/logs

# Crear docker-compose.yml
echo "📝 Creando docker-compose.yml..."
cat > $BASE_DIR/docker-compose.yml <<EOF
version: '3.9'

services:
  apache:
    build: ./apache
    container_name: apache-server
    ports:
      - "8081:80"
    volumes:
      - ./apache/html:/usr/local/apache2/htdocs
      - ./apache/conf/000-default.conf:/usr/local/apache2/conf/conf.d/000-default.conf
      - ./apache/logs:/usr/local/apache2/logs
    restart: always
EOF

# Crear Dockerfile
echo "📝 Creando Dockerfile..."
cat > $BASE_DIR/apache/Dockerfile <<EOF
FROM httpd:2.4
COPY conf/000-default.conf /usr/local/apache2/conf/conf.d/000-default.conf
EOF

# Crear configuración Apache
echo "📝 Creando configuración Apache..."
cat > $BASE_DIR/apache/conf/000-default.conf <<EOF
<VirtualHost *:80>
    DocumentRoot "/usr/local/apache2/htdocs"
    ErrorLog /usr/local/apache2/logs/error.log
    CustomLog /usr/local/apache2/logs/access.log combined
</VirtualHost>
EOF

# Crear HTML de prueba
echo "📝 Creando index.html de prueba..."
cat > $BASE_DIR/apache/html/index.html <<EOF
<!DOCTYPE html>
<html>
  <head><title>Servidor Apache en Docker</title></head>
  <body>
    <h1>¡Apache está funcionando en Docker!</h1>
  </body>
</html>
EOF

# Levantar contenedor
echo "🐳 Construyendo y levantando contenedor Apache..."
cd $BASE_DIR
docker-compose up --build -d

echo "✅ Despliegue completado. Accede en: http://localhost:8081"
