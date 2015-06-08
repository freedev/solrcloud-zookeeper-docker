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

/opt/solr/bin/solr start -f -c -p $SOLR_PORT -z $ZKHOST -s $SOLR_DATA >> $SOLR_LOG_DIR/solr-console.log 2>&1
