docker-solrcloud-zookeeper
================

A 5 node solrcloud and 3 node zookeeper ensemble that runs in Docker

Start ensemble by running:

    ./startup.sh
    
This will:

- Create a config container
- Create 3 zookeeper containers that wait for a config file to appear on the config container
- Create 3 solrcloud containers
- Generate the configuration
- Push the configuration into the config container
- Start the ensemble
