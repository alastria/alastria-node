## Migración de red Alastria Arrakis a Telsius 

Antes de migrar, debes tener claro que:

* Se pierden todos los datos de la blockchain de Arrakis
* Se va a crear una nueva dirección de enode

## Cómo migrar 

Este proceso es comun a cualquier tipo de nodo, tanto regular como validador.

```
$ cd ~/alastria-node/
$ cd scripts
$ ./stop.sh
$ pkill -f monitor
$ pkill -f bee
$ pkill -f constellation-node
$ pkill -f geth
```
Si tienes suficiente espacio en disco, puedes hacer una copia de los datos de Arrakis

```
$ mv ~/alastria{,.arrakis}
```

Si no tines espacio o no te interesa guardar una copia, puedes borrar los datos

```
$ rm -Rf ~/alastria 
```

En cualquiera de los dos casos, posteriormente hacemos

```
$ cd ~/alastria-node/
$ git checkout testnet2
$ git pull
$ wget https://github.com/alastria/quorum/releases/download/v2.2.0-0.Alastria_EthNetstats_IBFT/geth
$ chmod +x geth
$ mv geth /usr/local/bin/
```

### Migración de un nodo Regular

A continuación hacemos

```
$ ./init.sh auto/[IP_NODO] general [NOMBRE_NODO]
$ ENABLE_CONSTELLATION=true ./start.sh --no-monitor
```

Donde [NOMBRE_NODO] es el mismo que en Arrakis, modificando 'Testnet' por 'Telsius'.

Una vez finalizado, creamos un **Pull Request** con los ficheros modificados `../data/constellation-nodes.json` y `../data/regular-nodes.json`. Actualizar `DIRECTORY_REGULAR.md` con el nuevo enode generado.


### Migración de un nodo Validador

```
$ ./init.sh auto/[IP_NODO] validator [NOMBRE_NODO]
$ ./start.sh
```
Donde [NOMBRE_NODO] es el mismo que en Arrakis, modificando 'Testnet' por 'Telsius'.

Una vez finalizado, creamos un **Pull Request** con el fichero modificado  `../data/validator-nodes.json`. Actualizar `DIRECTORY_REGULAR.md` con el nuevo enode generado. 
