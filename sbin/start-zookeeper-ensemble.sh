#!/bin/bash

set -e
container_name=zookeeper
container_version=3.4.9

if [ "A$SZD_HOME" == "A" ]
then
        echo "ERROR: "\$SZD_HOME" environment variable not found!"
        exit 1
fi

. $SZD_HOME/sbin/common.sh

IMAGE=$($DOCKER_BIN images | grep "${container_name}" | grep "${container_version} " |  awk '{print $3}')
if [[ -z $IMAGE ]]; then
    $DOCKER_BIN pull ${container_name}:${container_version}
    rc=$?
    if [[ $rc != 0 ]]
    then
            echo "${container_name} image not found... Did you run 'build-images.sh' ?"
            exit $rc
    fi
fi


if [ "A$SZD_COMMON_CONFIG" == "A" ]
then
        echo "Error: common.sh not loaded"
        exit
fi

# Need a volume to read the config from
conf_prefix=solrcloudzookeeperdocker_zoo-
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
echo -n "Waiting for zookeeper startup... "
echo

$DOCKER_COMPOSE_BIN -f $SZD_HOME/zookeeper-ensemble-docker-compose.yml create
$DOCKER_COMPOSE_BIN -f $SZD_HOME/zookeeper-ensemble-docker-compose.yml start

# initial default zoo.cfg
ZKCLIENT_PORT=2181

zkhost=""

# Look up the zookeeper instance IPs
for ((i=1; i <= cluster_size ; i++)); do
  container_name=${conf_prefix}${i}_1
  container_ip=$($DOCKER_BIN inspect --format '{{.NetworkSettings.Networks.solrcloudzookeeperdocker_default.IPAddress}}' ${container_name})
  ZKCLIENT_PORT=$((ZKCLIENT_PORT+1))
  if [ "A$zkhost" != "A" ]
  then
  	zkhost="${zkhost},"
  fi
  zkhost="${zkhost}${container_ip}:$ZKCLIENT_PORT"
done

echo "${zkhost}" > $ZKHOST_CFG_FILE

echo "${zkhost}" 

echo "Ensemble ready."
echo
