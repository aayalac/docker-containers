# Despliegue de imágenes .NET con Docker

Guía para compilar y desplegar aplicaciones .NET Core/5+ usando Docker.

## Construir imagen

### Estructura del comando

```bash
docker image build -t [nombre-app]:[versión] -f [ruta-dockerfile] .
```

| Parámetro | Descripción |
|-----------|-------------|
| `-t` | Nombre y versión de la imagen |
| `-f` | Ruta al archivo Dockerfile |
| `.` | Contexto de construcción (directorio actual) |

### Ejemplo

```bash
docker image build -t mi-api:1.0 -f DockerFiles/DOCKERFILE .
```

## Ejecutar contenedor

### Estructura del comando

```bash
docker container run -d --name [nombre] -p [puerto-host]:[puerto-container] [imagen]
```

| Parámetro | Descripción |
|-----------|-------------|
| `-d` | Ejecutar en segundo plano (detached) |
| `--name` | Nombre del contenedor |
| `-p` | Mapeo de puertos |
| `--restart` | Política de reinicio |

### Ejemplo básico

```bash
docker container run -d \
  --name mi-api \
  -p 8080:8080 \
  mi-api:1.0
```

### Con variable de entorno

```bash
docker container run -d \
  --name mi-api \
  -p 8080:8080 \
  -e ASPNETCORE_ENVIRONMENT=Production \
  mi-api:1.0
```

### Con conexión a base de datos

```bash
docker container run -d \
  --name mi-api \
  -p 8080:8080 \
  -e ConnectionStrings__DefaultConnection="Server=db;Database=MiDb;User Id=sa;Password=secret;" \
  --network mi-red \
  mi-api:1.0
```

## Ejemplo completo

```bash
# 1. Construir imagen
docker image build -t tienda-pizzas:1.0 -f tienda-pizzas-razor.yml .

# 2. Ejecutar contenedor
docker container run -d \
  --name tienda-pizzas \
  -p 5000:80 \
  -e ASPNETCORE_ENVIRONMENT=Development \
  tienda-pizzas:1.0

# 3. Verificar
curl http://localhost:5000
```

## Ver también

- [Comandos de imágenes](comandos-imagenes-docker.md)
- [Docker Compose](docker-compose.md)
- [Tienda Pizzas Razor](../tienda-pizzas-razor/readme.md)
