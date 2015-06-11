docker-solrcloud-zookeeper
================

A SolrCloud cluster and Zookeeper ensemble that runs in Docker

Start a 3 node SolrCloud 5.2 and a 3 node Zookeeper 3.4.6 ensemble running:

    ./startup.sh
    
This will:

- Create 3 Zookeeper containers waiting for the configuration
- Generate the configuration (zoo.cfg and ZKHOST env)
- Start Zookeeper ensemble
- Create and start 3 SolrCloud containers linked to Zookeeper ensemble

Zookeeper ensemble and SolrCloud can be exposed externally through ZKHOST env variable

