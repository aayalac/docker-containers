# ConfigMaps en Kubernetes

Guía completa para configurar aplicaciones usando ConfigMaps.

## ¿Qué es un ConfigMap?

Un ConfigMap es un objeto de Kubernetes que almacena datos de configuración no sensibles como pares clave-valor. Permite desacoplar la configuración de las imágenes de contenedor.

**Usos comunes:**
- Variables de entorno
- Archivos de configuración
- Scripts de shell
- Certificados (no sensibles)

## Crear ConfigMaps

### Desde la línea de comandos

```bash
# Valor individual
kubectl create configmap mi-config --from-literal=APP_ENV=production

# Múltiples valores
kubectl create configmap mi-config \
  --from-literal=APP_ENV=production \
  --from-literal=APP_PORT=3000 \
  --from-literal=DB_HOST=localhost
```

### Desde un archivo

```bash
# Archivo de propiedades
kubectl create configmap mi-config --from-file=config.properties

# Archivo específico con clave personalizada
kubectl create configmap mi-config --from-file=configuracion=config.properties
```

### Desde un directorio

```bash
# Todos los archivos del directorio como claves
kubectl create configmap mi-config --from-file=configs/
```

### Desde YAML (declarativo)

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: mi-config
  namespace: default
data:
  APP_ENV: "production"
  APP_PORT: "3000"
  DB_HOST: "mysql-service"
  config.json: |
    {
      "debug": false,
      "logLevel": "info"
    }
  nginx.conf: |
    server {
      listen 80;
      server_name localhost;
    }
```

Aplicar:

```bash
kubectl apply -f configmap.yaml
```

## Usar ConfigMaps

### Como variable de entorno

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mi-app
spec:
  selector:
    matchLabels:
      app: mi-app
  template:
    metadata:
      labels:
        app: mi-app
    spec:
      containers:
      - name: mi-app
        image: mi-app:1.0
        envFrom:
        - configMapRef:
            name: mi-config
```

### Variables individuales

```yaml
spec:
  containers:
  - name: mi-app
    image: mi-app:1.0
    env:
    - name: APP_ENV
      valueFrom:
        configMapKeyRef:
          name: mi-config
          key: APP_ENV
    - name: APP_PORT
      valueFrom:
        configMapKeyRef:
          name: mi-config
          key: APP_PORT
```

### Como archivo montado

```yaml
spec:
  containers:
  - name: mi-app
    image: mi-app:1.0
    volumeMounts:
    - name: config-volume
      mountPath: /app/config
  volumes:
  - name: config-volume
    configMap:
      name: mi-config
```

### Archivo específico del ConfigMap

```yaml
spec:
  containers:
  - name: mi-app
    image: mi-app:1.0
    volumeMounts:
    - name: nginx-config
      mountPath: /etc/nginx/nginx.conf
      subPath: nginx.conf
  volumes:
  - name: nginx-config
    configMap:
      name: mi-config
      items:
      - key: nginx.conf
        path: nginx.conf
```

## Ejemplos prácticos

### Ejemplo 1: Variables de entorno para Node.js

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  NODE_ENV: "production"
  PORT: "3000"
  DB_HOST: "mysql-service"
  DB_PORT: "3306"
  DB_NAME: "mi_base_datos"
  REDIS_URL: "redis://redis-service:6379"
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mi-api
spec:
  selector:
    matchLabels:
      app: mi-api
  template:
    metadata:
      labels:
        app: mi-api
    spec:
      containers:
      - name: mi-api
        image: mi-api:1.0
        envFrom:
        - configMapRef:
            name: app-config
