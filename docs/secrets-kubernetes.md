# Secrets en Kubernetes

Guía completa para gestionar datos sensibles usando Secrets.

## ¿Qué es un Secret?

Un Secret es un objeto de Kubernetes que almacena datos sensibles como contraseñas, tokens, llaves API o certificados. Los datos se almacenan codificados en Base64.

> **Importante:** Los Secrets no están encriptados por defecto. Para mayor seguridad, habilitar encriptación en reposo o usar soluciones como Vault.

## Crear Secrets

### Desde la línea de comandos

```bash
# Valor individual
kubectl create secret generic mi-secret --from-literal=PASSWORD=mi_password

# Múltiples valores
kubectl create secret generic mi-secret \
  --from-literal=USERNAME=admin \
  --from-literal=PASSWORD=mi_password \
  --from-literal=API_KEY=abc123
```

### Desde un archivo

```bash
# Archivo de propiedades
kubectl create secret generic mi-secret --from-file=credentials.properties

# Archivo TLS
kubectl create secret tls mi-tls --cert=tls.crt --key=tls.key

# Archivo Docker Registry
kubectl create secret docker-registry regcred \
  --docker-server=registry.example.com \
  --docker-username=usuario \
  --docker-password=password
```

### Desde YAML (declarativo)

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: mi-secret
type: Opaque
data:
  USERNAME: YWRtaW4=          # base64 de "admin"
  PASSWORD: bWlfcGFzc3dvcmQ=  # base64 de "mi_password"
  API_KEY: YWJjMTIz            # base64 de "abc123"
```

Generar valores Base64:

```bash
echo -n "admin" | base64
# Output: YWRtaW4=

echo -n "mi_password" | base64
# Output: bWlfcGFzc3dvcmQ=
```

## Usar Secrets

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
        - secretRef:
            name: mi-secret
```

### Variables individuales

```yaml
spec:
  containers:
  - name: mi-app
    image: mi-app:1.0
    env:
    - name: DB_PASSWORD
      valueFrom:
        secretKeyRef:
          name: mi-secret
          key: PASSWORD
```

### Como archivo montado

```yaml
spec:
  containers:
  - name: mi-app
    image: mi-app:1.0
    volumeMounts:
    - name: secret-volume
      mountPath: /app/secrets
      readOnly: true
  volumes:
  - name: secret-volume
    secret:
      secretName: mi-secret
```

## Tipos de Secret

| Tipo | Descripción |
|------|-------------|
| `Opaque` | Datos generales codificados en Base64 |
| `kubernetes.io/tls` | Certificados TLS (tls.crt, tls.key) |
| `kubernetes.io/dockerconfigjson` | Credenciales de Docker Registry |
| `kubernetes.io/basic-auth` | Autenticación básica |
| `kubernetes.io/ssh-auth` | Llaves SSH |

## Ejemplos prácticos

### Ejemplo 1: Credenciales de base de datos

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: db-credentials
type: Opaque
data:
  DB_USERNAME: YWRtaW4=
  DB_PASSWORD: c3VwZXJfc2VjcmV0
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
        env:
        - name: DB_USERNAME
          valueFrom:
            secretKeyRef:
              name: db-credentials
              key: DB_USERNAME
        - name: DB_PASSWORD
          valueFrom:
            secretKeyRef:
              name: db-credentials
              key: DB_PASSWORD
```

### Ejemplo 2: TLS para Ingress

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: tls-secret
type: kubernetes.io/tls
data:
  tls.crt: |
    LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0t...
  tls.key: |
    LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0t...
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: mi-ingress
spec:
  tls:
  - hosts:
    - mi-app.example.com
    secretName: tls-secret
  rules:
  - host: mi-app.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: mi-service
            port:
              number: 80
```

### Ejemplo 3: Docker Registry

```bash
# Crear secret para registry privado
kubectl create secret docker-registry regcred \
  --docker-server=registry.example.com \
  --docker-username=usuario \
  --docker-password=password \
  --docker-email=usuario@ejemplo.com
```

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mi-app
spec:
  template:
    spec:
      containers:
      - name: mi-app
        image: registry.example.com/mi-app:1.0
      imagePullSecrets:
      - name: regcred
```

## Gestión de Secrets

### Ver Secrets

```bash
# Listar
kubectl get secrets

# Ver detalles
kubectl describe secret mi-secret

# Ver contenido (decodificado)
kubectl get secret mi-secret -o jsonpath='{.data.PASSWORD}' | base64 -d
```

### Actualizar Secrets

```bash
# Editar interactivamente
kubectl edit secret mi-secret

# Actualizar desde archivo
kubectl create secret generic mi-secret --from-file=credentials.properties --dry-run=client -o yaml | kubectl apply -f -
```

### Eliminar Secrets

```bash
kubectl delete secret mi-secret
```

## Buenas prácticas

| Práctica | Descripción |
|----------|-------------|
| No commitear secrets | Usar `.gitignore` para archivos sensibles |
| Usar RBAC | Controlar acceso a Secrets |
| Rotar secrets | Cambiar credenciales periódicamente |
| Encriptación en reposo | Habilitar encryption at rest |
| Usar Vault | Para producción, considerar HashiCorp Vault |

## ConfigMap vs Secret

| Característica | ConfigMap | Secret |
|----------------|-----------|--------|
| Datos sensibles | No | Si |
| Codificación | Texto plano | Base64 |
| Uso principal | Configuración general | Credenciales, certificados |
| Tamaño máximo | 1MB | 1MB |

## Ver también

- [ConfigMaps](configmaps-kubernetes.md)
- [Kubernetes con Minikube](minikube(Kubernetes).md)
- [Docker Compose](docker-compose.md)
