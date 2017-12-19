# ALASTRIA #

## Requisitos del sistema

Caracteristicas de la máquina:

* **CPU's**: 2

* **Memoria**: 4 Gb

* **Disco duro**: 30 Gb

* **Sistema operativo**: Ubuntu 16.04 64 bits

Es necesario habilitar los siguientes puertos de E/S en la maquina en la que vamos a desplegar el nodo:

* **21000**: TCP/UDP - Puerto para establecer la comunicación entre procesos geth.

* **9000**: TCP - Puerto para la comunicación de Constellation.

* **22000**: TCP - Puerto para establecer la comunicación RPC.

## Instalación de nodo Quorum + Constellation

Para configurar e instalar Quorum y Constellation, debe clonar el repositorio git que indicamos a continuación en el servidor de aplicaciones y ejecutar el siguiente script `scripts/bootstrap.sh`.

```
$ git clone https://github.com/alastria/alastria-node.git
$ cd alastria-node/scripts/
$ sudo -H ./bootstrap.sh
```

## Configuración del nodo
 Es necesario seguir los siguientes pasos para la configuración de los nodos:

1a. **Inicialización de un nuevo nodo**
Para inicializar un nuevo nodo a la red debe ejecutarse el sript init.sh pasando como parámetros la ip del nodo, el tipo de nodo a inicializar (validator o general), y el nombre del nodo que estamos configurando:
	```
	$ ./init.sh <<PUBLIC_IP_HOST_MACHINE>> <<NODE_TYPE>> <<NODE_NAME>>
	```
Por comodidad también puede utilizarse el el parámetro **auto** para detectar automáticamente la IP del nodo de la siguiente forma:
	```
	$ ./init.sh auto <<NODE_TYPE>> <<NODE_NAME>>
	```
Así si queremos inicializar un nodo **validator** ejecutaremos, por ejemplo: 
	```
	$ ./init.sh auto validator <<NODE_NAME>>
	```
Y para ejecutar un nodo **general**:
	```
	$ ./init.sh auto general <<NODE_NAME>>
	```

1b. **Reinicialización de un nodo existente**
Si ya disponemos de un nodo Alastria instalado en la máquina, y deseamos realizar una inicialización limpia del nodo manteniendo nuestro **enode**, nuestras claves constellation y nuestras cuentas actuales, podemos ejecutar:
    ```
	$ ./init.sh backup <<NODE_TYPE>> <<NODE_NAME>>
	```
Este será el procedimiento a seguir por los nodos miembros ante actualizaciones de la infraestructura.

2. **Configuración del fichero de nodos Quorum**

El nodo quorum que estamos desplegando se configura automaticamente con el script de inicialización ejecutado en el paso anterior. Si se ha realizado la inicialización de un nodo nuevo a la red (paso 1a), deberá realizarse un pull request al repositorio `alastria-node` con las modificaciones realizadas por el script `init.sh` en los archivos `data/static-nodes.json`, `data/permissioned-nodes_general.json` y `data/permissioned-nodes_validator.json`.

En función del tipo de nodo inicializado habrán cambiado todos o algunos de estos ficheros.

Además de estos archivos, en el pull request deberá incluirse la actualización del fichero `DIRECTORY.md` incluyendo la información de contacto del nodo, la información del host, la clave del private for de Constellation y el enode del nodo.

Para iniciar el nodo se utilizará el script `start.sh`.

Para los **nodos regulares**, aquí acaba el proceso de configuración. Los **nodos validadores**, por el contrario, deben realizar un paso más. 

Cada uno de los nodos validadores, deben ejecutar el script `restart.sh` con la opción onlyUpdate:
```
$ ./restart.sh onlyUpdate
```

