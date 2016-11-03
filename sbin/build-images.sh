#!/bin/bash

mantainer_name=freedev

if [ "A$SZD_HOME" == "A" ]
then
        echo "ERROR: "\$SZD_HOME" environment variable not found!"
        exit 1
fi

. $SZD_HOME/sbin/common.sh

$DOCKER_BIN build -t ${mantainer_name}/unix-utils ../unix-utils/

$DOCKER_BIN build -t ${mantainer_name}/tomcat ../tomcat/

$DOCKER_BIN build -t ${mantainer_name}/solr-tomcat ../solr-tomcat/

$DOCKER_BIN build -t ${mantainer_name}/solrcloud4-base ../solrcloud4-base/

$DOCKER_BIN build -t ${mantainer_name}/solrcloud4 ../solrcloud4/

$DOCKER_BIN build -t ${mantainer_name}/zkcli ../zkcli/

