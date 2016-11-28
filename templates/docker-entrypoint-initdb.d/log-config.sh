#!/bin/bash

mv /opt/solr/bin/solr.in.sh /opt/solr/bin/solr.in.sh.orig
# sed -e 's/SOLR_PORT=[0-9]\+/SOLR_PORT=${SOLR_PORT}/' </opt/solr/bin/solr.in.sh.orig >/opt/solr/bin/solr.in.sh

env | grep SOLR > /opt/solr/bin/solr.in.sh

cp /opt/solr/server/resources/log4j.properties /opt/solr/server/resources/log4j.properties.orig
cp /docker-entrypoint-initdb.d/log4j.properties /opt/solr/server/resources/

