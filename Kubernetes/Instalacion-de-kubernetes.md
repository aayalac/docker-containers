# Instalación de Kubernetes (kubeadm, kubelet y kubectl) en Ubuntu 24.04 (WSL)

Esta guía documenta la instalación de los componentes principales de Kubernetes utilizando el repositorio oficial.

> **Entorno**
>
> - Ubuntu 24.04 LTS (Noble)
> - WSL2
> - Docker previamente instalado
> - Usuario con privilegios sudo

---

# 1. Actualizar el sistema

```bash
sudo apt update
sudo apt upgrade -y
```

---

# 2. Instalar dependencias

```bash
sudo apt install -y apt-transport-https ca-certificates curl gpg
```

---

# 3. Crear el directorio para las llaves GPG

```bash
sudo mkdir -p -m 755 /etc/apt/keyrings
```

---

# 4. Descargar la llave oficial de Kubernetes

```bash
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key \
| sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
```

---

# 5. Agregar el repositorio oficial

```bash
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /" \
| sudo tee /etc/apt/sources.list.d/kubernetes.list
```

---

# 6. Actualizar la lista de paquetes

```bash
sudo apt update
```

Verifica que aparezca un repositorio similar a:

```
https://pkgs.k8s.io/core:/stable:/v1.31/deb
```

---

# 7. Instalar Kubernetes

```bash
sudo apt install -y kubelet kubeadm kubectl
```

---

# 8. Bloquear la actualización automática (recomendado)

```bash
sudo apt-mark hold kubelet kubeadm kubectl
```

Esto evita que una actualización del sistema cambie automáticamente la versión de Kubernetes, permitiendo realizar las actualizaciones del clúster de forma controlada.

---

# 9. Verificar la instalación

## kubectl

```bash
kubectl version --client
```

## kubeadm

```bash
kubeadm version
```

## kubelet

```bash
kubelet --version
```

También puedes comprobar dónde quedaron instalados:

```bash
which kubectl
which kubeadm
which kubelet
```

---

# 10. Verificar los paquetes instalados

```bash
apt list --installed | grep kube
```

Deberías obtener una salida similar a:

```
kubeadm
kubectl
kubelet
```

---

# 11. Comprobar que los paquetes quedaron bloqueados

```bash
apt-mark showhold
```

Resultado esperado:

```
kubeadm
kubectl
kubelet
```

---

# 12. Desbloquear para futuras actualizaciones

Cuando quieras actualizar Kubernetes:

```bash
sudo apt-mark unhold kubelet kubeadm kubectl
```

Actualizar:

```bash
sudo apt update
sudo apt upgrade
```

Y volver a bloquear:

```bash
sudo apt-mark hold kubelet kubeadm kubectl
```

---

# Estado final esperado

Verifica las versiones:

```bash
kubectl version --client
```

```bash
kubeadm version
```

```bash
kubelet --version
```

Si todos responden correctamente, la instalación ha finalizado con éxito.

---

# Próximos pasos

Una vez instalados los binarios de Kubernetes, el siguiente paso recomendado en un entorno de desarrollo con WSL es crear un clúster local utilizando **Kind (Kubernetes IN Docker)**, ya que aprovecha Docker y evita la complejidad de configurar un clúster completo con `kubeadm` dentro de WSL.