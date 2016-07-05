#!/bin/bash

if [ "A$ZKCLI_PARAMS" != "A" ]
then
	/opt/solr/server/scripts/cloud-scripts/zkcli.sh $ZKCLI_PARAMS
else
	echo "Error: ZKCLI_PARAMS missing"
fi
