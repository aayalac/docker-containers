# Contenedores Docker

Repositorio de contenedores Docker para infraestructura y despliegue de aplicaciones.

## Estructura del proyecto

```
docker-containers/
├── app-demo/               # API REST Node.js (prueba)
├── docker-apache/          # Servidor web Apache
├── sqlserver-develop/      # SQL Server Developer Edition
├── tienda-pizzas-razor/    # Aplicación ASP.NET Razor Pages
├── DockerFiles/            # Plantillas genéricas de Dockerfiles y Kubernetes
├── docs/                   # Documentación de comandos Docker
└── readme.md
```

## Contenedores

| Contenedor | Puerto | Descripción |
|------------|--------|-------------|
| [App Demo](app-demo/) | 3000 | API REST Node.js con Express |
| [Apache](docker-apache/) | 8081 | Servidor web Apache con HTML estático |
| [SQL Server](sqlserver-develop/) | 1433 | Base de datos SQL Server Developer |
| [Tienda Pizzas](tienda-pizzas-razor/) | - | Aplicación ASP.NET Razor Pages |

## Inicio rápido

### Docker Compose (recomendado)

Cada contenedor incluye un archivo `.yml` para Docker Compose:

```bash
# App Demo (Node.js)
cd app-demo
docker compose up -d

# Apache
cd docker-apache
docker compose up -d

# SQL Server
cd sqlserver-develop
docker compose up -d
```

### Scripts de despliegue

Alternativamente, cada carpeta incluye un script `.sh` para automatizar el despliegue:

```bash
# Dar permisos de ejecución
chmod +x app-demo/deploy.sh
chmod +x docker-apache/deploy-apache.sh
chmod +x sqlserver-develop/deploy_mssql.sh

# Ejecutar
./app-demo/deploy.sh
./docker-apache/deploy-apache.sh
./sqlserver-develop/deploy_mssql.sh
```

### Dockerfile genérico (aplicaciones .NET)

El archivo [`DockerFiles/DOCKERFILE`](DockerFiles/DOCKERFILE) contiene una plantilla multi-stage para aplicaciones .NET:

```bash
docker image build -t mi-app:1.0 -f DockerFiles/DOCKERFILE .
docker container run -d -p 8080:8080 --name mi-app mi-app:1.0
```

## Documentación

### Comandos Docker

- [Comandos de contenedores](docs/comandos-docker.md)
- [Comandos de imágenes](docs/comandos-imagenes-docker.md)
- [Comandos de redes](docs/comandos-redes-docker.md)
- [Comandos de volúmenes](docs/comandos-volumenes-docker.md)
- [Comandos de registros](docs/comandos-registros-docker.md)

### Guías

- [Docker Compose](docs/docker-compose.md)
- [Despliegue de imágenes .NET](docs/desplegar-imagenes-docker.md)

### Kubernetes

- [Kubernetes con Minikube](docs/minikube(Kubernetes).md)
- [ConfigMaps](docs/configmaps-kubernetes.md)
- [Secrets](docs/secrets-kubernetes.md)

## Requisitos previos

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (Windows/Mac) o Docker Engine (Linux)
- [Docker Compose](https://docs.docker.com/compose/install/) (incluido en Docker Desktop)
- Para scripts `.sh`: bash o WSL en Windows

## Licencia

Proyecto privado.
