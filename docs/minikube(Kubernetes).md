# Kubernetes con Minikube

Guía básica de comandos para gestionar clústeres de Kubernetes usando Minikube.

## Instalación

```bash
# Windows (con Chocolatey)
choco install minikube

# macOS (con Homebrew)
brew install minikube

# Linux
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
```

## Comandos de Minikube

| Comando | Descripción |
|---------|-------------|
| `minikube start` | Iniciar clúster local |
| `minikube stop` | Detener clúster |
| `minikube delete` | Eliminar clúster |
| `minikube status` | Ver estado del clúster |
| `minikube dashboard` | Abrir dashboard web |

## Comandos de kubectl

| Comando | Descripción |
|---------|-------------|
| `kubectl get all` | Ver todos los recursos |
| `kubectl get pods` | Ver pods |
| `kubectl get services` | Ver servicios |
| `kubectl get deployments` | Ver deployments |
| `kubectl describe [recurso]` | Ver detalles de un recurso |
| `kubectl logs [pod]` | Ver logs de un pod |
| `kubectl exec -it [pod] -- bash` | Entrar a un pod |
| `kubectl apply -f [archivo]` | Aplicar configuración |
| `kubectl delete -f [archivo]` | Eliminar recursos |

## Ejemplos

### Iniciar clúster

```bash
# Iniciar Minikube
minikube start

# Iniciar con más recursos
minikube start --cpus=4 --memory=8192

# Verificar estado
minikube status
```

### Desplegar aplicación

```bash
# Aplicar un deployment
kubectl apply -f DockerFiles/Deployment.yaml

# Ver pods
kubectl get pods

# Ver servicios
kubectl get services

# Ver logs
kubectl logs -l app=myapp
```

### Gestionar recursos

```bash
# Ver todos los recursos en un namespace
kubectl get all -n default

# Ver recursos en un namespace específico
kubectl get all -n backend

# Describir un pod
kubectl describe pod [nombre-pod]

# Eliminar un deployment
kubectl delete deployment myapp
```

### Acceder a servicios

```bash
# Obtener URL de un servicio
minikube service mi-servicio --url

# Abrir servicio en el navegador
minikube service mi-servicio
```

### Dashboard

```bash
# Abrir el dashboard de Kubernetes
minikube dashboard
```

## Ver también

- [Docker Compose](docker-compose.md)
- [DockerFiles](../DockerFiles/readme.md)
