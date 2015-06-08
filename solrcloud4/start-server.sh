#!/bin/bash

if [ ! -f $SOLR_DATA/solr.xml ]
then
	cp /opt/solr-config/solr.xml $SOLR_DATA/
fi

/opt/tomcat/bin/catalina.sh run >> $SOLR_LOG_DIR/solr-tomcat-console.log 2>&1
