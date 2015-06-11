docker-solrcloud-zookeeper
================

A SolrCloud cluster and Zookeeper ensemble that runs in Docker

Start a 3 node SolrCloud and a 3 node Zookeeper ensemble running:

    ./startup.sh
    
This will:

- Create 3 Zookeeper containers waiting for the configuration
- Generate the configuration (zoo.cfg and ZKHOST env)
- Start Zookeeper ensemble
- Create and start 3 SolrCloud containers linked to Zookeeper ensemble

Zookeeper ensemble and SolrCloud can be exposed externally through ZKHOST env variable

