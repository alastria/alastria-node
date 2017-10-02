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
$ git clone https://github.com/marcossanlab/alastria-node.git
$ cd alastria-node/scripts/
$ sudo -H ./bootstrap.sh
```

## Configuración del nodo
 Es necesario seguir los siguientes pasos para la configuración de los nodos:

1. **Ejecutar script init.sh**

	Configura el nodo Quorum junto con Constellation. 
	
	Al ejecutar este script debemos de pasar como parametro la IP pública del nodo que estamos configurando.
	```
	$ ./init.sh <<PUBLIC_IP_HOST_MACHINE>>
	```

2. **Configuración del fichero de nodos Quorum**

	El nodo quorum que estamos desplegando se configura automaticamente con el script de inicialización ejecutado en el paso anterior.

	Una vez que comprobemos que el fichero de nodos `static-nodes.json` tiene añadido nuestro enode, es necesario subirlo de nuevo al repositorio git, para que todos los integrantes de la red tengan actualizado su fichero de nodos.

3. **Configurción del fichero de nodos de Constellation**

	El nodo Constellation que estamos desplegando se configura automaticamente con el script de inicialización ejecutado en el paso anterior.

	Una vez que comprobemos que el fichero de nodos de constellation `constellation-nodes.json` tiene añadido nuestro nodo, es necesario subirlo de nuevo al repositorio git, para que todos los integrantes de la red tengan actualizado su fichero de nodos de constellation.

**NOTA**
En este punto ya tendriamos desplegado un nuevo nodo en la red, que incluiria el despliegue y configuración de Quorum y Constellation.

Si necesitamos desplegar mas nodos para nuestra red, es necesario volver a realizar los pasos descritos anteriormente.

## Arranque de nodo Quorum + Constellation
Una vez instalado y configurado todo ya podemos arrancar nuestro nodo. Para arrancar ejecutamos la siguiente orden:
```
$ ./start.sh
```
**NOTA**
Si el nodo que vamos a levantar es el primer nodo de la red, debemos arrancar con la siguiente orden:
```
$ ./start.sh init
``` 

## Habilitar el nodo para empezar a realizar transacciones
A la hora de realizar transacciones en la red de Alastria es necesario realizar el siguiente procedimiento:

Una vez que se levantado el nodo, es necesaria la realización de una transferencia de fondos de la cuenta principal a la cuenta que acaba de ser generada al iniciarse el nodo.

Con el fin de realizar este procedimiento se debe indicar al administrador del primer nodo de la red, poseedor de la cuenta principal, la cuenta que se ha generado al levantar el nodo. Tras esto, el administrador deberá asignar a la cuenta del nodo la cantidad que se haya acordado.