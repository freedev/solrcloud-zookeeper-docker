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
echo "Warning: this script will stop all running containers."
echo " "
select yn in "Stop_All" "Exit"; do
    case $yn in
        Stop_All ) break;;
        Exit ) exit 1;;
    esac
done

echo "..."
echo "Stopping..."
$DOCKER_BIN ps -q | xargs -I{} $DOCKER_BIN stop "{}"
echo "Done"
