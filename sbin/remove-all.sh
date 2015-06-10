#!/bin/bash

# set -e

if [ "A$SZD_HOME" == "A" ]
then
        echo "ERROR: "\$SZD_HOME" environment variable not found!"
        exit 1
fi

. $SZD_HOME/sbin/common.sh

if [ "A$SZD_COMMON_CONFIG" == "A" ]
then
        echo "Error: common.sh not loaded"
        exit
fi

echo ""
echo "Warning: this script will remove all stopped containers."
echo " "
select yn in "Remove_All" "Exit"; do
    case $yn in
        Remove_All ) break;;
        Exit ) exit 1;;
    esac
done

echo "..."
echo "Removing..."

docker ps -a -q | xargs -I{} docker rm {}

echo "Removing zoo.cfg..."
if [ -f $ZK_CFG_FILE ]
then
	rm $ZK_CFG_FILE
fi

if [ -f ZKHOST_CFG_FILE ]
then
	rm $ZKHOST_CFG_FILE
fi

echo Done
