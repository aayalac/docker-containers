# Comandos para administrar imagenes de Docker

Se pueden ejecutar desde el CLI:

Uso: **[docker][image][comando]**

- Construye una imagen desde un Dockerfile.
     ```bash
    docker image Build
    ```
- Mostrar el historial de una imagen.
     ```bash
    docker image history
    ```
- Mostrar informacion detallada de una imagen.
     ```bash
    docker image inspect
    ```
- Listar imágenes.
     ```bash
    docker image ls
    ```
- Elimina imágenes no utilizadas.
     ```bash
    docker image prune
    ```
- Obtener uan imagen desde un repositorio.
     ```bash
    docker image pull
    ```
- Enviar una imagen a un repositorio.
     ```bash
    docker image push
    ```
- Eliminar imágenes.
     ```bash
    docker image rm
    ```
- Crear una etiqueta en la imagen.
     ```bash
    docker image tag
    ```