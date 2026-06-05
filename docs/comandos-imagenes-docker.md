# Comandos de imágenes Docker

Referencia de comandos para administrar imágenes Docker.

**Sintaxis:** `docker image [comando]`

## Comandos básicos

| Comando | Descripción |
|---------|-------------|
| `docker image build` | Construir una imagen desde un Dockerfile |
| `docker image pull` | Obtener una imagen desde un repositorio |
| `docker image push` | Enviar una imagen a un repositorio |
| `docker image rm` | Eliminar una imagen |
| `docker image tag` | Crear una etiqueta en la imagen |

## Comandos de información

| Comando | Descripción |
|---------|-------------|
| `docker image ls` | Listar imágenes locales |
| `docker image inspect` | Mostrar información detallada de una imagen |
| `docker image history` | Mostrar el historial de capas de una imagen |

## Comandos de mantenimiento

| Comando | Descripción |
|---------|-------------|
| `docker image prune` | Eliminar imágenes no utilizadas |
| `docker image prune -a` | Eliminar todas las imágenes no utilizadas |

## Ejemplos

### Construir una imagen

```bash
# Construir con nombre y versión
docker image build -t mi-app:1.0 -f Dockerfile .

# Construir desde un directorio específico
docker image build -t mi-app:1.0 -f ./docker/Dockerfile ./src
```

### Gestionar imágenes

```bash
# Listar todas las imágenes
docker image ls

# Listar imágenes con más detalle
docker image ls --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"

# Ver el historial de capas
docker image history mi-app:1.0

# Inspeccionar una imagen
docker image inspect mi-app:1.0
```

### Publicar imágenes

```bash
# Etiquetar para un registro
docker image tag mi-app:1.0 usuario/mi-app:1.0

# Iniciar sesión en Docker Hub
docker login

# Subir al registro
docker image push usuario/mi-app:1.0
```

### Limpieza

```bash
# Eliminar imágenes sin uso
docker image prune

# Eliminar todas las imágenes (cuidado)
docker image prune -a

# Eliminar imagen específica
docker image rm mi-app:1.0
```

## Ver también

- [Comandos de contenedores](comandos-docker.md)
- [Despliegue de imágenes .NET](desplegar-imagenes-docker.md)
- [Comandos de registros](comandos-registros-docker.md)
