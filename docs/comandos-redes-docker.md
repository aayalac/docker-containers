# Comandos para administrar redes de Docker

Se pueden ejecutar desde el CLI:

Uso: **[docker][network][comando]**

- Permite conectar un contenedor a una red.
     ```bash
    docker network connect
    ```
- Permite crear una red.
     ```bash
    docker network create
    ```
- Permite desconectar un contenedor de una red.
     ```bash
    docker network disconnect
    ```
- Permite mostrar información detallada de las redes.
     ```bash
    docker network inspect
    ```
- Permite listar las redes.
     ```bash
    docker network ls
    ```
- Permite eliminar las redes no utilizadas.
     ```bash
    docker network prune
    ```
- Permite remover una red.
     ```bash
    docker network rm
    ```