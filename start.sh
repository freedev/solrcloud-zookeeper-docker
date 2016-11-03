#!/bin/bash

function my_readlink() {
  case "$OSTYPE" in
    solaris*) echo "SOLARIS" ;;
    darwin*)
       echo $( cd "$1" ; pwd -P )
       ;;
    linux*)
       echo $(readlink -f $1)
        ;;
    bsd*)     echo "BSD" ;;
    *)        echo "unknown: $OSTYPE" ;;
  esac
}

PWD=$(pwd)
PWD_PATH=$(my_readlink $PWD)
SCRIPT_PATH=$(my_readlink $(dirname "$0"))
SCRIPT_NAME=$(basename "$0")
SCRIPT_DIR=$(dirname $SCRIPT_PATH)

if [ "$SCRIPT_PATH" == "$PWD" ]
then
	export SZD_HOME="$SCRIPT_PATH"
	export SOLRCLOUD_CLUSTER_SIZE=1
	bash $SZD_HOME/sbin/common.sh
	bash $SZD_HOME/sbin/start-zookeeper-standalone.sh
	bash $SZD_HOME/sbin/start-solrcloud-cluster.sh
else
	echo ""
	echo "execute:"
	echo ""
	echo "  cd "$SCRIPT_PATH
	echo "  ./"$SCRIPT_NAME
	echo ""
fi

