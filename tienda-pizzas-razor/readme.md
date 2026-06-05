# Tienda Pizzas Razor

Aplicación ASP.NET Core Razor Pages desplegada con Docker.

> **Nota:** Este Dockerfile está preparado para .NET 9.0. Ajusta la versión según tu proyecto.

## Estructura

```
tienda-pizzas-razor/
└── tienda-pizzas-razor.yml   # Dockerfile para la aplicación
```

## Despliegue

### Construir la imagen

```bash
cd tienda-pizzas-razor

# Copiar el Dockerfile a la raíz de tu proyecto .NET
docker image build -t tienda-pizzas:1.0 -f tienda-pizzas-razor.yml .
```

### Ejecutar el contenedor

```bash
docker container run -d \
  --name tienda-pizzas \
  -p 5000:80 \
  tienda-pizzas:1.0
```

### Con variable de entorno

```bash
docker container run -d \
  --name tienda-pizzas \
  -p 5000:80 \
  -e ASPNETCORE_ENVIRONMENT=Production \
  tienda-pizzas:1.0
```

## Puerto

| Servicio | Puerto | Descripción |
|----------|--------|-------------|
| ASP.NET | 5000 → 80 | Aplicación web |

## Acceso

Una vez desplegado, accede a: **http://localhost:5000**

## Configuración

### Variables de entorno comunes

| Variable | Descripción |
|----------|-------------|
| `ASPNETCORE_ENVIRONMENT` | Entorno: Development, Staging, Production |
| `ASPNETCORE_URLS` | URLs de escucha (default: `http://+:80`) |
| `ConnectionStrings__DefaultConnection` | Cadena de conexión a BD |

### Multi-stage build

El Dockerfile utiliza dos etapas:

1. **Build** (`sdk:9.0`): Restaura dependencias y compila la aplicación
2. **Runtime** (`aspnet:9.0`): Ejecuta la aplicación con una imagen reducida

Esto reduce significativamente el tamaño de la imagen final.

## Comandos útiles

```bash
# Ver logs
docker logs -f tienda-pizzas

# Verificar estado
docker ps -f "name=tienda-pizzas"

# Entrar al shell
docker exec -it tienda-pizzas bash

# Reiniciar
docker restart tienda-pizzas
```

## Personalización

Para usar este Dockerfile con tu proyecto:

1. Copia `tienda-pizzas-razor.yml` a la raíz de tu proyecto
2. Renómbralo a `Dockerfile`
3. Ajusta la versión de .NET si es necesario
4. Modifica el `ENTRYPOINT` con el nombre de tu ensamblado:

```dockerfile
ENTRYPOINT ["dotnet", "MiProyecto.dll"]
```

## Notas

- La imagen base `aspnet:9.0` solo contiene el runtime de ASP.NET
- Si necesitas instalar paquetes adicionales, agrega los comandos `RUN` en la etapa de build
- Para aplicaciones con base de datos, usa Docker Compose para orquestar ambos contenedores
