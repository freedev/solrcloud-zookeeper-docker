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

if [ ! -f $SOLR_DATA/solr.xml ]
then
	cp /opt/config/solr.xml $SOLR_DATA/solr.xml
	echo "WARNING: " $SOLR_DATA/solr.xml " missing. Created a default solr.xml" 
fi

# Create lib directory for solrcloud customizations
if [ ! -d $SOLR_DATA/lib ]
then
        mkdir $SOLR_DATA/lib
fi

if [ -z "$SOLR_HEAP" ] && [ -n "$SOLR_JAVA_MEM" ]; then
  echo "SOLR_HEAP=" >> /opt/solr/bin/solr.in.sh
  echo "SOLR_JAVA_MEM=\"$SOLR_JAVA_MEM\"" >> /opt/solr/bin/solr.in.sh
else
  SOLR_HEAP="${SOLR_HEAP:-512m}"
  JAVA_MEM_OPTS=("-Xms$SOLR_HEAP" "-Xmx$SOLR_HEAP")
fi

cp /etc/hosts /opt/config/hosts

echo 'Waiting for hosts file to appear...'
while [ ! -f /opt/config/hosts.cluster ] ; do
	sleep 1
done
echo 'hosts file found, starting server.'
cat /opt/config/hosts /opt/config/hosts.cluster > /etc/hosts
rm /opt/config/hosts.cluster

exec /opt/solr/bin/solr start -f -c -p $SOLR_PORT -z $ZKHOST -s $SOLR_DATA -h $SOLR_HOSTNAME -DhostPort=$SOLR_PORT >> $SOLR_LOG_DIR/solr-console.log 2>&1
