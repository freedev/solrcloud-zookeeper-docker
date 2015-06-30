#!/bin/bash

$DOCKER_BIN ps -q | xargs -I{} $DOCKER_BIN exec -i {} /kill-server.sh
sleep 2
$DOCKER_BIN ps -q | xargs -I{} $DOCKER_BIN stop {} 
sleep 2
$DOCKER_BIN ps -a -q | xargs -I{} $DOCKER_BIN rm {}


