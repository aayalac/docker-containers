# SQL Server Developer

SQL Server 2022 Developer Edition desplegado con Docker Compose.

> **Nota:** La edición Developer es gratuita para desarrollo y pruebas. No está permitida en producción.

## Estructura

```
sqlserver-develop/
├── sqlserver-develop.yml   # Archivo de Docker Compose
└── deploy_mssql.sh         # Script de despliegue automatizado
```

## Configuración

| Parámetro | Valor |
|-----------|-------|
| Imagen | `mcr.microsoft.com/mssql/server:2022-latest` |
| Contenedor | `sqlserver-dev` |
| Puerto | 1433 |
| Usuario SA | `sa` |
| Contraseña SA | `Contraseña` |
| Licencia | Developer |
| CPU | 2 cores |
| Memoria | 2 GB |

## Puertos

| Servicio | Puerto | Descripción |
|----------|--------|-------------|
| SQL Server | 1433 | Conexión TDS |

## Despliegue

### Opción 1: Docker Compose

```bash
cd sqlserver-develop
docker compose up -d
```

### Opción 2: Script de despliegue

```bash
cd sqlserver-develop
chmod +x deploy_mssql.sh
./deploy_mssql.sh
```

El script ejecuta automáticamente:
1. Elimina el contenedor existente si hay uno
2. Crea los directorios de datos con permisos correctos
3. Despliega el nuevo contenedor
4. Verifica el estado
5. Realiza un test de conexión

### Opción 3: Manual

```bash
docker run -e "ACCEPT_EULA=Y" \
  -e "SA_PASSWORD=Contraseña" \
  -e "MSSQL_PID=Developer" \
  -p 1433:1433 \
  --name sqlserver-dev \
  --memory="2g" --cpus="2" \
  --restart unless-stopped \
  -d mcr.microsoft.com/mssql/server:2022-latest
```

## Volumenes

| Host | Contenedor | Descripción |
|------|------------|-------------|
| `/mnt/data/var/lib/docker/volumes/sqlserver_data` | `/var/opt/mssql` | Datos principales |
| `/mnt/data/var/lib/docker/volumes/sqlserver_system` | `/var/opt/mssql/.system` | Archivos del sistema |
| `/mnt/data/var/lib/docker/volumes/sqlserver_log` | `/log` | Logs del servidor |

## Conexión

### Con sqlcmd

```bash
sqlcmd -S localhost -U sa -P "Contraseña" -Q "SELECT @@VERSION"
```

### Con Azure Data Studio / SSMS

- **Server:** `localhost,1433`
- **Login:** `sa`
- **Password:** `Contraseña`

### Con .NET (Connection String)

```
Server=localhost,1433;Database=master;User Id=sa;Password=Contraseña;TrustServerCertificate=True;
```

## Comandos útiles

```bash
# Ver logs
docker logs -f sqlserver-dev

# Verificar estado
docker ps -f "name=sqlserver-dev"

# Entrar al shell
docker exec -it sqlserver-dev bash

# Conectar con sqlcmd desde el contenedor
docker exec -it sqlserver-dev /opt/mssql-tools/bin/sqlcmd \
  -S localhost -U sa -P "Contraseña"
```

## Variables de entorno

| Variable | Descripción |
|----------|-------------|
| `ACCEPT_EULA` | Acepta la licencia de Microsoft (requerido) |
| `SA_PASSWORD` | Contraseña del usuario SA |
| `MSSQL_PID` | Tipo de licencia: Developer, Express, Standard, Enterprise |

> **Importante:** La contraseña SA debe cumplir con la política de complejidad: mínimo 8 caracteres, incluir mayúsculas, minúsculas, números y caracteres especiales.
