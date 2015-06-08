#!/bin/bash

set -e
container_name=solrcloud5

IMAGE=$(docker images | grep "freedev/${container_name} " |  awk '{print $3}')
if [[ -z $IMAGE ]]; then
    echo "${container_name} image not found... Did you run 'build-images.sh' ?"
    exit 1
fi

if [ "A$SZD_HOME" == "A" ]
then
        echo "ERROR: "\$SZD_HOME" environment variable not found!"
        exit 1
fi

. $SZD_HOME/sbin/common.sh

if [ "A$COMMON_CONFIG_DIR" == "A" ]
then
        echo "Error: common.sh not loaded"
        exit
fi

if [ ! -f $ZOO_CFG_FILE ]
then
        echo "Error: $ZOO_CFG_FILE not found. Have you started zookeeper?"
        exit
fi

# Start the solrcloud containers
SOLR_PORT=8080
HOST_PREFIX=solrcloud5_
ZKHOST=$(cat $ZKHOST_CFG_FILE)

for ((i=1; i <= SOLRCLOUD_CLUSTER_SIZE ; i++)); do

  SOLR_PORT=$((SOLR_PORT+1))

  SOLR_HOSTNAME=${HOST_PREFIX}${i}
  HOST_DATA_DIR=$COMMON_DATA_DIR/${SOLR_HOSTNAME}

  if [ ! -d ${HOST_DATA_DIR} ] ; then
    mkdir -p ${HOST_DATA_DIR}/logs
    mkdir -p ${HOST_DATA_DIR}/store/solr
  fi

  if [ ! -d ${HOST_DATA_DIR} ] ; then
    echo "Error: unable to create "$HOST_DATA_DIR
    exit
  fi

  docker run -d \
	-v "$HOST_DATA_DIR/logs:/opt/logs" \
	-v "$HOST_DATA_DIR/store:/store" \
	-e SOLR_DATA=/store/solr \
	-e SOLR_LOG_DIR=/opt/logs \
	-e ZKHOST=${ZKHOST} \
	-e SOLR_PORT=8080 -p ${SOLR_PORT}:8080 \
	-e SOLR_HOSTNAME="${SOLR_HOSTNAME}" --name "${SOLR_HOSTNAME}" \
	-e SOLR_JAVA_MEM="-Xms512m -Xmx2048m" \
	freedev/solrcloud5
done

