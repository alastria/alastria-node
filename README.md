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

1. **Ejecutar script init.sh (CAMBIA)**

	Configura el nodo Quorum junto con Constellation. 
	
	Al ejecutar este script debemos de pasar como parametro la IP pública del nodo que estamos configurando:
	```
	$ ./init.sh <<PUBLIC_IP_HOST_MACHINE>>
	```
	O con el parámetro **auto** para detectarla automáticamente:
	```
	$ ./init.sh auto
	```
	Si ya disponemos de un nodo Alastria instalado en la máquina, y deseamos realizar una nueva
	inicialización limpia del nodo manteniendo nuestro **enode**, 
	nuestras claves constellation y nuestras cuentas actuales, podemos ejecutar:
	```
	$ ./init.sh backup
	```
	Este será el procedimiento a seguir ante actualizaciones en la testnet para evitar la 
	generación de un nuevo enode.

2. **Configuración del fichero de nodos Quorum**

	El nodo quorum que estamos desplegando se configura automaticamente con el script de inicialización ejecutado en el paso anterior.

	Con el **enode** informado, se actualiza el fichero de directorio de nodos `DIRECTORY.md` incluyendo la información de contacto del nodo, la información del host, la clave del private for y el enode del nodo a la rama develop de este repositorio.
	
	**INDICAR QUE DEBEN SUBIRSE LOS FICHEROS CAMBIADOS (static-nodes, permissioned-nodes).**

    **INDICAR QUE HAY QUE SUMINISTRAR EL address del nodo recigido del log (Sólo si ers validator)**

    **Si es regular, ser ha terminado subiendo los ficheros**
    
    **Si es validador, hay que esperar a la votación del resto de los nodos**

3. **Configuración del fichero de nodos de Constellation**

	El nodo Constellation que estamos desplegando se configura automáticamente con el script de inicialización ejecutado en el paso anterior.

**NOTA**
En este punto ya tendriamos desplegado un nuevo nodo en la red, que incluiria el despliegue y configuración de Quorum y Constellation.

Si necesitamos desplegar más nodos para nuestra red, es necesario volver a realizar los pasos descritos en el paso 2.

## Arranque de nodo Quorum + Constellation (CAMBIAR)
Una vez instalado y configurado todo ya podemos arrancar nuestro nodo. Para arrancar ejecutamos la siguiente orden:
```
$ ./start.sh
```
Ante errores en el nodo, podemos optar por realizar un reinicio limpio del nodo, para ello debemos
ejecutar los siguientes comados:
```
$ ./stop.sh
$ ./start.sh clean
```

## Hacer backups del estado de la blockchain y limpiar el nodo
El script `./scripts/backup.sh` permite realizar copias de seguridad del estado del nodo.
Ejecutando `./scripts/backup.sh keys` se hace una copia de seguridad de las claves y el enode de
nuestro nodo.

Con `./scripts/backup.sh full` realizamos una copia de seguridad de todo el estado del nodo y de la
blockchain. Todas las copias de seguridad se almacenan en el directorio home
como `~/alastria-keysBackup-<date>/` y `~/alastria-backup-<date>/`, respectivamente.

Existe un script `./scripts/clean.sh` que limpia el nodo actual y exige una resincronización
del mismo al iniciarlo de nuevo. Esto solventa posibles errores de sincronización.
Su efecto es el mismo que el de ejecutar directamente `./scripts/start.sh clean`


## Build/Run with Docker (A REVISAR)

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
```