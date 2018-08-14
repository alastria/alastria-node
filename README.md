# ALASTRIA #

1. [Tutoriales de instalación](#tutoriales-de-instalación)
2. [Requisitos del sistema](#requisitos-del-sistema)
3. [Instalación de un nodo](#instalación-de-un-nodo)
	1. [Bootstraping](#bootstraping)
	2. [Nombrado](#nombrado-de-los-nodos)
	3. [Inicialización](#inicialización-de-un-nodo)
	4. [Permisionado](#permisionado)
	5. [Arranque](#arranque-del-nodo)
	6. [Actualización](#actualización-del-nodo)
4. [Proposición de nodos validadores](#proposición-de-nodos-validadores)
5. [Configurando el primer nodo](#configurando-el-primer-nodo-de-la-red)
6. [Crear un nodo con Docker](#crear-un-nodo-con-docker)

## Tutoriales de instalación

* [Instalación de un nodo regular](https://medium.com/@alastria_es/paso-a-paso-as%C3%AD-se-crea-un-nodo-regular-en-alastria-e9ef9a47b07f)
* [Instalación de un nodo validador](https://medium.com/@alastria_es) * En construcción


## Requisitos del sistema

Caracteristicas de la máquina para nodos de la testnet:

* **CPU's**: 2 cores

* **Memoria**: 8 Gb

* **Disco duro**: 100 Gb SSD

* **Sistema operativo**: Ubuntu 16.04, CentOS 7.4 o Red Hat Enterprise Linux 7.4, siempre en 64 bits

Es necesario habilitar los siguientes puertos de red en la maquina en la que vamos a desplegar el nodo:

* **8443**: TCP - Puerto por el que se expone el API REST del monitor del nodo. Para poder acceder a este API, es necesario disponer de un certificado digital.

* **9000**: TCP - Puerto para la comunicación de Constellation por el que se transmiten las transacciones privadas.

**NOTA**: Tanto el monitor como constellation son optativos, por lo tanto, la apertura de los puertos también lo es.

* **21000**: TCP/UDP - Puerto para establecer la comunicación entre procesos geth. Este puerto debe estar abierto por ahora a todo el mundo.

* **22000**: TCP - Puerto para establecer la comunicación RPC. (este puerto se usa para aplicaciones que comunican con Alastria, y puede estar filtrado hacia Internet)

## Instalación de un nodo

Se describen los pasos fundamentales para instalar, configurar y verificar que un nodo dentro de la test-net de Alastria.

### Bootstraping

Para comenzar con el proceso de instalación del nodo, debe clonar el repositorio git [alastria-node](https://github.com/alastria/alastria-node) y ejecutar con permisos de administración el script [`scripts/bootstrap.sh`](scripts/bootstrap.sh) como se indica a continuación:

```
$ git clone https://github.com/alastria/alastria-node.git
$ cd alastria-node/scripts/
$ ./bootstrap.sh
$ source ~/.bashrc
```

### Nombrado de los nodos

Se ha definido una nomenclatura para describir fácilmente a cada uno de los nodos.

El nombre identificativo del nodo debe ser único en la red y cumplir:
* **TYPE_COMPANY_NET_CORES_RAM_SEQ**
	* **Type**: VAL | REG.
	* **NET**: TestNet | DevNet | MainNet.
	* **SEQ**: Sequencial empezando en 00.

**Ej.** `VAL_Alastria_TestNet_2_8_00` que es el primer validador desplegado en la test-net por alastria con 2 cores y 8 Gb de memoria RAM.

### Inicialización de un nodo 

Para crear un nuevo nodo de la red Alastria, debe ejecutarse el script init.sh pasando como parámetros la ip del nodo, el tipo de nodo (validator o general), y el nombre del nodo que estamos creando:

```
$ ./init.sh
Usage: init <mode> <node-type> <node-name>
    mode: CURRENT_HOST_IP | auto | backup
    node-type: validator | general
    node-name: NODE_NAME (example: VAL_Alastria_TestNet_2_8_00)
```

En parámetro **mode** indica:
* **CURRENT_HOST_IP**: corresponde con la IP en la que va a responder la máquina.
* **auto**: el script auto-descubre la IP de la máquina y la utiliza.
* **backup**: el script realizará una copia de seguridad del nodo.

**node-type** indica el tipo de nodo que vamos a configurar, que pueden utilizarse los valores:
* **validator**: configuramos un nodo validador.
* **general**: configuramos un nodo regular/general.

Por último, tendremos que indicar el nombre del nodo **NODE_NAME**, que debe cumplir con la estructura indicada en el apartado [Nombrado de los nodos](#Nombrado-de-los-nodos)

### Permisionado

Cuando termina el script de inicialización, en la carpeta alastria-node se modifican un conjunto de ficheros que son:

* Si el nodo era validador, se modifican los siguientes ficheros:
	* [`data/permissioned-nodes_general.json`](data/permissioned-nodes_general.json)
	* [`data/permissioned-nodes_validator.json`](data/permissioned-nodes_validator.json)
	* [`data/static-nodes.json`](data/static-nodes.json)
* Si el nodo era general, se modican en cambio estos ficheros:
	* [`data/constellation-nodes.json`](data/constellation-nodes.json)
	* [`data/permissioned-nodes_validator.json`](data/permissioned-nodes_validator.json)

Nótese que el nombre de los ficheros hace referencia a los nodos por los que son consumidos, no a los nodos que los han modificado durante su creación.

Además de estos cambios, que ocurren automáticamente al ejecutar el script [`init.sh`](scripts/init.sh), existen otros dos ficheros que deben modificarse manualmente, dependiendo del tipo de nodo creado, para indicar los datos de contacto de administración de los nodos: [DIRECTORY_VALIDATOR.md](DIRECTORY_VALIDATOR.md) o [DIRECTORY_REGULAR.md](DIRECTORY_REGULAR.md)

Una vez identificados los cambios, se debe realizar un fork del repositorio github alastria-node e incorporar los cambios.

Por último, realizamos un pull request y realizaremos una revisión y, en su caso, aceptación de la pull request.

Una vez realizada esta acción, poco a poco se irá actualizando el permisionado de los nodos de la red, en el caso de los nodos validadores, 

### Arranque del nodo

Por último, iniciaremos el nodo lanzando el script [`start.sh`](scripts/start.sh):

```
~/alastria-node/scripts$ ./start.sh
[*] Starting quorum node
```

Este comando inicia un proceso geth, crea un fichero log en `~/alastria/logs/quorum-XXX.log` y utilizará los puertos 21000 y 22000.

### Actualización del nodo

Al menos una vez al día es necesario actualizar los ficheros de permisionado de los nodos, para ello, desde la consola del nodo:

```
~/alastria-node/scripts$ ./update.sh
[*] Updating base code
Already up-to-date.
[*] Updating static-nodes
[*] Updating permissioned-nodes
[*] Restarting node
[*] Starting quorum node
```

Esto descargará los ficheros de permisionado del nodo, los actualizará, parará el nodo y lo volverá a arrancar.

## Proposición de nodos validadores

Cuando se configura un nodo como validador y se permisiona, no significa que puede generar bloques. Para que pueda realizar esta acción, se debe proponer ese nodo como validador.

Esta operación es coordinada entre todos los nodos que forman parte del conjunto de validadores propuestos y aceptados a través de una votación en cada nodo con el api `istanbul`.

Para conocer el address del nodo, nos conectaremos a la consola del mismo y nos quedaremos con el `coinbase`.

```
~$ geth attach ~/alastria/data/geth.ipc
Welcome to the Geth JavaScript console!

instance: Geth/VAL_Alastria_TestNet_2_8_00/v1.7.2-stable-94e1e31e/linux-amd64/go1.9.5
coinbase: 0xc063ae03fab22352d6cf99bc85ef521582988a2c
at block: 8209869 (Tue, 14 Aug 2018 18:00:05 CEST)
 datadir: /home/ubuntu/alastria/data
 modules: admin:1.0 debug:1.0 eth:1.0 istanbul:1.0 miner:1.0 net:1.0 personal:1.0 rpc:1.0 txpool:1.0 web3:1.0
```

Para la inclusión en la red de nuevos nodos validadores, los administradores del resto de miembros validadores deben usar el RPC API para añadir su dirección:

```
> istanbul.propose("0xc063ae03fab22352d6cf99bc85ef521582988a2c", true);
```

> **NUNCA DEBE REALIZARSE EL PROPOSE SIN HABER ACTUALIZADO ANTES LOS FICHEROS DE PERMISIONADO (restart.sh onlyUpdate).**

> **NUNCA SE DEBE ELIMINAR UN NODO DE LA RED SIN REALIZAR LA SOLICITUD DE ELIMINACIÓN PRIMERO A TRAVÉS DE UN PULL REQUEST PARA QUE EL RESTO DE MIEMBROS VALIDADORES LOS ELIMINEN DE SUS LISTAS PRIMERO Y REALICEN UNA RONDA DE VOTACIÓN:**

En el caso de querer extraer un nodo del conjunto de validadores, se debe ejecutar en el resto de nodos:

```
> istanbul.propose("0xc063ae03fab22352d6cf99bc85ef521582988a2c", false);
```

## Configurando el primer nodo de la red

Si se está inicializando una nueva red, el primer nodo debe tener obligatoriamente los siguientes ficheros en el nodo:

* [~/alastria/data/geth/nodekey](https://github.com/alastria/test-environment/blob/master/threenodes/alastria/validator/geth/nodekey):
```
e7889a64e5ec8c28830a1c8fc620810f086342cd511d708ee2c4420231904d18
```

* [~/alastria/data/keystore/UTC--2017-09-20T08-43-59.003454005Z--58b8527743f89389b754c63489262fdfc9ba9db6](https://github.com/alastria/alastria-node/blob/feature/ibft/data/keystore/UTC--2017-09-20T08-43-59.003454005Z--58b8527743f89389b754c63489262fdfc9ba9db6):
```
{"address":"58b8527743f89389b754c63489262fdfc9ba9db6","crypto":{"cipher":"aes-128-ctr","ciphertext":"20f46e1aacd6bf28b66e37b5b6cf9b1cefc42ac8a4461e86893ae4ccd7e671c7","cipherparams":{"iv":"4d455255a895091952f653c4b59c92c7"},"kdf":"scrypt","kdfparams":{"dklen":32,"n":262144,"p":1,"r":8,"salt":"74b089663af7571962992c5a1bb68c1e82e5f8308c646b68cfe576c1c6f38d5c"},"mac":"5ce860f522494ff1322f776d93ee6fb149eb1cddb53722e2e59191c4d0bdd8c9"},"id":"2db34512-2c46-44b7-a8a9-6b73302dde1e","version":3}
```

La secuencia de acciones sería:
```
$ cd ~/alastria/data/geth/
$ rm -rf nodekey
$ wget https://raw.githubusercontent.com/alastria/test-environment/master/threenodes/alastria/validator/geth/nodekey
$ cd ~/alastria/data/keystore/
$ rm -rf *
$ wget https://raw.githubusercontent.com/alastria/alastria-node/feature/ibft/data/keystore/UTC--2017-09-20T08-43-59.003454005Z--58b8527743f89389b754c63489262fdfc9ba9db6
```

Adicionalmente, se puede cambiar el script `start.sh` para con la IP pública del nodo que se está configurando.

## Crear un nodo con Docker

**TODO: HABLAR CON COUNCILBOX**

Para generar la imagen de Docker ejecutar:
```
sudo docker build -t alastria-node . --build-arg hostip=<host-ip> --build-arg nodetype=<node-type> --build-arg nodename=<node-name>
```
Indicando la IP del host donde se ejecuta el nodo, el tipo de nodo a generar (validador o general) y el nombre que queremos dar al nodo,
y ejecutando el comando anterior se genera la imagen para nuestro nodo con el nombre *alastria-node*.

**NOTA**
Si deseamos generar el nodo utilizando un enode y las claves de un nodo ya existente debemos hacer un backup de las claves
del antiguo nodo:
```
./backup.sh keys
```
Esto generará la carpeta ~/alastria-keysBackup-<date> cuyo contenido deberemos moverlo a ~/alastria-node/data/keys.
La claves de este directorio (que tiene que mantener la estructura de carpetas del backup generado) serán las utilizadas
en la imagen del nodo que vamos a generar.


Una vez finalizada la generación de la imagen, ejecutamos el nodo en segundo plano:
```
docker run -d --name alastria -p 9000:9000 -p 21000:21000 -p 22000:22000 -p 8443:8443 alastria-node
```
