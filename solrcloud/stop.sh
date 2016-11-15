#!/bin/bash

set -e

export DOCKER_COMPOSE_BIN="sudo docker-compose"

$DOCKER_COMPOSE_BIN -f $SZD_HOME/solrcloud/docker-compose.yml down

echo
echo
echo "SolrCloud cluster down!"
echo
echo


