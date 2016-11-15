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

found_confdir=false
found_cmd=false

for item in "${@:1}"
do
    collect_parameter=true
    if [ "$found_confdir" == "true" ]
    then
       WORK_PATH="$item"
       found_confdir=false
       item="/opt/conf"
    fi

    if [ "$found_cmd" == "true" ]
    then
       ZKCLI_CMD="$item"
       found_cmd=false
    fi

    if [ "$item" == "--cmd" ]
    then
      found_cmd=true
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

if [ "A$WORK_PATH" != "A" ]
then

case "$OSTYPE" in
  solaris*) echo "SOLARIS" ;;
  darwin*)  
     echo "OSX"
     WORK_PATH=$( cd "$WORK_PATH" ; pwd -P )
     echo $WORK_PATH
     ;;
  linux*)   
     echo "LINUX" 
     WORK_PATH=$(readlink -f $WORK_PATH)
      ;;
  bsd*)     echo "BSD" ;;
  *)        echo "unknown: $OSTYPE" ;;
esac
	WORK_PATH=$WORK_PATH

	if [ ! -d "$WORK_PATH" ]
	then
		echo "ERROR: $WORK_PATH is not a directory or cannot be found..."
		exit 1
	fi

fi

ZKCLI_CONTAINER_ID=$( $DOCKER_BIN run -d  \
	-v $WORK_PATH:/opt/conf \
	${container_name}:${container_version} /opt/solr/server/scripts/cloud-scripts/zkcli.sh $ZKCLI_PARAMS )

# Write the config to the config container

sleep 1

ZKCLI_HOSTNAME=$($DOCKER_BIN inspect $ZKCLI_CONTAINER_ID | grep \"Hostname\" | sed 's/\"/ /g'  | awk '{ print $3 }')

echo "--- $ZKCLI_HOSTNAME"

echo "---"

echo -n "Waiting for execution of cmd: $ZKCLI_CMD .."
while [ "A$( $DOCKER_BIN ps | grep $ZKCLI_HOSTNAME )" != "A" ] ; do echo -n "." ; sleep 1; done
echo " done."

$DOCKER_BIN logs $ZKCLI_HOSTNAME
$DOCKER_BIN rm $ZKCLI_HOSTNAME
