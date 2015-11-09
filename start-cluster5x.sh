#!/bin/bash

PWD=$(pwd)
PWD_PATH=$(readlink -f $PWD)
SCRIPT_PATH=$(readlink -f $0)
SCRIPT_NAME=$(basename $0)
SCRIPT_DIR=$(dirname $SCRIPT_PATH)

if [ "$SCRIPT_DIR" == "$PWD" ]
then
	export SZD_HOME="$SCRIPT_DIR"
	$SZD_HOME/sbin/common.sh
	$SZD_HOME/sbin/start-zookeeper-cluster.sh
	$SZD_HOME/sbin/start-solrcloud5-cluster.sh
else
	echo ""
	echo "execute:"
	echo ""
	echo "  cd "$SCRIPT_DIR
	echo "  ./"$SCRIPT_NAME
	echo ""
fi

