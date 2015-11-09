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
conf_container=zookeeper

# Start the zookeeper container

HOST_DATA="$SZD_DATA_DIR/${conf_container}"
if [ ! -d ${HOST_DATA} ] ; then
	mkdir -p ${HOST_DATA}/logs
	mkdir -p ${HOST_DATA}/data
fi

if [ ! -d ${HOST_DATA} ] ; then
  echo "Error: unable to create "$HOST_DATA
	exit
fi

# start $DOCKER_BIN instance
$DOCKER_BIN run -d --name "${conf_container}" \
	-p 2181:2181 \
	-p 2888:2888 \
	-p 3888:3888 \
	-e ZOO_ID=1 \
	-e ZOO_LOG_DIR=/opt/persist/logs \
	-e ZOO_DATADIR=/opt/persist/data \
	-e SERVER_JVMFLAGS="$ZK_JVMFLAGS" \
	-v "$HOST_DATA:/opt/persist" ${mantainer_name}/$container_name

zkhost=""

# Look up the zookeeper instance IPs and create the config file
i=1
container_ip=$($DOCKER_BIN inspect --format '{{.NetworkSettings.IPAddress}}' ${container_name})
line="server.${i}=${container_ip}:2888:3888"

# create zookeeper template config
config='tickTime=10000
#dataDir=/var/lib/zookeeper
clientPort=2181
initLimit=10
syncLimit=5
dataDir=/opt/persist/data
'

# add zookeeper config settings
config="${config}"$'\n'"${line}"
zkhost="${zkhost}${container_ip}:2181"

# create common zookeeper configuration files
echo "${config}" > $ZK_CFG_FILE
echo "${zkhost}" > $ZKHOST_CFG_FILE

# copy zoo.cfg file inside running container
cat $ZK_CFG_FILE | $DOCKER_BIN exec -i ${container_name} bash -c 'cat > /opt/zookeeper/conf/zoo.cfg' < $ZK_CFG_FILE

# Write the config to the config container
echo "Waiting for zookeeper startup... ${zkhost}"
sleep 3
echo "Done."
