#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

ps -ef | grep java | awk '{ print $2 }' | xargs kill -9
ps -ef | grep start-server.sh | awk '{ print $2 }' | xargs kill -9
