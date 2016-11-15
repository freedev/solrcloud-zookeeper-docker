#!/bin/bash

set -x
set -e

APP="zookeeper"
ZK_CLUSTER_SIZE=3

[ -z "$SZD_HOME" ] && echo "ERROR: "\$SZD_HOME" environment variable not found!" && exit 1;

export DOCKER_BIN="sudo docker"
export DOCKER_COMPOSE_BIN="sudo docker-compose"

# check if zookeeper container images are present 

z_container_name=zookeeper
z_container_version=3.4.9

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

export ZKHOST_CFG_FILE=$SZD_DATA_DIR/zkhost.cfg

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

echo
echo -n "Waiting for ensemble startup... "
echo

NETWORK=$($DOCKER_BIN network ls | grep "${APP}_default" |  awk '{print $1}')
if [[ -z $NETWORK ]]; then
    $DOCKER_BIN network create ${APP}_default
    rc=$?
    if [[ $rc != 0 ]]
    then
            echo "unable to create network ${APP}_default"
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

echo "${zkhost}" > $ZKHOST_CFG_FILE

echo "${zkhost}" 

echo "Ensemble ready."
echo

# Start the solrcloud containers
echo

echo "Zookeeper enseble running!"
echo

