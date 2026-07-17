# Guía de Instalación y Gestión de Kind (Kubernetes IN Docker)

## Objetivo

Esta guía documenta la instalación de **Kind (Kubernetes IN Docker)** y las operaciones más comunes para administrar un clúster local de Kubernetes utilizando Docker.

> **Entorno**
>
> - Ubuntu 24.04 LTS
> - WSL2
> - Docker Engine
> - Kubernetes (`kubectl`, `kubeadm` y `kubelet`) previamente instalados

---

# ¿Qué es Kind?

**Kind** (Kubernetes IN Docker) es una herramienta que permite crear un clúster de Kubernetes utilizando contenedores Docker como nodos.

Es la opción recomendada para:

- Desarrollo local
- Aprendizaje de Kubernetes
- Pruebas de aplicaciones
- Integración continua (CI/CD)

---

# Arquitectura

```text
                     Docker Engine
                           │
        ┌──────────────────┴──────────────────┐
        │                                     │
   kind-control-plane                 (Workers opcionales)
        │
        ▼
 Kubernetes Cluster
        │
        ▼
 kubectl administra el clúster
```

---

# 1. Instalar Kind

Descargar el binario oficial:

```bash
curl -Lo ./kind https://kind.sigs.k8s.io/dl/latest/kind-linux-amd64
```

Dar permisos de ejecución:

```bash
chmod +x ./kind
```

Mover el ejecutable:

```bash
sudo mv ./kind /usr/local/bin/
```

---

# 2. Verificar la instalación

```bash
kind version
```

Salida esperada:

```text
kind v0.xx.x
```

---

# 3. Verificar Docker

Kind utiliza Docker para crear el clúster.

```bash
docker version
```

```bash
docker ps
```

---

# 4. Crear un clúster

```bash
kind create cluster --name desarrollo
```

Salida esperada:

```text
Creating cluster "desarrollo" ...
✓ Ensuring node image
✓ Preparing nodes
✓ Writing configuration
✓ Starting control-plane
✓ Installing CNI
✓ Installing StorageClass
Set kubectl context to "kind-desarrollo"
```

---

# 5. Ver los clústeres existentes

```bash
kind get clusters
```

Ejemplo:

```text
desarrollo
```

---

# 6. Verificar el clúster

```bash
kubectl cluster-info
```

Ejemplo:

```text
Kubernetes control plane is running...
CoreDNS is running...
```

---

# 7. Ver los nodos

```bash
kubectl get nodes
```

Ejemplo:

```text
NAME                        STATUS   ROLES           AGE
desarrollo-control-plane    Ready    control-plane   2m
```

---

# 8. Ver todos los Pods

```bash
kubectl get pods -A
```

---

# 9. Ver todos los recursos

```bash
kubectl get all -A
```

---

# Administración de Kubernetes

## Ver Pods

```bash
kubectl get pods
```

Todos los namespaces:

```bash
kubectl get pods -A
```

---

## Ver Deployments

```bash
kubectl get deployments
```

---

## Ver Services

```bash
kubectl get svc
```

---

## Ver Namespaces

```bash
kubectl get ns
```

---

## Ver ConfigMaps

```bash
kubectl get configmaps
```

---

## Ver Secrets

```bash
kubectl get secrets
```

---

## Ver eventos

```bash
kubectl get events
```

---

## Describir un recurso

Ejemplo:

```bash
kubectl describe pod nombre-del-pod
```

---

## Ver logs

```bash
kubectl logs nombre-del-pod
```

---

## Acceder a un contenedor

```bash
kubectl exec -it nombre-del-pod -- bash
```

Si no existe Bash:

```bash
kubectl exec -it nombre-del-pod -- sh
```

---

# Trabajar con archivos YAML

Aplicar recursos:

```bash
kubectl apply -f deployment.yaml
```

Aplicar un directorio completo:

```bash
kubectl apply -f k8s/
```

---

Eliminar recursos:

```bash
kubectl delete -f deployment.yaml
```

---

Ver diferencias:

```bash
kubectl diff -f deployment.yaml
```

---

# Cargar imágenes Docker en Kind

Como Kind utiliza su propio runtime, las imágenes locales deben cargarse manualmente.

Construir la imagen:

```bash
docker build -t mi-api:v1 .
```

Cargarla al clúster:

```bash
kind load docker-image mi-api:v1 --name desarrollo
```

Verificar:

```bash
docker images
```

---

# Gestión del clúster

## Ver los clústeres

```bash
kind get clusters
```

---

## Exportar la configuración

```bash
kubectl config view
```

---

## Ver el contexto actual

```bash
kubectl config current-context
```

Resultado esperado:

```text
kind-desarrollo
```

---

## Cambiar de contexto

```bash
kubectl config use-context kind-desarrollo
```

---

# Eliminar un clúster

```bash
kind delete cluster --name desarrollo
```

---

# Crear un nuevo clúster

```bash
kind create cluster --name laboratorio
```

---

# Comandos útiles

## Ver imágenes del nodo

```bash
docker exec -it desarrollo-control-plane crictl images
```

---

## Ver contenedores Docker

```bash
docker ps
```

---

## Ver redes Docker

```bash
docker network ls
```

---

## Inspeccionar el nodo

```bash
docker inspect desarrollo-control-plane
```

---

# Flujo típico de trabajo

## 1. Construir la aplicación

```bash
docker build -t mi-api:v1 .
```

## 2. Cargar la imagen en Kind

```bash
kind load docker-image mi-api:v1 --name desarrollo
```

## 3. Desplegar la aplicación

```bash
kubectl apply -f deployment.yaml
```

## 4. Verificar el despliegue

```bash
kubectl get deployments
```

```bash
kubectl get pods
```

```bash
kubectl get svc
```

---

# Estructura típica de un proyecto

```text
Proyecto
│
├── Dockerfile
├── docker-compose.yml (opcional)
├── src/
│
└── k8s/
    ├── deployment.yaml
    ├── service.yaml
    ├── ingress.yaml
    ├── configmap.yaml
    └── secret.yaml
```

---

# Recursos principales de Kubernetes

| Recurso | Descripción |
|----------|-------------|
| Pod | Unidad mínima de ejecución. |
| Deployment | Administra Pods y réplicas. |
| ReplicaSet | Mantiene el número deseado de Pods. |
| Service | Expone aplicaciones dentro o fuera del clúster. |
| ConfigMap | Configuración no sensible. |
| Secret | Información sensible (contraseñas, tokens, etc.). |
| Namespace | Organización lógica de recursos. |
| Ingress | Punto de entrada HTTP/HTTPS al clúster. |
| PersistentVolume | Almacenamiento persistente. |
| PersistentVolumeClaim | Solicitud de almacenamiento para un Pod. |

---

# Próximos pasos recomendados

Una vez que el clúster esté funcionando, el siguiente orden de aprendizaje recomendado es:

1. Pods
2. Deployments
3. ReplicaSets
4. Services
5. Namespaces
6. ConfigMaps
7. Secrets
8. PersistentVolumes
9. Ingress
10. Helm
11. Observabilidad (Prometheus + Grafana)

---

# Conclusión

Con **Kind** y **kubectl** es posible disponer de un entorno de Kubernetes completamente funcional para desarrollo local, pruebas y aprendizaje sin necesidad de configurar un clúster completo con `kubeadm`. Esta combinación es ideal para trabajar con aplicaciones .NET, SQL Server y otros servicios ejecutados en contenedores Docker.