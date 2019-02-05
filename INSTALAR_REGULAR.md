
## Cómo poner en marcha un nodo regular Alastria

Nuestra primera aproximación a esta red, es la generación de una red en pruebas con [Quorum](https://www.jpmorgan.com/global/Quorum) (derivado de [Ethereum](https://www.ethereum.org/)) que permite disponer de una red permisionada (necesitaremos solicitar el acceso a la misma) y con la posibilidad de generar transacciones privadas.

El software que se incluye en el nodo es el siguiente:

* **geth**: Es el nodo Quorum con el que se opera en la red blockchain.

* **constellation**: Es la pieza de software que nos permite realizar transacciones privadas entre socios. Su utilización es opcional.

* **monitor:** Es un servicio REST desarrollado adHoc por el core de desarrolladores de Alastria, que permitirá recabar información y asegurar el correcto funcionamiento de la infraestructura.

### Requerimientos del nodo“Regular”

Se debe permitir el tráfico a los puertos:

* **21000/TCP** y **UDP**: Que permite conectarse los nodos Quorum entre sí.

Se debe permitir tráfico de entrada y salida con todos los nodos publicados en [permissioned-nodes.json](https://github.com/alastria/alastria-node/blob/develop/data/permissioned-nodes_general.json).

* **22000/TCP**: Puerto que se utiliza para conectar las Dapps.

Usualmente es de utilización local a la organización y con acceso muy restringido.

* **9000/TCP**: Puerto por el que Constellation transmite las transacciones privadas.

Se debe permitir tráfico de entrada y salida con los nodos publicados en [constellation-nodes.json](https://github.com/alastria/alastria-node/blob/develop/data/constellation-nodes.json).

## Configurando el nodo “Regular”

Para la realización de este tutorial, se ha utilizado una instancia AWS con Ubuntu 16.04 64bits, 2 cores, 8 Gb de memoria y 100Gb de HDD.

Todas las operaciones que se describen se realizarán en la carpeta home del usuario, que en el caso de AWS es en /home/ubuntu.

    $ cd $HOME
    $ pwd
    /home/ubuntu

Dicho usuario debe permitir la ejecución de operaciones con derecho de root, que en el caso de AWS ya viene pre-configurado.

Para asegurarnos que las dependencias de los scripts de configuración de los nodos están satisfechas, procederemos a:

    $ apt update
    $ apt upgrade -y
    $ apt install -y git curl sudo lsof
    $ rm -rf /var/lib/apt/lists/*

Lo primero que tenemos que hacer es descargar el repositorio alastria-node en nuestro nodo.

    $ git clone https://github.com/alastria/alastria-node -b testnet2
    Cloning into 'alastria-node'...
    remote: Counting objects: 1972, done.
    remote: Compressing objects: 100% (10/10), done.
    remote: Total 1972 (delta 7), reused 12 (delta 5), pack-reused 1957
    Receiving objects: 100% (1972/1972), 1.93 MiB | 3.08 MiB/s, done.
    Resolving deltas: 100% (1281/1281), done.
    Checking connectivity... done.

La llamada al script bootstrap.sh instala todo el software necesario para que todas las aplicaciones funcionen apropiadamente.

    $ cd alastria-node/scripts
    $ ./bootstrap.sh

El script añade unas variables de entorno al final del fichero ~/.bashrc.

    export GOROOT=/usr/local/go
    export GOPATH=$HOME/alastria/workspace
    export PATH=$GOROOT/bin:$GOPATH/bin:$PATH

Para asegurarnos que están activas:

    $ source ~/.bashrc
    $ echo $GOPATH
    /home/ubuntu/alastria/workspace

Y ahora sí, configuramos el nodo general llamando al script init.sh con los parámetros:

**auto**: obtiene la ip pública del nodo.

**general**: indica que se está configurando un nodo regular.

**TYPE_Company_Net_CORES_RAM_SEQ**: formato para la nomenclatura del nombre identificativo del nodo.

* Type: REG.

* Company: Nombre de la compañia.

* NET: Telsius.

* CORES: El número de cores de la máquina.

* RAM: Memoria RAM de la máquina.

* SEQ: Sequencial empezando en 00.

Ejemplo de ejecución

    $ ./init.sh auto general REG_Alastria_Telsius_2_4_01
    Autodiscovering public host IP …
    Public host IP found: 138.4.124.4
    [] Cleaning up temporary data directories.
    Installing monitor
    [] Removing previous versions
    [] Cloning monitor’s repository
    mkdir: cannot create directory ‘/root/alastria/workspace/bin’: File exists
    [] Downloading monitor
    % Total % Received % Xferd Average Speed Time Time Time Current
    Dload Upload Total Spent Left Speed
    100 5110 100 5110 0 0 11929 0 --:–:-- --:–:-- --:–:-- 11911
    ARCH = amd64
    OS = linux
    Will install into /root/alastria/workspace/bin
    Fetching https://github.com/golang/dep/releases/latest…
    Release Tag = v0.5.0
    Fetching https://github.com/golang/dep/releases/tag/v0.5.0…
    Fetching https://github.com/golang/dep/releases/download/v0.5.0/dep-linux-amd64…
    Setting executable permissions.
    Moving executable to /root/alastria/workspace/bin/dep
    LATESTTAG: v0.0.10-alpha
    Note: checking out ‘tags/v0.0.10-alpha’.
    
    You are in ‘detached HEAD’ state. You can look around, make experimental
    changes and commit them, and you can discard any commits you make in this
    state without impacting any branches by performing another checkout.
    
    If you want to create a new branch to retain commits you create, you may
    do so (now or later) by using -b with the checkout command again. Example:
    
    git checkout -b
    
    HEAD is now at 09e33eb… Merge branch ‘dev/arochaga’
    [] Installing dependencies
    github.com/astaxie/beego (download)
    github.com/astaxie/beego/vendor/gopkg.in/yaml.v2
    github.com/astaxie/beego/config
    github.com/astaxie/beego/utils
    github.com/astaxie/beego/logs
    github.com/astaxie/beego/toolbox
    github.com/astaxie/beego/grace
    github.com/astaxie/beego/vendor/golang.org/x/crypto/acme
    github.com/astaxie/beego/session
    github.com/astaxie/beego/vendor/golang.org/x/crypto/acme/autocert
    github.com/astaxie/beego/context
    github.com/astaxie/beego/context/param
    github.com/astaxie/beego
    github.com/beego/bee (download)
    github.com/beego/bee/logger/colors
    github.com/beego/bee/vendor/gopkg.in/yaml.v2
    github.com/beego/bee/vendor/github.com/lib/pq/oid
    github.com/beego/bee/vendor/github.com/go-sql-driver/mysql
    github.com/beego/bee/vendor/github.com/derekparker/delve/dwarf/util
    github.com/beego/bee/vendor/golang.org/x/debug/dwarf
    github.com/beego/bee/vendor/golang.org/x/sys/unix
    github.com/beego/bee/vendor/rsc.io/x86/x86asm
    github.com/beego/bee/vendor/github.com/lib/pq
    github.com/beego/bee/vendor/github.com/derekparker/delve/dwarf/frame
    github.com/beego/bee/logger
    github.com/beego/bee/vendor/github.com/derekparker/delve/dwarf/line
    github.com/beego/bee/vendor/github.com/derekparker/delve/dwarf/op
    github.com/beego/bee/vendor/github.com/derekparker/delve/version
    github.com/beego/bee/vendor/github.com/peterh/liner
    github.com/beego/bee/vendor/github.com/astaxie/beego/swagger
    github.com/beego/bee/vendor/github.com/astaxie/beego/utils
    github.com/beego/bee/vendor/github.com/fsnotify/fsnotify
    github.com/beego/bee/vendor/github.com/derekparker/delve/dwarf/reader
    github.com/beego/bee/vendor/golang.org/x/debug/elf
    github.com/beego/bee/vendor/github.com/gorilla/websocket
    github.com/beego/bee/vendor/github.com/derekparker/delve/proc
    github.com/beego/bee/config
    github.com/beego/bee/vendor/github.com/derekparker/delve/config
    github.com/beego/bee/utils
    github.com/beego/bee/cmd/commands
    github.com/beego/bee/generate/swaggergen
    github.com/beego/bee/cmd/commands/version
    github.com/beego/bee/cmd/commands/migrate
    github.com/beego/bee/cmd/commands/beefix
    github.com/beego/bee/cmd/commands/bale
    github.com/beego/bee/cmd/commands/dockerize
    github.com/beego/bee/cmd/commands/new
    github.com/beego/bee/cmd/commands/pack
    github.com/beego/bee/cmd/commands/rs
    github.com/beego/bee/cmd/commands/run
    github.com/beego/bee/cmd/commands/server
    github.com/beego/bee/generate
    github.com/beego/bee/cmd/commands/api
    github.com/beego/bee/cmd/commands/generate
    github.com/beego/bee/vendor/github.com/derekparker/delve/service/api
    github.com/beego/bee/cmd/commands/hprose
    github.com/beego/bee/vendor/github.com/derekparker/delve/service
    github.com/beego/bee/vendor/github.com/derekparker/delve/service/debugger
    github.com/beego/bee/vendor/github.com/derekparker/delve/service/rpc2
    github.com/beego/bee/vendor/github.com/derekparker/delve/terminal
    github.com/beego/bee/vendor/github.com/derekparker/delve/service/rpc1
    github.com/beego/bee/vendor/github.com/derekparker/delve/service/rpccommon
    github.com/beego/bee/cmd/commands/dlv
    github.com/beego/bee/cmd
    github.com/beego/bee
    [] Initializing quorum
    WARN [10-08|15:32:58] No etherbase set and no accounts found as default
    INFO [10-08|15:32:58] Allocated cache and file handles database=/root/alastria/data/geth/chaindata cache=16 handles=16
    INFO [10-08|15:32:58] Writing custom genesis block
    INFO [10-08|15:32:58] Successfully wrote genesis state database=chaindata hash=77a8c9…dd474c
    INFO [10-08|15:32:58] Allocated cache and file handles database=/root/alastria/data/geth/lightchaindata cache=16 handles=16
    INFO [10-08|15:32:59] Writing custom genesis block
    INFO [10-08|15:32:59] Successfully wrote genesis state database=lightchaindata hash=77a8c9…dd474c
    [] creating dir if not created and set nodekey
    ENODE -> ‘enode://e2a2773c0dddc339c56a6ced15167ad17af63d65548720ff16718a3d21bce903ceacfc7f6fc7f1c7d231397f9f2b2d3ce2ae53e7a7d56b9611b7f5fdadcc46fd@138.4.124.4:21000?discport=0’
    Selected general node…
    Updating permissioned nodes…
    Updating static-nodes…
    Definida contraseña por defecto para cuenta principal como: Passw0rd.
    WARN [10-08|15:32:59] No etherbase set and no accounts found as default
    Address: {7416f11dabc8c399dd9f0c47f5388634483f6997}
    [] Initializing Constellation node.
    Lock key pair node with password [none]: [*] creating dir if not created, and set keystore
    
    [*] Initialization was completed successfully.
    
    Update DIRECTORY_REGULAR.md or DIRECTORY_VALIDATOR.md from alastria-node repository and send a Pull Request.
    Don’t forget the .json files in data folder!.

**NOTA**: El script se encarga de rellenar todo lo necesario, incluida la contraseña por defecto del account Quorum creado para el nodo y el par de claves para Constellation.

Por último, para iniciar el nodo:

    $ ./start.sh --no-monitor
    Relinking permissioning file
    [*] Starting quorum node
    Monitor disabled.

En el caso de querer iniciar el nodo en modo con constellation, debería utilizarse:

    $ ENABLE_CONSTELLATION=true ./start.sh
    [*] Starting Constellation node
    [*] constellation node at 9000 is still starting. Awaiting 5 seconds.
    [*] constellation node at 9000 is still starting. Awaiting 5 seconds.
    [*] constellation node at 9000 is now up.
    [*] resuming start procedure
    [*] Starting quorum node

### Verificación

Para verificar que todo se ha inicializado correctamente:

    $  ps awx | grep alastria
    22290 pts/0    Sl     0:15 constellation-node /home/ubuntu/alastria/data/constellation/constellation.conf
    22479 pts/0    Sl     0:04 geth --datadir /home/ubuntu/alastria/data --networkid 82584648528 --identity REG_Alastria_Telsius_2_4_01 --permissioned --rpc --rpcaddr 0.0.0.0 --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum,istanbul --rpcport 22000 --port 21000 --istanbul.requesttimeout 30000 --ethstats REG_Alastria_Telsius_2_4_01:bb98a0b6442386d0cdf8a31b267892c1@http://netstats.telsius.alastria.io/ --verbosity 3 --vmdebug --emitcheckpoints --targetgaslimit 18446744073709551615
    22507 pts/0    S+     0:00 grep --color=auto alastria

Además, en el [monitor de la red](http://netstats.telsius.alastria.io/) aparecerá su nodo recién configurado.

![](https://cdn-images-1.medium.com/max/3816/1*wlIkSVnoPW9H3y-Yovz4JQ.png)


### Notificando el permisionado del nodo

Una vez iniciado Quorum y el monitor, llega el momento de notificar al resto de nodos de la red que queremos integrarnos en ella.

Para ello debemos saber qué ficheros se han modificado en la carpeta alastria-node y en qué consisten estos cambios.

En primer lugar, para identificar los ficheros cambiados en el nodo recién configurado, debemos realizar:

    $ cd ~/alastria-node
    $ git status
    On branch develop
    Your branch is up-to-date with 'origin/develop'.
    Changes not staged for commit:
      (use "git add <file>..." to update what will be committed)
      (use "git checkout -- <file>..." to discard changes in working directory)

    modified:   data/constellation-nodes.json
            modified:   data/permissioned-nodes_validator.json

    Untracked files:
      (use "git add <file>..." to include in what will be committed)

    scripts/start.sh.save
            scripts/tls-client-cert.pem
            scripts/tls-client-key.pem
            scripts/tls-known-clients
            scripts/tls-known-servers
            scripts/tls-server-cert.pem
            scripts/tls-server-key.pem

    no changes added to commit (use "git add" and/or "git commit -a")

Como se puede observar, se han modificado los ficheros constellation-nodes.json y permissioned-nodes_validator.json.

Para identificar lo que ha cambiado en ambos ficheros, podemos realizar:

![](https://cdn-images-1.medium.com/max/3538/1*Bt-4TC3dTrO9q7p5mVM0QQ.png)

En ambos ficheros se ha añadido una coma en la última fila del original y se añade una nueva fila con la información de nodo que estamos configurando.

Así mismo, para obtener la clave pública del nodo para realizar transacciones privadas, es necesario:

    $ cat ~/alastria/data/constellation/keystore/node.pub
    BAKMjJL7xeRjUt1za/Ax8pKIb9T66tSJWxW3QfTmOSY=

Una vez identificados los ficheros que cambian y el contenido del cambio, se procede a enviar un pull request al repositorio github alastria-node a su rama “develop”.

Si tiene dudas para realizar esta operación, sigua este tutorial (Enlace al F.A.Q. de la WIKI).

### Aceptación del pull request

El equipo core de plataforma, procederá entonces a la aceptación del pull request.

Con estos cambios aceptados, todos los nodos validadores deben actualizar sus ficheros de permisionado, que se realiza con el monitor a través de una llamada a su API.

Para verificar que se ha realizado, se debe consultar el [monitor de la red](http://netstats.telsius.alastria.io/) y comprobar que aumenta la columna de Peers y que la columna Last block aumenta hasta sincronizarse con el resto de nodos.

### Actualización del permisionado

Una vez que el nodo está listo para operar con la red, tenemos que asegurarnos que podremos actualizar nuestro nodo cuando sea necesario. Para ello, la carpeta alastria-node del nodo no puede tener ficheros marcados como modificados por git, por lo que, tendremos que descartar todos los cambios.

Desde la consola del nodo:

    $ cd ~/alastria-node/data
    $ git checkout -- constellation-nodes.json
    $ git checkout -- permissioned-nodes_validator.json
    $ git checkout -- static-nodes.json

Si algún miembro del APCT solicita que se actualicen manualmente los ficheros de permisionado y una vez asegurado que el repositorio local alastria-node está limpio de cambios, procedemos a actualizar los ficheros utilizando la siguiente secuencia de comandos:

    $ cd ~/alastria-node/scripts
    $ git pull
    $ ./update.sh
    [*] Updating base code
    Already up-to-date.
    [*] Updating static-nodes
    [*] Updating permissioned-nodes
    [*] Restarting node
    Relinking permissioning file
    [*] Starting quorum node

### Probando el nodo regular

Una forma sencilla de probar que su nodo opera con normalidad, es generar una transacción de envío de fondos desde la cuenta del nodo, a sí misma de 0 weis.

Desde la consola del nodo:

    
    $ geth attach ~/alastria/data/geth.ipc
    > personal.unlockAccount(eth.accounts[0])
    Unlock account 0xdd937922e953a76a36698e7d874d7dafa0a847b3
    Passphrase:
    true
    > eth.sendTransaction({from: eth.accounts[0], to: eth.accounts[0], value:0 })
    "0xcbe05cab94282ddd27062cba81462d0183cc5766c876335d8e04cfcbdceed378"

Si en el [monitor de la red](http://netstats.telsius.alastria.io/) aparece una nueva transacción es que su nodo opera apropiadamente.

Basado en https://medium.com/@marcos_26856/c%C3%B3mo-poner-en-marcha-un-nodo-regular-alastria-a26a5cb1eabd
