FROM freedev/solrcloud5-base

MAINTAINER Vincenzo D'Amore <v.damore@gmail.com>

RUN apt-get -y update

RUN apt-get -y install unzip

RUN mkdir -p /opt/zkcli

ADD zkhandle-conf.sh /opt/zkcli/

RUN chmod +x /opt/zkcli/zkhandle-conf.sh

CMD ["/opt/zkcli/zkhandle-conf.sh"]

# echo "uploading configuration files"
# ~/solr-cloud/zkcli/zkcli.sh -zkhost $ZKHOST -cmd upconfig -confdir $CONF_HOME/git/wrapper-ng/search/configurazione/0/conf/ -n 0

