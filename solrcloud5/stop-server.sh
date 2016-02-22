#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

if [ -z "$SOLR_LOG_DIR" ]
then
        SOLR_LOG_DIR=/var/log/
fi

# ps -ef | grep java | awk '{ print $2 }' | xargs kill

/opt/solr/bin/solr stop -p $SOLR_PORT -all >> $SOLR_LOG_DIR/solr-halt.log 2>&1

sleep 5

touch /opt/config/halt_solr_instance

