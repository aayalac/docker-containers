#!/bin/bash

echo "🚀 Desplegando app-demo..."

# Detener contenedor previo si existe
if [ "$(docker ps -aq -f name=app-demo)" ]; then
    echo "🛑 Deteniendo contenedor anterior..."
    docker stop app-demo && docker rm app-demo
fi

# Construir y levantar
echo "📦 Construyendo imagen..."
cd "$(dirname "$0")"
docker compose up --build -d

# Verificar estado
echo ""
echo "✅ Despliegue completado."
echo ""
sleep 3
docker ps -f "name=app-demo" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo ""
echo "🌐 Accede a: http://localhost:3000"
echo "📊 Health check: http://localhost:3000/health"
echo "ℹ️  Info: http://localhost:3000/info"
