JVM_OPTS=" \
-XX:NewRatio=3 \
-XX:SurvivorRatio=4 \
-XX:TargetSurvivorRatio=90 \
-XX:MaxTenuringThreshold=8 \
-XX:+UseConcMarkSweepGC \
-XX:+CMSScavengeBeforeRemark \
-XX:PretenureSizeThreshold=64m \
-XX:CMSFullGCsBeforeCompaction=1 \
-XX:+UseCMSInitiatingOccupancyOnly \
-XX:CMSInitiatingOccupancyFraction=70 \
-XX:CMSTriggerPermRatio=80 \
-XX:CMSMaxAbortablePrecleanTime=6000 \
-XX:+CMSParallelRemarkEnabled
-XX:+ParallelRefProcEnabled
-XX:+UseLargePages \
-XX:+AggressiveOpts \
-Dcom.sun.management.jmxremote.port=1616 \
-Dcom.sun.management.jmxremote.ssl=false \
-Dcom.sun.management.jmxremote.authenticate=false \
"

if [ "A" == "A$SOLR_JAVA_MEM" ]
then
  SOLR_JAVA_MEM="-Xms512m -Xmx1536m"
fi

if [ "A" == "A$SOLR_DATA" ]
then
  SOLR_DATA="/store/solr"
fi

if [ "A" == "A$SOLR_LOG_DIR" ]
then
  SOLR_LOG_DIR="/opt/tomcat/logs"
fi

if [ "A" == "A$ZKHOST" ]
then
  echo "ERROR: ZKHOST env variable missing!"
  exit
fi

export CATALINA_OPTS="-Dsolr.log=$SOLR_LOG_DIR -DzkHost=$ZKHOST -Dsolr.solr.home=$SOLR_DATA -Dhost='$SOLR_HOSTNAME' $SOLR_JAVA_MEM -server $JVM_OPTS"

CLASSPATH=$CATALINA_HOME/lib/jul-to-slf4j-1.7.12.jar:\
$CATALINA_HOME/lib/slf4j-api-1.7.12.jar:\
$CATALINA_HOME/lib/logback-classic-1.1.3.jar:\
$CATALINA_HOME/lib/logback-core-1.1.3.jar:$CATALINA_HOME/lib

