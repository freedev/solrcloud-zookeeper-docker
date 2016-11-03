FROM solr:5.3.1

MAINTAINER Vincenzo D'Amore <v.damore@gmail.com>

RUN mkdir -p /opt/zkcli 

ADD zkhandle-conf.sh /opt/zkcli/

RUN chmod +x /opt/zkcli/zkhandle-conf.sh

CMD ["/opt/zkcli/zkhandle-conf.sh"]

