# Docker Compose

Guía de uso de Docker Compose para orquestar múltiples contenedores.

## Instalación

Docker Compose viene incluido en Docker Desktop. Para Linux:

```bash
# Instalar Docker Compose plugin
sudo apt-get install docker-compose-plugin

# Verificar versión
docker compose version
```

## Comandos básicos

| Comando | Descripción |
|---------|-------------|
| `docker compose up` | Iniciar servicios |
| `docker compose down` | Detener y eliminar servicios |
| `docker compose ps` | Ver estado de los servicios |
| `docker compose logs` | Ver logs de los servicios |
| `docker compose build` | Construir imágenes |
| `docker compose restart` | Reiniciar servicios |

## Ejemplos

### Iniciar servicios

```bash
# Iniciar en segundo plano
docker compose up -d

# Iniciar con reconstrucción de imágenes
docker compose up -d --build

# Iniciar servicios específicos
docker compose up -d apache sqlserver
```

### Detener servicios

```bash
# Detener servicios
docker compose stop

# Detener y eliminar contenedores, redes
docker compose down

# Detener y eliminar todo (incluyendo volúmenes)
docker compose down -v
```

### Monitoreo

```bash
# Ver estado de servicios
docker compose ps

# Ver logs en tiempo real
docker compose logs -f

# Ver logs de un servicio específico
docker compose logs -f apache
```

## Archivo docker-compose.yml

### Estructura básica

```yaml
version: '3.9'

services:
  web:
    image: nginx:latest
    ports:
      - "8080:80"
    volumes:
      - ./html:/usr/share/nginx/html
    restart: always

  db:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: secret
    volumes:
      - db-data:/var/lib/mysql

volumes:
  db-data:
```

### Elementos comunes

```yaml
services:
  mi-servicio:
    image: mi-imagen        # Imagen a usar
    build: ./path           # Construir desde Dockerfile
    container_name: nombre  # Nombre del contenedor
    ports:                  # Mapeo de puertos
      - "8080:80"
    volumes:                # Montar volúmenes
      - ./local:/container
    environment:            # Variables de entorno
      - KEY=value
    restart: always         # Política de reinicio
    depends_on:             # Dependencias
      - otro-servicio
```

## Ejemplo práctico

Ver el archivo [`docker-apache/docker-compose.yml`](../docker-apache/docker-compose.yml) como ejemplo completo de configuración.

## Ver también

- [Comandos de Docker](comandos-docker.md)
- [Apache Docker](../docker-apache/readme.md)
- [SQL Server Docker](../sqlserver-develop/readme.md)
