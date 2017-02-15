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

command -v docker >/dev/null 2>&1 || { echo -e >&2 "Error: docker it's not installed. \n\n  https://docs.docker.com/engine/installation/ \n\n "; exit 1; }
command -v docker-compose >/dev/null 2>&1 || { echo -e >&2 "Error: docker-compose it's not installed. \n\n https://docs.docker.com/compose/install/ \n\n "; exit 1; }


if [ "$SCRIPT_PATH" == "$PWD" ]
then
	export SZD_HOME="$SCRIPT_PATH"
	bash $SZD_HOME/solrcloud/start.sh
else
	echo ""
	echo "execute:"
	echo ""
	echo "  cd "$SCRIPT_PATH
	echo "  ./"$SCRIPT_NAME
	echo ""
fi

