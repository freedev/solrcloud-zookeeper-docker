#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# ps -ef | grep java | awk '{ print $2 }' | xargs kill

/opt/tomcat/bin/catalina.sh stop