Acto seguido, nos dirigimos a los logs del nodo en `~/alastria/logs/quorum-XXX.log` del nuevo nodo validador en el log aparecerá el siguiente mensaje de error:
```
ERROR[12-19|12:25:05] Failed to decode message from payload    address=0x59d9F63451811C2c3C287BE40a2206d201DC3BfF err="unauthorized address"
```
Esto es debido a que el resto de validadores de la red no han aceptado todavía al nodo como validador. Para ello, debemos enviar el address que aparece en este mensaje de error (`0x59d9F63451811C2c3C287BE40a2206d201DC3BfF`) que debe ser notificada al resto de validadores a través de un pull request, a través de slack u otro medio que informe al resto de administradores de nodos validadores.

Esto provocará una ronda de votación a través del RPC API:

```
> istanbul.propose("0x59d9F63451811C2c3C287BE40a2206d201DC3BfF", true);
```

Así, nuestro nodo estará levantado y sincronizado con la red.

3. **Configuración del fichero de nodos de Constellation**
	El nodo Constellation que estamos desplegando se configura automáticamente con el script de inicialización ejecutado en el paso anterior. 
    En el caso de nodos validadores, no	es necesario ejecutar el constellation.

**NOTA**
En este punto ya tendriamos desplegado un nuevo nodo en la red, que incluiria el despliegue y configuración de Quorum y Constellation.

Si necesitamos desplegar más nodos para nuestra red, es necesario volver a realizar los pasos descritos en el paso 2.

## Arranque de nodo Quorum + Constellation (CAMBIAR)
Una vez instalado y configurado todo ya podemos arrancar nuestro nodo. Para arrancar ejecutamos la siguiente orden:
```
$ ./start.sh
```
Ante errores en el nodo, podemos optar por realizar un reinicio limpio del nodo, para ello debemos ejecutar los siguientes comados:
```
$ ./stop.sh
$ ./start.sh clean
```
Finalmente, disponemos de un script de restart para actualizar y reiniciar el nodo (por ejemplo ante actualizaciones del permissioned-nodes*):
```
$ ./restart.sh onlyUpdate
```
O para reiniciar completamente
el nodo:
```
$ ./restart.sh auto || <<CURRENT_HOST_IP>>
```

## Hacer backups del estado de la blockchain y limpiar el nodo
El script `./scripts/backup.sh` permite realizar copias de seguridad del estado del nodo.
Ejecutando `./scripts/backup.sh keys` se hace una copia de seguridad de las claves
y el enode de nuestro nodo.

Con `./scripts/backup.sh full` realizamos una copia de seguridad 
de todo el estado del nodo y de la
blockchain. Todas las copias de seguridad se almacenan en el directorio home
como `~/alastria-keysBackup-<date>/` y `~/alastria-backup-<date>/`, respectivamente.

Existe un script `./scripts/clean.sh` que limpia el nodo actual y exige una resincronización
del mismo al iniciarlo de nuevo. Esto solventa posibles errores de sincronización.
Su efecto es el mismo que el de ejecutar directamente `./scripts/start.sh clean`

<!-- EN PROCESO DE REVISIÓN

## Build/Run with Docker

**NOTA**
Ejecución con Docker es muy experimental y se requiere ejecutar el contenedor en modo interactivo y desde allí ejecutar los scripts `init.sh` y `start.sh`.


Existen dos posibilidades cómo ejecutar **Quorum** y **Constellation** con [Docker](https://www.docker.com/):
- Primera posibilidad es la más fácil y depende de una imagen de Docker disponible en [Docker Hub](hub.docker.com). En este caso lo único que se requiere es ejecutar el siguiente comando:
```
docker run -it --rm --name alastria -p 9000:9000 -p 21000:21000 -p 22000:22000 -p 41000:41000 koubek/alastria-node bash
```

- La segundo opción supone de que la imagen se quiere construir por el usuario mismo y para ello sirve el fichero `Dockerfile`. Para crear la imagen propia hay que ejecutar el siguiente este commando desde la carpeta dónde se encuentra el mismo fichero `Dockerfile`:
```
docker build -t alastria .
```

Al tener la imagen preparada se puede ejecutar (ahora en forma experimental e interactiva solo):
```
docker run -it --rm --name alastria -p 9000:9000 -p 21000:21000 -p 22000:22000 -p 41000:41000 alastria bash
``` -->
