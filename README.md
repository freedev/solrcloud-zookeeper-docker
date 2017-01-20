solrcloud-zookeeper-docker
================

This project aims to help developers and newbies that would try latest version of SolrCloud (and Zookeeper) in a Docker environment.

This version is entirely based on the newer Solr and Zookeeper official images. 

Hence the first version of this project was written when there wasn't docker-compose and there weren't official images for Solr, Zookeeper and even Java 8. So the project had its own images for every piece of the architecture and had to create the docker network in order to start a zookeeper ensemble. 

Finally there official images are ready for almost everything, so I have re-build this project from the ground up using docker-compose and official images.

Prerequisite

 * Mac-OS or Linux environment
 * Docker lastest version - https://docs.docker.com/engine/installation/
 * Docker-Compose latest version - https://docs.docker.com/compose/install/

If you want try a lightweight configuration with 1 SolrCloud container and 1 Zookeeper container, just run:

  	git clone https://github.com/freedev/solrcloud-zookeeper-docker.git
    cd solrcloud-zookeeper-docker
    ./start.sh

The script will output the list of container started, their ip addresses and ports. For example executing `start.sh` will output:

    [...]
    ZOO_SERVERS: localhost:2181
    Ensemble ready.

    Starting container: solr-1_1 (localhost) on port: 8081 ...

    SolrCloud cluster running!
    
Start a 3 container SolrCloud and a 3 container Zookeeper ensemble running:

    ./start-cluster.sh
    
The script will output the list of container started, their ip addresses and ports. For example executing `start-cluster.sh` will output:

    [...]
    Starting zoo-2 ... done
    Starting zoo-3 ... done
    Starting zoo-1 ... done
    Starting solr-1 ... done
    Starting solr-3 ... done
    Starting solr-2 ... done

    ZOO_SERVERS: localhost:2181,localhost:2182,localhost:2183
    Ensemble ready.

    Starting container: solr-1_1 (localhost) on port: 8081 ...
    Starting container: solr-2_1 (localhost) on port: 8082 ...
    Starting container: solr-3_1 (localhost) on port: 8083 ...

    SolrCloud cluster running!

    try connecting to http://localhost:8081/solr


Given that: "Every machine that is part of the ZooKeeper ensemble should know about every other machine in the ensemble". 

So when a cluster starts, in detail, this script will:

- enter the directory solrcloud-3-nodes-zookeeper-ensemble
- generate the zookeeper configuration as environment variable
- execute docker-compose
- Create 3 Zookeeper containers and 3 Solr containers
- Start Zookeeper ensemble with the given configuration.
- Create and start 3 SolrCloud containers linked to Zookeeper ensemble

If you want connect your clients to SolrCloud or want read by Zookeeper ensemble and SolrCloud can be exposed externally through ZKHOST env variable

# Boot
In order to help who want restart all the container automatically with Linux at every boot, an init.d start/stop script has been provided. 

You should link the script into `/etc/inid.d`:

	  export SZD_HOME=/home/ubuntu/solrcloud-zookeeper-docker
    sudo ln -s $SZD_HOME/sbin/solrcloud-zookeeper-docker /etc/init.d/solrcloud-zookeeper-docker
    
Edit `solrcloud-zookeeper-docker` script and modify:

    ZK_CLUSTER_SIZE=1
    SOLRCLOUD_CLUSTER_SIZE=1
    
Under Ubuntu you can configure boot start and stop in this way:
    
    sudo update-rc.d solrcloud-zookeeper-docker defaults
    

