# Comandos de redes Docker

Referencia de comandos para administrar redes Docker.

**Sintaxis:** `docker network [comando]`

## Comandos

| Comando | Descripción |
|---------|-------------|
| `docker network create` | Crear una red |
| `docker network rm` | Eliminar una red |
| `docker network ls` | Listar redes |
| `docker network inspect` | Mostrar información detallada de las redes |
| `docker network connect` | Conectar un contenedor a una red |
| `docker network disconnect` | Desconectar un contenedor de una red |
| `docker network prune` | Eliminar todas las redes no utilizadas |

## Tipos de redes

| Tipo | Descripción |
|------|-------------|
| `bridge` | Red por defecto. Comunicación entre contenedores en el mismo host |
| `host` | El contenedor usa la red del host directamente |
| `none` | Sin configuración de red |
| `overlay` | Red multi-host para Docker Swarm |
| `macvlan` | Asigna direcciones MAC a los contenedores |

## Ejemplos

### Crear y gestionar redes

```bash
# Crear una red bridge
docker network create mi-red

# Crear con subnet específico
docker network create --subnet=172.20.0.0/16 mi-red

# Listar redes
docker network ls

# Inspeccionar una red
docker network inspect mi-red
```

### Conectar contenedores

```bash
# Crear contenedor conectado a una red
docker container run -d --name app1 --network mi-red nginx

# Conectar contenedor existente a una red
docker network connect mi-red app2

# Desconectar contenedor de una red
docker network disconnect mi-red app2
```

### Comunicación entre contenedores

```bash
# En la misma red, los contenedores se comunican por nombre
docker network create red-apps

docker container run -d --name backend --network red-apps my-api
docker container run -d --name frontend --network red-apps my-web

# Desde frontend, se accede a backend por nombre: http://backend:8080
```

## Limpieza

```bash
# Eliminar todas las redes no utilizadas
docker network prune
```

## Ver también

- [Comandos de contenedores](comandos-docker.md)
- [Comandos de volúmenes](comandos-volumenes-docker.md)
