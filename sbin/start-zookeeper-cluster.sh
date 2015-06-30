#!/bin/bash

set -e
mantainer_name=freedev
container_name=zookeeper

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
    if [ $rc != 0 ]
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
conf_prefix=zookeeper_
conf_container=${conf_prefix}1

cluster_size=$ZK_CLUSTER_SIZE

# Start the zookeeper containers
ZKCLIENT_PORT=2181
ZKCLIENT_PORT1=2888
ZKCLIENT_PORT2=3888
for ((i=1; i <= cluster_size ; i++)); do
  ZKCLIENT_PORT=$((ZKCLIENT_PORT+1))
  ZKCLIENT_PORT1=$((ZKCLIENT_PORT1+1))
  ZKCLIENT_PORT2=$((ZKCLIENT_PORT2+1))

  HOST_DATA=$SZD_DATA_DIR"/${conf_prefix}${i}"
  if [ ! -d ${HOST_DATA} ] ; then
    mkdir -p ${HOST_DATA}/logs
    mkdir -p ${HOST_DATA}/data
  fi

  if [ ! -d ${HOST_DATA} ] ; then
    echo "Error: unable to create "$HOST_DATA
    exit
  fi

  $DOCKER_BIN run -d --name "${conf_prefix}${i}" \
        -p $ZKCLIENT_PORT:$ZKCLIENT_PORT \
        -p $ZKCLIENT_PORT1:$ZKCLIENT_PORT1 \
        -p $ZKCLIENT_PORT2:$ZKCLIENT_PORT2 \
	-e ZOO_ID=${i} \
	-e ZOO_LOG_DIR=/opt/persist/logs \
	-e ZOO_DATADIR=/opt/persist/data \
	-v "$HOST_DATA:/opt/persist" ${mantainer_name}/${container_name}
done

# initial default zoo.cfg
ZKCLIENT_PORT=2181
ZKCLIENT_PORT1=2888
ZKCLIENT_PORT2=3888
config="tickTime=10000
#dataDir=/var/lib/zookeeper
#clientPort=2181
initLimit=10
syncLimit=5"

zkhost=""

# Look up the zookeeper instance IPs and create the config file
for ((i=1; i <= cluster_size ; i++)); do
  container_name=${conf_prefix}${i}
  ZKCLIENT_PORT=$((ZKCLIENT_PORT+1))
  ZKCLIENT_PORT1=$((ZKCLIENT_PORT1+1))
  ZKCLIENT_PORT2=$((ZKCLIENT_PORT2+1))
  container_ip=$($DOCKER_BIN inspect --format '{{.NetworkSettings.IPAddress}}' ${container_name})
  line="server.${i}=${container_ip}:$ZKCLIENT_PORT1:$ZKCLIENT_PORT2"
  config="${config}"$'\n'"${line}"
  if [ "A$zkhost" != "A" ]
  then
  	zkhost="${zkhost},"
  fi
  zkhost="${zkhost}${container_ip}:$ZKCLIENT_PORT"
done

config="${config}"$'\n'"dataDir=/opt/persist/data"

echo "${config}" > $ZK_CFG_FILE
echo "${zkhost}" > $ZKHOST_CFG_FILE

# Look up the zookeeper instance IPs and add clientPortAddress config 
ZKCLIENT_PORT=2181
for ((i=1; i <= cluster_size ; i++)); do
  ZKCLIENT_PORT=$((ZKCLIENT_PORT+1))
  container_name=${conf_prefix}${i}
  container_ip=$($DOCKER_BIN inspect --format '{{.NetworkSettings.IPAddress}}' ${container_name})
  cat $ZK_CFG_FILE | $DOCKER_BIN exec -i ${container_name} bash -c 'cat > /opt/zookeeper/conf/zoo.cfg' < $ZK_CFG_FILE
  echo "clientPortAddress=$container_ip" | $DOCKER_BIN exec -i ${container_name} bash -c 'cat >> /opt/zookeeper/conf/zoo.cfg'
  echo "clientPort=$ZKCLIENT_PORT" | $DOCKER_BIN exec -i ${container_name} bash -c 'cat >> /opt/zookeeper/conf/zoo.cfg'
done

# Write the config to the config container
echo "Waiting for zookeeper startup..."
sleep 3

