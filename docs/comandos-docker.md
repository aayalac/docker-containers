# Comandos para administrar Docker

Se pueden ejecutar desde el CLI:

Uso: **[docker][container][comando]**

- Elimina todos los contenedores detenidos.
     ```bash
    docker container prune
    ```
- Renombrar un contenedor.
     ```bash
    docker container rename
    ```
- Reiniciar un contenedor.
     ```bash
    docker container restart
    ```
- Eliminar un contenedor
     ```bash
    docker container rm
    ```
- Ejecutar un comando en un nuevo contenedor.
     ```bash
    docker container run
    ```
- Inicia un contenedor detenido.
     ```bash
    docker container start
    ```
- Muestra estadisticas en vivo del uso de recursos.
     ```bash
    docker container stats
    ```
- Detener un contenedor.
     ```bash
    docker container stop
    ```
- Mostrar procesos en ejecución de un contenedor.
     ```bash
    docker container top
    ```