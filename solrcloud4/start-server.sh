#!/bin/bash

if [ ! -f $SOLR_DATA/solr.xml ]
then
	cp /opt/config/solr.xml $SOLR_DATA/
fi

cp /etc/hosts /opt/config/hosts

echo 'Waiting for hosts file to appear...'
while [ ! -f /opt/config/hosts.cluster ] ; do
        sleep 1
done
echo 'hosts file found, starting server.'
cat /opt/config/hosts /opt/config/hosts.cluster > /etc/hosts
rm /opt/config/hosts.cluster

/opt/tomcat/bin/catalina.sh run >> $SOLR_LOG_DIR/solr-tomcat-console.log 2>&1
