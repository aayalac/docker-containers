# Comandos de registros Docker

Referencia de comandos para administrar registros de imágenes (registries).

**Sintaxis:** `docker registry [comando]`

## Comandos

| Comando | Descripción |
|---------|-------------|
| `docker registry events` | Listar eventos del registro |
| `docker registry history` | Mostrar historial de imágenes |
| `docker registry info` | Mostrar información del registro |
| `docker registry inspect` | Inspeccionar imágenes del registro |
| `docker registry joblogs` | Mostrar logs de trabajos del registro |
| `docker registry jobs` | Listar trabajos del registro |
| `docker registry ls` | Listar imágenes del registro |
| `docker registry rmi` | Eliminar una imagen del registro |

## Ejemplos

### Listar imágenes en un registro

```bash
# Listar imágenes en Docker Hub
docker registry ls

# Inspeccionar una imagen remota
docker registry inspect library/nginx
```

### Gestionar registros privados

```bash
# Iniciar sesión en un registro privado
docker login mi-registry.example.com

# Etiquetar imagen para registro privado
docker image tag mi-app:1.0 mi-registry.example.com/mi-app:1.0

# Subir al registro privado
docker image push mi-registry.example.com/mi-app:1.0
```

### Registros populares

| Registro | URL | Descripción |
|----------|-----|-------------|
| Docker Hub | `docker.io` | Registro público por defecto |
| GitHub Container Registry | `ghcr.io` | Integrado con GitHub |
| Amazon ECR | `*.dkr.ecr.*.amazonaws.com` | AWS Elastic Container Registry |
| Azure Container Registry | `*.azurecr.io` | Azure Container Registry |
| Google Container Registry | `gcr.io` | Google Cloud Platform |

## Ver también

- [Comandos de imágenes](comandos-imagenes-docker.md)
- [Docker Compose](docker-compose.md)