```

### Ejemplo 2: Configuración de Nginx

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: nginx-config
data:
  nginx.conf: |
    server {
        listen 80;
        server_name localhost;

        location / {
            root /usr/share/nginx/html;
            index index.html;
            try_files $uri $uri/ /index.html;
        }

        location /api {
            proxy_pass http://backend:3000;
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection 'upgrade';
        }

        location ~* \.(js|css|png|jpg|jpeg|gif|ico)$ {
            expires 1y;
            add_header Cache-Control "public, immutable";
        }
    }
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
spec:
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 80
        volumeMounts:
        - name: nginx-config
          mountPath: /etc/nginx/conf.d/default.conf
          subPath: nginx.conf
      volumes:
      - name: nginx-config
        configMap:
          name: nginx-config
```

### Ejemplo 3: Múltiples archivos de configuración

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-files
data:
  app.properties: |
    app.name=MiApp
    app.version=1.0
    app.debug=false
  logback.xml: |
    <configuration>
      <appender name="STDOUT" class="ch.qos.logback.core.ConsoleAppender">
        <encoder>
          <pattern>%d{HH:mm:ss.SSS} [%thread] %-5level %logger{36} - %msg%n</pattern>
        </encoder>
      </appender>
      <root level="info">
        <appender-ref ref="STDOUT" />
      </root>
    </configuration>
  init.sh: |
    #!/bin/bash
    echo "Initializing application..."
    mkdir -p /app/logs
    chown -R 1000:1000 /app/logs
    exec "$@"
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mi-app
spec:
  selector:
    matchLabels:
      app: mi-app
  template:
    metadata:
      labels:
        app: mi-app
    spec:
      containers:
      - name: mi-app
        image: mi-app:1.0
        volumeMounts:
        - name: config-files
          mountPath: /app/config
          readOnly: true
        - name: init-script
          mountPath: /docker-entrypoint-initdb.d/init.sh
          subPath: init.sh
      volumes:
      - name: config-files
        configMap:
          name: app-files
          items:
          - key: app.properties
            path: app.properties
          - key: logback.xml
            path: logback.xml
      - name: init-script
        configMap:
          name: app-files
          items:
          - key: init.sh
            path: init.sh
            mode: 0755
```

## Gestión de ConfigMaps

### Ver ConfigMaps

```bash
# Listar todos
kubectl get configmaps

# Ver detalles
kubectl describe configmap mi-config

# Ver contenido
kubectl get configmap mi-config -o yaml
```

### Actualizar ConfigMaps

```bash
# Editar interactivamente
kubectl edit configmap mi-config

# Actualizar desde archivo
kubectl create configmap mi-config --from-file=config.properties --dry-run=client -o yaml | kubectl apply -f -

# Actualizar valor específico
kubectl patch configmap mi-config --type merge -p '{"data":{"APP_ENV":"staging"}}'
```

### Eliminar ConfigMaps

```bash
kubectl delete configmap mi-config
```

## Comportamiento de actualización

Cuando un ConfigMap se actualiza:
- **Variables de entorno:** No se actualizan automáticamente. Se requiere recrear el pod
- **Archivos montados:** Se actualizan automáticamente (con delay de ~1 minuto)

```bash
# Forzar recreación de pods tras cambio de configmap
kubectl rollout restart deployment/mi-app
```

## Buenas prácticas

| Práctica | Descripción |
|----------|-------------|
| No almacenar secretos | Usar Secrets para datos sensibles |
| Usar nombres descriptivos | `app-config`, `nginx-config`, etc. |
| Versionar cambios | Usar `kubectl rollout history` |
| Probar cambios | Usar `--dry-run` antes de aplicar |
| Limitar tamaño | Máximo 1MB por ConfigMap |

## ConfigMap vs Secret

| Característica | ConfigMap | Secret |
|----------------|-----------|--------|
| Datos sensibles | No | Si |
| Codificación | Texto plano | Base64 |
| Uso principal | Configuración general | Credenciales, certificados |
| Tamaño máximo | 1MB | 1MB |

## Ver también

- [Secrets en Kubernetes](secrets-kubernetes.md)
- [Comandos de contenedores](comandos-docker.md)
- [Docker Compose](docker-compose.md)
- [Kubernetes con Minikube](minikube(Kubernetes).md)
