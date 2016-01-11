#!/bin/bash

if [ -z "$SOLR_LOG_DIR" ]
then
        SOLR_LOG_DIR=/var/log/
fi

if [ ! -d $SOLR_DATA ]
then
        echo "ERROR: " $SOLR_DATA " missing..." 
        echo "ERROR: " $SOLR_DATA " missing..." >> $SOLR_LOG_DIR/solr.log
        exit
fi

# If solr.xml does not exist create a default one
if [ ! -f $SOLR_DATA/solr.xml ]
then
	cp /opt/config/solr.xml $SOLR_DATA/
fi

# Create lib directory for solrcloud customizations
if [ ! -d $SOLR_DATA/lib ]
then
	mkdir $SOLR_DATA/lib
fi

cp /etc/hosts /opt/config/hosts

echo 'Waiting for hosts file to appear...'
while [ ! -f /opt/config/hosts.cluster ] ; do
        sleep 1
done
echo 'hosts file found, starting server.'

cat /opt/config/hosts /opt/config/hosts.cluster > /etc/hosts
rm /opt/config/hosts.cluster

exec /opt/tomcat/bin/catalina.sh start >> $SOLR_LOG_DIR/solr-tomcat-console.log 2>&1

while [ ! -f /opt/config/stop.node ] ; do
        sleep 1
done
