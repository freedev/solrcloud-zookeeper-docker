#!/bin/bash

set -e
container_name=zookeeper

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

if [ "A$COMMON_CONFIG" == "A" ]
then
	echo "Error: common.sh not loaded"
	exit 
fi

# Need a volume to read the config from
conf_prefix=zookeeper_
conf_container=${conf_prefix}1

cluster_size=$ZOO_CLUSTER_SIZE

# Start the zookeeper containers
ZKCLIENT_PORT=2181
for ((i=1; i <= cluster_size ; i++)); do
  ZKCLIENT_PORT=$((ZKCLIENT_PORT+1))

  HOST_DATA=$COMMON_DATA_DIR"/${conf_prefix}${i}"
  if [ ! -d ${HOST_DATA} ] ; then
    mkdir -p ${HOST_DATA}/logs
    mkdir -p ${HOST_DATA}/data
  fi

  if [ ! -d ${HOST_DATA} ] ; then
    echo "Error: unable to create "$HOST_DATA
    exit
  fi

  docker run -d --name "${conf_prefix}${i}" \
        -p $ZKCLIENT_PORT:$ZKCLIENT_PORT \
	-e ZOO_ID=${i} \
	-e ZOO_LOG_DIR=/opt/persist/logs \
	-e ZOO_DATADIR=/opt/persist/data \
	-v "$HOST_DATA:/opt/persist" freedev/${container_name}
done

# initial default zoo.cfg
config="tickTime=10000
#dataDir=/var/lib/zookeeper
#clientPort=2181
initLimit=10
syncLimit=5"

zkhost=""

# Look up the zookeeper instance IPs and create the config file
for ((i=1; i <= cluster_size ; i++)); do
  container_name=${conf_prefix}${i}
  container_ip=$(docker inspect --format '{{.NetworkSettings.IPAddress}}' ${container_name})
  line="server.${i}=${container_ip}:2888:3888"
  config="${config}"$'\n'"${line}"
  if [ "A$zkhost" != "A" ]
  then
  	zkhost="${zkhost},"
  fi
  zkhost="${zkhost}${container_ip}:2181"
done

config="${config}"$'\n'"dataDir=/opt/persist/data"

echo "${config}" > $ZOO_CFG_FILE
echo "${zkhost}" > $ZKHOST_CFG_FILE

# Look up the zookeeper instance IPs and add clientPortAddress config 
ZKCLIENT_PORT=2181
for ((i=1; i <= cluster_size ; i++)); do
  ZKCLIENT_PORT=$((ZKCLIENT_PORT+1))
  container_name=${conf_prefix}${i}
  container_ip=$(docker inspect --format '{{.NetworkSettings.IPAddress}}' ${container_name})
  cat $ZOO_CFG_FILE | docker exec -i ${container_name} bash -c 'cat > /opt/zookeeper/conf/zoo.cfg' < $ZOO_CFG_FILE
  echo "clientPortAddress=$container_ip" | docker exec -i ${container_name} bash -c 'cat >> /opt/zookeeper/conf/zoo.cfg'
  echo "clientPort=$ZKCLIENT_PORT" | docker exec -i ${container_name} bash -c 'cat >> /opt/zookeeper/conf/zoo.cfg'
done

# Write the config to the config container
echo "Waiting for zookeeper startup..."
sleep 3

