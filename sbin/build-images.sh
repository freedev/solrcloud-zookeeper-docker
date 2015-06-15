#!/bin/bash

set -ex

mantainer=freedev

# docker build -t ${mantainer}/curl ../curl/

# docker build -t ${mantainer}/java8 ../java8/

# docker build -t ${mantainer}/zookeeper ../zookeeper/

# docker build -t ${mantainer}/tomcat ../tomcat/

# docker build -t ${mantainer}/solr-tomcat ../solr-tomcat/

docker build -t ${mantainer}/solrcloud4-base ../solrcloud4-base/

docker build -t ${mantainer}/solrcloud4 ../solrcloud4/

docker build -t ${mantainer}/solrcloud5-base ../solrcloud5-base/

docker build -t ${mantainer}/solrcloud5 ../solrcloud5/

docker build -t ${mantainer}/zkcli ../zkcli/

