# Contenedores Docker

Cada contenedor en este proyecto se genera utilizando dos scripts:

- **Archivo `.yml`**: Define la configuración del contenedor usando Docker Compose.  
    > **Requisito:** Es necesario tener instalado el plugin de Docker Compose para poder ejecutar este archivo.

- **Archivo `.sh`**: Script de shell para automatizar tareas relacionadas con el contenedor.  
    > **Requisito:** Se debe otorgar permisos de ejecución al archivo usando el comando:  
    ```bash
    chmod +x nombre-del-script.sh
    ```

De esta forma, puedes gestionar y desplegar los contenedores de manera eficiente.