#!/bin/bash

if [ -z ${ZOO_ID} ] ; then
  echo 'ERROR: ZOO_ID env variable missing.'
  exit -1
fi

if [ ! -f /opt/zookeeper/conf/zoo.cfg ] ; then
  echo 'Waiting for config file to appear...'
  while [ ! -f /opt/zookeeper/conf/zoo.cfg ] ; do
    sleep 1
  done
  echo 'Config file found, starting server.'
fi

if [ -z ${SERVER_JVMFLAGS} ] ; then
  # export SERVER_JVMFLAGS=" -Xmx1g -Dzookeeper.serverCnxnFactory=org.apache.zookeeper.server.NettyServerCnxnFactory"
  export SERVER_JVMFLAGS=" -Xmx1g "
fi

mkdir -p ${ZOO_LOG_DIR}
mkdir -p ${ZOO_DATADIR}

echo "${ZOO_ID}" > ${ZOO_DATADIR}/myid

exec /opt/zookeeper/bin/zkServer.sh start-foreground >> $ZOO_LOG_DIR/zk-console.log 2>&1
