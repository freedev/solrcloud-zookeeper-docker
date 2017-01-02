solrcloud-zookeeper-docker
================

This project aims to help developers and newbies that would try latest version of SolrCloud (and Zookeeper) in a Docker environment.

Here a  new version is entirely based on the newerSolr and Zookeeper official images. 

First version of this project was written when there weren't official images for Solr, Zookeeper and even Java 8. So it had its own images for every dependency. Finally there are official images for almost everything.

Prerequisite

 * Mac-OS or Linux environment
 * Docker lastest version - https://docs.docker.com/compose/install/
 * Docker-Compose latest version - https://docs.docker.com/compose/install/

If you want start a lightweight configuration with 1 SolrCloud container and 1 Zookeeper container, just run:

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
    
The script will output the list of container started, their ip addresses and ports. For example executing `start-cluster5x.sh` will output:

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


When a Zookeeper ensemble is created, every instance need to have a configuration file (zoo.cfg) where are listed (ip addresses, ports, etc.) all the ensemble instance's. 
In other words, "Every machine that is part of the ZooKeeper ensemble should know about every other machine in the ensemble". 

So, in detail, this will:

- Create 3 Zookeeper containers waiting for the ensemble configuration.
- Generate the configuration (zoo.cfg and ZKHOST environment for SolrCloud)
- Start Zookeeper ensemble with the given configuration.
- Create and start 3 SolrCloud containers linked to Zookeeper ensemble

Zookeeper ensemble and SolrCloud can be exposed externally through ZKHOST env variable

# Boot
An init.d start/stop script has been provided. Linking the script into `/etc/inid.d`:

	export SZD_HOME=/home/ubuntu/solrcloud-zookeeper-docker
    sudo ln -s $SZD_HOME/sbin/solrcloud-zookeeper-docker /etc/init.d/solrcloud-zookeeper-docker
    
Edit `solrcloud-zookeeper-docker` script and modify:

	ZK_CLUSTER_SIZE=1
	SOLRCLOUD_CLUSTER_SIZE=1
    
Under Ubuntu you can configure boot start and stop in this way:
    
    sudo update-rc.d solrcloud-zookeeper-docker defaults
    

