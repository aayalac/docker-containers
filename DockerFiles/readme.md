# DockerFiles

Plantillas genéricas de Dockerfiles y configuraciones de Kubernetes.

## Archivos

### DOCKERFILE

Plantilla multi-stage para aplicaciones .NET:

```
DockerFiles/
├── DOCKERFILE           # Dockerfile para aplicaciones .NET Core/5+
└── Deployment.yaml      # Plantilla de Deployment para Kubernetes
```

## Dockerfile (.NET)

### Estructura

El Dockerfile usa dos etapas de compilación:

```dockerfile
# Etapa 1: Build
FROM mcr.microsoft.com/sdk:10.0 AS build-env
WORKDIR /src
COPY . ./
RUN dotnet restore
RUN dotnet publish -c Release -o publish

# Etapa 2: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:10.0
WORKDIR /app
COPY --from=build-env /src/publish ./
ENTRYPOINT ["dotnet", "WebApiNetCore.dll"]
```

### Uso

```bash
# Desde la raíz del proyecto .NET
docker image build -t mi-api:1.0 -f DockerFiles/DOCKERFILE .

# Ejecutar
docker container run -d -p 8080:8080 --name mi-api mi-api:1.0
```

### Personalización

1. Ajusta la versión de .NET (`10.0` por la que necesites)
2. Cambia `WebApiNetCore.dll` por el nombre de tu ensamblado
3. Si tu proyecto tiene submódulos, ajusta los comandos `COPY`

### Variables de entorno útiles

| Variable | Descripción |
|----------|-------------|
| `ASPNETCORE_ENVIRONMENT` | Entorno de ejecución |
| `ASPNETCORE_URLS` | URLs de escucha |

## Deployment.yaml (Kubernetes)

Plantilla básica de Deployment para Kubernetes.

### Personalización

Reemplaza los placeholders:
- `<Image>`: Nombre de tu imagen Docker (ej: `mi-api:1.0`)
- `<Port>`: Puerto de tu aplicación (ej: `8080`)

### Uso

```bash
# Aplicar el deployment
kubectl apply -f DockerFiles/Deployment.yaml

# Verificar estado
kubectl get pods
kubectl get deployments
```

### Especificaciones

| Recurso | Límite |
|---------|--------|
| CPU | 500m (0.5 cores) |
| Memoria | 128Mi |

> Ajusta los límites de recursos según las necesidades de tu aplicación.
