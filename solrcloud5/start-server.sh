#!/bin/bash
 
sleep 3

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

if [ ! -f $SOLR_DATA/solr.xml ]
then
	cp /opt/config/solr.xml $SOLR_DATA/solr.xml
	echo "ERROR: " $SOLR_DATA/solr.xml " missing..." 
fi

echo "SOLR_HEAP=\"$SOLR_HEAP\"" >> /opt/solr/bin/solr.in.sh

cp /etc/hosts /opt/config/hosts

echo 'Waiting for hosts file to appear...'
while [ ! -f /opt/config/hosts.cluster ] ; do
	sleep 1
done
echo 'hosts file found, starting server.'
cat /opt/config/hosts /opt/config/hosts.cluster > /etc/hosts
rm /opt/config/hosts.cluster

if [ -z ${SERVER_JVMFLAGS} ] ; then
  export SERVER_JVMFLAGS=" -Xmx1g -Dzookeeper.serverCnxnFactory=org.apache.zookeeper.server.NettyServerCnxnFactory"
fi

exec /opt/solr/bin/solr start -f -c -p $SOLR_PORT -z $ZKHOST -s $SOLR_DATA -h $SOLR_HOSTNAME -DhostPort=$SOLR_PORT >> $SOLR_LOG_DIR/solr-console.log 2>&1
