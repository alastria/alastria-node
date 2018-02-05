# ALASTRIA #



## Requisitos del sistema

Caracteristicas de la máquina para nodos de la testnet:

* **CPU's**: 2 cores

* **Memoria**: 4 Gb

* **Disco duro**: 30 Gb SSD

* **Sistema operativo**: Ubuntu 16.04, CentOS 7.4 o Red Hat Enterprise Linux 7.4, siempre en 64 bits

Es necesario habilitar los siguientes puertos de red en la maquina en la que vamos a desplegar el nodo:

* **8443**: TCP - Puerto para monitorización

* **9000**: TCP - Puerto para la comunicación de Constellation.

* **21000**: TCP/UDP - Puerto para establecer la comunicación entre procesos geth.

* **22000**: TCP - Puerto para establecer la comunicación RPC. (este puerto se usa para aplicaciones que comunican con Alastria, y puede estar filtrado hacia Internet)


## Instalación de nodo Quorum + Constellation

Para configurar e instalar Quorum y Constellation, debe clonar este repositorio git y ejecutar con permisos de administración el script [`scripts/bootstrap.sh`](scripts/bootstrap.sh).

```
$ git clone https://github.com/alastria/alastria-node.git
$ cd alastria-node/scripts/
$ sudo -H ./bootstrap.sh
```

## Configuración del nodo
Es necesario seguir los siguientes pasos para la configuración de los nodos: 

### Creación de un nuevo nodo ###

Para crear un nuevo nodo de la red Alastria, debe ejecutarse el script init.sh pasando como parámetros la ip del nodo, el tipo de nodo (validator o general), y el nombre del nodo que estamos creando:

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

### Reinicialización de un nodo existente ###

Si ya disponemos de un nodo Alastria instalado en la máquina, y deseamos realizar una inicialización limpia del nodo manteniendo nuestro **enode**, nuestras claves constellation y nuestras cuentas actuales, podemos ejecutar:

    ```
	$ ./init.sh backup <<NODE_TYPE>> <<NODE_NAME>>
	```

Este será el procedimiento a seguir por los nodos miembros ante actualizaciones de la infraestructura.

### Configuración del fichero de nodos Quorum ###

Si el nodo se creó desde cero, entonces el paso anterior modificó diversos ficheros, a saber:

* Si el nodo era validador, se modifican los siguientes ficheros:
	* [`data/permissioned-nodes_general.json`](data/permissioned-nodes_general.json)
	* [`data/permissioned-nodes_validator.json`](data/permissioned-nodes_validator.json)
	* [`data/static-nodes.json`](data/static-nodes.json)
* Si el nodo era general, se modican en cambio estos ficheros:
	* [`data/constellation-nodes.json`](data/constellation-nodes.json)
	* [`data/permissioned-nodes_validator.json`](data/permissioned-nodes_validator.json)

Nótese que el nombre de los ficheros hace referencia a los nodos por los que son consumidos, no a los nodos que los han modificado durante su creación.

Además de estos cambios, que ocurren automáticamente al ejecutar el script [`init.sh`](scripts/init.sh), existen otros dos ficheros que deben modificarse manualmente, dependiendo del tipo de nodo creado, para indicar los datos de contacto de administración de los nodos: [DIRECTORY_VALIDATOR.md](DIRECTORY_VALIDATOR.md) o [DIRECTORY_REGULAR.md](DIRECTORY_REGULAR.md)

Una vez que disponemos de todos estos ficheros modificados, si el nodo era regular, solo es necesario arrancarlo usando el script [`start.sh`](scripts/start.sh)

En cambio, si el nodo es validador, entonces este debe ejecutar el script `restart.sh` con la opción onlyUpdate:
```
$ ./restart.sh onlyUpdate
```

Entonces, el el fichero `~/alastria/logs/quorum-XXX.log` del nuevo nodo validador aparecerá el siguiente mensaje de error:
```
ERROR[12-19|12:25:05] Failed to decode message from payload    address=0x59d9F63451811C2c3C287BE40a2206d201DC3BfF err="unauthorized address"
```
Esto es debido a que el resto de validadores de la red no han aceptado todavía al nodo como validador. Para solicitar dicha aceptación debemos anotar la dirección (address) del nodo.

### Publicación del nodo ###

Con los ficheros modificados, tanto automáticamente como manualmente, se debe crear un pull request contra este repositorio. Si el nodo era validador y tiene un address que aún no está autorizado, entonces debe indicarse dicha dirección en el pull request.

Para la inclusión en la red de nuevos nodos validadores, los administradores del resto de miembros validadores deben usar el RPC API para añadir su dirección:


```
> istanbul.propose("0x59d9F63451811C2c3C287BE40a2206d201DC3BfF", true);
```

Así, el nuevo nodo estará levantado y sincronizado con la red.

> **NUNCA DEBE REALIZARSE EL PROPOSE SIN HABER ACTUALIZADO ANTES LOS FICHEROS DE PERMISIONADO (restart.sh onlyUpdate).**

> **NUNCA SE DEBE ELIMINAR UN NODO DE LA RED SIN REALIZAR LA SOLICITUD DE ELIMINACIÓN PRIMERO A TRAVÉS DE UN PULL REQUEST PARA QUE EL RESTO DE MIEMBROS VALIDADORES LOS ELIMINEN DE SUS LISTAS PRIMERO Y REALICEN UNA RONDA DE VOTACIÓN:**

```
> istanbul.propose("0x59d9F63451811C2c3C287BE40a2206d201DC3BfF", false);
```

### Operación del nodo ###

 * Ante errores en el nodo, podemos optar por realizar un reinicio limpio del nodo, para ello debemos ejecutar los siguientes comados:
```
$ ./stop.sh
$ ./start.sh clean
```

 * También, disponemos de un script de restart para actualizar y reiniciar el nodo (por ejemplo ante actualizaciones del permissioned-nodes*):
```
$ ./restart.sh onlyUpdate
```
O para reiniciar completamente
el nodo:
```
$ ./restart.sh auto || <<CURRENT_HOST_IP>>
```

 * El script `./scripts/backup.sh` permite realizar copias de seguridad del estado del nodo. Ejecutando `./scripts/backup.sh keys` se hace una copia de seguridad de las claves
y el enode de nuestro nodo y con `./scripts/backup.sh full` realizamos una copia de seguridad de todo el estado del nodo y de la blockchain. Todas las copias de seguridad se almacenan en el directorio home como `~/alastria-keysBackup-<date>/` y `~/alastria-backup-<date>/`, respectivamente.

 * Existe un script `./scripts/clean.sh` que limpia el nodo actual y exige una resincronización del mismo al iniciarlo de nuevo. Esto solventa posibles errores de sincronización. Su efecto es el mismo que el de ejecutar directamente `./scripts/start.sh clean`

## Crear un nodo con Docker
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
