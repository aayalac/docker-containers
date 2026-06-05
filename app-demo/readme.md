# App Demo

Aplicación de prueba desplegada con Docker. API REST sencilla con Express.js para demostrar el flujo completo de despliegue.

## Estructura

```
app-demo/
├── src/
│   └── app.js              # Aplicación Express
├── package.json            # Dependencias Node.js
├── Dockerfile              # Imagen Docker
├── docker-compose.yml      # Orquestación Docker
├── deploy.sh               # Script de despliegue
└── readme.md               # Esta documentación
```

## Endpoints

| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | `/` | Mensaje de bienvenida |
| GET | `/health` | Health check con uptime y memoria |
| GET | `/info` | Información del sistema |
| GET | `/hello/:name` | Saludo personalizado |

## Puertos

| Servicio | Puerto | Descripción |
|----------|--------|-------------|
| App | 3000 | API REST |

## Despliegue

### Opción 1: Docker Compose

```bash
cd app-demo
docker compose up -d
```

### Opción 2: Script de despliegue

```bash
cd app-demo
chmod +x deploy.sh
./deploy.sh
```

### Opción 3: Manual

```bash
cd app-demo

# Construir imagen
docker image build -t app-demo:1.0 .

# Ejecutar contenedor
docker container run -d \
  --name app-demo \
  -p 3000:3000 \
  -e PORT=3000 \
  app-demo:1.0
```

## Pruebas

Una vez desplegado, verifica que funciona:

```bash
# Bienvenida
curl http://localhost:3000

# Health check
curl http://localhost:3000/health

# Info del sistema
curl http://localhost:3000/info

# Saludo personalizado
curl http://localhost:3000/hello/docker
```

## Variables de entorno

| Variable | Valor por defecto | Descripción |
|----------|-------------------|-------------|
| `PORT` | `3000` | Puerto del servidor |
| `NODE_ENV` | `production` | Entorno de ejecución |

## Comandos útiles

```bash
# Ver logs
docker logs -f app-demo

# Reiniciar
docker restart app-demo

# Detener y eliminar
docker stop app-demo && docker rm app-demo

# Entrar al shell
docker exec -it app-demo sh
```

## Dockerfile explicado

```dockerfile
# Imagen base ligera con Node.js 20
FROM node:20-alpine

# Directorio de trabajo
WORKDIR /app

# Copiar y instalar dependencias primero (mejor cache)
COPY package*.json ./
RUN npm install --production

# Copiar código de la aplicación
COPY src/ ./src/

# Puerto expuesto
EXPOSE 3000

# Comando de inicio
CMD ["node", "src/app.js"]
```

> **Tip:** Copiar `package.json` antes del código permite que Docker cache las dependencias, acelerando las reconstrucciones.

## Health Check

El `docker-compose.yml` incluye un health check automático:

```yaml
healthcheck:
  test: ["CMD", "wget", "--spider", "-q", "http://localhost:3000/health"]
  interval: 30s      # Cada 30 segundos
  timeout: 10s       # Timeout de 10 segundos
  retries: 3         # 3 intentos antes de marcar como unhealthy
```

Verificar estado:

```bash
docker inspect --format='{{.State.Health.Status}}' app-demo
```

## Ver también

- [Docker Compose](../docs/docker-compose.md)
- [Comandos de contenedores](../docs/comandos-docker.md)
- [Despliegue de imágenes](../docs/desplegar-imagenes-docker.md)
