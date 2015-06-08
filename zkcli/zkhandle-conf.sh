#!/bin/bash

/opt/solr/server/scripts/cloud-scripts/zkcli.sh -zkhost $ZKHOST -cmd $ZKCLI_CMD -confdir $COLLECTION_PATH -n $COLLECTION_NAME
