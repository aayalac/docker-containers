# Comandos de volúmenes Docker

Referencia de comandos para administrar volúmenes Docker.

**Sintaxis:** `docker volume [comando]`

## Comandos

| Comando | Descripción |
|---------|-------------|
| `docker volume create` | Crear un volumen |
| `docker volume rm` | Eliminar volúmenes |
| `docker volume ls` | Listar volúmenes |
| `docker volume inspect` | Mostrar información detallada de los volúmenes |
| `docker volume prune` | Eliminar todos los volúmenes no utilizados |

## Tipos de volúmenes

| Tipo | Sintaxis | Descripción |
|------|----------|-------------|
| Named volume | `-v mi-volumen:/app/data` | Volumen administrado por Docker |
| Bind mount | `-v /host/path:/container/path` | Monta un directorio del host |

## Ejemplos

### Crear y gestionar volúmenes

```bash
# Crear un volumen
docker volume create mi-volumen

# Listar volúmenes
docker volume ls

# Inspeccionar un volumen
docker volume inspect mi-volumen

# Eliminar un volumen
docker volume rm mi-volumen
```

### Usar volúmenes con contenedores

```bash
# Con named volume
docker container run -d \
  --name mi-app \
  -v mi-volumen:/app/data \
  mi-imagen

# Con bind mount
docker container run -d \
  --name mi-app \
  -v $(pwd)/data:/app/data \
  mi-imagen

# Con bind mount (solo lectura)
docker container run -d \
  --name mi-app \
  -v $(pwd)/config:/app/config:ro \
  mi-imagen
```

### Ejemplo práctico: Base de datos

```bash
# Crear volumen para datos persistentes
docker volume create mysql-data

# Ejecutar MySQL con volumen
docker container run -d \
  --name mysql-db \
  -v mysql-data:/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD=secret \
  -p 3306:3306 \
  mysql:8.0

# Los datos persisten aunque se elimine el contenedor
docker container rm -f mysql-db
docker container run -d --name mysql-db -v mysql-data:/var/lib/mysql mysql:8.0
# ¡Los datos siguen ahí!
```

## Limpieza

```bash
# Eliminar todos los volúmenes no utilizados
docker volume prune
```

> **Precaución:** Esto elimina volúmenes que no están conectados a ningún contenedor.

## Ver también

- [Comandos de contenedores](comandos-docker.md)
- [Comandos de redes](comandos-redes-docker.md)
