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

if [ ! -f $ZK_CFG_FILE ]
then
	echo "Error: $ZK_CFG_FILE not found. Have you started zookeeper?"
        exit
fi

export container_name="solrcloud4"

$SZD_HOME/sbin/start-tomcat-cluster.sh

