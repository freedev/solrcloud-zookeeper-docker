#!/bin/bash

# set -x
set -e

function my_readlink() {
  case "$OSTYPE" in
    solaris*) echo "SOLARIS" ;;
    darwin*)
       echo $( cd "$1" ; pwd -P )
       ;;
    linux*)
       echo $(readlink -f $1)
        ;;
    bsd*)     echo "BSD" ;;
    *)        echo "unknown: $OSTYPE" ;;
  esac
}

PWD=$(pwd)
PWD_PATH=$(my_readlink $PWD)
SCRIPT_PATH=$(my_readlink $(dirname "$0"))
APP=$(basename $SCRIPT_PATH)


echo $APP

ZK_CLUSTER_SIZE=1
SOLRCLOUD_CLUSTER_SIZE=1

export DOCKER_BIN="sudo docker"
export DOCKER_COMPOSE_BIN="sudo docker-compose"

# check if zookeeper and solr container images are present 

s_container_name=solr
s_container_version=latest

IMAGE=$($DOCKER_BIN images | grep "${s_container_name} " | grep "${s_container_version} " |  awk '{print $3}')
if [[ -z $IMAGE ]]; then
    $DOCKER_BIN pull ${s_container_name}:${s_container_version}
    rc=$?
    if [[ $rc != 0 ]]
    then
            echo "${s_container_name}:${s_container_version} image not found..."
            exit $rc
    fi
fi

z_container_name=zookeeper
z_container_version=latest

IMAGE=$($DOCKER_BIN images | grep "${z_container_name}" | grep "${z_container_version} " |  awk '{print $3}')
if [[ -z $IMAGE ]]; then
    $DOCKER_BIN pull ${z_container_name}:${z_container_version}
    rc=$?
    if [[ $rc != 0 ]]
    then
            echo "${z_container_name} image not found... Did you run 'build-images.sh' ?"
            exit $rc
    fi
fi

# create data dir for each cluster node 

SZD_DATA_DIR=$SZD_HOME/$APP/data

# Need a volume to read the config from
conf_prefix=zoo-
conf_container=${conf_prefix}1
cluster_size=$ZK_CLUSTER_SIZE

for ((i=1; i <= cluster_size ; i++)); do

  HOST_DATA=$SZD_DATA_DIR"/${conf_prefix}${i}"
  if [ ! -d ${HOST_DATA} ] ; then
    mkdir -p ${HOST_DATA}/logs
    mkdir -p ${HOST_DATA}/data
  fi

  if [ ! -d ${HOST_DATA} ] ; then
    echo "Error: unable to create "$HOST_DATA
    exit
  fi

done

SOLR_HEAP=""
SOLR_JAVA_MEM=$SOLRCLOUD_JVMFLAGS

# Start the solrcloud containers
HOST_PREFIX=${s_container_name}-

for ((i=1; i <= SOLRCLOUD_CLUSTER_SIZE ; i++)); do

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

done

chmod -R +rw ${SZD_DATA_DIR}

echo
echo -n "Waiting for cluster and ensemble startup... "
echo

NETWORK_NAME="${APP//-}_default"

NETWORK=$($DOCKER_BIN network ls | grep "${NETWORK_NAME}" |  awk '{print $1}')
if [[ -z $NETWORK ]]; then
    $DOCKER_BIN network create ${NETWORK_NAME}
    rc=$?
    if [[ $rc != 0 ]]
    then
            echo "unable to create network ${NETWORK_NAME}"
            exit $rc
    fi
fi

$DOCKER_COMPOSE_BIN -f $SZD_HOME/$APP/docker-compose.yml create
$DOCKER_COMPOSE_BIN -f $SZD_HOME/$APP/docker-compose.yml start

echo
echo

# initial default zoo.cfg
ZKCLIENT_PORT=2181

zkhost=""
conf_prefix=$APP_zoo-

# Look up the zookeeper instance IPs
for ((i=1; i <= cluster_size ; i++)); do
  if [ "A$zkhost" != "A" ]
  then
  	zkhost="${zkhost},"
  fi
  zkhost="${zkhost}localhost:$ZKCLIENT_PORT"
  ZKCLIENT_PORT=$((ZKCLIENT_PORT+1))
done

echo "ZOO_SERVERS: ${zkhost}" 

echo "Ensemble ready."
echo

SOLR_HEAP=""
SOLR_JAVA_MEM=$SOLRCLOUD_JVMFLAGS

# Start the solrcloud containers
SOLR_PORT=8080
HOST_PREFIX=${s_container_name}-

for ((i=1; i <= SOLRCLOUD_CLUSTER_SIZE ; i++)); do

  SOLR_PORT=$((SOLR_PORT+1))
  SOLR_HOSTNAME=$APP_${HOST_PREFIX}${i}_1

  line="localhost ${SOLR_HOSTNAME}"

  echo "Starting container: ${SOLR_HOSTNAME} (localhost) on port: ${SOLR_PORT} ..."

done

echo

echo "SolrCloud cluster running!"
echo
echo ${HOSTS_CLUSTER}

echo try connecting to http://localhost:8081/solr


