#!/bin/bash

if [ ! -f /store/solr/solr.xml ]
then
  cp /opt/solr/server/solr/solr.xml /store/solr/solr.xml
fi

