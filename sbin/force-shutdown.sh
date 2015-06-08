#!/bin/bash

docker ps -q | xargs -I{} docker exec -i {} /kill-server.sh
sleep 2
docker ps -q | xargs -I{} docker stop {} 
sleep 2
docker ps -a -q | xargs -I{} docker rm {}


