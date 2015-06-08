#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

ps -ef | grep java | grep -v grep | awk '{ print $2 }' | xargs kill
