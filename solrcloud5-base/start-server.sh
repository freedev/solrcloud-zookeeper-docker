#!/bin/bash
 
sleep 3

if [ -z "$SOLR_LOG_DIR" ]
then
	SOLR_LOG_DIR=/var/log/
fi

# /opt/solr/bin/solr start -f -c -h $SOLR_HOSTNAME -p $SOLR_PORT -z $ZKHOST -m 2g -s $SOLR_DATA 
/opt/solr/bin/solr start -f -c -p $SOLR_PORT -z $ZKHOST -m 2g -s $SOLR_DATA >> $SOLR_LOG_DIR/solr.log 2>&1
