#!/bin/bash

# set -e

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

echo "Warning: this script will stop all running containers "
select yn in "Stop_All" "Exit"; do
    case $yn in
        Stop_All ) break;;
        Exit ) exit 1;;
    esac
done

docker ps -q | xargs -I{} docker exec -i {} /stop-server.sh
sleep 2
docker ps -a -q | xargs -I{} docker rm {}

if [ -f $ZOO_CFG_FILE ]
then
	rm $ZOO_CFG_FILE
fi

if [ -f ZKHOST_CFG_FILE ]
then
	rm $ZKHOST_CFG_FILE
fi

