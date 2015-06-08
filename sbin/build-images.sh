#!/bin/bash

set -ex

docker build -t freedev/java ../java/

docker build -t freedev/zookeeper ../zookeeper/

docker build -t freedev/tomcat ../tomcat/

docker build -t freedev/solr-tomcat ../solr-tomcat/

docker build -t freedev/solrcloud4-base ../solrcloud4-base/

docker build -t freedev/solrcloud4 ../solrcloud4/

docker build -t freedev/solrcloud5-base ../solrcloud5-base/

docker build -t freedev/solrcloud5 ../solrcloud5/

docker build -t freedev/zkcli ../zkcli/

