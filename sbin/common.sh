#!/bin/bash

set -e

[ -z "$SZD_HOME" ] && echo "ERROR: "\$SZD_HOME" environment variable not found!" && exit 1;

export DOCKER_BIN="sudo docker"

export DOCKER_COMPOSE_BIN="sudo docker-compose"

# export ZK_JVMFLAGS="-Xms512m -Xmx2048m"

# export ZKHOST_CFG_FILE=$SZD_CONFIG_DIR/zkhost.cfg

# export SOLRCLOUD_JVMFLAGS=${SOLRCLOUD_JVMFLAGS:-"-Xms512m -Xmx2048m"}

export SZD_COMMON_CONFIG="LOADED"

