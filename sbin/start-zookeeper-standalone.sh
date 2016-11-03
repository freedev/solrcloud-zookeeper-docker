#!/bin/bash

set -e
container_name=zookeeper
container_version=3.4.9

# Standard configuration envs taken from zookeeper docker image
#
# ZOO_INIT_LIMIT=5
# ZOO_DATA_LOG_DIR=/datalog
# ZOO_PORT=2181
# ZOO_SYNC_LIMIT=2
# ZOOCFGDIR=/conf
# ZOO_CONF_DIR=/conf
# ZOO_USER=zookeeper
# ZOO_DATA_DIR=/data
# ZOO_TICK_TIME=2000
#

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

echo
echo -n "Waiting for zookeeper container startup: ${conf_container} ... "
echo

container_id=$( $DOCKER_BIN run -d --name "${conf_container}" \
	-e ZOO_ID=1 \
	-e ZOO_DATA_LOG_DIR=/opt/persist/logs \
	-e ZOO_LOG_DIR=/opt/persist/logs \
	-e ZOO_DATADIR=/opt/persist/data \
	-e SERVER_JVMFLAGS="$ZK_JVMFLAGS" \
	-v "$HOST_DATA:/opt/persist" ${container_name}:${container_version} )

zkhost=""

# Look up the zookeeper instance IPs and create the config file
i=1
container_ip=$($DOCKER_BIN inspect --format '{{.NetworkSettings.IPAddress}}' ${conf_container})
line="server.${i}=${container_ip}:2888:3888"

# add zookeeper config settings
zkhost="${container_ip}:2181"

echo "${zkhost}" > $ZKHOST_CFG_FILE

# Write the config to the config container
echo "Done."
echo
