#!/bin/bash

if [ "$ZKCLI_CMD" != "list" -a "$ZKCLI_CMD" != "clear" ]
then
	/opt/solr/server/scripts/cloud-scripts/zkcli.sh -zkhost $ZKHOST -cmd $ZKCLI_CMD -confdir $COLLECTION_PATH -n $COLLECTION_NAME
else
	/opt/solr/server/scripts/cloud-scripts/zkcli.sh -zkhost $ZKHOST -cmd $ZKCLI_CMD $ZKCMDPATH
fi
