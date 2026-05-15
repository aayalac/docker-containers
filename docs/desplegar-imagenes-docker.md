# Comandos para desplegar las imagenes compiladas desde aplicaciones .NET Core

Se pueden ejecutar desde el CLI, ya sea de Windows o Linux:
---
- Despliegua la imagen desde el proyecto de la solución.
```bash
docker image build -t [Nombre_APP]:1.0.0 -f "Dockerfile" .
```
- Genera el contenedor a partir del ID de la imagen generada.
```bash
docker container run -d -p [Puerto_personalizado]:8080 --name [mi-docker-app] [ID_IMAGEN]
```