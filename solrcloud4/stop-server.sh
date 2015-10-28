#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# ps -ef | grep java | awk '{ print $2 }' | xargs kill

export CATALINA_HOME=/opt/tomcat
export CATALINA_BASE=/opt/tomcat

bash /opt/tomcat/bin/catalina.sh stop

sleep 10

touch /opt/config/stop.node

