#!/bin/bash

set -ex

mantainer_name=freedev

# docker build -t ${mantainer_name}/curl ../curl/

# docker build -t ${mantainer_name}/java8 ../java8/

# docker build -t ${mantainer_name}/zookeeper ../zookeeper/

# docker build -t ${mantainer_name}/tomcat ../tomcat/

# docker build -t ${mantainer_name}/solr-tomcat ../solr-tomcat/

docker build -t ${mantainer_name}/solrcloud4-base ../solrcloud4-base/

docker build -t ${mantainer_name}/solrcloud4 ../solrcloud4/

docker build -t ${mantainer_name}/solrcloud5-base ../solrcloud5-base/

docker build -t ${mantainer_name}/solrcloud5 ../solrcloud5/

docker build -t ${mantainer_name}/zkcli ../zkcli/

