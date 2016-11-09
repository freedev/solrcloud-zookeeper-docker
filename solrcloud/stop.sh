#!/bin/bash

set -e

if [ "A$SZD_HOME" == "A" ]
then
        echo "ERROR: "\$SZD_HOME" environment variable not found!"
        exit 1
fi

. $SZD_HOME/sbin/common.sh

if [ "A$SZD_CONFIG_DIR" == "A" ]
then
        echo "Error: common.sh not loaded"
        exit
fi

$DOCKER_COMPOSE_BIN -f $SZD_HOME/solrcloud/docker-compose.yml down

echo
echo
echo "SolrCloud cluster down!"
echo
echo


