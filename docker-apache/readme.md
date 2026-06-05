# Apache Docker

Servidor web Apache HTTP Server 2.4 desplegado con Docker Compose.

## Estructura

```
docker-apache/
├── apache/
│   ├── Dockerfile          # Imagen basada en httpd:2.4
│   ├── conf/
│   │   └── 000-default.conf  # Configuración VirtualHost
│   ├── html/
│   │   └── index.html      # Página de prueba
│   └── logs/               # Logs de Apache (montados como volumen)
├── deploy-apache.sh        # Script de despliegue automatizado
└── docker-compose.yml      # Archivo de Docker Compose
```

## Puertos

| Servicio | Puerto | Descripción |
|----------|--------|-------------|
| Apache | 8081 → 80 | Acceso HTTP |

## Despliegue

### Opción 1: Docker Compose

```bash
cd docker-apache
docker compose up -d
```

### Opción 2: Script de despliegue

```bash
cd docker-apache
chmod +x deploy-apache.sh
./deploy-apache.sh
```

### Opción 3: Manual

```bash
# Construir imagen
docker image build -t apache-server ./apache

# Ejecutar contenedor
docker container run -d \
  --name apache-server \
  -p 8081:80 \
  -v $(pwd)/apache/html:/usr/local/apache2/htdocs \
  -v $(pwd)/apache/conf/000-default.conf:/usr/local/apache2/conf/conf.d/000-default.conf \
  -v $(pwd)/apache/logs:/usr/local/apache2/logs \
  apache-server
```

## Volumenes

| Host | Contenedor | Descripción |
|------|------------|-------------|
| `./apache/html` | `/usr/local/apache2/htdocs` | Contenido web estático |
| `./apache/conf/000-default.conf` | `/usr/local/apache2/conf/conf.d/000-default.conf` | Configuración VirtualHost |
| `./apache/logs` | `/usr/local/apache2/logs` | Logs de Apache |

## Acceso

Una vez desplegado, accede a: **http://localhost:8081**

## Comandos útiles

```bash
# Ver logs en tiempo real
docker logs -f apache-server

# Reiniciar contenedor
docker restart apache-server

# Detener y eliminar
docker stop apache-server && docker rm apache-server

# Entrar al shell del contenedor
docker exec -it apache-server bash
```

## Configuración

El archivo `apache/conf/000-default.conf` define el VirtualHost:

```apache
<VirtualHost *:80>
    DocumentRoot "/usr/local/apache2/htdocs"
    ErrorLog /usr/local/apache2/logs/error.log
    CustomLog /usr/local/apache2/logs/access.log combined
</VirtualHost>
```

Para agregar rutas adicionales o configuraciones, edita este archivo y reinicia el contenedor.
