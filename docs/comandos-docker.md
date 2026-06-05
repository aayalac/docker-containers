# Comandos de contenedores Docker

Referencia de comandos para administrar contenedores Docker.

**Sintaxis:** `docker container [comando]`

## Comandos básicos

| Comando | Descripción |
|---------|-------------|
| `docker container run` | Ejecutar un comando en un nuevo contenedor |
| `docker container start` | Iniciar un contenedor detenido |
| `docker container stop` | Detener un contenedor en ejecución |
| `docker container restart` | Reiniciar un contenedor |
| `docker container rm` | Eliminar un contenedor |
| `docker container rename` | Renombrar un contenedor |

## Comandos de información

| Comando | Descripción |
|---------|-------------|
| `docker container ls` | Listar contenedores en ejecución |
| `docker container ls -a` | Listar todos los contenedores (incluyendo detenidos) |
| `docker container inspect` | Mostrar información detallada de un contenedor |
| `docker container stats` | Mostrar estadísticas en vivo del uso de recursos |
| `docker container top` | Mostrar procesos en ejecución |

## Comandos de mantenimiento

| Comando | Descripción |
|---------|-------------|
| `docker container prune` | Eliminar todos los contenedores detenidos |
| `docker container exec -it [ID] bash` | Ingresar al shell bash de un contenedor |
| `docker update --restart unless-stopped [ID]` | Aplicar política de reinicio automático |

## Ejemplos

### Ejecutar un contenedor

```bash
# Ejecutar Ubuntu con shell interactivo
docker container run -it --name mi-contenedor ubuntu bash

# Ejecutar en segundo plano
docker container run -d --name mi-app -p 8080:80 nginx

# Con variable de entorno
docker container run -d -e MYSQL_ROOT_PASSWORD=secret --name db mysql
```

### Gestionar contenedores

```bash
# Listar contenedores activos
docker container ls

# Listar todos los contenedores
docker container ls -a

# Ver logs de un contenedor
docker logs -f mi-contenedor

# Entrar a un contenedor en ejecución
docker exec -it mi-contenedor bash
```

### Limpieza

```bash
# Eliminar todos los contenedores detenidos
docker container prune

# Eliminar un contenedor específico
docker container rm mi-contenedor

# Forzar eliminación de contenedor en ejecución
docker container rm -f mi-contenedor
```

## Ver también

- [Comandos de imágenes](comandos-imagenes-docker.md)
- [Comandos de redes](comandos-redes-docker.md)
- [Comandos de volúmenes](comandos-volumenes-docker.md)
