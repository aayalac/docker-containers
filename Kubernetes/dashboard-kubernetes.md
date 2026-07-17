# Instalación y Gestión del Panel de Kubernetes (Dashboard)

## Objetivo

Esta guía documenta la instalación del **Kubernetes Dashboard** utilizando **Helm**, así como la creación de un usuario administrador y el acceso seguro al panel web.

> **Entorno**
>
> - Ubuntu 24.04 LTS
> - WSL2
> - Docker Engine
> - Kind
> - Kubernetes (kubectl)
> - Cluster previamente creado

---

# Introducción

A partir de la versión **7.x**, el proyecto **Kubernetes Dashboard** eliminó la instalación mediante archivos YAML (`recommended.yaml`).

Actualmente la instalación oficial se realiza mediante **Helm**.

Además, el Dashboard **no se expone públicamente**, sino que se accede mediante un **Port Forward** y autenticación utilizando un **Service Account Token**.

---

# Arquitectura

```text
                     kubectl
                        │
                        │
                Port Forward (8443)
                        │
                        ▼
             Kubernetes Dashboard
                        │
                        ▼
               Kubernetes API Server
                        │
                        ▼
                    Kubernetes Cluster
```

---

# Requisitos

Verificar que el clúster esté funcionando:

```bash
kubectl cluster-info
```

Verificar los nodos:

```bash
kubectl get nodes
```

---

# 1. Instalar Helm

Verificar si Helm ya está instalado:

```bash
helm version
```

Si no está instalado:

```bash
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
```

Verificar nuevamente:

```bash
helm version
```

---

# 2. Agregar el repositorio del Dashboard

```bash
helm repo add kubernetes-dashboard https://kubernetes-retired.github.io/dashboard/
```

Actualizar los repositorios:

```bash
helm repo update
```

---

# 3. Instalar Kubernetes Dashboard

```bash
helm upgrade --install kubernetes-dashboard \
    kubernetes-dashboard/kubernetes-dashboard \
    --create-namespace \
    --namespace kubernetes-dashboard
```

---

# 4. Verificar la instalación

Ver los Pods:

```bash
kubectl get pods -n kubernetes-dashboard
```

Ver los Services:

```bash
kubectl get svc -n kubernetes-dashboard
```

Ver todos los recursos:

```bash
kubectl get all -n kubernetes-dashboard
```

---

# 5. Crear un usuario administrador

Crear el archivo:

```text
dashboard-admin.yaml
```

Contenido:

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard

---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user

roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin

subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kubernetes-dashboard
```

Aplicar la configuración:

```bash
kubectl apply -f dashboard-admin.yaml
```

Verificar:

```bash
kubectl get serviceaccounts -n kubernetes-dashboard
```

---

# 6. Obtener el Token

Generar el token de acceso:

```bash
kubectl -n kubernetes-dashboard create token admin-user
```

Obtendrás un JWT similar a:

```text
eyJhbGciOiJSUzI1NiIsImtpZCI6...
```

Guarda este token, ya que será utilizado para iniciar sesión.

---

# 7. Abrir el Dashboard

Crear el Port Forward:

```bash
kubectl -n kubernetes-dashboard port-forward svc/kubernetes-dashboard-kong-proxy 8443:443
```

Salida esperada:

```text
Forwarding from 127.0.0.1:8443 -> 8443
```

---

# 8. Acceder desde el navegador

Abrir:

```text
https://localhost:8443
```

El navegador mostrará un aviso de certificado autofirmado.

Seleccionar:

**Continuar al sitio**.

---

# 9. Iniciar sesión

Seleccionar:

```
Token
```

Pegar el JWT generado anteriormente.

Ingresar.

---

# Administración del Dashboard

## Ver Pods

```bash
kubectl get pods -A
```

---

## Ver Deployments

```bash
kubectl get deployments -A
```

---

## Ver Services

```bash
kubectl get svc -A
```

---

## Ver Namespaces

```bash
kubectl get ns
```

---

## Ver ConfigMaps

```bash
kubectl get configmaps -A
```

---

## Ver Secrets

```bash
kubectl get secrets -A
```

---

## Ver eventos

```bash
kubectl get events -A
```

---

## Ver el Dashboard instalado

```bash
helm list -A
```

---

## Ver el Release

```bash
helm status kubernetes-dashboard -n kubernetes-dashboard
```

---

# Actualizar el Dashboard

Actualizar los repositorios:

```bash
helm repo update
```

Actualizar el release:

```bash
helm upgrade kubernetes-dashboard \
    kubernetes-dashboard/kubernetes-dashboard \
    -n kubernetes-dashboard
```

---

# Desinstalar el Dashboard

Eliminar el Release:

```bash
helm uninstall kubernetes-dashboard -n kubernetes-dashboard
```

Eliminar el Namespace:

```bash
kubectl delete namespace kubernetes-dashboard
```

---

# Solución de problemas

## Error 403

```json
{
  "message": "User \"system:anonymous\" cannot get path \"/\""
}
```

### Causa

Se está intentando acceder directamente al API Server desde el navegador.

El navegador no utiliza las credenciales almacenadas en:

```text
~/.kube/config
```

### Solución

Acceder siempre mediante:

- Port Forward
- Dashboard
- Token de autenticación

---

## Verificar el contexto actual

```bash
kubectl config current-context
```

Resultado esperado:

```text
kind-desarrollo
```

---

## Verificar el estado del clúster

```bash
kubectl cluster-info
```

---

## Verificar los nodos

```bash
kubectl get nodes
```

---

# Flujo de trabajo recomendado

```text
Docker
    │
    ▼
Kind
    │
    ▼
Cluster Kubernetes
    │
    ▼
Helm
    │
    ▼
Dashboard
    │
    ▼
kubectl
    │
    ▼
Administración del Cluster
```

---

# Próximos pasos recomendados

Con el Dashboard instalado, el siguiente orden de aprendizaje es:

1. Crear el primer Pod.
2. Crear un Deployment.
3. Escalar réplicas.
4. Crear un Service.
5. Crear un ConfigMap.
6. Crear un Secret.
7. Configurar un Ingress.
8. Implementar almacenamiento persistente.
9. Desplegar una API ASP.NET Core.
10. Desplegar SQL Server sobre Kubernetes.

---

# Conclusión

El Dashboard proporciona una interfaz gráfica para administrar un clúster de Kubernetes y complementa el uso de `kubectl`. En un entorno de desarrollo basado en **WSL + Docker + Kind**, constituye una herramienta útil para visualizar recursos, revisar el estado del clúster y comprender la organización de los objetos de Kubernetes mientras se adquiere experiencia con la administración mediante línea de comandos.