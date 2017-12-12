# ALASTRIA #

## Requisitos del sistema

Caracteristicas de la máquina:

* **CPU's**: 2

* **Memoria**: 4 Gb

* **Disco duro**: 30 Gb

* **Sistema operativo**: Ubuntu 16.04 64 bits

Es necesario habilitar los siguientes puertos de E/S en la maquina en la que vamos a desplegar el nodo:

* **21000**: TCP/UDP - Puerto para establecer la comunicación entre procesos geth.

* **41000**: TCP - Puerto para el consenso RAFT de Quorum.

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

1. **Ejecutar script init.sh**

	Configura el nodo Quorum junto con Constellation. 
	
	Al ejecutar este script debemos de pasar como parametro la IP pública del nodo que estamos configurando:
	```
	$ ./init.sh <<PUBLIC_IP_HOST_MACHINE>>
	```
	O con el parámetro **auto** para detectarla automáticamente:
	```
	$ ./init.sh auto
	```

2. **Configuración del fichero de nodos Quorum**

	El nodo quorum que estamos desplegando se configura automaticamente con el script de inicialización ejecutado en el paso anterior.

	Con el **enode** informado, se actualiza el fichero de directorio de nodos `DIRECTORY.md` incluyendo la información de contacto del nodo, la información del host, la clave del private for y el enode del nodo a la rama develop de este repositorio.

	Una vez procesado el **pull request**, se remitirá al contacto del nodo el RAFT_ID y se actualizará el fichero `DIRECTORY.md`.

	Este fichero se colocará en la carpeta `~/alastria/data/`.

3. **Configuración del fichero de nodos de Constellation**

	El nodo Constellation que estamos desplegando se configura automaticamente con el script de inicialización ejecutado en el paso anterior.

**NOTA**
En este punto ya tendriamos desplegado un nuevo nodo en la red, que incluiria el despliegue y configuración de Quorum y Constellation.

Si necesitamos desplegar mas nodos para nuestra red, es necesario volver a realizar los pasos descritos anteriormente.

## Arranque de nodo Quorum + Constellation
Una vez instalado y configurado todo ya podemos arrancar nuestro nodo. Para arrancar ejecutamos la siguiente orden:
```
$ ./start.sh
```

## Habilitar el nodo/account para empezar a emitir transacciones
A la hora de realizar transacciones en la red de Alastria es necesario realizar el siguiente procedimiento:

Una vez que se levantado el nodo, es necesaria la realización de una transferencia de fondos de la cuenta principal a la cuenta que acaba de ser generada al iniciarse el nodo.

Con el fin de realizar este procedimiento se debe indicar al administrador del primer nodo de la red, poseedor de la cuenta principal, la cuenta que se ha generado al levantar el nodo. Tras esto, el administrador deberá asignar a la cuenta del nodo la cantidad que se haya acordado.


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
```