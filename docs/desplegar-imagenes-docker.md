# Comandos para desplegar las imagenes compiladas desde aplicaciones .NET Core

Se pueden ejecutar desde el CLI, ya sea de Windows o Linux:
---
- Despliegua la imagen desde el proyecto de la solución.
```bash
docker image build -t [Nombre_APP]:[Version] -f [RutaArchivoDockerfile] .
```
- Genera el contenedor a partir del ID de la imagen generada.
```bash
docker container run -d --name [nombre] -p [Puerto_personalizado]:8080 --name [nombre-contenedor] [ID_IMAGEN]
```
- Genera el contenedor a partir del ID de la imagen generada con variable de entorno.
```bash
docker container run -d --name [nombre] -p [Puerto_personalizado]:8080 --name -e [variable-de-entorno] [nombre-contenedor] [ID_IMAGEN]
```