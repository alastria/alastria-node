
## INSTRUCTIONS TO UPGRADE TO LAST VERSION OF CONSENSYS QUORUM

Please, follow these instructions to upgrade your binaries to the last versions provided by Consensys Quorum. As of November 2020, after the update, the outcome of *geth version* should be:

    **Version: 1.9.7-stable  
    Git Commit: af7525189f2cee801ef6673d438b8577c8c5aa34  
    Quorum Version: 20.10.0  
    Architecture: amd64  
    Protocol Versions: [64 63]  
    Network Id: 1337  
    Go Version: go1.15.2  
    Operating System: linux  
    GOPATH=/root/alastria/workspace  
    GOROOT=/usr/local/go**  

Please, note that due to a change in Quorum versioning number, the version **20.10.0** would have corresponded to the older nomenclature **2.8.0**

This document was meant to bump your **2.2.3** Alastria version to **Consensys 2.8.0** , but changing the **commit-hash** it will serve to establish *lifecycle management* for upcoming versions.

#### CHANGES YOU WILL FIND AFTER UPDATING TO THIS NEW VERSION:
* geth will change from version 1.8.x to version 1.9.7
* geth will log now more metrics than 1.8.x,  that can be visualized in Grafana
* log verbosity level is increased to 5
* prometheus scraping is included at port 9545 to make it compatible with **Alastria RedB** current settings of Besu
* env **PRIVATE_CONFIG=ignore** was added when CONSTELLATION environment variable not set, so geth can start up
* get rid of monitor by now as it is unmaintained


You must select the instructions corresponding to your type of node:
- A) Node non-installed with docker
- B) Node installed with docker


### A) INSTRUCTIONS FOR NODES INSTALLED WITH NON-DOCKER INSTALLATION PROCESS

Step 1: Please verify your current version by executing *geth version*. If it is in the last version, skip.

Step 2: Please verify your system requirements as the new version needs new memory and ports

  * RAM needed is 8 Gb now , as geth 1.9.x is more memory hungry
  * Open port for incoming scraping of port 9545 , protocol HTTP, IP address 185.180.8.244 (Prometheus)
  * Open port for outgoing HTTP traffic to IP address 185.180.8.244 (Influx)
  * Open port for outgoing HTTP and HTTPS websockets traffic to IP address 185.180.8.152 (netstats)

Step 3: The upgrade procedure consists of four simple steps being positioned in ``/root/alastria/node-scripts``:

    ./update.sh
    ./stop.sh
    ./bootstrap.sh reinstall
    ./start.sh

Step 4: Then run *geth version* to verify that you've changed version. If it is below the required, please go to step 2

Step 5: You will find your logs now in a fixed path, namely **/root/alastria/logs/quorum.log** with increased verbosity


### B) INSTRUCTIONS FOR NODES INSTALLED WITH DOCKER INSTALLATION PROCESS
(WORK IN PROGRESS)

Step 1: Please verify your current version by executing *geth version*. If it is in the last version, skip.

Step 2: Please verify your system requirements as the new version needs new memory and ports

  * RAM needed is 8 Gb now , as geth 1.9.x is more memory hungry
  * Open port for incoming scraping of port 9545 , protocol HTTP, IP address 185.180.8.244 (Prometheus)
  * Open port for outgoing HTTP traffic to IP address 185.180.8.244 (Influx)
  * Open port for outgoing HTTP and HTTPS websockets traffic to IP address 185.180.8.152 (netstats)

Step 3: Connecting to your Alastria Container

Step 4: The upgrade procedure consists of four simple steps being positioned in ``XXXXXXXXXXXXXXXXXXXXXX/root/alastria/node-scripts``:

    ./update.sh
    ./stop.sh
    ./bootstrap.sh reinstall
    ./start.sh

Step 4: Then run *geth version* to verify that you've changed version. If it is below the required, please go to step 2

Step 5: You will find your logs now in a fixed path, namely **XXXXXXXXXXXXXXXXXXXXXXXXXXX/root/alastria/logs/quorum.log** with increased verbosity


## FUTURE ENHANCEMENTS TO THE PROCESESS

As part of the continuouos experimentation and innovation, there are several actions to do to enhance these processs.

Please **feel free to take any of these actions and propose them as Pull Request** to collaborate with us.

#### Actions to do in the Non-Docker Process:
* systemd unit with an option to restart in case geth crashes
* place a unit in /etc/logrotate.d/geth to ensure log rotation of quorum.log
* log shipping with telegraf (analyze quorum.log with grok regex patterns and ship to Prometheus)
* get rid of constellation as it is no more supported by Consensys
* build **ansible playbook** for new installations

#### Actions to do in the Docker Process:
* move to microservices architecture with automatic auto-restart in case of crashes
* explore docker-compose
* explore kubernetes version of Quorum (**qubernetes**) at https://github.com/ConsenSys/qubernetes


