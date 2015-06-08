#!/bin/bash

set -e

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

$SZD_HOME/sbin/stop-all.sh

echo "Warning: this script will remove all data from $COMMON_DATA_DIR"
select yn in "Remove_All" "Exit"; do
    case $yn in
        Remove_All ) break;;
        Exit ) exit 1;;
    esac
done

sudo rm -rf $COMMON_DATA_DIR/*

