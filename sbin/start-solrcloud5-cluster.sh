#!/bin/bash

set -e
mantainer_name=freedev
container_name=solrcloud5

#SOLR_HEAP=""
SOLR_JAVA_MEM=$SOLRCLOUD_JVMFLAGS

IMAGE=$(docker images | grep "${mantainer_name}/${container_name} " |  awk '{print $3}')
if [[ -z $IMAGE ]]; then
    docker pull ${mantainer_name}/${container_name}
    rc=$?
    if [[ $rc != 0 ]]
    then
            echo "${container_name} image not found... Did you run 'build-images.sh' ?"
            exit $rc
    fi
fi

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

# Start the solrcloud containers
SOLR_PORT=8080
HOST_PREFIX=${container_name}-
ZKHOST=$(cat $ZKHOST_CFG_FILE)
HOSTS_CLUSTER='
'

for ((i=1; i <= SOLRCLOUD_CLUSTER_SIZE ; i++)); do

  SOLR_PORT=$((SOLR_PORT+1))

  SOLR_HOSTNAME=${HOST_PREFIX}${i}
  HOST_DATA_DIR=$SZD_DATA_DIR/${SOLR_HOSTNAME}

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
	-e SOLR_PORT=${SOLR_PORT} -p ${SOLR_PORT}:${SOLR_PORT} \
	-e SOLR_HOSTNAME="${SOLR_HOSTNAME}" --name "${SOLR_HOSTNAME}" \
	-e SOLR_HEAP="$SOLR_HEAP" \
	-e SOLR_JAVA_MEM="$SOLR_JAVA_MEM" \
	${mantainer_name}/${container_name}

  container_ip=$(docker inspect --format '{{.NetworkSettings.IPAddress}}' ${SOLR_HOSTNAME})
  line="${container_ip} ${SOLR_HOSTNAME}"
  HOSTS_CLUSTER="${HOSTS_CLUSTER}"$'\n'"${line}"$'\n'

done

echo "SolrCloud cluster ready:"
echo ${HOSTS_CLUSTER}

for ((i=1; i <= SOLRCLOUD_CLUSTER_SIZE ; i++)); do
    SOLR_HOSTNAME=${HOST_PREFIX}${i}
    echo "${HOSTS_CLUSTER}" | docker exec -i ${SOLR_HOSTNAME} bash -c 'cat > /opt/config/hosts.cluster'
done

