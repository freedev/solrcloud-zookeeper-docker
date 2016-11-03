#!/bin/bash

set -e
container_name=solr
container_version=6.2.1

if [ "A$SZD_HOME" == "A" ]
then
        echo "ERROR: "\$SZD_HOME" environment variable not found!"
        exit 1
fi

. $SZD_HOME/sbin/common.sh

IMAGE=$($DOCKER_BIN images | grep "${container_name} " | grep "${container_version} " |  awk '{print $3}')
if [[ -z $IMAGE ]]; then
    $DOCKER_BIN pull ${container_name}:${container_version}
    rc=$?
    if [[ $rc != 0 ]]
    then
            echo "${container_name}:${container_version} image not found..."
            exit $rc
    fi
fi

if [ "A$SZD_CONFIG_DIR" == "A" ]
then
        echo "Error: common.sh not loaded"
        exit
fi

if [ ! -f $ZKHOST_CFG_FILE ]
then
        echo "Error: $ZKHOST_CFG_FILE not found. Have you started zookeeper?"
        exit
fi

#SOLR_HEAP=""
SOLR_JAVA_MEM=$SOLRCLOUD_JVMFLAGS

# Start the solrcloud containers
SOLR_PORT=8080
SOLR_INTERNAL_PORT=8983
HOST_PREFIX=${container_name}-
ZK_HOST=$(cat $ZKHOST_CFG_FILE)
HOSTS_CLUSTER='
'

for ((i=1; i <= SOLRCLOUD_CLUSTER_SIZE ; i++)); do

  SOLR_PORT=$((SOLR_PORT+1))

  SOLR_HOSTNAME=${HOST_PREFIX}${i}
  HOST_DATA_DIR=$SZD_DATA_DIR/${SOLR_HOSTNAME}

  if [ ! -d ${HOST_DATA_DIR} ] ; then
    mkdir -p ${HOST_DATA_DIR}/logs
    mkdir -p ${HOST_DATA_DIR}/store/solr
    mkdir -p ${HOST_DATA_DIR}/store/shared-lib
    cp -r $SZD_HOME/templates/solr/docker-entrypoint-initdb.d ${HOST_DATA_DIR}/
    cp $SZD_HOME/templates/solr/solr.xml ${HOST_DATA_DIR}/store/solr/solr.xml
  fi

  if [ ! -d ${HOST_DATA_DIR} ] ; then
    echo "Error: unable to create "$HOST_DATA_DIR
    exit
  fi

  if [ ! -f ${HOST_DATA_DIR}/store/solr/solr.xml ] ; then
    echo "Error: ${HOST_DATA_DIR}/store/solr/solr.xml not found "
    exit
  fi

  container_id=$(  $DOCKER_BIN run -d \
  --name "${SOLR_HOSTNAME}" \
	-v "$HOST_DATA_DIR/logs:/opt/logs" \
	-v "$HOST_DATA_DIR/store:/store" \
	-v "$HOST_DATA_DIR/docker-entrypoint-initdb.d:/docker-entrypoint-initdb.d" \
	-e SOLR_HOME=/store/solr \
	-e SOLR_LOGS_DIR=/opt/logs \
	-e ZK_HOST=${ZK_HOST} \
	-p ${SOLR_PORT}:${SOLR_INTERNAL_PORT} \
	-e SOLR_HOSTNAME="${SOLR_HOSTNAME}" \
	-e SOLR_HEAP="$SOLR_HEAP" \
	-e SOLR_JAVA_MEM="$SOLR_JAVA_MEM" \
	${container_name}:${container_version}  )

  container_ip=$($DOCKER_BIN inspect --format '{{.NetworkSettings.IPAddress}}' ${SOLR_HOSTNAME})
  line="${container_ip} ${SOLR_HOSTNAME}"
  HOSTS_CLUSTER="${HOSTS_CLUSTER}"$'\n'"${line}"$'\n'

  echo "Starting container: ${SOLR_HOSTNAME} ($container_ip) on port: ${SOLR_PORT} ..."

done

echo

echo "SolrCloud cluster running!"
echo
echo ${HOSTS_CLUSTER}

# for ((i=1; i <= SOLRCLOUD_CLUSTER_SIZE ; i++)); do
#     SOLR_HOSTNAME=${HOST_PREFIX}${i}
#     echo "${HOSTS_CLUSTER}" | $DOCKER_BIN exec -i ${SOLR_HOSTNAME} bash -c 'cat > /opt/config/hosts.cluster'
# done

echo


