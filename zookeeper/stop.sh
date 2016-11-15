#!/bin/bash

set -e

export DOCKER_COMPOSE_BIN="sudo docker-compose"

$DOCKER_COMPOSE_BIN -f $SZD_HOME/zookeeper/docker-compose.yml down

echo
echo
echo "Zookeeper cluster down!"
echo
echo


