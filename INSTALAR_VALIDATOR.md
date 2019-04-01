
## Cómo poner en marcha un nodo validador Alastria


Como la red Telsius está utilizando el protocolo de consensio Istanbul BFT, la forma de generar nuevos bloques en la test-net es teniendo disponibles nodos validadores en la red e integrarlos en el conjuto de nodos que forman parte de la ronda de validación.

Cada ronda la inicia un nodo distinto que “propone” un conjunto de transacciones en un bloque y los distribuye al resto de nodos.

El nodo validador no debería utilizarse en ningún caso para operar directamente con él para interactuar con la red. 

Los nodos validadores deben centrarse en operar el protocolo de consenso, integrando las transacciones en la cadena de bloques y distribuirlas al resto de nodos.

Como parte de las políticas de gobernanza de la red, se está trabajando en poder rotar entre todos los nodos validadores, ya sea por mal funcionamiento del nodo o periódicamente.


### Requerimientos del nodo“Validador”



Se debe permitir el tráfico a los puertos:

* **21000/TCP** y **UDP**: Que permite conectarse los nodos Quorum entre sí.

Se debe permitir tráfico de entrada y salida con todos los nodos publicados en [permissioned-nodes.json](https://github.com/alastria/alastria-node/blob/develop/data/permissioned-nodes_general.json).

* **22000/TCP**: Puerto que se utiliza para realizar tareas administrativas sobre el nodo.

Usualmente es de utilización local a la organización y con acceso muy restringido.

* **8443/TCP**: Puerto por el que se expone el API REST del monitor del nodo. Para poder acceder a este API, es necesario disponer de un certificado digital instalado en el navegador.

Se permitirá el tráfico de entrada con cualquier ip ya que es la herramienta que permite al APCT realizar las operaciones necesarias para la gestión de la test-net.

## Configurando el nodo “Validator”

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

    $ git clone https://github.com/alastria/alastria-node --branch testnet2
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

Y ahora sí, configuramos el nodo validador llamando al script init.sh con los parámetros:

**auto**: obtiene la ip pública del nodo.

**validator**: indica que se está configurando un nodo validador.

**TYPE_COMPANY_NET_CORES_RAM_SEQ**: formato para la nomenclatura del nombre identificativo del nodo.

* Type: VAL.

* Company: Nombre de la compañia.

* NET: Telsius.

* CORES: El número de cores de la máquina.

* RAM: Memoria RAM de la máquina.

* SEQ: Sequencial empezando en 00.

        $ ./init.sh auto validator VAL_Alastria_Telsius_2_4_01
        Autodiscovering public host IP ...
        Public host IP found: 138.4.124.4
        [*] Cleaning up temporary data directories.
        Installing monitor
        [*] Removing previous versions
        [*] Cloning monitor's repository
        mkdir: cannot create directory '/root/alastria/workspace/bin': File exists
        [*] Downloading monitor
          % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                         Dload  Upload   Total   Spent    Left  Speed
        100  5110  100  5110    0     0  12469      0 --:--:-- --:--:-- --:--:-- 12493
        ARCH = amd64
        OS = linux
        Will install into /root/alastria/workspace/bin
        Fetching [https://github.com/golang/dep/releases/latest](https://github.com/golang/dep/releases/latest)..
        Release Tag = v0.5.0
        Fetching [https://github.com/golang/dep/releases/tag/v0.5.0](https://github.com/golang/dep/releases/tag/v0.5.0)..
        Fetching [https://github.com/golang/dep/releases/download/v0.5.0/dep-linux-amd64](https://github.com/golang/dep/releases/download/v0.5.0/dep-linux-amd64)..
        Setting executable permissions.
        Moving executable to /root/alastria/workspace/bin/dep
        LATESTTAG: v0.0.10-alpha
        Note: checking out 'tags/v0.0.10-alpha'.
        
        You are in 'detached HEAD' state. You can look around, make experimental
        changes and commit them, and you can discard any commits you make in this
        state without impacting any branches by performing another checkout.
        
        If you want to create a new branch to retain commits you create, you may
        do so (now or later) by using -b with the checkout command again. Example:
        
        git checkout -b <new-branch-name>
        
        HEAD is now at 09e33eb... Merge branch 'dev/arochaga'
        [*] Installing dependencies
        github.com/astaxie/beego (download)
        github.com/astaxie/beego/vendor/gopkg.in/yaml.v2
        github.com/astaxie/beego/utils
        github.com/astaxie/beego/config
        github.com/astaxie/beego/logs
        github.com/astaxie/beego/grace
        github.com/astaxie/beego/toolbox
        github.com/astaxie/beego/vendor/golang.org/x/crypto/acme
        github.com/astaxie/beego/session
        github.com/astaxie/beego/vendor/golang.org/x/crypto/acme/autocert
        github.com/astaxie/beego/context
        github.com/astaxie/beego/context/param
        github.com/astaxie/beego
        github.com/beego/bee (download)
        github.com/beego/bee/logger/colors
        github.com/beego/bee/vendor/gopkg.in/yaml.v2
        github.com/beego/bee/vendor/github.com/go-sql-driver/mysql
        github.com/beego/bee/vendor/github.com/lib/pq/oid
        github.com/beego/bee/vendor/github.com/derekparker/delve/dwarf/util
        github.com/beego/bee/vendor/golang.org/x/debug/dwarf
        github.com/beego/bee/vendor/golang.org/x/sys/unix
        github.com/beego/bee/vendor/rsc.io/x86/x86asm
        github.com/beego/bee/vendor/github.com/lib/pq
        github.com/beego/bee/logger
        github.com/beego/bee/vendor/github.com/derekparker/delve/dwarf/frame
        github.com/beego/bee/vendor/github.com/derekparker/delve/dwarf/line
        github.com/beego/bee/vendor/github.com/derekparker/delve/dwarf/op
        github.com/beego/bee/vendor/github.com/derekparker/delve/version
        github.com/beego/bee/vendor/github.com/peterh/liner
        github.com/beego/bee/vendor/github.com/astaxie/beego/swagger
        github.com/beego/bee/vendor/github.com/astaxie/beego/utils
        github.com/beego/bee/vendor/github.com/derekparker/delve/dwarf/reader
        github.com/beego/bee/vendor/golang.org/x/debug/elf
        github.com/beego/bee/vendor/github.com/fsnotify/fsnotify
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
        github.com/beego/bee/vendor/github.com/derekparker/delve/service/rpc1
        github.com/beego/bee/vendor/github.com/derekparker/delve/terminal
        github.com/beego/bee/vendor/github.com/derekparker/delve/service/rpccommon
        github.com/beego/bee/cmd/commands/dlv
        github.com/beego/bee/cmd
        github.com/beego/bee
        [*] Initializing quorum
        WARN [10-15|17:34:25] No etherbase set and no accounts found as default 
        INFO [10-15|17:34:25] Allocated cache and file handles         database=/root/alastria/data/geth/chaindata cache=16 handles=16
        INFO [10-15|17:34:26] Writing custom genesis block 
        INFO [10-15|17:34:26] Successfully wrote genesis state         database=chaindata                          hash=77a8c9…dd474c
        INFO [10-15|17:34:26] Allocated cache and file handles         database=/root/alastria/data/geth/lightchaindata cache=16 handles=16
        INFO [10-15|17:34:26] Writing custom genesis block 
        INFO [10-15|17:34:26] Successfully wrote genesis state         database=lightchaindata                          hash=77a8c9…dd474c
        [*] creating dir if not created and set nodekey
        ENODE -> 'enode://dc661ad70d6fdef7c8267a302b83f80bf5970c0f414a8d65e9335369b9703231444acf5affd6c3af446baf1d7a82b6b6baae8e9a4c65fdf38dc2ea2f65f5eed7@138.4.124.4:21000?discport=0'
        Selected validator node...
        Updating permissioned nodes...
        Updating static-nodes...
        [*] Initialization was completed successfully.
        Update DIRECTORY_REGULAR.md or DIRECTORY_VALIDATOR.md from alastria-node repository and send a Pull Request.
        Don't forget the .json files in data folder!.

**NOTA**: El script se encarga de rellenar todo lo necesario para que funcione el nodo validador.

Por último, para iniciar el nodo:

    $ ./start.sh
    Relinking permissioning file
    [*] Starting quorum node
    [*] Monitor enabled. Starting monitor...

### Verificación



Para verificar que todo se ha inicializado correctamente:

    $  ps awx | grep alastria
    10088 ?        Sl     0:04 geth --datadir /root/alastria/data --networkid 82584648528 --identity VAL_Alastria_Telsius_2_4_01 --permissioned --rpc --rpcaddr 0.0.0.0 --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum,istanbul --rpcport 22000 --port 21000 --istanbul.requesttimeout 10000 --ethstats VAL_Alastria_Telsius_2_4_01:[bb98a0b6442386d0cdf8a31b267892c1@http://netstats.telsius.alastria.io/](mailto:bb98a0b6442386d0cdf8a31b267892c1@http://netstats.telsius.alastria.io/).builders:80 --verbosity 3 --vmdebug --emitcheckpoints --targetgaslimit 18446744073709551615 --syncmode full --vmodule consensus/istanbul/core/core.go=5 --maxpeers 100 --mine --minerthreads 8
    11411 ?        S+     0:00 grep --color=auto alastria

Además, en el [monitor de la red](http://netstats.telsius.alastria.io/) aparecerá su nodo recién configurado.

![](https://cdn-images-1.medium.com/max/3816/1*wlIkSVnoPW9H3y-Yovz4JQ.png)

### Verificación



Para verificar que el monitor está correctamente inicializado, hay que verificar que los procesos están arrancados y que el puerto 8443 está disponible.

    $ ps
      PID TTY          TIME CMD
        1 ?        00:00:00 bash
     4020 ?        00:00:00 bash
    10088 ?        00:00:07 geth
    10099 ?        00:00:00 bee
    11395 ?        00:00:00 monitor
    11412 ?        00:00:00 ps
    $ lsof -i :8443
    COMMAND   PID   USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
    monitor 32212 ubuntu    3u  IPv6 326649      0t0  TCP *:8443 (LISTEN)

    

Para verificar que se puede acceder al monitor, se debe intentar acceder desde el navegador a la url, o con la utilidad curl (teniendo en cuenta que va a provocar un error por falta del certificado de cliente) y :

    $ curl -I [https://35.176.34.215:8443](https://35.176.34.215:8443)
    curl: (60) SSL certificate problem: unable to get local issuer certificate
    More details here: [https://curl.haxx.se/docs/sslcerts.html](https://curl.haxx.se/docs/sslcerts.html)

    

    curl failed to verify the legitimacy of the server and therefore could not
    establish a secure connection to it. To learn more about this situation and
    how to fix it, please visit the web page mentioned above.

En el fichero de log monitor_XXX.log reportará un mensaje como este:

    Server.go:2846] [HTTP] http: TLS handshake error from 83.53.37.206:63154: remote error: tls: unknown certificate authority

### Notificando el permisionado del nodo

### 

Una vez iniciado Quorum y el monitor, llega el momento de notificar al resto de nodos de la red que queremos integrarnos en ella.

Para ello debemos saber qué ficheros se han modificado en la carpeta alastria-node y en qué consisten estos cambios.

En primer lugar, para identificar los ficheros cambiados en el nodo recién configurado, debemos realizar:

    $ cd ~/alastria-node
    $ git status
    On branch testnet2
    Your branch is up-to-date with 'origin/testnet2'.
    Changes not staged for commit:
      (use "git add <file>..." to update what will be committed)
      (use "git checkout -- <file>..." to discard changes in working directory)

     modified:   ../data/validator-nodes.json
     modified:   ../data/static-nodes.json

    no changes added to commit (use "git add" and/or "git commit -a")

Como se puede observar, se han modificado los ficheros static-nodes_general.json, permissioned-nodes_validator y permissioned-nodes_general.json.

Para identificar lo que ha cambiado en un fichero, podemos realizar:

    $ git diff data/static-nodes.json

Una vez identificados los ficheros que cambian y el contenido del cambio, se procede a enviar un pull request al repositorio github alastria-node a su rama “testnet2”.

Si tiene dudas para realizar esta operación, sigua este [tutorial](https://github.com/alastria/alastria-node/wiki/FAQ_EN#howto-pull-request-to-alastria-node).

### Aceptación del pull request

### 

El equipo core de plataforma, procederá entonces a la aceptación del pull request.

Con estos cambios aceptados, todos los nodos validadores deben actualizar sus ficheros de permisionado, que se realiza con el monitor a través de una llamada a su API.

Para verificar que se ha realizado, se debe consultar el [monitor de la red](http://netstats.telsius.alastria.io/) y comprobar que aumenta la columna de Peers y que la columna Last block aumenta hasta sincronizarse con el resto de nodos.

### Actualización del permisionado

### 

Una vez que el nodo está listo para operar con la red, tenemos que asegurarnos que podremos actualizar nuestro nodo cuando sea necesario. Para ello, la carpeta alastria-node del nodo no puede tener ficheros marcados como modificados por git, por lo que, tendremos que descartar todos los cambios.

Desde la consola del nodo:

    $ cd ~/alastria-node/data
    $ git checkout -- validator-nodes.json
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

### Integrando el nodo validador en el pool de validadores


Como parte del protocolo de consenso, a través del puerto RPC del nodo se puede alternar mediante votación de todos los nodos activos en la ronda de validación para añadir o eliminar nodos.

Para ello, cada nodo validador está identificado con respecto al resto de nodos validadores por el coinbase del nodo. 

Por si mismo, el coinbase no sirve para mucho, a no ser que desde el conjunto de nodos validadores que están en la ronda de votación se vote por la inclusión o exclusión del nodo validador.

    $ geth attach alastria/data/geth.ipc
    > istanbul.getValidators() 
    [...]
    > istanbul.propose("0xb87dc349944cc47474775dde627a8a171fc94532", true)
    > istanbul.propose("0xc68574f386ad5a8c3df12f52440c48654f2185c5", false)

* istanbul.getValidators() recupera la lista de validadores que forman la ronda de validación.

* istanbul.propose("0x...", true) vota para que el validador representado por el coinbase, sea integrado en la ronda de validación. Debe ser aceptado por al menos la mitad de los nodos. 

* istanbul.propose("0x...", false) vota para que el validador representado por el coinbase, sea excluido de la ronda de validación. Debe ser rechazado por al menos la mitad de los nodos.

Todas estas operaciones están automatizadas a través de las herramientas de gestión de la red aportadas por el core de plataforma.

Así mismo, el monitor de la red se está evolucionando para que muestre en su interfaz qué nodos son los que están involucrados en las rondas de votación, cuál es el nodo que está proponiendo el bloque y cuáles no están proponiendo el bloque provocando que la red mine más despacio.

Basado en https://medium.com/@marcos_26856/2e3185659a6
