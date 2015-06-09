#!/bin/bash

set -e

if [ "A$SZD_HOME" == "A" ]
then
	echo "ERROR: "\$SZD_HOME" environment variable not found!"
	exit 1
fi

if [ "A$SZD_COMMON_DATA_DIR" == "A" ]
then
	export SZD_COMMON_DATA_DIR=$SZD_HOME/data
	if [ ! -d $SZD_HOME/data ]
	then
		mkdir $SZD_HOME/data
	fi
fi

if [ ! -d $SZD_COMMON_DATA_DIR ]
then
	echo "ERROR: "$SZD_COMMON_DATA_DIR" unable to access contaners data dir!"
	exit 1
fi

export SZD_COMMON_CONFIG_DIR=$SZD_COMMON_DATA_DIR/config

if [ ! -d $SZD_COMMON_CONFIG_DIR ]
then
	echo "INFO: "$SZD_COMMON_CONFIG_DIR" not found, creating..."
	mkdir -p $SZD_COMMON_CONFIG_DIR
fi

export ZOO_CLUSTER_SIZE=3

export SOLRCLOUD_CLUSTER_SIZE=3

export ZOO_CFG_FILE=$SZD_COMMON_CONFIG_DIR/zoo.cfg

export ZKHOST_CFG_FILE=$SZD_COMMON_CONFIG_DIR/zkhost.cfg

export SZD_COMMON_CONFIG="LOADED"

