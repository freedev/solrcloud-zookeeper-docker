#!/bin/bash

set -e

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
APP=$(basename $SCRIPT_PATH)

export DOCKER_COMPOSE_BIN="sudo docker-compose"

$DOCKER_COMPOSE_BIN -f $SZD_HOME/$APP/docker-compose.yml down

echo
echo
echo "SolrCloud cluster down!"
echo
echo


