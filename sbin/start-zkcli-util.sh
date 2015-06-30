#!/bin/bash

set -e
mantainer_name=freedev
container_name=zkcli

if [ "A$SZD_HOME" == "A" ]
then
        echo "ERROR: "\$SZD_HOME" environment variable not found!"
        exit 1
fi

. $SZD_HOME/sbin/common.sh


IMAGE=$($DOCKER_BIN images | grep "${mantainer_name}/${container_name} " |  awk '{print $3}')
if [[ -z $IMAGE ]]; then
    $DOCKER_BIN pull ${mantainer_name}/${container_name}
    rc=$?
    if [[ $rc != 0 ]]
    then
            echo "${container_name} image not found... Did you run 'build-images.sh' ?"
            exit $rc
    fi
fi

if [ ! -f $ZK_CFG_FILE ]
then
        echo "Error: $ZK_CFG_FILE not found. Have you started zookeeper?"
        exit
fi

if [ "A$1" == "A" -o "A$2" == "A" -o "A$3" == "A" ]
then
        echo "Usage: $0 [upconfig|list|downconfig] collection_name /solrcloud/collection/config/path"
        exit 1
fi

if [ "A$SZD_CONFIG_DIR" == "A" ]
then
        echo "Error: common.sh not loaded"
        exit 1
fi

if [ "$1" != "upconfig" -a "$1" != "downconfig" -a "$1" != "list"  ]
then
	echo "ERROR: $1 command not supported..."
	exit 1
fi

WORK_PATH=$(readlink -f $3)

if [ ! -d "$WORK_PATH" ]
then
	echo "ERROR: $WORK_PATH is not a directory or cannot be found..."
	exit 1
fi

zkhost=$(cat $ZKHOST_CFG_FILE)
echo "${zkhost}" 

# Write the config to the config container

$DOCKER_BIN run -d -v /opt/zookeeper/conf \
	-v $WORK_PATH:/opt/conf \
	-e ZKHOST=${zkhost} \
	-e ZKCLI_CMD=$1 \
	-e COLLECTION_PATH=/opt/conf \
	-e COLLECTION_NAME=$2 \
	${mantainer_name}/${container_name} > /tmp/$$.zkcli.tmp

ZKCLI_CONTAINER_ID=$(cat /tmp/$$.zkcli.tmp)

rm /tmp/$$.zkcli.tmp

sleep 1

ZKCLI_HOSTNAME=$($DOCKER_BIN inspect $ZKCLI_CONTAINER_ID | grep \"Hostname\" | sed 's/\"/ /g'  | awk '{ print $3 }')

echo "--- $ZKCLI_HOSTNAME"

echo "---"

echo -n "Waiting for zookeeper upload..."
while [ "A$( $DOCKER_BIN ps | grep $ZKCLI_HOSTNAME )" != "A" ] ; do echo -n "." ; sleep 1; done
echo " done."

$DOCKER_BIN logs $ZKCLI_HOSTNAME
$DOCKER_BIN rm $ZKCLI_HOSTNAME
