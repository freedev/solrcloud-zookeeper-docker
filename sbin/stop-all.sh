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

echo ""
echo "Warning: this script will stop and remove all containers running."
echo "If removing step doesn't start after stop, wait few seconds and try again..."
echo " "
select yn in "Stop_All" "Exit"; do
    case $yn in
        Stop_All ) break;;
        Exit ) exit 1;;
    esac
done

echo "..."
echo "Stopping..."
docker ps -q | xargs -I{} docker exec -i "{}" /stop-server.sh
echo "Done"
sleep 2
echo "..."
echo "Removing..."

docker ps -a -q | xargs -I{} docker rm {}

if [ -f $ZOO_CFG_FILE ]
then
	rm $ZOO_CFG_FILE
fi

if [ -f ZKHOST_CFG_FILE ]
then
	rm $ZKHOST_CFG_FILE
fi

echo Done
