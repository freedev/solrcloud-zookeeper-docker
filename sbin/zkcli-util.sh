#!/bin/bash

set -e
mantainer_name=freedev
container_name=zkcli

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

found_confdir=false

for item in "${@:1}"
do
    collect_parameter=true
    if [ "$found_confdir" == "true" ]
    then
       WORK_PATH="$item"
       found_confdir=false
       item="/opt/conf"
    fi

    if [ "$item" == "-confdir" ]
    then
      found_confdir=true
    fi

    if [ "$item" == "-d" ]
    then
      found_confdir=true
    fi

    if [ "$collect_parameter" == "true" ]
    then
       ZKCLI_PARAMS="$ZKCLI_PARAMS $item"
    fi
done

echo $ZKCLI_PARAMS

if [ "A$SZD_CONFIG_DIR" == "A" ]
then
        echo "Error: common.sh not loaded"
        exit 1
fi

if [ "A$WORK_PATH" != "A" ]
then
	WORK_PATH=$(readlink -f $WORK_PATH)

	if [ ! -d "$WORK_PATH" ]
	then
		echo "ERROR: $WORK_PATH is not a directory or cannot be found..."
		exit 1
	fi

ZKCLI_CONTAINER_ID=$( $DOCKER_BIN run -d -v /opt/zookeeper/conf \
	-v $WORK_PATH:/opt/conf \
	-e ZKCLI_PARAMS="$ZKCLI_PARAMS" \
	${mantainer_name}/${container_name} )

else

ZKCLI_CONTAINER_ID=$( $DOCKER_BIN run -d -v /opt/zookeeper/conf \
	-e ZKCLI_PARAMS="$ZKCLI_PARAMS" \
	${mantainer_name}/${container_name} )

fi

# Write the config to the config container

sleep 1

ZKCLI_HOSTNAME=$($DOCKER_BIN inspect $ZKCLI_CONTAINER_ID | grep \"Hostname\" | sed 's/\"/ /g'  | awk '{ print $3 }')

echo "--- $ZKCLI_HOSTNAME"

echo "---"

echo -n "Waiting for zookeeper: $ZKCLI_CMD"
while [ "A$( $DOCKER_BIN ps | grep $ZKCLI_HOSTNAME )" != "A" ] ; do echo -n "." ; sleep 1; done
echo " done."

$DOCKER_BIN logs $ZKCLI_HOSTNAME
$DOCKER_BIN rm $ZKCLI_HOSTNAME
